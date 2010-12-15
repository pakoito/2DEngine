
#import "Animations.h"

@implementation Animations


@synthesize frame;
@synthesize step;
@synthesize animations;
@synthesize delay;



- (id) init  
{  
    self = [super init];  
	delay = 0;
    return self;  
}



// release resources when they are no longer needed.
- (void)dealloc
{	
	[super dealloc];
}


//this is the "core" of this class, we load each animation per separately
//we have the same animations as states, so if the player/enemy/whatever has 3 states
//we normally load 3 animations, one per state
//basically we work with numbers, we dont store any image, only the state and the number frames needed for that
//state
///load our animation based in states and number of frames
-(void) LoadAnimation:(state)states  frames_number:(const char*)frames_number
{
	//I'm a C programmer, so this is C stuff
	//this buffer its the max animation global
	//this means, the total animations in ALL your game
	//for example, 5 frames for player, 10 frames for enemy
	//and 10 frames more for the big boss enemy, so in total we have
	//25 frames max, got it? this is defined in defines.h
	char buffer[MAX_FRAME_ANIMATION];
	char * next;
	int i = 0; //to store each animation number 
	
	strcpy (buffer, frames_number);
	
	next = (char *) strtok (buffer, " ,"); //we dont want "," symbol, so we cut it out
	
	while (next) //while we have something in the string
	{
		animations.anim[states][i] = atoi (next);
		next = (char *) strtok (NULL, " ,");
		i++;
	}
	
	//add each frame number to the array
	animations.anim[states][i] = END_ANIMATION;
}





//increase our frame animation, setting the delay we want
-(int) NextAnimationFrame:(int) delayvalue
{
	if (delay < 0) //if delay < 0, change to next frame and reset delay counter
	{
		step ++;
		frame = animations.anim [status][step];
		
        delay = delayvalue; //reset delay counter to value asigned
		
		if (frame == END_ANIMATION)
		{
			step = 0;
			frame = animations.anim [status][0];
			return 1;
		}
	}
	else delay --;
	
	
	return 0;
}



//select the frame we want to show
-(void) SelectFrame:(int) frames
{
	step = frames;
	frame = animations.anim [status][step];
}



//return our actual frame in an animation
-(int) GetActualFrame
{
	return frame;
}



//return our state to know in wich state we are
-(int) GetState
{
	return status;
}




/////////////////////
////////////////////
/// STATES
///////////////////
//////////////////


//change our animation state
-(void) ChangeStates:(state) Status
{
	status = Status;
	//frame = animations.anim [status][0];
}



//change our state and reset the animation to its first frame
-(void) ChangeStatesAndResetAnim:(state) State
{
	status = State;
	step = 0;
	frame = animations.anim [status][0];
}



//refresh the animation to know what frame we need to draw
-(void) RefreshStates
{
	switch (status)
	{
        case MOVERIGHT:
        case MOVEUP:
        case MOVEDOWN:
            [self StateWalking];
            break;
		case STOPPED:
            [self StateStopped];
            break;
			
		case CREATING:
			[self StateCreating];
			break;
			
		default:
			break;
	}
}





//set our animation speed
//higher values means slow animations
-(void) StateWalking
{
	[self NextAnimationFrame:4];
}


//set our animation speed
-(void) StateStopped
{
	[self NextAnimationFrame:3];
}


//set our animation speed
-(void) StateCreating
{
	if ([self NextAnimationFrame: 7])
		[self ChangeStatesAndResetAnim:STOPPED];
}


@end

