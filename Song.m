//
//  Song.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Song.h"
#import "Measure.h"
#import "Note.h"
#import "Beat.h"
#import "Tempo.h"
#import "Phrase.h"
#import "Instrument.h"

@implementation Song

- (id) initWithCapacity:(uint)numItems {
	if (self = [super init]) {
		
		measureArray = [[NSMutableArray alloc] initWithCapacity:numItems];
		
		for (int i = 0; i < numItems; i++){
			Measure *measure = [[Measure alloc] initWithCapacity: [[Tempo sharedTempo] beatsPerMeasure]];
			[measureArray addObject:measure];
		}
		
	}
	
	return self;
	
} //initWithCapacity


- (void) dealloc {
	for (int i = 0; i < measureArray.count; i++){
		Measure *measure = [measureArray objectAtIndex:i];
		[measure release];
	}
	[measureArray release];
	
	[super dealloc];
	
} //dealloc

#pragma mark -
#pragma mark add
- (BOOL) addNote:(Note *)note{
	Measure *targetMeasure = [measureArray objectAtIndex:note.measure];
	return [targetMeasure addNote:note];
}//addNote


#pragma mark playback
- (void) playAtMeasure:(uint)measure atBeat:(uint)beat{
	Measure *targetMeasure = [measureArray objectAtIndex:measure];
	[targetMeasure playAtBeat:beat];
}//playAtMeasure:atBeat


#pragma mark retrival
- (Note *) getNoteOfInstrument:(Instrument *)instrument fromMeasure:(uint)measure fromBeat:(uint)beat {
	Measure *targetMeasure = [measureArray objectAtIndex:measure];
	return [targetMeasure getNoteOfInstrument:instrument fromBeat:beat];
} //getNoteOfInstrument

- (NSMutableArray *) getNoteArrayOfNote:(Note *)note{
	Measure *targetMeasure = [measureArray objectAtIndex:note.measure];
	return [targetMeasure getNoteArrayOfNote:note];
}
- (NSMutableArray *) getNoteArrayFromMeasure:(uint)measure fromBeat:(uint)beat{
	Measure *targetMeasure = [measureArray objectAtIndex:measure];
	return [targetMeasure getNoteArrayFromBeat:beat];
}


@end
