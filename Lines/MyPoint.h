//
//  Point.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
// a class to use (row, column) points as objects
@interface MyPoint : NSObject

@property NSInteger column;
@property NSInteger row;

-(instancetype)initWithRow:(NSInteger)x Column:(NSInteger) y;
@end
