//
//  SparkleEngineView.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkleEngineView.h"
#import <QuartzCore/QuartzCore.h>

#if TARGET_IPHONE_SIMULATOR
#define _SHOW_PLACEMENT_GRID_ 0
#else
#define _SHOW_PLACEMENT_GRID_ 0
#endif

/* ---- These are some const arrays for OpenGL effects ---- */

/* screenBorderVerts provides dimensions for a full-screen triangle strip */
const GLfloat screenBorderVerts[] = {
	0,       0, 
	0,       MVIEW_Y,
	MVIEW_X, 0,
	MVIEW_X, MVIEW_Y,
};

/* screenBorderTexCoords provides texture coordinate dimensions for a full-screen texture */
const GLfloat screenBorderTexCoords[] = {
	0,        0,
	0,        FBOTEX_T,
	FBOTEX_S, 0,
	FBOTEX_S, FBOTEX_T,
};

/* mipmap1BorderTexCoords provides texture coordinate dimensions for a mipmap1 full-screen texture */ 
const GLfloat mipmap1BorderTexCoords[] = {
0,         0,
0,         MIPMAP1_T,
MIPMAP1_S, 0,
MIPMAP1_S, MIPMAP1_T,
};

//#define MIPMAP1_BLEND 127
#define MIPMAP1_BLEND 106
const GLubyte mipmap1BlendColors[] = {
	255, 255, 255, MIPMAP1_BLEND,
	255, 255, 255, MIPMAP1_BLEND,
	255, 255, 255, MIPMAP1_BLEND,
	255, 255, 255, MIPMAP1_BLEND,
};

/* screenFadeColors provides the color for the full-screen fade cycle */
#if TARGET_IPHONE_SIMULATOR
#define FADE_ALPHA 180
#else
//#define FADE_ALPHA 172
#define FADE_ALPHA 185
#endif
const GLubyte screenFadeColors[] = {
	0, 0, 0, FADE_ALPHA,
	0, 0, 0, FADE_ALPHA,
	0, 0, 0, FADE_ALPHA,
	0, 0, 0, FADE_ALPHA,
};

/* lightShadowColors provides black-out for the light texture modulation */
const GLubyte lightShadowColors[] = {
	0, 0, 0, 0, 
	0, 0, 0, 0, 
	0, 0, 0, 0, 
	0, 0, 0, 0, 
};

/* gridCoords provides line coords for the placement grid */
const GLfloat gridCoords[] = {
0,   40,   320, 40,   0,   80,  320, 80,   0,   120, 320, 120, 0,   160, 320, 160, /* 8 */
0,  200,   320, 200,  0,  240,  320, 240,  0,   280, 320, 280, 0,   320, 320, 320, /* 8 */
0,  360,   320, 360,  0,  400,  320, 400,  0,   440, 320, 440,                     /* 6 */

40,   0,   40,  480, 80,   0,   80,  480,120,   0,   120,  480,  160,   0,   160,  480,  /* 8 */
200,  0,  200,  480, 240,   0,  240,  480,280,   0,   280,  480,                        /* 6 */
};

#define OFFGRID 140, 140, 140, 255
#define ONGRID  255, 255, 255, 255
const GLubyte gridColors[] = {
OFFGRID , OFFGRID , ONGRID , ONGRID , OFFGRID , OFFGRID , ONGRID , ONGRID ,
OFFGRID , OFFGRID , ONGRID , ONGRID , OFFGRID , OFFGRID , ONGRID , ONGRID ,
OFFGRID , OFFGRID , ONGRID , ONGRID , OFFGRID , OFFGRID , 

OFFGRID , OFFGRID , ONGRID , ONGRID , OFFGRID , OFFGRID , ONGRID , ONGRID ,
OFFGRID , OFFGRID , ONGRID , ONGRID , OFFGRID , OFFGRID ,
};

// A class extension to declare private methods
@interface SparkleEngineView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createBuffers;
- (void) destroyBuffers;

@end


@implementation SparkleEngineView
@synthesize context;
@synthesize levelModel;


+ (Class)layerClass {
    return [CAEAGLLayer class];
}



- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor blackColor];
		
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;        
		}
		
		mainBlurBuffer = nil;
		swapBlurBuffer = nil;
		mipmapBuffer   = nil;
		
		levelModel     = nil;
		
		radarTexture                          = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_radar.png"]];
		discIconImages[LJDISCTYPE_PUSH]       = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_push.png"]];
		discIconImages[LJDISCTYPE_SPEEDUP]    = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_speed.png"]];
		discIconImages[LJDISCTYPE_SLOWDOWN]   = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_slow.png"]];
		discIconImages[LJDISCTYPE_ATTRACT]    = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_attract.png"]];
		discIconImages[LJDISCTYPE_BOUNCE]     = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_bounce.png"]];
		discIconImages[LJDISCTYPE_REPEL]      = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_repel.png"]];
		discIconImages[LJDISCTYPE_SPLIT]      = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"disc_split.png"]];
		
		prismTexture                          = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"prism_master.png"]];
		
		[self createBuffers];
		
		takeScreenShot = NO;
		screenShotFileName = nil;
    }
    return self;
}



- (void) drawRect:(CGRect)rect {
    // Drawing code
}



#pragma mark Draw Functions

- (void) _frameRateCheckpoint {
	static int frames = 0;
	static int lasttime = 0;
	int curtime = time(0);
	frames++;
	
	if (curtime > lasttime) {
		NSLog(@"{%d fps}", frames);
		frames = 0;
		lasttime = curtime;
	}
}


- (void) clearBuffers {
	[mainBlurBuffer activate];
	glViewport(0, 0, 320, 480);
	glClearColor(0, 0, 0, 0);
	glClear(GL_COLOR_BUFFER_BIT);
	[swapBlurBuffer activate];
	glViewport(0, 0, 320, 480);
	glClearColor(0, 0, 0, 0);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glViewport(0, 0, 320, 480);
	glClearColor(0, 0, 0, 0);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void) _fadeBuffer {
	/* Turn on blending (we're doing an alpha blend to fade) */
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	/* Assign the data pointers */
	glVertexPointer(2, GL_FLOAT,         0, screenBorderVerts);
    glColorPointer (4, GL_UNSIGNED_BYTE, 0, screenFadeColors);
	
	/* Set the client state for drawing arrays */
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);    
    glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	/* Draw the fade quad */
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}



