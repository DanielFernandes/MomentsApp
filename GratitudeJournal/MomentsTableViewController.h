//
//  MomentsTableViewController.h
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface MomentsTableViewController : UITableViewController

@property NSArray *savedMoments;
@property (strong, nonatomic) Moment *moment;

@end
