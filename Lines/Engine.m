//
//  Engine.m
//  Lines
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "Engine.h"
#import "LinesBoard.h"
#import "AnimationManager.h"

static Engine* sharedEngine = nil;

@implementation Engine

{
    BOOL startChosen;
    BOOL usersTurn;
    MyPoint* start;
    MyPoint* dest;
    MyPoint* cellToBeDeleted;
    MyPoint* cellToBeSwapped1;
    MyPoint* cellToBeSwapped2;
}

+(Engine*) sharedEngine
{
    if(!sharedEngine)
    {
        sharedEngine = [[Engine alloc] init];
    }
    return sharedEngine;
}

-(instancetype)init
{
    self = [super init];
    if( self)
    {
        startChosen = NO;
        usersTurn = NO;
        start = [[MyPoint alloc]init];
        dest = [[MyPoint alloc]init];
        _multiCastDelegate = [[MulticastDelegate alloc] init];
        _delegateOfCells = (id)_multiCastDelegate;
        _cellIsBeingDeleted = NO;
        _canDelete = DELETE_BONUS_AMOUNT;
    
    }
    return self;
}

-(void)getInput:(MyPoint *) point
{
    
    
    // the starting point is being chosen, the destination point is not chosen yet
    if (!startChosen)
    {
        // if the starting point is not an empty cell and the user does not want to delete a cell
        if ( [[LinesBoard sharedLinesBoard] cellStateAtPoint:point] && !_cellIsBeingDeleted)
        {
            // set the start
            startChosen = YES;
            start = point;
            // animate the start
            if( [_delegateOfCells respondsToSelector:@selector(cellChosenAnimate:offon:)])
                [_delegateOfCells cellChosenAnimate:start offon:YES ];
            // disable the delete button
            if([_delegateOfViewController respondsToSelector:@selector(disableDeleteButton:)])
                [_delegateOfViewController disableDeleteButton:YES];
        }
        // if the user wants to delete a cell and the chosen cell isnt empty
        else if ([[LinesBoard sharedLinesBoard] cellStateAtPoint:point] && _cellIsBeingDeleted )
        {
            
            cellToBeDeleted = point;
            [[Engine sharedEngine] implementCellBeingDeleted];
            if([_delegateOfViewController respondsToSelector:@selector(turnOffDeleteButtonAnimation)] )
                [_delegateOfViewController turnOffDeleteButtonAnimation];
            _cellIsBeingDeleted = NO;
        }
        
    }
    
    
    // if the starting point is already chosen
    else if (startChosen)
    {
        
            // if the destination point is not empty, new starting point is chosen
            if([[LinesBoard sharedLinesBoard] cellStateAtPoint:point])
            {
                
                // turn of the animation of old start
                if( [_delegateOfCells respondsToSelector:@selector(cellChosenAnimate:offon:)])
                [_delegateOfCells cellChosenAnimate:start offon:NO];
                //change the start
                start = point;
                // put the animation on the new start
                if( [_delegateOfCells respondsToSelector:@selector(cellChosenAnimate:offon:)])
                [_delegateOfCells cellChosenAnimate:start offon:YES];
            
            }
        
        
            // if the destination point is an empty cell
            else
            {
                dest = point;
                NSMutableArray* shortestpath = [[LinesBoard sharedLinesBoard] shortestPathStart:start destination:dest];
                
                
               // if there is no path
                if( !shortestpath)
                {
                    // call the VC to implement the no path animation
                    if([_delegateOfViewController respondsToSelector:@selector(implementPathNotFoundAnimation)])
                        [_delegateOfViewController implementPathNotFoundAnimation];
                    startChosen = NO;
                    // turn off the start chosen animation
                    if([_delegateOfCells respondsToSelector:@selector(cellChosenAnimate:offon:)])
                        [_delegateOfCells cellChosenAnimate:start offon:NO];
                    // enable the delete button
                    if([_delegateOfViewController respondsToSelector:@selector(disableDeleteButton:)])
                        [_delegateOfViewController disableDeleteButton:NO];
                    
                }
                
                
                // if there is a path
                else
                {
                    startChosen = NO;
                    // turn off the start chosen animation
                    if([_delegateOfCells respondsToSelector:@selector(cellChosenAnimate:offon:)])
                    [_delegateOfCells cellChosenAnimate:start offon:NO];
                    
                     //get the color of the start
                    CellState color = [[LinesBoard sharedLinesBoard] cellStateAtPoint:start];
                    for( NSInteger i = shortestpath.count - 1; i >= 0; i--)
                    {
                       if([_delegateOfCells respondsToSelector:@selector(giveImageViewofColor:forCell:)])
                           [_delegateOfCells giveImageViewofColor:color forCell:[shortestpath objectAtIndex:i]];
                    }
                    [self turnButtons:NO];
                    [[AnimationManager sharedAnimator] animateCellMovement:0];
                    // the rest is implemented after the animator calls the
                    // doTheRest functions
                    
                }
            
            }
        }
    
    
    }


