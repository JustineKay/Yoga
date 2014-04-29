//
//  Fade.h
//  WaterPipe
//
//  Created by Jason Snell on 7/6/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "RenderedObject.h"

@interface Fade : NSObject {
	RenderedObject *target;
	float targetAlpha;
	float delay;
	float timer;
	float speed;
}

@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float delay;

- (id) initWithTarget:(RenderedObject *)aImage targetAlpha:(GLfloat)aAlpha delay:(float)aDelay speed:(float)aSpeed;
- (id) initWithDelay:(float)aDelay speed:(float)aSpeed;
- (void) setAlpha:(GLfloat)aAlpha;
- (void) setTarget:(RenderedObject *)aTarget;
- (BOOL) update:(float)delta;
	
@end
