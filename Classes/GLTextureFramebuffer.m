//
//  GLTextureFramebuffer.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GLTextureFramebuffer.h"


@implementation GLTextureFramebuffer


- (id) initWithDefaultViewportX:(int)vX y:(int)vY andOrthoX:(int)oX y:(int)oY {
	if (self = [super init]) {
		defaultViewportX = vX;
		defaultViewportY = vY;
		
		/* Generate the framebuffer and texture handles */
		glGenFramebuffersOES(1, &fb_handle);
		glGenTextures(1, &tex_handle);
		
		/* Bind the framebuffer architecture to our new framebuffer */
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, fb_handle);
		
		/* Bind textures to our texture handle and setup linear filters */
		glBindTexture(GL_TEXTURE_2D, tex_handle);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		
		/* Create the frame buffer texture in memory */ 
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, FBO_SIZE, FBO_SIZE, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
		
		/* Rebind the texture and attach it to the framebuffer */
		glBindTexture(GL_TEXTURE_2D, tex_handle);
		glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, tex_handle, 0);
		
		/* Check our status */
		GLint status = glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES);
		if (status != GL_FRAMEBUFFER_COMPLETE_OES) {
			NSLog(@"Raising incomplete framebuffer exception");
			[NSException raise:@"Incomplete Framebuffer" format:@"glCheckFramebufferStatusOES returned incomplete status"];
		}	
		
		[self clear];
		
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0, oX, 0, oY, -1.0f, 1.0f);
		glGetFloatv(GL_PROJECTION_MATRIX, defaultProjectionMatrix);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();		
		glGetFloatv(GL_MODELVIEW_MATRIX, defaultModelviewMatrix);
		
		
	}
	return self;
}



- (void) dealloc {
	glDeleteTextures(1, &tex_handle);
	glDeleteFramebuffersOES(1, &fb_handle);
	[super dealloc];
}



- (void) clear {
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, fb_handle);
	glBindTexture(GL_TEXTURE_2D, 0);
	glViewport(0, 0, FBO_SIZE, FBO_SIZE);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT);
}



- (void) activate {
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, fb_handle);
	glBindTexture(GL_TEXTURE_2D, 0);
	
	glViewport(0, 0, defaultViewportX, defaultViewportY);
	glMatrixMode(GL_PROJECTION);
	glLoadMatrixf(defaultProjectionMatrix);
	glMatrixMode(GL_MODELVIEW);
	glLoadMatrixf(defaultModelviewMatrix);
}



- (void) bindTexture {
	glBindTexture(GL_TEXTURE_2D, tex_handle);
}


@end
