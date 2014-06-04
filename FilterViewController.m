//
//  FilterViewController.m
//  ParsePhotoApp
//
//  Created by Nitin Karki on 4/19/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = self.selectedImage;
    
    self.items = @[@"Original",
                @"CIPhotoEffectChrome",
                @"CIPhotoEffectFade",
                @"CISepiaTone",
                @"CIPhotoEffectInstant",
                @"CIPhotoEffectMono",
                @"CIPhotoEffectNoir",
                @"CIPhotoEffectProcess",
                @"CIPhotoEffectTonal",
                @"CIPhotoEffectTransfer",
                @"CISRGBToneCurveToLinear"];
}

#pragma mark - Button Actions

- (IBAction)cancelPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)applyPressed:(id)sender {
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.7f);
    PFFile *imageFile = [PFFile fileWithName:@"Filtered_Image.jpg" data:imageData];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    // Set determinate mode
    self.HUD.mode = MBProgressHUDModeDeterminate;
    self.HUD.delegate = self;
    self.HUD.labelText = @"Uploading";
    [self.HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            //Hide determinate HUD
            [self.HUD hide:YES];
            
            // Show checkmark
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            self.HUD.mode = MBProgressHUDModeCustomView;
            
            self.HUD.delegate = self;
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Filtered photo was uploaded." delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
                    [alert show];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [self.HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        self.HUD.progress = (float)percentDone/100;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// =============================================================================
#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}

// =============================================================================
#pragma mark - UIPickerViewDelegate
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if ([self.items[row] isEqualToString:@"CIPhotoEffectChrome"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Chrome" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectFade"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Fade" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectInstant"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Instant" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectMono"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Mono" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectNoir"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Noir" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectProcess"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Process" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectTonal"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Tonal" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CIPhotoEffectTransfer"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Transfer" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CISRGBToneCurveToLinear"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Linear" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else if ([self.items[row] isEqualToString:@"CISepiaTone"]) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Sepia" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    else
    {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.items[row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return attString;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row == 0) {
        
        self.imageView.image = self.selectedImage;
        
        return;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.selectedImage];
    
    CIFilter *filter = [CIFilter filterWithName:self.items[row]
                                  keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