-(void)updateTheScore
{
    if([_delegateOfViewController respondsToSelector:@selector(updateTheScoreLabel)])
    {  [_delegateOfViewController updateTheScoreLabel];

    }
}

// sends user activity turn off/on commands to board cells
-(void)turnButtons:(BOOL)onOff
{
    if([_delegateOfCells respondsToSelector:@selector(turnOff:)])
     [_delegateOfCells turnOff:onOff];
    
}


// updates the game stateafter a new game has started
-(void)update
{
    [LinesBoard sharedLinesBoard].numberOfFreeCells = BOARD_SIZE*BOARD_SIZE;
    [self turnButtons:YES];
    [Score sharedScore].score = 0;
    [self updateTheScore];
    [[LinesBoard sharedLinesBoard] newBoard];
    [[LinesBoard sharedLinesBoard] placeNewCells:NO];
    [Engine sharedEngine].canDelete = DELETE_BONUS_AMOUNT;
    if([_delegateOfViewController respondsToSelector:@selector(updateDeleteButtonText)])
        [_delegateOfViewController updateDeleteButtonText];
    if([_delegateOfViewController respondsToSelector:@selector(disableDeleteButton:)])
        [_delegateOfViewController disableDeleteButton:NO];
    if([_delegateOfViewController respondsToSelector:@selector( disableEndGameButton:)])
        [_delegateOfViewController disableEndGameButton:NO];
}

-(void)doTheRest
{
    // enable the delete button
    if([_delegateOfViewController respondsToSelector:@selector(disableDeleteButton:)])
        [_delegateOfViewController disableDeleteButton:NO];
    [self turnButtons:YES];
    // swap the start and dest in the board
    [[LinesBoard sharedLinesBoard] makeAMoveFrom:start to:dest];
    // if there are NO cells destroyed
    if( ![[LinesBoard sharedLinesBoard] blowCells])
    {
        usersTurn = NO;
    }
    // if there are any cells blown, the user plays again
    else
    {
        usersTurn = YES;
    }
    // if it's not the user's turn
    if(!usersTurn)
    {
        //if the nubmer of free cells is less than those to be added, game over
        [[Engine sharedEngine] checkForGameOver];
        // if there are still places to be added, add and blow
        if( [LinesBoard sharedLinesBoard].numberOfFreeCells >= NEW_CELLS)
        {
            [[LinesBoard sharedLinesBoard] placeNewCells:NO];
            [[LinesBoard sharedLinesBoard] blowCells];
        }
        // in case of the board goes empty, add new cells
        if( [LinesBoard sharedLinesBoard].numberOfFreeCells == BOARD_SIZE*BOARD_SIZE)
        {
            [[LinesBoard sharedLinesBoard] placeNewCells:NO];
            [[LinesBoard sharedLinesBoard] blowCells];
        }
        [[Engine sharedEngine] checkForGameOver];
        
    }

}


-(void)checkForGameOver
{
if( [LinesBoard sharedLinesBoard].numberOfFreeCells < NEW_CELLS)
{
    // tuens buttons off
    [self turnButtons:NO];
    // brings up gameoverview
    if([_delegateOfViewController respondsToSelector:@selector(hideMainView)])
        [_delegateOfViewController hideMainView];
    if([_delegateOfViewController respondsToSelector:@selector(disableDeleteButton:)])
        [_delegateOfViewController disableDeleteButton:YES];
    if([_delegateOfViewController respondsToSelector:@selector(disableEndGameButton:)])
        [_delegateOfViewController disableEndGameButton:YES];
    if([_delegateOfViewController respondsToSelector:@selector(turnOffDeleteButtonAnimation)])
        [_delegateOfViewController turnOffDeleteButtonAnimation];
    [Engine sharedEngine].cellIsBeingDeleted = NO;
}
}

-(void)implementCellBeingDeleted
{
    [[LinesBoard sharedLinesBoard] setCellState:EmptyCell forCell:cellToBeDeleted];
    [LinesBoard sharedLinesBoard].numberOfFreeCells++;
    if([LinesBoard sharedLinesBoard].numberOfFreeCells == BOARD_SIZE*BOARD_SIZE)
    [[LinesBoard sharedLinesBoard] placeNewCells:NO];
        [[LinesBoard sharedLinesBoard] blowCells];
    [Engine sharedEngine].canDelete--;
    if([_delegateOfViewController respondsToSelector:@selector(updateDeleteButtonText)])
        [_delegateOfViewController updateDeleteButtonText];
}

@end
