//
//  TextEffectsViewController.m
//  GratitudeJournal
//
//  Created by Alice Chang on 3/14/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "TextEffectsViewController.h"
#import "MomentsCollectionViewController.h"

@interface TextEffectsViewController ()

@property NSArray *fonts;
@property NSArray *colors;

@end

@implementation TextEffectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    //load image and label text
    if (self.moment != nil) {
        [self.imageView setImage:self.moment.image];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"sample"]];
    }
    self.momentTextLabel.text = self.moment.text;
    self.momentDateLabel.text = self.moment.date;
    
    //auto-resize moment text
    [self.momentTextLabel sizeToFit];
    
    //[self.imageView setImage:[UIImage imageNamed:@"sample"]];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [self addGestureRecognizersToPiece:self.momentTextLabel];
    
    self.fonts = [NSArray arrayWithObjects:@"Avenir", @"American Typewriter", @"Avenir-HeavyOblique", @"Noteworthy-Bold", @"BradleyHandITCTT-Bold", @"Didot-Italic", nil];
    
    UIColor *pinkColor = [UIColor colorWithRed:1 green:0.6 blue:0.6 alpha:1];
    UIColor *orangeColor = [UIColor colorWithRed:1 green:0.722 blue:0.439 alpha:1];
    UIColor *yellowColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:1];
    UIColor *greenColor = [UIColor colorWithRed:0.8 green:1 blue:0.698 alpha:1];
    UIColor *blueColor = [UIColor colorWithRed:0.58 green:0.722 blue:1 alpha:1];
    UIColor *purpleColor = [UIColor colorWithRed:0.8 green:0.6 blue:1 alpha:1];
    UIColor *darkPinkColor = [UIColor colorWithRed:0.675 green:0.122 blue:0.263 alpha:1]; /*#ac1f43*/
    UIColor *darkOrangeColor = [UIColor colorWithRed:0.933 green:0.49 blue:0 alpha:1]; /*#ee7d00*/
    UIColor *darkGreenColor = [UIColor colorWithRed:0 green:0.667 blue:0.392 alpha:1]; /*#00aa64*/
    UIColor *darkBlueColor = [UIColor colorWithRed:0.008 green:0.173 blue:0.776 alpha:1]; /*#022cc6*/
    UIColor *darkPurpleColor = [UIColor colorWithRed:0.333 green:0.122 blue:0.58 alpha:1]; /*#551f94*/
    self.colors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], pinkColor, orangeColor, yellowColor, greenColor, blueColor, purpleColor,
                   darkPinkColor, darkOrangeColor, darkGreenColor, darkBlueColor, darkPurpleColor, nil];
    
    //set default font
    [self.momentTextLabel setFont:[UIFont fontWithName:[self.fonts objectAtIndex:0] size:25.0]];
    [self.momentDateLabel setFont:[UIFont fontWithName:[self.fonts objectAtIndex:0] size:17.0]];
    self.momentDateLabel.textColor = [UIColor whiteColor];
    self.momentDateLabel.backgroundColor = [UIColor blackColor];
    
    
    self.fontsScrollView.contentSize = CGSizeMake(250, 50);
    self.colorsScrollView.contentSize = CGSizeMake(700, 50);
    
    //Create font buttons
    for (int i = 0; i < [self.fonts count]; i++) {
        UIButton *fontButton = [[UIButton alloc] initWithFrame:CGRectMake(i*50 + i*4, 0, 50, 50)];
        fontButton.tag = i + 100;
        [fontButton setTitle:@"Aa" forState:UIControlStateNormal];
        fontButton.layer.cornerRadius = 10;
        fontButton.clipsToBounds = YES;
        fontButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        fontButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [[fontButton layer] setBorderWidth:1.0f];
        [[fontButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [fontButton.titleLabel setFont:[UIFont fontWithName:[self.fonts objectAtIndex:i] size:25.0]];
        [fontButton addTarget:self action:@selector(chooseFont:) forControlEvents:UIControlEventTouchUpInside];
        [self.fontsScrollView addSubview:fontButton];
        NSLog(@"Created and added %@ font button", [self.fonts objectAtIndex:i]);
    }
    
    //Create color buttons
    for (int i = 0; i < [self.colors count]; i++) {
        UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(i*50 + i*4, 0, 50, 50)];
        colorButton.tag = i + 200;
        colorButton.layer.cornerRadius = 10;
        colorButton.clipsToBounds = YES;
        colorButton.backgroundColor = [self.colors objectAtIndex:i];
        [colorButton addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorsScrollView addSubview:colorButton];
        NSLog(@"Created and added color button");
    }

}

#pragma mark - Target Actions

//Once the user has chosen a font, apply that font to the moment text.
- (IBAction)chooseFont:(UIButton *)sender {
    NSLog(@"Button pressed target action: chose font");
    
    int chosenFontIndex = (int)sender.tag-100;
    NSLog(@"Chose font #%d", chosenFontIndex);
    [self.momentTextLabel setFont:[UIFont fontWithName:[self.fonts objectAtIndex:chosenFontIndex] size:25.0]];
}

//Once the user has chosen a text color, apply the color to the moment text.
- (IBAction)chooseColor:(UIButton *)sender {
    NSLog(@"Button pressed target action: chose color");
    int chosenColorIndex = (int)sender.tag-200;
    NSLog(@"Chose color #%d", chosenColorIndex);
    self.momentTextLabel.textColor = [self.colors objectAtIndex:chosenColorIndex];
}

#pragma mark - Screenshot

//Take a screenshow of a view and all its subviews.
//Source: https://developer.apple.com/library/ios/qa/qa1817/_index.html
- (UIImage *)takeScreenshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"submitMoment"])
    {
        NSLog(@"Performing submitMoment segue");
        
        //take a screenshot of the main image view, to capture the added text
        UIImage *imageWithText = [self takeScreenshot:self.imageContainerView];
        
        self.moment.image = imageWithText;
        
        //pass updated Moment object with text overlay to MomentsCollectionViewController
        MomentsCollectionViewController *mvc = (MomentsCollectionViewController*) [segue destinationViewController];
        mvc.moment = self.moment;
    }
}

#pragma mark - Gesture Recognizers

//Add rotation, pinch, and pan gesture recognizers to moment text.
- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    NSLog(@"Adding gesture recognizers to moment text");
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(rotatePiece:)];
    [rotationGesture setDelegate:self]; //allows multiple types of gestures to be simultaneously recognized!
    [piece addGestureRecognizer:rotationGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
}

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next
// callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    [[piece superview] bringSubviewToFront:piece];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        //make sure the panning stays within bounds of the image view
        if (CGRectContainsPoint(self.imageView.frame, CGPointMake([piece center].x + translation.x,
                                                                  [piece center].y + translation.y))) {
            [piece setCenter:CGPointMake([piece center].x + translation.x,
                                         [piece center].y + translation.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        }
    }
    
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform =
        CGAffineTransformRotate([[gestureRecognizer view] transform],
                                [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform =
        CGAffineTransformScale([[gestureRecognizer view] transform],
                               [gestureRecognizer scale], [gestureRecognizer scale]);
        
        [gestureRecognizer setScale:1];
    }
}

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer
                                       locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x /
                                              piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        
        piece.center = locationInSuperview;
    }
}

#pragma mark - UIGestureRecognizerDelegate

//Allow for multiple gesture recognition.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
