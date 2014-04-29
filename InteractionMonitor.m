//
//  TImer.m
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "InteractionMonitor.h"


@implementation InteractionMonitor

@synthesize interactive;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(InteractionMonitor);

- (id) init {
	interactive = YES;
	limit = 3000;
	return self;
}

- (void) dealloc {
	[super dealloc];
} //dealloc

-(void) reset{
	
	//user has touched screen, so reset count 
	count = 0;
	interactive = YES;
	
}

-(void) update{
	
	//only count until user is determined to be inactive
	if (interactive){
		count++;
	
		if (count >= limit){
			interactive = NO;
			NSLog(@"MONITOR : User inactive");
		}
	}
	
}
@end
