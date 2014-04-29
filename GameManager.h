#pragma mark imports
#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Common.h"

#pragma mark -
#pragma mark classes
@class Image;
@class SpriteSheet;
@class Animation;
@class ParticleEmitter;
@class MainView;

#pragma mark -
#pragma mark interface
@interface GameManager : NSObject {
	
	//globals
	GLuint scene;
	GLuint mode;
	GLuint device;
	GLuint audioRoute;
	GLuint currentlyBoundTexture;
	GLfloat globalAlpha;
    float framesPerSecond;
	BOOL displayOn;
	
}

#pragma mark -
#pragma mark properties
@property (nonatomic, assign) GLuint scene;
@property (nonatomic, assign) GLuint mode;
@property (nonatomic, assign) GLuint device;
@property (nonatomic, assign) GLuint audioRoute;
@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, assign) GLfloat globalAlpha;
@property (nonatomic, assign) float framesPerSecond;
@property (readwrite) BOOL displayOn;

+ (GameManager*)sharedGameManager;

@end
