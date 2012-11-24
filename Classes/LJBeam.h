//
//  LJBeam.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "MathHelper.h"

/* BeamColor defines the possible beam colors */
typedef enum LJBeamColor {
	BEAM_COLOR_WHITE = 0,
	BEAM_COLOR_CYAN,
	BEAM_COLOR_MAGENTA,
	BEAM_COLOR_YELLOW,
	BEAM_COLOR_BLUE,
	BEAM_COLOR_RED,
	BEAM_COLOR_GREEN,
	
	BEAM_COLOR_CHR1,
	BEAM_COLOR_CHR2,
	BEAM_COLOR_CHR3,
	
	BEAM_COLOR_DIV1,
	BEAM_COLOR_DIV2,
	BEAM_COLOR_DIV3,
	
	BEAM_COLOR_REP1,
	BEAM_COLOR_REP2,
	
	BEAM_COLOR_RAINBOW,
	BEAM_NUM_COLORS,
} LJBeamColor_t;

/* A quick structure for carrying color info */
typedef struct BeamColorComps {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
	uint8_t alpha;
} __attribute__ ((packed)) BeamColorComps_t;

/* Accessible array for quick color lookup based on beam color */
extern BeamColorComps_t g_beamColorComps[BEAM_NUM_COLORS];

/* Min and max speeds of a beam (per axis) */
#define BEAM_MAX_SPD 60
#define BEAM_MIN_SPD -60
#define BEAM_MIN_VEL 0.3

/* Beam Glow lead: A measure of how far the glow preceeds the segments */
#define BEAM_GLOW_LEAD 3

/* How long to beams live for (max)? */
#define BEAM_MAX_LIFE  240  /* At 30 fps this is 8 seconds */

/* For attraction */
#define BEAM_ATTRACT_MIN_RADIUS 16
#define BEAM_ATTRACT_MIN_SPEED_IN_CENTER 8
#define BEAM_ATTRACT_UNIVERSAL_CONSTANT_INFLECTION_RADIUS 8
#define BEAM_ATTRACT_UNIVERSAL_CONSTANT (BEAM_ATTRACT_UNIVERSAL_CONSTANT_INFLECTION_RADIUS * BEAM_ATTRACT_UNIVERSAL_CONSTANT_INFLECTION_RADIUS)

/* How many segments we show in the beam trail? */
#define BEAM_SEGMENT_LEN 20
#define BEAM_SEGMENT_HISTORY_SZ 1024
#define BEAM_SEGMENT_HISTORY_BUF_SZ (BEAM_SEGMENT_HISTORY_SZ<<1)
#define BEAM_SEGLIMIT_CUTOFF        (BEAM_SEGMENT_HISTORY_BUF_SZ - (BEAM_SEGMENT_LEN-1)*2)

/* The Beam model */
@interface LJBeam : NSObject {
	/* Position */
	float real_x;
	float real_y;
	int int_x;
	int int_y;
	
	/* Velocity */
	float spd_x;
	float spd_y;
	int   int_spd;
	float rad_angle;
	int   deg_angle;
	
	/* Friction */
	float friction;
	
	/* Charge - how many more steps before friction takes over? */
	int curCharge;
	int maxCharge;
	
	/* Color */
	LJBeamColor_t color;
	
	/* Was I in a disc? */
	BOOL wasInDisc;
	
	/* Life */
	BOOL alive;
	int  lifeLeft;
	
	/* Segment position history buffer */
	float segmentPositionHistory[BEAM_SEGMENT_HISTORY_SZ * 2];
	int   segmentPositionIndex;
	
	/* Segment colors */
	GLubyte segmentColors[BEAM_SEGMENT_LEN * sizeof(BeamColorComps_t)];
	int     segmentColorIndex;
	GLubyte currentSegmentColor[16];
}

@property (nonatomic, readonly) LJBeamColor_t color;
@property (nonatomic, readonly) BOOL          alive;
@property (nonatomic, readonly) int           lifeLeft;
@property (nonatomic, readonly) int           int_x;
@property (nonatomic, readonly) int           int_y;
@property (nonatomic, readonly) float         spd_x;
@property (nonatomic, readonly) float         spd_y;
@property (nonatomic, readonly) int           int_spd;
@property (nonatomic, readonly) int           curCharge;
@property (nonatomic, assign)   BOOL          wasInDisc;

- (void) resetToPosition:(CGPoint)position withJitter:(int)jitter withVelocity:(CGSize)velocity withVelocityJitter:(int)velJitter withFriction:(float)levFriction withCharge:(int)levCharge withStartColor:(LJBeamColor_t)startColor;
- (void) kill;
- (void) advanceOneStep;
- (void) transitionToNewColor:(LJBeamColor_t)newColor;

- (void) drawGlow;
- (void) drawSegments;

- (void) pushInFixedDirection:(Direction_t)direction withForce:(float)force;
- (void) speedUpByFactor:(float)multFactor;
- (void) bounceOffDisc:(CGPoint)discCenter;
- (void) pullToPoint:(CGPoint)discCenter direction:(BOOL)toward;
- (void) splitByDisc:(CGPoint)discCenter;

@end
