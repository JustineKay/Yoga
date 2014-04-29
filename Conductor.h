//
//  Conductor.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Song;
@class Orchestra;
@class AutoFiller;

@interface Conductor : NSObject {
	Song *currSong;
	Orchestra *o;
	AutoFiller *af;
}

@property (nonatomic, retain) Song *currSong;

+ (Conductor *) sharedConductor;

@end
