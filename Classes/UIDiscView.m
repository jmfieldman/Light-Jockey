//
//  UIDiscView.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIDiscView.h"
#import "LJDisc.h"
#import "MathHelper.h"
#import "QuartzCore/QuartzCore.h"
#import "SparkleEngineController.h"

static BOOL     imagesInitialized = NO;
static UIImage *discIconImages[NUM_LJDISCTYPE];
static UIImage *discRadarImage;

@implementation UIDiscView
@synthesize levelModel, reportAllTouches;

- (id)initWithFrame:(CGRect)frame {
	if (!imagesInitialized) {
		/*
		discRadarImage                        = [[UIImage imageNamed:@"disc_radar.png"] retain];
		discIconImages[LJDISCTYPE_PUSH]       = [[UIImage imageNamed:@"disc_push.png"] retain];
		discIconImages[LJDISCTYPE_SPEEDUP]    = [[UIImage imageNamed:@"disc_speed.png"] retain];
		discIconImages[LJDISCTYPE_SLOWDOWN]   = [[UIImage imageNamed:@"disc_slow.png"] retain];
		discIconImages[LJDISCTYPE_ATTRACT]    = [[UIImage imageNamed:@"disc_attract.png"] retain];
		discIconImages[LJDISCTYPE_BOUNCE]     = [[UIImage imageNamed:@"disc_bounce.png"] retain];
		discIconImages[LJDISCTYPE_REPEL]      = [[UIImage imageNamed:@"disc_repel.png"] retain];
		 */
		imagesInitialized = YES;
	}
	
    if (self = [super initWithFrame:frame]) {
		self.levelModel = nil;
		discIcons = nil;
		discRadars = nil;
		
		self.backgroundColor = [UIColor clearColor];
		
		activeDisc = -1;
		reportAllTouches = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	
}



- (void) _cleanDiscIcons {
	for (int i = 0; i < [discIcons count]; i++) {
		UIImageView *v = [discIcons objectAtIndex:i];
		[v removeFromSuperview];
	}
	[discIcons release];
	discIcons = nil;
	
	for (int i = 0; i < [discRadars count]; i++) {
		UIImageView *v = [discRadars objectAtIndex:i];
		[v removeFromSuperview];
	}
	[discRadars release];
	discRadars = nil;
}



- (void) linkToLevel:(LJLevel*)newLevelModel {
	[self _cleanDiscIcons];
	
	self.levelModel = newLevelModel;
	discIcons  = [[NSMutableArray alloc] initWithCapacity:MAX_DISCS_PER_LEVEL];
	discRadars = [[NSMutableArray alloc] initWithCapacity:MAX_DISCS_PER_LEVEL];
	
	for (int i = 0; i < levelModel.numDiscs; i++) {
		/* Create the icon view */
		LJDisc *d = [levelModel discAtIndex:i];
		UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DISC_ICON_SIZE,DISC_ICON_SIZE)];
		UIImageView *r = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,d.radius<<1,d.radius<<1)];
		CGPoint cen = d.position;
		cen.y = 480 - cen.y;
		v.center = cen;
		v.backgroundColor = [UIColor clearColor];
		r.center = cen;
		r.backgroundColor = [UIColor clearColor];
		
		/* Set the proper icon */
		v.image = discIconImages[d.type];
		r.image = discRadarImage;
		
		/* And rotation */
		if (d.type == LJDISCTYPE_PUSH) {
			float radians = 0;
			if (d.direction == DIR_E) radians = M_PI_2;
			if (d.direction == DIR_S) radians = M_PI;
			if (d.direction == DIR_W) radians = M_PI + M_PI_2;
			
			CATransform3D rotate = CATransform3DIdentity;
			rotate = CATransform3DRotate(rotate, radians, 0, 0, 1);
			v.layer.transform = rotate;
		}
		
		/* Add to our arrays and self */
		//[self addSubview:v];
		[discIcons insertObject:v atIndex:i];
		//[self addSubview:r];
		//[self sendSubviewToBack:r];
		[discRadars insertObject:r atIndex:i];
		[v release];
		[r release];
	}
	
	[self setNeedsDisplay];
}


- (void)dealloc {
	[self _cleanDiscIcons];
	[levelModel release];
    [super dealloc];
}



#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (reportAllTouches) {
		[[SparkleEngineController sharedInstance] reportTap];
		return;
	}
	
	NSArray *myTouches = [[event touchesForView:self] allObjects];
	UITouch *t = [myTouches objectAtIndex:0];
	CGPoint p =  [t locationInView:self];
	p.y = 480 - p.y;
	activeDisc = -1;
	movingCenter = YES;
	
	for (int i = 0; i < levelModel.numDiscs; i++) {
		//UIImageView *v = [discIcons objectAtIndex:i];
		LJDisc *d = [levelModel discAtIndex:i];
		if (d.type == LJDISCTYPE_SPLIT) continue; /* Can't move splitters */
		
		CGPoint vcen = d.position;
		int dx = abs(vcen.x - p.x);
		int dy = abs(vcen.y - p.y);
		float distance = sqrt( dx*dx + dy*dy );
		
		if ( distance <= 20 ) {
			activeDisc = i;
			movingCenter = YES;
			return;
		}

		if ( abs(distance - d.radius) < DISC_DRAG_RADIUS_BAND && d.type != LJDISCTYPE_SPLIT ) {
			activeDisc = i;
			movingCenter = NO;
		}
		
		if (movingCenter && distance < d.radius) {
			activeDisc = i;
		}
	}
	
	/* Resize disc if double-tap */
	if (activeDisc >= 0 && movingCenter && t.tapCount == 2) {
		LJDisc *d = [levelModel discAtIndex:activeDisc];
		d.radius = LJDISC_DEFAULT_RADIUS;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	/* No active disc? Return */
	if (activeDisc == -1) return;
	
	NSArray *myTouches = [[event touchesForView:self] allObjects];
	
	/* objects */
	//UIImageView *v = [discIcons objectAtIndex:activeDisc];
	//UIImageView *r = [discRadars objectAtIndex:activeDisc];
	LJDisc *d = [levelModel discAtIndex:activeDisc];
	
	/* Handle dragging */
	UITouch *t = [myTouches objectAtIndex:0];
	
	CGPoint p =  [t locationInView:self];
	p.y = 480 - p.y;
	CGPoint lp = [t previousLocationInView:self];
	lp.y = 480 - lp.y;
	
	if (movingCenter) {
		CGPoint c = d.position;
		c.x += p.x - lp.x;
		c.y += p.y - lp.y;
		//v.center = c;
		//r.center = c;
		//c.y = 480 - c.y;
		d.position = c;
	} else {
		/* Changing radius */
		CGPoint c = d.position;
		int dx = abs(c.x - p.x);
		int dy = abs(c.y - p.y);
		
		if (dx > LJDISC_MAX_RADIUS || dy > LJDISC_MAX_RADIUS) {
			d.radius = LJDISC_MAX_RADIUS;
		} else {
			d.radius = HYP_OF(dx, dy);
			if (d.radius < LJDISC_DEFAULT_RADIUS) d.radius = LJDISC_DEFAULT_RADIUS;
			if (d.radius > LJDISC_MAX_RADIUS) d.radius = LJDISC_MAX_RADIUS;
		}
		
		//CGPoint t = r.center;
		//r.bounds = CGRectMake(0, 0, d.radius << 1, d.radius << 1);
		//r.center = t;
	}
	
	//[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	activeDisc = -1;
}

- (void)touchesCanceled:(NSSet *)touches withEvent:(UIEvent *)event {
	activeDisc = -1;
}

@end
