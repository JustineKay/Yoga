//
//  Metronome.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//
// creates a loop and broadcasts a message to recipients (Position and Conductor) in a time increment set by the Tempo class

#import "Metronome.h"
#import "Position.h"
#import "Player.h"
#import "Cleaner.h"
#import "Tempo.h"
#import "EventTimer.h"


#pragma mark private interface
@interface Metronome (Private)
//private methods
- (void) nextBeat;
@end

@implementation Metronome

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Metronome);

- (id) init {
	
	//Open GL
	//create a loop with EventTimer
	//timer = [[EventTimer alloc] initWithTarget:self selector:@selector(nextBeat)];
	//timer.interval = [[Tempo sharedTempo] getBeatLength];
	
	//VS
	
	//NSTimer
	myNsTimer = [NSTimer scheduledTimerWithTimeInterval:[[Tempo sharedTempo] getBeatLength] target:self selector:@selector(nextBeat) userInfo:nil repeats:YES];

	
	active = YES;
	
	return self;
	
} //init

- (void) dealloc {
	[myOpenGLTimer release];
	[super dealloc];
} //dealloc


//Open GL update
- (void)update:(float)aDelta {
	/*
	if (active)
		[timer update:aDelta];
	 */
	
}

- (void) nextBeat {
	[[Position sharedPosition] update];
	[[Player sharedPlayer] play];
	[[Cleaner sharedCleaner] clean];

} //update


@end
