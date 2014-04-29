//
//  MultiInstrument.m
//  Yoga
//
//  Created by Jason Snell on 9/4/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "MultiInstrument.h"
#import "SoundManager.h"

@implementation MultiInstrument

- (id) initWithKey:(NSString *)_key fileName:(NSString *)_fileName fileExt:(NSString *)_fileExt {
	[super initWithKey:_key fileName:_fileName fileExt:_fileExt];
	
	//init keys array and add first key
	keys = [[NSMutableArray alloc] initWithCapacity:10];
	[keys addObject:_key];
	currentKeyID = 0;
	
	return self;
}

- (void) dealloc {
	[keys release];
	[super dealloc];
} //dealloc

- (void) addSoundWithKey:(NSString *)_key fileName:(NSString *)_fileName fileExt:(NSString *)_fileExt{
	//NSLog(@"Load: %@", _key);
	[[SoundManager sharedSoundManager] loadSoundWithKey:_key fileName:_fileName fileExt:_fileExt];
	[keys addObject:_key];
}

- (int) playAtVolume:(float)volume atPitch:(float)pitch {
	
	//init random key
	int randomKeyID;
	
	//generate random until it's different than the last one
	do {
		randomKeyID = arc4random() % [keys count];
	} while (currentKeyID == randomKeyID);
	
	//update current
	currentKeyID = randomKeyID;
	
	//get the source ID that this instrument is playing in
	
	int playSourceID = [self getPlaySourceID];
	
	// OVERLOAD CHECK
	// if the source ID is -1, it means the OpenAL system is maxed out...
	if (playSourceID == -1){
		
		//... so stop here and don't play the sound
		NSLog(@"BLOCKED : * OPENAL FULL *");
		
	} else {
		//otherwise it's OK to proceed and play the sound
		[[SoundManager sharedSoundManager] playSoundWithKey:[keys objectAtIndex:currentKeyID] gain:volume pitch:pitch location:Vector2fMake(0, 0) shouldLoop:NO sourceID:playSourceID];
		
	}		
	
	return playSourceID;
	
} //playAtVolume


@end
