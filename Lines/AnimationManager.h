//
//  AnimationManager.h
//  Lines
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationManager.h"
#import "ViewController.h"
#import "Protocols.h"
#import <QuartzCore/QuartzCore.h>
@class BoardCell;

@interface AnimationManager : UIView

+(AnimationManager*) sharedAnimator;
@property NSMutableArray* arrayOfView;
@property UIImageView* chosenCellView;
@property (weak) id <AnimationManagerDelegate> delegate;
-(void)animateNoPathFound:(UILabel*) pathNotFoundLabel;
-(void)animateCellMovement:(NSInteger) begin;
-(void)animateCellStateChangedView:(UIImageView*) view show:(BOOL) show;
-(void)animateChosenCellonOff:(BOOL) onoff;
-(void)animateDeleteButtonPressed:(UIButton*) delteButton onoff:(BOOL)onoff;
@end
