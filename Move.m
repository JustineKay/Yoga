//
//  Move.m
//  WaterPipe
//
//  Created by Jason Snell on 7/6/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Move.h"


@implementation Move


- (void)dealloc {
	[super dealloc];
}


- (id)initWithTarget:(RenderedObject *)aTarget startPoint:(CGPoint)aStartPoint endPoint:(CGPoint)aEndPoint delay:(float)aDelay speed:(float)aSpeed {
	self = [super init];
	if(self != nil) {
		
		target = aTarget;
		currX = aStartPoint.x;
		currY = aStartPoint.y;
		endPosition = aEndPoint;
		endX = aEndPoint.x;
		endY = aEndPoint.y;
		delay = aDelay;
		speed = aSpeed;
		timer = 0;
		xComplete = NO;
		yComplete = NO;
		
	}
	return self;
}

- (CGPoint)update:(float)delta {
	
	// Update the timer with the delta
	timer += delta;
	
	// If the timer has exceed the delay for the current frame, move to the next frame.  If we are at
	// the end of the animation, check to see if we should repeat, pingpong or stop
	if(timer > delay) {
		//reset timer
		timer = 0;
		
		//change loc
		
		
		//get detailed increment
		float xIncFloat = (endX - currX) * speed;
		float yIncFloat = (endY - currY) * speed;
	
		//round off to nearest integer
		int xIncInt = xIncFloat;
		int yIncInt  = yIncFloat;
		
		//only make adjustments if incomplete (otherwise visual "shake" happens at end of anim)
		if (!xComplete)
			currX = currX + xIncInt;
		
		if (!yComplete)
			currY = currY + yIncInt;
	
		//make CG to pass back
		currPosition = CGPointMake(currX,currY);

		//if with a pixel of the end point, switch to complete
		if (xIncInt > -1 && xIncInt < 1)
			xComplete = YES;
		
		if (yIncInt > -1 && yIncInt < 1)
			yComplete = YES;
			
		//if both are complete, return end point
		if (xComplete && yComplete)
			return endPosition;
		
	}
	
	//not complete yet
	return currPosition;
}



@end
