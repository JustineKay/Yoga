//
//  PlayController.h
//  Yoga
//
//  Created by Jason Snell on 7/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>

@class PlayView;
@class GameManager;
@class LocationInstrumentTranslator;
@class ParchmentScroller;
@class Visualizer;
@class Note;
@class InteractionMonitor;

@interface PlayController : NSObject {
	
	//view
	PlayView *v;
	
	//MANAGERS
	GameManager *gm;
	Visualizer *vis;
	ParchmentScroller *ps;
	InteractionMonitor *im;
	
}

@property (nonatomic, retain) PlayView *v;

#pragma mark -
#pragma mark GL updates

- (void)updateWithDelta:(GLfloat)aDelta;
- (void)render;

#pragma mark -
#pragma mark User input

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;


#pragma mark -
#pragma mark Setters

- (void) setView:(PlayView *)view;

@end
