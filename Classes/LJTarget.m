//
//  LJTarget.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LJTarget.h"


@implementation LJTarget

@synthesize color, position, power, musicTrack;

- (id) initWithColor:(LJBeamColor_t)targetColor atPosition:(CGPoint)targetPos withTrack:(NSString*)trackName {
	if (self = [super init]) {
		color = targetColor;
		position = targetPos;
		power = 0;
		charge = 0;
		musicTrack = [trackName retain];
	}
	return self;
}



- (void) advanceOneStep {
	/* If we have charge from a beam then decrement charge and return */
	if (charge > 0) {
		charge--;
		return;
	}
	
	/* Otherwise reduce the power */
	if (power > 0) {
		power -= LJTARGET_STEP_POWER_REDUX;
		if (power < 0) power = 0;
	}
}



- (void) powerUpFromBeam {
	charge = LJTARGET_BEAM_CHARGE;
	power += LJTARGET_BEAM_POWERUP;
	if (power > LJTARGET_POWER_SCALE) power = LJTARGET_POWER_SCALE;
}



- (void) dealloc {
	[musicTrack release];
	[super dealloc];
}


@end
