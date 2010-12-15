//
//  Common.h
//  
//
//  Created by Eskema on 02/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



#import <OpenGLES/ES1/gl.h>



#pragma mark -
#pragma mark Macros

#define RANDOM_MINUS_1_TO_1() ( (( arc4random() % 100 ) * 0.01f ) - 1.0f )

#define RANDOM_0_TO_1() ( ( arc4random() % 100 ) * 0.01f )

#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)

#define RANDOM_FLOAT_BETWEEN(x, y) (((float) rand() / RAND_MAX) * (y - x) + x)

//get a random number between min and max
//return rand() % (max - min) + min;
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + arc4random() % ((__MAX__+1) - (__MIN__)))


#pragma mark -
#pragma mark Types

typedef struct MyFonts
{
	int posX;
	int posY;
	int w;
	int h;
	int offsetx;
	int offsety;
	int xadvance;
}_ArrayFonts;

typedef struct _TileVert {
	short v[2];
	float uv[2];
	unsigned color;
} TileVert;

typedef struct _Color4f {
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Vector2f {
	GLfloat x;
	GLfloat y;
} Vector2f;


typedef struct _Quad2f {
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;


typedef struct _Particle {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat particleSize;
	GLfloat timeToLive;
} Particle;


typedef struct _PointSprite {
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;


#pragma mark -
#pragma mark Inline Functions

static const Vector2f Vector2fZero = {0.0f, 0.0f};

static const Vector2f Vector2fInit = {1.0f, 1.0f};

static inline Vector2f Vector2fMake(GLfloat x, GLfloat y)
{
	return (Vector2f) {x, y};
}

static const Color4f Color4fInit = {255.0f, 255.0f, 255.0f, 1.0f};

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}

static inline GLfloat Vector2fLength(Vector2f v)
{
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}







