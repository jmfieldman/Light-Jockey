//
//  SparkleEngineController.m
//  LightJockey
//
//  Created by Jason Fieldman on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SparkleEngineController.h"
#import "LJLevelData.h"
#import "UILJGroupCell.h"
#import "UILJLevelCell.h"

@implementation SparkleEngineController


+ (SparkleEngineController*) sharedInstance {
	static SparkleEngineController *shared = nil;
	if (!shared) shared = [[SparkleEngineController alloc] init];
	return shared;
}

- (void) _animationTimer:(NSTimer*)t {
	[levelModel advanceOneStep];
	[sparkleView performDrawCycle];
}

- (void) turnSparkleAnimationOn:(BOOL)on {
	if (on) {
		if (animationTimer) return;
		animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(_animationTimer:) userInfo:nil repeats:YES];
	} else {
		if (!animationTimer) return;
		[animationTimer invalidate];
		animationTimer = nil;
	}
}

- (id) init {
	if (self = [super init]) {
		animationTimer = nil;
		
		/* Models */
		levelModel = [[LJLevel alloc] initWithLevel:0 fromGroup:0];
				
		/* Views */
		contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		contentView.backgroundColor = [UIColor blackColor];
		contentView.opaque = YES;
		self.view = contentView;
		
		sparkleView = [[SparkleEngineView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		//sparkleView.levelModel = levelModel;
		//self.view = sparkleView;
		[contentView addSubview:sparkleView];
		[sparkleView release];
		
		discView = [[UIDiscView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		//[discView linkToLevel:levelModel];
		[sparkleView addSubview:discView];
		[discView release];
				
		prismView = [[UIPrismView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		//[prismView linkToLevel:levelModel];
		//[sparkleView addSubview:prismView];
		//[prismView release];
		
		targetView = [[UITargetOrganizerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		//[targetView linkToLevel:levelModel];
		[sparkleView addSubview:targetView];
		[targetView release];
		[targetView startUpdating];
		
		/* Menu button */
		menuButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		[menuButton addTarget:self action:@selector(_clickedOnMenuButton:) forControlEvents:UIControlEventTouchUpInside];
		menuButton.frame = CGRectMake(287, 447, 40, 40);
		[sparkleView addSubview:menuButton];
		
		/* Table initialization */
		levelTableBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		levelTableBackground.backgroundColor = [UIColor blackColor];
		levelTableBackground.hidden = YES;
		[contentView addSubview:levelTableBackground];
		[levelTableBackground release];
		
		[self loadLevelState];
		levelCellArray = [[NSMutableArray alloc] initWithCapacity:100];
		int cell_index = 0;
		for (int group_index = 0; group_index < g_groupData.numGroups; group_index++) {
			NSString *gname = g_groupData.groups[group_index].groupName;
			UILJGroupCell *newCell = [[UILJGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
			[newCell setGroupName:gname];
			[levelCellArray insertObject:newCell atIndex:cell_index];
			[newCell release];
			cell_index++;

			for (int level_index = 0; level_index < g_groupData.groups[group_index].numLevels; level_index++) {
				NSString *lname = g_groupData.groups[group_index].levels[level_index].levelName;
				UILJLevelCell *newCell = [[UILJLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
				[newCell setLevelNum:level_index groupNum:group_index];
				[newCell setLevelName:lname];
				[newCell setBeaten:g_levelBeatenState[group_index][level_index]];
				[levelCellArray insertObject:newCell atIndex:cell_index];
				cell_index++;
			}
			
		}
						
		levelTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		levelTable.hidden = YES;
		levelTable.delegate = self;
		levelTable.dataSource = self;
		levelTable.backgroundColor = [UIColor clearColor];
		levelTable.separatorStyle = UITableViewCellSeparatorStyleNone;
		levelTable.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		levelTable.showsVerticalScrollIndicator = YES;
		//levelTable.contentOffset = CGPointMake(0,[GameStateModel getLevelTableOffset]);		
		[contentView addSubview:levelTable];
		[levelTable release];
		
		/* Bottom header */
		bottomHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bottom.png"]];
		bottomHeader.frame = CGRectMake(0, 480, 320, 50);
		bottomHeader.backgroundColor = [UIColor clearColor];
		bottomHeader.userInteractionEnabled = YES;
		bottomHeader.hidden = YES;
		[contentView addSubview:bottomHeader];
		[bottomHeader release];
		
		volumeLabel = [[UICustomLabel alloc] initWithFrame:CGRectMake(10, 18, 240, 30)];
		volumeLabel.customColor = [UIColor grayColor];
		volumeLabel.backgroundColor = [UIColor clearColor];
		volumeLabel.customFont = [FontHelper fontHelperWithName:kFontNameLevelName];
		volumeLabel.customSize = 20;
		volumeLabel.text = @"VOLUME:";
		volumeLabel.textAlignment = NSTextAlignmentLeft;
		[bottomHeader addSubview:volumeLabel];
		[volumeLabel release];
		
		volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 18, 150, 20)];
		volumeSlider.minimumValue = 0;
		volumeSlider.maximumValue = 1;
		volumeSlider.value = [SoundManager sharedInstance].masterVolume;
		[volumeSlider addTarget:self action:@selector(_masterVolumeControl:) forControlEvents:UIControlEventValueChanged];
		[volumeSlider addTarget:self action:@selector(_masterVolumeControlSave:) forControlEvents:UIControlEventTouchUpInside];
		[bottomHeader addSubview:volumeSlider];
		[volumeSlider release];
		
		/*
		menuExitButton = [UIButton buttonWithType:UIButtonTypeCustom];		
		[menuExitButton addTarget:self action:@selector(_clickedOnMenuExitButton:) forControlEvents:UIControlEventTouchUpInside];
		menuExitButton.frame = CGRectMake(280, 10, 40, 40);
		menuExitButton.alpha = 1;
		menuExitButton.backgroundColor = [UIColor clearColor];
		[bottomHeader addSubview:menuExitButton];
		*/
			
		menuExitButton = [UIButton buttonWithType:UIButtonTypeInfoLight];		
		[menuExitButton addTarget:self action:@selector(_clickedOnMenuExitButton:) forControlEvents:UIControlEventTouchUpInside];
		menuExitButton.frame = CGRectMake(287, 447, 40, 40);
		menuExitButton.alpha = 1;
		menuExitButton.hidden = YES;
		menuExitButton.backgroundColor = [UIColor clearColor];
		[contentView addSubview:menuExitButton];
		 
		/* This is the "level complete" message system */
		levelCompleteView = [[UIView alloc] initWithFrame:CGRectZero];
		levelCompleteView.alpha = 0;
		levelCompleteView.userInteractionEnabled = NO;
		[sparkleView addSubview:levelCompleteView];
		[levelCompleteView release];
		
		UICustomLabel *msg1 = [[UICustomLabel alloc] initWithFrame:CGRectMake(-20, 10, 320, 36)];
		msg1.textColor = [UIColor whiteColor];
		msg1.backgroundColor = [UIColor clearColor];
		msg1.customFont = [FontHelper fontHelperWithName:kFontNameLevelName];
		msg1.customSize = 36;
		msg1.text = @"STAGE COMPLETE";
		msg1.textAlignment = NSTextAlignmentCenter;
		[levelCompleteView addSubview:msg1];
		[msg1 release];

		UICustomLabel *msg2 = [[UICustomLabel alloc] initWithFrame:CGRectMake(-20, 50, 320, 30)];
		msg2.textColor = [UIColor whiteColor];
		msg2.backgroundColor = [UIColor clearColor];
		msg2.customFont = [FontHelper fontHelperWithName:kFontNameLevelName];
		msg2.customSize = 18;
		msg2.text = @"Tap Anywhere To Continue";
		msg2.textAlignment = NSTextAlignmentCenter;
		[levelCompleteView addSubview:msg2];
		[msg2 release];
		
		/* Level Name */
		levelNameView = [[UICustomLabel alloc] initWithFrame:CGRectMake(2, 460, 240, 30)];
		levelNameView.textColor = [UIColor whiteColor];
		levelNameView.backgroundColor = [UIColor clearColor];
		levelNameView.customFont = [FontHelper fontHelperWithName:kFontNameLevelName];
		levelNameView.customSize = 18;
		levelNameView.text = @"1:1 PUSH";
		levelNameView.alpha = 0.5;
		levelNameView.textAlignment = NSTextAlignmentLeft;
		[sparkleView addSubview:levelNameView];
		[levelNameView release];
		
		//[[SoundManager sharedInstance] startBackgroundTracks];
		//[[SoundManager sharedInstance] blastAllBackgroundTracks];
		//[[SoundManager sharedInstance] muteAllBackgroundTracks];
		//[[SoundManager sharedInstance] setMasterVolume:0.0];
		
		[self loadSparkleState];
				
		/* Animation timer */
		//[self turnSparkleAnimationOn:YES];
	}
	return self;
}

- (void) setBeatenTimer:(NSTimer*)timer { UILJLevelCell* cell = timer.userInfo; [cell setBeaten:YES]; }
- (void) enterStageCompleteMode {
	levelCompleteView.alpha = 0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kLevelAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	levelCompleteView.alpha = kCompleteAlpha;
	[UIView commitAnimations];
	discView.reportAllTouches = YES;
	[sparkleView takeScreenShotWithFileName:g_groupData.groups[levelModel.groupId].levels[levelModel.levelId].levelTag];
	g_levelBeatenState[levelModel.groupId][levelModel.levelId] = YES;
	[self saveLevelState];
	
	for (int i = ([levelCellArray count]-1); i >= 0; i--) {
		UITableViewCell *cell = [levelCellArray objectAtIndex:i];
		if ([cell isKindOfClass:[UILJLevelCell class]]) {
			UILJLevelCell *lcell = (UILJLevelCell*)cell;
			if (lcell.levelNum == levelModel.levelId && lcell.groupNum == levelModel.groupId) {
				[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setBeatenTimer:) userInfo:cell repeats:NO];
				break;
			}
		}
	}
	
	//[SoundManager playSoundEffect:g_groupData.groups[levelModel.groupId].finishSound];
}

- (void) saveSparkleState {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"sparkleState"];
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
	
	/* Set level tag */
	[dic setObject:g_groupData.groups[levelModel.groupId].levels[levelModel.levelId].levelTag forKey:@"levelTag"];
		
	/* Set disc positions */
	int numDiscs = levelModel.numDiscs;
	for (int i = 0; i < numDiscs; i++) {
		LJDisc *disc = [levelModel discAtIndex:i];
		CGPoint p = disc.position;
		
		int r = disc.radius;
		
		NSString *keyX = [NSString stringWithFormat:@"x%d", i];
		NSString *keyY = [NSString stringWithFormat:@"y%d", i];
		NSString *keyR = [NSString stringWithFormat:@"r%d", i];
		
		[dic setObject:[NSNumber numberWithFloat:p.x] forKey:keyX];
		[dic setObject:[NSNumber numberWithFloat:p.y] forKey:keyY];
		[dic setObject:[NSNumber numberWithInt:r]     forKey:keyR];
	}

	[dic setObject:[NSNumber numberWithFloat:levelTable.contentOffset.y] forKey:@"tableOffset"];
	
	NSLog(@"Saving tag: %@", g_groupData.groups[levelModel.groupId].levels[levelModel.levelId].levelTag);
	[dic writeToFile:filePath atomically:YES];
}

- (void) loadSparkleState {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"sparkleState"];
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
	
	if (!dic) {
		[self _transitionToLevel:0 ofGroup:0];
		return;
	}
	
	NSString *tag = [dic objectForKey:@"levelTag"];
	int lNum, gNum;
	[LJLevel fromLevelTag:tag getLevelNum:&lNum andGroupNum:&gNum];
	[self _transitionToLevel:lNum ofGroup:gNum];
	NSLog(@"loading tag: %@ lev: %d group: %d", tag, lNum, gNum);
	
	int numDiscs = levelModel.numDiscs;
	for (int i = 0; i < numDiscs; i++) {
		LJDisc *disc = [levelModel discAtIndex:i];
		
		NSString *keyX = [NSString stringWithFormat:@"x%d", i];
		NSString *keyY = [NSString stringWithFormat:@"y%d", i];
		NSString *keyR = [NSString stringWithFormat:@"r%d", i];
		
		NSNumber *pX = [dic objectForKey:keyX];
		NSNumber *pY = [dic objectForKey:keyY];
		NSNumber *r  = [dic objectForKey:keyR];
		
		disc.position = CGPointMake([pX floatValue], [pY floatValue]);
		disc.radius   = [r intValue];		
	}
	
	NSNumber *tableOffset = [dic objectForKey:@"tableOffset"];
	levelTable.contentOffset = CGPointMake(0, [tableOffset floatValue]);
	
}

- (void) saveLevelState {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"levelState"];
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
	
	for (int g = 0; g < g_groupData.numGroups; g++) {
		for (int l = 0; l < g_groupData.groups[g].numLevels; l++) {
			[dic setObject:[NSNumber numberWithBool:g_levelBeatenState[g][l]] forKey:g_groupData.groups[g].levels[l].levelTag];
		}
	}
	
	[dic writeToFile:filePath atomically:YES];
}

- (void) loadLevelState {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"levelState"];
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
	
	if (!dic) {
		memset(g_levelBeatenState, 0, sizeof(g_levelBeatenState));
		return;
	}
	
	for (int g = 0; g < g_groupData.numGroups; g++) {
		for (int l = 0; l < g_groupData.groups[g].numLevels; l++) {
			NSNumber *n = [dic objectForKey:g_groupData.groups[g].levels[l].levelTag];
			if (n) g_levelBeatenState[g][l] = [n boolValue];
		}
	}
}


- (void) _transitionOutOfLevelTimer:(NSTimer*)t {
	sparkleView.hidden = 1;
	[sparkleView clearBuffers];
	[self turnSparkleAnimationOn:NO];
	[targetView stopUpdating];
	[[SoundManager sharedInstance] stopBackgroundTracks];
}

- (void) _transitionOutOfLevel {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kLevelAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	sparkleView.alpha = 0;
	
	[UIView commitAnimations];
	
	[NSTimer scheduledTimerWithTimeInterval:kLevelAnimationDuration target:self selector:@selector(_transitionOutOfLevelTimer:) userInfo:nil repeats:NO];
}

- (void) _transitionToLevel:(int)lev ofGroup:(int)grp {	
		
	[levelModel release];
	levelModel = [[LJLevel alloc] initWithLevel:lev fromGroup:grp];
	sparkleView.levelModel = levelModel;
	[discView   linkToLevel:levelModel];
	[prismView  linkToLevel:levelModel];
	[targetView linkToLevel:levelModel];

	levelCompleteView.alpha = 0;
	discView.reportAllTouches = NO;

	/* Set level name */
	levelNameView.text = [NSString stringWithFormat:@"%d:%d %@", grp+1, lev+1, [levelModel.levelName uppercaseString]];
	[levelNameView setNeedsDisplay];
	
	[self turnSparkleAnimationOn:YES];
	[targetView startUpdating];
	
	sparkleView.alpha = 0;
	sparkleView.hidden = NO;
		
	[[SoundManager sharedInstance] startBackgroundTracks];
	[[SoundManager sharedInstance] muteAllBackgroundTracks];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kLevelAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	sparkleView.alpha = 1;
	
	[UIView commitAnimations];
	
	
	/* Set the tutorial image */
	[targetView setTutorialImage:nil];
	if (grp == 0 && lev == 0) [targetView setTutorialImage:@"tutorial1.png"];
	if (grp == 0 && lev == 1) [targetView setTutorialImage:@"tutorial2.png"];
	if (grp == 0 && lev == 2) [targetView setTutorialImage:@"tutorial3.png"];
	if (grp == 1 && lev == 0) [targetView setTutorialImage:@"tutorial4.png"];
}


- (void) _masterVolumeControlSave:(id)sender {
	[[SoundManager sharedInstance] saveMasterVolume];
}

- (void) _masterVolumeControl:(id)sender {
	//NSLog(@"new slider: %f", volumeSlider.value);
	[[SoundManager sharedInstance] setMasterVolume:volumeSlider.value];
}

- (void) _handleSparkleStartTimer:(NSTimer*)timer {
	[self turnSparkleAnimationOn:YES];
}


- (void) _handleMenuFadeOutTimer:(NSTimer*)timer {
	levelTable.hidden = YES;
	levelTableBackground.hidden = YES;
	sparkleView.hidden = NO;
}


- (void) _clickedOnMenuExitButton:(id)sender {
	if (levelTable.hidden) return;
	bottomHeader.userInteractionEnabled = NO;
	levelTable.userInteractionEnabled = NO;
	menuExitButton.hidden = YES;
	
	[targetView startUpdating];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kTableAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	levelTable.alpha = 0;
	levelTableBackground.alpha = 0;
	
	CGPoint bHeadCen = bottomHeader.center;
	bHeadCen.y += 50;
	bottomHeader.center = bHeadCen;
	
	[UIView commitAnimations];
	
	[NSTimer scheduledTimerWithTimeInterval:kTableAnimationDuration target:self selector:@selector(_handleMenuFadeOutTimer:) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:kTableAnimationDuration target:self selector:@selector(_handleSparkleStartTimer:) userInfo:nil repeats:NO];
	
}

- (void) _clickedOnMenuButton:(id)sender {
	if (!levelTable.hidden) return;
	
	[self turnSparkleAnimationOn:NO];
	sparkleView.hidden = YES;
	bottomHeader.userInteractionEnabled = YES;
	levelTable.userInteractionEnabled = YES;
	menuExitButton.hidden = NO;
	
	[targetView stopUpdating];
	
	levelTable.hidden = NO;
	levelTable.alpha  = 0;
	levelTableBackground.hidden = NO;
	levelTableBackground.alpha  = 0;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kTableAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
	levelTable.alpha = 1;
	levelTableBackground.alpha = 0.5;
	
	CGPoint bHeadCen = bottomHeader.center;
	bHeadCen.y -= 50;
	bottomHeader.center = bHeadCen;
	
	[UIView commitAnimations];
}



/* Called by the disc view when any tap is pressed (and we've set to report all taps) */
- (void) reportTap {
	[self _transitionOutOfLevel];
	[NSTimer scheduledTimerWithTimeInterval:kLevelAnimationDuration target:self selector:@selector(_reportTapTimer:) userInfo:nil repeats:NO];	
}

- (void) _reportTapTimer:(NSTimer*)timer {
	levelCompleteView.alpha = 0;
	discView.reportAllTouches = NO;
	
	int lev, grp;
	GetNextLevelAndGroupAfter(levelModel.levelId, levelModel.groupId, &lev, &grp);
	
	[self _transitionToLevel:lev ofGroup:grp];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



- (void)dealloc {
    [super dealloc];
}



/* -------------------------- TABLE DELEGATE METHODS ----------------------- */

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
}

- (void) _cellSelectedTimer:(NSTimer*)t {
	UILJLevelCell *cell = t.userInfo;
	[self _transitionToLevel:cell.levelNum ofGroup:cell.groupNum];
}

// Push the details view controller when a contract is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSInteger row = [indexPath row];
	//DungeonViewController *dvc = GetDungeonViewController();
	
	//[[self navigationController] pushViewController:dvc animated:YES];
	//[dvc initializeForLevel:row];
	//[SoundManager playSound:SND_VAULT];
	//[self flourishOut];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (![cell isKindOfClass:[UILJLevelCell class]]) return;
	
	UILJLevelCell *levCell = (UILJLevelCell*)cell;
	[self _transitionOutOfLevel];
	[self _clickedOnMenuExitButton:nil];
	[NSTimer scheduledTimerWithTimeInterval:kLevelAnimationDuration target:self selector:@selector(_cellSelectedTimer:) userInfo:levCell repeats:NO];
}

// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [levelCellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *sourceCell = [levelCellArray objectAtIndex:[indexPath row]];
    return sourceCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[levelCellArray objectAtIndex:[indexPath row]] isKindOfClass:[UILJLevelCell class]]) {
		return 100;
	} else {
		return 50;
	}
}



@end
