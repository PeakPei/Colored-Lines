//
//  Score.m
//  Lines
//
//  Created by Admin on 26.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "Score.h"

static Score* sharedScore = nil;

@implementation Score


+(Score*)sharedScore
{
    if(!sharedScore)
    {
        sharedScore = [[Score alloc]init];
    }
    return sharedScore;
}


@end
