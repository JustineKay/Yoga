//
//  TapTranslator.m
//  SimpleSong
//
//  Created by Jason Snell on 6/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "LocationInstrumentTranslator.h"
#import "Instrument.h"
#import "Orchestra.h"

@implementation LocationInstrumentTranslator

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(LocationInstrumentTranslator);

- (id)initWithHeight:(uint)height {
	self = [super init];
	if (self != nil) {
		//calculate height of buttons based on total number of instruments in orchestra and height of playPad
		buttonHeight = height / [[Orchestra sharedOrchestra] instrumentTotal];
	}
	
	return self;
} //init

- (void) dealloc {
	[super dealloc];
} //dealloc


- (Instrument *) getInstrumentFromPoint:(CGPoint)touchPoint {
	
	//grab y loc from touchpoint set
	int yLoc = touchPoint.y;	
	
	//calc slot num by dividing y location by button height. Int rounds it down automatically
	int slotNum = yLoc / buttonHeight;
	
	//get instrument from orchestra via slot num
	Instrument *selectedInstrument = [[Orchestra sharedOrchestra] getInstrumentFromSlotNumber:slotNum];
	
	//return instr
	return selectedInstrument;
	
} // getInstrumentFromPoint

- (CGPoint) getPointFromInstrument:(Instrument *)instrument {
	
	//get slot number of instrument from orchestra
	
	int slotNum = [[Orchestra sharedOrchestra] getSlotNumberFromInstrument:instrument];
	
	//calc yLoc from slot num
	float yLoc = slotNum * buttonHeight;
	
	//random x based on screen width
	float xLoc = arc4random() % 300;
	xLoc += 10;
	
	//make CGpoint and return
	CGPoint point = CGPointMake(xLoc, yLoc);
	return point;

} // getInstrumentFromPoint



@end
