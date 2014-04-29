#import "PlayView.h"
#import "GameManager.h"
#import "PlayController.h"
#import "Image.h"

#pragma mark private interface
@interface PlayView (Private)
//private method headers


@end

#pragma mark -
@implementation PlayView

#pragma mark synthesize
//@sythesize objects
@synthesize c;
@synthesize playPad;
@synthesize playPadHeight;
@synthesize bgGradient;
@synthesize arm;
@synthesize basePanel;
@synthesize carvedPanel;
@synthesize noteDown;
@synthesize noteUp;
@synthesize parchment0;
@synthesize parchment1;

#pragma mark dealloc
- (void)dealloc {
	//release objects
	[bgGradient release];
	[arm release];
	[basePanel release];
	[carvedPanel release];
	[noteDown release];
	[noteUp release];
	[parchment0 release];
	[parchment1 release];
	
	[super dealloc];
}

#pragma mark init
- (id)init {
	self = [super init];
	if (self != nil) {
		
		//init managers
		
		//init touch area
		playPadHeight = 460;
		playPad = CGRectMake(0, 17, 320, playPadHeight);

		//init images
		bgGradient = [[Image alloc] initWithImage:@"bg_gradient.jpg"];
		arm = [[Image alloc] initWithImage:@"arm.png"];
		basePanel = [[Image alloc] initWithImage:@"base_panel.png"];
		carvedPanel = [[Image alloc] initWithImage:@"carved_panel.png"];
		noteDown = [[Image alloc] initWithImage:@"note_down.png"];
		noteUp = [[Image alloc] initWithImage:@"note_up.png"];
		parchment0 = [[Image alloc] initWithImage:@"parchment.png"];
		parchment1 = [[Image alloc] initWithImage:@"parchment_short.png"];
	}
	
	return self;
}

#pragma mark -
#pragma mark setters
- (void) setController:(PlayController *)controller{
	c = controller;
}


@end