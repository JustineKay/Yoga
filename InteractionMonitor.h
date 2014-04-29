//
//  Loop.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface InteractionMonitor : NSObject {
	uint count;
	BOOL interactive;
	uint limit;
}

@property (readwrite) BOOL interactive;

-(void) reset;
-(void) update;

+ (InteractionMonitor *) sharedInteractionMonitor;

@end
