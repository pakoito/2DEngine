//
//  StateManager.m
//  
//
//  Created by Eskema on 02/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "StateManager.h"



#import "MenuScreen.h"
#import "MainGamescreen.h"




@implementation StateManager
@synthesize input;
@synthesize screenBounds;
@synthesize menuinitialised, gameinitialised;
@synthesize fadecompleted, fadeOut, alpha, alphaOut, TimeAlpha, TimeAlphaOut, counteralpha, counteralphaOut;
@synthesize blanktexture, _FPS, SpeedFactor,  TotalVolume, VolumeGlobal;





- (id) init 
{  
    self = [super init]; 

	StateOption = MENU;

	menuinitialised = NO;
	gameinitialised = NO;


	fadeOut = NO;
	fadecompleted = NO;
	counteralphaOut = 0;
	
	//for transitions
	alpha = 1.0f;
	alphaOut = 0.0f;
	TimeAlpha = 10;
	TimeAlphaOut = 10;
	counteralpha = 0;
	
	
	
	
	//volume
	VolumeGlobal = 5;
	TotalVolume = 0.5;
	
	//for fps counter
	_FPS = 0;
	
	//gamespeed
	SpeedFactor = 0;
	
	//texture for transitions between screens
	blanktexture  = [[Image alloc] initWithTexture:@"Blank.png"  filter:GL_NEAREST Use32bits:NO TotalVertex:12];
	

	// Init sound and load a sound
	sharedSoundManager = [SoundManager sharedSoundManager];
	//[sharedSoundManager loadSoundWithKey:@"soundtest" fileName:@"click" fileExt:@"wav" ];

	input = [[InputManager alloc] init];  
    input.isLandscape = YES; 
	
    return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	[sharedSoundManager shutdownSoundManager];
	[blanktexture release];
	[input release];
	[super dealloc];
}




-(int) GetState
{
    return StateOption;
}




-(void) ChangeStates:(options)optionselected
{
	StateOption = optionselected;
    
}






//the counter alpha value is some value that fit may needs
//you can change this to modify the speed of the transitions (fade out/in)
-(void) UpdateScreenTransition
{
	
	if( !( counteralpha%5 ) ) 
	{
		TimeAlpha--;
		
		if (alpha > 0.0f)
		{
			alpha -=0.1f;
		}
	}
	counteralpha++;
	
	if (TimeAlpha <= 0)
	{
		fadecompleted = YES;
		alpha = 1.0f;
		TimeAlpha = 10;
		counteralpha = 0;
	}
}


-(void) UpdateTransitionOut
{
	
	if( !( counteralphaOut%7 ) ) //7 its some value that fit my needs
	{
		TimeAlphaOut--;
		
		if (alphaOut < 1.0f)
		{
			alphaOut +=0.1f;
		}
	}
	counteralphaOut++;
	
	if (TimeAlphaOut <= 0)
	{
		fadeOut = YES;
		alphaOut = 1.0f; 
		TimeAlphaOut = 10;
		counteralphaOut = 0;
	}
}




- (void) fadeBackBufferToBlack:(double)alpha1  
{  
    glColor4f(alpha1, alpha1, alpha1, alpha1);  
	[blanktexture  drawInEntireRect:CGRectMake(0, 0, 480, 320)];
	
} 





//update the scene based on the current state
- (void)updateScene:(float)deltaTime 
{	
	
	switch ( [self GetState] )
	{
		case PLAY:
			if (!fadecompleted)
			{
				[self UpdateScreenTransition];
			}
			else{
				[MainGame handleInput:input];
				[MainGame update:deltaTime];
			}
			break;
			
			
		

			
		case MENU:
			if (!fadecompleted)
			{
				[self UpdateScreenTransition];
			}
			else{
				[MainMenu handleInput:input];
				[MainMenu update:deltaTime];
			}
			break;	
				
	};
	
	
	//update the input 
    [input update];
	
}











- (void)DrawScene {

	
	switch ( [self GetState] )
	{
			
		case PLAY:
			if (!gameinitialised)
			{
				MainGame = [[MainGameScreen alloc] init:self];
				gameinitialised = YES;
			}
			else
		
			[MainGame draw];
			if (!fadecompleted)
			{
				[self fadeBackBufferToBlack:alpha];
			}
			break;

			
		
		case MENU:
			if (!menuinitialised)
			{
				MainMenu = [[MenuScreen alloc] init:self];
				menuinitialised = YES;
			}
			else

			[MainMenu draw];
			if (!fadecompleted)
			{
				[self fadeBackBufferToBlack:alpha];
			}
			break;
			
		
	};

}


@end
