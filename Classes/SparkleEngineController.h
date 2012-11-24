//
//  SparkleEngineController.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkleEngineView.h"
#import "LJLevel.h"
#import "UIDiscView.h"
#import "UIPrismView.h"
#import "UITargetView.h"
#import "UITargetOrganizerView.h"
#import "UICustomLabel.h"

#define kTableAnimationDuration 0.35
#define kLevelAnimationDuration 0.35

#define kCompleteAlpha          0.85

@interface SparkleEngineController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UIView *contentView;
	
	/* Views */
	SparkleEngineView     *sparkleView;
	UIDiscView            *discView;
	UIPrismView           *prismView;
	UITargetOrganizerView *targetView;

	/* Models */
	LJLevel               *levelModel;
	
	/* Menu button */
	UIButton              *menuButton;
	
	/* Animation timer */
	NSTimer               *animationTimer;
	
	/* Level table */
	UIView                *levelTableBackground;
	UITableView           *levelTable;
	NSMutableArray        *levelCellArray;
	
	/* Bottom header */
	UIImageView           *bottomHeader;
	UIButton              *menuExitButton;
	UISlider              *volumeSlider;
	UICustomLabel         *volumeLabel;
	
	/* Level Name */
	UICustomLabel         *levelNameView;
	
	/* The level-complete pop up */
	UIView                *levelCompleteView;	
}

+ (SparkleEngineController*) sharedInstance;

- (void) saveSparkleState;
- (void) loadSparkleState;

- (void) saveLevelState;
- (void) loadLevelState;

- (void) turnSparkleAnimationOn:(BOOL)on;
- (void) _transitionToLevel:(int)lev ofGroup:(int)grp;

- (void) reportTap;
- (void) enterStageCompleteMode;

@end
