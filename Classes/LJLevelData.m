//
//  LJLevelData.m
//  LightJockey
//
//  Created by Jason Fieldman on 2/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LJLevelData.h"

//if () {

LJGroupData_t g_groupData = {
	6, /* Number of groups */
	{  /* group array */
		
		{ /* group 1 */
			5, /* Number of levels */
			@"LEARNING", /* Group name */
			kMusicTrackIntroF, /* Group Finish Sound */
			{  /* Level array */
				{ /* level 1.1 */
					@"Awaken",     /* Name */
					@"Awaken",     /* tag */
					BEAM_COLOR_WHITE,
					{ 40, 400 },   /* Beam home */
					15,            /* Home jitter */
					{ 0, -8 },     /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					1,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 240 },  LJDISCTYPE_PUSH,      DIR_E },
					},
					
					1,              /* Number of targets */
					{
						{ { 240, 100 },  BEAM_COLOR_WHITE,    kMusicTrackIntro1 },
		
					},
					
					0,              /* Number of prisms */
					{					
					}
				}, /* END OF LEVEL */
				{ /* level 1.2 */
					@"Flex",       /* Name */
					@"Flex",       /* tag */
					BEAM_COLOR_WHITE,
					{ 40, 40 },    /* Beam home */
					15,            /* Home jitter */
					{ 6, 4 },      /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{ { 100, 300 },  LJDISCTYPE_PUSH,     DIR_S },
						{ { 200, 300 },  LJDISCTYPE_PUSH,     DIR_W },
					},
					
					2,              /* Number of targets */
					{
						{ { 200, 210 }, BEAM_COLOR_WHITE,     kMusicTrackIntro1 },
						{ { 60, 150 },  BEAM_COLOR_WHITE,     kMusicTrackIntro2 },						
					},
					
					0,              /* Number of prisms */
					{					
					}
				}, /* END OF LEVEL */
				{ /* level 1.3 */
					@"Stretch",    /* Name */
					@"Stretch",    /* tag */
					BEAM_COLOR_WHITE,
					{ 120, 40 },   /* Beam home */
					15,            /* Home jitter */
					{ 2, 0 },      /* Initial velocity */
					0,             /* Velocity jitter */
					0,             /* Beam charge */
					0.95,          /* Friction */
					
					1,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 240 },  LJDISCTYPE_PUSH,     DIR_N },
					},
					
					1,              /* Number of targets */
					{
						{ { 160, 400 },  BEAM_COLOR_WHITE,    kMusicTrackIntro1 },						
					},
					
					0,              /* Number of prisms */
					{					
					}
				}, /* END OF LEVEL */
				{ /* level 1.4 */
					@"Feel",       /* Name */
					@"Feel",       /* tag */
					BEAM_COLOR_WHITE,
					{ 300, 120 },  /* Beam home */
					15,            /* Home jitter */
					{ -12, -4 },   /* Initial velocity */
					0,             /* Velocity jitter */
					0,             /* Beam charge */
					0.95,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 280, 420 },  LJDISCTYPE_PUSH, DIR_N },
						{ { 280, 340 },  LJDISCTYPE_PUSH, DIR_W },
						{ { 280, 260 },  LJDISCTYPE_PUSH, DIR_E },
					},
					
					3,              /* Number of targets */
					{
						{ { 140, 120 },  BEAM_COLOR_WHITE, kMusicTrackIntro1 },
						{ { 180, 240 },  BEAM_COLOR_WHITE, kMusicTrackIntro2 },
						{ { 100, 360 },  BEAM_COLOR_WHITE, kMusicTrackIntro3 },						
					},
					
					0,              /* Number of prisms */
					{					
					}
				}, /* END OF LEVEL */
				{ /* level 1.5 */
					@"Grasp",      /* Name */
					@"Grasp",      /* tag */
					BEAM_COLOR_WHITE,
					{ 240, 400 },  /* Beam home */
					15,            /* Home jitter */
					{ -8, -4 },    /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.99,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 80, 160 },   LJDISCTYPE_PUSH, DIR_S },
						{ { 160, 240 },  LJDISCTYPE_PUSH, DIR_N },
						{ { 240, 320 },  LJDISCTYPE_PUSH, DIR_E },
					},
					
					4,              /* Number of targets */
					{
						{ { 80, 320 },   BEAM_COLOR_WHITE, kMusicTrackIntro1 },
						{ { 80, 80 },    BEAM_COLOR_WHITE, kMusicTrackIntro2 },
						{ { 160, 120 },  BEAM_COLOR_WHITE, kMusicTrackIntro3 },
						{ { 240, 160 },  BEAM_COLOR_WHITE, kMusicTrackIntro4 },						
					},
					
					0,              /* Number of prisms */
					{					
					}
				}, /* END OF LEVEL */
				
			} /* END OF LEVEL ARRAY */
		}, /* END OF GROUP */

