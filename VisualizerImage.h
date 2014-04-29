//
//  NoteImage.h
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import "Image.h"

@class Fade;
@class Note;
@class Instrument;

@interface VisualizerImage : Image {
	
	Instrument *instrument;
	CGFloat x;
	CGFloat y;
	
	//fade in and out
	BOOL fadeComplete;
	Fade *fadeAnim;
	
	
}

@property (nonatomic, retain) Instrument *instrument;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (void) show;
- (void) dim;
- (void) hide;
- (BOOL) fade:(float)aDelta;

@end
