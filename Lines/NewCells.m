//
//  NewCells.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "NewCells.h"

static NewCells *_sharedNewCells = nil;

@implementation NewCells

{
    NSUInteger randomCells[NEW_CELLS];
    // informs its cells to change the color
    id <NewCellsDelegate> delegateOfStateChanged;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self updateCellsWithInitializing:YES];
        _multiCastDelegate = [[MulticastDelegate alloc] init];
        delegateOfStateChanged = (id)_multiCastDelegate;
    }
    return self;
}

+(NewCells*)sharedNewCells
{
    if (!_sharedNewCells)
    {
        _sharedNewCells = [[NewCells alloc] init];
    }
    return _sharedNewCells;
    
}


-(void) updateCellsWithInitializing:(BOOL)initializing
{
    for ( int i = 0; i < NEW_CELLS; i++)
    {
    if(!initializing)
      [[NewCells sharedNewCells] setCellStateAt:i state:arc4random_uniform(COLOR_NUM) + 1];
    else
        randomCells[i] =arc4random_uniform(COLOR_NUM) + 1;
    }
}

-(CellState)getCellState:(NSInteger) place
{
    return randomCells[place];
}

-(void)setCellStateAt:(NSInteger) position state:(CellState) cellState
{
    randomCells[position] = cellState;
    [self informDelegateOfStateChanged:cellState column:position];
}

-(void)informDelegateOfStateChanged:(CellState)state column:(NSInteger)column
{
    if ([delegateOfStateChanged respondsToSelector:@selector(cellStateChangedTo:column:)]) {
        [delegateOfStateChanged cellStateChangedTo:state column:column];
    }
}
@end
