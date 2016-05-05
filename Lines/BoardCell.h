//
//  BoardCell.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LinesBoard.h"
#import "NewCells.h"
#import "Protocols.h"
#import "AnimationManager.h"
@class LinesBoard;
// each cell is a subclass of UIView. The cell recognizes the board it belongs to, as well as its row and column on the board
// the class conforms to the protocol LinesBoardDelegate to be informed about the cell state changes in the LinesBoard
@interface BoardCell : UIView <LinesBoardDelegate, EngineDelegate>

// constructor of cells for the board
-(instancetype)initWithFrame:(CGRect)frame cell:(MyPoint*) cell board:(LinesBoard*)board ;

@end
