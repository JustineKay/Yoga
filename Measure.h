//
//  Measure.h
//  MusicMakerDev
//
//  Created by Jason Snell on 6/17/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Note;
@class Instrument;
@class Beat;

@interface Measure : NSObject {
	NSMutableArray *beatArray;
	uint estimatedNotesPerBeat;
}

- (id) initWithCapacity:(uint)numItems;
- (BOOL) addNote:(Note *)note;
- (void) playAtBeat:(uint)beat;
- (Note *) getNoteOfInstrument:(Instrument *)instrument fromBeat:(uint)beat;
- (NSMutableArray *) getNoteArrayOfNote:(Note *)note;
- (NSMutableArray *) getNoteArrayFromBeat:(uint)beat;
@end
