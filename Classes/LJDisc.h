//
//  LJDisc.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathHelper.h"

#define LJDISC_DEFAULT_RADIUS 48
#define LJDISC_MAX_RADIUS 240

#define DISC_PUSH_FORCE 1

#define DISC_SPEED_UP_FACTOR  1.05
#define DISC_SLOW_DOWN_FACTOR 0.95

/* Defines the different types of discs */
typedef enum LJDiscType {
	LJDISCTYPE_NONE = 0,
	LJDISCTYPE_PUSH,      /* Pushes the light in one direction */
	LJDISCTYPE_ATTRACT,   /* Attracts the light (pulls toward center) */
	LJDISCTYPE_REPEL,     /* Repels the light (pushes away from center) */
	LJDISCTYPE_SPEEDUP,   /* Causes light inside the ring to speed up */
	LJDISCTYPE_SLOWDOWN,  /* Causes light inside the ring to slow down */
	LJDISCTYPE_GRAVITY,   /* Pushes based on iPhone orientation */
	LJDISCTYPE_BOUNCE,    /* Bounces the light off the surface */
	LJDISCTYPE_SPLIT,     /* Splits the incoming beam into two possible angles */
	NUM_LJDISCTYPE,
} LJDiscType_t;

@interface LJDisc : NSObject {
	LJDiscType_t    type;
	Direction_t     direction;
	int             radius;
	CGPoint         position;
}

@property (nonatomic, readonly) LJDiscType_t type;
@property (nonatomic, readonly) Direction_t  direction;
@property (nonatomic, assign)   int          radius;
@property (nonatomic, assign)   CGPoint      position;

- (id) initWithType:(LJDiscType_t)discType withDirection:(Direction_t)aDirection atPosition:(CGPoint)pos;

@end
