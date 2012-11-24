//
//  UILJLevelCell.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UILJLevelCell.h"
#import "LJLevelData.h"

static UIImage *background_beaten   = nil;
static UIImage *background_unbeaten = nil;

@implementation UILJLevelCell
@synthesize levelNum, groupNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.backgroundColor = [UIColor clearColor];
		
		if (!background_beaten) {
			background_beaten   = [UIImage imageNamed:@"menu_background_beaten.png"];
			background_unbeaten = [UIImage imageNamed:@"menu_background_unbeaten.png"];
		}
		
		backgroundImage = [[UIImageView alloc] initWithImage:background_unbeaten];
		[self addSubview:backgroundImage];
		[backgroundImage release];
		
		levelNameView = [[UICustomLabel alloc] initWithFrame:CGRectMake(90, 33, 240, 30)];
		levelNameView.textColor = [UIColor whiteColor];
		levelNameView.backgroundColor = [UIColor clearColor];
		levelNameView.customFont = [FontHelper fontHelperWithName:kFontNameLevelName];
		levelNameView.customSize = 30;
		levelNameView.alpha = 0.5;
		levelNameView.text = @"ERROR";
		levelNameView.textAlignment = NSTextAlignmentLeft;
		[self addSubview:levelNameView];
		[levelNameView release];
		
		starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_off.png"]];
		starImage.frame = CGRectMake(16, 10, 32, 48);
		starImage.alpha = 0.0;
		[self addSubview:starImage];
		[starImage release];
		
		levelName = nil;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setLevelName:(NSString*)newName {
	[levelName release];
	levelName = [[newName uppercaseString] retain];
	levelNameView.text = levelName;
	[levelNameView setNeedsDisplay];
}

- (void) setLevelNum:(int)lnum groupNum:(int)gnum {
	levelNum = lnum;
	groupNum = gnum;
}

- (void) setBeaten:(BOOL)b {
	beaten = b;
	if (beaten) {
		
		NSString *screenShotFileName = g_groupData.groups[groupNum].levels[levelNum].levelTag;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *ssFile = [NSString stringWithFormat:@"%@/screenshot_%@", documentsDirectory, screenShotFileName];
		
		starImage.image = [UIImage imageWithContentsOfFile:ssFile];
		//starImage.image = [UIImage imageNamed:@"star.png"];
		starImage.frame = CGRectMake(12, 5, 60, 90);
		starImage.alpha = 1;
		
		backgroundImage.image = background_beaten;
		
		//levelNameView.customColor = [UIColor colorWithRed:245/255.0 green:255/255.0 blue:180/255.0 alpha:1];
		levelNameView.alpha = 1;
	}
}


- (void)dealloc {
	[levelName release];
    [super dealloc];
}


@end
