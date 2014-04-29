//
//  Fade.m
//  WaterPipe
//
//  Created by Jason Snell on 7/6/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Fade.h"


@implementation Fade

@synthesize speed;
@synthesize delay;

- (void)dealloc {
	[super dealloc];
}


- (id)initWithTarget:(RenderedObject *)aTarget targetAlpha:(GLfloat)aAlpha delay:(float)aDelay speed:(float)aSpeed {
	self = [super init];
	if(self != nil) {
		
		target = aTarget;
		targetAlpha = aAlpha;
		delay = aDelay;
		speed = aSpeed;
		timer = 0;
		
	}
	return self;
}

- (id) initWithDelay:(float)aDelay speed:(float)aSpeed {
	self = [super init];
	if(self != nil) {
		
		delay = aDelay;
		speed = aSpeed;
		timer = 0;
		
	}
	return self;
}



- (BOOL)update:(float)delta {
	
	// Update the timer with the delta
	timer += delta;
	
	// If the timer has exceed the delay for the current frame, move to the next frame.  If we are at
	// the end of the animation, check to see if we should repeat, pingpong or stop
	if(timer > delay) {
		//reset timer
		timer = 0;
		
		//NSLog(@"target = %@", target);
		//NSLog(@"target alpha = %f", targetAlpha);
		
		//change alpha
		GLfloat currentAlpha = [target getAlpha];
		GLfloat inc = (targetAlpha - currentAlpha) * speed;
		GLfloat nextAlpha = currentAlpha + inc;
		[target setAlpha:nextAlpha];
		
		float precision = 0.01;
		if (((nextAlpha - precision) < targetAlpha) && ((nextAlpha + precision) > targetAlpha)) {
			[target setAlpha:targetAlpha];//set completely to target alpha
			return YES;
		} else {
			return NO;
		}
				
	}
	
	//not complete yet
	return NO;
}

#pragma mark -
#pragma mark setters
- (void) setAlpha:(GLfloat)aAlpha {
	targetAlpha = aAlpha;
}
- (void) setTarget:(RenderedObject *)aTarget {
	target = aTarget;
}

@end
