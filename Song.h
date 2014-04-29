//
//  Song.h
//  SimpleSong
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//
//  sample structure:
//	-song
//		-4 measures
//			-16 beats per measure
//				-x notes on each beat

#import <Foundation/Foundation.h>
@class Note;
@class Instrument;

@interface Song : NSObject {
	NSMutableArray *measureArray;
}

- (id) initWithCapacity:(uint)numItems;
- (BOOL) addNote:(Note *)note;
- (void) playAtMeasure:(uint)measure atBeat:(uint)beat;
- (NSMutableArray *) getNoteArrayOfNote:(Note *)note;
- (NSMutableArray *) getNoteArrayFromMeasure:(uint)measure fromBeat:(uint)beat;
- (Note *) getNoteOfInstrument:(Instrument *)instrument fromMeasure:(uint)measure fromBeat:(uint)beat;

@end
