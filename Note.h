//
//  Note.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Instrument;
@class Song;

@interface Note : NSObject <NSCopying> {
	Instrument *instrument;//type of sound
	uint measure;//location in song
	uint beat;
	CGPoint point; // location of visual feedback on screen
	float volume;//gain of instrument
	float pitch;//pitch of instrument
	uint type;//0=manual, 1=auto
	uint sourceID;//most recent slot in open AL
	BOOL userTouched; //is this note created directly from a user touch?
}

#pragma mark -
#pragma mark properties
@property (nonatomic, retain) Instrument *instrument;
@property (nonatomic, assign) uint measure;
@property (nonatomic, assign) uint beat;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float pitch;
@property (nonatomic, assign) uint type;
@property (readwrite) BOOL userTouched;

#pragma mark -
#pragma mark methods

- (id)copyWithZone:(NSZone *) zone;
- (Note *)initWithNote:(Note *) copyFrom;
- (void) play;
- (void) refresh;

@end
