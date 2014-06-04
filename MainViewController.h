//
//  MainViewController.h
//  ParsePhotoApp
//
//  Created by Nitin Karki on 3/12/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <stdlib.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MainViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) NSMutableArray *allImages;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) MBProgressHUD *refreshHUD;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)refreshPressed:(id)sender;
- (IBAction)uploadImagePressed:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;
- (void)loginIfNecessary;

@end