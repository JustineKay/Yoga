//
//  Rejuvenator.m
//  Yoga
//
//  Created by Jason Snell on 9/16/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Rejuvenator.h"
#import "Creator.h"
#import "Note.h"
#import "Orchestra.h"
#import "Instrument.h"
#import "Counter.h"
#import "AutoFiller.h"
#import "InteractionMonitor.h"
#import "Phrase.h"
#import "Tempo.h"
#import "Visualizer.h"
#import "LocationInstrumentTranslator.h"

#pragma mark private method headers
@interface Rejuvenator (Private)
//private method headers
- (void) resetInstrument:(Instrument *)instrument;
- (void) newInstrument;
- (void) assessAllInstruments;

@end

@implementation Rejuvenator

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Rejuvenator);

- (id) init {
	
	if (self = [super init]) {		
		
		debug = YES;
		
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
} //dealloc

- (void) assessInstrument:(Instrument *)instrument{
	
	if (instrument == nil)
		return;
	
	uint autoTotal = [[Counter sharedCounter] getTotalOfInstrument:instrument ofType:1];
	uint manualTotal = [[Counter sharedCounter] getTotalOfInstrument:instrument ofType:0];
	
	//always reset shakers
	if([instrument.key isEqualToString:@"shaker"] && autoTotal <= 16){
		[[AutoFiller sharedAutoFiller] addInstrument:instrument withPoint:CGPointMake(-1.0,-1.0)];
		return;
	}
	if([instrument.key isEqualToString:@"shakerRoll"] && autoTotal <= 48){
		[[AutoFiller sharedAutoFiller] addInstrument:instrument withPoint:CGPointMake(-1.0,-1.0)];
		return;
	}
	//reset one sitar for each one that dies out
	if ([instrument.key isEqualToString: @"sitar1"]){
		[self resetInstrument:instrument];
		return;
	}
	
	//OVERLOAD
	//don't rejuvenate is over note max (used particularly on gong and om)
	if (manualTotal > instrument.noteMax){
		if (debug)
			NSLog(@"BLOCKED : REJUENATOR NOTEMAX, %@", instrument.key);
		return;
	}
	
	//if both totals are at zero, reset all
	if (autoTotal <= 0 && manualTotal <= 0)
		[self assessAllInstruments];
	
	uint chance  = arc4random() % 10;
	
	// RESET - 40%
	if (chance <= 4){
		
		if (instrument.autoFillEnabled){
			
			//instruments with autofill
			
			if (autoTotal <= 0) {
				[self resetInstrument:instrument];
			} else {
				if (debug)
					NSLog(@"RELEASE : Let go of AUTO %@", instrument.key);
			}
			
		} else {
			
			//instruments with manual only
			
			if (manualTotal <= 0) {
				[self resetInstrument:instrument];
			} else {
				if (debug)
					NSLog(@"RELEASE : Let go of MANUAL %@", instrument.key);
			}
		}
		
	// SWAP 30%
	} else if (chance <= 6){
		if (![InteractionMonitor sharedInteractionMonitor].interactive){
			[self newInstrument];
		} else {
			if (debug)
				NSLog(@"RELEASE : Attempted new instrument, but user active");
		}
		
	// RELEASE 10%
	} else if (chance <= 9){
		if (debug)
			NSLog(@"RELEASE : Die out %@", instrument.key);
		//do nothing - note dies
	}
	
}

#pragma mark -
#pragma mark private

- (void) assessAllInstruments{
	
	uint autoTally = 0;
	uint manualTally = 0;
	
	//uint instrumentMax = [Orchestra sharedOrchestra]
	for (int i = 0; i < [Orchestra sharedOrchestra].instrumentArray.count; i++){
		Instrument *instrument = [[[Orchestra sharedOrchestra] instrumentArray] objectAtIndex:i];
		autoTally += [[Counter sharedCounter] getTotalOfInstrument:instrument ofType:1];
		manualTally += [[Counter sharedCounter] getTotalOfInstrument:instrument ofType:0];
	}
	if (debug)
		NSLog(@"RJUVANTE: Assess all: M%d, A%d", manualTally, autoTally);
	
	//if no instruments are playing...
	if (autoTally < 70 && manualTally < 10){
		//if (debug)
			NSLog(@"RJUVANTE: Reset all");
		
		//add 3 new instruments
		for (uint i = 0; i < 3; i++){
			[self newInstrument];
		}
	}
}

- (void) resetInstrument:(Instrument *)instrument {
		
	//generate a new CG point for visualizer in the appropriate slot for this instrument
	CGPoint randomPoint = [[LocationInstrumentTranslator sharedLocationInstrumentTranslator] getPointFromInstrument:instrument];
	
	//random loc in song
	uint randomMeasure = arc4random() % [[Phrase sharedPhrase] length];
	uint randomBeat = arc4random() % [[Tempo sharedTempo] beatsPerMeasure];

	if (debug)
		NSLog(@"RESET   : %@ : %d:%d", instrument.key, randomMeasure, randomBeat);
	
	//add to song
	[[Creator sharedCreator] addNoteOfInstrument:instrument atPoint:randomPoint atMeasure:randomMeasure atBeat:randomBeat withUserTouch:NO];
	
}

- (void) newInstrument{
	
	//get random user-selected instrument from orchestra
	Instrument *randomInstrument = [[Orchestra sharedOrchestra] getRandomUserSelectedInstrument];
	//Instrument *randomInstrument = [[Orchestra sharedOrchestra] getRandomInstrument];

	if (randomInstrument == nil || [randomInstrument.key isEqualToString: @"sitar1"])
		return;
	
	//generate a new CG point for visualizer in the appropriate slot for this instrument
	CGPoint randomPoint = [[LocationInstrumentTranslator sharedLocationInstrumentTranslator] getPointFromInstrument:randomInstrument];
	
	//random loc in song
	uint randomMeasure = arc4random() % [[Phrase sharedPhrase] length];
	uint randomBeat = arc4random() % [[Tempo sharedTempo] beatsPerMeasure];
	
	if (debug)
		NSLog(@"SWITCH  : %@ : %d:%d", randomInstrument.key, randomMeasure, randomBeat);

	//add to song
	[[Creator sharedCreator] addNoteOfInstrument:randomInstrument atPoint:randomPoint atMeasure:randomMeasure atBeat:randomBeat withUserTouch:NO];
	
	
}

@end
