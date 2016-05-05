//
//  Point.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

-(instancetype)initWithRow:(NSInteger)x Column:(NSInteger) y
{
    self = [super init];
    if(self)
    {
        _column = y;
        _row = x;
    }
    return self;
}

@end
