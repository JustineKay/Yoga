//
//  Orchestra.m
//  MusicMaker
//
//  Created by Jason Snell on 6/5/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "Orchestra.h"
#import "Instrument.h"
#import "MultiInstrument.h"
#import "BackgroundLoop.h"
#import "Counter.h"
#import "SoundManager.h"


#pragma mark private method headers
@interface Orchestra (Private)
//private method headers
- (void) loadInstruments;
- (void) setSources;
- (void) setVolumes;
- (void) setPitches;
- (void) setAutoFills;
- (void) setArrangement;
- (void) setPans;
- (void) setInstrumentList;
- (void) setVisuals;

@end


@implementation Orchestra

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Orchestra);

@synthesize instrumentArray;
@synthesize instrumentTotal;
@synthesize djembe;
@synthesize doumbek;
@synthesize gamelan;
@synthesize gong;
@synthesize om;
@synthesize sitar;
@synthesize synth;
@synthesize tablaLow;
@synthesize talkingDrum;
@synthesize tambourine;
@synthesize tibetHigh;
@synthesize tibetLow;
@synthesize shaker;
@synthesize shakerRoll;

- (id) init {
	
	if (self = [super init]) {		
		
		[self loadInstruments];
		[self setSources];
		[self setAutoFills];
		[self setVolumes];
		[self setPitches];
		[self setArrangement];
		[self setPans];
		[self setInstrumentList];
		[self setVisuals];
		
	}
	
	return self;
}

- (void) dealloc {
	[instrumentArray release];
	[synth release];
	[gong release];
	[om release];
	[tibetLow release];
	[tablaLow release];
	[doumbek release];
	[tibetHigh release];
	[djembe release];
	[sitar release];
	[talkingDrum release];
	[shaker release];
	[shakerRoll release];
	[tambourine release];
	[gamelan release];
	[super dealloc];
}

#pragma mark -
#pragma mark accessors

- (Instrument *) getInstrumentFromSlotNumber:(int)slotNum{

	if (slotNum >= instrumentArray.count)
		slotNum = instrumentArray.count-1;
	
	if (slotNum < 0)
		slotNum = 0;
		
	return [instrumentArray objectAtIndex:slotNum];
	
} // getInstrumentWithSlotNum

- (int) getSlotNumberFromInstrument:(Instrument *)instrument{
	
	return [instrumentArray indexOfObject:instrument];
	
} // getInstrumentWithSlotNum

- (Instrument *) getRandomInstrument{
	//pick a random instrument id
	uint randomInstrumentID = arc4random() % instrumentArray.count;
	//and grab it from instr array
	return [instrumentArray objectAtIndex:randomInstrumentID];
	
} //getRandomInstrument

#pragma mark user selected instruments
- (void)addUserSelectedInstrument:(Instrument *)instrument{
	
	//change instrument marker in array from 0 (not used) to 1 (used)
	uint instrumentID = instrument.slot;
	userSelectedInstruments[instrumentID] = 1;
	
}

- (void) removeUserSelectedInstrument:(Instrument *)instrument{
	
	//change instrument marker in array from 1 (used) to 0 (not used)
	uint instrumentID = instrument.slot;
	userSelectedInstruments[instrumentID] = 0;
	
}

- (Instrument *) getRandomUserSelectedInstrument{
	
	uint randomSlot;
	uint instrumentStatus = 0;
	uint noInstrumentFoundCount = 0;
	
	do {
		
		//grab random slot
		randomSlot = arc4random() % instrumentArray.count;
		
		//get status from that slot
		instrumentStatus = userSelectedInstruments[randomSlot];
		
		// if loop happens 20 times and no instrument is found, give up search
		// there may be no instruments playing
		noInstrumentFoundCount++;
		
		if (noInstrumentFoundCount > 16){
			return nil;
			break;
		}
	
	} while (instrumentStatus == 0);
	
	return [self getInstrumentFromSlotNumber:randomSlot];
	
}


#pragma mark -
#pragma mark private methods

#pragma mark load instruments

