//
//  Quantizer.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Instrument.h"

@interface Quantizer : NSObject {

}

- (NSArray *) quantizeInstrument:(Instrument *)instrument atMeasure:(uint)measure atBeat:(uint)beat;

+ (Quantizer *) sharedQuantizer;

@end
