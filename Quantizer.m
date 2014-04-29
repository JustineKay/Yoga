//
//  Quantizer.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Quantizer.h"
#import "Position.h"
#import "Phrase.h"
#import "Tempo.h"

@implementation Quantizer

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Quantizer);

- (void) dealloc {
	[super dealloc];
} //dealloc


- (NSArray *) quantizeInstrument:(Instrument *)instrument atMeasure:(uint)measure atBeat:(uint)beat{
	
	//snapTo is a value that the current note is divided by and multipled by
	//since it is an int, it automatically rounds the value down to the closest quantized note behind the curr note
	uint snapTo = [[Tempo sharedTempo] beatsPerMeasure] / instrument.quantization;
	uint div = beat / snapTo;
	uint beatJustPassed = div * snapTo;
	uint beatComingUp = beatJustPassed + snapTo;
	
	//prep vars
	uint quantizedBeat;
	uint quantizedMeasure = measure;

	//if forward beat is in the next measure, advance measure and make beat in first position (0)
	if (beatComingUp >= [[Tempo sharedTempo] beatsPerMeasure]){
		beatComingUp = 0;
		quantizedMeasure++;
		
		//if measure is past end of loop, move it beginning of next loop (0)
		if (quantizedMeasure == [[Phrase sharedPhrase] length]){
			quantizedMeasure = 0;
		}
		
	}
	
	quantizedBeat = beatComingUp;
	
	//convert meas and beat to Numbers
	NSNumber *quantizedMeasureNum = [[NSNumber alloc] initWithInt:quantizedMeasure];
	NSNumber *quantizedBeatNum = [[NSNumber alloc] initWithInt:quantizedBeat];
	
	//insert into new array
	NSArray *quantizedData = [[NSArray alloc] initWithObjects:quantizedMeasureNum, quantizedBeatNum, nil];
	
	//clean up memory
	[quantizedMeasureNum release];
	[quantizedBeatNum release];
	
	//return data array
	return [quantizedData autorelease];

} //quantizeInstrument

@end
