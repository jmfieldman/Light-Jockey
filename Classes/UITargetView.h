//
//  UITargetView.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJBeam.h"

/* This is a single instance of a target.  It has no knowledge of how the model works */

/* Some graphics info */
#define UITARGET_RADIUS   32
#define UITARGET_DIAMETER 64

#define UITARGET_CENTER_RADIUS 10

#define UITARGET_OFFCOLOR_ALPHA 0.2
#define UITARGET_ONCOLOR_DRAIN  0.8
#define UITARGET_ONCOLOR_BOOST  0.35

#define UITARGET_POWER_WIDTH 2
#define UITARGET_POWER_OFFSET 4
#define UITARGET_POWERBAND_INSET (10.0 * (M_PI / 180.0))

/* Animation */
#define UITARGET_FADE_DURATION 0.25

/* Bounds */
#define UITARGET_MAX_COLORS 4
#define UITARGET_MAX_POWER 4
#define UITARGET_NUM_POWERS 5

@interface UITargetView : UIView {
	/* Data */
	int             numColors;
	LJBeamColor_t   colors[UITARGET_MAX_COLORS];
	int             powers[UITARGET_MAX_COLORS];
	
	/* Image buffers */
	UIImageView    *imageBuffers[UITARGET_MAX_COLORS][UITARGET_NUM_POWERS];	
}

- (id) initAtPosition:(CGPoint)pos withNumColors:(int)numCol withColors:(LJBeamColor_t*)theColors;
- (void) setPower:(int)power forColorIndex:(int)color;

@end
