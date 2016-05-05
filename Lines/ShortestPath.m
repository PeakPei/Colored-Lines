//
//  ShortestPath.m
//  Lines
//
//  Created by Admin on 29.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "ShortestPath.h"

@implementation ShortestPath

int* getNeightbors(NSUInteger graph[BOARD_SIZE][BOARD_SIZE], int row, int col)
{
    static int result[4];
    // check if has a left neighbor and if it is empty
    if( col - 1 > -1 && graph[row][col-1] == 0)
        result[0] = row* BOARD_SIZE + col - 1;
    else
        result[0] = -1;
    // same for the top neighbor
    if( row - 1  > -1 && graph[row - 1][col] == 0)
        result[1] = (row - 1)*BOARD_SIZE + col;
    else
        result[1] = -1;
    // right neighbor
    if( col + 1 < BOARD_SIZE && graph[row][col + 1] == 0)
        result[2] = row * BOARD_SIZE + col + 1;
    else
        result[2] = -1;
    // bottom neighbor
    if( row + 1 < BOARD_SIZE && graph[row + 1][col] == 0)
        result[3] = (row + 1) * BOARD_SIZE + col;
    else
        result[3] = -1;
    return result;
}

 BOOL setIsEmpty(int set[BOARD_SIZE*BOARD_SIZE])
{
    for( int i = 0; i < BOARD_SIZE*BOARD_SIZE; i++)
        if( set[i] == 1 )
            return NO;
    return YES;
}

int minDist(int set[BOARD_SIZE*BOARD_SIZE],int dist[BOARD_SIZE*BOARD_SIZE])
{
    int min = 1000;
    int min_index = 0 ;
    for ( int i = 0; i < BOARD_SIZE*BOARD_SIZE; i++)
    {
        if(set[i] == 1 && dist[i] <= min)
        {
            min_index = i;
            min = dist[i];

        }
        
    }

    return min_index;
    
}

+(NSMutableArray*) shortestPath:(NSUInteger[BOARD_SIZE][BOARD_SIZE])graph source:(MyPoint*) source destination:(MyPoint*)destination;
{
    NSMutableArray* shortestpath = [[NSMutableArray alloc] init];
    // the "infinity" distance from nodes, used in the dijkstra algorithm
    int MAX = 1000;
    // the total number of cells on the board, the cells that are not in EmptyState are omitted in the algorithm
    int nodes = BOARD_SIZE*BOARD_SIZE;
    // the array of distances from the source
    int dist[nodes];
    // the array that will store the path
    int path[nodes];
    CellState temp = graph[source.row][source.column];
    graph[source.row][source.column] = EmptyCell;
    // the coordinate of the source cell in 1D
    int src = (int)(source.row) * BOARD_SIZE + (int)(source.column);
    // the coordinate of the destination cell in 1D
    int dest = (int)(destination.row) *BOARD_SIZE + (int)(destination.column);
    // contains the nodes that have not been yet visited, once a node is visited, it is removed from the set
    // if 1 - contains the node, 0 does not contain, -1 node is not used
    int set[nodes];
    
    // initialization of the set of unvisited cells and array of distances
    for( int i = 0; i < nodes; i++)
    {
        // if set to -1, the node is not in EmptyState and thus will not be used
        dist[i] = MAX;
        set[i] = -1;
        // if the cell is in EmptyState
        if( graph[i / BOARD_SIZE][i % BOARD_SIZE] == EmptyCell)
        {
            // add the cell in the set of unvisited cells
            set[i] = 1;
            path[i] = -1;
        }

    }
    // the distance from source to source is 0
    dist[src] = 0;

    // do the operation while the set is not empty
    while( !setIsEmpty(set) )
    {
        // get the node that is in the set of unvisited with the minimal distance
        int u = minDist(set, dist);
        // if u is the destination point, terminate the algorithm;
        if ( u == dest)
            break;
        
        // remove the node from the set
        set[u] = 0;
        // get the neighbors of u
        int* neighbors = getNeightbors(graph, u / BOARD_SIZE, u % BOARD_SIZE);

        // iterate for all neighbors of u
        for ( int i = 0; i < 4; i++)
        {
            if ( neighbors[i] != -1)
            {
                int v = neighbors[i];
                // the alternative distance to v
                int altDist = dist[u] + 1;
                // if the new distance is less than the previous one, update the distance, add the noe to the path
                if( altDist < dist[v])
                {
                    dist[v] = altDist;
                    path[v] = u;
                }
            }
            
        }
    }
    graph[source.row][source.column] = temp;
    if( dist[dest] == MAX)
    {
        return nil;
    }
    else
    {
        while( path[dest] != -1)
        {
            [shortestpath addObject:[[MyPoint alloc]initWithRow:dest / BOARD_SIZE Column:dest % BOARD_SIZE ]];
            dest = path[dest];
        
        }
    }
    [shortestpath addObject:[[MyPoint alloc] initWithRow:src / BOARD_SIZE Column:src % BOARD_SIZE]];
    

    return shortestpath;
    }

@end

