//
//  UITargetOrganizerView.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJLevel.h"
#import "UITargetView.h"

typedef struct LJTargetViewReference {
	UITargetView *targetView;
	int           index;
} LJTargetViewReference_t;

#define TIME_ALL_ON_TO_WIN 4

@interface UITargetOrganizerView : UIView {
	LJLevel *levelModel;  /* We're going to bypass MVC for efficiency (direct M-V connection) */
	
	/* Each target in the level points to one UITargetView instance at a certain index */
	int                     numTargets;  // The number of actual targets
	LJTargetViewReference_t targetReferences[MAX_TARGETS_PER_LEVEL];
	
	/* The target views (views may group multiple targets) */	
	NSMutableArray *targetViews;  // The actual views
	
	/* Update timer */
	NSTimer *updateTimer;
	
	/* Have we completed the level? */
	BOOL haveCompleted;
	int  timeAllOn;
	
	/* The tutorial image */
	UIImageView *tutorialView;
}


@property (nonatomic, readonly) BOOL haveCompleted;
@property (nonatomic, retain) LJLevel *levelModel;

- (void) linkToLevel:(LJLevel*)newLevelModel;
- (void) updateTarget:(int)target toPower:(int)power;

- (void) startUpdating;
- (void) stopUpdating;

- (void) setTutorialImage:(NSString*)tutorial;

@end
