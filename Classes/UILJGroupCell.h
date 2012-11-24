//
//  UILJGroupCell.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLabel.h"

@interface UILJGroupCell : UITableViewCell {
	NSString *groupName;
	
	UICustomLabel *groupNameView;
}

- (void) setGroupName:(NSString*)newName;

@end
