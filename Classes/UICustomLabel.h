//
//  UICustomLabel.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontHelper.h"

@interface UICustomLabel : UILabel {
	FontHelper *customFont;
	UIColor    *customColor;
	int         customSize;
}

@property (nonatomic, retain) FontHelper *customFont;
@property (nonatomic, retain) UIColor    *customColor;
@property (nonatomic, assign) int         customSize;

@end
