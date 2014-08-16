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
    [self load];
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
        NSManagedObject *newTeam;
        newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
        [newTeam setValue:self.teamNameField.text forKey:@"teamName"];
        [newTeam setValue:self.teamNumberField.text forKey:@"teamNumber"];
        NSError *error;
        [context save:&error];
        if (error != nil)
        {
            NSLog(@"Error saving");
        }
    }
    else
    {
        [team setValue:self.teamNameField.text forKey:@"teamName"];
        [team setValue:self.teamNumberField.text forKey:@"teamNumber"];
        NSError *error;
        [context save:&error];
        if (error != nil)
        {
            NSLog(@"Error updating");
        }
    }
}

- (void)load
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
        //self.teamNameField.text is already set from the segue
        self.teamNumberField.text = [matches valueForKey:@"teamNumber"];
    }
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
