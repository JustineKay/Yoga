//
//  Tempo.h
//  SimpleSong
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//
// Contains speed of song (which is an actual BPM) and beats in a measure

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface Tempo : NSObject {
	float speed;
	float beatsPerMeasureFloat;
	uint beatsPerMeasure;
}

@property (nonatomic, assign) float speed;
@property (nonatomic, assign) uint beatsPerMeasure;

+ (Tempo *) sharedTempo;

- (float) getBeatLength;



@end
