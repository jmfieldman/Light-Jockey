//
//  FontHelper.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFontNameMain @"main"
#define kFontNameLevelName @"level_but"

@interface FontHelper : NSObject {
	CGFontRef fontRef;
	CGGlyph   glyphs[256];
	int       unitsPerEm;
}

@property (nonatomic, readonly) CGFontRef fontRef;
@property (nonatomic, readonly) int       unitsPerEm;

+ (void) setFontName:(NSString*)name ofSize:(int)size forContext:(CGContextRef)context;
+ (FontHelper*) fontHelperWithName:(NSString*)fontName;

- (id) initWithFontName:(NSString*)fontName;
- (void) activateForContext:(CGContextRef)context withSize:(int)size;
- (int) getWidthOfString:(NSString*)string withFontSize:(int)size;

@end
