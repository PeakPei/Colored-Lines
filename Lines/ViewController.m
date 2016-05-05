//
//  ViewController.m
//  Lines
//
//  Created by Admin on 25.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "ViewController.h"
#import "GameOverViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gridImage;
@property (weak, nonatomic) IBOutlet UIImageView *nextBallsImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *noPathFoundLabel;
@property (strong, nonatomic) IBOutlet GameOverViewController *gameOverView;
// the delete functionality gives the opportunity to delete any cell on the board
// it does not add to the score, but lets the user to open a path
// the number of the cells the user can delete during a single game is defined in Config.h
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *endGameButton;
@end

@implementation ViewController

{
    BOOL startingCellChosen;
    BOOL destinationCellChosen;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[[FileManager sharedManager] load];
     // the sizes of the frame of the nextBalls us adjusted depending on the number of new balls incoming
    CGRect frame = _nextBallsImage.frame;
    frame.size.height = HEIGHT_OF_NEW_CELLS;
    frame.size.width = HEIGHT_OF_NEW_CELLS * NEW_CELLS;
    [_nextBallsImage setFrame:frame];
    // the boardview is created using the coordinates and the size of its background image
    BoardView* boardView = [[BoardView alloc] initWithFrame:CGRectMake( _gridImage.frame.origin.x, _gridImage.frame.origin.y, _gridImage.frame.size.width, _gridImage.frame.size.height) board:[LinesBoard sharedLinesBoard]];
    // the view of new cells created using the coordinates of its background image
    NewCellsView* cellsView = [[NewCellsView alloc] initWithFrame:CGRectMake( _nextBallsImage.frame.origin.x, _nextBallsImage.frame.origin.y, _nextBallsImage.frame.size.width, _nextBallsImage.frame.size.height) newCells:[NewCells sharedNewCells]];
    
    [self.view addSubview:boardView];
    [self.view addSubview:cellsView];
    // because the sizes of the labels, board and buttons are not static and can be changed
    // the images are resized and adjusted to the size of their frame
    UIImage* newBackGroundImage = [self imageWithImage:[UIImage imageNamed:MAIN_BACK] scaledToSize: self.view.frame.size];
    UIImage* newBoardViewImage = [self imageWithImage:[UIImage imageNamed:LIGHTGRAY_BACK] scaledToSize: boardView.frame.size];
    UIImage* newCellsViewImage = [self imageWithImage:[UIImage imageNamed:LIGHTGRAY_BACK] scaledToSize: cellsView.frame.size];
    UIImage* newDeleteButtonImage = [self imageWithImage:[UIImage imageNamed:PLUM_BACK] scaledToSize: _deleteButton.frame.size];
    UIImage* newScoreLabelImage = [self imageWithImage:[UIImage imageNamed:PLUM_BACK] scaledToSize: _scoreLabel.frame.size];
    UIImage* newScoreNumberLabelImage = [self imageWithImage:[UIImage imageNamed:PLUM_BACK] scaledToSize:_scoreNumberLabel.frame.size];
    UIImage* newEndGameButtonImage = [self imageWithImage:[UIImage imageNamed:PLUM_BACK] scaledToSize: _endGameButton.frame.size];
    [_deleteButton setBackgroundImage:newDeleteButtonImage forState:UIControlStateNormal];
    [_endGameButton setBackgroundImage:newEndGameButtonImage forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithPatternImage:newBackGroundImage];
    boardView.backgroundColor = [UIColor colorWithPatternImage:newBoardViewImage];
    cellsView.backgroundColor = [UIColor colorWithPatternImage:newCellsViewImage];
    _scoreLabel.backgroundColor = [UIColor colorWithPatternImage:newScoreLabelImage];
    _scoreNumberLabel.backgroundColor = [UIColor colorWithPatternImage:newScoreNumberLabelImage];
   
  
    self.noPathFoundLabel.highlighted = YES;
    _scoreLabel.text = [NSString stringWithFormat:@"%li", (long)[Score sharedScore].score];
    [_deleteButton setTitle:[NSString stringWithFormat:@"Delete: %li", [Engine sharedEngine].canDelete] forState:UIControlStateNormal];
    _noPathFoundLabel.alpha = 0.0;
    
    startingCellChosen = NO;
    destinationCellChosen = NO;
    [Engine sharedEngine].delegateOfViewController = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)newGameButton:(id)sender
{
    [[Engine sharedEngine] turnButtons:NO];
    [Engine sharedEngine].cellIsBeingDeleted = NO;
    [self turnOffDeleteButtonAnimation];
    _deleteButton.userInteractionEnabled = NO;
    _endGameButton.userInteractionEnabled = NO;
    [self hideMainView];
}
- (IBAction)deleteCell:(id)sender
{
    UIButton* button = (UIButton*)(sender);
    if( [Engine sharedEngine].canDelete > 0)
    {
    [Engine sharedEngine].cellIsBeingDeleted = ![Engine sharedEngine].cellIsBeingDeleted;
    if( [Engine sharedEngine].cellIsBeingDeleted)
       [[AnimationManager sharedAnimator] animateDeleteButtonPressed:button onoff:YES];
    else
        [[AnimationManager sharedAnimator]animateDeleteButtonPressed:button onoff:NO];
    }
}



// after being informed by the Board that path was not found, sends its label to the animation manager
-(void)implementPathNotFoundAnimation
{
    [[AnimationManager sharedAnimator] animateNoPathFound:_noPathFoundLabel];
}


// implements the method of engine protocol tp update the score
-(void)updateTheScoreLabel
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%li", (long)[Score sharedScore].score];
}

// hides main view, brings up the game over view
-(void)hideMainView
{
    _gameOverView.hidden = NO;
    _gameOverView.scoreLabel.text = [NSString stringWithFormat:@"%li", [Score sharedScore].score];
    [self.view bringSubviewToFront: _gameOverView];
}

-(void)turnOffDeleteButtonAnimation
{
    [[AnimationManager sharedAnimator] animateDeleteButtonPressed:_deleteButton onoff:NO];
}

-(void)disableDeleteButton:(BOOL)onoff
{
    _deleteButton.userInteractionEnabled = !onoff;
}

-(void)updateDeleteButtonText
{
    [_deleteButton setTitle:[NSString stringWithFormat:@"Delete: %li", [Engine sharedEngine].canDelete] forState:UIControlStateNormal];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)disableEndGameButton:(BOOL)onoff
{
    _endGameButton.userInteractionEnabled = !onoff;
}
@end
