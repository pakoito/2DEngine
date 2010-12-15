
#import "MenuScreen.h"
#import "Fonts.h"
#import "SoundManager.h"
#import "LenguageManager.h"
#import "Widgets.h"


@implementation MenuScreen






- (id) init:(StateManager *)states_ 
{  
    self = [super init]; 
	menustate = states_; 

	[self loadContent];
	
    return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	[super dealloc];
	
}




- (void) loadContent  
{ 
	
	// Init sound
	sharedSoundManager = [SoundManager sharedSoundManager];
	
	
	SpriteGame  = [[Image alloc] initWithTexture:@"mainmenu.png"  filter:GL_NEAREST Use32bits:NO TotalVertex:2000];

	fontImage = [[Image alloc] initWithTexture:@"gunplay_18_outline.png" filter:GL_NEAREST Use32bits:YES TotalVertex:2000];
	
	
	//init the font
	FontMenu  = [[Fonts alloc] LoadFont:fontImage FileFont:@"gunplay_18_outline.fnt"];// @"war.font"];

	MenuText = [[LenguageManager alloc] init];
	[MenuText LoadText:@"menu"];
	
 


	//used for selected option
	selected = 0;
	
	//active to mark load
	active = 0;
	

	
	y = 0;
	Time = 2;
	exitscreen = NO;
	
	
	button1 = [[Widgets alloc] initWidget:Vector2fMake(80.0f, 140.0f)
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(2.0f, 1.0f)
									Touch:CGRectMake(80, 140, 100, 40)
								 Rotation:0.0f 
								   Active:YES
									Image:SpriteGame];
	
	button2 = [[Widgets alloc] initWidget:Vector2fMake(190.0f, 190.0f)
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(2.0f, 1.0f)
									Touch:CGRectMake(190, 190, 100, 40)
								 Rotation:0.0f 
								   Active:YES
									Image:SpriteGame];
	button3 = [[Widgets alloc] initWidget:Vector2fMake(260.0f, 260.0f)
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(2.0f, 1.0f)
									Touch:CGRectMake(260, 260, 100, 40)
								 Rotation:0.0f
								   Active:YES
									Image:SpriteGame
									 Font:FontMenu];

			   /*
	button3 = [[Widgets alloc] initWidget:Vector2fMake(260.0f, 260.0f)
									 Size:Vector2fMake(40.0f, 40.0f)
								 LocAtlas:Vector2fMake(472.0f, 152.0f)
									Color:Color4fInit 
									Scale:Vector2fMake(2.0f, 1.0f)
									Touch:CGRectMake(260, 260, 100, 40)
								 Rotation:0.0f
								   Active:NO
									Image:SpriteGame];
	*/
	
	
	backgroundWidget = [[Widgets alloc] initWidget:Vector2fZero
											  Size:Vector2fMake(480, 320)
										  LocAtlas:Vector2fMake(0, 192)
											 Image:SpriteGame];

}




- (void) unloadContent  
{  
	[MenuText release];
	[button1 release];
	[button2 release];
	[button3 release];
	[FontMenu release];
	[SpriteGame release];
	[self dealloc];
} 





-(void) TimeOut
{
	
	if( !( y%43 ) ) //55 its some value that fit my needs
	{
		Time--;
	}
	y++;
	
	if(Time <= 0)
	{
		[self LoadOption];
	
	}
}


-(void) LoadOption
{
	if (selected == 1)
	{
		exitscreen = YES;
	}
}







- (void) handleInput:(InputManager *)inputmenu  
{  	
	
	if (active == 0)
	{
		if ([inputmenu isButtonPressed:button1.touch Active:button1.active])  
		{  
			selected = 1;
			active = 1;
		} 
	}
	
	
} 












- (void) update:(float)deltaspeed 
{  

	if (selected != 0)
	{
		if (Time > 0)
		{
			[self TimeOut];
		}
	}
	

	//when exitscreen update the transition
	//when the transition finish change the screen
	if (exitscreen)
	{
		if (!menustate.fadeOut)
		{
			[menustate UpdateTransitionOut];
		}
		else{
			switch (selected) {
				case 1:
					[menustate ChangeStates:PLAY];
					menustate.menuinitialised = NO;
					menustate.fadecompleted = NO;
					Time = 2;
					menustate.fadeOut = NO;
					menustate.alphaOut = 0.0f;
					[self unloadContent];
					break;
				
				default:
					break;
			}
			
			
		}
	}
	
	
}  






