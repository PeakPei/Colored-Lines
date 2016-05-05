//
//  NewCellsView.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCellsCell.h"
#import "Config.h"

@class NewCells;
// a view that displays the NewCells

@interface NewCellsView : UIView

-(instancetype)initWithFrame:(CGRect)frame newCells:(NewCells*) newCells;

@end
