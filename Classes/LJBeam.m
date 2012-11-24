//
//  LJBeam.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LJBeam.h"

/* glowVerticies outline the glow rectangle */
#define GLOW_WIDTH  5
#define GLOW_WIDTHN (0 - GLOW_WIDTH)
const GLfloat glowVerticies[] = {
	0, GLOW_WIDTHN,
	1, GLOW_WIDTHN,
	0, GLOW_WIDTH,
	1, GLOW_WIDTH,
};

BeamColorComps_t g_beamColorComps[BEAM_NUM_COLORS] = {
	{ 255, 255, 255, 255}, //WHITE
	{ 96,   255, 255, 255}, //CYAN
	{ 255, 96,   255, 255}, //MAGENTA
	{ 255, 255, 96,   255}, //YELLOW
	{ 0,   0,   255, 255}, //BLUE
	{ 255, 0,   0,   255}, //RED
	{ 96,  255, 96,  255}, //GREEN

	{ 255, 128, 128, 255}, //CHR1
	{ 255, 210, 103, 255}, //CHR2
	{ 255, 103, 228, 255}, //CHR3
	
	{ 128, 128,  255, 255}, //DIV1
	{ 64, 220, 255,  255}, //DIV2
	{ 255, 160,  255, 255}, //DIV3

	{ 255, 255,  64, 255}, //REP1
	{ 255, 160, 96,  255}, //REP2

	{ 255, 255, 0, 255}, //RAINBOW
};

#define GLOW_STRENGTH 160
BeamColorComps_t g_glowColorComps[BEAM_NUM_COLORS] = {
	{ GLOW_STRENGTH, GLOW_STRENGTH, GLOW_STRENGTH, 255}, //WHITE
	{ 0,             GLOW_STRENGTH, GLOW_STRENGTH, 255}, //CYAN
	{ GLOW_STRENGTH, 0,             GLOW_STRENGTH, 255}, //MAGENTA
	{ GLOW_STRENGTH, GLOW_STRENGTH, 0,             255}, //YELLOW
	{ 0,             0,             GLOW_STRENGTH, 255}, //BLUE
	{ GLOW_STRENGTH, 0,             0,             255}, //RED
	{ 10,             GLOW_STRENGTH, 10,             255}, //GREEN


	{ GLOW_STRENGTH, 80           , 80           , 255}, //CHR1
	{ GLOW_STRENGTH, GLOW_STRENGTH*0.75, 80            , 255}, //CHR2
	{ GLOW_STRENGTH, 0            , GLOW_STRENGTH, 255}, //CHR3

{ GLOW_STRENGTH*0.15, GLOW_STRENGTH*0.21, GLOW_STRENGTH, 255 }, //DIV1
{ GLOW_STRENGTH*0.1, GLOW_STRENGTH*0.85, GLOW_STRENGTH, 255 }, //DIV2
{ GLOW_STRENGTH, GLOW_STRENGTH*0.45, GLOW_STRENGTH, 255 }, //DIV3

{ GLOW_STRENGTH, GLOW_STRENGTH, 40, 255 }, //REP1
{ GLOW_STRENGTH, 80, 20, 255 }, //REP2


	{ GLOW_STRENGTH, GLOW_STRENGTH, GLOW_STRENGTH, 255}, //RAINBOW
};


@implementation LJBeam

@synthesize color, alive, int_x, int_y, int_spd, curCharge, spd_x, spd_y, lifeLeft, wasInDisc;



- (void) _setCurrentSegmentColor:(LJBeamColor_t)segColor {
	BeamColorComps_t *col = &g_glowColorComps[segColor];
	memcpy(&currentSegmentColor[0],  col, sizeof(BeamColorComps_t));
	memcpy(&currentSegmentColor[4],  col, sizeof(BeamColorComps_t));
	memcpy(&currentSegmentColor[8],  col, sizeof(BeamColorComps_t));
	memcpy(&currentSegmentColor[12], col, sizeof(BeamColorComps_t));	
}



