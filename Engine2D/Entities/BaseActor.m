#import "BaseActor.h"
#import "TBXML.h"



@implementation BaseActor


@synthesize Animation;
@synthesize x,y,width, height;
@synthesize columns, speed, flip;
@synthesize rotation;
@synthesize MoveLeft, MoveRight, MoveUp, MoveDown;
@synthesize colLayer, objlayer;




- (id) init  
{  
    self = [super init]; 

	// usually i use a large tilesheet with all animations like this
	// image
	// /////////////////////////////////////////
	// / 0  / 1  / 2  / 3  / 4  / 5  / 6  / 7  /
	// / 8  / 9  / 10 / 11 / 12 / 13 / 14 / 15 /
	// / 16 / 17 / 18 / 19 / 20 / 21 / 22 / 23 /
	// /////////////////////////////////////////
	// so the image has 8 columns (start from 1, but the array always start from 0)
	// maybe the animation for walk its 8,9,10,13, we pass any number to the animations
	// to construct our animation based on the image number we want, not linear like frame1*width, frame2*width,etc
	
	Animation = [[Animations alloc] init];
	[Animation LoadAnimation:STOPPED  frames_number:"128"];
    [Animation LoadAnimation:MOVERIGHT frames_number:"128, 129, 130, 131, 132, 133, 134, 135"];
	[Animation LoadAnimation:MOVEUP frames_number:"112, 113, 114, 115, 116, 117, 118, 119"];
	[Animation LoadAnimation:MOVEDOWN frames_number:"96, 97, 98, 99, 100, 101, 102, 103"];
	

	MoveDown = MoveUp = MoveLeft = MoveRight = false;
	rotation = 0;
	

    return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	[Animation release];
	[super dealloc];
}





//create an actor for the game
//type = wich kind of actor is, player, enemy, final boss,etc
//image = atlas or image with the sprite
//filename = the xml file with the properties for this actor
//==============================================================================
-(void) InitActor:(int)_mtype SpriteImage:(Image *)Spriteimage FileName:(NSString *)_filename
{

	Animation = [[Animations alloc] init];

	//define some default values
	//this values must be readed from the xml file
	ImageSizeX = 10;
	ImageSizeY =  10;
	
	//create memory for arrays, vertex, coords and texture
	textureCoordinates = calloc( 1, sizeof( Quad2f ) );
	mvertex = calloc( 1, sizeof( Quad2f ) );
	cachedTexture = calloc((ImageSizeX * ImageSizeY), sizeof(Quad2f));
	
	//cache all the texture coordinates for that actor
	int spriteSheetCount = 0;
    for(int i=0; i<ImageSizeY; i++) {
        for(int j=0; j<ImageSizeX; j++) {
            [Spriteimage cacheTexCoords:32
					 SubTextureHeight:32  
					CachedCoordinates:textureCoordinates 
					   CachedTextures:cachedTexture
							  Counter:spriteSheetCount
								 PosX:j * 32
								 PosY:i * 32 ];
			
			spriteSheetCount++;
        }
    }

	
	//pointer to use XML files
	TBXML *tbxml;
	
	switch (_mtype) {
		case SOLDIER:
			tbxml = [[TBXML alloc] initWithXMLFile:_filename fileExtension:nil];
			break;
	}
	
	///// ANIMATIONS
	// Load and parse the xml file for animations and other config values
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	// if root element is valid
	if (root) {
		
		// search for the first element within the root element's children
		TBXMLElement * property = [TBXML childElementNamed:@"properties" parentElement:root];
		
		// search for the first element within the root element's children
		TBXMLElement * animation = [TBXML childElementNamed:@"animation" parentElement:property];
		
		
		// if an animation element was found
		while (animation != nil) {
			
			NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:animation];
			NSString *frame = [TBXML valueOfAttributeNamed:@"frame" forElement:animation];
			NSString *_speed = [TBXML valueOfAttributeNamed:@"speed" forElement:animation];
			
			[Animation LoadAnimation:STOPPED  frames_number:"128"];
			[Animation LoadAnimation:MOVERIGHT frames_number:"128, 129, 130, 131, 132, 133, 134, 135"];
			[Animation LoadAnimation:MOVEUP frames_number:"112, 113, 114, 115, 116, 117, 118, 119"];
			[Animation LoadAnimation:MOVEDOWN frames_number:"96, 97, 98, 99, 100, 101, 102, 103"];
			
			if([name isEqualToString:@"Stopped"])
			{
				[Animation LoadAnimation:STOPPED  frames_number:[frame cStringUsingEncoding:NSUTF8StringEncoding]];
			}
			
			if([name isEqualToString:@"MoveLeft"])
			{
				[Animation LoadAnimation:STOPPED  frames_number:[frame cStringUsingEncoding:NSUTF8StringEncoding]];
			}
			
			if([name isEqualToString:@"MoveRight"])
			{
				[Animation LoadAnimation:STOPPED  frames_number:[frame cStringUsingEncoding:NSUTF8StringEncoding]];
			}
			
			if([name isEqualToString:@"MoveDown"])
			{
				[Animation LoadAnimation:STOPPED  frames_number:[frame cStringUsingEncoding:NSUTF8StringEncoding]];
			}
			
			if([name isEqualToString:@"Dead"])
			{
				[Animation LoadAnimation:STOPPED  frames_number:[frame cStringUsingEncoding:NSUTF8StringEncoding]];
			}
			
			speed = [_speed floatValue];

			
			// find the next sibling element
			animation = [TBXML nextSiblingNamed:@"animation" searchFromElement:animation];
		}//end animation
		
		
	}
	
	[tbxml release];
	
}






