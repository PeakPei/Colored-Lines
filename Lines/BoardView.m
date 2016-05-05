//
//  BoardView.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

// creates the view of the board
-(instancetype)initWithFrame:(CGRect)frame board:(LinesBoard *)board
{
    self = [super initWithFrame:frame];
    if( self)
    {
        // get the height/ width of the cell depending on the sizes of the entire grid defined in config.h
        double rowHeight = frame.size.height / BOARD_SIZE;
        double columnWidth = frame.size.width / BOARD_SIZE;
        for ( int i = 0; i < BOARD_SIZE; i++)
            for ( int j = 0; j < BOARD_SIZE; j++)
            {
                BoardCell* cell = [[BoardCell alloc] initWithFrame:CGRectMake(j*columnWidth, i*rowHeight, columnWidth, rowHeight) cell:[[MyPoint alloc] initWithRow:i Column:j] board:board];
                [self addSubview:cell];
            }
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}


@end
