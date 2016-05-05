//
//  NewCellsView.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "NewCellsView.h"

@implementation NewCellsView

// creates the view of the board
-(instancetype)initWithFrame:(CGRect)frame newCells:(NewCells*)newCells
{
    self = [super initWithFrame:frame];
    if( self)
    {
        // get the height/ width of the cell depending on the number of the randomly generated balls defined in config.h
        double rowHeight = frame.size.height;
        double columnWidth = frame.size.width / NEW_CELLS;
        for ( int i = 0; i < NEW_CELLS; i++)
            {
                NewCellsCell* cell = [[NewCellsCell alloc] initWithFrame:CGRectMake(i*columnWidth, 0, columnWidth, rowHeight) column:i newCells:newCells];
                [self addSubview:cell];
            }
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

@end
