//
//  LoopingInstrument.m
//  Yoga
//
//  Created by Jason Snell on 9/8/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "BackgroundLoop.h"
#import "SoundManager.h"
#import "NumberUtils.h"


@implementation BackgroundLoop

@synthesize sourceID;
//pitch
@synthesize maxPitch;
@synthesize minPitch;
@synthesize pitchInc;
@synthesize variedPitch;

#pragma mark -
#pragma mark init
- (id) initWithKey:(NSString *)_key fileName:(NSString *)_fileName fileExt:(NSString *)_fileExt {
    if (self = [super init]) {
		key = [[NSString alloc] initWithFormat:_key];
		//NSLog(@"Load: %@", key);
		[[SoundManager sharedSoundManager] loadSoundWithKey:key fileName:_fileName fileExt:_fileExt];
		sourceID = -1;
	}
	
    return (self);
	
} // init

- (void) dealloc {
	[key release];
	[super dealloc];
} //dealloc

#pragma mark -
#pragma mark loading
- (void) load{
	}

#pragma mark -
#pragma mark play
- (void) playAtVolume:(float)volume atPitch:(float)pitch {
	
	[[SoundManager sharedSoundManager] playSoundWithKey:key gain:volume pitch:pitch location:Vector2fMake(0, 0) shouldLoop:YES sourceID:sourceID];

} //playAtVolume

- (float) getRandomPitch {
	if (variedPitch){
		return [NumberUtils getRandomFloatBetween:maxPitch and:minPitch withInc:pitchInc]; //return random pitch if variedPitch is set to YES
	} else {
		return 1.0;//else return the default
	}
} //getRandomPitch

@end