- (void) loadInstruments{
	synth = [[BackgroundLoop alloc] initWithKey:@"synth" fileName:@"foundation_synth" fileExt:@"aif"];
	tibetLow = [[Instrument alloc] initWithKey:@"tibetLow" fileName:@"tibet_low" fileExt:@"caf"];
	tablaLow = [[Instrument alloc] initWithKey:@"tablaLow" fileName:@"tabla_low" fileExt:@"caf"];
	doumbek = [[Instrument alloc] initWithKey:@"doumbek" fileName:@"doumbek" fileExt:@"caf"];
	tibetHigh = [[Instrument alloc] initWithKey:@"tibetHigh" fileName:@"tibet_high" fileExt:@"caf"];
	djembe = [[Instrument alloc] initWithKey:@"djembe" fileName:@"djembe" fileExt:@"caf"];
	talkingDrum = [[Instrument alloc] initWithKey:@"talkingDrum" fileName:@"talking_drum_quiet" fileExt:@"caf"];
	shaker = [[Instrument alloc] initWithKey:@"shaker" fileName:@"shaker" fileExt:@"caf"];
	shakerRoll = [[Instrument alloc] initWithKey:@"shakerRoll" fileName:@"shaker_roll" fileExt:@"caf"];
	tambourine = [[Instrument alloc] initWithKey:@"tambourine" fileName:@"tambourine" fileExt:@"caf"];
	gamelan = [[Instrument alloc] initWithKey:@"gamelan" fileName:@"gamelan" fileExt:@"caf"];
	sitar = [[MultiInstrument alloc] initWithKey:@"sitar1" fileName:@"sitar_c_1" fileExt:@"caf"];
	[sitar addSoundWithKey:@"sitar2" fileName:@"sitar_c_2" fileExt:@"caf"];
	[sitar addSoundWithKey:@"sitar3" fileName:@"sitar_c_3" fileExt:@"caf"];
	[sitar addSoundWithKey:@"sitar4" fileName:@"sitar_c_4" fileExt:@"caf"];
	[sitar addSoundWithKey:@"sitar5" fileName:@"sitar_c_5" fileExt:@"caf"];
	[sitar addSoundWithKey:@"sitar6" fileName:@"sitar_c_6" fileExt:@"caf"];
	[sitar addSoundWithKey:@"sitar7" fileName:@"sitar_c_7" fileExt:@"caf"];
	//om as single
	//om = [[Instrument alloc] initWithKey:@"om" fileName:@"om" fileExt:@"caf"];
	// om as multi 
	om = [[MultiInstrument alloc] initWithKey:@"om1" fileName:@"om1" fileExt:@"caf"];
	[om addSoundWithKey:@"om2" fileName:@"om2" fileExt:@"caf"];
	[om addSoundWithKey:@"om3" fileName:@"om3" fileExt:@"caf"];
	//gong as single
	//gong = [[Instrument alloc] initWithKey:@"gong" fileName:@"gong" fileExt:@"caf"];
	// gong as multi 
	gong = [[MultiInstrument alloc] initWithKey:@"gong1" fileName:@"gong1" fileExt:@"caf"];
	[gong addSoundWithKey:@"gong2" fileName:@"gong2" fileExt:@"caf"];
	[gong addSoundWithKey:@"gong3" fileName:@"gong3" fileExt:@"caf"];
	
}

#pragma mark insturment lists
- (void) setInstrumentList{
	//INIT ARRAY AND TOTAL
	instrumentArray = [[NSArray alloc]initWithObjects:gong, om, tibetLow, tablaLow, gamelan, doumbek, tibetHigh, djembe, talkingDrum, tambourine, sitar, nil];
	instrumentTotal = instrumentArray.count;
	
	//assign visual slot numbers into instrument objects
	for (int i = 0; i < instrumentArray.count; i++){
		Instrument *instrument = [instrumentArray objectAtIndex:i];
		instrument.slot = i;
		instrument.visualOutput = YES;
		
		//also init user selected insturment array to zeroes
		userSelectedInstruments[i] = 0;
	}
	
	//COUNTER
	[[Counter sharedCounter] initForInstruments:instrumentArray];
}

