//
//  Metronome.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class EventTimer;

@interface Metronome : NSObject {
	EventTimer *myOpenGLTimer;
	NSTimer *myNsTimer;
	bool active;
}

- (void)update:(float)aDelta;
+ (Metronome *) sharedMetronome;

@end
