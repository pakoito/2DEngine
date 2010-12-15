////////////////////////////////////////////////////////////////////
//
// TileMaps.h
// 
// class made to work with arrays maps of Mappy
//
// http://www.tilemap.co.uk/mappy.php
//
// this class load the levels, draw levels, and manage colisions
//
// Created by Eskema
//
////////////////////////////////////////////////////////////////////




#import <Foundation/Foundation.h> 
#import "Image.h"
#import "defines.h"



//how many frames will have any animated tile
#define MAXANIMATION 5



//==============================================================================
typedef struct Tile_Struct {
	int     Tilenum;
	bool    visible;
	bool    nowalkable;
	bool	tileAnimated;
	bool	object;
	int		animated[MAXANIMATION];
	int		delay, nextframe;
	int		delaySpeed;
} Tile_Struct;









//==============================================================================
@interface TileMaps : NSObject  
{  
	//widht and height map in PIXELS = wide*TILESIZE
	int WideTotalMap;
	int HeighTotalMap;
	
	//columns and rows of our map in TILES 
	int MaxColumns;
	int MaxRows;
	
	//how many layers we have in maps
	int Layers;
	
	//size of tiles
	int TileSize;
	
	//used for scroll map if we need it
	int indiceScroll;
	
	//float speed for automatic scroll map
	float speed;
	
	//our struct tilemap dynamic
	Tile_Struct ***level;
	
	//size screen
	int screenX, screenY;
	int ImageSizeX, ImageSizeY;
	
	// Array used to store texture coords and vertices info for rendering
	Quad2f *cachedTexture;
	Quad2f *textureCoordinates;
	Quad2f *mvertex;

}
	
	


@property (nonatomic, readwrite) int  WideTotalMap, HeighTotalMap, MaxColumns, MaxRows, Layers, TileSize,  indiceScroll; //QuadsToDraw,
@property (nonatomic, readwrite) int screenX, screenY, ImageSizeX, ImageSizeY;






//==============================================================================
//==============================================================================
//====================== FUNCTIONS =============================================
//==============================================================================
//==============================================================================
//reset all values to 0
-(void) CleanLevel;


//copy the tmp map to our level
//-(void) ReadLevel:(struct map *)ourmap Layer:(int)Layer;
-(void)ReadLevel:(NSString *)filemap Layer:(int)Layer;

//init the tilesheet and values for map
-(void) InitTileset:(Image *)ImageDraw  TotalLayers:(int)TotalLayers  Columns:(int)maxcolumns  Rows:(int)maxrows  SizeTile:(int)tilesize
		   Lanscape:(bool)landscape
		 ImagesizeX:(int)imagesizeX  ImagesizeY:(int)imagesizeY;


//assign the properties to each tile in our map
-(void) ProcessTiles;
//get the tile index to draw that tile
- (int) getSpriteIndeX:(int)X Y:(int)Y Layer:(int)Layer;

//turn now to draw the level, choose between an automatic scroll or a fixed map with movement controlled by the player
-(void) DrawLevel:(Image *) Surf_Draw  CameraX:(float)CameraX  CameraY:(float)CameraY  Layer:(int)Layer Colors:(Color4f)colors;
-(void) DrawLevelWithScroll:(Image *)Surf_Draw  ScrollY:(bool)ScrollY  MapWidth:(int)mapX  MapHeight:(int)mapY  Layer:(int)Layer Colors:(Color4f)_colors;

//convert map coords in pixels coords in x,y
//remember levels start at position 0,0
-(int) SetPosLevelX:(int)x;
-(int) SetPosLevelY:(int)y;
-(int) GetTileNum:(int)x y:(int)y Layer:(int)l;
-(bool) CollisionTile:(int) x y:(int) y  Layer:(int)l;
-(bool) CollisionObjects:(int)x y:(int)y tilenum:(int)tilenum  Layer:(int)l;
-(bool) CollisionObjects:(int)x y:(int)y Layer:(int)l;
-(void) GetObjects:(int)x y:(int) y  Layer:(int)l;
-(void) RemoveObject:(int) x y:(int) y  Layer:(int)l;
@end
	