#pragma mark sources
- (void) setSources{
	synth.sourceID = [[SoundManager sharedSoundManager] nextAvailableSource];
	om.areSourcesProtected = YES;
	gong.areSourcesProtected = YES;
	sitar.areSourcesProtected = YES;
	gamelan.areSourcesProtected = YES;
	instrumentOverloadCount = 0;
	instrumentOverloadMax = 10;
}

- (void) sourceOverload{
	instrumentOverloadCount++;
	if (instrumentOverloadCount >= instrumentOverloadMax){
		
		NSLog(@"RESETSRC: OpenAL reset");
		
		//reset count
		instrumentOverloadCount = 0;
		
		// init array
		NSMutableArray *protectedSources = [[NSMutableArray alloc] initWithCapacity:10];
		
		//prep values and pass into array
		NSNumber *synthSource = [[NSNumber alloc] initWithInt:synth.sourceID];
		[protectedSources addObject:synthSource];
		[protectedSources addObjectsFromArray: om.protectedSources];
		[protectedSources addObjectsFromArray: gong.protectedSources];
		[protectedSources addObjectsFromArray: gamelan.protectedSources];
		[protectedSources addObjectsFromArray: sitar.protectedSources];
		
		//send array to sound manager
		[[SoundManager sharedSoundManager] resetSourcesExcept:protectedSources];
		
		//release array
		[protectedSources release];
	}
}

#pragma mark visuals
- (void) setVisuals{
	
	sitar.visualFade = 0.25;
	tambourine.visualFade = 1.5;
	talkingDrum.visualFade = 1.2;
	djembe.visualFade = 1.9;
	tibetHigh.visualFade = 1.2;
	doumbek.visualFade = 1.5;
	gamelan.visualFade = 0.35;
	tablaLow.visualFade = 0.8;
	tibetLow.visualFade = 1.2;
	om.visualFade = 0.25;
	gong.visualFade = 0.25;
	
}


