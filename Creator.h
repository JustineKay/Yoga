//
//  Creator.h
//  MusicMakerDev
//
//  Created by Jason Snell on 6/17/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Instrument;

@interface Creator : NSObject {
	
}

- (void) addNoteOfInstrument:(Instrument *)instrument atPoint:(CGPoint)point;
- (void) addNoteOfInstrument:(Instrument *)instrument atPoint:(CGPoint)point atMeasure:(uint)measure atBeat:(uint)beat withUserTouch:(BOOL)touch;


+ (Creator *) sharedCreator;

@end
