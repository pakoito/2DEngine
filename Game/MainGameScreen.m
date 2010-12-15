//
//  
//  
//
//  Created by Eskema on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainGamescreen.h"

#import "Fonts.h"
#import "SoundManager.h"
#import "LenguageManager.h"
#import "Camera.h"
#import "BaseActor.h"
#import "ParticleEmitter.h"



//to display fps if we want
#define FPS 1





@implementation MainGameScreen


//  
//  Initialize the ingame screen  
//  
-(id) init:(StateManager *)States_;
{  
    self = [super init];
	if (self != nil)  
    {  
		gameState = States_;
		[self loadContent]; 

	}
	return self;
}




- (void) dealloc
{
	[super dealloc];
}








- (void) loadContent  
{

	exitScreen = NO;
	
	pausedgame = NO;
	
	
	
	//////////
	// IMAGES
	//////////
	SpriteGame		= [[Image alloc] initWithTexture:@"SpriteSheet.png"  filter:GL_NEAREST Use32bits:NO TotalVertex:2000];

	
	//init the font
	font1 = [[Fonts alloc] LoadFont:SpriteGame FileFont:@"test"];
	
	//camera
	tileCamera = [[Camera alloc] init];
	


	

	//player
	Mainplayer	= [[BaseActor alloc] init];
	//init player			
		
	
	
	//positions for touches in pause
	saveexitbutton = CGRectMake(150, 280, 250, 40);
	
	
	//touch for menu
	exitgamebutton	= CGRectMake(120, 0, 160, 60);
	
	//touch for exit inventory
	touchContinue = CGRectMake(105, 130, 100, 25);
	
	//pause
	pausebutton = CGRectMake(0, 0, 35, 35);
	

	
	//touch for inventory
	touchInventory = CGRectMake(440, 0, 50, 40);
	
	//touch attack;
	touched = NO;

	
	
	//controlpad for test
	//touch in the corners of the screen
	padUp				= CGRectMake(40, 200, 50, 40); 
	padDown				= CGRectMake(48, 280, 40, 35); 
	padLeft				= CGRectMake(0,  245, 30, 34); 
	padRight			= CGRectMake(85, 245, 35, 34); 
	
	
	//text resources
	MainGameText = [[LenguageManager alloc] init];
	if (MainGameText.Languages == SPANISH)
	{
		[MainGameText LoadText:@"Text_GameSPA"];
	}else {
		[MainGameText LoadText:@"Text_GameENG"];
	}
	
	
	// Init particle emitter with explosion
	particles = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"particle_explosion.png"
																  position:Vector2fMake(0, 0)
													sourcePositionVariance:Vector2fMake(50, 35)
																	 speed:0.25f
															 speedVariance:0.2f
														  particleLifeSpan:0.75f	
												  particleLifespanVariance:0.25f
																	 angle:0.0f
															 angleVariance:360
																   gravity:Vector2fMake(0.0f, 0.0f)
																startColor:Color4fMake(1.0f, 0.0f, 0.0f, 1.0f)
														startColorVariance:Color4fMake(0.2f, 0.2f, 0.2f, 1.0f)
															   finishColor:Color4fMake(1.0f, 1.0f, 0.3f, 0.0f)  
													   finishColorVariance:Color4fMake(0.4f, 0.4f, 0.4f, 0.0f)
															  maxParticles:100
															  particleSize:20
													  particleSizeVariance:6
																  duration:0.0f
															 blendAdditive:YES];	
	[particles setActive:NO];
	[self InitGame];
	
}  




- (void) unloadContent  
{ 
	[MainGameText release];
	[font1 release];
	[SpriteGame release];
	[Mainplayer release];
	[particles release];
	[self dealloc];
}  




//update touches ingame
//this code is only a skeleton, and based on a specific game
//you need to delete this and create your touch code for you joystick or whatever
- (void) handleInput:(InputManager *)inputGame
{  
	//touches to move the character
	if ([inputGame isButtonHeld:padUp Active:YES])  
    {  
		Mainplayer.MoveUp = true;
    }  
	if ([inputGame isButtonHeld:padDown Active:YES])   
    {  
		Mainplayer.MoveDown = true;
    }  
	if ([inputGame isButtonHeld:padLeft Active:YES])  
    {  
		Mainplayer.MoveLeft = true;
    }  
	if ([inputGame isButtonHeld:padRight Active:YES])  
    { 
		Mainplayer.MoveRight = true;
    }  
	
	
	if (![inputGame isButtonHeld:padUp Active:YES])   
    {  
		Mainplayer.MoveUp = false;
    }  
	if (![inputGame isButtonHeld:padDown Active:YES])  
    {  
		Mainplayer.MoveDown = false;
    }  
	if (![inputGame isButtonHeld:padLeft Active:YES])  
    {  
		Mainplayer.MoveLeft = false;
    }  
	if (![inputGame isButtonHeld:padRight Active:YES])  
    {  
		Mainplayer.MoveRight = false;
    }  
	
	
	//display particles if someone touch in that area
	/*if ([inputGame isButtonPressed:touchExplosion]) {
		[particles setActive:YES];
		 [particles setDuration:0.04f];
		 particles.sourcePosition = Vector2fMake((Mainplayer.x+50)-tileCamera.CameraX, (Mainplayer.y+40)-tileCamera.CameraY);
	}*/
	
	
	
	
	//if game is paused, unpause, if not pause game
	if ([inputGame isButtonPressed:pausebutton Active:YES] && pausedgame == YES)  
	{ 
		pausedgame = NO;
	} else if ([inputGame isButtonPressed:pausebutton Active:YES]  && pausedgame == NO){
		pausedgame = YES;
	}

	
	
	//return to game when you are in pause and press the button
	if ([inputGame isButtonPressed:exitgamebutton Active:YES] && pausedgame == YES)  
	{ 
		pausedgame = NO;
	} 
	
	//if you are in pause and press the button, exit to main menu
	if (pausedgame == YES)
	{
		if ([inputGame isButtonPressed:saveexitbutton Active:YES])    
		{
			exitScreen = YES;
		}
	}

	
	
	
	
	//release all touches
	if ( !inputGame.currentState.isBeingTouched )
	{
		touched = NO;
	}
	
} 









