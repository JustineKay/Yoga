//
//  Move.h
//  WaterPipe
//
//  Created by Jason Snell on 7/6/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "RenderedObject.h"

@interface Move : NSObject {
	RenderedObject *target;
	
	int currX;
	int currY;
	CGPoint currPosition;
	
	int endX;
	int endY;
	CGPoint endPosition;
	
	float delay;
	float timer;
	float speed;
	
	BOOL xComplete;
	BOOL yComplete;
	
}

- (id)initWithTarget:(RenderedObject *)aImage startPoint:(CGPoint)aStartPoint endPoint:(CGPoint)aEndPoint delay:(float)aDelay speed:(float)aSpeed;
- (CGPoint)update:(float)delta;

@end
