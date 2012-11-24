//
//  UIDiscView.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJLevel.h"

#define DISC_ICON_SIZE 32

#define DISC_DRAG_RADIUS_BAND 15

/* UIDiscView draws all discs together */

@interface UIDiscView : UIView {
	LJLevel *levelModel;  /* We're going to bypass MVC for efficiency (direct M-V connection) */
	
	NSMutableArray *discIcons;
	NSMutableArray *discRadars;
	
	/* Touch handling state */
	int  activeDisc;
	BOOL movingCenter;
	
	/* Should this view report all touches back to the controller? mainly for tap-anywhere purposes */
	BOOL reportAllTouches;
}

@property (nonatomic, assign) BOOL     reportAllTouches;
@property (nonatomic, retain) LJLevel *levelModel;

- (void) linkToLevel:(LJLevel*)newLevelModel;

@end
