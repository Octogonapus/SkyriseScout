//
//  OCTDetailViewController.h
//  Skyrise Scout
//
//  Created by Octogonaus on 5/22/14.
//  Copyright (c) 2014 Octogonaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCTAppDelegate.h"

@class OCTDetailViewController;
@protocol OCTDetailViewController <NSObject>
- (void)addItemViewController:(OCTDetailViewController *)controller didFinishEnteringItem:(NSString *)item forIndex:(NSInteger)index;
@end

@interface OCTDetailViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) id<OCTDetailViewController> delegate;
@property (nonatomic) NSInteger index;
@property (weak, nonatomic) NSString *teamNameRef;

@property (weak, nonatomic) IBOutlet UIImageView *robotPicture;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *robotPictureTapRecognizer;
@property (strong, nonatomic) UIActionSheet *robotPicturePopup;
@property (weak, nonatomic) IBOutlet UITextField *teamNameField;
@property (weak, nonatomic) IBOutlet UITextField *teamNumberField;
@property (weak, nonatomic) IBOutlet UITextField *schoolNameField;

@property (weak, nonatomic) IBOutlet UISlider *driveSpeedSlider;
@property (weak, nonatomic) IBOutlet UITextField *driveTypeField;

@property (weak, nonatomic) IBOutlet UISlider *liftSpeedSlider;
@property (weak, nonatomic) IBOutlet UITextField *liftTypeField;
@property (weak, nonatomic) IBOutlet UITextField *liftMaxHeightField;

@property (weak, nonatomic) IBOutlet UISlider *autonConsistencySlider;
@property (weak, nonatomic) IBOutlet UITextField *autonPointsField;

@property (weak, nonatomic) IBOutlet UISwitch *canBuildSkyriseSwitch;
@property (weak, nonatomic) IBOutlet UITextField *maxSectionsField;

@property (weak, nonatomic) IBOutlet UISlider *intakeSpeedSlider;
@property (weak, nonatomic) IBOutlet UITextField *maxHeldCubesField;


@end