//==============================================================================
-(int) GetX
{
    return x;
}


//==============================================================================
-(int) GetY
{
    return y;
}


//==============================================================================
-(int) GetWidth
{
    return width;
}


//==============================================================================
-(int) GetHeight
{
    return height;
}


//this function needs changes depending if the game uses tilemaps or not
//=============================================================================
-(int) SetPosX:(int)X
{
    return X;// * level.TileSize; 
}


//this function needs changes depending if the game uses tilemaps or not
//=============================================================================
-(int) SetPosY:(int)Y
{
    return Y;// * level.TileSize; 
}





//this is the funny part, we pass the pointer to the image we want to draw, usually a tilesheet
// we use the camera to move around the tilemap, so we draw all about its camera position
//so x and y minus cameraX and cameraY to get the position
//the offset for texture/image, firts we get the actual frame number and take the rest by columns to get
//frame for X position and then repeat, but this time divide by columns to get Y position
// the quadnumber its the quad we pass to the array of quads, so that way we draw multiple images with only one call
//
// usually i use a large tilesheet with all animations like this
// image
// /////////////////////////////////////////
// / 0  / 1  / 2  / 3  / 4  / 5  / 6  / 7  /
// / 8  / 9  / 10 / 11 / 12 / 13 / 14 / 15 /
// / 16 / 17 / 18 / 19 / 20 / 21 / 22 / 23 /
// /////////////////////////////////////////
// so the image has 8 columns (start from 1, but the array always start from 0)
// maybe the animation for walk its 8,9,10,13, to know what part we draw
// we pass this number getting our actualframe%columns *width, so now we know that particular
//frame what offset have, to pass in the draw function
// remember one important thing, I take the images from 0,0 top-left coords, not from center
//not from bottom-right

//==============================================================================
-(void) Draw:(Image *)Surf_Draw CameraX:(float)cameraX  CameraY:(float)cameraY 
{

	[Surf_Draw DrawSprites:CGRectMake(x-cameraX, y-cameraY, width, height)
			   OffsetPoint:CGPointMake(([Animation GetActualFrame]%columns) *width,  ([Animation GetActualFrame]/columns) *height)
				ImageWidth:width ImageHeight:height
					  Flip:flip
					Colors:Color4fInit
				  Rotation:0.0f];
	 
}




//not much to explain here
//add X and Y to move the player
//==============================================================================
-(void) Move:(int)X Y:(int)Y
{
    x = X;
    y = Y;
	
}




//time to update player
//update its animations, and based on its animations
//do someaction, like shoot, move,etc
//==============================================================================
-(void) Update
{
	[Animation NextAnimationFrame:4];
    /*[Animation RefreshStates];

    //now update the player animations and his actions
    switch ( [Animation GetState] )
    {
        case STOPPED:
			[self StateStopped ];
        break;

        case MOVERIGHT:
        case MOVEUP:
        case MOVEDOWN:
			
			[self StateWalking];
			
        break;
		default:
			break;
    }
*/
	
	[self StateStopped ];
	
	[self CheckCollisions];

}









//the movement, we check against the tilemap, if we arent out of borders of the screen
//or we dont collide with the tile next to us, we can move and return valid, otherwise we cant move
// I always check if we DONT collide, in that case we can move, and always check the tile next to your direction
// if you gonna move left, check the tile to your left position
//==============================================================================
-(int) CanActorMoveLeft {
	
	//double check, first if we dont collide in the "head" y+2, then in the "foot" y+(height-2)
	//if (x > 0 && ![level CollisionTile:x - 1  y:y + 2  Layer:objlayer]  && ![level CollisionTile:x - 1 y:y + (height -2) Layer:objlayer] ) return Valid;
	
    return NoValid;
	
	
}


