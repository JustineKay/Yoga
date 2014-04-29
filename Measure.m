//
//  Measure.m
//  MusicMakerDev
//
//  Created by Jason Snell on 6/17/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Measure.h"
#import "Beat.h"
#import "Tempo.h"
#import "Instrument.h"
#import "Note.h"

@implementation Measure

- (id) initWithCapacity:(uint)numItems {
	
	if (self = [super init]) {
		
		estimatedNotesPerBeat = 10;
		
		beatArray = [[NSMutableArray alloc] initWithCapacity:numItems];
		
		for (int i = 0; i < numItems; i++){
			Beat *beat = [[Beat alloc] initWithCapacity: estimatedNotesPerBeat];
			[beatArray addObject:beat];
		}
		
	}
	
	return self;
	
} //initWithCapacity

- (void) dealloc {
	for (int i = 0; i < beatArray.count; i++){
		Beat *beat = [beatArray objectAtIndex:i];
		[beat release];
	}
	[beatArray release];
	[super dealloc];
} //dealloc

#pragma mark -
#pragma mark add
- (BOOL) addNote:(Note *)note{
	Beat *targetBeat = [beatArray objectAtIndex:note.beat];
	return [targetBeat addNote:note];
} //addNote

#pragma mark playback
- (void) playAtBeat:(uint)beat{
	Beat *targetBeat = [beatArray objectAtIndex:beat];
	[targetBeat play];
}

#pragma mark retrival
- (Note *) getNoteOfInstrument:(Instrument *)instrument fromBeat:(uint)beat{
	Beat *targetBeat = [beatArray objectAtIndex:beat];
	return [targetBeat getNoteOfInstrument:instrument];
}

- (NSMutableArray *) getNoteArrayOfNote:(Note *)note{
	Beat *targetBeat = [beatArray objectAtIndex:note.beat];
	return [targetBeat getNoteArray];
}
- (NSMutableArray *) getNoteArrayFromBeat:(uint)beat{
	Beat *targetBeat = [beatArray objectAtIndex:beat];
	return [targetBeat getNoteArray];
}

@end
