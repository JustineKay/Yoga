//
//  ParchmentScroller.h
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>

@class PlayView;

@interface ParchmentScroller : NSObject {
	//view
	PlayView *v;
	
	CGFloat parchment0X;
	CGFloat parchment1X;
	float parchmentWidth;
	float startX;
	float xInc;
}

@property (nonatomic, assign) CGFloat parchment0X;
@property (nonatomic, assign) CGFloat parchment1X;

- (void) updateWithDelta:(GLfloat)aDelta;
- (void) setView:(PlayView *)aView;

@end
