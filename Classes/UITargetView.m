//
//  UITargetView.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UITargetView.h"


@implementation UITargetView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
    }
    return self;
}



- (void)dealloc {
    [super dealloc];
}



- (void) _createBufferForIndex:(int)colorIndex forPower:(int)power startRadians:(float)startRadians endRadians:(float)endRadians {
	CGRect newSize = CGRectMake(0, 0, UITARGET_DIAMETER, UITARGET_DIAMETER);
	UIGraphicsBeginImageContext(newSize.size);
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	BeamColorComps_t *comps = &g_beamColorComps[colors[colorIndex]];
	
	/* Setup colors */
	float offR = comps->red   / 255.0;
	float offG = comps->green / 255.0;
	float offB = comps->blue  / 255.0;
	float offA = UITARGET_OFFCOLOR_ALPHA;
	
	float onR = comps->red   / 255.0;
	float onG = comps->green / 255.0;
	float onB = comps->blue  / 255.0;
	float onA = UITARGET_ONCOLOR_DRAIN;
	
	if (power == UITARGET_MAX_POWER) {
		onR = (comps->red   / 255.0) + UITARGET_ONCOLOR_BOOST;
		onG = (comps->green / 255.0) + UITARGET_ONCOLOR_BOOST;
		onB = (comps->blue  / 255.0) + UITARGET_ONCOLOR_BOOST;
		onA = 1.0;
	}
	
	/* Clear the whole screen */
	
	CGContextSetRGBFillColor(c, 0, 0, 0, 0);
	CGContextFillRect(c, newSize);
	
	/* Anti-aliasing: YES */
	
	CGContextSetAllowsAntialiasing(c, YES);
	CGContextSetShouldAntialias(c, YES);
	
	/* We're going to blur if we're at max power */
	
	if (power == UITARGET_MAX_POWER) {
		float blurColor[] = { onR, onG, onB, onA };
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGColorRef cRef = CGColorCreate(colorSpace, blurColor);
		CGContextSetShadowWithColor(c, CGSizeMake(0,0), 10, cRef);
		CGColorRelease(cRef);
		CGColorSpaceRelease(colorSpace);
		
	}
	
	/* Draw the middle section (always) */
	
	CGContextSetRGBFillColor(c, onR, onG, onB, onA);
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, UITARGET_RADIUS, UITARGET_RADIUS);
	CGContextAddArc(c, UITARGET_RADIUS, UITARGET_RADIUS, UITARGET_CENTER_RADIUS, startRadians, endRadians, 0);
	CGContextFillPath(c);
	
	/* Now draw the rings */
	
	CGContextSetLineWidth(c, UITARGET_POWER_WIDTH);
	CGContextSetLineCap(c, kCGLineCapRound);
	for (int p = 0; p < UITARGET_MAX_POWER; p++) {
		if (p < power) {
			CGContextSetRGBStrokeColor(c, onR, onG, onB, onA);
		} else {
			CGContextSetRGBStrokeColor(c, offR, offG, offB, offA);
		}

		/* Calculate the offset from the center */
		float bandRad = UITARGET_CENTER_RADIUS - 1 + ( UITARGET_POWER_OFFSET * (p+1) );
		
		/* Calculate angles */
		float sRad = startRadians;
		float eRad = endRadians;
		if (numColors > 1) {
			sRad += 12 * UITARGET_POWERBAND_INSET / bandRad;
			eRad -= 12 * UITARGET_POWERBAND_INSET / bandRad;
		}
		
		/* Draw the arc */		
		CGContextBeginPath(c);
		CGContextAddArc(c, UITARGET_RADIUS, UITARGET_RADIUS, bandRad, sRad, eRad, 0);
		CGContextStrokePath(c);
		
		/* This has been removed  - too much blur */
		if (power == UITARGET_MAX_POWER) {
			CGContextBeginPath(c);
			CGContextAddArc(c, UITARGET_RADIUS, UITARGET_RADIUS, bandRad, sRad, eRad, 0);
			CGContextStrokePath(c);
		}
	}
	
	/* Create the imageview and add it to ourselves */
	imageBuffers[colorIndex][power] = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
	imageBuffers[colorIndex][power].frame = CGRectMake(0, 0, UITARGET_DIAMETER, UITARGET_DIAMETER);
	imageBuffers[colorIndex][power].backgroundColor = [UIColor clearColor];
	imageBuffers[colorIndex][power].hidden = YES;
	[self addSubview:imageBuffers[colorIndex][power]];
	[imageBuffers[colorIndex][power] release];
	UIGraphicsEndImageContext();	
}



- (void) _createBuffers {
	int   angle_deg = 360 / numColors;
	float angle_rad = angle_deg * (M_PI / 180.0);

	float start_radians = 0;
	for (int c = 0; c < numColors; c++) {
		for (int p = 0; p < UITARGET_NUM_POWERS; p++) {
			[self _createBufferForIndex:c forPower:p startRadians:start_radians endRadians:(start_radians + angle_rad)];			
		}
		start_radians += angle_rad;
	}
}



- (id) initAtPosition:(CGPoint)pos withNumColors:(int)numCol withColors:(LJBeamColor_t*)theColors {
	if (self = [self initWithFrame:CGRectMake(pos.x - UITARGET_RADIUS, 480 - (pos.y + UITARGET_RADIUS), UITARGET_DIAMETER, UITARGET_DIAMETER)]) {
		numColors = numCol;
		for (int c = 0; c < numColors; c++) {
			colors[c] = theColors[c];
			powers[c] = 0;			
		}
		[self _createBuffers];
		
		for (int c = 0; c < numColors; c++) {
			imageBuffers[c][0].hidden = NO;
		}
	}
	return self;
}



- (void) _handleHideView:(NSTimer*)timer {
	UIImageView *v = [timer userInfo];
	
	/* Let's do some verification that we should hide this view */
	int myPower = 0, myColor = 0;
	for (int p = 0; p < UITARGET_MAX_POWER; p++) {
		for (int c = 0; c < numColors; c++) {
			if (v == imageBuffers[p][c]) {
				myPower = p;
				myColor = c;
				goto imgBufFound;
			}
		}
	}
		
imgBufFound:
	
	if (myPower > powers[myColor]) {	
		v.hidden = YES;
	}
}



- (void) setPower:(int)power forColorIndex:(int)color {
	if (powers[color] == power) return;
	
	UIImageView *oldPower = imageBuffers[color][powers[color]];
	UIImageView *newPower = imageBuffers[color][power];
	
	if (power > powers[color]) { /* We're increasing power */
		/* First we set alpha of the new power to 0 and expose it */
		newPower.alpha = 0;
		newPower.hidden = NO;
	
		/* Now we animate the alpha transitions */
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:UITARGET_FADE_DURATION];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		newPower.alpha = 1;
		[UIView commitAnimations];
	} else { /* We're decreasing power */
		/* We animate the old power decreasing alpha */
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:UITARGET_FADE_DURATION];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		oldPower.alpha = 0;
		[UIView commitAnimations];
		
		[NSTimer scheduledTimerWithTimeInterval:UITARGET_FADE_DURATION target:self selector:@selector(_handleHideView:) userInfo:oldPower repeats:NO];
	}
	
	/* Update the new power value */
	powers[color] = power;
}



@end
