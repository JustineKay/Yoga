//
//  Beat.h
//  MusicMakerDev
//
//  Created by Jason Snell on 6/17/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Note;
@class Instrument;

@interface Beat : NSObject {
	NSMutableArray *noteArray;
	int maxNotesPerBeat;
}

- (id) initWithCapacity:(uint)numItems;
- (BOOL) addNote:(Note *)note;
- (void) play;
- (Note *) getNoteOfInstrument:(Instrument *)instrument;
- (NSMutableArray *) getNoteArray;
@end
