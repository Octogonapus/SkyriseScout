//
//  OCTDetailViewController.m
//  Skyrise Scout
//
//  Created by Octogonaus on 5/22/14.
//  Copyright (c) 2014 Octogonaus. All rights reserved.
//

#import "OCTDetailViewController.h"

@interface OCTDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation OCTDetailViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = self.teamNameRef;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.teamNameField.text = self.teamNameRef;
    [self configureView];
    ((UIScrollView *)[self.view viewWithTag:100]).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.robotPicturePopup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo", @"Choose a Photo", nil];
    if (![self load])
    {
        self.robotPicture.image = [UIImage imageNamed:@"placeholder.png"];
    }
    
    //Make keyboard dismiss
    self.teamNameField.delegate = self;
    self.teamNumberField.delegate = self;
    self.schoolNameField.delegate = self;
    self.driveTypeField.delegate = self;
    self.liftTypeField.delegate = self;
    self.liftMaxHeightField.delegate = self;
    self.autonPointsField.delegate = self;
    self.maxSectionsField.delegate = self;
    self.maxHeldCubesField.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self save];
    [self.delegate addItemViewController:self didFinishEnteringItem:self.teamNameField.text forIndex:self.index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y -= 100;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y += 100;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

#pragma mark - RobotPicture

- (IBAction)robotPictureTapped:(id)sender
{
    [self.robotPicturePopup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //Take a photo
            [self takePhoto];
            break;
        
        case 1:
            //Choose a photo
            [self choosePhoto];
            break;
        
        default:
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)choosePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.robotPicture.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Core Data

- (void)save
{
    OCTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *team = [self loadAndGet];
    
    if (team == nil)
    {
        //Team does not exist yet, make a new one
        NSManagedObject *newTeam;
        newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
        [newTeam setValue:UIImagePNGRepresentation(self.robotPicture.image) forKey:@"robotPicture"];
        [newTeam setValue:self.teamNameField.text forKey:@"teamName"];
        [newTeam setValue:self.teamNumberField.text forKey:@"teamNumber"];
        [newTeam setValue:self.schoolNameField.text forKey:@"schoolName"];
        [newTeam setValue:[NSNumber numberWithFloat:self.driveSpeedSlider.value] forKey:@"driveSpeed"];
        [newTeam setValue:self.driveTypeField.text forKey:@"driveType"];
        [newTeam setValue:[NSNumber numberWithFloat:self.liftSpeedSlider.value] forKey:@"liftSpeed"];
        [newTeam setValue:self.liftTypeField.text forKey:@"liftType"];
        [newTeam setValue:self.liftMaxHeightField.text forKey:@"liftMaxHeight"];
        [newTeam setValue:[NSNumber numberWithFloat:self.autonConsistencySlider.value] forKey:@"autonConsistency"];
        [newTeam setValue:self.autonPointsField.text forKey:@"autonPoints"];
        [newTeam setValue:[NSNumber numberWithBool:self.canBuildSkyriseSwitch.isOn] forKey:@"canBuildSkyrise"];
        [newTeam setValue:self.maxSectionsField.text forKey:@"maxSections"];
        [newTeam setValue:[NSNumber numberWithFloat:self.intakeSpeedSlider.value] forKeyPath:@"intakeSpeed"];
        [newTeam setValue:self.maxHeldCubesField.text forKeyPath:@"maxHeldCubes"];
        NSError *error;
        [context save:&error];
        if (error != nil)
        {
            NSLog(@"Error saving");
        }
    }
    else
    {
        //Team already exists, update that one
        [team setValue:UIImagePNGRepresentation(self.robotPicture.image) forKey:@"robotPicture"];
        [team setValue:self.teamNameField.text forKey:@"teamName"];
        [team setValue:self.teamNumberField.text forKey:@"teamNumber"];
        [team setValue:self.schoolNameField.text forKey:@"schoolName"];
        [team setValue:[NSNumber numberWithFloat:self.driveSpeedSlider.value] forKey:@"driveSpeed"];
        [team setValue:self.driveTypeField.text forKey:@"driveType"];
        [team setValue:[NSNumber numberWithFloat:self.liftSpeedSlider.value] forKey:@"liftSpeed"];
        [team setValue:self.liftTypeField.text forKey:@"liftType"];
        [team setValue:self.liftMaxHeightField.text forKey:@"liftMaxHeight"];
        [team setValue:[NSNumber numberWithFloat:self.autonConsistencySlider.value] forKey:@"autonConsistency"];
        [team setValue:self.autonPointsField.text forKey:@"autonPoints"];
        [team setValue:[NSNumber numberWithBool:self.canBuildSkyriseSwitch.isOn] forKey:@"canBuildSkyrise"];
        [team setValue:self.maxSectionsField.text forKey:@"maxSections"];
        [team setValue:[NSNumber numberWithFloat:self.intakeSpeedSlider.value] forKeyPath:@"intakeSpeed"];
        [team setValue:self.maxHeldCubesField.text forKeyPath:@"maxHeldCubes"];
        NSError *error;
        [context save:&error];
        if (error != nil)
        {
            NSLog(@"Error updating");
        }
    }
}

- (BOOL)load
{
    OCTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(teamName = %@)", self.teamNameField.text];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] != 0)
    {
        matches = objects[0];
        self.robotPicture.image = [UIImage imageWithData:[matches valueForKey:@"robotPicture"]];
        //self.teamNameField.text is already set from the segue
        self.teamNumberField.text = [matches valueForKey:@"teamNumber"];
        self.schoolNameField.text = [matches valueForKey:@"schoolName"];
        [self.driveSpeedSlider setValue:[[matches valueForKey:@"driveSpeed"] floatValue]];
        self.driveTypeField.text = [matches valueForKey:@"driveType"];
        [self.liftSpeedSlider setValue:[[matches valueForKey:@"liftSpeed"] floatValue]];
        self.liftTypeField.text = [matches valueForKey:@"liftType"];
        self.liftMaxHeightField.text = [matches valueForKey:@"liftMaxHeight"];
        [self.autonConsistencySlider setValue:[[matches valueForKey:@"autonConsistency"] floatValue]];
        self.autonPointsField.text = [matches valueForKey:@"autonPoints"];
        [self.canBuildSkyriseSwitch setOn:[[matches valueForKey:@"canBuildSkyrise"] boolValue] animated:YES];
        self.maxSectionsField.text = [matches valueForKey:@"maxSections"];
        [self.intakeSpeedSlider setValue:[[matches valueForKey:@"intakeSpeed"] floatValue]];
        self.maxHeldCubesField.text = [matches valueForKey:@"maxHeldCubes"];
        return YES;
    }
    return NO;
}

- (BOOL)checkLoad
{
    OCTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(teamName = %@)", self.teamNameField.text];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    return [objects count] != 0;
}

- (NSManagedObject *)loadAndGet
{
    OCTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(teamName = %@)", self.teamNameField.text];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] != 0)
    {
        return objects[0];
    }
    
    return nil;
}

@end
