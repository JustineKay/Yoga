#import "AppDelegate.h"
#import "AppView.h"
#import "GameManager.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	glView = [[[AppView alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
	
    // Add the glView to the window which has been defined
	[window addSubview:glView];
	[window makeKeyAndVisible];
    
	//set status bar to black
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	// Since OS 3.0, just calling [glView mainGameLoop] did not work, you just got a black screen.
    // It appears that others have had the same problem and to fix it you need to use the 
    // performSelectorOnMainThread call below.
    [glView performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO];
	
	//prevents app from falling asleep during play (which throws off playback)
	UIApplication* myApp = [UIApplication sharedApplication];
	myApp.idleTimerDisabled = YES;
	
	UIAlertView *instructions = [[UIAlertView alloc] initWithTitle:@"Instructions" message:@"Tap the screen to add notes." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[instructions show];
	[instructions release];

}


- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"DEVICE  : Screen locked");
	[GameManager sharedGameManager].displayOn = NO;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"DEVICE  : Screen unlocked");
	[GameManager sharedGameManager].displayOn = YES;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
