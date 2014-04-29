//
//  Repeater.h
//  MusicMakerDev
//
//  Created by Jason Snell on 6/16/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@class Note;

@interface Repeater : NSObject {

}

- (void) addNote:(Note *)originalNote;
- (void) refreshNote:(Note *)originalNote;
//- (NSMutableArray *) getRepeatsOfNote:(Note *)originalNote;

+ (Repeater *) sharedRepeater;

@end