/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */

		{ /* group 2 */
			6, /* Number of levels */
			@"CHROMATICS", /* Group name */
			kMusicTrackIntroF, /* Group Finish Sound */
			{  /* Level array */
				{ /* level 2.1 */
					@"Filter",      /* Name */
					@"Filter",      /* tag */
					BEAM_COLOR_WHITE,
					{ 240, 40 },   /* Beam home */
					15,            /* Home jitter */
					{ 0, 8 },      /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{ { 60, 60 },    LJDISCTYPE_PUSH,   DIR_W },
						{ { 60, 420 },   LJDISCTYPE_PUSH,   DIR_E },
					},
					
					1,              /* Number of targets */
					{
						{ { 240, 360 },  BEAM_COLOR_CHR1,   kMusicTrackIntro1 },
					},
					
					1,              /* Number of prisms */
					{
						{ { 120, 200 },  BEAM_COLOR_CHR1,   80 },
					}
				}, /* END OF LEVEL */
				{ /* level 2.2 */
					@"Hue",        /* Name */
					@"Hue",        /* tag */
					BEAM_COLOR_WHITE,
					{ 80, 400 },   /* Beam home */
					15,            /* Home jitter */
					{ 8, -4 },     /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{ { 240, 60 },   LJDISCTYPE_PUSH,     DIR_W },
						{ { 240, 420 },  LJDISCTYPE_PUSH,     DIR_E },
					},
					
					2,              /* Number of targets */
					{
						{ { 160, 300 },  BEAM_COLOR_WHITE,    kMusicTrackIntro1 },
						{ { 240, 160 },  BEAM_COLOR_CHR2,     kMusicTrackIntro2 },
					},
					
					1,              /* Number of prisms */
					{
						{ { 100, 200 },  BEAM_COLOR_CHR2,     60 },
					}
				}, /* END OF LEVEL */
				{ /* level 2.3 */
					@"Prism",/* Name */
					@"Prism1",/* tag */
					BEAM_COLOR_CHR1,
					{ 280, 260 },  /* Beam home */
					15,            /* Home jitter */
					{ -8, 4 },     /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{
							{ 80, 80 },
							LJDISCTYPE_PUSH,
							DIR_W,
						},
						{
							{ 160, 80 },
							LJDISCTYPE_PUSH,
							DIR_E,
						},
						{
							{ 240, 80 },
							LJDISCTYPE_PUSH,
							DIR_S,
						},
					},
					
					3,              /* Number of targets */
					{
						{
							{ 80, 360 },
							BEAM_COLOR_CHR1,
							kMusicTrackIntro1,
						},
						{
							{ 220, 200 },
							BEAM_COLOR_CHR1,
							kMusicTrackIntro2,
						},
						{
							{ 80, 120 },
							BEAM_COLOR_CHR3,
							kMusicTrackIntro3,
						},
					},
					
					2,              /* Number of prisms */
					{
						{
							{ 300, 240 },
							BEAM_COLOR_CHR1,
							80,
						},
						{
							{ 160, 160 },
							BEAM_COLOR_CHR3,
							40,
						},
					}
				}, /* END OF LEVEL */
				{ /* level 2.4 */
					@"Gamut",    /* Name */
					@"Gamut",    /* tag */
					BEAM_COLOR_WHITE,
					{ 160, 240 },  /* Beam home */
					15,            /* Home jitter */
					{ -8,- 4 },    /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{
							{ 80, 400 },
							LJDISCTYPE_PUSH,
							DIR_W,
						},
						{
							{ 240, 80 },
							LJDISCTYPE_PUSH,
							DIR_E,
						},
						{
							{ 240, 240 },
							LJDISCTYPE_PUSH,
							DIR_N,
						},
					},
					
					4,              /* Number of targets */
					{
						{
							{ 120, 90 },
							BEAM_COLOR_CHR1,
							kMusicTrackIntro1,
						},
						{
							{ 240, 160 },
							BEAM_COLOR_CHR2,
							kMusicTrackIntro2,
						},
						{
							{ 160, 320 },
							BEAM_COLOR_CHR2,
							kMusicTrackIntro3,
						},
						{
							{ 180, 380 },
							BEAM_COLOR_CHR3,
							kMusicTrackIntro4,
						},
					},
					
					3,              /* Number of prisms */
					{
						{
							{ 0, 160 },
							BEAM_COLOR_CHR2,
							80,
						},
						{
							{ 120, 80 },
							BEAM_COLOR_CHR1,
							40,
						},
						{
							{ 200, 400 },
							BEAM_COLOR_CHR3,
							40,
						},
					}
				}, /* END OF LEVEL */
				{ /* level 2.5 */
					@"Wheel",  /* Name */
					@"Wheel",  /* tag */
					BEAM_COLOR_WHITE,
					{ 0, 0 },      /* Beam home */
					15,            /* Home jitter */
					{ 6, 5 },      /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					4,             /* Number of discs */
					{              /* Disc array */
						{
							{ 120, 160 },
							LJDISCTYPE_PUSH,
							DIR_W,
						},
						{
							{ 120, 320 },
							LJDISCTYPE_PUSH,
							DIR_E,
						},
						{
							{ 240, 160 },
							LJDISCTYPE_PUSH,
							DIR_N,
						},
						{
							{ 240, 320 },
							LJDISCTYPE_PUSH,
							DIR_S,
						},
					},
					
					5,              /* Number of targets */
					{
						{
							{ 80, 160 },
							BEAM_COLOR_CHR1,
							kMusicTrackIntro1,
						},
						{
							{ 160, 200 },
							BEAM_COLOR_CHR1,
							kMusicTrackIntro2,
						},
						{
							{ 80, 280 },
							BEAM_COLOR_CHR2,
							kMusicTrackIntro3,
						},
						{
							{ 160, 360 },
							BEAM_COLOR_CHR3,
							kMusicTrackIntro4,
						},
						{
							{ 240, 320 },
							BEAM_COLOR_CHR3,
							kMusicTrackIntro4,
						},
					},
					
					3,              /* Number of prisms */
					{
						{
							{ 180, 80 },
							BEAM_COLOR_CHR1,
							80,
						},
						{
							{ 60, 280 },
							BEAM_COLOR_CHR2,
							40,
						},
						{
							{ 120, 360 },
							BEAM_COLOR_CHR3,
							60,
						},
					}
				}, /* END OF LEVEL */
				{ /* level 2.6 */
					@"Bend",       /* Name */
					@"Bend",       /* tag */
					BEAM_COLOR_WHITE,
					{ 80, 400 },   /* Beam home */
					15,            /* Home jitter */
					{ 8, -4 },     /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					4,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  320 },  LJDISCTYPE_PUSH,     DIR_W },
						{ { 240, 420 },  LJDISCTYPE_PUSH,     DIR_E },
						{ { 80 , 200 },  LJDISCTYPE_PUSH,     DIR_N },
						{ { 80 , 80  },  LJDISCTYPE_PUSH,     DIR_S },
					},
					
					3,              /* Number of targets */
					{
						{ { 40 , 440 },  BEAM_COLOR_CHR2,     kMusicTrackIntro1 },
						{ { 240, 160 },  BEAM_COLOR_CHR2,     kMusicTrackIntro2 },
						{ { 240, 240 },  BEAM_COLOR_WHITE,    kMusicTrackIntro2 },
					},
					
					1,              /* Number of prisms */
					{
						{ { 200, 80  },  BEAM_COLOR_CHR2,     60 },
					}
				}, /* END OF LEVEL */
			} /* END OF LEVEL ARRAY */
		}, /* END OF GROUP */

