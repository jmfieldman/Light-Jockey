//
//  LightJockeyAppDelegate.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LightJockeyAppDelegate.h"
#import "MathHelper.h"
#import "SparkleEngineController.h"

@implementation LightJockeyAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	/* Mandatory Initialization */
	InitializeMathHelper();
	
	/* Turn off idle timer */
	//[UIApplication sharedApplication].idleTimerDisabled = YES;
	
	/* Background is black */
	window.backgroundColor = [UIColor blackColor];
	
	/* Test: Add the sparkle engine directly to the window */
	[window addSubview:[SparkleEngineController sharedInstance].view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[SparkleEngineController sharedInstance] saveSparkleState];
	[[SparkleEngineController sharedInstance] saveLevelState];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
