//
//  LinesBoard.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Colors.h"
#import "NewCells.h"
#import "MyPoint.h"
#import "MulticastDelegate.h"
#import "Engine.h"
#import "Score.h"
#import "Protocols.h"

// the mathematical model of the board

@interface LinesBoard : NSObject

+(LinesBoard*)sharedLinesBoard;
// returns the state of the cell
@property (readonly) MulticastDelegate* multiCastDelegate;
// returns the state of the cell
@property NSInteger numberOfFreeCells;
// gets the cell state
-(CellState) cellStateAtPoint:(MyPoint*) cell;
// sets the state of the cell
-(void) setCellState: (CellState) state forCell:(MyPoint*) cell;
// places new cells on the board, depending on whether the function is called
// when the board is first initialized or during the game, the behavior is different
-(void)placeNewCells:(BOOL) intializing;
// as the board is initialized, all the states are set to empty and random cells are added
-(void) newBoard;
// returns the shortest path between the two points as an NSMutableArray of MyPoint objects
// in case the points are not connected, returns nil
-(NSMutableArray*) shortestPathStart:(MyPoint*) start destination:(MyPoint*) destination;
// finds the matches on the matrix and blows the cells, updates the score
// returns true if any cells have been destroyed, false otherwise
-(BOOL)blowCells;
// changes the states of two cells
-(void)makeAMoveFrom:(MyPoint*)start to:(MyPoint*) destination;
// informs the boardcells about the state change
-(void)informDelegateOfStateChanged:(CellState)state forCell:(MyPoint*) cell;
@end
