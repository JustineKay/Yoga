//
//  AutoFiller.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Instrument.h"
#import "Song.h"


@interface AutoFiller : NSObject {
	uint maxNotesPerMeasure;
}

- (void) addInstrument:(Instrument *)instrument withPoint:(CGPoint)point;
//- (void) removeInstrument:(Instrument *)instrument;


+ (AutoFiller *) sharedAutoFiller;

@end
