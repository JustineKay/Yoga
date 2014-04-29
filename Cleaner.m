//
//  Remover.m
//  Yoga
//
//  Created by Jason Snell on 9/16/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Cleaner.h"
#import "Note.h"
#import "Orchestra.h"
#import "Instrument.h"
#import "Song.h"
#import "Conductor.h"
#import "Rejuvenator.h"
#import "Position.h"
#import "Counter.h"
#import "Phrase.h"
#import "Tempo.h"

#pragma mark private method headers
@interface Cleaner (Private)
//private method headers


@end


@implementation Cleaner

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Cleaner);

- (void) dealloc {
	[super dealloc];
} //dealloc


// called each position update by metronome (after call to player so removal doesn't interfere with playback)

- (void) clean{
	
	//get note array of the current position so it can be manipulated
	NSMutableArray *noteArray = [[[Conductor sharedConductor] currSong] getNoteArrayFromMeasure:[[Position sharedPosition] currMeasure] fromBeat:[[Position sharedPosition] currBeat]];
	NSMutableArray *removalArray = [[NSMutableArray alloc] initWithCapacity:noteArray.count];
	
	//if there are no notes on this beat, then skip check
	if (noteArray.count == 0)
		return;
	
	//loop through the note array...
	for (int i = 0; i < noteArray.count; i++){
		
		Note *note = [noteArray objectAtIndex:i];
		
		//... checking each note for a volume drop below it's volume minimum
		if (note.volume <= note.instrument.playMinVolume){
			
			// if below minimum, add to removal array
			[removalArray addObject:note];
		
		}
		
	}
	
	
	//if there are no notes to remove on this beat, then skip removal loop
	if (removalArray.count == 0)
		return;
	
	//loop through removal array...
	for (int ii = 0; ii < removalArray.count; ii++){
		
		// grab note to remove
		Note *noteToRemove = [removalArray objectAtIndex:ii];
		Instrument *instrument = noteToRemove.instrument;
		
		//remove it from counter
		[[Counter sharedCounter] removeInstrument:instrument ofType:noteToRemove.type];
		
		//tell rejuventator to assess this instrument
		[[Rejuvenator sharedRejuvenator] assessInstrument:instrument];
		
		//remove it from the original array in song
		[noteArray removeObject:noteToRemove];
		
	}
	
	[removalArray release];
	
}

//called when user taps wood panel

- (void) removeInstrument:(Instrument *)instrument{
	//NSLog(@"REMOVE  : %@", instrument.key);
	
	//loop through all measures
	
	for (uint m = 0; m < [[Phrase sharedPhrase] length]; m++){
		
		//loop through all beats
		
		for (uint b = 0; b < [[Tempo sharedTempo] beatsPerMeasure]; b++){
			
			//get note of instrument from each measure and beat in song
			Note *note = [[[Conductor sharedConductor] currSong] getNoteOfInstrument:instrument fromMeasure:m fromBeat:b];
			
			//if valid...
			if (note != nil){
				
				//then remove
				[self removeNote:note];
			
			}

		}
		
	}
	
	//take orchestra off of users list
	[[Orchestra sharedOrchestra] removeUserSelectedInstrument:instrument];
}

- (void) removeNote:(Note *)note{
	
	//get note array of this note so it can be manipulated
	NSMutableArray *noteArray = [[[Conductor sharedConductor] currSong] getNoteArrayOfNote:note];
	
	//remove from counter
	[[Counter sharedCounter] removeInstrument:note.instrument ofType:note.type];
	
	//remove note from array
	[noteArray removeObject:note];
	
}

@end
