//
//  NewCellsCell.m
//  Lines
//
//  Created by Admin on 26.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "NewCellsCell.h"
#import "NewCells.h"
@implementation NewCellsCell

{
    NSInteger row;
    NSInteger column;
    NewCells* newCells;
    //an array that will contain the subviews of all colors of the current cell
    NSMutableArray* imageViews;
}

-(instancetype)initWithFrame:(CGRect)frame column:(NSInteger)newcolumn newCells:(NewCells *)newnewCells

{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        column = newcolumn;
        newCells = newnewCells;
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
        self.userInteractionEnabled = NO;
        [[NewCells sharedNewCells].multiCastDelegate addDelegate:self];
        [self setTheColor];

    }
    return self;
}

// updates the alpha-s of the subviews of the cell based on the state of the NewCells array at index column
// makes the appropriate subview visible
-(void)setTheColor
{
    CellState currentState = [newCells getCellState:column];
    for ( int i = 1; i <= COLOR_NUM; i++)
    {
        if( currentState == i )
            ((UIImageView*)[imageViews objectAtIndex:i-1]).alpha = 1.0;
        else
            ((UIImageView*)[imageViews objectAtIndex:i-1]).alpha = 0.0;
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

-(void)cellStateChangedTo:(CellState)state column:(NSInteger) newcolumn;
{
    if( column == newcolumn)
        [self setTheColor];
}
@end
