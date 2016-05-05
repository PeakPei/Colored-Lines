//
//  LinesBoard.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "LinesBoard.h"
#import "ShortestPath.h"


static LinesBoard* sharedLinesBoard = nil;

@implementation LinesBoard

{
    NSUInteger myBoard[BOARD_SIZE][BOARD_SIZE];
    id <LinesBoardDelegate> delegateOfStateChanged;
    
}
+(LinesBoard*) sharedLinesBoard
{
    if (!sharedLinesBoard)
    {
        sharedLinesBoard= [[LinesBoard alloc] init];
    }
    return sharedLinesBoard;
    
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _numberOfFreeCells = BOARD_SIZE*BOARD_SIZE;
        [self newBoard];  // clears the board as the board is initialized
        [self placeNewCells: YES]; // places the first cells
        _multiCastDelegate = [[MulticastDelegate alloc] init];
        delegateOfStateChanged = (id)_multiCastDelegate;
        
    }
    return self;
}

-(CellState) cellStateAtPoint:(MyPoint*) cell;
{
    return myBoard[cell.row][cell.column];
    
}

-(void) setCellState: (CellState) state forCell:(MyPoint*) cell;
{
    myBoard[cell.row][cell.column] = state;
    // as the state is changed, the delegate is informed about the change
    [self informDelegateOfStateChanged:state forCell:cell];
    
}

-(void)newBoard
{
    for( int i = 0; i < BOARD_SIZE; i++)
        for(int j = 0; j < BOARD_SIZE; j++)
            [self setCellState:EmptyCell forCell:[[MyPoint alloc] initWithRow:i Column:j]];
}

-(void)placeNewCells:(BOOL)initializing
{
    // creates an array of the free cells in the board
    NSMutableArray *freeCells = [[NSMutableArray alloc] init];
    for ( int i = 0; i < BOARD_SIZE; i++)
        for( int j = 0; j < BOARD_SIZE; j++)
            if ( myBoard[i][j] == EmptyCell)
            {
                // inputs the cells as objects of type MyPoint
                [freeCells addObject: [[MyPoint alloc]initWithRow:i Column:j]];
            }
    for ( int i = 0; i < NEW_CELLS; i++)
    {
        // a random number is generated out of the number of free cells
        int rand = arc4random_uniform((u_int32_t)freeCells.count);
        // the row and the column of the randomly chosen free cell are taken
        NSInteger row = ((MyPoint*)[freeCells objectAtIndex: rand]).row;
        NSInteger col = ((MyPoint*)[freeCells objectAtIndex: rand]).column;
        // the board cell with the coordinates row, column is set to the statei of the shared newCells
        CellState state =[[NewCells sharedNewCells] getCellState:i];
        if( initializing)
            myBoard[row][col] = state;
        else
            [[LinesBoard sharedLinesBoard] setCellState: state forCell:[[MyPoint alloc] initWithRow:row Column:col]];
        // the already not free cell is then removed from the array of free cells
        [freeCells removeObjectAtIndex: rand];
    }
    _numberOfFreeCells -= NEW_CELLS;
    [[NewCells sharedNewCells] updateCellsWithInitializing:NO]; //as the new cells are placed, the next new cells are generated
    
}

-(NSMutableArray*) shortestPathStart:(MyPoint *)start destination:(MyPoint *)destination
{

    return [ShortestPath shortestPath:myBoard source:start destination:destination];
}

-(void)addToScore:(NSInteger)numOfCells
{
    [Score sharedScore].score += NUM_COMBO;
    numOfCells -= NUM_COMBO;
    int mult = 2;
    while (numOfCells > 0) {
        [Score sharedScore].score += MIN(NUM_COMBO/2, numOfCells)*mult;
        mult++;
        numOfCells -= MIN(NUM_COMBO/2, numOfCells);
    }
    
}

-(void)makeAMoveFrom:(MyPoint *)start to:(MyPoint *)destination
{
    [[LinesBoard sharedLinesBoard] setCellState:myBoard[start.row][start.column] forCell:destination];
    [[LinesBoard sharedLinesBoard] setCellState:EmptyCell forCell:start];
//as the name suggests, the method informs the delegate  about a change in the state in the given cell
}

-(void)informDelegateOfStateChanged:(CellState)state forCell:(MyPoint*) cell
{
    if ([delegateOfStateChanged respondsToSelector:@selector(cellStateChangedforCell:)])
    
        [delegateOfStateChanged cellStateChangedforCell:cell];
    
    
}

