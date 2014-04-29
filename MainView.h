#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import "ResourceManager.h"

@class MainController;

#pragma mark -
#pragma mark interface
@interface MainView : NSObject {
	
	//Controllers, Managers
	MainController *mainController;
	
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) MainController *mainController;


#pragma mark -
#pragma mark Setters
- (void) setController:(MainController *)controller;

@end