/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */

		{ /* group 3 */
			6, /* Number of levels */
			@"GRAVITATION", /* Group name */
			kMusicTrackIntroF, /* Group Finish Sound */
			{  /* Level array */
				{ /* level 1 */
					@"Pull",     /* Name */
					@"Pull",     /* tag */
					BEAM_COLOR_WHITE,
					{ 160, 500 },  /* Beam home */
					15,            /* Home jitter */
					{ -6, -12 },   /* Initial velocity */
					0,             /* Velocity jitter */
					10,            /* Beam charge */
					0.98,          /* Friction */
					
					1,             /* Number of discs */
					{              /* Disc array */
						{
							{ 240, 360 },
							LJDISCTYPE_ATTRACT,
							DIR_W,
						},
					},
					
					1,              /* Number of targets */
					{
						{
							{ 160, 240 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull31,
						},
												
					},
					
					1,              /* Number of prisms */
					{
						{
							{ 240, 160 },
							BEAM_COLOR_YELLOW,
							60,
						},
					
					}
				}, /* END OF LEVEL */
				{ /* level 2 */
					@"Orbit",     /* Name */
					@"Orbit",     /* tag */
					BEAM_COLOR_WHITE,
					{ 320, 240 },  /* Beam home */
					15,            /* Home jitter */
					{ -5, -10 },   /* Initial velocity */
					0,             /* Velocity jitter */
					15,            /* Beam charge */
					0.97,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{
							{ 120, 360 },
							LJDISCTYPE_ATTRACT,
							DIR_W,
						},
						{
							{ 240, 360 },
							LJDISCTYPE_PUSH,
							DIR_N,
						},
					},
					
					2,              /* Number of targets */
					{
						{
							{ 120, 60 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull31,
						},
						{
							{ 200, 360 },
							BEAM_COLOR_MAGENTA,
							kMusicTrackPull32,
						},
						
					},
					
					2,              /* Number of prisms */
					{
						{
							{ 260, 0 },
							BEAM_COLOR_YELLOW,
							120,
						},
						{
							{ 0, 240 },
							BEAM_COLOR_MAGENTA,
							120,
						},
						
					}
				}, /* END OF LEVEL */
				{ /* level 3 */
					@"Escape",     /* Name */
					@"Escape",     /* tag */
					BEAM_COLOR_WHITE,
					{ 290, -20 },  /* Beam home */
					15,            /* Home jitter */
					{ 0, 4 },      /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{
							{ 80, 300 },
							LJDISCTYPE_ATTRACT,
							DIR_N,
						},
						{
							{ 160, 300 },
							LJDISCTYPE_PUSH,
							DIR_N,
						},
						{
							{ 240, 300 },
							LJDISCTYPE_ATTRACT,
							DIR_W,
						},
					},
					
					3,              /* Number of targets */
					{
						{
							{ 160, 240 },
							BEAM_COLOR_CYAN,
							kMusicTrackPull31,
						},
						{
							{ 130, 300 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull32,
						},
						{
							{ 60, 380 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull33,
						},						
					},
					
					2,              /* Number of prisms */
					{
						{
							{ 20, 70 },
							BEAM_COLOR_CYAN,
							100,
						},
						{
							{ 0, 480 },
							BEAM_COLOR_YELLOW,
							140,
						},					
					}
				}, /* END OF LEVEL */
				{ /* level 4 */
					@"Cusp",     /* Name */
					@"Cusp",     /* tag */
					BEAM_COLOR_WHITE,
					{ 20, 260 },   /* Beam home */
					15,            /* Home jitter */
					{ 6, 12 },      /* Initial velocity */
					0,             /* Velocity jitter */
					15,            /* Beam charge */
					0.97,          /* Friction */
					
					4,             /* Number of discs */
					{              /* Disc array */
						{
							{ 120, 180 },
							LJDISCTYPE_PUSH,
							DIR_S,
						},
						{
							{ 240, 180 },
							LJDISCTYPE_PUSH,
							DIR_W,
						},
						{
							{ 120, 300 },
							LJDISCTYPE_ATTRACT,
							DIR_W,
						},
						{
							{ 240, 300 },
							LJDISCTYPE_ATTRACT,
							DIR_W,
						},
					},
					
					4,              /* Number of targets */
					{
						{
							{ 240, 360 },
							BEAM_COLOR_CYAN,
							kMusicTrackPull1,
						},
						{
							{ 140, 240 },
							BEAM_COLOR_CYAN,
							kMusicTrackPull3,
						},
						{
							{ 120, 70 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull4,
						},
						{
							{ 220, 40 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull5,
						},
					},
					
					2,              /* Number of prisms */
					{
						{
							{ 60, 340 },
							BEAM_COLOR_CYAN,
							40,
						},
						{
							{ 120, 160 },
							BEAM_COLOR_YELLOW,
							60,
						},					
					}
				}, /* END OF LEVEL */
				{ /* level 5 */
					@"Flare",     /* Name */
					@"Flare",     /* tag */
					BEAM_COLOR_WHITE,
					{ 20, 200 },   /* Beam home */
					15,            /* Home jitter */
					{ 4, -8 },     /* Initial velocity */
					0,             /* Velocity jitter */
					10,            /* Beam charge */
					0.98,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  300 }, LJDISCTYPE_PUSH,     DIR_N },
						{ { 160, 300 }, LJDISCTYPE_ATTRACT,  DIR_W },
						{ { 240, 300 }, LJDISCTYPE_ATTRACT,  DIR_W },
					},
					
					5,             /* Number of targets */
					{
						{ { 120, 120 }, BEAM_COLOR_CYAN,     kMusicTrackPull1 },
						{ { 280, 200 }, BEAM_COLOR_CYAN,     kMusicTrackPull2 },
						{ { 140, 230 }, BEAM_COLOR_YELLOW,   kMusicTrackPull3 },
						{ { 80,  360 }, BEAM_COLOR_MAGENTA,  kMusicTrackPull4 },
						{ { 120, 400 }, BEAM_COLOR_MAGENTA,  kMusicTrackPull5 }
					},
					
					3,             /* Number of prisms */
					{
						{ { 0,   240 }, BEAM_COLOR_CYAN,     100 },
						{ { 200, 240 }, BEAM_COLOR_YELLOW,   40 },
						{ { 320, 480 }, BEAM_COLOR_MAGENTA,  180 }
					}
				}, /* END OF LEVEL */
				{ /* level 6 */
					@"Horizon",      /* Name */
					@"Horizon",      /* tag */
					BEAM_COLOR_WHITE,
					{ 0, 40 },     /* Beam home */
					15,            /* Home jitter */
					{ 2, 8 },      /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{
							{ 120, 240 },
							LJDISCTYPE_PUSH,
							DIR_N,
						},
						{
							{ 240, 240 },
							LJDISCTYPE_ATTRACT,
							DIR_W,
						},
					},
					
					4,              /* Number of targets */
					{
						{
							{ 280, 50 },
							BEAM_COLOR_CYAN,
							kMusicTrackPull1,
						},
						{
							{ 160, 200 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull3,
						},
						{
							{ 50, 270 },
							BEAM_COLOR_YELLOW,
							kMusicTrackPull4,
						},
						{
							{ 150, 360 },
							BEAM_COLOR_MAGENTA,
							kMusicTrackPull5,
						}
						
					},
					
					3,              /* Number of prisms */
					{
						{
							{ 280, 70 },
							BEAM_COLOR_CYAN,
							40,
						},
						{
							{ 20, 60 },
							BEAM_COLOR_YELLOW,
							20,
						},
						{
							{ 135, 290 },
							BEAM_COLOR_MAGENTA,
							40,
						}
					}
				} /* END OF LEVEL */

			} /* END OF LEVEL ARRAY */
		}, /* END OF GROUP */

/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */

		{ /* group 4 */
			4, /* Number of levels */
			@"DIVISION", /* Group name */
			kMusicTrackIntroF, /* Group Finish Sound */
			{  /* Level array */
				{ /* level 1 */
					@"Branch",       /* Name */
					@"Branch",       /* tag */
					BEAM_COLOR_DIV1,
					{ 10, 500 },   /* Beam home */
					15,            /* Home jitter */
					{ 6, -6 },     /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.95,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  240 },  LJDISCTYPE_PUSH,       DIR_S },
						{ { 160, 240 },  LJDISCTYPE_SPLIT,      DIR_W },
					},
					
					2,             /* Number of targets */
					{
						{ { 140, 60  },  BEAM_COLOR_DIV2,     kMusicTrackIntro1 },
						{ { 240, 180 },  BEAM_COLOR_DIV1,      kMusicTrackIntro1 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 140, 140 },  BEAM_COLOR_DIV2,     30 },
					}
				}, /* END OF LEVEL */
				{ /* level 2 */
					@"Split",       /* Name */
					@"Split",       /* tag */
					BEAM_COLOR_DIV1,
					{ 120, 320 },  /* Beam home */
					15,            /* Home jitter */
					{ 3, -5.8 },   /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.99,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  80  },  LJDISCTYPE_PUSH,       DIR_N },
						{ { 240, 80  },  LJDISCTYPE_PUSH,       DIR_W },
						{ { 164, 240 },  LJDISCTYPE_SPLIT,      DIR_N },
					},
					
					3,             /* Number of targets */
					{
						{ { 80,  240 },  BEAM_COLOR_DIV2,       kMusicTrackIntro1 },
						{ { 80,  400 },  BEAM_COLOR_DIV1,       kMusicTrackIntro1 },
						{ { 160, 120 },  BEAM_COLOR_DIV1,       kMusicTrackIntro1 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 320, 200 },  BEAM_COLOR_DIV2,       120 },
					}
				}, /* END OF LEVEL */
				{ /* level 3 */
					@"Sunder",       /* Name */
					@"Sunder",       /* tag */
					BEAM_COLOR_DIV1,
					{ 20, 240 },   /* Beam home */
					15,            /* Home jitter */
					{ 0, 2 },      /* Initial velocity */
					0,             /* Velocity jitter */
					4,             /* Beam charge */
					0.97,          /* Friction */
					
					4,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  80  },  LJDISCTYPE_PUSH,       DIR_N },
						{ { 160, 80  },  LJDISCTYPE_PUSH,       DIR_E },
						{ { 240, 80  },  LJDISCTYPE_ATTRACT,    DIR_W },
						{ { 160, 280 },  LJDISCTYPE_SPLIT,      DIR_N },
					},
					
					4,             /* Number of targets */
					{
						{ { 120, 360 },  BEAM_COLOR_DIV1,       kMusicTrackIntro1 },
						{ { 280, 360 },  BEAM_COLOR_DIV1,       kMusicTrackIntro1 },
						{ { 160, 160 },  BEAM_COLOR_DIV2,       kMusicTrackIntro1 },
						{ { 240, 80  },  BEAM_COLOR_DIV2,       kMusicTrackIntro1 },
					},
					
					2,             /* Number of prisms */
					{
						{ { 80,  280 },  BEAM_COLOR_DIV1,       80 },
						{ { 240, 200 },  BEAM_COLOR_DIV2,       80 },
					}
				}, /* END OF LEVEL */
				{ /* level 4 */
					@"Unbound",       /* Name */
					@"Unbound",       /* tag */
					BEAM_COLOR_DIV3,
					{ 0, 0 },      /* Beam home */
					15,            /* Home jitter */
					{ 6, 6 },      /* Initial velocity */
					0,             /* Velocity jitter */
					5,             /* Beam charge */
					0.97,          /* Friction */
					
					4,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  300 },  LJDISCTYPE_PUSH,       DIR_N },
						{ { 160, 300 },  LJDISCTYPE_PUSH,       DIR_W },
						{ { 240, 300 },  LJDISCTYPE_ATTRACT,    DIR_W },
						{ { 40,  40  },  LJDISCTYPE_SPLIT,      DIR_N },
					},
					
					5,             /* Number of targets */
					{
						{ { 40,  240 },  BEAM_COLOR_DIV2,       kMusicTrackIntro1 },
						{ { 160, 160 },  BEAM_COLOR_DIV3,       kMusicTrackIntro1 },
						{ { 190, 320 },  BEAM_COLOR_DIV2,       kMusicTrackIntro1 },
						{ { 160, 370 },  BEAM_COLOR_DIV1,       kMusicTrackIntro1 },
						{ { 240, 280 },  BEAM_COLOR_DIV1,       kMusicTrackIntro1 },
					},
					
					2,             /* Number of prisms */
					{
						{ { 90,  180 },  BEAM_COLOR_DIV2,       60 },
						{ { 280, 360 },  BEAM_COLOR_DIV1,       80 },
					}
				}, /* END OF LEVEL */
			}, /* END OF LEVEL ARRAY */
		}, /* END OF GROUP */
		
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */

		{ /* group 5 */
			5, /* Number of levels */
			@"SPEED", /* Group name */
			kMusicTrackIntroF, /* Group Finish Sound */
			{  /* Level array */
				{ /* level 1 */
					@"Haste",     /* Name */
					@"Haste",     /* tag */
					BEAM_COLOR_WHITE,
					{ 20, 20 },    /* Beam home */
					15,            /* Home jitter */
					{ 2, 3 },      /* Initial velocity */
					0,             /* Velocity jitter */
					10,            /* Beam charge */
					0.95,          /* Friction */
					
					1,             /* Number of discs */
					{              /* Disc array */
						{ { 140, 210 },  LJDISCTYPE_SPEEDUP,    DIR_S },
					},
					
					1,             /* Number of targets */
					{
						{ { 280, 420  }, BEAM_COLOR_GREEN,      kMusicTrackIntro1 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 200, 300 },  BEAM_COLOR_GREEN,     30 },
					}
				}, /* END OF LEVEL */
				{ /* level 2 */
					@"Impel",     /* Name */
					@"Impel",     /* tag */
					BEAM_COLOR_WHITE,
					{ 320, 240 },  /* Beam home */
					7,             /* Home jitter */
					{ -10, -5 },   /* Initial velocity */
					0,             /* Velocity jitter */
					10,            /* Beam charge */
					0.99,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 190 },  LJDISCTYPE_ATTRACT,    DIR_S },
						{ { 160, 290 },  LJDISCTYPE_SPEEDUP,    DIR_S },
					},
					
					2,             /* Number of targets */
					{
						{ { 160, 420  }, BEAM_COLOR_WHITE,      kMusicTrackIntro1 },
						{ { 280, 40   }, BEAM_COLOR_GREEN,      kMusicTrackIntro2 },
					},
					
					2,             /* Number of prisms */
					{
						{ { 320, 300 },  BEAM_COLOR_WHITE,     160 },
						{ { 260, 120 },  BEAM_COLOR_GREEN,     60 },
					}
				}, /* END OF LEVEL */
				{ /* level 3 */
					@"Eclipse",     /* Name */
					@"Eclipse",     /* tag */
					BEAM_COLOR_WHITE,
					{ 260, 340 },  /* Beam home */
					15,            /* Home jitter */
					{ -6, -3 },    /* Initial velocity */
					0,             /* Velocity jitter */
					10,            /* Beam charge */
					0.97,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  240 },  LJDISCTYPE_ATTRACT,    DIR_S },
						{ { 160, 240 },  LJDISCTYPE_SPEEDUP,    DIR_S },
						{ { 240, 240 },  LJDISCTYPE_PUSH,       DIR_W },
					},
					
					3,             /* Number of targets */
					{
						{ { 240, 430  }, BEAM_COLOR_WHITE,      kMusicTrackIntro1 },
						{ { 40,  450  }, BEAM_COLOR_WHITE,      kMusicTrackIntro2 },
						{ { 200, 80   }, BEAM_COLOR_GREEN,      kMusicTrackIntro2 },
					},
					
					2,             /* Number of prisms */
					{
						{ { 240, 320 },  BEAM_COLOR_WHITE,     80 },
						{ { 160, 210 },  BEAM_COLOR_GREEN,     60 },
					}
				}, /* END OF LEVEL */
				{ /* level 4 */
					@"Urgency",     /* Name */
					@"Urgency",     /* tag */
					BEAM_COLOR_WHITE,
					{ 160, 160 },  /* Beam home */
					7,             /* Home jitter */
					{ 8, -8 },     /* Initial velocity */
					0,             /* Velocity jitter */
					10,            /* Beam charge */
					0.97,          /* Friction */
					
					4,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  320 },  LJDISCTYPE_ATTRACT,    DIR_S },
						{ { 80,  160 },  LJDISCTYPE_ATTRACT,    DIR_S },
						{ { 240, 320 },  LJDISCTYPE_SPEEDUP,    DIR_S },
						{ { 240, 160 },  LJDISCTYPE_PUSH,       DIR_E },
					},
					
					4,             /* Number of targets */
					{
						{ { 100, 60   }, BEAM_COLOR_WHITE,      kMusicTrackIntro1 },
						{ { 160, 240  }, BEAM_COLOR_WHITE,      kMusicTrackIntro1 },
						{ { 120, 400  }, BEAM_COLOR_GREEN,      kMusicTrackIntro2 },
						{ { 290, 240  }, BEAM_COLOR_GREEN,      kMusicTrackIntro2 },
					},
					
					2,             /* Number of prisms */
					{
						{ { 240, 80  },  BEAM_COLOR_WHITE,     120 },
						{ { 200, 320 },  BEAM_COLOR_GREEN,     60 },
					}
				}, /* END OF LEVEL */
				{ /* level 5 */
					@"Momentum",     /* Name */
					@"Momentum",     /* tag */
					BEAM_COLOR_WHITE,
					{ 230, 40 },   /* Beam home */
					15,            /* Home jitter */
					{ -2, 0  },    /* Initial velocity */
					0,             /* Velocity jitter */
					6,             /* Beam charge */
					0.97,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 80,  240 },  LJDISCTYPE_ATTRACT,    DIR_S },
						{ { 160, 240 },  LJDISCTYPE_SPEEDUP,    DIR_S },
						{ { 240, 240 },  LJDISCTYPE_PUSH,       DIR_N },
					},
					
					5,             /* Number of targets */
					{
						{ { 200, 150  }, BEAM_COLOR_WHITE,      kMusicTrackIntro1 },
						{ { 160, 320  }, BEAM_COLOR_GREEN,      kMusicTrackIntro2 },
						{ { 280, 200  }, BEAM_COLOR_GREEN,      kMusicTrackIntro2 },
						{ { 40,  440  }, BEAM_COLOR_CYAN,       kMusicTrackIntro2 },
						{ { 80,  300  }, BEAM_COLOR_CYAN,       kMusicTrackIntro2 },
					},
					
					3,             /* Number of prisms */
					{
						{ { 0,   0   },  BEAM_COLOR_WHITE,     120 },
						{ { 200, 240 },  BEAM_COLOR_GREEN,     60 },
						{ { 100, 360 },  BEAM_COLOR_CYAN,      60 },
					}
				}, /* END OF LEVEL */
			}, /* END OF LEVEL ARRAY */
		}, /* END OF GROUP */
		
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
		
		{ /* group 6 */
			4, /* Number of levels */
			@"REPULSION", /* Group name */
			kMusicTrackIntroF, /* Group Finish Sound */
			{  /* Level array */
				{ /* level 1 */
					@"Prod",       /* Name */
					@"Prod",       /* tag */
					BEAM_COLOR_REP1,
					{ 20, 20 },    /* Beam home */
					7,             /* Home jitter */
					{ 6, 3 },      /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					1,             /* Friction */
					
					1,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 240 },  LJDISCTYPE_REPEL,      DIR_S },
					},
					
					1,             /* Number of targets */
					{
						{ { 160, 400  }, BEAM_COLOR_REP2,       kMusicTrackIntro1 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 160, 160 },  BEAM_COLOR_REP2,      100 },
					}
				}, /* END OF LEVEL */
				{ /* level 2 */
					@"Bounce",       /* Name */
					@"Bounce",       /* tag */
					BEAM_COLOR_REP1,
					{ 290, 500 },  /* Beam home */
					3,             /* Home jitter */
					{ 0, -9 } ,    /* Initial velocity */
					0,             /* Velocity jitter */
					20,            /* Beam charge */
					0.98,          /* Friction */
					
					2,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 300 },  LJDISCTYPE_REPEL,      DIR_S },
						{ { 160, 180 },  LJDISCTYPE_BOUNCE,     DIR_S },
					},
					
					3,             /* Number of targets */
					{
						{ { 240, 120 },  BEAM_COLOR_REP1,       kMusicTrackIntro1 },
						{ { 140, 220 },  BEAM_COLOR_REP1,       kMusicTrackIntro1 },
						{ { 140, 380 },  BEAM_COLOR_REP2,        kMusicTrackIntro1 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 30, 290 },  BEAM_COLOR_REP2,         100 },
					}
				}, /* END OF LEVEL */
				{ /* level 3 */
					@"Force",       /* Name */
					@"Force",       /* tag */
					BEAM_COLOR_REP1,
					{ -30, 240 },  /* Beam home */
					3,             /* Home jitter */
					{ 9, 0 } ,     /* Initial velocity */
					0,             /* Velocity jitter */
					25,            /* Beam charge */
					0.99,          /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 400 },  LJDISCTYPE_REPEL,      DIR_S },
						{ { 160, 250 },  LJDISCTYPE_PUSH,       DIR_W },
						{ { 160, 100 },  LJDISCTYPE_PUSH,       DIR_S },
					},
					
					2,             /* Number of targets */
					{
						{ { 260, 400 },  BEAM_COLOR_REP1,       kMusicTrackIntro1 },
						{ { 260, 80  },  BEAM_COLOR_REP1,       kMusicTrackIntro1 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 320, 240 },  BEAM_COLOR_REP2,       120 },
					}
				}, /* END OF LEVEL */
				{ /* level 4 */
					@"Denial",       /* Name */
					@"Denial",       /* tag */
					BEAM_COLOR_REP1,
					{ 20, 480 },   /* Beam home */
					3,             /* Home jitter */
					{ 7, -7 },     /* Initial velocity */
					0,             /* Velocity jitter */
					15,            /* Beam charge */
					0.985,         /* Friction */
					
					3,             /* Number of discs */
					{              /* Disc array */
						{ { 160, 400 },  LJDISCTYPE_ATTRACT,    DIR_S },
						{ { 160, 250 },  LJDISCTYPE_BOUNCE,     DIR_W },
						{ { 160, 100 },  LJDISCTYPE_REPEL,      DIR_S },
					},
					
					3,             /* Number of targets */
					{
						{ { 180, 100 },  BEAM_COLOR_REP1,       kMusicTrackIntro1 },
						{ { 40,  200 },  BEAM_COLOR_REP2,       kMusicTrackIntro1 },
						{ { 120, 120 },  BEAM_COLOR_REP2,       kMusicTrackIntro2 },
					},
					
					1,             /* Number of prisms */
					{
						{ { 320, 160 },  BEAM_COLOR_REP2,       80 },
					}
				}, /* END OF LEVEL */
			}, /* END OF LEVEL ARRAY */
		}, /* END OF GROUP */		
	} /* END OF GROUP ARRAY */
};


BOOL g_levelBeatenState[MAX_GROUPS][MAX_LEVELS_PER_GROUP];

void GetNextLevelAndGroupAfter(int level, int group, int *nextLevel, int *nextGroup) {
	if ((level+1) < g_groupData.groups[group].numLevels) {
		*nextGroup = group;
		*nextLevel = level + 1;
		return;
	}
	
	*nextLevel = 0;
	
	if ((group+1) < g_groupData.numGroups) {
		*nextGroup = group + 1;
		return;
	}
	
	*nextGroup = 0;
}
