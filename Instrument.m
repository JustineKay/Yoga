//
//  Instrument.m
//  SimpleSong
//
//  Created by Jason Snell on 6/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Instrument.h"
#import "Orchestra.h"
#import "SoundManager.h"
#import "NumberUtils.h"

#pragma mark private method headers
@interface Instrument (Private)
//private method headers

@end

@implementation Instrument

//openAL
@synthesize key;
@synthesize sourceID;
@synthesize areSourcesProtected;
@synthesize protectedSources;
//autofill
@synthesize autoFillEnabled;
@synthesize autoFillActive;
@synthesize autoFillSlots;
@synthesize autoFillMin;
//pitch
@synthesize maxPitch;
@synthesize minPitch;
@synthesize pitchInc;
@synthesize variedPitch;
@synthesize randomPitch;
//volume
@synthesize manualMaxVolume;
@synthesize manualMinVolume;
@synthesize autoMaxVolume;
@synthesize autoMinVolume;
@synthesize volumeFade;
@synthesize playMinVolume;
//arrangement
@synthesize instantPlay;
@synthesize repeatEveryHowManyMeasures;
@synthesize noteMax;
@synthesize quantization;
//@synthesize rejuvenateThreshold;
//pan
@synthesize pan;
//visual
@synthesize visualFade;
@synthesize visualOutput;
//general
@synthesize slot;

#pragma mark -
#pragma mark init

- (id) initWithKey:(NSString *)_key fileName:(NSString *)_fileName fileExt:(NSString *)_fileExt {
    if (self = [super init]) {
		
		//OPEN AL
		key = [[NSString alloc] initWithFormat:_key];
		//NSLog(@"Load: %@", key);
		[[SoundManager sharedSoundManager] loadSoundWithKey:key fileName:_fileName fileExt:_fileExt];
		sourceID = -1;
		areSourcesProtected = NO;
		protectedSources = [[NSMutableArray alloc] initWithCapacity:8];
		
		//AUTOFILL
		autoFillEnabled = YES;
		autoFillActive = NO;
		autoFillSlots = 4;
		autoFillMin = 2;
		
		//ARRANGEMENT
		noteMax = 128;
		quantization = 16;
		instantPlay = NO;
		repeatEveryHowManyMeasures = 1;
		instantRemoval = NO;
		//rejuvenateThreshold = 1;
		
		//VOLUME
		volumeFade = 0.1;
		manualMaxVolume = 0.5;
		manualMinVolume = 0.3;
		autoMaxVolume = 0.5;
		autoMinVolume = 0.3;
		playMinVolume = 0.1;
		
		//PITCH
		minPitch = 0.9;
		maxPitch = 1.1;
		pitchInc = 0.01;
		variedPitch = NO;
		randomPitch = NO;
		
		//PAN
		pan = 0.0;
		
		//VISUAL
		visualFade = 0.025;
		visualOutput = NO;
		
	}
	
    return (self);
	
} // init


- (void) dealloc {
	[key release];
	[protectedSources release];
	[super dealloc];
} //dealloc


#pragma mark -
#pragma mark autofill positions
- (void) setAutoFillPositions:(int *)positions intoColumn:(int)column{
	//loop through incoming sequence and place position values into autofill array
	// -1 marks end of array
	int notePosition; //position of note in meausre
	int arrayPosition = 0; //position in array
	do {
		notePosition = positions[arrayPosition];
		autoFillPositions[column][arrayPosition] = notePosition;
		arrayPosition++;
	} while (notePosition != -1);
} //setAutoFillPositions intoSlot

- (int) getAutoFillPosition:(int)position fromColumn:(int)column{
	return autoFillPositions[column][position];
}


#pragma mark -
#pragma mark playback
- (int) playAtVolume:(float)volume atPitch:(float)pitch {
	
	//get the source ID that this instrument is playing in
	
	int playSourceID = [self getPlaySourceID];
	
	// OVERLOAD CHECK
	// if the source ID is -1, it means the OpenAL system is maxed out...
	if (playSourceID == -1){
		
		//... so stop here and don't play the sound
		NSLog(@"BLOCKED : * OPENAL FULL ********");
		[[Orchestra sharedOrchestra] sourceOverload];
		
	} else {
		
		//otherwise it's OK to proceed and play the sound
		[[SoundManager sharedSoundManager] playSoundWithKey:key gain:volume pitch:pitch location:Vector2fMake(pan, 0.0f) shouldLoop:NO sourceID:playSourceID];

	}
	
	return playSourceID;
	
} //playAtVolume


#pragma mark -
#pragma mark sources

- (void) addProtectedSource:(int) source{
	
	BOOL okToAdd = YES;
	
	//loop through sources to make sure it doesn't already exist
	for (int i = 0; i < protectedSources.count; i++){
		
		//get protected source
		int protectedSource = [[protectedSources objectAtIndex:i] intValue];
		
		//compare it with incoming source
		if (protectedSource == source){
			
			//if there is a match, don't add to array
			okToAdd = NO;
			break;
		}
	}
	
	if (okToAdd){
		
		//convert to number and add to array
		NSNumber *sourceNum = [[NSNumber alloc] initWithInt:source];
		[protectedSources addObject:sourceNum];
		[sourceNum release];
	
		//NSLog(@"Protected sources add = %@", protectedSources);	
	}
	
	//protected sources is never above max
	if (protectedSources.count > noteMax)
		[protectedSources removeObjectAtIndex:0];
	
}

- (void) removeProtectedSource:(int) source{
	
	int removalIndex = -1;
	
	for (int i = 0; i < protectedSources.count; i++){
		int protectedSource = [[protectedSources objectAtIndex:i] intValue];
		
		if (protectedSource == source){
			removalIndex = i;
			//NSLog(@"remove %d", source);
			break;
		}
	}
	
	if (removalIndex != -1){
		[protectedSources removeObjectAtIndex:removalIndex];
		//NSLog(@"Protected sources remove = %@", protectedSources);	
	}
}

#pragma mark -
#pragma mark volume & pitch
- (float) getRandomVolumeForType:(uint)type{
	if (type == 1){
		return [NumberUtils getRandomFloatBetween:autoMaxVolume and:autoMinVolume];
	} else {
		return [NumberUtils getRandomFloatBetween:manualMaxVolume and:manualMinVolume];
	}
} //getRandomStartVolumeForType


- (float) getRandomPitch {
	if (variedPitch){
		return [NumberUtils getRandomFloatBetween:maxPitch and:minPitch withInc:pitchInc]; //return random pitch if variedPitch is set to YES
	} else {
		return 1.0;//else return the default
	}
} //getRandomPitch


- (int) getPlaySourceID {
	
	// init source id to use to play instrument in OpenAL
	int playSourceID;
	
	if (sourceID == -1) {
		
		//if the instruments source is -1, then get a random source from Sound Manager
		playSourceID = [[SoundManager sharedSoundManager] nextAvailableSource];
		
	} else {
		
		//otherwise use the fixed ID that this instrument has specified
		playSourceID = sourceID;
		
	}
	
	//NSLog(@"SOURCEID: %d : %@", playSourceID, key);
	
	return playSourceID;
}

@end

