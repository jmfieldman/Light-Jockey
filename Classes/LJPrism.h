//
//  LJPrism.h
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJBeam.h"


#define LJPRISM_DEFAULT_RADIUS 20


@interface LJPrism : NSObject {
	LJBeamColor_t         color;
	int                   radius;
	CGPoint               position;
}

@property (nonatomic, readonly) LJBeamColor_t  color;
@property (nonatomic, assign)   int            radius;
@property (nonatomic, assign)   CGPoint        position;

- (id) initWithColor:(LJBeamColor_t)prismColor atPosition:(CGPoint)pos withRadius:(int)rad;

@end
