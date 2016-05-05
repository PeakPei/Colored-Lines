//
//  GameOverViewController.h
//  Lines
//
//  Created by Admin on 30.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Engine.h"
#import "Protocols.h"


@interface GameOverViewController : UIView

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak) id <GameOverDelegate> delegateOfEngine;

@end
