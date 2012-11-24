//
//  UIPrismView.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIPrismView.h"
#import "LJBeam.h"
#import "MathHelper.h"
#import "QuartzCore/QuartzCore.h"

static BOOL     imagesInitialized = NO;
static UIImage *prismIconImages[BEAM_NUM_COLORS];

@implementation UIPrismView
@synthesize levelModel;

- (id)initWithFrame:(CGRect)frame {
	if (!imagesInitialized) {
		prismIconImages[BEAM_COLOR_CYAN]       = [[UIImage imageNamed:@"prism_cyan.png"] retain];
		prismIconImages[BEAM_COLOR_YELLOW]     = [[UIImage imageNamed:@"prism_yellow.png"] retain];
		prismIconImages[BEAM_COLOR_MAGENTA]    = [[UIImage imageNamed:@"prism_magenta.png"] retain];
		prismIconImages[BEAM_COLOR_RED]        = [[UIImage imageNamed:@"prism_red.png"] retain];
		prismIconImages[BEAM_COLOR_BLUE]       = [[UIImage imageNamed:@"prism_blue.png"] retain];
		prismIconImages[BEAM_COLOR_GREEN]      = [[UIImage imageNamed:@"prism_green.png"] retain];
		imagesInitialized = YES;
	}
	
    if (self = [super initWithFrame:frame]) {
		self.levelModel = nil;
		prismIcons = nil;
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
    }
    return self;
}



- (void) _cleanPrismIcons {
	for (int i = 0; i < [prismIcons count]; i++) {
		UIImageView *v = [prismIcons objectAtIndex:i];
		[v removeFromSuperview];
	}
	[prismIcons release];
	prismIcons = nil;	
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
}



- (void) linkToLevel:(LJLevel*)newLevelModel {
	[self _cleanPrismIcons];
	
	self.levelModel = newLevelModel;
	prismIcons  = [[NSMutableArray alloc] initWithCapacity:MAX_PRISMS_PER_LEVEL];
	
	for (int i = 0; i < levelModel.numPrisms; i++) {
		/* Create the icon view */
		LJPrism *p = [levelModel prismAtIndex:i];
		UIImageView *r = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,p.radius<<1,p.radius<<1)];
		CGPoint cen = p.position;
		cen.y = 480 - cen.y;
		r.center = cen;
		r.backgroundColor = [UIColor clearColor];
		
		/* Set the proper icon */
		r.image = prismIconImages[p.color];
								
		/* Add to our arrays and self */
		[self addSubview:r];
		[prismIcons insertObject:r atIndex:i];
		[r release];
	}
	
	[self setNeedsDisplay];
}



- (void)dealloc {
	[self _cleanPrismIcons];
	[levelModel release];
    [super dealloc];
}


@end
