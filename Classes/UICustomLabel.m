//
//  UICustomLabel.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UICustomLabel.h"


@implementation UICustomLabel
@synthesize customFont;
@synthesize customColor;
@synthesize customSize;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		customFont = nil;
		customSize = 12;
		customColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	/* Activate the font */
	[customFont activateForContext:c withSize:customSize];
	
	/* Set the color */
	CGContextSetFillColorWithColor(c, customColor.CGColor);
	
	/* We need to flip over the X-axis for some reason */
	CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);		
	CGContextSetTextMatrix(c, transform);
	
	/* Get the label width */
	int labelWidth = [customFont getWidthOfString:self.text withFontSize:customSize];
	
	int xPos = 0;
	if (self.textAlignment == NSTextAlignmentCenter) {
		xPos = (self.frame.size.width - labelWidth) / 2;
	} else if (self.textAlignment == NSTextAlignmentRight) {
		xPos = self.frame.size.width - labelWidth;
	}
	
	/* Paint the text */
	CGGlyph _glyphStr[512];
	const char *utfstr = [self.text UTF8String];
	for (int i = 0; i < [self.text length]; i++) _glyphStr[i] = utfstr[i] - 29;
	CGContextShowGlyphsAtPoint(c, xPos, customSize, _glyphStr, [self.text length]);
}



- (void)dealloc {
	self.customFont = nil;
	self.customColor = nil;
    [super dealloc];
}


@end
