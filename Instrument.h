//
//  Instrument.h
//  SimpleSong
//
//  Created by Jason Snell on 6/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instrument : NSObject {
	
	//OPEN AL
	NSString *key; //id for OpenAL
	int sourceID; //which slot the instrument plays in out of 32. -1 dynamically finds a slot
	NSMutableArray *protectedSources;
	BOOL areSourcesProtected;
	
	//AUTOFILL
	BOOL autoFillEnabled; //does the instrument have autofill?
	BOOL autoFillActive; //are autofill notes currently active in song?
	int autoFillSlots; // number of different sequences to choose from
	uint autoFillMin; // low average number of notes in an autofill sequence
	int autoFillPositions[8][16]; //array to hold sequences
	
	//ARRANGEMENT
	BOOL instantPlay; //does the instrument play instantly when quantized to a previous position, or wait until the next round?
	uint repeatEveryHowManyMeasures; //1 = every measure, 4 = once every 4 measures
	uint quantization; //called when adding a note. Helps position note in Song. 4 = quantize to quarter note, 8 = quantize to 1/8 note, etc
	uint noteMax; //called when adding a note to see if old ones need to be cleared
	BOOL instantRemoval; //when note max is hit, does the instrument get removed instantly, or do they fade out and get removed when their volume reaches playMinimum?
	//uint rejuvenateThreshold;//when total notes drops below this, allow rejunator to reset manual notes
	
	//VOLUME
	float volumeFade; //amount that instrument volume reduces on each repeat
	float manualMaxVolume; //randomly generated volumes fall between these manual and auto maximums and minimums
	float manualMinVolume; 
	float autoMaxVolume; 
	float autoMinVolume; 
	float playMinVolume; //note volume has to be at least this to still play. Fall below and it is removed.
	
	//PITCH
	float minPitch; //randomly generated pitches fall between these maximums and minimums
	float maxPitch;
	float pitchInc; //increment between randomly generated pitches
	BOOL variedPitch; //does the sound accept randomized pitches?
	BOOL randomPitch; //is pitch random each time note is played?
	
	//PAN
	float pan;
	
	//VISUAL
	float visualFade;
	BOOL visualOutput;
	
	//GENERAL
	uint slot;
	
}

#pragma mark -
#pragma mark openAL
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) int sourceID;
@property (readwrite) BOOL areSourcesProtected;
@property (nonatomic, retain) NSMutableArray *protectedSources;

#pragma mark autofill
@property (readwrite) BOOL autoFillEnabled;
@property (readwrite) BOOL autoFillActive;
@property (nonatomic, assign) uint autoFillMin;
@property (nonatomic, assign) int autoFillSlots;

#pragma mark pitch
@property (nonatomic, assign) float maxPitch;
@property (nonatomic, assign) float minPitch;
@property (nonatomic, assign) float pitchInc;
@property (readwrite) BOOL variedPitch;
@property (readwrite) BOOL randomPitch;

#pragma mark volume
@property (nonatomic, assign) float manualMaxVolume;
@property (nonatomic, assign) float manualMinVolume;
@property (nonatomic, assign) float autoMaxVolume;
@property (nonatomic, assign) float autoMinVolume;
@property (nonatomic, assign) float volumeFade;
@property (nonatomic, assign) float playMinVolume;

#pragma mark arrangement
@property (nonatomic, assign) uint quantization;
@property (readwrite) BOOL instantPlay;
@property (nonatomic, assign) uint repeatEveryHowManyMeasures;
@property (nonatomic, assign) uint noteMax;
//@property (nonatomic, assign) uint rejuvenateThreshold;

#pragma mark pan
@property (nonatomic, assign) float pan;

#pragma mark visuals
@property (nonatomic, assign) float visualFade;
@property (readwrite) BOOL visualOutput;

#pragma mark general
@property (nonatomic, assign) uint slot;


#pragma mark -
#pragma mark methods
- (id) initWithKey:(NSString *)_key fileName:(NSString *)_fileName fileExt:(NSString *)_fileExt;
- (int) playAtVolume:(float)volume atPitch:(float)pitch;
- (float) getRandomVolumeForType:(uint)type;
- (float) getRandomPitch;

- (void) setAutoFillPositions:(int *)positions intoColumn:(int)column;
- (int) getAutoFillPosition:(int)position fromColumn:(int)slot;
- (int) getPlaySourceID;

- (void) addProtectedSource:(int) source;
- (void) removeProtectedSource:(int) source;


@end
