//
//  Repeater.m
//  MusicMakerDev
//
//  Created by Jason Snell on 6/16/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Repeater.h"
#import "Note.h"
#import "Instrument.h"
#import "Position.h"
#import "Phrase.h"
#import "Conductor.h"
#import "Song.h"
#import "Counter.h"

@implementation Repeater

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Repeater);

- (void) dealloc {
	[super dealloc];
} //dealloc


#pragma mark add
- (void) addNote:(Note *)originalNote{
	Instrument *instrument = originalNote.instrument;
	uint repeat = instrument.repeatEveryHowManyMeasures;
	uint phraseLength = [[Phrase sharedPhrase] length];
	
	//if repeat equals the phrase length, don't add any notes because its just one note per phrase
	if (repeat == phraseLength){
		//no repeats necessary
		return;
	
	//else add notes
	} else {
		
		uint noteTotal = phraseLength / repeat;
		uint nextMeasure = [[Position sharedPosition] currMeasure];
		
		for (int i = 1; i < noteTotal; i++){
			
			//OVERLOAD
			if ([[Counter sharedCounter] getTotalOfInstrument:instrument ofType:0] > instrument.noteMax){
				NSLog(@"BLOCKED : REPEATER NOTEMAX %@", instrument.key);
				return;
				break;
			}
			 
			nextMeasure =  nextMeasure + repeat;
			
			if (nextMeasure >= phraseLength)
				nextMeasure = nextMeasure - phraseLength;
			
			//create a new note based on the original
			Note *repeatedNote = [originalNote copy];
			
			//update measure to reflect next position
			repeatedNote.measure = nextMeasure;
			
			//add note to song
			[[[Conductor sharedConductor] currSong] addNote:repeatedNote];
			
			[repeatedNote release];
			
		}
	
	}
}


- (void) refreshNote:(Note *)originalNote{
	Instrument *instrument = originalNote.instrument;
	uint repeat = instrument.repeatEveryHowManyMeasures;
	uint phraseLength = [[Phrase sharedPhrase] length];
	
	//if repeat equals the phrase length, don't add any notes because its just one note per phrase
	if (repeat == phraseLength){
		//no repeats necessary
		return;
		
		//else add notes
	} else {
		
		uint noteTotal = phraseLength / repeat;
		uint nextMeasure = [[Position sharedPosition] currMeasure];
		
		for (int i = 1; i < noteTotal; i++){
			nextMeasure =  nextMeasure + repeat;
			
			if (nextMeasure >= phraseLength)
				nextMeasure = nextMeasure - phraseLength;
			
			//get repeated note from song
			Note *repeatedNote = [[[Conductor sharedConductor] currSong] getNoteOfInstrument:instrument fromMeasure:nextMeasure fromBeat:originalNote.beat];
			
			//refresh note
			if (repeatedNote != nil)
				[repeatedNote refresh];
			
		}
		
	}
}

@end
