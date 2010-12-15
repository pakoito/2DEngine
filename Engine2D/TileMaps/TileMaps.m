//
//
//Created by Eskema
//
//

#import "TileMaps.h"


@implementation TileMaps




@synthesize screenX, screenY;
@synthesize  WideTotalMap;
@synthesize HeighTotalMap;
@synthesize MaxColumns;
@synthesize MaxRows;
@synthesize Layers;
@synthesize TileSize;
@synthesize indiceScroll;
@synthesize ImageSizeX;
@synthesize ImageSizeY;



- (id) init  
{  
    self = [super init];
	WideTotalMap = HeighTotalMap = MaxColumns = MaxRows  = Layers = TileSize = indiceScroll = screenX = screenY = 0;
	return self;  
	
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	free(textureCoordinates);
	free(mvertex);
	free(cachedTexture);
	free(level);

	[super dealloc];
}



//init the tileset with the image, usually a texture atlas
//layers = how many layers will have this level
//columns = how many columns are in the map file
//rows = how many rows are in the map file
//tilesize = size of the tiles all tiles must be equal
//landscape = our game is played in landscape or portrait
//imagesizeX = the size of the image, or the size within the texture atlas
//imagesizeY = the size of the image, or the size within the texture atlas
//=============================================================================
-(void) InitTileset:(Image *)ImageDraw  TotalLayers:(int)TotalLayers  Columns:(int)maxcolumns  Rows:(int)maxrows  SizeTile:(int)tilesize
		   Lanscape:(bool)landscape
		 ImagesizeX:(int)imagesizeX  ImagesizeY:(int)imagesizeY
{

	Layers = TotalLayers;
	MaxRows = maxrows;
	MaxColumns = maxcolumns;
	TileSize = tilesize;
	WideTotalMap = ((MaxColumns-1)*TileSize); //we take minus 1 to "fake" the limits off map
	HeighTotalMap = ((MaxRows-1)*TileSize); //we take minus 1 to "fake the limits off map
	
	
	//speed for automatic scrolling maps
	speed = 4;
	


	//init screen size for tilemaps
	if (landscape) {
		screenX = 480;
		screenY = 320;
	}else {
		screenX = 320;
		screenY = 480;
	}

	
	//create memory to hold the map with all layers
	//init the dinamic array level
	int a,b;
	level = (Tile_Struct ***)malloc(Layers * sizeof(Tile_Struct **));
	for (a = 0; a < Layers; a++){
		level[a] = (Tile_Struct **)malloc(MaxRows * sizeof(Tile_Struct *));
		for (b = 0; b < MaxRows; b++)
			level[a][b] =
			(Tile_Struct *)malloc(MaxColumns *sizeof(Tile_Struct));
	}
	
	
	

	//calculate image coords size, basically how many rows and columns are in that image
	ImageSizeX = (imagesizeX / tilesize);
	ImageSizeY =  (imagesizeY / tilesize);
	
	//create memory for arrays, vertex, coords and texture
	textureCoordinates = calloc( 1, sizeof( Quad2f ) );
	mvertex = calloc( 1, sizeof( Quad2f ) );
	cachedTexture = calloc((ImageSizeX * ImageSizeY), sizeof(Quad2f));
	
	//now loop the tileset and cache all the texture coordinates
	//this will speed up things a lot
	int spriteSheetCount = 0;
    for(int i=0; i<ImageSizeY; i++) {
        for(int j=0; j<ImageSizeX; j++) {
            [ImageDraw cacheTexCoords:TileSize
					  SubTextureHeight:TileSize  
					 CachedCoordinates:textureCoordinates 
						CachedTextures:cachedTexture
							   Counter:spriteSheetCount
								  PosX:j * TileSize
								 PosY:i * TileSize ];
			spriteSheetCount++;
        }
    }

	

	
}






//=============================================================================
-(void) CleanLevel
{
	//reset all values to 0
	for (int l = 0; l < Layers; l++){
	for(int y = 0; y < MaxRows; y++){
    for(int x = 0; x < MaxColumns; x++){

		level[l][y][x].Tilenum = 0;
		level[l][y][x].visible = false;
		level[l][y][x].nowalkable = true;
		level[l][y][x].object = false;
		level[l][y][x].tileAnimated = false;
		level[l][y][x].animated[MAXANIMATION] = 0;
		level[l][y][x].delay = 0;
		level[l][y][x].nextframe = 0;
		level[l][y][x].delaySpeed = 0;
        }
    }
	}
	
}



//read the map file, you must specify wich layer are you loading
//remember all layers start on 0
//=============================================================================
-(void)ReadLevel:(NSString *)filemap Layer:(int)Layer
{
	NSString * path = [[NSBundle mainBundle] pathForResource:filemap ofType:@"CSV"];
	FILE *f = fopen([path cStringUsingEncoding:1],"r");
	if (f == NULL)
	NSLog(@"map file not found");


	for ( int row=0; row < MaxRows; row++) {
		for ( int column=0; column < MaxColumns; column++) {

            fscanf(f, "%d, ", &level[Layer][row][column].Tilenum);
        }
    }

    fclose(f);
}




