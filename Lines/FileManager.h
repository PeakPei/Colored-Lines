//
//  FileManager.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinesBoard.h"
#import "Config.h"
#import "Score.h"
#import "NewCells.h"

// a shared FileManager to save the state of the Board, the 2D int array of CellState-s
@interface FileManager : NSObject

+(FileManager*) sharedManager;
-(void)save;
-(void)load;

@end
