//
//  LJLevel.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LJLevel.h"
#import "LJLevelData.h"

@implementation LJLevel

@synthesize numTargets, numDiscs, numPrisms, levelId, groupId, levelName;

- (id) init {
	if (self = [super init]) {
		memset(beams, 0, sizeof(beams));
		memset(targets, 0, sizeof(targets));
		memset(prisms, 0, sizeof(prisms));
		memset(discs, 0, sizeof(discs));
		
		beamsHead = 0;
		beamsTail = 0;
		numTargets = 0;
		numPrisms = 0;
		numDiscs = 0;
	}
	return self;
}



- (id) initWithLevel:(int)level fromGroup:(int)group {
	if (self = [self init]) {
		
		/* Sanity checking */
		if (group >= g_groupData.numGroups) {
			[NSException raise:@"InvalidGroup" format:@"group (%d) is invalid (max=%d)", group, g_groupData.numGroups];
			[self release];
			return nil;
		}
		
		if (level >= g_groupData.groups[group].numLevels) {
			[NSException raise:@"InvalidGroup" format:@"level (%d) of group (%d) is invalid (max=%d)", level, group, g_groupData.groups[group].numLevels];
			[self release];
			return nil;
		}
		
		LJLevelData_t *levelData = &(g_groupData.groups[group].levels[level]);
		
		/* Assign global values */
		levelId        = level;
		groupId        = group;
		startColor     = levelData->startColor;
		levelName      = levelData->levelName;
		beamHome       = levelData->beamHome;
		homeJitter     = levelData->homeJitter;
		beamVelocity   = levelData->beamVelocity;
		velocityJitter = levelData->velocityJitter;
		beamCharge     = levelData->maxCharge;
		friction       = levelData->friction;
		
		/* Create discs */
		numDiscs     = levelData->numDiscs;
		for (int i = 0; i < numDiscs; i++) {
			discs[i] = [[LJDisc alloc] initWithType:levelData->discs[i].type withDirection:levelData->discs[i].direction atPosition:levelData->discs[i].position];
		}

		/* Create targets */
		numTargets   = levelData->numTargets;
		for (int i = 0; i < numTargets; i++) {
			targets[i] = [[LJTarget alloc] initWithColor:levelData->targets[i].color atPosition:levelData->targets[i].position withTrack:levelData->targets[i].musicTrack];
		}

		/* Create prisms */
		numPrisms    = levelData->numPrisms;
		for (int i = 0; i < numPrisms; i++) {
			prisms[i] = [[LJPrism alloc] initWithColor:levelData->prisms[i].color atPosition:levelData->prisms[i].position withRadius:levelData->prisms[i].radius];
		}
		
		/* Beam initialization */
		for (int i = 0; i < MAX_BEAMS_PER_LEVEL; i++) {
			beams[i] = [[LJBeam alloc] init];
			[beams[i] resetToPosition:beamHome withJitter:homeJitter withVelocity:beamVelocity withVelocityJitter:velocityJitter withFriction:friction withCharge:beamCharge withStartColor:startColor];
		}
		beamsHead = 0;
		beamsTail = 0;
		beamIntroCounter = BEAM_INTRODUCTION_RATE;
	}
	return self;
}



- (void) _cleanLevelData {
	int i;
	
	for (i = 0; i < MAX_BEAMS_PER_LEVEL; i++) {
		[beams[i] release];
		beams[i] = nil;
	}
	for (i = 0; i < MAX_TARGETS_PER_LEVEL; i++) {
		[targets[i] release];
		targets[i] = nil;
	}
	for (i = 0; i < MAX_DISCS_PER_LEVEL; i++) {
		[discs[i] release];
		discs[i] = nil;
	}
	for (i = 0; i < MAX_PRISMS_PER_LEVEL; i++) {
		[prisms[i] release];
		prisms[i] = nil;
	}
	
	beamsHead = beamsTail = 0;
	numDiscs = numTargets = numPrisms = 0;
}



- (void) dealloc {
	[self _cleanLevelData];
	[super dealloc];
}



