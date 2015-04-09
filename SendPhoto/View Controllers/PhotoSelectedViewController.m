//
//  PhotoCollectionViewController.m
//  SendPhoto
//
//  Created by Александр on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "PhotoSelectedViewController.h"
#import "SWRevealViewController.h"
#import "PhotoManager.h"
#import "ELCImagePickerHeader.h"

@interface PhotoSelectedViewController() <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ELCImagePickerControllerDelegate>
@property(nonatomic, strong) ALAssetsLibrary *photoLibrary;
@end

@implementation PhotoSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma mark SWRevealViewController
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
#pragma mark -
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linen.jpg"]];
    background.contentMode = UIViewContentModeScaleToFill;
    [self.tableView setBackgroundView:background];
    
    self.photoLibrary = [[ALAssetsLibrary alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showOrHideNavigationPromt];
}

- (void)showOrHideNavigationPromt {
    
    CGFloat delayInSeconds = .5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationItem setPrompt:@"Add photos to send to Email"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationItem setPrompt:nil];
        });
        
    });
}

#pragma mark Actions

- (IBAction)addPhoto:(UIBarButtonItem *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Get Photos From:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Internet", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    static const NSInteger kButtonIndexPhotoLibrary = 0;
    static const NSInteger kButtonIndexInternet = 1;
    
    if (buttonIndex == kButtonIndexPhotoLibrary) {
        
#pragma mark - ELCImagePickerController
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.imagePickerDelegate = self;
        
        elcPicker.maximumImagesCount = 10; //Set the maximum number of images to select to 100
        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
        //elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:elcPicker animated:YES completion:^{
            
        }];
        
        
    } else if (buttonIndex == kButtonIndexInternet) {
        
    }
    
    /*
    if (buttonIndex == kButtonIndexPhotoLibrary) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    } else if (buttonIndex == kButtonIndexInternet) {
        
    }
     */
}

/*
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *view = [[UIImageView alloc] initWithImage:selectedImage];
    
    [self.view addSubview:view];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
*/

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[[PhotoManager sharedManager] photos] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - ELCImagePickerControllerDelegate

/**
 * Called with the picker the images were selected from, as well as an array of dictionary's
 * containing keys for ALAssetPropertyLocation, ALAssetPropertyType,
 * UIImagePickerControllerOriginalImage, and UIImagePickerControllerReferenceURL.
 * @param picker
 * @param info An NSArray containing dictionary's with the key UIImagePickerControllerOriginalImage, which is a rotated, and sized for the screen 'default representation' of the image selected. If you want to get the original image, use the UIImagePickerControllerReferenceURL key.
 */
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    NSLog(@"%@",[info description]);
    
    for (NSDictionary *dict in info) {
        
        [self.photoLibrary assetForURL:[dict objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            
            Photo *photo = [[Photo alloc] initWithAsset:asset];
            [[PhotoManager sharedManager] addPhoto:photo];
            
        } failureBlock:^(NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied" message:@"To access your photos, please change the permissions in Settings" delegate:nil cancelButtonTitle:@"ok"otherButtonTitles:nil, nil];
            [alert show];
            
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/**
 * Called when image selection was cancelled, by tapping the 'Cancel' BarButtonItem.
 */

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end