#pragma mark autofills
- (void) setAutoFills{
	//default autoFill = YES;
	
	//instruments with no autofill
	om.autoFillEnabled = NO;
	sitar.autoFillEnabled = NO;
	gamelan.autoFillEnabled = NO;
	gong.autoFillEnabled = NO;
	
	//TIBET LOW
	int tibetLowAF0[16] = {8,14,-1};
	int tibetLowAF1[16] = {8,12,14,-1};
	int tibetLowAF2[16] = {0,8,14,-1};
	int tibetLowAF3[16] = {7,8,14,-1};
	int tibetLowAF4[16] = {7,8,12,14,-1};
	int tibetLowAF5[16] = {7,8,13,14,-1};
	int tibetLowAF6[16] = {7,8,12,14,15,-1};
	int tibetLowAF7[16] = {8,12,13,15,-1};
	int tibetLowAF8[16] = {8,13,14,-1};
	
	[tibetLow setAutoFillPositions:tibetLowAF0 intoColumn:0];
	[tibetLow setAutoFillPositions:tibetLowAF1 intoColumn:1];
	[tibetLow setAutoFillPositions:tibetLowAF2 intoColumn:2];
	[tibetLow setAutoFillPositions:tibetLowAF3 intoColumn:3];
	[tibetLow setAutoFillPositions:tibetLowAF4 intoColumn:4];
	[tibetLow setAutoFillPositions:tibetLowAF5 intoColumn:5];
	[tibetLow setAutoFillPositions:tibetLowAF6 intoColumn:6];
	[tibetLow setAutoFillPositions:tibetLowAF7 intoColumn:7];
	[tibetLow setAutoFillPositions:tibetLowAF8 intoColumn:8];
	
	tibetLow.autoFillMin = 2;
	tibetLow.autoFillSlots = 9;
	
	//TABLA LOW
	
	int tablaLowAF0[16] = {0,-1};
	int tablaLowAF1[16] = {0,14,-1};
	int tablaLowAF2[16] = {0,1,12,14,-1};
	int tablaLowAF3[16] = {0,1,3,13,15,-1};
	int tablaLowAF4[16] = {0,1,13,15,-1};
	int tablaLowAF5[16] = {0,13,15,-1};
	int tablaLowAF6[16] = {0,15,-1};
	int tablaLowAF7[16] = {0,1,3,7,8,13,15,-1};
	
	[tablaLow setAutoFillPositions:tablaLowAF0 intoColumn:0];
	[tablaLow setAutoFillPositions:tablaLowAF1 intoColumn:1];
	[tablaLow setAutoFillPositions:tablaLowAF2 intoColumn:2];
	[tablaLow setAutoFillPositions:tablaLowAF3 intoColumn:3];
	[tablaLow setAutoFillPositions:tablaLowAF4 intoColumn:4];
	[tablaLow setAutoFillPositions:tablaLowAF5 intoColumn:5];
	[tablaLow setAutoFillPositions:tablaLowAF6 intoColumn:6];
	[tablaLow setAutoFillPositions:tablaLowAF7 intoColumn:7];

	tablaLow.autoFillMin = 1;
	tablaLow.autoFillSlots = 8;
	
	//DOUMBEK
	int doumbekAF0[16] = {0,1,13,-1};
	int doumbekAF1[16] = {0,13, -1};
	int doumbekAF2[16] = {1,13,-1};
	int doumbekAF3[16] = {1,11,13,-1};
	int doumbekAF4[16] = {0,11, -1};
	int doumbekAF5[16] = {1,11,-1};
	
	[doumbek setAutoFillPositions:doumbekAF0 intoColumn:0];
	[doumbek setAutoFillPositions:doumbekAF1 intoColumn:1];
	[doumbek setAutoFillPositions:doumbekAF2 intoColumn:2];
	[doumbek setAutoFillPositions:doumbekAF3 intoColumn:3];
	[doumbek setAutoFillPositions:doumbekAF4 intoColumn:4];
	[doumbek setAutoFillPositions:doumbekAF5 intoColumn:5];
	
	doumbek.autoFillMin = 2;
	doumbek.autoFillSlots = 6;
	
	//TIBET HIGH
	int tibetHighAF0[16] = {0,2,12,14,-1};
	int tibetHighAF1[16] = {0,1,2,12,14,-1};
	int tibetHighAF2[16] = {0,2,12,13,-1};
	int tibetHighAF3[16] = {0,2,12,13,15,-1};
	
	[tibetHigh setAutoFillPositions:tibetHighAF0 intoColumn:0];
	[tibetHigh setAutoFillPositions:tibetHighAF1 intoColumn:1];
	[tibetHigh setAutoFillPositions:tibetHighAF2 intoColumn:2];
	[tibetHigh setAutoFillPositions:tibetHighAF3 intoColumn:3];
	
	tibetHigh.autoFillMin = 4;
	tibetHigh.autoFillSlots = 4;
	
	//DJEMBE
	int djembeAF0[16] = {5,13,-1};
	int djembeAF1[16] = {2,3,5,10,13,-1};
	int djembeAF2[16] = {5,10,11,13,-1};
	int djembeAF3[16] = {5,13,14,-1};
	int djembeAF4[16] = {5,7,14,-1};
	
	[djembe setAutoFillPositions:djembeAF0 intoColumn:0];
	[djembe setAutoFillPositions:djembeAF1 intoColumn:1];
	[djembe setAutoFillPositions:djembeAF2 intoColumn:2];
	[djembe setAutoFillPositions:djembeAF3 intoColumn:3];
	[djembe setAutoFillPositions:djembeAF4 intoColumn:4];
	
	djembe.autoFillMin = 2;
	djembe.autoFillSlots = 5;
	
	//TALKING DRUM
	int talkingDrumAF0[16] = {4,12,-1};
	int talkingDrumAF1[16] = {4,7,12,-1};
	int talkingDrumAF2[16] = {4,7,10,12,-1};
	int talkingDrumAF3[16] = {2,4,7,10,12,-1};
	int talkingDrumAF4[16] = {3,4,12,-1};
	int talkingDrumAF5[16] = {4,11,12,-1};
	int talkingDrumAF6[16] = {3,4,11,12,-1};
	
	[talkingDrum setAutoFillPositions:talkingDrumAF0 intoColumn:0];
	[talkingDrum setAutoFillPositions:talkingDrumAF1 intoColumn:1];
	[talkingDrum setAutoFillPositions:talkingDrumAF2 intoColumn:2];
	[talkingDrum setAutoFillPositions:talkingDrumAF3 intoColumn:3];
	[talkingDrum setAutoFillPositions:talkingDrumAF4 intoColumn:4];
	[talkingDrum setAutoFillPositions:talkingDrumAF5 intoColumn:5];
	[talkingDrum setAutoFillPositions:talkingDrumAF6 intoColumn:6];
	
	talkingDrum.autoFillMin = 2;
	talkingDrum.autoFillSlots = 7;
	
	
	
	//TAMBOURINE
	int tambourineAF0[16] = {2,6,10,14,-1};
	int tambourineAF1[16] = {2,5,6,10,14,-1};
	int tambourineAF2[16] = {2,3,6,10,14,-1};
	int tambourineAF3[16] = {2,6,10,11,14,-1};
	int tambourineAF4[16] = {2,3,6,10,13,14,-1};
	int tambourineAF5[16] = {2,5,6,10,14,15,-1};
	[tambourine setAutoFillPositions:tambourineAF0 intoColumn:0];
	[tambourine setAutoFillPositions:tambourineAF1 intoColumn:1];
	[tambourine setAutoFillPositions:tambourineAF2 intoColumn:2];
	[tambourine setAutoFillPositions:tambourineAF3 intoColumn:3];
	[tambourine setAutoFillPositions:tambourineAF4 intoColumn:4];
	[tambourine setAutoFillPositions:tambourineAF5 intoColumn:5];
	
	tambourine.autoFillMin = 4;
	tambourine.autoFillSlots = 6;
	
	
	//PERMANENT SOUNDS
	int shakerAF0[16] = {2,3,7,10,11,15,-1};
	int shakerAF1[16] = {2,3,4,7,10,11,15,-1};
	int shakerAF2[16] = {2,3,10,11,-1};
	[shaker setAutoFillPositions:shakerAF0 intoColumn:0];
	[shaker setAutoFillPositions:shakerAF1 intoColumn:1];
	[shaker setAutoFillPositions:shakerAF2 intoColumn:2];
	
	shaker.autoFillMin = 4;
	shaker.autoFillSlots = 1;
	
	int shakerRollAF0[16] = {4,12,-1};
	int shakerRollAF1[16] = {4,-1};
	int shakerRollAF2[16] = {12,-1};
	[shakerRoll setAutoFillPositions:shakerRollAF0 intoColumn:0];
	[shakerRoll setAutoFillPositions:shakerRollAF1 intoColumn:1];
	[shakerRoll setAutoFillPositions:shakerRollAF2 intoColumn:2];
	
	shakerRoll.autoFillSlots = 3;
	shakerRoll.autoFillMin = 1;
}