- (void) draw 
{ 
	


	[backgroundWidget DrawWidget];
	
	[button1 DrawWidget];
	[button2 DrawWidget];
	//[button3 DrawWidget];
	
	//draw all sprites without alpha
	[SpriteGame RenderToScreenActiveBlend:NO];
	
	
	if (MenuText.Languages == ENGLISH)
	{
		if (active == 1)
			[FontMenu DrawText:fontImage X:10 Y:290 Scale:1.0 Text:[MenuText.TextArray objectAtIndex:3]];
			
		switch (selected)
		{
			case 0: //none selected
				[FontMenu DrawTextCenteredPosX:fontImage Width:[button1 GetWidthOfWidget] X:[button1 GetPositionX] Y:[button1 GetCenterOfWidgetY] Scale:1.0 Text:[MenuText.TextArray objectAtIndex:0]];
				[FontMenu DrawTextCenteredPosX:fontImage Width:[button2 GetWidthOfWidget] X:[button2 GetPositionX] Y:[button2 GetCenterOfWidgetY] Scale:1.0 Colors:Color4fMake(128, 220, 90, 1.0) Text:[MenuText.TextArray objectAtIndex:1]];
				//[FontMenu DrawTextCenteredPosX:SpriteGame Width:[button3 GetWidthOfWidget] X:[button3 GetPositionX] Y:[button3 GetCenterOfWidget] Scale:1.0 Colors:Color4fMake(128, 220, 90, 0.5) Text:[MenuText.TextArray objectAtIndex:2]];
				//[button3 DrawWidgetFont:[MenuText.TextArray objectAtIndex:2]];
				[fontImage RenderToScreenActiveBlend:YES];
				//[button3 DrawWidgetFont:[MenuText.TextArray objectAtIndex:2] Scale:1.0f Color:Color4fMake(128, 220, 90, 0.5)];
				break;
				
			case 1:
				[FontMenu DrawText:SpriteGame X:200 Y:140 Scale:0.9 Text:[MenuText.TextArray objectAtIndex:0]];
				break;
		}

	}else{

		/*if (active == 1)
			[FontMenu DrawText:SpriteGame X:10 Y:290 Scale:1.0 Text:@"Cargando..."];
		switch (selected)
		{
			case 0: //none selected
				[FontMenu DrawTextCenteredPosX:SpriteGame Width:[button1 GetWidthOfWidget] X:[button1 GetPositionX] Y:[button1 GetCenterOfWidgetY] Scale:1.0 Text:[MenuText.TextArray objectAtIndex:0]];
				[FontMenu DrawTextCenteredPosX:SpriteGame Width:[button2 GetWidthOfWidget] X:[button2 GetPositionX] Y:[button2 GetCenterOfWidgetY] Scale:1.0 Colors:Color4fMake(128, 220, 90, 1.0) Text:[MenuText.TextArray objectAtIndex:1]];
				[FontMenu DrawTextCenteredPosX:SpriteGame Width:[button3 GetWidthOfWidget] X:[button3 GetPositionX] Y:[button3 GetCenterOfWidgetY] Scale:1.0 Colors:Color4fMake(128, 220, 90, 0.5) Text:[MenuText.TextArray objectAtIndex:2]];
				break;
				
			case 1:
				[FontMenu DrawText:SpriteGame X:195 Y:140 Scale:0.9 Text:[MenuText.TextArray objectAtIndex:0]];
				break;
		}
		 */
	}

	/*[FontMenu DrawText:SpriteGame 
					 X:menustate.screenBounds.x - [FontMenu GetTextWidth:[NSString stringWithFormat: @"FPS %.1f", menustate._FPS] Scale:1.0f] 
					 Y:menustate.screenBounds.y - 20 
				 Scale:1.0 
				  Text:[NSString stringWithFormat: @"FPS %.1f", menustate._FPS]];

	*/
	
	//draw all alpha sprites
	[SpriteGame RenderToScreenActiveBlend:YES];
	
	
	
		
	
	//draw transition when we select one option
	if (selected !=0)
		[menustate fadeBackBufferToBlack:menustate.alphaOut];
		
}  





@end






