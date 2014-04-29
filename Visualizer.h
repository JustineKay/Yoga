//
//  NoteManager.h
//  Yoga
//
//  Created by Jason Snell on 9/20/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"

@class Note;
@class Instrument;

@interface Visualizer : NSObject {
	
	uint instrumentTotal;
	
	//tracking arrays
	NSMutableArray *notesOnScreen;
	NSMutableArray *glowsOnScreen;
	
	uint glowSwitchboard[15];
	
	float scrollSpeed;
}

@property (nonatomic, assign) float scrollSpeed;

- (void) addImageForNote:(Note *)note;
- (void) addGlowForInstrument:(Instrument *)instrument;
- (void) removeGlowForInstrument:(Instrument *)instrument;

- (void) updateWithDelta:(GLfloat)aDelta;
- (void) render;

+ (Visualizer *) sharedVisualizer;

@end