#pragma mark volumes
-(void) setVolumes{
	
	om.manualMaxVolume = 0.9;
	om.manualMinVolume = 0.6;
	om.volumeFade = 0.1;
	om.playMinVolume = 0.2;
	
	gong.manualMaxVolume = 0.55;
	gong.manualMinVolume = 0.4;
	gong.volumeFade = 0.1;
	gong.playMinVolume = 0.2;
	
	tibetLow.manualMaxVolume = 0.75;
	tibetLow.manualMinVolume = 0.4;
	tibetLow.autoMaxVolume = 0.75;
	tibetLow.autoMinVolume = 0.4;
	tibetLow.volumeFade = 0.1;
	
	tablaLow.manualMaxVolume = 0.5;
	tablaLow.manualMinVolume = 0.3;
	tablaLow.autoMaxVolume = 0.5;
	tablaLow.autoMinVolume = 0.3;	
	tablaLow.volumeFade = 0.1;
	
	gamelan.manualMaxVolume = 0.75;
	gamelan.manualMinVolume = 0.4;
	gamelan.volumeFade = 0.1;
	gamelan.playMinVolume = 0.2;
	
	doumbek.manualMaxVolume = 0.55;
	doumbek.manualMinVolume = 0.25;
	doumbek.autoMaxVolume = 0.55;
	doumbek.autoMinVolume = 0.25;
	doumbek.volumeFade = 0.1;
	
	tibetHigh.manualMaxVolume = 0.3;
	tibetHigh.manualMinVolume = 0.1;
	tibetHigh.autoMaxVolume = 0.3;
	tibetHigh.autoMinVolume = 0.1;
	tibetHigh.volumeFade = 0.05;
	
	djembe.manualMaxVolume = 0.4;
	djembe.manualMinVolume = 0.15;
	djembe.autoMaxVolume = 0.4;
	djembe.autoMinVolume = 0.15;
	djembe.volumeFade = 0.05;
	
	talkingDrum.manualMaxVolume = 0.4;
	talkingDrum.manualMinVolume = 0.2;
	talkingDrum.autoMaxVolume = 0.4;
	talkingDrum.autoMinVolume = 0.2;
	talkingDrum.volumeFade = 0.05;
	
	tambourine.manualMaxVolume = 0.35;
	tambourine.manualMinVolume = 0.2;
	tambourine.autoMaxVolume = 0.35;
	tambourine.autoMinVolume = 0.2;
	tambourine.volumeFade = 0.025;
	
	sitar.manualMaxVolume = 0.5;
	sitar.manualMinVolume = 0.3;	
	sitar.volumeFade = 0.05;
	
	shaker.volumeFade = 0.005;
	shaker.manualMaxVolume = 0.025;
	shaker.manualMinVolume = 0.025;
	shaker.autoMaxVolume = 0.025;
	shaker.autoMinVolume = 0.025;
	shaker.playMinVolume = 0;
	
	shakerRoll.volumeFade = 0.005;
	shakerRoll.manualMaxVolume = 0.025;
	shakerRoll.manualMinVolume = 0.025;
	shakerRoll.autoMaxVolume = 0.025;
	shakerRoll.autoMinVolume = 0.025;
	shakerRoll.playMinVolume = 0;
	
	/*
	 volumeFade = 0.15;
	 maxVolume = 1.0;
	 minVolume = 0.5;
	 playMinVolume = 0.3;
	 */
}

