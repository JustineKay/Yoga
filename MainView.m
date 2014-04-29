#import "MainView.h"
#import "GameManager.h"
#import "MainController.h"
#import "SoundManager.h"

#pragma mark private interface
@interface MainView (Private)
//private method headers


@end

#pragma mark -
@implementation MainView

#pragma mark synthesize
//@sythesize objects
@synthesize mainController;

#pragma mark dealloc
- (void)dealloc {
	//release objects
	
	[super dealloc];
}

#pragma mark init
- (id)init {
	self = [super init];
	if (self != nil) {

		
	}
	
	return self;
}

#pragma mark -

#pragma mark -
#pragma mark setters
- (void) setController:(MainController *)controller{
	mainController = controller;
}


@end