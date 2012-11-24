//
//  UILJGroupCell.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UILJGroupCell.h"


@implementation UILJGroupCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		groupName = nil;
		
		
		groupNameView = [[UICustomLabel alloc] initWithFrame:CGRectMake(90, 13, 240, 24)];
		groupNameView.textColor = [UIColor whiteColor];
		groupNameView.backgroundColor = [UIColor clearColor];
		groupNameView.customFont = [FontHelper fontHelperWithName:kFontNameLevelName];
		groupNameView.customSize = 24;
		groupNameView.customColor = [UIColor colorWithRed:0.6 green:0.85 blue:1 alpha:1];
		groupNameView.alpha = 0.8;
		groupNameView.text = @"ERROR";
		groupNameView.textAlignment = UITextAlignmentLeft;
		[self addSubview:groupNameView];
		[groupNameView release];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	return;
}


- (void) setGroupName:(NSString*)newName {
	[groupName release];
	groupName = [newName retain];
	groupNameView.text = groupName;
	[groupNameView setNeedsDisplay];
}


- (void)dealloc {
	[groupName release];
    [super dealloc];
}


@end
