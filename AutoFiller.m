//
//  AutoFiller.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "AutoFiller.h"
#import "Instrument.h"
#import "Orchestra.h"
#import "Note.h"
#import "NumberUtils.h"
#import "Conductor.h"
#import "Song.h"
#import "Position.h"
#import "Phrase.h"

@implementation AutoFiller

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(AutoFiller);



- (id) init {
	
	if (self = [super init]) {		
		maxNotesPerMeasure = 16;
	}
	
	return self;
} //init

- (void) addInstrument:(Instrument *)instrument withPoint:(CGPoint)point{
	instrument.autoFillActive = YES;
	 
	//cycle through each measure and fill with autofill notes for this instrument
	for (uint measure = 0; measure < [[Phrase sharedPhrase] length]; measure++){
		
		//pick a random autofill slot
		uint randomSlot = arc4random() % instrument.autoFillSlots;
		
		//cycle through beat positions in random autofill slot and populate the measures
		for (uint arrayPosition = 0; arrayPosition < maxNotesPerMeasure; arrayPosition++){
			uint beat = [instrument getAutoFillPosition:arrayPosition fromColumn:randomSlot];
			if (beat == -1){
				break;
			} else {
				
				//create an auto note
				Note *note = [[Note alloc] init];
				note.instrument = instrument;
				note.measure = measure;
				note.beat = beat;
				note.point = point;
				note.volume = [instrument getRandomVolumeForType:1];
				note.pitch = [instrument getRandomPitch];
				note.type = 1;
				
				//add to song
				[[[Conductor sharedConductor] currSong] addNote:note];
				
				//and release
				[note release];
			}

		}
	}

}

/*
- (void) removeInstrument:(Instrument *)instrument{
	instrument.autoFillActive = NO;
	//have song remove all the auto notes of this instrument
	NSLog(@"AUTOFILL IS ATTEMPTING TO REMOVE IT'S INSTRUMENTS");
	//[[[Conductor sharedConductor] currSong] removeAutoNotesOfInstrument:instrument];
} //removeInstrument
*/
 
@end
