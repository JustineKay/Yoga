//
//  Rejuvenator.h
//  Yoga
//
//  Created by Jason Snell on 9/16/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Instrument;

@interface Rejuvenator : NSObject {
	bool debug;
}

+ (Rejuvenator *) sharedRejuvenator;

- (void) assessInstrument:(Instrument *)instrument;

@end
