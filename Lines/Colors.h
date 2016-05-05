//
//  Colors.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

// enumaration of cell states corresponding to the colors in the Colors shared object
// in case of adding a color that is inittialy not in the shared object
// typedef has to be editted by adding the new color in  the enumaration
typedef NS_ENUM(NSUInteger, CellState) {
    EmptyCell,
    RedCell,
    GreenCell,
    BlueCell,
    PurpleCell,
    YellowCell,
    DarkgreenCell,
    GreyCell,
    OrangeCell,
    VioletCell,
    PinkCell
};
// a shared object colors, which contains the colors as strings
// new colors can be added
// typdef enum describes the state of the cell as a color or an empty cell
@interface Colors : NSObject
+(Colors*)sharedColors;
-(NSString*)getColorNumber:(NSInteger) number;
-(void)addAColor:(NSString*) color;
@end
