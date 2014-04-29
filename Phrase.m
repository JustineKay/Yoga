//
//  Loop.m
//  SimpleSong
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//
// Contains Loop length, which is the number of measures that a loop goes before looping back to beginning. Usually 4.


#import "Phrase.h"

@implementation Phrase

@synthesize length;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Phrase);

- (id) init {
	length = 4;
	return self;
} //init

- (void) dealloc {
	[super dealloc];
} //dealloc

@end
