//
//  SparkleEngineView.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGLDrawable.h>
#import "GLTextureFramebuffer.h"
#import "LJLevel.h"
#import "Texture2D.h"

#define MVIEW_X 320
#define MVIEW_Y 480

@interface SparkleEngineView : UIView {
	/* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
	float scale;
	
	/* EAGL context */
	EAGLContext *context;
	
	/* OpenGL handles for renderbuffer and framebuffer */
    GLuint viewRenderbuffer, viewFramebuffer;
	
	/* Frame buffers for the blur effect */
	GLTextureFramebuffer *mainBlurBuffer;
	GLTextureFramebuffer *swapBlurBuffer;
	
	/* Frame buffer to hold the mipmaps for gaussian blur */
	GLTextureFramebuffer *mipmapBuffer;
	
	/* Texture for the radar blits */
	Texture2D *radarTexture;
	Texture2D *discIconImages[NUM_LJDISCTYPE];
	Texture2D *prismTexture;
	
	/* Pointer to the LJLevel model we're drawing beams from */
	LJLevel *levelModel;
	
	/* Should take a screenshot? */
	BOOL takeScreenShot;
	NSString *screenShotFileName;
}

@property (nonatomic, assign) LJLevel *levelModel;

- (void) performDrawCycle;
- (void) clearBuffers;

- (void) takeScreenShotWithFileName:(NSString*)fileName;

@end
