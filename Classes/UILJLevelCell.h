//
//  UILJLevelCell.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLabel.h"

@interface UILJLevelCell : UITableViewCell {
	UIImageView *backgroundImage;
	
	NSString *levelName;
	int       levelNum;
	int       groupNum;
	BOOL      beaten;
	UIImageView *starImage;
	
	UICustomLabel *levelNameView;
}

@property (nonatomic, readonly) int levelNum;
@property (nonatomic, readonly) int groupNum;

- (void) setLevelName:(NSString*)newName;
- (void) setLevelNum:(int)lnum groupNum:(int)gnum;
- (void) setBeaten:(BOOL)b;

@end
