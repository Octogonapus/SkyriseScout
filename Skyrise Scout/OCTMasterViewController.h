//
//  OCTMasterViewController.h
//  Skyrise Scout
//
//  Created by Octogonaus on 5/22/14.
//  Copyright (c) 2014 Octogonaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCTDetailViewController;

@interface OCTMasterViewController : UITableViewController

@property (strong, nonatomic) OCTDetailViewController *detailViewController;

@end
