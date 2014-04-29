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

@class MainView;
@class PlayView;
@class PlayController;
@class GameManager;

@interface MainController : NSObject {
	
	//MANAGERS
	GameManager *gm;
	
	//tracking vars
	uint sceneState;
	
	//view
	MainView *mainView;
	PlayView *playView;
	
	//view controllers
	PlayController *playController;
	
}

@property (nonatomic, retain) MainView *mainView;
@property (nonatomic, retain) PlayView *playView;
@property (nonatomic, retain) PlayController *playController;

#pragma mark -
#pragma mark GL updates

// Selector to update the scenes logic using |aDelta| which is passe in from the game loop
- (void)updateWithDelta:(GLfloat)aDelta;

// Selector which renders the scene
- (void)render;

#pragma mark -
#pragma mark User input
// Enables a touchesBegan events location to be passed into a scene.  |aTouchLocation| is 
// a CGPoint which has been encoded into an NSString
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

// Enables accelerometer data to be passed into the scene.
- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration;

#pragma mark -
#pragma mark Setters

- (void) setView:(MainView *)view;

@end