- (void) _initializeToColor:(LJBeamColor_t)newColor {
	color = newColor;
	
	/* And let's quickly fill out the entire color array */
	BeamColorComps_t *comp = &g_beamColorComps[color];
	[self _setCurrentSegmentColor:color];
	
	const uint8_t alpha_deg = 255 / BEAM_SEGMENT_LEN;
	uint8_t alpha = 255;
		
	for (int c = 0; c < BEAM_SEGMENT_LEN; c++) {
		BeamColorComps_t *seg = (BeamColorComps_t*)&segmentColors[c << 2];
		memcpy(seg, comp, sizeof(BeamColorComps_t));
		seg->alpha = alpha;
		alpha -= alpha_deg;
	}
	
	/* Initialize the segment color index to indicate we are "done transitioning" colors */
	segmentColorIndex = BEAM_SEGMENT_LEN;
}



- (id) init {
	if (self = [super init]) {
		[self resetToPosition:CGPointMake(0,0) withJitter:1 withVelocity:CGSizeMake(1,1) withVelocityJitter:0 withFriction:1 withCharge:20 withStartColor:BEAM_COLOR_WHITE];
	}
	return self;
}



- (void) _refactorVelocityInfo {
	int intx = (int)spd_x;
	int inty = (int)spd_y;
	int_spd = HYP_OF( abs(intx), abs(inty) );
	
	deg_angle = ATAN_OF(intx, inty);
	rad_angle = _DEG2RAD(deg_angle);
}



- (void) resetToPosition:(CGPoint)position withJitter:(int)jitter withVelocity:(CGSize)velocity withVelocityJitter:(int)velJitter withFriction:(float)levFriction withCharge:(int)levCharge withStartColor:(LJBeamColor_t)startColor {
	segmentPositionIndex = BEAM_SEGMENT_HISTORY_BUF_SZ;
	
	/* Set position */
	real_x = position.x + (fastRand()&jitter);
	real_y = position.y + (fastRand()&jitter);
	
	/* Set velocity */
	spd_x  = velocity.width + (fastRand()&velJitter);
	spd_y  = velocity.height + (fastRand()&velJitter);
	[self _refactorVelocityInfo];
	
	/* friction */
	friction = levFriction;
	curCharge = maxCharge = levCharge;
	
	/* Set default color to white */
	[self _initializeToColor:startColor];
	
	/* Bring to life! */
	alive = YES;
	lifeLeft = BEAM_MAX_LIFE;
	
	/* Not in a disc */
	wasInDisc = NO;
}



- (void) transitionToNewColor:(LJBeamColor_t)newColor {
	color = newColor;
	memcpy(segmentColors, &g_beamColorComps[newColor], sizeof(BeamColorComps_t));
	[self _setCurrentSegmentColor:newColor];
	/* We've filled in one.. */
	segmentColorIndex = 1;
}



- (void) advanceOneStep {
	/* Age */
	lifeLeft--;
	
	/* Apply charge/friction */
	if (curCharge > 0) {
		curCharge--;
	} else {
		spd_x *= friction;
		spd_y *= friction;
		
		//int intx = (int)spd_x;
		//int inty = (int)spd_y;
		//int_spd = HYP_OF( abs(intx), abs(inty) );
	}
	
	/* Adjust physical location */	
	real_x += spd_x;
	real_y += spd_y;
	int_x = (int)real_x;
	int_y = (int)real_y;
		
	/* Increment the segment color index if necessary */
	if (segmentColorIndex < BEAM_SEGMENT_LEN) {
		BeamColorComps_t *target_comp = (BeamColorComps_t*)&segmentColors[segmentColorIndex << 2];
		uint8_t target_alpha = target_comp->alpha;
		memcpy(target_comp, &g_beamColorComps[color], sizeof(BeamColorComps_t));
		target_comp->alpha = target_alpha;
		segmentColorIndex++;
	}
	
	/* Increment the segment position index */
	if (segmentPositionIndex == 0) {
		int numfloats = (BEAM_SEGMENT_LEN - 1) * 2;
		/* First, if we're at the beginning we need to shift everything back */
		memcpy(&segmentPositionHistory[BEAM_SEGMENT_HISTORY_BUF_SZ - numfloats],
			   segmentPositionHistory,
			   numfloats * sizeof(float));
		segmentPositionIndex = BEAM_SEGMENT_HISTORY_SZ - (BEAM_SEGMENT_LEN - 1);		
	}
	/* Ok, let's put the new data point in */
	segmentPositionIndex -= 2;
	segmentPositionHistory[segmentPositionIndex]   = real_x;
	segmentPositionHistory[segmentPositionIndex+1] = real_y;
		
	
}



