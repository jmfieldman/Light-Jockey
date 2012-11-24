//
//  SoundManager.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager
@synthesize masterVolume;

+ (SoundManager*) sharedInstance {
	static SoundManager* instance = nil;
	if (!instance) instance = [[SoundManager alloc] init];	
	return instance;
}


+ (void) playSoundEffect:(NSString*)effectName {	
	/*AVAudioPlayer *player = [[ AVAudioPlayer alloc ] 
							 initWithContentsOfURL: [NSURL fileURLWithPath: [[ NSBundle mainBundle ] pathForResource:effectName 
																											  ofType:@"caf" 
																										 inDirectory:@"/" ]]
							 error:nil ];*/
	
	NSData *data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath: [[ NSBundle mainBundle ] pathForResource:effectName 
																											ofType:@"caf" 
																									   inDirectory:@"/" ]]];
	AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
	
	if (!player) {
		NSLog(@"Error creating sound effect (%@)", effectName);
		return;
	}
	
	player.delegate = [SoundManager sharedInstance];
	player.volume   = [SoundManager sharedInstance].masterVolume;
	[player play];
}


- (void) loadMasterVolume {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"masterVolume"];
	NSDictionary *vDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
	
	if (!vDic) {
		masterVolume = 1;
		return;
	}
	
	NSNumber *num = [vDic objectForKey:@"masterVolume"];
	masterVolume = [num floatValue];
}

- (void) saveMasterVolume {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"masterVolume"];
	
	NSNumber *num = [NSNumber numberWithFloat:masterVolume];
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
	[dic setObject:num forKey:@"masterVolume"];
	[dic writeToFile:filePath atomically:YES];
}


- (id) init {
	if (self = [super init]) {
		masterVolume = 1.0;
		[self loadMasterVolume];
		
		for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
			backgroundTracks[i] = nil;
		}
	}
	return self;
}


- (void) dealloc {
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		if (backgroundTracks[i]) {
			[backgroundTracks[i] stop];
			[backgroundTracks[i] release];
			backgroundTracks[i] = nil;
		}
	}
	[super dealloc];
}



- (void) clearBackgroundTrack:(int)index {
	if (!backgroundTracks[index]) return;
	
	[backgroundTracks[index] stop];
	[backgroundTracks[index] release];
	backgroundTracks[index] = nil;
}



- (void) clearAllBackgroundTracks {
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		[self clearBackgroundTrack:i];
	}
}



- (void) assignBackgroundTrack:(NSString*)trackName toIndex:(int)index {
	return;
	[self clearBackgroundTrack:index];
	
	AVAudioPlayer *player = [[ AVAudioPlayer alloc ] 
							 initWithContentsOfURL: [NSURL fileURLWithPath: [[ NSBundle mainBundle ] pathForResource:trackName 
																											  ofType:@"caf" 
																										 inDirectory:@"/" ]]
							 error:nil ];
	if (!player) {
		NSLog(@"Error creating backgroundTrack (%@)", trackName);
		return;
	}
	
	player.delegate      = self;
	player.volume        = 0;
	player.numberOfLoops = 1000000000;
	[player prepareToPlay];
	
	backgroundTracks[index] = player;
}



- (void) setMasterVolume:(float)volume {
	if (volume == masterVolume) return;
	
	float oldVolume = masterVolume;
	masterVolume = volume;
	
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		if (backgroundTracks[i]) {
			if (backgroundTracks[i].volume == oldVolume)   backgroundTracks[i].volume = masterVolume;
			if (backgroundTracks[i].volume > masterVolume) backgroundTracks[i].volume = masterVolume;			
		}
	}
}



- (void) muteBackgroundTrack:(int)index {
	if (backgroundTracks[index]) {
		backgroundTracks[index].volume = 0;
	}
}



- (void) muteAllBackgroundTracks {
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		[self muteBackgroundTrack:i];
	}
}



- (void) blastBackgroundTrack:(int)index {
	if (backgroundTracks[index]) {
		backgroundTracks[index].volume = masterVolume;
	}
}



- (void) blastAllBackgroundTracks {
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		[self blastBackgroundTrack:i];
	}
}


- (void) setVolume:(float)volume ofBackgroundTrack:(int)index {
	float v = (volume > masterVolume) ? masterVolume : volume;
	if (backgroundTracks[index]) {
		backgroundTracks[index].volume = v;
	}
}



- (void) startBackgroundTracks {
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		if (backgroundTracks[i]) {
			[backgroundTracks[i] prepareToPlay];
		}
	}
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		if (backgroundTracks[i]) {
			[backgroundTracks[i] play];
		}
	}
	
}



- (void) stopBackgroundTracks {
	for (int i = 0; i < MAX_BACKGROUND_TRACKS; i++) {
		if (backgroundTracks[i]) {
			[backgroundTracks[i] stop];
		}
	}
}



#pragma mark AVAudioPlayer Delegate Fucntions

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	/* Since we're only handling sound effects as one-off items, we can just release the player here */
	[player release];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	
}

@end
