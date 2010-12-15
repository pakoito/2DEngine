////////////////////////////////////////////////////////////////////
//
//Actor.h
// this class controls all the actor in a game, like player, enemies
//npcs, bosses,etc.
//
////////////////////////////////////////////////////////////////////


//this class needs a lot of work to be more global to
//handle both tilemapped games and non tilemapped games
//for now there's a lot of code commented



#import <Foundation/Foundation.h> 


#import "Image.h"
#import "Animations.h"




typedef enum
{
	SOLDIER = 1,
	HEAVYSOLDIER,
	SKELETON,
	MAGE
} TypeActor;


enum{
	Valid, 
	NoValid, 
BLOCK};



@interface BaseActor : NSObject  
{  
	
	
	//pointers to classes
	Animations *Animation; //create a animation for our actor	

	TypeActor _TypeActor;
	//variables
    int x, y;
    int width, height;
    int columns;  //how many columns has the tilesheet, this is needed for animations
	float speed; //speed to move player
	int flip; //used to flip sprite left/right
	float rotation; //maybe we want to rotate the player
    bool MoveLeft, MoveRight, MoveUp, MoveDown;
	int colLayer; //collision layer for tilemap
	int objlayer; //collision layer for tilemap

	//size screen
	int screenX, screenY;
	int ImageSizeX, ImageSizeY;
	
	// Array used to store texture coords and vertices info for rendering
	Quad2f *cachedTexture;
	Quad2f *textureCoordinates;
	Quad2f *mvertex;
}



@property (nonatomic, retain) Animations *Animation;
@property (nonatomic, readwrite) int x,y,width, height;
@property (nonatomic, readwrite) int columns, flip;
@property (nonatomic, readwrite) float rotation, speed;
@property (nonatomic, readwrite) bool MoveLeft, MoveRight, MoveUp, MoveDown;
@property (nonatomic, readwrite) int  colLayer, objlayer;






-(void) InitActor:(int)_mtype SpriteImage:(Image *)Spriteimage FileName:(NSString *)_filename;
-(int) GetX;
-(int) GetY;
-(int) GetWidth;
-(int) GetHeight;
-(int) SetPosX:(int)X;
-(int) SetPosY:(int)Y;
-(void) Draw:(Image *) Surf_Draw  CameraX:(float)cameraX  CameraY:(float)cameraY;
-(void) Move:(int)X Y:(int)Y;
-(void) Update;




-(int) CanActorMoveLeft;
-(int) CanActorMoveRight;
-(int) CanActorMoveUp;
-(int) CanActorMoveDown;


//states and collisions
-(void) StateStopped;
-(void) StateWalking;
-(void) CheckCollisions;

@end
