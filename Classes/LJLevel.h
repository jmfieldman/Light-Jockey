//
//  LJLevel.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJBeam.h"
#import "LJTarget.h"
#import "LJPrism.h"
#import "LJDisc.h"
#import "LJLevelData.h"

#define BEAM_MAX_BOUNDS_EXTEND   200
#define BEAM_MAX_X               (320 + BEAM_MAX_BOUNDS_EXTEND)
#define BEAM_MAX_Y               (480 + BEAM_MAX_BOUNDS_EXTEND)
#define BEAM_MIN_X               (0   - BEAM_MAX_BOUNDS_EXTEND)
#define BEAM_MIN_Y               (0   - BEAM_MAX_BOUNDS_EXTEND)

#define MAX_BEAMS_PER_LEVEL      256
#define MAX_BEAMS_PER_LEVEL_MASK 0xFF

#define BEAM_INTRODUCTION_RATE   1  /* Number of frames between beams */
#define BEAM_INTRODUCTION_RATE_JITTER 0x01

@interface LJLevel : NSObject {
	
	/* Global info */
	int            levelId;          /* My level number */
	int            groupId;          /* My group number */
	LJBeamColor_t  startColor;       /* Start color */
	NSString      *levelName;        /* Level Name */
	CGPoint        beamHome;         /* Position that the beams start in */
	int            homeJitter;       /* Jitter allowed for each beam start position */
	CGSize         beamVelocity;     /* Initial beam velocity */
	int            velocityJitter;   /* Jitter allowed for each beam start velocity */
	int            beamCharge;       /* Beam charge at beginning and after discs */
	float          friction;         /* Friction applied to a beam (slows it down each step) */
		
	/* Beam buffer */
	LJBeam *beams[MAX_BEAMS_PER_LEVEL];
	int beamsHead;
	int beamsTail;
	int beamIntroCounter;
	
	/* Targets */
	LJTarget *targets[MAX_TARGETS_PER_LEVEL];
	int numTargets;
	
	/* Prisms */
	LJPrism *prisms[MAX_PRISMS_PER_LEVEL];
	int numPrisms;
	
	/* Discs */
	LJDisc *discs[MAX_DISCS_PER_LEVEL];
	int numDiscs;
}

@property (nonatomic, readonly) int levelId;
@property (nonatomic, readonly) int groupId;

@property (nonatomic, readonly) int numDiscs;
@property (nonatomic, readonly) int numTargets;
@property (nonatomic, readonly) int numPrisms;

@property (nonatomic, readonly) NSString *levelName;

+ (void) fromLevelTag:(NSString*)tag getLevelNum:(int*)levNum andGroupNum:(int*)grpNum;

- (id) initWithLevel:(int)level fromGroup:(int)group;

- (void) advanceOneStep;

- (void) drawGlows;
- (void) drawSegments;

- (LJTarget*)targetAtIndex:(int)index;
- (LJPrism*)prismAtIndex:(int)index;
- (LJDisc*)discAtIndex:(int)index;

@end
