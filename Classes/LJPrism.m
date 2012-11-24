//
//  LJPrism.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LJPrism.h"


@implementation LJPrism

@synthesize color, radius, position;


- (id) initWithColor:(LJBeamColor_t)prismColor atPosition:(CGPoint)pos withRadius:(int)rad {
	if (self = [super init]) {
		color = prismColor;
		radius = rad;
		position = pos;
	}
	return self;
}


@end
