//
//  UIPrismView.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJLevel.h"

@interface UIPrismView : UIView {
	LJLevel *levelModel;  /* We're going to bypass MVC for efficiency (direct M-V connection) */
	
	NSMutableArray *prismIcons;
}


@property (nonatomic, retain) LJLevel *levelModel;

- (void) linkToLevel:(LJLevel*)newLevelModel;


@end
