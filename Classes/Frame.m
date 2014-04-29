#import "Frame.h"

@implementation Frame

@synthesize frameDelay;
@synthesize frameImage;

- (void)dealloc {
    [frameImage release];
	[super dealloc];
}

- (id)initWithImage:(Image*)image delay:(float)delay {
	self = [super init];
	if(self != nil) {
		frameImage = image;
		frameDelay = delay;
	}
	return self;
}

@end
