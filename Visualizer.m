//
//  NoteManager.m
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Visualizer.h"
#import "Note.h"
#import "VisualizerImage.h"
#import "Instrument.h"
#import "Orchestra.h"
#import "Tempo.h"

#pragma mark private method headers
@interface Visualizer (Private)

//private method headers

- (void) initGlows;

- (void) dimGlowForInstrument:(Instrument *)instrument;

- (float) getNoteYFromSlot:(uint)slot;

@end

@implementation Visualizer

@synthesize scrollSpeed;

SYNTHESIZE_SINGLETON_FOR_CLASS(Visualizer);

#pragma mark base
- (void)dealloc {
	//release objects
	[notesOnScreen release];
	[glowsOnScreen release];
	[super dealloc];
}

- (id)init {
	self = [super init];
	if(self != nil) {
		
		scrollSpeed = [[Tempo sharedTempo] speed] / 40;
		
		notesOnScreen = [[NSMutableArray alloc] initWithCapacity:24];
		
		instrumentTotal = [Orchestra sharedOrchestra].instrumentTotal;
		
		[self initGlows];
			
	}
	return self;
}

#pragma mark -
#pragma mark notes
- (void) addImageForNote:(Note *)note{
	
	//init note image
	VisualizerImage *noteImage = [[VisualizerImage alloc] initWithImage:@"note_up.png"];
	noteImage.blendSFactor = GL_SRC_ALPHA;
	noteImage.blendDFactor = GL_ONE_MINUS_SRC_ALPHA;
	noteImage.instrument = note.instrument;
	noteImage.y = [self getNoteYFromSlot: note.instrument.slot];
	if (note.userTouched){
		noteImage.x = note.point.x;
	} else {
		noteImage.x = 280;
	}
	
	//add to array
	[notesOnScreen addObject:noteImage];
	
	//release because the array is now holding on to it
	[noteImage release];
	
	//add glow each time a note is added
	[self addGlowForInstrument:noteImage.instrument];
	
}

#pragma mark open GL
- (void)updateWithDelta:(GLfloat)aDelta{
	
	//notes
	
	for (uint n = 0; n < notesOnScreen.count; n++){
		VisualizerImage *noteImage = [notesOnScreen objectAtIndex:n];
		noteImage.x -= scrollSpeed;
		
		//alpha
		float alpha = [noteImage getAlpha];
		alpha -= noteImage.instrument.visualFade / [[Tempo sharedTempo] speed];
		[noteImage setAlpha:alpha];
		
		//if note disappears
		if (alpha <= 0 || noteImage.x < 50){
		
			//and turn off glow
			[self dimGlowForInstrument:noteImage.instrument];
			
			//remove from note array
			[notesOnScreen removeObject:noteImage];
			
		}
		
	}
	
	//glows
	
	for (uint g = 0; g < instrumentTotal; g++){
		
		//loop through switchboard
		uint glowStatus = glowSwitchboard[g];
		
		//if a glow is in 2 or 3 / fade in or out...
		if (glowStatus == 2 || glowStatus == 3){
			
			// grab it from array
			VisualizerImage *glow = [glowsOnScreen objectAtIndex:g];
			
			//run fade script
			BOOL fadeComplete = [glow fade:aDelta];
			
			//when fade script is complete, switch status to 1 / on
			if (fadeComplete){
				
				//if it was fading in / 2, switch to on / 1
				if (glowStatus == 2){
					glowSwitchboard[g] = 1;
					
					//else if it was fading out / 3, switch to off / 0
				} else if (glowStatus == 3){
					glowSwitchboard[g] = 0;
				}
					
			}
				  
		}
	}
	
}

- (void)render{
	
	//render notes
	for (uint n = 0; n < notesOnScreen.count; n++){
		VisualizerImage *noteImage = [notesOnScreen objectAtIndex:n];
		[noteImage renderAtPoint:CGPointMake(noteImage.x, noteImage.y) centerOfImage:NO];
	}
	
	//render glows
	for (uint g = 0; g < glowsOnScreen.count; g++){
		VisualizerImage *glow = [glowsOnScreen objectAtIndex:g];
		[glow renderAtPoint:CGPointMake(glow.x, glow.y) centerOfImage:NO];
	}
	
}

#pragma mark glows

- (void) addGlowForInstrument:(Instrument *)instrument{
	
	//gets switch status from instrument ID
	uint glowStatus = glowSwitchboard[instrument.slot];
	
	//if glow is 0 / off or 3 / fading out
	if (glowStatus == 0 || glowStatus == 3) {
		//if (glowStatus == 0) {
		
		//turn to 2 / fade in
		glowSwitchboard[instrument.slot] = 2;
		
		//get glow image
		VisualizerImage *glow = [glowsOnScreen objectAtIndex:instrument.slot];
		
		//begin show / fade in anim
		[glow show];
		
	}
	
} //addGlowForInstrument

- (void) removeGlowForInstrument:(Instrument *)instrument{
	
	//turn to 3 / fade out
	glowSwitchboard[instrument.slot] = 3;
		
	//get glow image
	VisualizerImage *glow = [glowsOnScreen objectAtIndex:instrument.slot];
		
	//begin hide / fade out anim
	[glow hide];

}

#pragma mark -
#pragma mark private accessors

- (void) initGlows{
	//array to hold images
	glowsOnScreen = [[NSMutableArray alloc] initWithCapacity:instrumentTotal];
	
	// 0 = off
	// 1 = on
	// 2 = fadeIn
	// 3 = fadeOut
	
	//init switchboard and fill array with images (on standby, hidden)
	for (uint i = 0; i < instrumentTotal; i++){
		
		//set all status to zero / off
		glowSwitchboard[i] = 0;
		
		//create glow image
		VisualizerImage *glow = [[VisualizerImage alloc] initWithImage:@"glow.png"];
		
		//position it
		glow.x = 7;
		glow.y = i * 39 + 12;
		
		//hide image
		[glow setAlpha:0.0];
		
		//add to array
		[glowsOnScreen addObject:glow];
		
		//release becase the array is now holding on to it
		[glow release];
		
		
	}
	
}

- (void) dimGlowForInstrument:(Instrument *)instrument{
	
	//gets switch status from instrument ID
	uint glowStatus = glowSwitchboard[instrument.slot];
	
	//if glow is 1 / on or 2 / fading in
	if (glowStatus == 1 || glowStatus == 2) {
		//if (glowStatus == 1) {	
		
		//turn to 3 / fade out
		glowSwitchboard[instrument.slot] = 3;
		
		//get glow image
		VisualizerImage *glow = [glowsOnScreen objectAtIndex:instrument.slot];
		
		//begin hide / fade out anim
		[glow dim];
		
	}
	
} //removeGlowForInstrument


#pragma mark  misc

-(float)getNoteYFromSlot:(uint)slot{
	
	return 39 * slot + 23;
}


@end
