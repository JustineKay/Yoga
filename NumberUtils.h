//
//  NumberUtils.h
//  MusicMaker
//
//  Created by Jason Snell on 6/11/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumberUtils : NSObject {

}

+ (float) getRandomFloatBetween:(float)max and:(float) min;
+ (float) getRandomFloatBetween:(float)max and:(float) min withInc:(float)inc;

@end
