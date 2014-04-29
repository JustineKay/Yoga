//
//  NumberUtils.m
//  MusicMaker
//
//  Created by Jason Snell on 6/11/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import "NumberUtils.h"


@implementation NumberUtils


+ (float) getRandomFloatBetween:(float)max and:(float) min {
	
	//check is max and min is same, and just send value back
	if (max == min){
		return max;
	}
	
	//error check
	if (max < min){
		return max;
	}
	
	// multiply by 10, so the float doesn't lose its tenths value when converted to int
	float maxTensFloat = max * 10;
	float minTensFloat = min * 10;

	//convert to int
	int maxTensInt = maxTensFloat;
	int minTensInt = minTensFloat;

	//subtract min from max to get range
	int randomRange = maxTensInt - minTensInt;

	//generate random value within range
	int randomMax = arc4random() % randomRange;
		
	//add min back to push range inbetween min and max
	int randomInt = randomMax + minTensInt;
	
	//convert back to float
	float randomTensFloat = randomInt;
	
	//reduce by 10 to get back to pitch values
	float randomFloat = randomTensFloat / 10;
	
	return randomFloat;
	
} //getRandomFloatBetween

+ (float) getRandomFloatBetween:(float)max and:(float) min withInc:(float)inc{
	float randomFloat = [self getRandomFloatBetween:max and:min];
	float divFloat = randomFloat / inc;
	int expandedInt = divFloat * 10;
	float contractedFloat = expandedInt / 10;
	float finalFloat = contractedFloat * inc;
	return finalFloat;
}

@end
