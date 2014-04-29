//
//  Tempo.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//
// Contains bpm (beats per minute), notesPerMeasure (usually 16 or 32), and noteLength (calculated with bpm and notesPerMeasure)

#import "Tempo.h"

@implementation Tempo

@synthesize speed;
@synthesize beatsPerMeasure;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Tempo);

- (id)init {
	
	//get current speed from user settings here
	speed = 60;//this is actually a true BPM (beats per minute), which technically is not the same as beats are being used in this app
	
	beatsPerMeasure = 16;
	beatsPerMeasureFloat = beatsPerMeasure;
	//8  = 1.875
	//16 = 0.9375
	
	return self;

}//init

- (void) dealloc {
	[super dealloc];
} //dealloc


- (float) getBeatLength {

	return (0.9375 * beatsPerMeasureFloat) / speed;
	
} //getBeatLength


@end