#pragma mark pitches
- (void) setPitches{
	//default variedPitch = YES;
	//instruments with no varied pitch
	
	synth.variedPitch = YES;
	synth.minPitch = 0.6;
	synth.maxPitch = 1.2;
	synth.pitchInc = 0.2;
	
	om.variedPitch = YES;
	om.randomPitch = YES;
	om.minPitch = 0.4;
	om.maxPitch = 1.0;
	om.pitchInc = 0.2;
	
	gong.variedPitch = YES;
	gong.minPitch = 0.6;
	gong.maxPitch = 1.2;
	gong.pitchInc = 0.2;
	
	tibetLow.variedPitch = YES;
	
	tablaLow.variedPitch = YES;
	tablaLow.minPitch = 0.8;
	tablaLow.maxPitch = 1.1;
	
	gamelan.variedPitch = YES;
	gamelan.minPitch = 0.4;
	gamelan.maxPitch = 2.0;
	gamelan.pitchInc = 0.2;
	
	doumbek.variedPitch = YES;
	tibetHigh.variedPitch = YES;
	
	/*
	//PITCH
	minPitch = 0.9;
	maxPitch = 1.1;
	pitchInc = 0.01;
	variedPitch = NO;
	 */
}

#pragma mark arrangement
-(void) setArrangement {
	
	gong.repeatEveryHowManyMeasures = 2;
	gong.quantization = 8;
	gong.noteMax = 4;
	
	om.repeatEveryHowManyMeasures = 2;
	om.quantization = 8;
	om.noteMax = 4;
	
	gamelan.repeatEveryHowManyMeasures = 2;
	
	sitar.repeatEveryHowManyMeasures = 4;
	sitar.quantization = 4;
	
	
	
}

#pragma mark pans
- (void) setPans{
	shakerRoll.pan = -10;
	shaker.pan = 10;
	sitar.pan = 15;
	tambourine.pan = 40;
	talkingDrum.pan = 25;
	djembe.pan = -35;
	tibetHigh.pan = 35;
	doumbek.pan = -30;
	gamelan.pan = -10;
	tablaLow.pan = 15;
	tibetLow.pan = -20;
	om.pan = 40;
	gong.pan = -20;
	
}

@end
