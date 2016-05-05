//
//  Protocols.h
//  Lines
//
//  Created by Admin on 02.02.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#ifndef Lines_Protocols_h
#define Lines_Protocols_h
#import "Colors.h"
@class UIView;
@class UIImageView;
@class MyPoint;

@protocol EngineDelegate <NSObject>

@optional

-(void)cellChosenAnimate:(MyPoint*) point offon:(BOOL) offon;
-(void)implementPathNotFoundAnimation;
-(void)updateTheScoreLabel;
-(void)turnOffDeleteButtonAnimation;
-(void)giveImageViewofColor:(CellState) color forCell:(MyPoint*) cell;
-(void)hideMainView;
-(void)disableDeleteButton:(BOOL) onoff;
-(void)disableEndGameButton:(BOOL) onoff;
-(void)updateDeleteButtonText;
-(void)turnOff:(BOOL) onoff;



@end

@protocol GameOverDelegate <NSObject>

-(void)update;

@end



@protocol AnimationManagerDelegate <NSObject>

@optional

-(void)doTheRest;

@end




@protocol  LinesBoardDelegate <NSObject>

@optional

-(void)cellStateChangedforCell:(MyPoint*) cell;

@end



@protocol  NewCellsDelegate <NSObject>

@optional

-(void)cellStateChangedTo:(CellState) state column:(NSInteger) column;

@end


#endif
