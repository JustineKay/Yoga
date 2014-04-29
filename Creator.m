//
//  Creator.m
//  MusicMakerDev
//
//  Created by Jason Snell on 6/17/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Creator.h"
#import "Orchestra.h"
#import "Song.h"
#import "Instrument.h"
#import "Position.h"
#import "Conductor.h"
#import "Counter.h"
#import "Note.h"
#import "AutoFiller.h"
#import "Tempo.h"
#import "Quantizer.h"
#import "Repeater.h"

@implementation Creator

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Creator);

- (void) dealloc {
	[super dealloc];
} //dealloc

#pragma mark add
- (void) addNoteOfInstrument:(Instrument *)instrument atPoint:(CGPoint)point {

	//this method is called by play view controller when user touches screen
	
	//grab curr position and send it along to main add function
	uint measure = [[Position sharedPosition] currMeasure];
	uint beat = [[Position sharedPosition] currBeat];
	[self addNoteOfInstrument:instrument atPoint:point atMeasure:measure atBeat:beat withUserTouch:YES];

} // addNoteOfInstrument atPoint


- (void) addNoteOfInstrument:(Instrument *)instrument atPoint:(CGPoint)point atMeasure:(uint)measure atBeat:(uint)beat withUserTouch:(BOOL)touch{
	
	//OVERLOAD CHECK
	/*
	uint manualTotal = [[Counter sharedCounter] getTotalOfInstrument:instrument ofType:0];
	if (manualTotal > instrument.noteMax){
		NSLog(@"BLOCKED : * NOTEMAX %d / %d * %@", manualTotal, instrument.noteMax, instrument.key);
		return;
	}
	 */
	
	//AUTOFILL
	uint autoTotal = [[Counter sharedCounter] getTotalOfInstrument:instrument ofType:1];
	if (autoTotal < instrument.autoFillMin && instrument.autoFillEnabled && instrument.autoFillActive){
		instrument.autoFillActive = NO;
	}
	//if song has no notes of this instrument && autofill is enabled...
	if (autoTotal < instrument.autoFillMin && instrument.autoFillEnabled && !instrument.autoFillActive){ //and global autoFillEnabled
		//run autofill for instrument
		//include changing instruction autofillActive to YES
		//NSLog(@"AFILL ++: %@", instrument.key);
		[[AutoFiller sharedAutoFiller] addInstrument:instrument withPoint:point];
	}
	
	//QUANTIZER
	//get quantized data from quanitizer
	uint quantizedMeasure;
	uint quantizedBeat;
	
	NSArray *quantizedData = [[Quantizer sharedQuantizer] quantizeInstrument:instrument atMeasure:measure atBeat:beat];
	quantizedMeasure = [[quantizedData objectAtIndex:0] intValue];
	quantizedBeat = [[quantizedData objectAtIndex:1] intValue];
	
		
	//CREATE NOTE
	Note *note = [[Note alloc] init];
	note.instrument = instrument;
	note.measure = quantizedMeasure;
	note.beat = quantizedBeat;
	note.point = point;
	note.userTouched = touch;
	note.volume = [instrument getRandomVolumeForType:0];
	note.pitch = [instrument getRandomPitch];
	note.type = 0;
	
	//ADD TO USER SELECTED INSTRUMENTS
	[[Orchestra sharedOrchestra] addUserSelectedInstrument:instrument];
	
	//ADD TO SONG
	BOOL wasNewNoteAdded = [[[Conductor sharedConductor] currSong] addNote:note];
	
	if (!wasNewNoteAdded){
		note.userTouched = NO;	
	} else {
		//NSLog(@"ADDINSTR: %d:%d: %@", quantizedMeasure, quantizedBeat, instrument.key);
	}	
	
	//REPEATER
	//send note to repeater
	[[Repeater sharedRepeater] addNote:note];
	
	//CLEANUP
	[note release];
}

@end
