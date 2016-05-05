//
//  Engine.h
//  Lines
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Colors.h"
#import "MulticastDelegate.h"
#import "MyPoint.h"
#import "Protocols.h"


// contains the game logic. Works after getting a user input ( click in the board cell).
// connects the model/views/animator with delegates


@interface Engine : NSObject <GameOverDelegate, AnimationManagerDelegate>

+(Engine*) sharedEngine;
// a delegate class that redirects the delegate message to all board cells
@property (readonly) MulticastDelegate* multiCastDelegate;
// informs the ViewController that path was not found
@property (weak) id <EngineDelegate> delegateOfViewController;
// informs the Boardcells to switch on their animation of being chosen
@property (weak) id <EngineDelegate> delegateOfCells;
// informs the gameoverview to show itself
@property (weak) id <EngineDelegate> delegateOfGameOverView;
@property BOOL cellIsBeingDeleted;
@property NSInteger canDelete;
// gets the MyPoint object of coordinates of the tapped Cell on the board
// does all the logic of the game and sends commands to the model/animator and view
-(void)getInput:(MyPoint*) input;
//  informs the viewcontroller to update the score label
-(void)updateTheScore;
// sends commands to all cells to turn user interaction on ro off
-(void)turnButtons:(BOOL) onOff;
// does the rest of the logic algorithm after the animator is done animating the path, called by shared animator
-(void)doTheRest;
// checks for a game over condition
-(void)checkForGameOver;
// check if the user wants to delete a cell
-(void)implementCellBeingDeleted;

@end