- (void) update:(float)deltaTime
{  
	//update transition to exit
	if (exitScreen)
	{
		if (!gameState.fadeOut)
		{
			[gameState UpdateTransitionOut];
		}
		else{
			[gameState ChangeStates:MENU];
			gameState.alphaOut = 0.0f;
			gameState.fadeOut = NO;
			gameState.gameinitialised = NO;
			gameState.fadecompleted = NO;
			[self unloadContent];
		}
		
	}
	
	//game is not paused? then update player and camera position/animation
	if (!pausedgame)
	{
		[particles update:deltaTime];
		
		//update our player animations and movements
		[Mainplayer Update];
		
			
	}
	
}  










- (void) draw
{
	[self DrawLevelGame];

}  










//////////////////////////////////////////////
/////
////
////    MAIN GAME
////
////
/////////////////////////////////////////////

-(void) InitGame
{
	exitScreen = NO;
	pausedgame = NO;
}
	 










-(void) DrawLevelGame
{



	//draw border, inventory icon and touchpad
	[SpriteGame DrawImage:CGRectMake(0, 0, 480, 320) 
			  OffsetPoint:CGPointMake(0, 704)
			   ImageWidth:480 ImageHeight:320];
	//inventory
	[SpriteGame DrawImage:CGRectMake(440, -10, 50, 50) 
			  OffsetPoint:CGPointMake(448, 0)
			   ImageWidth:64 ImageHeight:64];
	//touchpad
	[SpriteGame DrawImage:CGRectMake(30, 245, 67, 54) 
			  OffsetPoint:CGPointMake(957, 650)
			   ImageWidth:67 ImageHeight:54];
	
	
	//player
	[Mainplayer Draw:SpriteGame  CameraX:0.0   CameraY:0.0];
	
	
	//draw all sprites in one batch
	[SpriteGame RenderToScreenActiveBlend:YES];
	
	
	
	//now draw text in another batch because this is
	//a different texture
	[font1 DrawText:SpriteGame X:90  Y:0  Scale:1.0  Text:[MainGameText.TextArray objectAtIndex:0]];
	[font1 DrawText:SpriteGame X:315  Y:0  Scale:1.0  Text:@"Inventory"];

	
	
	//we want to draw fps?
	if(FPS)
	{
		[font1 DrawText:SpriteGame X:385 Y:290 Scale:1.0f Text:[NSString stringWithFormat: @"FPS %.1f", gameState._FPS]];
	}
	
	//draw all the sprites with alpha blend active, needed for transparency
	[SpriteGame RenderToScreenActiveBlend:YES];
	

	
	
	//render particles after tilemaps and fonts
	//[particles renderParticles];
	
	

	//draw when pause the game
	if (pausedgame == YES)
	{
		[SpriteGame DrawImage:CGRectMake(80, 120, 300, 80) 
					OffsetPoint:CGPointMake(704, 1)
					 ImageWidth:236 ImageHeight:143];
		

		[SpriteGame DrawImage:CGRectMake(120, 0, 190, 45) 
				  OffsetPoint:CGPointMake(704, 1)
				   ImageWidth:236 ImageHeight:143];
		
		
		//draw all sprites in one batch
		[SpriteGame RenderToScreenActiveBlend:YES];
		
		
		if (MainGameText.Languages == ENGLISH)
		{
			[font1 DrawText:SpriteGame X:140  Y:130  Scale:1.5  Text:@"PAUSE"];
			[font1 DrawText:SpriteGame X:90  Y:165  Scale:1.0  Text:@"Time for relax?"];
			[font1 DrawText:SpriteGame X:130  Y:210  Scale:1.0  Text:@"EXIT GAME"];
			[font1 DrawText:SpriteGame X:100  Y:290  Scale:1.0  Text:@"Touch at the bottom to exit"];

					}else{
						[font1 DrawText:SpriteGame X:140  Y:130  Scale:1.5  Text:@"PAUSA"];
						[font1 DrawText:SpriteGame X:95  Y:165  Scale:1.0  Text:@"Tiempo muerto"];
						[font1 DrawText:SpriteGame X:130  Y:210  Scale:0.9  Text:@"Salir del juego"];
						[font1 DrawText:SpriteGame X:130  Y:290  Scale:1.0  Text:@"Toca abajo para salir"];
		}
		
		//draw the second batch
		[SpriteGame RenderToScreenActiveBlend:YES];
		
		
	}
	
	
	
	
	
	
	//if we are exiting to main menu draw the transition screen
	if(exitScreen)
		[gameState fadeBackBufferToBlack:gameState.alphaOut];
	
		

}
 




-(void) ExitGame
{
	[self unloadContent];
}



@end








