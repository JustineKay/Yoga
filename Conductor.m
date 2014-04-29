//
//  Conductor.m
//  SimpleSong
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Conductor.h"
#import "Song.h"
#import "Phrase.h"
#import "Orchestra.h"
#import "Instrument.h"
#import "AutoFiller.h"
#import "Counter.h"

@implementation Conductor

@synthesize currSong;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Conductor);

- (id) init {
	//init song 
	currSong = [[Song alloc] initWithCapacity:[[Phrase sharedPhrase] length]];
	
	o = [Orchestra sharedOrchestra];
	af = [AutoFiller sharedAutoFiller];
	
	//intro gamelan
	[[o gamelan] playAtVolume:1.0f atPitch:1.0f];
	
	//bg loop
	[[o synth] playAtVolume:0.0125f atPitch:[[o synth] getRandomPitch]];
	
	//permanent shaker lines
	[af addInstrument:[o shaker] withPoint:CGPointMake(-1.0,-1.0)];
	[af addInstrument:[o shakerRoll] withPoint:CGPointMake(-1.0,-1.0)];
	
	return self;
} //init

- (void) dealloc {
	[currSong release];
	[super dealloc];
} //dealloc


@end
