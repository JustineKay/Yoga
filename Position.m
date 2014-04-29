//
//  Position.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Position.h"
#import "Phrase.h"
#import "Tempo.h";


@implementation Position

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Position);

@synthesize currBeat;
@synthesize currMeasure;

- (id) init {
	currBeat = 0;
	currMeasure = 0;
	return self;
}

- (void) dealloc {
	[super dealloc];
} //dealloc

- (void) update {
	
	currBeat = currBeat+1;
	
	//if beat goes above beats per measure
	if (currBeat >= [[Tempo sharedTempo] beatsPerMeasure]){
		currBeat = 0;//reset back to first beat
		
		currMeasure = currMeasure+1;//move to next measure
		
		//if measure goes above phrase length
		if (currMeasure >= [[Phrase sharedPhrase] length]){
			currMeasure = 0;//reset back to first measure
		}
		
	}
	
	// have conductor refresh instruments every time a new phrase comes (0,0)
	if (currMeasure == 0 && currBeat == 0)
		NSLog(@"////////: NEW PHRASE");
	
	//NSLog(@"curr pos = %d, %d", currMeasure, currBeat);
	
} //refresh

@end