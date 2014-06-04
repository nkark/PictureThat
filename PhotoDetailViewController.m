//
//  PhotoDetailViewController.m
//  ParsePhotoApp
//
//  Created by Nitin Karki on 3/12/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "MainViewController.h"
#import "FilterViewController.h"
#import "HUTransitionAnimator.h"
#import "ZBFallenBricksAnimator.h"

@interface PhotoDetailViewController ()


@end

static NSString *const kKeychainItemName = @"Google Drive";
static NSString *const kClientID = @"781186734382-mhg4303652vnrjp36vc1vc14rn46kdbc.apps.googleusercontent.com";
static NSString *const kClientSecret = @"hGCVGZvXfKAOQ1TJdtU7KoBW";

@implementation PhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.transitioningDelegate = self;
    self.photoImageView.image = self.selectedImage;
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                    clientSecret:kClientSecret];
    //PINCH ZOOM
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self
                                                                                       action:@selector(twoFingerPinch:)];
    [self.photoImageView addGestureRecognizer:twoFingerPinch];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    //NSLog(@"Pinch scale: %f", recognizer.scale);
    if (recognizer.scale >1.0f && recognizer.scale < 2.5f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        self.photoImageView.transform = transform;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Google Drive

// Helper to check if user is authorized
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        self.driveService.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

// Uploads a photo to Google Drive
- (void)uploadPhoto:(UIImage*)image
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"'Uploaded image from Picture That!"];
    
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = [dateFormat stringFromDate:[NSDate date]];
    file.descriptionProperty = @"Uploaded from Picture That!";
    file.mimeType = @"image/png";
    
    NSData *data = UIImagePNGRepresentation((UIImage *)image);
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          [self showAlert:@"Google Drive" message:@"File saved!"];
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                      }
                  }];
}

// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Button Actions

- (IBAction)googleDrivePressed:(id)sender {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: @"Google Drive"
                                       message: @"Do you want to upload this picture to Google Drive?"
                                      delegate: self
                             cancelButtonTitle: @"No"
                             otherButtonTitles: @"Yes", nil];
    [alert show];

}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)trash:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this photo?" delegate:self cancelButtonTitle:@"No"otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)didTap:(id)sender
{
    NSArray *itemsToShare = @[self.selectedImage, @"#pictureThat!"];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if(buttonIndex==alertView.cancelButtonIndex)
        return;
    
    if([alertView.title isEqualToString:@"Google Drive"])
    {
       
        if (![self isAuthorized])
        {
            // Not yet authorized, request authorization and present the login UI
            [self presentViewController:[self createAuthController] animated:YES completion:nil];
        }
        else
        {
            [self uploadPhoto:self.selectedImage];
        }
    }
    else
    {
        [self.selectedObject deleteInBackground];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)filterPressed:(id)sender
{
    FilterViewController *fvc = (FilterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"Filter"];
    
    fvc.selectedImage = self.selectedImage;
    fvc.selectedObject = self.selectedObject;
    
    [self presentViewController:fvc animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NSObject <UIViewControllerAnimatedTransitioning> *animator;
    animator = [[ZBFallenBricksAnimator alloc] init];
    return animator;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