//this function will change and we will load those values from a xml file
//right now the values are hardcoded, walls, walkable,etc,etc
//having this function with values on a xml file allows us more flexibility
//and anyone can change the file to make changes on the game
//=============================================================================
-(void) ProcessTiles
{

    int index = 0;
	
	//now go through each layer and all map width and height
	//and add the properties we want for each tile
	//doors, walls, water, etc,etc
	for (int l = 0; l < Layers; l++)
	{
		for (int i = 0; i < MaxRows; i ++)
		{
			for (int j = 0; j < MaxColumns; j++)
			{
				index = level[l][i][j].Tilenum;
	
				
				switch (index)
				{
					case 0: //empty
						level[l][i][j].visible = false;
						level[l][i][j].nowalkable = true;
						level[l][i][j].object = false;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
				 
					case 1:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = true;
						level[l][i][j].object = false;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
								
					case 4: //water
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = true;
						level[l][i][j].object = false;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
					
					case 5:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = false;
						level[l][i][j].object = true;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].animated[0] = 5;
						level[l][i][j].animated[1] = 6;
						level[l][i][j].animated[2] = 7;
						level[l][i][j].animated[3] = 8;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 5;
						break;
						
					case 6:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = false;
						level[l][i][j].object = true;
						level[l][i][j].tileAnimated = true;
						level[l][i][j].animated[0] = 6;
						level[l][i][j].animated[1] = 7;
						level[l][i][j].animated[2] = 8;
						level[l][i][j].animated[3] = 1;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 8;
						break;
						
					case 7:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = false;
						level[l][i][j].object = true;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
						
					case 8:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = false;
						level[l][i][j].object = true;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
						
					case 9:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = false;
						level[l][i][j].object = true;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
						
					//default values for tiles
					default:
						level[l][i][j].visible = true;
						level[l][i][j].nowalkable = false;
						level[l][i][j].object = false;
						level[l][i][j].tileAnimated = false;
						level[l][i][j].delay = 0;
						level[l][i][j].nextframe = 0;
						level[l][i][j].delaySpeed = 0;
						break;
				}
				 
			}
		}
	}
	

}





//get the current tile in that position
//if tile is animated get the current frame to draw
- (int) getSpriteIndeX:(int)X Y:(int)Y Layer:(int)Layer 
{
	
	if (level[Layer][Y][X].tileAnimated)
	{
	
		if (level[Layer][Y][X].delay < 0) //if delay < 0, change to next frame and reset delay counter
		{
			level[Layer][Y][X].nextframe ++;
			level[Layer][Y][X].Tilenum = level[Layer][Y][X].animated[level[Layer][Y][X].nextframe];
			
			level[Layer][Y][X].delay = level[Layer][Y][X].delaySpeed; //reset delay counter to value asigned
			
			//we reach the max frame, so reset to 0 and start over
			if (level[Layer][Y][X].nextframe == MAXANIMATION)
			{
				level[Layer][Y][X].nextframe = 0;
				level[Layer][Y][X].Tilenum = level[Layer][Y][X].animated[0];
				return  level[Layer][Y][X].Tilenum;
			}
		}
		else level[Layer][Y][X].delay --;
	}
		
	
	return level[Layer][Y][X].Tilenum;
	
}




