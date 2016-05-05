//
//  ShortestPath.h
//  Lines
//
//  Created by Admin on 29.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPoint.h"
#import "Config.h"
#import "Colors.h"
// Implements Dijkstra's shortest path algorithm
@interface ShortestPath : NSObject

+(NSMutableArray*) shortestPath:(NSUInteger[BOARD_SIZE][BOARD_SIZE])graph source:(MyPoint*) source destination:(MyPoint*)dest;

@end