//==============================================================================
-(int) CanActorMoveRight {

	//I check screenx-width because the player start in topleft position
	//so we take the width
	//if ( x < (level.WideTotalMap-width) && ![level CollisionTile:x + 1 + (width -1) y:y + 2 Layer:objlayer] && ![level CollisionTile:x + 1 + (width -1) y:y + (height -2) Layer:objlayer] )  return Valid;
	
	return NoValid;
}



//==============================================================================
-(int) CanActorMoveUp {

	//if ( y > 0 &&  ![level CollisionTile:x +2 y:y - 1 Layer:objlayer] && ![level CollisionTile:x + width - 2 y:y - 1 Layer:objlayer]  ) return Valid;
	
	return NoValid;
	
	
}




//==============================================================================
-(int) CanActorMoveDown {

	
	//if ( y < (level.HeighTotalMap-height) &&  ![level CollisionTile:x +2  y:y + 2 + height Layer:objlayer] && ![level CollisionTile:x + width - 2   y:y + 2 + height Layer:objlayer] ) return Valid;
	
	
    return NoValid;
}







//=============================================================================
-(void) StateStopped
{
	
	//when we are stopped check if we can move
	//in that case change the animations to move
    if ( MoveLeft == true )
    {
		//switch the image mirror horizontal
         flip = 3;
		
		if ([self CanActorMoveLeft] == Valid)
			[Animation ChangeStates:MOVERIGHT];
    }
    else if ( MoveRight == true )
    {
		//switch the imagen to draw
         flip = 1;
				
		if ([self CanActorMoveRight] == Valid)
			[Animation ChangeStates:MOVERIGHT];
    }
    else if ( MoveUp == true )
    {
		
		if ([self CanActorMoveUp] == Valid) 
			[Animation ChangeStates:MOVEUP];
		
	}
    else if ( MoveDown == true )
    {
				
		if ([self CanActorMoveDown] == Valid) 
			[Animation ChangeStates:MOVEDOWN];
		
	}

	
}






//==============================================================================
-(void) StateWalking
{
	
	//now we are in move, so change again the animation to move
	//and increase the move function, adding the speed in the direction needed
    if ( MoveLeft == true )
    {
		//switch the image mirror horizontal
		flip = 3;
		if ([self CanActorMoveLeft] == Valid) {
			[Animation ChangeStates:MOVERIGHT];
			[self Move:x-speed Y:y];
		}
    }
	else if ( MoveRight == true )
    {
		//switch the image to original position
		flip = 1;
		
		if ([self CanActorMoveRight] == Valid) {
			[Animation ChangeStates:MOVERIGHT];
			[self Move:x+speed Y:y];
		}
	}
    else if ( MoveUp == true )
    {
		if ([self CanActorMoveUp] == Valid) {
			[Animation ChangeStates:MOVEUP];
			[self Move:x Y:y-speed];
		}
	}
    else if ( MoveDown == true )
    {
		if ([self CanActorMoveDown] == Valid) {
			[Animation ChangeStates:MOVEDOWN];
			[self Move:x Y:y+speed];
		}
	}
	
	
	//if the player stops, stop its animation
	if ((MoveLeft == false) && (MoveRight == false) && (MoveUp == false) && (MoveDown == false))
    {
        [Animation ChangeStatesAndResetAnim:STOPPED];
	}
	
}



//some global function to check collisions basically on tilemaps
-(void) CheckCollisions
{
	//int tile = [level GetTileNum:[self GetX]  y:[self GetY] Layer:colLayer];
	
	/*if ( [level CollisionObjects:[self GetX]  y:[self GetY] Layer:colLayer] )
	{
		switch (tile) {
			case 6:
				if ([ActorInventory InsertItemsbyItemName:@"ObjectPotion"] )
				{
					[level GetObjects:[self GetX]  y:[self GetY]  Layer:colLayer];
				}
				break;
				
			case 7:
				if ([ActorInventory InsertItemsbyItemName:@"ObjectPotion2"] )
				{
					[level GetObjects:[self GetX]  y:[self GetY]  Layer:colLayer];
				}
				break;
				
			case 8:
				if ([ActorInventory InsertItemsbyItemName:@"ObjectPotion3"] )
				{
					[level GetObjects:[self GetX]  y:[self GetY]  Layer:colLayer];
				}
				break;
				
			default:
				break;
		}
		
	}
	*/
	
	/*if ( [level CollisionObjects:[self GetX]  y:[self GetY] tilenum:8 Layer:colLayer] )
	{
		if ([ActorInventory InsertItemsbyItemName:@"ObjectPotion2"] )
		{
			[level GetObjects:[self GetX]  y:[self GetY]  Layer:colLayer];
		}
	}*/

}


@end
