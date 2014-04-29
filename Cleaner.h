//
//  Remover.h
//  Yoga
//
//  Created by Jason Snell on 9/16/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Note;
@class Instrument;

@interface Cleaner : NSObject {

}

- (void) clean;
- (void) removeNote:(Note *)note;
- (void) removeInstrument:(Instrument *)instrument;

+ (Cleaner *) sharedCleaner;

@end
