//
//  
//  
//
//  Created by Eskema on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//main classes
#import "StateManager.h"


@class Fonts;
@class SoundManager;
@class LenguageManager;
@class Camera;
@class BaseActor;
@class ParticleEmitter;



@interface MainGameScreen : NSObject 
{
	
	LenguageManager *MainGameText;
	//sound
	SoundManager *sharedSoundManager;
	
	//game sprites
	Image *SpriteGame;
	
	
	//game states
	StateManager *gameState;
	
	//buttons
	CGRect exitgamebutton;
	CGRect pausebutton;
	CGRect saveexitbutton;
	CGRect touchInventory;
	CGRect touchContinue;
	
	//fonts
	Fonts *font1;

	Camera *tileCamera;
	BaseActor *Mainplayer;
	ParticleEmitter *particles;

	
	bool touched;
	bool pausedgame;
	bool exitScreen;

	
	
	//pad
	CGRect padUp;
	CGRect padDown;
	CGRect padLeft;
	CGRect padRight;
	
}

















//////////////////
///
///	FUNCTIONS GENERALS
///
//////////////////
- (id) init:(StateManager *)States_; 
- (void) loadContent;
- (void) unloadContent;
- (void) handleInput:(InputManager *)inputGame;
- (void) update:(float)deltaTime;
- (void) draw;




//////////////////
///
///	FUNCTIONS IN GAME
///
//////////////////
-(void) InitGame;
-(void) DrawLevelGame;
-(void) ExitGame;






@end
