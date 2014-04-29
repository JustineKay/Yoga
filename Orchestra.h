//
//  Orchestra.h
//  MusicMaker
//
//  Created by Jason Snell on 6/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Instrument;
@class MultiInstrument;
@class BackgroundLoop;

@interface Orchestra : NSObject {
	
	NSArray *instrumentArray;
	uint userSelectedInstruments[15];
	uint instrumentTotal;
	
	uint instrumentOverloadCount;
	uint instrumentOverloadMax;
	
	Instrument *djembe;
	Instrument *doumbek;	
	Instrument *gamelan;
	MultiInstrument *gong;
	MultiInstrument *om;
	MultiInstrument *sitar;
	BackgroundLoop *synth;
	Instrument *tablaLow;
	Instrument *talkingDrum;
	Instrument *tambourine;
	Instrument *tibetHigh;
	Instrument *tibetLow;
	Instrument *shaker;
	Instrument *shakerRoll;
	

}

@property (nonatomic, retain) NSArray *instrumentArray;
@property (nonatomic, assign) uint instrumentTotal;
@property (nonatomic, retain) Instrument *djembe;
@property (nonatomic, retain) Instrument *doumbek;
@property (nonatomic, retain) Instrument *gamelan;
@property (nonatomic, retain) MultiInstrument *gong;
@property (nonatomic, retain) MultiInstrument *om;
@property (nonatomic, retain) MultiInstrument *sitar;
@property (nonatomic, retain) BackgroundLoop *synth;
@property (nonatomic, retain) Instrument *tablaLow;
@property (nonatomic, retain) Instrument *talkingDrum;
@property (nonatomic, retain) Instrument *tambourine;
@property (nonatomic, retain) Instrument *tibetHigh;
@property (nonatomic, retain) Instrument *tibetLow;
@property (nonatomic, retain) Instrument *shaker;
@property (nonatomic, retain) Instrument *shakerRoll;

+ (Orchestra *)sharedOrchestra;

- (Instrument *) getInstrumentFromSlotNumber:(int)slotNum;
- (int) getSlotNumberFromInstrument:(Instrument *)instrument;
- (Instrument *) getRandomInstrument;
- (void) sourceOverload;
- (void) addUserSelectedInstrument:(Instrument *)instrument;
- (void) removeUserSelectedInstrument:(Instrument *)instrument;
- (Instrument *) getRandomUserSelectedInstrument;

/*
- (Instrument *) getInstrumentWithKey:(NSString *)key;

- (NSArray *) getInstrumentsInCategory:(NSString *)categoryName;

*/




@end
