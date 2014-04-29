//
//  MultiInstrument.h
//  Yoga
//
//  Created by Jason Snell on 9/4/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instrument.h"


@interface MultiInstrument : Instrument {
	NSMutableArray *keys;
	int currentKeyID; 
}

- (void) addSoundWithKey:(NSString *)_key fileName:(NSString *)_fileName fileExt:(NSString *)_fileExt;

@end
