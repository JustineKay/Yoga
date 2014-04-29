#import "GameManager.h"

@implementation GameManager

#pragma mark synthesize
@synthesize scene;
@synthesize mode;
@synthesize device;
@synthesize audioRoute;
@synthesize currentlyBoundTexture;
@synthesize globalAlpha;
@synthesize framesPerSecond;
@synthesize displayOn;


// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(GameManager);

- (void)dealloc {
	[super dealloc];
}

- (id)init {
	
	//GLOBALS
	globalAlpha = 1.0f;
	
	//set device so various objects can grab it
	NSString *deviceStr = [[UIDevice currentDevice] localizedModel];
	NSLog(@"Device = %@", deviceStr);
	if ([deviceStr isEqualToString: @"iPod touch"]) {
		device = kDeviceIPodTouch;
	} else {
		device = kDeviceIPhone;
	}
	
	displayOn = YES;
	
	return self;
}

@end
