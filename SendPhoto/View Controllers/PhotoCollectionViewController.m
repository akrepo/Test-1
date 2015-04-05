//
//  PhotoCollectionViewController.m
//  SendPhoto
//
//  Created by Александр on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "SWRevealViewController.h"
#import "PhotoManager.h"

@interface PhotoCollectionViewController() <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong) ALAssetsLibrary *photoLibrary;
@end

@implementation PhotoCollectionViewController 

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
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flax_texture_1.jpg"]];
    background.contentMode = UIViewContentModeScaleToFill;
    [self.collectionView setBackgroundView:background];
    
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
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    } else if (buttonIndex == kButtonIndexInternet) {
        
    }
}

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

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[[PhotoManager sharedManager] photos] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end




