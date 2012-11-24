//
//  LJDisc.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LJDisc.h"


@implementation LJDisc

@synthesize type, direction, radius, position;


- (id) initWithType:(LJDiscType_t)discType withDirection:(Direction_t)aDirection atPosition:(CGPoint)pos {
	if (self = [super init]) {
		type = discType;
		direction = aDirection;
		radius = LJDISC_DEFAULT_RADIUS;
		if (type == LJDISCTYPE_SPLIT) radius = 24;
		position = pos;
	}
	return self;
}


@end