- (void) advanceOneStep {

	/* Advance all of the targets */
	for (int t = 0; t < numTargets; t++) {
		[targets[t] advanceOneStep];
	}
	
	/* Apply effects to active beams */
	for (int b = beamsHead; b != beamsTail; b = ((b + 1) & MAX_BEAMS_PER_LEVEL_MASK)) {
		LJBeam *beam = beams[b];
		if (!beam.alive) continue;
		
		int bx = beam.int_x;
		int by = beam.int_y;
		
		/* Iterate through discs to see if we intersect */
		BOOL didIntersect = NO;
		for (int d = numDiscs-1; d >= 0; d--) {
			LJDisc *disc = discs[d];
			if (isPointInCircle(bx, by, disc.position.x, disc.position.y, disc.radius)) {
				switch (disc.type) {
					case LJDISCTYPE_PUSH: {
						[beam pushInFixedDirection:disc.direction withForce:DISC_PUSH_FORCE];
					} break;
					case LJDISCTYPE_SPEEDUP: {
						[beam speedUpByFactor:DISC_SPEED_UP_FACTOR];
					} break;
					case LJDISCTYPE_SLOWDOWN: {
						[beam speedUpByFactor:DISC_SLOW_DOWN_FACTOR];
					} break;
					case LJDISCTYPE_BOUNCE: {
						[beam bounceOffDisc:disc.position];
					} break;
					case LJDISCTYPE_ATTRACT: {
						[beam pullToPoint:disc.position direction:YES];
					} break;
					case LJDISCTYPE_REPEL: {
						[beam pullToPoint:disc.position direction:NO];
					} break;
					case LJDISCTYPE_SPLIT: {
						[beam splitByDisc:disc.position];
					} break;
					default: break;
				}
				didIntersect = YES;
			}
		}
		beam.wasInDisc = didIntersect;
			
		/* Let's see if the beam hit a target? */
		for (int t = numTargets-1; t >= 0; t--) {
			LJTarget *target = targets[t];
			if (isPointInCircle(bx, by, target.position.x, target.position.y, LJTARGET_RADIUS)) {
				if (target.color == beam.color) {
					[target powerUpFromBeam];
				}
			}
		}
		
		/* Reset dead beams */
		if (beam.int_x > BEAM_MAX_X ||
			beam.int_y > BEAM_MAX_Y ||
			beam.int_x < BEAM_MIN_X ||
			beam.int_y < BEAM_MIN_Y ||
			beam.lifeLeft < 0       ||
			(!beam.curCharge && fabs(beam.spd_x) < BEAM_MIN_VEL && fabs(beam.spd_y) < BEAM_MIN_VEL) ) {
			
			[beam kill];

			if (b == beamsHead) do {
				beamsHead = (beamsHead + 1) & MAX_BEAMS_PER_LEVEL_MASK;
			} while (beamsHead != beamsTail && !(beams[beamsHead].alive));
		}
		
	}
	
	/* Add new beams if necessary */
	beamIntroCounter--;
	if (beamIntroCounter <= 0) {
		if ( ((beamsTail+1) & MAX_BEAMS_PER_LEVEL_MASK) == beamsHead) return; /* Can't add into a full buffer */
		
		[beams[beamsTail] resetToPosition:beamHome withJitter:homeJitter withVelocity:beamVelocity withVelocityJitter:velocityJitter withFriction:friction withCharge:beamCharge withStartColor:startColor];
		beamsTail = (beamsTail + 1) & MAX_BEAMS_PER_LEVEL_MASK;
		beamIntroCounter = BEAM_INTRODUCTION_RATE + (fastRand() & BEAM_INTRODUCTION_RATE_JITTER);
	}

}



- (void) drawGlows {
	for (int b = beamsHead; b != beamsTail; b = ((b + 1) & MAX_BEAMS_PER_LEVEL_MASK)) {
		LJBeam *beam = beams[b];
		if (!beam.alive) continue;
		[beam drawGlow];
		
		/* Todo: what to do about this? Needs to advance between the glow and segments */
		[beam advanceOneStep];
		
		/* Iterate through prisms to see if we hit */
		for (int p = numPrisms-1; p >= 0; p--) {
			LJPrism *prism = prisms[p];
			if (beam.color != prism.color && isPointInCircle(beam.int_x, beam.int_y, prism.position.x, prism.position.y, prism.radius)) {
				[beam transitionToNewColor:prism.color];
			}
		}
	}
}



- (void) drawSegments {
	for (int b = beamsHead; b != beamsTail; b = ((b + 1) & MAX_BEAMS_PER_LEVEL_MASK)) {
		LJBeam *beam = beams[b];
		if (!beam.alive) continue;		
		[beam drawSegments];
	}
}



- (LJTarget*)targetAtIndex:(int)index {
	return targets[index];
}



- (LJPrism*)prismAtIndex:(int)index {
	return prisms[index];
}



- (LJDisc*)discAtIndex:(int)index {
	return discs[index];
}


+ (void) fromLevelTag:(NSString*)tag getLevelNum:(int*)levNum andGroupNum:(int*)grpNum {
	int gNum = 0;
	int lNum = 0;
	while (gNum < g_groupData.numGroups) {
		lNum = 0;
		while (lNum < g_groupData.groups[gNum].numLevels) {
			if ([g_groupData.groups[gNum].levels[lNum].levelTag isEqualToString:tag]) {
				*levNum = lNum;
				*grpNum = gNum;
				return;
			}
			lNum++;
		}
		gNum++;
	}
	*levNum = 0;
	*grpNum = 0;
	return;
}


@end
