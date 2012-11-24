//
//  MathHelper.h
//  Musion
//
//  Created by Jason Fieldman on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Direction helper */
typedef enum Direction {
	DIR_NONE = 0,
	DIR_N    = 1,
	DIR_W    = 2,
	DIR_S    = 4,
	DIR_E    = 8,
} Direction_t;

/* hyp helper */
#define HYP_HELPER_MAX 256
#define HYP_HELPER_SHIFT 8
#define HYP_HELPER_SZ  (HYP_HELPER_MAX * HYP_HELPER_MAX)
#define HYP_OF(_x, _y) hyp_helper[_x + (_y << HYP_HELPER_SHIFT)]
extern float hyp_helper[HYP_HELPER_SZ];

/* angle helper */
#define DEGREES_NUM 360
extern float deg_to_rad_array[DEGREES_NUM];
extern float sin_of_deg_array[DEGREES_NUM];
extern float cos_of_deg_array[DEGREES_NUM];
#define _DEG2RAD(_d) deg_to_rad_array[_d]
#define _SIN_DEG(_d) sin_of_deg_array[_d]
#define _COS_DEG(_d) cos_of_deg_array[_d]

/* arctan helper */
#define ATAN_HELPER_MAX 256
#define ATAN_HELPER_HALF 128
#define ATAN_HELPER_SHIFT 8
#define ATAN_HELPER_SZ  (ATAN_HELPER_MAX * ATAN_HELPER_MAX)
#define ATAN_OF(_x, _y) atan_helper[(_x + ATAN_HELPER_HALF) + ((_y + ATAN_HELPER_HALF) << ATAN_HELPER_SHIFT)]
extern int atan_helper[ATAN_HELPER_SZ];

/* Circle/point intersection detection */
/* Circle/point intersection */
static inline BOOL isPointInCircle(int px, int py, int cx, int cy, int radius) {
	int xdis = abs(px - cx);
	int ydis = abs(py - cy);
	if (xdis > radius || ydis > radius) return NO;
	return ((int)HYP_OF(xdis, ydis) <= radius);
}

/* Fast random number generator */
#define RNG_SZ       4096
#define RNG_SZ_SHIFT 0xFFF
extern int rng_pool[RNG_SZ];
extern int *rng_ptr;
extern int *rng_final;
static inline int fastRand() {
	rng_ptr++;
	if (rng_ptr == rng_final) rng_ptr = rng_pool;
	return *rng_ptr;
}

/* Initialize the math helper */
void InitializeMathHelper();


