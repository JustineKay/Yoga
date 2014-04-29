//
//  Beat.m
//  MusicMakerDev
//
//  Created by Jason Snell on 6/17/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Beat.h"
#import "Note.h"
#import "Instrument.h"
#import "Repeater.h"
#import "Counter.h"

@implementation Beat

- (id) initWithCapacity:(uint)numItems {
	if (self = [super init]) {		
		noteArray = [[NSMutableArray alloc] initWithCapacity:numItems];
		maxNotesPerBeat = 5;
	}
	return self;
} //initWithCapacity

- (void) dealloc {
	[noteArray release];
	[super dealloc];
} //dealloc

#pragma mark -
#pragma mark add
- (BOOL) addNote:(Note *)note{
	
	// OVERLOAD CHECK
	if (noteArray.count >= maxNotesPerBeat){
		NSLog(@"BLOCKED : * BEAT * %d, %@", noteArray.count, note.instrument.key);
		return NO;
	}
	 
	//init vars
	BOOL containsInstrument = NO;
	Note *existingNote;
	
	//loop through beat array, looking to see if this instrument already exists on this beat
	for (int i = 0; i < noteArray.count; i++){
		existingNote = [noteArray objectAtIndex:i];	
		if (note.instrument == existingNote.instrument){
			containsInstrument = YES;
			break;
		}
	}
	
	//if instrument is not in beat yet...
	if (!containsInstrument){
		
		//add note to beat array
		[noteArray addObject:note]; 
		
		//add to counter
		[[Counter sharedCounter] addInstrument:note.instrument ofType:note.type];
	
		return YES;
		
	//else...
	} else {
		
		//refresh the already existing note with same user touch state as new note
		existingNote.userTouched = note.userTouched;
		[existingNote refresh];
		
		return NO;
	}
	
} //addNote

#pragma mark playback
- (void) play{
	//loop through all notes and play them
	
	for (int i = 0; i < noteArray.count; i++){
		
		Note *note = [noteArray objectAtIndex:i];
		[note play];

	}
	
}

#pragma mark retrival
- (Note *) getNoteOfInstrument:(Instrument *)instrument{
	for (int i = 0; i < noteArray.count; i++){
		
		//grab search note
		Note *searchNote = [noteArray objectAtIndex:i];	
		
		//if note has the same instrument as incoming instrument...
		if (searchNote.instrument == instrument){
			return searchNote; //return note
			break; //break loop
		}
	}
	
	return nil;
	
}

- (NSMutableArray *) getNoteArray{
	return noteArray;
}

@end
