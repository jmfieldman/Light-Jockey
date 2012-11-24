//
//  GLTextureFramebuffer.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGLDrawable.h>

/* The x/y dimensions of the texture frame buffer */
#define FBO_SIZE 256
#define FBOTEX_X 160
#define FBOTEX_Y 240
#define FBOTEX_S (160.0 / 256.0)
#define FBOTEX_T (240.0 / 256.0)

#define MIPMAP1_X 80
#define MIPMAP1_Y 120
#define MIPMAP1_S (80.0  / 256.0)
#define MIPMAP1_T (120.0 / 256.0)
#define MIPMAP2_X 40
#define MIPMAP2_Y 60
#define MIPMAP2_S (40.0 / 256.0)
#define MIPMAP2_T (60.0 / 256.0)

@interface GLTextureFramebuffer : NSObject {
	GLuint       fb_handle;
	GLuint       tex_handle;
	
	GLfloat      defaultModelviewMatrix[16];
	GLfloat      defaultProjectionMatrix[16];
	int          defaultViewportX;
	int          defaultViewportY;
}

- (id) initWithDefaultViewportX:(int)vX y:(int)vY andOrthoX:(int)oX y:(int)oY;

/* Clears the framebuffer texture */
- (void) clear;

/* Activates the framebuffer to accept commands */
- (void) activate;

/* Binds this buffer's texture as the GL_TEXTURE_2D source */
- (void) bindTexture;



@end
