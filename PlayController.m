//
//  PlayController.m
//  Yoga
//
//  Created by Jason Snell on 7/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "PlayController.h"
#import "PlayView.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "LocationInstrumentTranslator.h"
#import "Instrument.h"
#import "Image.h"
#import "ParchmentScroller.h"
#import "InteractionMonitor.h"
#import "Visualizer.h"
#import "Creator.h"
#import "Cleaner.h"
#import "Note.h";

#pragma mark private interface
@interface PlayController (Private)
//private methods
@end

#pragma mark -
#pragma mark implementation
@implementation PlayController

@synthesize v;


- (void)dealloc {
	//release objects
	[ps release];
	[vis release];
	[super dealloc];
}

- (id)init {
	self = [super init];
	if(self != nil) {
		gm = [GameManager sharedGameManager];
		ps = [[ParchmentScroller alloc] init];
		vis = [Visualizer sharedVisualizer];
		im = [InteractionMonitor sharedInteractionMonitor];
	}
	return self;
}

#pragma mark -
#pragma mark LOGIC
- (void)updateWithDelta:(GLfloat)aDelta {
	
	//active in all scenes
	
	//SCENE SPECIFIC UPDATES 
#pragma mark play
	if (gm.scene == kScene_Play){
		if (gm.mode == kMode_In){
			
		} else if (gm.mode == kMode_Running){
			[ps updateWithDelta:aDelta];
			[vis updateWithDelta:aDelta];
			[im update];
		} else if (gm.mode == kMode_Out){
			
		} 

	}	
	
}


#pragma mark -
#pragma mark RENDER
- (void)render {
	
	//render with lowest layer first
#pragma mark play
	if (gm.scene == kScene_Play){
		[v.bgGradient renderAtPoint:CGPointMake(0,0) centerOfImage:NO];
		[v.parchment1 renderAtPoint:CGPointMake(ps.parchment1X,6) centerOfImage:NO];
		[v.parchment0 renderAtPoint:CGPointMake(ps.parchment0X,6) centerOfImage:NO];
		[v.basePanel renderAtPoint:CGPointMake(0,0) centerOfImage:NO];
		[vis render];
		[v.carvedPanel renderAtPoint:CGPointMake(6,4) centerOfImage:NO];
		[v.arm renderAtPoint:CGPointMake(296,-1) centerOfImage:NO];
		
	}
	

	//render on top of all other scenes, like popup windows
}


#pragma mark -
#pragma mark touch began

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint touchLocation = [touch locationInView:aView];
    touchLocation.y = 480 - touchLocation.y; //flip y for openGL
	
	//if touch hits particular button
	if (CGRectContainsPoint(v.playPad, touchLocation)){			 
		
		//get instrument corresponding to location from tap translator and send note to conductor so it can be processed and added to the song
		Instrument *instrument = [[LocationInstrumentTranslator sharedLocationInstrumentTranslator] getInstrumentFromPoint:touchLocation];
		
		if (touchLocation.x <=60){
			
			//left side of screen touched on wood panel - remove instrument from song if active
			[[Cleaner sharedCleaner] removeInstrument:instrument];
			[[Visualizer sharedVisualizer] removeGlowForInstrument:instrument];
			
		
		} else {
			
			//else add instrument to song
			[[Creator sharedCreator] addNoteOfInstrument:instrument atPoint:touchLocation];
			[[Visualizer sharedVisualizer] addGlowForInstrument:instrument];
			
			
		}
	}
	
	//each tap resets the interaction monitor
	[im reset];
	
	
}


#pragma mark -
#pragma mark Setters

- (void) setView:(PlayView *)view{
	
	v = view;
	
	//pass view to subcontrollers
	[[LocationInstrumentTranslator sharedLocationInstrumentTranslator] initWithHeight:v.playPadHeight];
	
}



@end
