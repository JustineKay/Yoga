//
//  Player.h
//  Yoga
//
//  Created by Jason Snell on 9/3/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface Player : NSObject {

}

- (void) play;
+ (Player *) sharedPlayer;

@end
