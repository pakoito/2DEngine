//
//  Widgets.m
//  War_Warriors
//
//  Created by Alejandro Perez Perez on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Widgets.h"
#import "Image.h"
#import "Fonts.h"



@implementation Widgets


@synthesize size, position, locAtlas;
@synthesize color, scale, touch, rotation;
@synthesize active;


//init a widget without text, typically only a button
//usually you pass a tileset/texture atlas for the button
//pos = position on screen
//size = size of the widget
//locatlas = position of that widget within the texture atlas/spritesheet
//Color = color to apply to that image, or leave it white to use the image as it is
//scale = scale of that widget
//touch = touchable area of that widget, for tap inside
//rotation = rotation for that widget applied in degrees
// active = only active widgets are rendered on screen
//image = the atlas containing the widget or the image itself
//font = font to draw the text within the button
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Touch:(CGRect)Touch Rotation:(float)Rotation Active:(bool)Active Image:(Image *)image
{
	self = [super init];
	if (self != nil) {
	
		position = pos;
		size = Size;
		locAtlas = LocAtlas;
		color = Color;
		scale = Scale;
		touch = Touch;
		rotation = Rotation;
		widgetImage = image;
		active = Active;
		widgetFont = nil;
	}
	return self;
}


//init a widget with text, typically a button with text
- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Touch:(CGRect)Touch Rotation:(float)Rotation Active:(bool)Active Image:(Image *)image Font:(Fonts *)font;
{
	self = [super init];
	if (self != nil) {
		
		position = pos;
		size = Size;
		locAtlas = LocAtlas;
		color = Color;
		scale = Scale;
		touch = Touch;
		rotation = Rotation;
		widgetImage = image;
		active = Active;
		widgetFont = font;
	}
	return self;
}


- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Rotation:(float)Rotation Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color Scale:Scale Touch:CGRectNull Rotation:0.0f Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Scale:(Vector2f)Scale Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color Scale:Scale Touch:CGRectNull Rotation:0.0f Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Color:(Color4f)Color Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color Scale:Vector2fInit Touch:CGRectNull Rotation:0.0f Active:YES Image:image];
}

- (id) initWidget:(Vector2f)pos Size:(Vector2f)Size LocAtlas:(Vector2f)LocAtlas Image:(Image *)image
{
	return [self initWidget:pos Size:Size LocAtlas:LocAtlas Color:Color4fInit Scale:Vector2fInit Touch:CGRectNull Rotation:0.0f Active:YES Image:image];
}



- (void) dealloc
{
	[super dealloc];
}



//draw widget only
- (void) DrawWidget
{
	if (active)
	[widgetImage DrawSprites:CGRectMake(position.x, position.y, size.x*scale.x, size.y*scale.y) 
				 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
				  ImageWidth:size.x ImageHeight:size.y 
						Flip:1 
					  Colors:color 
					Rotation:rotation];
	
}


- (void) DrawWidgetFont:(NSString *)text
{
	[self DrawWidgetFont:text Scale:1.0f Color:color];	
}


//draw widget with text, the text will be centered on the widget
- (void) DrawWidgetFont:(NSString *)text Scale:(float)scaletext Color:(Color4f)colortext
{
	if (active)
	{
		[widgetImage DrawSprites:CGRectMake(position.x, position.y, size.x*scale.x, size.y*scale.y) 
					 OffsetPoint:CGPointMake(locAtlas.x, locAtlas.y) 
					  ImageWidth:size.x ImageHeight:size.y 
							Flip:1 
						  Colors:color 
						Rotation:rotation];
		[widgetFont DrawTextCenteredPosX:widgetImage
								   Width:[self GetWidthOfWidget] 
									   X:[self GetPositionX] 
									   Y:[self GetCenterOfWidgetY] 
								   Scale:scaletext
								  Colors:colortext
									Text:text];
	}
}

- (int) GetCenterOfWidgetY
{
	return position.y + (((size.y*scale.y)/2)/2);
}

- (int) GetCenterOfWidgetX
{
	return position.x + (((size.x*scale.x)/2));
}


- (int) GetWidthOfWidget
{
	return size.x*scale.x;
}

- (int) GetPositionX
{
	return position.x;
}

- (int) GetPositionY
{
	return position.y;
}



@end
