//
//  RenderObject.h
//  WaterPipe
//
//  Created by Jason Snell on 7/6/09.
//  Copyright 2009 FluxVisual.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@interface RenderedObject : UIView {
	
}

- (void)setAlpha:(GLfloat)aAlpha;
- (GLfloat) getAlpha;

@end
