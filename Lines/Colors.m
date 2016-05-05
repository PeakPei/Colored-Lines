//
//  Colors.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "Colors.h"

static Colors* sharedColors = nil;

@implementation Colors

{
    NSMutableArray* colors;
}

+(Colors*) sharedColors
{
    if(!sharedColors)
    {
        sharedColors = [[Colors alloc] init];
    }
    return sharedColors;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        colors = [[NSMutableArray alloc] init];
        [colors addObject:@"EmptyCell"];
        [colors addObject:@"RedCell"];
        [colors addObject:@"GreenCell"];
        [colors addObject:@"BlueCell"];
        [colors addObject:@"PurpleCell"];
        [colors addObject:@"YellowCell"];
        [colors addObject:@"DarkgreenCell"];
        [colors addObject:@"GreyCell"];
        [colors addObject:@"OrangeCell"];
        [colors addObject:@"VioletCell"];
        [colors addObject:@"PinkCell"];
    }
    return self;
}

-(void)addAColor:(NSString *)color
{
    BOOL colorExists = NO;
    for ( int i = 0; i < colors.count; i++)
        if([color isEqualToString:[colors objectAtIndex:i]])
            colorExists = YES;
    if(!colorExists)
        [colors addObject:color];
}

-(NSString*)getColorNumber:(NSInteger)number
{
    return [colors objectAtIndex:number];
}

@end
