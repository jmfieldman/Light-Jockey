//
//  FontHelper.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FontHelper.h"

static NSMutableDictionary *fontDictionary = nil;

@implementation FontHelper
@synthesize fontRef, unitsPerEm;

#pragma mark Class Methods

+ (FontHelper*) fontHelperWithName:(NSString*)fontName {
	if (!fontDictionary) fontDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
	
	FontHelper *helper = [fontDictionary objectForKey:fontName];
	if (helper) {
		return helper;
	}
	
	/* Otherwise create a new helper */
	helper = [[FontHelper alloc] initWithFontName:fontName];
	[fontDictionary setObject:helper forKey:fontName];
	[helper release];
	return helper;
}

+ (void) setFontName:(NSString*)name ofSize:(int)size forContext:(CGContextRef)context {
	FontHelper *helper = [FontHelper fontHelperWithName:name];	
	[helper activateForContext:context withSize:size];
}


#pragma mark Instance Methods

- (id) initWithFontName:(NSString*)fontName {
	if (self = [super init]) {
		NSString* fontPathX = [[NSBundle mainBundle] pathForResource:fontName ofType:@"ttf"];
		NSURL *fontURL = [NSURL fileURLWithPath:fontPathX isDirectory: NO];		
		CGDataProviderRef fontProvider = CGDataProviderCreateWithURL((CFURLRef) fontURL);
		fontRef = CGFontCreateWithDataProvider(fontProvider);
		CGDataProviderRelease(fontProvider);
		
		for (int i = 31; i < 128; i++) glyphs[i] = i - 29;
		unitsPerEm = CGFontGetUnitsPerEm(fontRef);
	}
	return self;
}


- (void) activateForContext:(CGContextRef)context withSize:(int)size {
	CGContextSetFont(context, fontRef);
	CGContextSetFontSize(context, size);
}


- (int) getWidthOfString:(NSString*)string withFontSize:(int)size {
	int usize[512];
	CGRect vsize[512];
	CGGlyph _glyphs[512];
	const char *utfstr = [string UTF8String];
	for (int c = 0; c < [string length]; c++) {
		_glyphs[c] = utfstr[c] - 29;
	}
	CGFontGetGlyphAdvances(fontRef, _glyphs, [string length], usize);
	CGFontGetGlyphBBoxes(fontRef, _glyphs, [string length], vsize);
	int rsize = 0;
	for (int g = 0; g < [string length]; g++) {
		rsize += 0 + vsize[g].size.width;
	}
	return (rsize * size) / unitsPerEm;
}




@end
