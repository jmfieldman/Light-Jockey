//
//  LJLevelData.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJBeam.h"
#import "LJDisc.h"
#import "MathHelper.h"
#import "SoundManager.h"

#define MAX_GROUPS               10
#define MAX_LEVELS_PER_GROUP     10
#define MAX_TARGETS_PER_LEVEL    10
#define MAX_PRISMS_PER_LEVEL     10
#define MAX_DISCS_PER_LEVEL      10


/* Structure to represent an individual level start state */
typedef struct LJLevelData {
	
	/* Global info */
	
	NSString      *levelName;        /* Level Name */
	NSString      *levelTag;         /* Internal tag for consistency */
	LJBeamColor_t  startColor;       /* Start beam color */
	CGPoint        beamHome;         /* Position that the beams start in */
	int            homeJitter;       /* Jitter allowed for each beam start position */
	CGSize         beamVelocity;     /* Initial beam velocity */
	int            velocityJitter;   /* Jitter allowed for each beam start velocity */
	int            maxCharge;        /* What is the beam charge? */
	float          friction;         /* Friction applied to a beam (slows it down each step) */
	
	/* Discs */
	
	int            numDiscs;         /* Number of discs available */
	struct {
		CGPoint        position;     /* Position of the disc */
		LJDiscType_t   type;         /* Type of the disc */
		Direction_t    direction;    /* Direction of the disc */
	} discs[MAX_DISCS_PER_LEVEL];
	
	/* Targets */
	
	int            numTargets;       /* Number of targets */
	struct {
		CGPoint        position;     /* Position of the target */
		LJBeamColor_t  color;        /* Color index */
		NSString      *musicTrack;   /* Name of music track to play */
	} targets[MAX_TARGETS_PER_LEVEL];
	
	/* Prisms */
	
	int            numPrisms;        /* Number of prisms */
	struct {
		CGPoint        position;     /* Position of the prism */
		LJBeamColor_t  color;        /* Color */
		int            radius;       /* Radius */
	} prisms[MAX_PRISMS_PER_LEVEL];
	
} LJLevelData_t;


/* Structure to represent a groups's organization */
typedef struct LJGroupData {
	
	int            numGroups;
	struct {
		
		/* Level data inside the group */
		
		int               numLevels;
		NSString         *groupName;
		NSString         *finishSound;
		LJLevelData_t	  levels[MAX_LEVELS_PER_GROUP];
		
	} groups[MAX_GROUPS];
	
} LJGroupData_t;


/* Level data array */
extern LJGroupData_t g_groupData;

/* Level beaten-state */
extern BOOL g_levelBeatenState[MAX_GROUPS][MAX_LEVELS_PER_GROUP];

/* Get next levels */
void GetNextLevelAndGroupAfter(int level, int group, int *nextLevel, int *nextGroup);
