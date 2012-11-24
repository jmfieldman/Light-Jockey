//
//  UITargetOrganizerView.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UITargetOrganizerView.h"
#import "SoundManager.h"
#import "SparkleEngineController.h"

@implementation UITargetOrganizerView
@synthesize levelModel, haveCompleted;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		if (self = [super initWithFrame:frame]) {
			self.levelModel = nil;
			
			self.backgroundColor = [UIColor clearColor];
			self.userInteractionEnabled = NO;
			
			updateTimer = nil;
			
			tutorialView = [[UIImageView alloc] initWithFrame:frame];
			tutorialView.hidden = YES;
			tutorialView.backgroundColor = [UIColor clearColor];
			[self addSubview:tutorialView];
			[tutorialView release];
		}
		return self;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {

}



- (void) _cleanTargets {
	if (!targetViews) return;
	[[SoundManager sharedInstance] clearAllBackgroundTracks];
	for (int i = 0; i < [targetViews count]; i++) {
		UITargetView *t = [targetViews objectAtIndex:i];
		[t removeFromSuperview];		
	}
	[targetViews release];
	targetViews = nil;
}



- (void) linkToLevel:(LJLevel*)newLevelModel {
	[self _cleanTargets];
	
	self.levelModel = newLevelModel;
	
	timeAllOn = 0;
	haveCompleted = NO;

	targetViews  = [[NSMutableArray alloc] initWithCapacity:MAX_TARGETS_PER_LEVEL];
	
	numTargets = levelModel.numTargets;
	BOOL dealtWith[MAX_TARGETS_PER_LEVEL]; memset(dealtWith, 0, sizeof(dealtWith));
		
	/* iterate through each target in the level */
	for (int i = 0; i < numTargets; i++) {
		
		/* Have we already dealth with this target?  If so, continue */
		if (dealtWith[i]) continue;
		
		/* Now we're guaranteed that this a target /not/ in any other view */
		dealtWith[i] = YES;
		
		/* Let's build the information for our new target view */
		int numTargetsInNewView = 1;
		LJBeamColor_t colorsOfTargetsInNewView[MAX_TARGETS_PER_LEVEL];
		colorsOfTargetsInNewView[0] = [levelModel targetAtIndex:i].color;
		
		/* And setup the background music */
		[[SoundManager sharedInstance] assignBackgroundTrack:[levelModel targetAtIndex:i].musicTrack toIndex:i];
		
		/* Now deal with the multi-target references */		
		targetReferences[i].targetView = (UITargetView*)0xDEADBEEF; /* this is an ugly hack */
		targetReferences[i].index      = 0;
		
		// These are the X/Y coords of the new view
		CGPoint newViewPosition = [levelModel targetAtIndex:i].position;

		/* Let's iterate through all of the future targets to see if we have any takers */
		for (int n = (i+1); n < numTargets; n++) {
			if (dealtWith[n]) continue;
			LJTarget *possibleTarget = [levelModel targetAtIndex:n];
			if (!CGPointEqualToPoint(newViewPosition, possibleTarget.position)) continue;
			
			/* We have a taker! */
			dealtWith[n] = YES;
			[[SoundManager sharedInstance] assignBackgroundTrack:[levelModel targetAtIndex:n].musicTrack toIndex:n];
			colorsOfTargetsInNewView[numTargetsInNewView] = possibleTarget.color;
			targetReferences[n].targetView = (UITargetView*)0xDEADBEEF;
			targetReferences[n].index      = numTargetsInNewView;
			numTargetsInNewView++;
		}
		
		/* We should now have a proper array to create the view */
		UITargetView *newTargetView = [[UITargetView alloc] initAtPosition:newViewPosition withNumColors:numTargetsInNewView withColors:colorsOfTargetsInNewView];
		[targetViews addObject:newTargetView];
		[self addSubview:newTargetView];
		[newTargetView release];
		
		/* Let's fix the references */
		for (int z = i; z < numTargets; z++) {
			if (targetReferences[z].targetView == (UITargetView*)0xDEADBEEF) targetReferences[z].targetView = newTargetView;
		}
				
	}
	
}



- (void) updateTarget:(int)target toPower:(int)power {
	LJTargetViewReference_t *ref = &targetReferences[target];
	[ref->targetView setPower:power forColorIndex:ref->index];
	[[SoundManager sharedInstance] setVolume:power/4.0 ofBackgroundTrack:target];
}



- (void) _handleUpdateTimer:(NSTimer*)timer {
	BOOL allDone = YES;
	for (int t = 0; t < numTargets; t++) {
		LJTarget *target = [levelModel targetAtIndex:t];
		int newPower = target.power >> LJTARGET_POWER_SHIFT;
		if (newPower != UITARGET_MAX_POWER) allDone = NO;

		[self updateTarget:t toPower:newPower];
	}
	
	if (!allDone) {
		timeAllOn = 0;
		haveCompleted = NO;
	} else {
		if (timeAllOn == 0) {
			timeAllOn = time(0);
			haveCompleted = NO;
		} else if ((timeAllOn + TIME_ALL_ON_TO_WIN) <= time(0)) {
			if (!haveCompleted) [[SparkleEngineController sharedInstance] enterStageCompleteMode];
			haveCompleted = YES;			
		}
	}
}



- (void) startUpdating {
	haveCompleted = NO;
	timeAllOn = 0;
	[updateTimer invalidate];
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(_handleUpdateTimer:) userInfo:nil repeats:YES];
}



- (void) stopUpdating {
	timeAllOn = 0;
	haveCompleted = NO;
		
	if (!updateTimer) return;
		
	[updateTimer invalidate];
	updateTimer = nil;
}



- (void)dealloc {
	[self stopUpdating];
	[self _cleanTargets];
	[levelModel release];
    [super dealloc];
}


- (void) setTutorialImage:(NSString*)tutorial {
	if (tutorial == nil) {
		tutorialView.hidden = YES;
		return;
	}
	
	tutorialView.hidden = NO;
	tutorialView.image = [UIImage imageNamed:tutorial];
}


@end
