#import "AppController.h"
#import "Common.h"
#import "AppView.h"
#import "Orchestra.h"

@interface AppController (Private)

@end

@implementation AppController

#pragma mark - 
#pragma mark Dealloc

- (void)dealloc {
	[soundManager shutdownSoundManager];
	[gameManager dealloc];
	[resourceManager dealloc];
	[mainController dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialize the game

#define PORTRATE_MODE YES

- (id)init {
	
	if(self == [super init]) {	
		// Get the shared instance from the SingletonGameState class.  This will provide us with a static
		// class that can track game and OpenGL state
		gameManager = [GameManager sharedGameManager];
		resourceManager = [ResourceManager sharedResourceManager];
		soundManager = [SoundManager sharedSoundManager];
		
		// Initialize OpenGL
		[self initOpenGL];
		
		// Initialize main view and controller
		
		mainView = [[MainView alloc] init];
		mainController = [[MainController alloc] init];		
		[mainController setView:mainView];
		[mainView setController:mainController];
		
		// Make sure glInitialised is set to NO so that OpenGL gets initialised when the first scene is rendered
		glInitialised = NO;

	}
	return self;
}

#pragma mark -
#pragma mark Initialize OpenGL settings

- (void)initOpenGL {
	
	screenBounds = [[UIScreen mainScreen] bounds];
	
	// Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	// Rotate the entire view 90 degrees to the left to handle the phone being in landscape mode
	if(!PORTRATE_MODE) {
		glRotatef(-90.0f, 0, 0, 1);
	
		// Setup Ortho for the current matrix mode.  This describes a transformation that is applied to
		// the projection.  For our needs we are defining the fact that 1 pixel on the screen is equal to
		// one game unit by defining the horizontal and vertical clipping planes to be from 0 to the views
		// dimensions.  The far clipping plane is set to -1 and the near to 1.  The height and width have
		// been swapped to handle the phone being in landscape mode
		glOrthof(0, screenBounds.size.height, 0, screenBounds.size.width, -1, 1);
	} else {
		glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -1, 1);
	}
	
	// Switch to GL_MODELVIEW so we can now draw our objects
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Setup how textures should be rendered i.e. how a texture with alpha should be rendered ontop of
	// another texture.
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
	
	// We are not using the depth buffer in our 2D game so depth testing can be disabled.  If depth
	// testing was required then a depth buffer would need to be created as well as enabling the depth
	// test
	glDisable(GL_DEPTH_TEST);
	
	// Set the colour to use when clearing the screen with glClear
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	// Mark game as initialised
	glInitialised = YES;
}


#pragma mark -
#pragma mark Update the game scene logic

- (void)updateScene:(GLfloat)aDelta {
	
	// Update the games logic based for the current scene
	[mainController updateWithDelta:aDelta];

}


#pragma mark -
#pragma mark Render the scene

- (void)renderScene {
    
	// Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
	if(!PORTRATE_MODE) {
        glViewport(0, 0, screenBounds.size.height , screenBounds.size.width);
    } else {
        glViewport(0, 0, screenBounds.size.width , screenBounds.size.height);
    }
	
	// Clear the screen
	glClear(GL_COLOR_BUFFER_BIT);
	
	[mainController render];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[mainController updateWithTouchLocationBegan:touches withEvent:event view:aView];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[mainController updateWithTouchLocationMoved:touches withEvent:event view:aView];

}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[mainController updateWithTouchLocationEnded:touches withEvent:event view:aView];
}

#pragma mark -
#pragma mark Accelerometer

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [mainController updateWithAccelerometer:acceleration];
}

@end
