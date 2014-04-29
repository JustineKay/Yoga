//
//  SoundManager.h
//  OGLGame
//
//  Created by Michael Daley on 22/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "Common.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

// SoundManager provides a basic wrapper for OpenAL and AVAudioPlayer.  It is a singleton
// class that allows sound clips to be loaded and cached with a key and then played back
// using that key.  It also allows for music tracks to be played, stopped and paused
//
// This sound engine class has been created based on the OpenAL tutorial at
// http://benbritten.com/blog/2008/11/06/openal-sound-on-the-iphone/
//
@interface SoundManager : NSObject {

 @private
	ALCcontext *context;
	ALCdevice *device;
	NSMutableArray *soundSources;
	NSMutableDictionary *soundLibrary;
	NSMutableDictionary *musicLibrary;
	AVAudioPlayer *musicPlayer;
	ALfloat musicVolume;
	Vector2f listenerPosition;
	GLfloat FXVolume;
    ALenum err;
	uint currSourceID;
}

// Returns as instance of the SoundManager class.  If an instance has already been created
// then this instance is returned, otherwise a new instance is created and returned.
+ (SoundManager *)sharedSoundManager;

// Designated initializer.
- (id)init;

// Plays the sound which is found with |aSoundKey| using the provided |aGain| and |aPitch|.
// |aLocation| is used to set the location of the sound source in relation to the listener
// and |aLoop| specifies if the sound should be continuously looped or not.
- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch 
                       location:(Vector2f)aLocation shouldLoop:(BOOL)aLoop sourceID:(NSUInteger)aSourceID;

// Loads a sound with the supplied key, filename, file extension and frequency.  Frequency
// could be worked out from the file but this implementation takes it as an argument. If no
// sound is found with a matching key then nothing happens.
- (void)loadSoundWithKey:(NSString*)aSoundKey fileName:(NSString*)aFileName fileExt:(NSString*)aFileExt;

// Removes the sound with the supplied key from the sound library.  This deletes the buffer that was created
// to hold the sound
- (void)removeSoundWithKey:(NSString*)aSoundKey;

// Plays the music with the supplied key.  If no music is found then nothing happens.
// |aRepeatCount| specifies the number of times the music should loop.
- (void)playMusicWithKey:(NSString*)aMusicKey timesToRepeat:(NSUInteger)aRepeatCount;


// Loads the path of a music files into a dictionary with the a key of |aMusicKey|
- (void)loadBackgroundMusicWithKey:(NSString*)aMusicKey fileName:(NSString*)aFileName 
                           fileExt:(NSString*)aFileExt;

// Removes the path to the music file with the matching key from the music library array.
- (void)removeBackgroundMusicWithKey:(NSString*)aMusicKey;

// Stops any currently playing music.
- (void)stopMusic;

// Pauses any currently playing music.
- (void)pauseMusic;

// Shutsdown the SoundManager class and deallocates resources which have been assigned.
- (void)shutdownSoundManager;

// Used to get the next available OpenAL source.  The returned source is then bound to a sound
// buffer so that the sound can be played.  This method checks each of the available OpenAL 
// soucres which have been generated and returns the first source which is not currently being
// used.  If no sources are found to be free then the first looping source is returned.  If there
// are no looping sources then the first source created is returned
- (NSUInteger)nextAvailableSource;

- (void)resetSourcesExcept:(NSMutableArray *)protectedSources;

#pragma mark -
#pragma mark SoundManager settings

// Set the volume for music which is played.
- (void)setMusicVolume:(ALfloat)aVolume;

// Sets the location of the OpenAL listener.
- (void)setListenerPosition:(Vector2f)aPosition;

// Sets the orientation of the listener.  This is used to make sure that sound
// is played correctly based on the direction the player is moving in
- (void)setOrientation:(Vector2f)aPosition;

// Sets the volume for all sounds which are played.  This acts as a global FX volume for
// all sounds.
- (void)setFXVolume:(ALfloat)aVolume;

@end
