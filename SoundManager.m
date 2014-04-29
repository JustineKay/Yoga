//
//  SoundManager.m
//  OGLGame
//
//  Created by Michael Daley on 22/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//
// load: [sharedSoundManager loadSoundWithKey:@"closeDoor" fileName:@"close_door" fileExt:@"wav"];
// play: [sharedSoundManager playSoundWithKey:@"closeDoor" gain:1.0f pitch:1.0f location:Vector2fMake(position.x, position.y) shouldLoop:NO sourceID:-1];

#import "SoundManager.h"
#import "SynthesizeSingleton.h"
#import "MyOpenALSupport.h"

#pragma mark -
#pragma mark Private interface

@interface SoundManager (Private)

// This method is used to initialize OpenAL.  It gets the default device, creates a new context 
// to be used and then preloads the define # sources.  This preloading means we wil be able to play up to
// (max 32) different sounds at the same time
- (BOOL)initOpenAL;

// Used to set the current state of OpenAL.  Then the game is interrupted the OpenAL state is
// stopped and then restarted when the game becomes active again.
- (void)setActivated:(BOOL)aState;

@end


#pragma mark -
#pragma mark Public implementation

@implementation SoundManager

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(SoundManager);

#pragma mark -
#pragma mark Interruption listener

// Method which handles an interruption message from the audio session.  It reacts to the
// type of interruption state i.e. beginInterruption or endInterruption
void interruptionListener(	void *inClientData, UInt32 inInterruptionState) {
    
	SoundManager *soundManager = [SoundManager sharedSoundManager];
    
    if (inInterruptionState == kAudioSessionBeginInterruption) {
        [soundManager setActivated:NO];
	} else if (inInterruptionState == kAudioSessionEndInterruption) {
		OSStatus result = AudioSessionSetActive(true);
		if (result) printf("Error setting audio session active! %d\n", result);
        [soundManager setActivated:YES];
	}
}

#pragma mark -
#pragma mark Dealloc and Init and Shutdown

- (void)dealloc {
	// Loop through the OpenAL sources and delete them
	for(NSNumber *sourceIDVal in soundSources) {
		NSUInteger sourceID = [sourceIDVal unsignedIntValue];
		alDeleteSources(1, &sourceID);
	}
	
	// Loop through the OpenAL buffers and delete 
	NSEnumerator *enumerator = [soundLibrary keyEnumerator];
	id key;
	while ((key = [enumerator nextObject])) {
		NSNumber *bufferIDVal = [soundLibrary objectForKey:key];
		NSUInteger bufferID = [bufferIDVal unsignedIntValue];
		alDeleteBuffers(1, &bufferID);		
	}
    
	// Release the arrays and dictionaries we have been using
	[soundLibrary release];
	[soundSources release];
	[musicLibrary release];
	
	// If background music has been played then release the AVAudioPlayer
	if(musicPlayer)
		[musicPlayer release];
	
	// Disable and then destroy the context
	alcMakeContextCurrent(NULL);
	alcDestroyContext(context);
	
	// Close the device
	alcCloseDevice(device);
	
	[super dealloc];
}


- (id)init {
    self = [super init];
	if(self != nil) {

		// Register to be notified of both the UIapplicationWillResignActive and UIApplicationDidBecomeActive.
		// Set up notifications that will let us know if the application resigns being active or becomes active
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) 
                                                     name:@"UIApplicationWillResignActiveNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) 
                                                     name:@"UIApplicationDidBecomeActiveNotification" object:nil];
		 
        // Initialize the array and dictionaries we are going to use
		soundSources = [[NSMutableArray alloc] init];
		soundLibrary = [[NSMutableDictionary alloc] init];
		musicLibrary = [[NSMutableDictionary alloc] init];
		
		// Initialize the audio session and set its audio category to ambient sound.
		OSStatus result = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
		if (result) {
            NSLog(@"ERROR - SoundManager: Error initializing audio session! %d\n", result);
        } else {
			
			UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
			
			result = AudioSessionSetProperty (
									 kAudioSessionProperty_AudioCategory,                      
									 sizeof (sessionCategory),                                  
									 &sessionCategory                                        
									 );
			
			if (result) {
                NSLog(@"ERROR - SoundManager: Error setting audio session category! %d\n", result);
			} else {
				result = AudioSessionSetActive(true);
				if (result) {
                    NSLog(@"ERROR - SoundManager: Error setting audio session active! %d\n", result);
                }
			}
		}
		
        // Set up the OpenAL.  If an error occurs then nil will be returned.
		BOOL success = [self initOpenAL];
		if(!success) {
            NSLog(@"ERROR - SoundManager: Error initializing OpenAL");
            [self release];
            return nil;
        }
		
		// Set up the listener position
		ALfloat listener_pos[] = {0, 0, 0};
		ALfloat listener_ori[] = {0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
		ALfloat listener_vel[] = {0, 0, 0};
		
		alListenerfv(AL_POSITION, listener_pos);
		alListenerfv(AL_ORIENTATION, listener_ori);
		alListenerfv(AL_VELOCITY, listener_vel);
        
		[self setListenerPosition: Vector2fMake(0.0f, 0.0f)];
		
        // Set the default volume for music and sound FX
		musicVolume = 1.0f;
		FXVolume = 1.0f;
		
		currSourceID = 0;

	}
    return self;
}


