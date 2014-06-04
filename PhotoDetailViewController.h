//
//  PhotoDetailViewController.h
//  ParsePhotoApp
//
//  Created by Nitin Karki on 3/12/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@interface PhotoDetailViewController : UIViewController <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *singlePhotoToolbar;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) PFObject *selectedObject;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

//GOOGLE DRIVE
@property (nonatomic, retain) GTLServiceDrive *driveService;

- (IBAction)didTap:(id)sender;
@end
