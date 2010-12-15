////////////////////////////////////////////////////////////
//
// Animations.h
// this class controls all the animations added to any sprite
//
/////////////////////////////////////////////////////////////

//this class needs to be some refactoring code
//instead of this classic animation system is better to improve it
//to allow more types of animation, usually saving the frame rects position
//to use it later to conform animations


#import "defines.h"

#import <Foundation/Foundation.h>  
#include <stdio.h>


//we work with states, so each animation has its own state
//this way we can change from one state to another, and keep 
//track of actual state
//of course you need to create your states, to fit your game needs
typedef enum {
    MOVERIGHT,
	MOVEUP,
	MOVEDOWN,
    STOPPED,
    ATTACK,
	DEAD,
	DYING,
	CREATING,
	_STATES
}state;


//prepare a struct to hold the animation frames
//this is faster than create a class
struct main_animation {
	int anim[_STATES][MAX_FRAME_ANIMATION];
};
typedef struct main_animation Struct_Animation;




//now our class
@interface Animations : NSObject  
{  
    int frame; //actual frame to draw
    int step; //counter to increase frame
    state status; //the states
	Struct_Animation animations; //struct to hold the animations
    int delay; //establish time between frames 
}  




@property (nonatomic, readwrite) int frame;  
@property (nonatomic, readwrite) int step;
@property (nonatomic, readwrite) Struct_Animation animations;
@property (nonatomic, readwrite) int delay;



-(void) LoadAnimation:(state)states  frames_number:(const char*)frames_number;
-(int) NextAnimationFrame:(int) delayvalue;
-(void) SelectFrame:(int) frames;
-(int) GetActualFrame;
-(int) GetState;

//States
-(void) ChangeStates:(state) Status;
-(void) ChangeStatesAndResetAnim:(state) State;
-(void) RefreshStates;
-(void) StateWalking;
-(void) StateStopped;
-(void) StateCreating;





@end  


