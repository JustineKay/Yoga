//
//  Position.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface Position : NSObject {
	uint currBeat;
	uint currMeasure;
}

@property (nonatomic, assign) uint currBeat;
@property (nonatomic, assign) uint currMeasure;

+ (Position *) sharedPosition;

- (void) update;

@end