- (void) pushInFixedDirection:(Direction_t)direction withForce:(float)force {
	switch (direction) {
		case DIR_N: { spd_y += force; if (spd_y > BEAM_MAX_SPD) spd_y = BEAM_MAX_SPD; break; }
		case DIR_S: { spd_y -= force; if (spd_y < BEAM_MIN_SPD) spd_y = BEAM_MIN_SPD; break; }
		case DIR_W: { spd_x -= force; if (spd_x < BEAM_MIN_SPD) spd_x = BEAM_MIN_SPD; break; }
		case DIR_E: { spd_x += force; if (spd_x > BEAM_MAX_SPD) spd_x = BEAM_MAX_SPD; break; }
		default: { break; }
	}
	[self _refactorVelocityInfo];
	
	/* Recharge the beam */
	curCharge = maxCharge;
}



- (void) speedUpByFactor:(float)multFactor {
	spd_x *= multFactor;
	spd_y *= multFactor;

	int intx = (int)spd_x;
	int inty = (int)spd_y;
	int_spd = HYP_OF( abs(intx), abs(inty) );
	
	curCharge = maxCharge;
}



- (void) bounceOffDisc:(CGPoint)discCenter {
	/* Calculate vector to the center */
	int vectorToDiscCenter_x = discCenter.x - int_x;
	int vectorToDiscCenter_y = discCenter.y - int_y;
	
	while (abs(vectorToDiscCenter_x) >= ATAN_HELPER_HALF || abs(vectorToDiscCenter_y) >= ATAN_HELPER_HALF) {
		vectorToDiscCenter_x /= 2;
		vectorToDiscCenter_y /= 2;
	}
	
	/* Find the degree to the center */
	int degToCenter = ATAN_OF(vectorToDiscCenter_x, vectorToDiscCenter_y);
	
	/* Calculate the degree diffs */
	int degDiff = deg_angle - degToCenter;
	int absDegDiff = abs(degDiff);
	
	/* If the degree is between 90 and 270, then we're exiting the disc (no bounce) */
	if (absDegDiff >= 90 && absDegDiff <= 270) return;
	
	/* Now we get the new angle */
	int newAngle = (deg_angle + (180 - (degDiff*2)) + 360) % 360;
	
	/* Let's do this with rounding */
	spd_x = _COS_DEG(newAngle) * int_spd;
	spd_y = _SIN_DEG(newAngle) * int_spd;
	
	[self _refactorVelocityInfo];
	curCharge = maxCharge;
}



- (void) pullToPoint:(CGPoint)discCenter direction:(BOOL)toward {
	/* Calculate vector to the center */
	int vectorToDiscCenter_x = discCenter.x - int_x;
	int vectorToDiscCenter_y = discCenter.y - int_y;
	
	while (abs(vectorToDiscCenter_x) >= ATAN_HELPER_HALF || abs(vectorToDiscCenter_y) >= ATAN_HELPER_HALF) {
		vectorToDiscCenter_x /= 2;
		vectorToDiscCenter_y /= 2;
	}
	
	/* Find distance to center */
	float distToCenter = HYP_OF(abs(vectorToDiscCenter_x), abs(vectorToDiscCenter_y));
	if (distToCenter < BEAM_ATTRACT_MIN_RADIUS) {
		if (toward && int_spd < BEAM_ATTRACT_MIN_SPEED_IN_CENTER) {
			lifeLeft = 0;
		}
		return; /* Otherwise let's not affect beams too close */
	}
	//float distToCenter2 = distToCenter * distToCenter;
	
	/* The force applied */
	float forceApplied = (BEAM_ATTRACT_UNIVERSAL_CONSTANT / distToCenter);

	/* Find the degree to the center */
	int degToCenter = ATAN_OF(vectorToDiscCenter_x, vectorToDiscCenter_y);
			
	float forceX = forceApplied * _COS_DEG(degToCenter);
	float forceY = forceApplied * _SIN_DEG(degToCenter);
	
	/* Let's do this with rounding */
	if (toward) {
		spd_x += forceX;
		spd_y += forceY;
	} else {
		spd_x -= forceX / 2;
		spd_y -= forceY / 2;
	}
		
	[self _refactorVelocityInfo];
	//curCharge = maxCharge;
}



