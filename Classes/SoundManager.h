//
//  SoundManager.h
//  LightJockey
//
//  Created by Jason Fieldman on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

#define MAX_BACKGROUND_TRACKS 10

/* Sound effects defines */

/* Background track defines */
#define kMusicTrackIntro1         @"Intro1"
#define kMusicTrackIntro2         @"Intro2"
#define kMusicTrackIntro3         @"Intro3"
#define kMusicTrackIntro4         @"Intro4"
#define kMusicTrackIntroF         @"Intro_Finish"



#define kMusicTrackPull1          @"Pull1"
#define kMusicTrackPull2          @"Pull2"
#define kMusicTrackPull3          @"Pull3"
#define kMusicTrackPull4          @"Pull4"
#define kMusicTrackPull5          @"Pull5"

#define kMusicTrackPull31          @"Pull3_1"
#define kMusicTrackPull32          @"Pull3_2"
#define kMusicTrackPull33          @"Pull3_3"



#define kMusicTrackQuick5_1       @"Caravan_5_1"
#define kMusicTrackQuick5_2       @"Caravan_5_2"
#define kMusicTrackQuick5_3       @"Caravan_5_3"
#define kMusicTrackQuick5_4       @"Caravan_5_4"
#define kMusicTrackQuick5_5       @"Caravan_5_5"

#define kMusicTrackQuick3_1       @"Caravan_3_1"
#define kMusicTrackQuick3_2       @"Caravan_3_2"
#define kMusicTrackQuick3_3       @"Caravan_3_3"

#define kMusicTrackQuick2_1       @"Caravan_2_1"
#define kMusicTrackQuick2_2       @"Caravan_2_2"



/* SoundManager interface */

@interface SoundManager : NSObject <AVAudioPlayerDelegate> {
	AVAudioPlayer   *backgroundTracks[MAX_BACKGROUND_TRACKS];
	
	/* This is the maximum volume for any background track, and the volume that sfx get played */
	float masterVolume;
}

@property (nonatomic, readonly) float masterVolume;

+ (SoundManager*) sharedInstance;
+ (void) playSoundEffect:(NSString*)effectName;

- (void) clearBackgroundTrack:(int)index;
- (void) clearAllBackgroundTracks;
- (void) assignBackgroundTrack:(NSString*)trackName toIndex:(int)index;
- (void) setMasterVolume:(float)volume;
- (void) saveMasterVolume;

- (void) muteBackgroundTrack:(int)index;
- (void) muteAllBackgroundTracks;
- (void) blastBackgroundTrack:(int)index;
- (void) blastAllBackgroundTracks;
- (void) setVolume:(float)volume ofBackgroundTrack:(int)index;
- (void) startBackgroundTracks;
- (void) stopBackgroundTracks;

@end
