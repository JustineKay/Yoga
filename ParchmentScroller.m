//
//  ParchmentScroller.m
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "ParchmentScroller.h"
#import "PlayView.h"
#import "Visualizer.h"

@implementation ParchmentScroller

@synthesize parchment0X;
@synthesize parchment1X;

- (void)dealloc {
	//release objects
	[super dealloc];
}

- (id)init {
	self = [super init];
	if(self != nil) {
		xInc = 0.01;
		startX = 55;
		parchmentWidth = 705;
		parchment0X = startX;
		parchment1X = startX + parchmentWidth;
		
	}
	return self;
}


- (void)updateWithDelta:(GLfloat)aDelta {
	
	if (xInc >= [[Visualizer sharedVisualizer] scrollSpeed]){
		xInc = [[Visualizer sharedVisualizer] scrollSpeed];
	} else {
		xInc += 0.01;
	}
	
	//move to right
	parchment0X -= xInc;
	
	//if second panel has arrived at start point, move panel 1 back to start for a seamless loop
	if (parchment0X < -parchmentWidth + startX)
		parchment0X = startX;
	
	//put second panel right behind panel 1 in scrolling
	parchment1X = parchment0X + parchmentWidth;
	
	//NSLog(@"p0 x = %f", parchment0X);

}



-(void)setView:(PlayView *)aView{
	v = aView;
}

@end
