//
//  Loop.h
//  MusicMaker
//
//  Created by Jason Snell on 6/9/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface Phrase : NSObject {
	uint length;
}

@property (nonatomic, assign) uint length;

+ (Phrase *) sharedPhrase;

@end