- (void)shutdownSoundManager {
	@synchronized(self) {
		if(sharedSoundManager != nil) {
			[self dealloc];
		}
	}
}

#pragma mark -
#pragma mark Sound management

- (void)loadSoundWithKey:(NSString*)aSoundKey fileName:(NSString*)aFileName fileExt:(NSString*)aFileExt {

    // Check to make sure that a sound with the same key does not already exist
    NSNumber *numVal = [soundLibrary objectForKey:aSoundKey];
	
    // If the key is not found log it and finish
    if(numVal != nil) {
        NSLog(@"WARNING - SoundManager: Sound key '%@' already exists.", aSoundKey);
        return;
    }
    
    NSUInteger bufferID;
	
	// Generate a buffer within OpenAL for this sound
	alGenBuffers(1, &bufferID);
    
    // Set up the variables which are going to be used to hold the format
    // size and frequency of the sound file we are loading
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	ALvoid *data;
    
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Get the audio data from the file which has been passed in
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:aFileName ofType:aFileExt]] retain];
	
	if (fileURL)
	{	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CFRelease(fileURL);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"ERROR - SoundManager: Error loading sound: %x\n", error);
			exit(1);
		}
		
		// Use the static buffer data API
		alBufferDataStaticProc(bufferID, format, data, size, freq);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"ERROR - SoundManager: Error attaching audio to buffer: %x\n", error);
		}		
	}
	else
	{
		NSLog(@"ERROR - SoundManager: Could not find file '%@.%@'", aFileName, aFileExt);
		data = NULL;
	}
	
	// Place the buffer ID into the sound library against |aSoundKey|
	[soundLibrary setObject:[NSNumber numberWithUnsignedInt:bufferID] forKey:aSoundKey];
    if(DEBUG) NSLog(@"INFO - SoundManager: Loaded sound with key '%@' into buffer '%d'", aSoundKey, bufferID);
}

- (void)removeSoundWithKey:(NSString*)aSoundKey {
 
    // Find the buffer which has been linked to the sound key provided
    NSNumber *numVal = [soundLibrary objectForKey:aSoundKey];
    
    // If the key is not found log it and finish
    if(numVal == nil) {
        NSLog(@"WARNING - SoundManager: No sound with key '%@' was found so cannot be removed", aSoundKey);
        return;
    }
    
    // Get the buffer number form the sound library so that the sound buffer can be released
    NSUInteger bufferID = [numVal unsignedIntValue];
    glDeleteBuffers(1, &bufferID);
    [soundLibrary removeObjectForKey:aSoundKey];
    if(DEBUG) NSLog(@"INFO - SoundManager: Removed sound with key '%@'", aSoundKey);
}


- (void)loadBackgroundMusicWithKey:(NSString*)aMusicKey fileName:(NSString*)aFileName fileExt:(NSString*)aFileExt {
    // Check to make sure that a sound with the same key does not already exist
    NSString *path = [musicLibrary objectForKey:aMusicKey];
    
    // If the key is not found log it and finish
    if(path != nil) {
        NSLog(@"WARNING - SoundManager: Music key '%@' already exists.", aMusicKey);
        return;
    }
    
	path = [[NSBundle mainBundle] pathForResource:aFileName ofType:aFileExt];
	[musicLibrary setObject:path forKey:aMusicKey];
    if(DEBUG) NSLog(@"INFO - SoundManager: Loaded background music with key '%@'", aMusicKey);
}

- (void)removeBackgroundMusicWithKey:(NSString*)aMusicKey {
    NSString *path = [musicLibrary objectForKey:aMusicKey];
    if(path == NULL) {
        NSLog(@"WARNING - SoundManager: No music found with key '%@' was found so cannot be removed", aMusicKey);
        return;
    }
    [musicLibrary removeObjectForKey:aMusicKey];
    if(DEBUG) NSLog(@"INFO - SoundManager: Removed music with key '%@'", aMusicKey);
}

