//
//  PlayController.m
//  Yoga
//
//  Created by Jason Snell on 7/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "MainController.h"
#import "MainView.h"
#import "PlayView.h"
#import "PlayController.h"
#import "GameManager.h"
#import "Metronome.h"

#pragma mark private interface
@interface MainController (Private)
//private methods
@end

#pragma mark -
#pragma mark implementation
@implementation MainController

@synthesize mainView;
@synthesize playView;
@synthesize playController;

- (void)dealloc {
	//release objects
	[super dealloc];
}

- (id)init {
	self = [super init];
	if(self != nil) {
		
		gm = [GameManager sharedGameManager];
		gm.scene = kScene_Play;
		gm.mode = kMode_Running;
		
		//views
		playView = [[PlayView alloc] init];
	
		//controllers
		playController = [[PlayController alloc] init];
		
		//connections
		[playView setController:playController];
		[playController setView:playView];
		
	}
	return self;
}



#pragma mark -
#pragma mark LOGIC
- (void)updateWithDelta:(GLfloat)aDelta {
	
#pragma mark all scenes
	//active in all scenes, whether screen is on or off
	[[Metronome sharedMetronome] update:aDelta];
	
	//don't use CPU to render when screen is off
	if (gm.displayOn == NO)
		return;
	
	//SCENE SPECIFIC UPDATES 
#pragma mark play
	if (gm.scene == kScene_Play){
		
		[playController updateWithDelta:aDelta];
		
	}	
	
}


#pragma mark -
#pragma mark RENDER
- (void)render {

	//don't use CPU to render when screen is off
	if (gm.displayOn == NO)
		return;
	
#pragma mark play
	if (gm.scene == kScene_Play){
		[playController render];
	}
	
}


#pragma mark -
#pragma mark touch began

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
	//don't use CPU to render when screen is off
	if (gm.displayOn == NO)
		return;
	
	
}

#pragma mark -
#pragma mark touch moved

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {

	//don't use CPU to render when screen is off
	if (gm.displayOn == NO)
		return;
	
}

#pragma mark -
#pragma mark touch ended
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {

	//don't use CPU to render when screen is off
	if (gm.displayOn == NO)
		return;
	
	//play scene
	if (gm.scene == kScene_Play){
		[playController updateWithTouchLocationEnded:touches withEvent:event view:aView];
	}
	
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration {
	/*
	 if (fabsf(aAcceleration.x) > 1.75 || fabsf(aAcceleration.y) > 1.75 || fabsf(aAcceleration.z) > 1.75) {
	 //shake detected
	 }
	 */
	
}

#pragma mark -
#pragma mark Setters

- (void) setView:(MainView *)view{
	mainView = view;
	//pass view to subcontrollers
}



@end
