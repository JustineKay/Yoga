//
//  Counter.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Instrument;

@interface Counter : NSObject {
	uint manualTotals[15];
	uint autoTotals[15];
}

- (void) initForInstruments:(NSArray *)instrumentArray;
- (uint) getTotalOfInstrument:(Instrument *)instrument ofType:(uint)type;
- (uint) addInstrument:(Instrument *)instrument ofType:(uint)type;
- (uint) removeInstrument:(Instrument *)instrument ofType:(uint)type;

+ (Counter *) sharedCounter;

@end
 
