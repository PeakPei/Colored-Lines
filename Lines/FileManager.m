//
//  FileManager.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "FileManager.h"

static FileManager* sharedManager = nil;

@implementation FileManager

{
    NSFileManager* manager;
    NSString* filePath;
}

+(FileManager*)sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[FileManager alloc]init];
    }
    return sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if ( self)
    {
        manager =  [[NSFileManager alloc]init];
        filePath = [[self documentsDirectory] stringByAppendingString:@"save"];
    }
    return self;
}

-(NSString*)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject]; // Get documents folder
    
    return documentsDirectory;
}

-(void)save
{
    
    if (![manager fileExistsAtPath:filePath]) {
        [manager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    // iterates through the 2d array od the shared board and saves the integers
    NSMutableString* str = [[NSMutableString alloc]init];
    for ( int i = 0; i < BOARD_SIZE; i++)
        for( int j = 0; j < BOARD_SIZE; j++)
            [str appendFormat:@"%lu ", [[LinesBoard sharedLinesBoard] cellStateAtPoint:[[MyPoint alloc] initWithRow:i Column:j]]];
    // saving the NewCells info
    for( int i = 0; i < NEW_CELLS; i++)
        [str appendFormat:@"%lu ", [[NewCells sharedNewCells] getCellState:i]];
    // saving the score
    [str appendFormat:@"%lu ", [Score sharedScore].score];
    [str writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
}

-(void)load
{
    if ([manager fileExistsAtPath:filePath]) {
        NSString* str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        // keeping the track of where we are in the loaded file
        int loadArrayPosition = 0;
        // loading the board info
        for ( int i = 0 ;i < BOARD_SIZE; i++)
            for ( int j = 0; j < BOARD_SIZE; j++)
            {
                NSString* cellState = [str componentsSeparatedByString:@" "][ i * BOARD_SIZE + j];
                [[LinesBoard sharedLinesBoard] setCellState:[cellState intValue] forCell:[[MyPoint alloc] initWithRow:i Column:j]];
            }
        loadArrayPosition += BOARD_SIZE*BOARD_SIZE;
        // loading the newcells info
        for ( int i = 0; i < NEW_CELLS; i++)
        {
            NSString* newCellsState = [str componentsSeparatedByString:@" "][loadArrayPosition];
            [[NewCells sharedNewCells] setCellStateAt:i state:[newCellsState intValue]];
            loadArrayPosition++;
        }
        // loading the score info
        NSString* score = [str componentsSeparatedByString:@ " "][loadArrayPosition];
        [Score sharedScore].score = [score intValue];
        [[Engine sharedEngine] updateTheScore];
    }
    
}

@end