- (void) splitByDisc:(CGPoint)discCenter {
	int vectorToDiscCenter_x = discCenter.x - int_x;
	int vectorToDiscCenter_y = discCenter.y - int_y;
	
	int degToCenter = ATAN_OF(vectorToDiscCenter_x, vectorToDiscCenter_y);
	if (wasInDisc && abs(degToCenter - deg_angle) >= 120) return;
	
	int angleDiff = ( fastRand() & 1 ) ? 30 : 330;
	
	//int newPosAngle = ( degToCenter + angleDiff ) % 360;
	
	/* New x/y coords /
	float newPosCos = _COS_DEG(newPosAngle);
	float newPosSin = _SIN_DEG(newPosAngle);
	
	real_x = discCenter.x + (newPosCos * 5);
	real_y = discCenter.y + (newPosSin * 5);
	int_x = (int)real_x;
	int_y = (int)real_y;
	segmentPositionIndex -= 2;
	segmentPositionHistory[segmentPositionIndex]   = real_x;
	segmentPositionHistory[segmentPositionIndex+1] = real_y;
	*/
	
	/* Let's velocity now */
	int newVelAngle = ( deg_angle + angleDiff ) % 360;
	
	float newVelCos = _COS_DEG(newVelAngle);
	float newVelSin = _SIN_DEG(newVelAngle);
	spd_x = newVelCos * int_spd;
	spd_y = newVelSin * int_spd;

	/* x/y */
	real_x = discCenter.x + (newVelCos * 7) + (fastRand() % 9) - 4;
	real_y = discCenter.y + (newVelSin * 7) + (fastRand() % 9) - 4;
	int_x = (int)real_x;
	int_y = (int)real_y;
	segmentPositionIndex -= 2;
	segmentPositionHistory[segmentPositionIndex]   = real_x;
	segmentPositionHistory[segmentPositionIndex+1] = real_y;
	
	[self _refactorVelocityInfo];
}



- (void) kill {
	alive = NO;
}



- (void) drawGlow {
	/* Assumes we're at the identity matrix */
	glPushMatrix();
	
	/* Translate to our beam coords */
	glTranslatef(real_x, real_y, 0);
	
	/* Rotate to our angle */
	glRotatef(deg_angle, 0, 0, 1);
	
	/* Extend the glow accordingly */
	glScalef(int_spd + BEAM_GLOW_LEAD, 1, 1);

	/* Draw the glow (assume client state is proper) */
	glVertexPointer(2, GL_FLOAT,         0, glowVerticies);	
	glColorPointer (4, GL_UNSIGNED_BYTE, 0, currentSegmentColor);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);	
	
	/* All done */
	glPopMatrix();
}



- (void) drawSegments {
	glVertexPointer(2, GL_FLOAT, 0, &segmentPositionHistory[segmentPositionIndex]);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, segmentColors);
	if (segmentPositionIndex > BEAM_SEGLIMIT_CUTOFF) {
		glDrawArrays(GL_LINE_STRIP, 0, (BEAM_SEGMENT_HISTORY_BUF_SZ - segmentPositionIndex) >> 1);
	} else {
		glDrawArrays(GL_LINE_STRIP, 0, BEAM_SEGMENT_LEN-1);
	}
}



@end
