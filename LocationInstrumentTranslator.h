//
//  TapTranslator.h
//  MusicMaker
//
//  Created by Jason Snell on 6/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Instrument;

@interface LocationInstrumentTranslator : NSObject {
	int buttonHeight;
}

-(id) initWithHeight:(uint)height;
- (Instrument *) getInstrumentFromPoint:(CGPoint)touchPoint;
- (CGPoint) getPointFromInstrument:(Instrument *)instrument; 

+ (LocationInstrumentTranslator *) sharedLocationInstrumentTranslator;

@end
