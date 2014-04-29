//
//  Player.m
//  Yoga
//
//  Created by Jason Snell on 9/3/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Player.h"
#import "Position.h"
#import "Conductor.h"
#import "Song.h"
#import "Counter.h"

@implementation Player

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Player);

- (void) play{
	//tell song to play notes at curr position
	[[[Conductor sharedConductor] currSong] playAtMeasure:[[Position sharedPosition] currMeasure] atBeat:[[Position sharedPosition] currBeat]];
		
}

- (void) dealloc {
	[super dealloc];
} //dealloc

@end