//=============================================================================
-(void) DrawLevel:(Image *)Surf_Draw  CameraX:(float)CameraX  CameraY:(float)CameraY  Layer:(int)Layer   Colors:(Color4f)_colors  
{

	int index = 0;
    int x,y;
	int xtile, ytile, xpos,ypos;
	
	//add calculations to achieve smooth scroll
	xtile = CameraX / TileSize;
	ytile = CameraY / TileSize;
	xpos = (int)CameraX & TileSize-1;
	ypos = (int)CameraY & TileSize-1;
	

	unsigned char red = _colors.red * 255.0f;
	unsigned char green = _colors.green * 255.0f;
	unsigned char blue = _colors.blue * 255.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	
	//we only want to render the visible screen plus 1 tile in each direcction
	// if map its more bigger than the screen resolution, that extra tile its 
	//for smooth scroll, so we only scan the screen resolution
	for (int i = 0; i < (screenY/TileSize)+2; i ++)
	{
		for (int j = 0; j < (screenX/TileSize)+2; j++)
		{
			
			if (level[Layer][i+ytile][j+xtile].visible) 
			{
				//loop through the map
				index = [self getSpriteIndeX:j+xtile  Y:i+ytile  Layer:Layer];
				
				//convert map coords into pixels coords
				x=(j*TileSize) - xpos;
				y=(i*TileSize) - ypos;
	
				//calculate the vertex coordinates for this tile to render on screen
				Quad2f vert = *[Surf_Draw getVerticesForSpriteAtrect:CGRectMake(x, y, TileSize, TileSize) Vertices:mvertex Flip:1];
				
				//the textures are cached on a quad array, simply retrieve the correct texture coordinate from the array
				// Triangle #1
				[Surf_Draw _addVertex:vert.tl_x  Y:vert.tl_y  UVX:cachedTexture[index].tl_x  UVY:cachedTexture[index].tl_y  Color:_color];
				[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				
				// Triangle #2
				[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				[Surf_Draw _addVertex:vert.br_x  Y:vert.br_y  UVX:cachedTexture[index].br_x  UVY:cachedTexture[index].br_y  Color:_color];
			}
		}
	}//end for
		

}


	






//=============================================================================
-(void) DrawLevelWithScroll:(Image *)Surf_Draw ScrollY:(bool)ScrollY MapWidth:(int)mapX  MapHeight:(int)mapY  Layer:(int)Layer  Colors:(Color4f)_colors
{
	
	int index = 0;
    int x,y;

	
	unsigned char red = _colors.red * 255.0f;
	unsigned char green = _colors.green * 255.0f;
	unsigned char blue = _colors.blue * 255.0f;
	unsigned char shortAlpha = _colors.alpha * 255.0f;
	
	//	pack all of the color data bytes into an unsigned int
	unsigned _color = (shortAlpha << 24) | (blue << 16) | (green << 8) | (red << 0);
	
	
	//calculate speed for scroll here, higher number means more slower scroll
	if(speed == 3)
	{
		speed = 0;
		indiceScroll +=1;
	}
	else
		speed++;
	
	
	//if we are at the end of the level
	//start again the map
	if (ScrollY)
	{
		if(indiceScroll>=HeighTotalMap - screenY)
		{
			indiceScroll = 0;
		}
	}
	else {
		if(indiceScroll>=WideTotalMap - screenY)
		{
			indiceScroll = 0;
		}
	}
	
	//we only want to render the visible screen plus 1 tile in each direcction
	// if map its more bigger than the screen resolution, that extra tile its 
	//for smooth scroll, so we only scan the screen resolution
	for(int i=0; i < mapY; i++){
		for(int j=0; j < mapX; j++){
			if (level[Layer][i][j].visible == YES)
			{
				//loop through the map
				// index = level[Layer][i][j].Tilenum;
				index = [self getSpriteIndeX:j  Y:i  Layer:Layer];
				//index = [self getSpriteIndex:level[Layer][i][j].Tilenum];

				if (ScrollY)
				{
					//convert map coords into pixels coords
					x=(j*TileSize);
					y=(i*TileSize) - indiceScroll;
				}
				else {
					//convert map coords into pixels coords
					x=(j*TileSize) - indiceScroll;
					y=(i*TileSize);
				}				
				
				
				
				Quad2f vert = *[Surf_Draw getVerticesForSpriteAtrect:CGRectMake(x, y, TileSize, TileSize) Vertices:mvertex Flip:1];
				
				//the textures are cached on a quad array, simply retrieve the correct texture coordinate from the array
				// Triangle #1
				[Surf_Draw _addVertex:vert.tl_x  Y:vert.tl_y  UVX:cachedTexture[index].tl_x  UVY:cachedTexture[index].tl_y  Color:_color];
				[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				
				// Triangle #2
				[Surf_Draw _addVertex:vert.tr_x  Y:vert.tr_y  UVX:cachedTexture[index].tr_x  UVY:cachedTexture[index].tr_y  Color:_color];
				[Surf_Draw _addVertex:vert.bl_x  Y:vert.bl_y  UVX:cachedTexture[index].bl_x  UVY:cachedTexture[index].bl_y  Color:_color];
				[Surf_Draw _addVertex:vert.br_x  Y:vert.br_y  UVX:cachedTexture[index].br_x  UVY:cachedTexture[index].br_y  Color:_color];
				
			}
		}
	}

}









//=============================================================================
-(int) SetPosLevelX:(int) x
{
    return x * TileSize;
}



//=============================================================================
-(int) SetPosLevelY:(int) y
{
    return y * TileSize;
}



-(int) GetTileNum:(int)x y:(int)y Layer:(int)l
{
    return level[l] [y / TileSize] [x /  TileSize].Tilenum;
}

//=============================================================================
-(bool) CollisionTile:(int)x  y:(int)y  Layer:(int)l
{
	//first convert pixel coords into map coords    
     return level[l][y / TileSize] [x /  TileSize].nowalkable;

}




//=============================================================================
-(bool) CollisionObjects:(int)x y:(int)y tilenum:(int)tilenum  Layer:(int)l
{
	
	int tile_num = level[l] [y / TileSize] [x /  TileSize].Tilenum;
	
	if (tile_num == level[l] [y / TileSize] [x /  TileSize].visible)
	{
        return YES;
	}
	else
		return NO;
	
}

-(bool) CollisionObjects:(int)x y:(int)y Layer:(int)l
{
	return level[l][y / TileSize] [x /  TileSize].object;
}


//=============================================================================
-(void) GetObjects:(int)x y:(int) y  Layer:(int)l
{
    level[l] [y / TileSize] [x / TileSize].visible = false;
}



//=============================================================================
-(void) RemoveObject:(int) x y:(int) y  Layer:(int)l
{
	
    level[l] [y / TileSize] [x / TileSize].visible = false;
    level[l] [y / TileSize] [x / TileSize].nowalkable = false;
}


@end




