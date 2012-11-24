//
//  LJTarget.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJBeam.h"

#define LJTARGET_RADIUS           32       /* Radius of the target (in pixels) */
#define LJTARGET_POWER_SCALE      1024     /* General power scale (max value of the scale) */
#define LJTARGET_POWER_SHIFT      8        /* How many bits to shift to get an integer value of power */
#define LJTARGET_BEAM_CHARGE      30       /* How many steps a new beam will lock the current power */
#define LJTARGET_STEP_POWER_REDUX 10       /* How much power is lost in a step when there is no charge */
#define LJTARGET_BEAM_POWERUP     4        /* How much power a beam will provide to the target */

@interface LJTarget : NSObject {
	LJBeamColor_t        color;
	CGPoint              position;
	int                  power;
	int                  charge;
	NSString            *musicTrack;
}

@property (nonatomic, readonly) LJBeamColor_t    color;
@property (nonatomic, assign)   CGPoint          position;
@property (nonatomic, readonly) int              power;
@property (nonatomic, readonly) NSString        *musicTrack;

- (id) initWithColor:(LJBeamColor_t)targetColor atPosition:(CGPoint)targetPos withTrack:(NSString*)trackName;
- (void) advanceOneStep;
- (void) powerUpFromBeam;

@end
