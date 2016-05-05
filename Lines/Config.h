//
//  Config.h
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//
// last
#ifndef Lines_Config_h
#define Lines_Config_h
#define BOARD_SIZE 15
#define COLOR_NUM 10 // if set more than 10, add a new image asset, add the name
                     // to the Colors singleton, and add to the typedef in Colors.h
#define NEW_CELLS 10 // if set to more than 10, HEIGHT_OF_NEW_CELLS should also be
                    // do not set to more than BOARD_SIZE*BOARD_SIZE
#define HEIGHT_OF_NEW_CELLS 35
#define MOVEMENT_TIME 0.15 // the time take takes a cell to move to one cell
#define HIDE_APPEAR_TIME 0.5 // the time to blow/show cells
#define NUM_COMBO 5 // the number of cells in a row to be deleted
#define CHOSEN_CELL_ANIMATION_SPEED 0.2 // the speed at which the chosen cel animates
#define DELETE_BONUS_AMOUNT 10 
#define BLUE_BACK @"BlueBackground"
#define PLUM_BACK @"PlumBackground"
#define LIGHTGRAY_BACK @"LightgrayBackground"
#define DARKGRAY_BACK @"DarkgrayBackground"
#define YELLOW_BACK @"YellowBackground"
#define MAIN_BACK @"MainBackground"
#endif
