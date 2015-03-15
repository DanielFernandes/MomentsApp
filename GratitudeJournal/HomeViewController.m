//
//  HomeViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "HomeViewController.h"
#import "MomentsCollectionViewController.h"
#import "FilterImageViewController.h"

/* TODOS
 instagram integration!!
 madlibs type input?  Today I saw ____.  My favorite moment was when ____.  My goal for tomorrow is ______. (next button, diff views)
 
 */

@interface HomeViewController ()

@property NSMutableArray *placeholderArray;
@property NSMutableArray *moments;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self resetNSUserDefaults];
    
    self.placeholderArray = [[NSMutableArray alloc] init];
    [self.placeholderArray addObject:@"What made you smile today?"];
    [self.placeholderArray addObject:@"What are you happy about today?"];
    [self.placeholderArray addObject:@"What are you grateful for today?"];
    [self.placeholderArray addObject:@"What made you happy today?"];
    
    NSString *placeholderText = [self.placeholderArray objectAtIndex:arc4random_uniform(4)]; //TODO: 0-8
    
    self.dailyQuestion.placeholder = placeholderText;
    
    self.moments = [[NSMutableArray alloc] init];
    
    self.dailyQuestion.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showMoments"])
    {
        NSLog(@"Performing showMoments segue");
        //every time you submit a new moment, automatically update the moments array in the table view controller
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        MomentsCollectionViewController *mvc = [segue destinationViewController];
        mvc.savedMoments = [defaults objectForKey:@"moments"];
    }
    else if ([[segue identifier] isEqualToString:@"showFilters"])
    {
        NSLog(@"Performing showFilters segue");
        //pass Moment object to Filter Image View Controller
        //Note: this segue goes to the navigation controller, not the filters view controller, in order to show the nav bar.
        //BUT, in order to pass along the image to the FVC itself, we can retrieve the FVC from the NVC by using nvc.topViewController.
        UINavigationController *nvc = [segue destinationViewController];
        FilterImageViewController *fvc = (FilterImageViewController*) nvc.topViewController; //NOW you can pass along the moment to this view controller's property
        fvc.moment = self.moment;
    }
}

#pragma mark - Saving Moments

//for testing purposes - reset user defaults
//Source: http://stackoverflow.com/questions/6358737/nsuserdefaults-reset
- (void)resetNSUserDefaults {
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)loadImagePicker:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    //default to choose photo from gallery
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSLog(@"show image picker: photo gallery available");
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

//- (void)addMomentToDefaults {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    //ENCODE THE DATA: MOMENT -> NSDATA
//    
//    NSData *todaysMomentData = [NSKeyedArchiver archivedDataWithRootObject:self.moment];
//    
//    //MOMENTS IS AN NSMUTABLEARRAY OF TYPE NSDATA
//    self.moments = [NSMutableArray arrayWithArray:[defaults objectForKey:@"moments"]]; //make sure self.moments property is up to date
//    [self.moments insertObject:todaysMomentData atIndex:0]; //then add today's moment to it
//
//    [defaults setObject:[NSArray arrayWithArray:self.moments] forKey:@"moments"]; //then cast self.moments to an NSArray and refresh the user defaults
//    [defaults synchronize];
//
//}

#pragma mark - Image picker delegate methods

//Source: http://www.raywenderlich.com/13541/how-to-create-an-app-like-instagram-with-a-web-service-backend-part-22
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     NSLog(@"Did finish picking image");
    
    //get the image from the dictionary
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage]; //save the EDITED, cropped image!
    
    //if user did not sufficiently crop their image to a sqaure, crop it for them
    if (chosenImage.size.height != chosenImage.size.width) {
        //Crop the image to a square
        //Source: http://stackoverflow.com/questions/17712797/ios-custom-uiimagepickercontroller-camera-crop-to-square
        CGSize imageSize = chosenImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        if (width != height) {
            CGFloat newDimension = MIN(width, height);
            CGFloat widthOffset = (width - newDimension) / 2;
            CGFloat heightOffset = (height - newDimension) / 2;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
            [chosenImage drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                      blendMode:kCGBlendModeCopy
                          alpha:1.];
            chosenImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    //after user has selected a photo, we must create the moment and segue to Filters
    [picker dismissViewControllerAnimated:YES completion:^{
        Moment *todaysMoment = [[Moment alloc] init];
        todaysMoment.text = self.dailyQuestion.text;
        todaysMoment.date = @"2/28/15";
        todaysMoment.image = chosenImage;
        
        self.moment = todaysMoment;
        //[self addMomentToDefaults];
        [self performSegueWithIdentifier:@"showFilters" sender:self];
    }];
    
    NSLog(@"dismissed picker");
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
