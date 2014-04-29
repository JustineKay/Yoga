#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "GameManager.h"
#import "SoundManager.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "MainController.h"
#import "MainView.h"

@class AppView;

@interface AppController : UIView <UIAccelerometerDelegate> {
	/* State to define if game has been initialised or not */
	BOOL glInitialised;
	
	// Grab the bounds of the screen
	CGRect screenBounds;
	
	// Accelerometer fata
	UIAccelerationValue _accelerometer[3];
	
	// Shared game state
	GameManager *gameManager;
	
	// Shared resource manager
	ResourceManager *resourceManager;
	
	// Shared sound manager
	SoundManager *soundManager;
	
	//class that controls the pipe objects, logic, and view
	MainController *mainController;
	
	// holds on the pipe graphics, animations, and particle emitters
	MainView *mainView;

}

- (id)init;
- (void)initOpenGL;
- (void)renderScene;
- (void)updateScene:(GLfloat)aDelta;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

@end
