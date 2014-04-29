//
//  Note.m
//  SimpleSong
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Note.h"
#import "Instrument.h"
#import "Conductor.h"
#import "Counter.h"
#import "Song.h"
#import "Orchestra.h"
#import "Creator.h"
#import "Repeater.h"
#import "Cleaner.h"
#import "Rejuvenator.h"
#import "Visualizer.h"
#import "LocationInstrumentTranslator.h"

#pragma mark private method headers
@interface Note (Private)
//private method headers
- (void) protectSource:(uint)newSourceID;

@end

@implementation Note

@synthesize instrument;
@synthesize measure;
@synthesize beat;
@synthesize point;
@synthesize volume;
@synthesize pitch;
@synthesize type;
@synthesize userTouched;

- (id) init{
	
	if (self = [super init]) {
		sourceID = 0;
	}
	
	return self;
}//init

- (void) dealloc {
	[super dealloc];
} //dealloc

- (id) copyWithZone:(NSZone *)zone {
	Note *copy = [[[self class] allocWithZone:zone] initWithNote:self];
	return copy;
}//copyWithZone

- (Note *) initWithNote:(Note *) copyFrom {
	//pass params over here
	instrument = copyFrom.instrument;
	measure = copyFrom.measure;
	beat = copyFrom.beat;
	point = copyFrom.point;
	volume = copyFrom.volume;
	pitch = copyFrom.pitch;
	type = copyFrom.type;
	sourceID = 0;
	[self retain];
	return self;
}

- (void) play {
	
	//NSLog(@"PLAYNOTE: %d:%d: %@", measure, beat, instrument.key);
	
	//grab fade amount
	float fade = instrument.volumeFade;
	
	//reduce volume so each time loop gets quieter
	volume -= fade;
	
	//send to visualizer if instrument has visual output
	if (instrument.visualOutput){
		[[Visualizer sharedVisualizer] addImageForNote:self];
	}
	
	//reset so it doesn't appear in mid screen again
	userTouched = NO;
	
	// use random pitch if instrument is set as such
	float playPitch;
	if (instrument.randomPitch){
		playPitch = [instrument getRandomPitch];
	
	//otherwise use the note's pitch as set during note creation
	} else {
		playPitch = pitch;
	}
	
	//play instrument and get back open AL source ID slot
	int newSourceID = [instrument playAtVolume:volume atPitch:playPitch];

	//don't process notes that get blocked by open AL overload in instrument class
	if (newSourceID == -1)
		return;

	//testing only
	/*
	if (instrument.visualOutput){
		//NSLog(@"NOTE PLAY ///// ");
		//NSLog(@"Play note of %@ at %d:%d", instrument.key, measure, beat);
		//NSLog(@"vol = %f, pitch = %f, source = %i", volume, pitch, newSourceID);
	}
	 */
	
	//protect note source if instrument is set to protect its sources
	if (instrument.areSourcesProtected)
		[self protectSource: newSourceID];
	
	
	

} //play

-(void) refresh {
	
	volume = [instrument getRandomVolumeForType:type];
	pitch = [instrument getRandomPitch];
	
	if (type == 1 && userTouched){
		
		//NSLog(@"CV A > M: %@", instrument.key);
		//if this note was an auto note...
		
		//convert it to manual
		type = 0; //turn into a manual note since it's now input via a user tap
	
		// move note count from auto totals to manual totals
		[[Counter sharedCounter] removeInstrument:instrument ofType:1];
		[[Counter sharedCounter] addInstrument:instrument ofType:0];
		
	}
	
} //refresh


#pragma mark -
#pragma mark private methods

- (void) protectSource:(uint) newSourceID {
	
	//if this is a new id for this note...
	if (newSourceID != sourceID){
		
		//then release the old note
		[instrument removeProtectedSource:sourceID];
		
		//and add the new
		[instrument addProtectedSource:newSourceID];
		
		//update sourceID for next time note is played
		sourceID = newSourceID;
	}
}

@end
