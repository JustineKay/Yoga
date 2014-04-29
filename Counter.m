//
//  Counter.m
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//


#import "Counter.h"
#import "Instrument.h"

#pragma mark private method headers
@interface Counter (Private)
//private method headers
- (void) setTotal:(int)totalInt ofInstrument:(Instrument *)instrument ofType:(uint)type;
@end

@implementation Counter

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Counter);

#pragma mark init
- (void) initForInstruments:(NSArray *)instrumentArray{
	
	//init arrays
	 
	for (int i = 0; i < instrumentArray.count; i++){
		manualTotals[i] = 0;
		autoTotals[i] = 0;
	}
	
} //initForInstrument

- (void) dealloc {
	[super dealloc];
} //dealloc

#pragma mark retrival
- (uint) getTotalOfInstrument:(Instrument *)instrument ofType:(uint)type{
	
	//init total
	uint total;
	
	//manual notes
	if (type == 0){
		total = manualTotals[instrument.slot];
		
	//auto
	} else if (type == 1){
		total = autoTotals[instrument.slot];
		
	//error handling
	} else {
		NSLog(@"ERR_PROCESSING_NOTE_TYPE - COUNTER - GET TOTAL");
		total = -1;
	}

	//return value
	return total;
	
} //getTotalOfInstrument


#pragma mark add
- (uint) addInstrument:(Instrument *)instrument ofType:(uint)type{

	//grab value from accessor method
	uint total = [self getTotalOfInstrument:instrument ofType:type];
	
	//increase total
	total++;
	
	//NSLog(@"ADD ++ %i: %@: %d", type, instrument.key, total);
	
	//put back in array
	[self setTotal:total ofInstrument:instrument ofType:type];
	
	return total;
	
} //addInstrument


#pragma mark remove
- (uint) removeInstrument:(Instrument *)instrument ofType:(uint)type{
	
	
	//grab value from accessor method
	uint total = [self getTotalOfInstrument:instrument ofType:type];
	
	//decrease total
	total--;
	
	//NSLog(@"SUB -- %i: %@: %d", type, instrument.key, total);
	
	if (total < 0)
		NSLog(@"ERR_INSTRUMENT_TOTAL_HAS_DROPPED_BELOW_ZERO: %@", instrument.key);

	
	//put back in array
	[self setTotal:total ofInstrument:instrument ofType:type];
	
	return total;

} //removeInstrument

#pragma mark -
#pragma mark private

- (void) setTotal:(int)total ofInstrument:(Instrument *)instrument ofType:(uint)type{
	
	//manual notes
	if (type == 0){
		manualTotals[instrument.slot] = total;
		
	//auto
	} else if (type == 1){
		autoTotals[instrument.slot] = total;
		
	//error handling
	} else {
		NSLog(@"ERR_PROCESSING_NOTE_TYPE - COUNTER - SET TOTAL");
		total = -1;
	}

}


@end
