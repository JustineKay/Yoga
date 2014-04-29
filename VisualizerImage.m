//
//  NoteImage.m
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "VisualizerImage.h"
#import "Fade.h"

@implementation VisualizerImage

@synthesize instrument;
@synthesize x;
@synthesize y;

#pragma mark base
- (void)dealloc {
	//release objects
	[instrument release];
	[super dealloc];
}

- (id)initWithImage:(NSString*)aImage {
	self = [super initWithImage:aImage];
	if (self != nil) {
		
        fadeAnim = [[Fade alloc] initWithDelay:0.05f speed:0.25f];
		[fadeAnim setTarget:self];
	}
	return self;
}

#pragma mark open GL
- (BOOL) fade:(float)aDelta {
		
	//if fade isn't complete, keep updating it
	if (!fadeComplete){
		fadeComplete = [fadeAnim update:aDelta];
	}
	
	return fadeComplete;
}


#pragma mark visibility

- (void) show {
	
	//init fade
	[fadeAnim setAlpha:0.75f];
	fadeComplete = NO;

}

- (void) dim {
	
	//init fade
	[fadeAnim setAlpha:0.5f];
	fadeComplete = NO;
	
}

- (void) hide {
	
	//init fade
	[fadeAnim setAlpha:0.0f];
	fadeComplete = NO;
	
}


@end
