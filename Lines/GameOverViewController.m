//
//  GameOverViewController.m
//  Lines
//
//  Created by Admin on 30.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "GameOverViewController.h"
#import "AppDelegate.h"

@interface GameOverViewController()

@end

@implementation GameOverViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.hidden = YES;
        self.layer.borderWidth = 3.0F;
        self.layer.opaque = YES;
        _delegateOfEngine = (id)[Engine sharedEngine];
        UIImage* newBackGroundImage = [self imageWithImage:[UIImage imageNamed:BLUE_BACK] scaledToSize: self.frame.size];
        self.backgroundColor = [UIColor colorWithPatternImage:newBackGroundImage];
    }
    
    return self;
}

- (IBAction)gameOverAction:(id)sender {
    self.hidden = YES;
    if([_delegateOfEngine respondsToSelector:@selector(update)])
        [_delegateOfEngine update];
    
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
