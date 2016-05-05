//
//  AnimationManager.m
//  Lines
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "AnimationManager.h"

static AnimationManager* sharedAnimator = nil;

@implementation AnimationManager

+(AnimationManager*)sharedAnimator
{
    if(!sharedAnimator)
    {
        sharedAnimator = [[AnimationManager alloc]init];
    }
    return sharedAnimator;
}

-(instancetype)init
{
    self = [super init];
    if( self)
    {
        _arrayOfView = [[NSMutableArray alloc]init];
        _chosenCellView = [[UIImageView alloc]init];
        _delegate = (id)[Engine sharedEngine];
    }
    return self;
}

-(void)animateNoPathFound:(UILabel *)pathNotFoundLabel
{
    [UIView animateWithDuration:1.0 animations:^{
        pathNotFoundLabel.alpha = 1.0;
    }completion:^(BOOL finished) {
        if(finished)
            [UIView animateWithDuration:1.0 animations:^{
                pathNotFoundLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                ;
            }];
    }
     ];
}

-(void)animateChosenCellonOff:(BOOL) onoff
{

    if(onoff)
    {
        [UIView animateWithDuration:CHOSEN_CELL_ANIMATION_SPEED delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
            _chosenCellView.alpha = 1 - _chosenCellView.alpha;
        } completion:^(BOOL finished) {
            ;
        }];
    }
    else
    {
        [_chosenCellView.layer removeAllAnimations];
        _chosenCellView.alpha = 1.0;
    }
}

-(void)animateCellStateChangedView:(UIImageView*) view show:(BOOL) show
{

    double newalpha = show  ? 1.0 : 0.0;
    [UIView animateWithDuration:HIDE_APPEAR_TIME animations:^{
        view.alpha = newalpha;
    }];
}
-(void)animateCellMovement:(NSInteger) start; {
    double time = MOVEMENT_TIME;
    if( start < _arrayOfView.count - 1)
    {
        [UIView animateWithDuration:time/2 animations:^{
            ((UIImageView*)[_arrayOfView objectAtIndex:start]).alpha = 1.0;
        } completion:^(BOOL finished) {
            if( finished)
            {
                [UIView animateWithDuration:time/2 animations:^{
                    ((UIImageView*)[_arrayOfView objectAtIndex:start]).alpha = 0.0;
                } completion:^(BOOL finished) {
                    if(finished)
                    {
                        [self animateCellMovement:start+1];
                    }
                }];
            }
        }];
    }
    else
    {
        [_arrayOfView removeAllObjects];
        [[Engine sharedEngine] doTheRest];
    }
}

-(void)animateDeleteButtonPressed:(UIButton *)deleteButton onoff:(BOOL)onoff
{
    if(onoff)
    {
        deleteButton.layer.borderWidth = 5.0f;
    }
    else
        deleteButton.layer.borderWidth = 1.0f;
    
}
@end
