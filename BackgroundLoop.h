//
//  LoopingInstrument.h
//  Yoga
//
//  Created by Jason Snell on 9/8/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instrument.h"


@interface BackgroundLoop : NSObject {
	NSString *key; //id for OpenAL
	int sourceID;
	
	//PITCH
	float minPitch; //randomly generated pitches fall between these maximums and minimums
	float maxPitch;
	float pitchInc; //increment between randomly generated pitches
	BOOL variedPitch; //does the sound accept randomized pitches?
}

@property (nonatomic, assign) int sourceID;

@property (nonatomic, assign) float maxPitch;
@property (nonatomic, assign) float minPitch;
@property (nonatomic, assign) float pitchInc;
@property (readwrite) BOOL variedPitch;

- (void) load;
- (void) playAtVolume:(float)volume atPitch:(float)pitch;
- (float) getRandomPitch;

@end