#pragma mark -
#pragma mark Source Management
- (NSUInteger)nextAvailableSource {
	
	// Holder for the current state of the current source
	NSInteger sourceState;
	
	// Find a source which is not being used at the moment
	for (NSNumber *sourceNumber in soundSources) {
		
		alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
		
		// If this source is not playing, and isn't the same as the last source 
		// (to prevent lock-loops) then return it
		
		if(sourceState != AL_PLAYING && [sourceNumber unsignedIntValue] != currSourceID) {
			currSourceID = [sourceNumber unsignedIntValue];
			return currSourceID;
		}
	}
	
	//else return -1 so instrument can handle error
	
	return -1;
	
}


- (void)resetSourcesExcept:(NSMutableArray *)protectedSources {
	
	int numberOfProtectedSources = 0;
	
	for(NSNumber *sourceNumber in soundSources) {
		NSUInteger sourceID = [sourceNumber unsignedIntValue];
		
		BOOL okToStop = YES;
		
		
		for (int i = 0; i < protectedSources.count; i++){
			NSUInteger protectedSourceID = [[protectedSources objectAtIndex:i] unsignedIntValue];
			if (protectedSourceID == sourceID){
				okToStop = NO;
				numberOfProtectedSources++;
				break;
			}
		}
		
		if (okToStop)
			alSourceStop(sourceID);			
	}
	
	NSLog(@"PROTECT : %d sources", numberOfProtectedSources);
	
}


#pragma mark -
#pragma mark Sound control

- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch location:(Vector2f)aLocation shouldLoop:(BOOL)aLoop sourceID:(NSUInteger)aSourceID {
	
	err = alGetError(); // clear the error code
	
	// Find the buffer linked to the key which has been passed in
	NSNumber *numVal = [soundLibrary objectForKey:aSoundKey];
	if(numVal == nil) return 0;
	NSUInteger bufferID = [numVal unsignedIntValue];
	
	// Find an available source if -1 has been passed in as the sourceID.  If the sourceID is
    // not -1 i.e. a source ID has been passed in then check to make sure that source is not playing
    // and if not play the identified buffer ID within the provided source
    NSUInteger sourceID;
    if(aSourceID == -1) {
        sourceID = [self nextAvailableSource];
    } else {
        NSInteger sourceState;
        alGetSourcei(aSourceID, AL_SOURCE_STATE, &sourceState);
        if(sourceState == AL_PLAYING)
            return 0;
        sourceID = aSourceID;
    }
	
	// Make sure that the source is clean by resetting the buffer assigned to the source
	// to 0
	alSourcei(sourceID, AL_BUFFER, 0);
    
	// Attach the buffer we have looked up to the source we have just found
	alSourcei(sourceID, AL_BUFFER, bufferID);
	
	// Set the pitch and gain of the source
	alSourcef(sourceID, AL_PITCH, aPitch);
	alSourcef(sourceID, AL_GAIN, aGain * FXVolume);
	
	// Set the looping value
	if(aLoop) {
		alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	} else {
		alSourcei(sourceID, AL_LOOPING, AL_FALSE);
	}

	// Set the source location
	alSource3f(sourceID, AL_POSITION, aLocation.x, aLocation.y, 0.0f);
	
	// Now play the sound
	alSourcePlay(sourceID);
    err = alGetError();

    // Check to see if there were any errors
	err = alGetError();
	if(err != 0) {
		if(DEBUG) NSLog(@"ERROR - SoundManager: %d", err);
		return 0;
	}
    
	// Return the source ID so that loops can be stopped etc
	return sourceID;
}


- (void)stopSoundWithKey:(NSString*)theSoundKey {
	// TODO: complete this method
}


- (void)playMusicWithKey:(NSString*)aMusicKey timesToRepeat:(NSUInteger)aRepeatCount {
	
	NSError *error;
	
	NSString *path = [musicLibrary objectForKey:aMusicKey];
	
	if(!path) {
		if(DEBUG) NSLog(@"ERROR - SoundManager: The music key '%@' could not be found", aMusicKey);
		return;
	}
	
	if(musicPlayer)
		[musicPlayer release];
	
	// Initialize the AVAudioPlayer
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	
	// If the backgroundMusicPlayer object is nil then there was an error
	if(!musicPlayer) {
		if(DEBUG) NSLog(@"ERROR - SoundManager: Could not play music for key '%d'", error);
		return;
	}		
	
	// Set the number of times this music should repeat.  -1 means never stop until its asked to stop
	[musicPlayer setNumberOfLoops:aRepeatCount];
	
	// Set the volume of the music
	[musicPlayer setVolume:musicVolume];
	
	// Play the music
	[musicPlayer play];
}