// changes the states of the cells, adds to the score and at the end, tells the view controller to update the score label
// traverses the matrix in 4 directions, the algorithm is very effective, linear,
// each horizontal/vertical/diagonal line is traversed exactly once
-(BOOL) blowCells
{
    NSMutableArray* stack = [[NSMutableArray alloc]init];
    NSMutableSet* set = [[NSMutableSet alloc] init];
    // direction 1 = horizontal, 0 = vertical
    //
    for ( int direction = 1; direction >= 0; direction--)
    {
        for( int row = 0; row < BOARD_SIZE; row++)
        {
            
            NSInteger currentState = -1;
            int capacity = 0;
            
            for( int col = 0; col < BOARD_SIZE; col++)
            {
                if( currentState == -1 && myBoard[direction ? row:col][direction ? col:row ] > EmptyCell )
                {
                    currentState = myBoard[direction ? row:col][direction ? col:row ];
                    [stack addObject: [[MyPoint alloc] initWithRow:direction ? row:col Column:direction ? col:row]];
                    capacity++;
                }
                else if( currentState == -1 && myBoard[direction ? row:col][direction ? col:row ] == EmptyCell)
                {
                    
                }
                else if( currentState == myBoard[direction ? row:col][direction ? col:row ] )
                {
                    [stack addObject: [[MyPoint alloc] initWithRow:direction ? row:col Column:direction ? col:row]];
                    capacity++;
                    if( capacity >= NUM_COMBO && (( direction == 1 && col == BOARD_SIZE - 1) || ( direction == 0 && col == BOARD_SIZE - 1)))
                    {
                        for( int i = 0; i < stack.count; i++)
                            [set addObject:[stack objectAtIndex:i]];
                        [self addToScore: stack.count];
                        
                        [stack removeAllObjects];
                        capacity = 0;
                    }
                }
                else if( myBoard[direction ? row:col][direction ? col:row] != currentState && capacity < NUM_COMBO)
                {
                    [stack removeAllObjects];
                    capacity = 0;
                    if( myBoard[direction ? row:col][direction ? col:row ] == EmptyCell )
                        currentState = -1;
                    else
                    {
                        currentState = myBoard[direction ? row:col][direction ? col:row];
                        [stack addObject: [[MyPoint alloc] initWithRow:direction ? row:col Column:direction ? col:row]];
                        capacity++;
                    }
                }
                else if ( myBoard[direction ? row:col][direction ? col:row] != currentState && capacity >= NUM_COMBO)
                {
                    for( int i = 0; i < stack.count; i++)
                        [set addObject:[stack objectAtIndex:i]];
                    [self addToScore: stack.count];
                    
                    [stack removeAllObjects];
                    capacity = 0;
                }
                
            }
            // empty the stack for the vertical movement
            [stack removeAllObjects];
        }
        
    }
    // topleft to bottom right and topright to bottom left diagonal checks
    // direction = 0 - top left to bottom right
    // direction = 1 - top right to bottom left
    for ( int direction = 1; direction >= 0; direction--)
    {
        //row, col - row
        //row, N-1 - (col - row)
        for( int col = 0; col < BOARD_SIZE*2 - 1; col++)
        {
            int z = col < BOARD_SIZE ? 0 : col - BOARD_SIZE + 1;
            NSInteger currentState = -1;
            int capacity = 0;
            for( int row = z; row <= col - z; row++)
            {

                if( currentState == -1 && myBoard[row][direction ? col - row: BOARD_SIZE - 1 - (col - row) ] > EmptyCell )
                {
                    currentState = myBoard[row][direction ?  col - row: BOARD_SIZE - 1 - (col - row) ];
                    [stack addObject: [[MyPoint alloc] initWithRow: row Column:direction ?  col - row: BOARD_SIZE - 1 - (col - row) ]];
                    capacity++;
                }
                else if( currentState == -1 && myBoard[row][direction ? col - row: BOARD_SIZE - 1 - (col - row) ] == EmptyCell)
                {
                    
                }
               else  if( currentState == myBoard[row][direction ? col - row: BOARD_SIZE - 1 - (col - row) ] )
                {
                    [stack addObject: [[MyPoint alloc] initWithRow:row Column:direction ?  col - row: BOARD_SIZE - 1 - (col - row) ]];
                    capacity++;
                    if( capacity >= NUM_COMBO && ( ((direction == 1 && col - row == 0) || ( direction == 1 && row == BOARD_SIZE - 1)) || ((direction == 0 && row == BOARD_SIZE - 1) || ( direction == 0 && BOARD_SIZE - 1 - (col - row) == BOARD_SIZE - 1))) )
                    {
                        for( int i = 0; i < stack.count; i++)
                            [set addObject:[stack objectAtIndex:i]];
                        [self addToScore: stack.count];
                        [stack removeAllObjects];
                        capacity = 0;
                    }
                }
               else if( myBoard[row][direction ?  col - row: BOARD_SIZE - 1 - (col - row) ] != currentState && capacity < NUM_COMBO)
                {
                    [stack removeAllObjects];
                    capacity = 0;
                    if( myBoard[row][direction ?  col - row: BOARD_SIZE - 1 - (col - row)  ] == EmptyCell )
                        currentState = -1;
                    else
                    {
                        currentState = myBoard[row][direction ?  col - row: BOARD_SIZE - 1 - (col - row) ];
                        [stack addObject: [[MyPoint alloc] initWithRow:row Column:direction ?  col - row: BOARD_SIZE - 1 - (col - row) ]];
                        capacity++;
                    }
                }
               else if ( myBoard[row][direction ?  col - row: BOARD_SIZE - 1 - (col - row)] != currentState && capacity >= NUM_COMBO)
               {
                   for( int i = 0; i < stack.count; i++)
                       [set addObject:[stack objectAtIndex:i]];
                   [self addToScore: stack.count];
                   
                   [stack removeAllObjects];
                   capacity = 0;
               }
                
            }
            // empty the stack for the vertical movement
            [stack removeAllObjects];
        }
        
    }
    for( int i = 0; i < set.count; i++){
        [[LinesBoard sharedLinesBoard] setCellState:EmptyCell forCell: ((MyPoint*)[[set allObjects] objectAtIndex:i])];
    }
    _numberOfFreeCells += set.count;
    [[Engine sharedEngine].delegateOfViewController updateTheScoreLabel];
    if( set.count > 0)
        return YES;
    return NO;
}
@end
