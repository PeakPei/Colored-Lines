//
//  BoardCell.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "BoardCell.h"
#import "Config.h"
#import "Colors.h"
#import "LinesBoard.h"
#import "Engine.h"


@implementation BoardCell

// the cell has a row, column, the board it belongs to and its imageView which can be set to be anything, but
// by default it will be set to be a picture of a circle of given color defined in Colors.h
{
    MyPoint* cell;
    LinesBoard* board;
    NSMutableArray* imageViews;
}

// initially each object of type BoardCell will have an array of imageviews of nubmer of COLOR_NUM
// as the board is initially loaded, each cell will already have all the subviews in it
// instead of adding or deleting subviews, the game will have all the necessary components in advance
// and the visual effect will be manipulated only through the alpha component of each imageview
// the user will see only the subview, the alpha of which is set to 1.0
// constructor for the board
-(instancetype)initWithFrame:(CGRect)frame cell:(MyPoint *)newcell board:(LinesBoard *)newboard
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        cell = newcell;
        board = newboard;
        imageViews = [[NSMutableArray alloc] init];
        for ( CellState imageColor = 1; imageColor <= COLOR_NUM; imageColor++)
        {
            // need to fit the image to the size of the cell
            UIImage* oldImage = [UIImage imageNamed:[[Colors sharedColors] getColorNumber:imageColor]];
            UIImage* newImage = [self imageWithImage:oldImage scaledToSize:self.frame.size];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:newImage];
            imageView.alpha = 0.0;
            [imageViews addObject:imageView];
            [self addSubview:imageView];
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        //adding tap recognizer to each cell on the board
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(cellTapped:)];
        [[Engine sharedEngine].multiCastDelegate addDelegate:self];
        [[LinesBoard sharedLinesBoard].multiCastDelegate addDelegate:self];
        [self addGestureRecognizer:tapRecognizer];
        [self setTheColor];
    }
    return self;
}


// sets the appropriate subview appear depending on the CellState of the Cell
// the outer loop iterates through the subviews of the Cell, not more than COLOR_NUM
// the inner loop iterates through the cell states in the typedef enum
// if the state of the cell equals to appropriate CellState in the enum
// the alpha of the subview is set to 1.0 thus making it visible to the user
-(void)setTheColor
{
    CellState currentState = [board cellStateAtPoint:cell];
    if( currentState == EmptyCell)
    {
        for( int i = 1; i <= COLOR_NUM; i++)
            if( ((UIImageView*)[imageViews objectAtIndex:i-1]).alpha == 1.0 )
            [[AnimationManager sharedAnimator] animateCellStateChangedView:((UIImageView*)[imageViews objectAtIndex:i-1]) show:NO];
            
            
    }
    else
    {
        [[AnimationManager sharedAnimator] animateCellStateChangedView:((UIImageView*)[imageViews objectAtIndex:currentState - 1]) show:YES];
    }
}

// since the images on the board are not drawn by the program but set from outside
// the images need to be resized to fit the cells

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// the implementation of the protocol method of LinesBoardDelegate protocol
-(void)cellStateChangedforCell:(MyPoint*) newcell;
{
    
    // checks if it is the correct cell to be updated
    if( cell.column == newcell.column && cell.row == newcell.row )
        [self setTheColor];
        
        
}

// the implementation of the protocol method of EngineDelegate protocol
-(void)cellChosenAnimate:(MyPoint*) point offon:(BOOL)offon
{
    
    if( cell.column == point.column && cell.row == point.row){
        if(offon){
            for( int i = 0; i < COLOR_NUM; i++)
                if( ((UIImageView*)[imageViews objectAtIndex:i]).alpha == 1.0)
                    {
                            [AnimationManager sharedAnimator].chosenCellView = ((UIImageView*)[imageViews objectAtIndex:i]);
                        [[AnimationManager sharedAnimator] animateChosenCellonOff:YES];
                    }
     
                }
        else
            {
                [[AnimationManager sharedAnimator] animateChosenCellonOff:NO];
            }
    
}
}

-(void)giveImageViewofColor:(CellState)color forCell:(MyPoint *)newcell
{
    if( cell.column == newcell.column && cell.row == newcell.row)
    {

        [[AnimationManager sharedAnimator].arrayOfView addObject:[imageViews objectAtIndex:color-1]];
    }
}

- (void)cellTapped:(UITapGestureRecognizer*)recognizer
{
    MyPoint* point = cell;
    [[Engine sharedEngine] getInput:point];
}

-(void)turnOff:(BOOL) onoff;
{
    if(onoff)
        self.userInteractionEnabled = YES;
    else
        self.userInteractionEnabled = NO;
}
@end
