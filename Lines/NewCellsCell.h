//
//  NewCellsCell.h
//  Lines
//
//  Created by Admin on 26.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Protocols.h"

@class NewCells;
@interface NewCellsCell : UIView <NewCellsDelegate>

-(instancetype)initWithFrame:(CGRect )frame column:(NSInteger) column newCells:(NewCells*) newnewCells;

@end
