#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import "ResourceManager.h"

@class PlayController;
@class Image;


#pragma mark -
#pragma mark interface
@interface PlayView : NSObject {
	
	//Controllers, Managers
	PlayController *c;
	
	//SOUND
	
	//VIEWS (in order from top to bottom on screen)
	uint playPadHeight;
	CGRect playPad;
	
	Image *bgGradient;
	Image *arm;
	Image *basePanel;
	Image *carvedPanel;
	Image *noteDown;
	Image *noteUp;
	Image *parchment0;
	Image *parchment1;

	
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) PlayController *c;

#pragma mark images
@property (nonatomic, assign) CGRect playPad;
@property (nonatomic, assign) uint playPadHeight;

@property (nonatomic, retain) Image *bgGradient;
@property (nonatomic, retain) Image *arm;
@property (nonatomic, retain) Image *basePanel;
@property (nonatomic, retain) Image *carvedPanel;
@property (nonatomic, retain) Image *noteDown;
@property (nonatomic, retain) Image *noteUp;
@property (nonatomic, retain) Image *parchment0;
@property (nonatomic, retain) Image *parchment1;

#pragma mark -
#pragma mark Setters
- (void) setController:(PlayController *)controller;



@end