- (void)stopMusic {
	[musicPlayer stop];
}


- (void)pauseMusic {
	if(musicPlayer)
		[musicPlayer pause];
}

#pragma mark -
#pragma mark SoundManager settings

- (void)setMusicVolume:(ALfloat)aVolume {

	// Set the volume iVar
	musicVolume = aVolume;

	// Check to make sure that the audio player exists and if so set its volume
	if(musicPlayer) {
		[musicPlayer setVolume:musicVolume];
	
	}
}


- (void)setFXVolume:(ALfloat)aVolume {
	FXVolume = aVolume;
}


- (void)setListenerPosition:(Vector2f)aPosition {
	listenerPosition = aPosition;
	alListener3f(AL_POSITION, aPosition.x, aPosition.y, 0.0f);
}


- (void)setOrientation:(Vector2f)aPosition {
    ALfloat orientation[] = {aPosition.x, aPosition.y, 0.0f, 0.0f, 0.0f, 1.0f};
    alListenerfv(AL_ORIENTATION, orientation);
}



@end


#pragma mark -
#pragma mark Private implementation

@implementation SoundManager (Private)

// Define the number of sources which will be created.  iPhone can have a max of 32
#define MAX_OPENAL_SOURCES 32

- (BOOL)initOpenAL {
    if (DEBUG) NSLog(@"INFO - Sound Manager: Initializing sound manager");
	
    // Get the device we are going to use for sound.  Using NULL gets the default device
	device = alcOpenDevice(NULL);
	
	// If a device has been found we then need to create a context, make it current and then
	// preload the OpenAL Sources
	if(device) {
		// Use the device we have now got to create a context in which to play our sounds
		context = alcCreateContext(device, NULL);
        
		// Make the context we have just created into the active context
		alcMakeContextCurrent(context);
        
        // Set the distance model to be used
        alDistanceModel(AL_LINEAR_DISTANCE_CLAMPED);
        
		// Pre-create 32 sound sources which can be dynamically allocated to buffers (sounds)
		NSUInteger sourceID;
		for(int index = 0; index < MAX_OPENAL_SOURCES; index++) {
			// Generate an OpenAL source
			alGenSources(1, &sourceID);
            
            // Configure the generated source so that sounds fade as the player moves
            // away from them
            alSourcef(sourceID, AL_REFERENCE_DISTANCE, 50.0F);
            alSourcef(sourceID, AL_MAX_DISTANCE, 250.0f);
            alSourcef(sourceID, AL_ROLLOFF_FACTOR, 25.0f);
            
            if (DEBUG) NSLog(@"INFO - Sound Manager: Generated source id '%d'", sourceID);
            
			// Add the generated sourceID to our array of sound sources
			[soundSources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
		}
        
        if (DEBUG) NSLog(@"INFO - Sound Manager: Finished initializing the sound manager");
		// Return YES as we have successfully initialized OpenAL
		return YES;
	}

	// We were unable to obtain a device for playing sound so tell the user and return NO.
    if(DEBUG) NSLog(@"ERROR - SoundManager: Unable to allocate a device for sound.");
	return NO;
}



#pragma mark -
#pragma mark Interruption handling


- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self setActivated:NO];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self setActivated:YES];
}


- (void)setActivated:(BOOL)aState {
    
    OSStatus result;
    
    if(aState) {
        if(DEBUG) NSLog(@"INFO - SoundManager: OpenAL Active");
        
		
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		
		result = AudioSessionSetProperty (
								 kAudioSessionProperty_AudioCategory,                      
								 sizeof (sessionCategory),                                  
								 &sessionCategory                                        
								 );
       
        if(result) {
            if(DEBUG) NSLog(@"ERROR - SoundManager: Unable to set the audio session category");
            return;
        }
        
        // Set the audio session state to true and report any errors
        result = AudioSessionSetActive(true);
		if (result) {
            if(DEBUG) NSLog(@"ERROR - SoundManager: Unable to set the audio session state to YES with error %d.", result);
            return;
        }
        
        // As we are finishing the interruption we need to bind back to our context.
        alcMakeContextCurrent(context);
    } else {
        if(DEBUG) NSLog(@"INFO - SoundManager: OpenAL Inactive");
        
		
        // As we are being interrupted we set the current context to NULL.  If this sound manager is to be
        // compaitble with firmware prior to 3.0 then the context would need to also be destroyed and
        // then re-created when the interruption ended.

		// Comment out if using media playback and you want the music to keep playing past screen lock / sleep mode
		// Update: screen lock impairs performance significantly, so let app stop sound so users learn not to press sleep button
		alcMakeContextCurrent(NULL);
    }
}

@end