- (void) performDrawCycle {
	//[self _frameRateCheckpoint];
	
	/*  High level review of what we're doing in this function:
		[We have source FBO (main) and target FBO (swap)]
		1. Draw newest beam fragments into main FBO
		2. Fade main FBO by some amount of black
		3. Clear the swap FBO
		4. Copy main FBO into swap FBO using gaussian blur effect
		5. Copy the swap FBO into the screen FBO
		6. Draw the line segments directly to the screen FBO (so they don't blur)
		7. Exchange main/swap FBO pointers, repeat from step 1.
	 */
	
	/* Stage 1: Draw newest beam fragments into main FBO */

	[mainBlurBuffer activate];
	
	/* Set the client state for drawing arrays */
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);    
    glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	[levelModel drawGlows];
	
	
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	static float xoff = 0.1;
	static float modr = 1.0;
	xoff += 1;
	modr -= 0.005;
	for (int p = 0; p < levelModel.numPrisms; p++) {
		LJPrism *prism = [levelModel prismAtIndex:p];
		LJBeamColor_t pcolor = prism.color;
		glColor4f(g_beamColorComps[pcolor].red/255.0, g_beamColorComps[pcolor].green/255.0, g_beamColorComps[pcolor].blue/255.0, 1);
		CGPoint p = prism.position;
		p.x += xoff;
		p.y += xoff;
		[prismTexture drawAtPoint:p withScale:(modr*(prism.radius / 64.0)) withRotation:0];
	}
	glBindTexture(GL_TEXTURE_2D, 0);
	
	
	/* Stage 2: Fade main FBO by some amount of black */
	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);    
    glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	
	[self _fadeBuffer];
	
	/* Stage 3: Clear the swap FBO */
	
		/* ==> NOTE: after review the clear part doesn't seem to be necessary */	
	
	/* Stage 4: Copy main FBO into swap FBO using gaussian blur effect */
	
	{ /* This part copies the main FBO to the swap FBO 1:1 with blur attempt */
		[swapBlurBuffer activate];
		glClearColor(0,0,0,0);
		glClear(GL_COLOR_BUFFER_BIT);
		
		[mainBlurBuffer bindTexture];
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
		
		glTexCoordPointer(2, GL_FLOAT, 0, screenBorderTexCoords);
		glVertexPointer  (2, GL_FLOAT, 0, screenBorderVerts);
		glColorPointer   (4, GL_UNSIGNED_BYTE, 0, mipmap1BlendColors);
		
		glDisableClientState(GL_COLOR_ARRAY);    
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		const float blurT = 3.0;
		
		glColor4f(1, 1, 1, 1);
		glPushMatrix();
		glTranslatef(-blurT, blurT,0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glPopMatrix();
		glPushMatrix();
		glTranslatef(-blurT,-blurT,0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glPopMatrix();
		glPushMatrix();
		glTranslatef(blurT,-blurT,0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glPopMatrix();
		glPushMatrix();
		glTranslatef(blurT,blurT,0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glPopMatrix();
		
	}
		
	/* Stage 5: Copy the swap FBO into the screen FBO */
		
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glViewport(0, 0, backingWidth, backingHeight);
	glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0.0f, (float)backingWidth/scale, 0.0f, (float)backingHeight/scale, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
	
	glClearColor(0.17, 0.17, 0.17, 0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[swapBlurBuffer bindTexture];
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	
	glTexCoordPointer(2, GL_FLOAT, 0, screenBorderTexCoords);
	glVertexPointer  (2, GL_FLOAT, 0, screenBorderVerts);
		
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glDisableClientState(GL_COLOR_ARRAY);    
		
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
	/* Stage 6: Draw the line segments directly to the screen FBO */
	
	glBindTexture(GL_TEXTURE_2D, 0);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glLineWidth(1);
	glEnable(GL_LINE_SMOOTH);
	[levelModel drawSegments];
	
	/* Mid-stage: Should we draw the placement grid? */
#if _SHOW_PLACEMENT_GRID_
	glVertexPointer(2, GL_FLOAT, 0, gridCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, gridColors);
	glDrawArrays(GL_LINES, 0, 36);
#endif
	
	/* Stage 6b: Draw the radar elements of the discs (we need this to be fast in OpenGL) */
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	for (int p = 0; p < levelModel.numPrisms; p++) {
		LJPrism *prism = [levelModel prismAtIndex:p];
		LJBeamColor_t pcolor = prism.color;
		glColor4f(g_beamColorComps[pcolor].red/255.0, g_beamColorComps[pcolor].green/255.0, g_beamColorComps[pcolor].blue/255.0, 1);
		[prismTexture drawAtPoint:prism.position withScale:(prism.radius / 64.0) withRotation:0];
	}
	
	//glColor4f(1, 1, 1, 1);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	for (int d = 0; d < levelModel.numDiscs; d++) {
		LJDisc *disc = [levelModel discAtIndex:d];
		[radarTexture drawAtPoint:disc.position withScale:(disc.radius / 64.0) withRotation:0];
	}
	
	for (int d = 0; d < levelModel.numDiscs; d++) {
		LJDisc *disc = [levelModel discAtIndex:d];
		if (disc.type == LJDISCTYPE_PUSH) {
			int rotation = 0;
			if (disc.direction == DIR_W) rotation = 90;
			else if (disc.direction == DIR_S) rotation = 180;
			else if (disc.direction == DIR_E) rotation = 270;
			[discIconImages[disc.type] drawAtPoint:disc.position withScale:1 withRotation:rotation];

		} else {
			[discIconImages[disc.type] drawAtPoint:disc.position withScale:1 withRotation:0];
		}
	}
	
	/* Stage 7: Exchange main/swap FBO pointers */
	
	GLTextureFramebuffer *tmp = mainBlurBuffer;
	mainBlurBuffer = swapBlurBuffer;
	swapBlurBuffer = tmp;
	
	/* Wrap it up: present render buffer to the screen */

	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	/* Should we take a screenshot? */
	if (takeScreenShot) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *ssFile = [NSString stringWithFormat:@"%@/screenshot_%@", documentsDirectory, screenShotFileName];
		
		unsigned char buffer[320*480*4];
		glReadPixels(0,0,320,480,GL_RGBA,GL_UNSIGNED_BYTE,&buffer);
		CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, &buffer, 320*480*4, NULL);
		CGImageRef iref = CGImageCreate(320,480,8,32,320*4,CGColorSpaceCreateDeviceRGB(),kCGBitmapByteOrderDefault,ref,NULL,true,kCGRenderingIntentDefault);
		
		size_t width         = CGImageGetWidth(iref);
		size_t height        = CGImageGetHeight(iref);
		size_t length        = width*height*4;
		uint32_t *pixels     = (uint32_t *)malloc(length);
		CGContextRef c       = CGBitmapContextCreate(pixels, width, height, 8, width*4, CGImageGetColorSpace(iref), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
		CGContextTranslateCTM(c, 0.0, height);
		CGContextScaleCTM(c, 1.0, -1.0);
		CGContextDrawImage(c, CGRectMake(0.0, 0.0, width, height), iref);
		CGImageRef outputRef = CGBitmapContextCreateImage(c);
		UIImage *outputImage = [UIImage imageWithCGImage:outputRef];
		
		CGRect newSize = CGRectMake(0, 0, 60, 90);
		UIGraphicsBeginImageContext(newSize.size);
				
		[outputImage drawInRect:newSize];
		UIImage *smallImg = UIGraphicsGetImageFromCurrentImageContext();
		NSData *imgdata = UIImagePNGRepresentation(smallImg);
		[imgdata writeToFile:ssFile atomically:YES];
		UIGraphicsEndImageContext();
				
		
		CGImageRelease(outputRef);
		CGContextRelease(c);
		
		takeScreenShot = NO;
	}
}



- (void) takeScreenShotWithFileName:(NSString*)fileName {
	takeScreenShot = YES;
	[screenShotFileName release];
	screenShotFileName = [fileName copy];
}


#pragma mark Utility Functions


- (void) dealloc {
	[self destroyBuffers];
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }    
	[radarTexture release];
    [context release];
	[screenShotFileName release];
    [super dealloc];
}



- (BOOL)createBuffers {
    
	glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    		
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    NSLog(@"createBuffers: renderbuffer dimensions (%d, %d)", backingWidth, backingHeight);
	
	/* scale down */
	scale = [UIScreen mainScreen].scale;
	
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		[NSException raise:@"Invalid renderbuffer" format:@"createBuffers could not create a renderbuffer"];
        return NO;
    }
    
	[EAGLContext setCurrentContext:context];    

	/* Let's do some initial clearing to make sure we don't have any white pop */
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glViewport(0, 0, backingWidth, backingHeight);
	glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(0.0f, (float)backingWidth/scale, 0.0f, (float)backingHeight/scale, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
	
	glClearColor(0,0,0,0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	/* Done clearing the framebuffer */
	
	glEnable(GL_TEXTURE_2D);
	
	mainBlurBuffer = [[GLTextureFramebuffer alloc] initWithDefaultViewportX:FBOTEX_X y:FBOTEX_Y andOrthoX:backingWidth/scale y:backingHeight/scale];
	swapBlurBuffer = [[GLTextureFramebuffer alloc] initWithDefaultViewportX:FBOTEX_X y:FBOTEX_Y andOrthoX:backingWidth/scale y:backingHeight/scale];
	mipmapBuffer   = [[GLTextureFramebuffer alloc] initWithDefaultViewportX:MIPMAP1_X y:MIPMAP1_Y andOrthoX:backingWidth/scale y:backingHeight/scale];
	
    return YES;
}



- (void) destroyBuffers {
    
    if (viewFramebuffer) glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    if (viewRenderbuffer) glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
	[mainBlurBuffer release];
	[swapBlurBuffer release];
	[mipmapBuffer release];
}



@end
