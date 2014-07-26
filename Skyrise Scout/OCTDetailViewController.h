//
//  OCTDetailViewController.h
//  Skyrise Scout
//
//  Created by Ryan Benasutti on 5/22/14.
//  Copyright (c) 2014 Octogonaus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCTDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIImageView *robotPicture;

@end