//
//  BoardView.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardCell.h"
#import "Config.h"
#import "MyPoint.h"

@class LinesBoard;
// a view of the entire board that contains as its subviews of type BoardCell
@interface BoardView : UIView

-(instancetype)initWithFrame:(CGRect)frame board:(LinesBoard*) board;

@end
