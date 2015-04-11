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
#import "DatabaseManager.h"
#import "ELCImagePickerHeader.h"
#import "PhotoCell.h"

NSString *const kPhotoLibraryUpdatedNotification = @"kPhotoLibraryUpdatedNotification";

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoHasAddedToPhotoLibrary) name:kPhotoLibraryUpdatedNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *urlStrings = [[DatabaseManager sharedManager] selectAllURLs];
    
    if (!urlStrings || (urlStrings && [urlStrings count] == 0)) {
        [self showOrHideNavigationPromt];
    }
    
    for (NSString *urlrStr in urlStrings) {
        NSURL *url = [NSURL URLWithString:urlrStr];
        
        [self fillPhotoLibraryFromURL:url];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Notification
- (void)photoHasAddedToPhotoLibrary {
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
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

- (void)fillPhotoLibraryFromURL:(NSURL *)url {
    [self.photoLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        Photo *photo = [[Photo alloc] initWithAsset:asset];
        [[PhotoManager sharedManager] addPhoto:photo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibraryUpdatedNotification object:nil];
        
    } failureBlock:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied" message:@"To access your photos, please change the permissions in Settings" delegate:nil cancelButtonTitle:@"ok"otherButtonTitles:nil, nil];
        [alert show];
        
    }];
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
        
#pragma mark - Create ELCImagePickerController
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[PhotoManager sharedManager] photos] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Photo *photo = [[[PhotoManager sharedManager] photos] objectAtIndex:indexPath.row];
    
    PhotoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    cell.imageView.image = photo.thumbnail;
    
    return cell;
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
        
        NSURL *assetURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
        __unused NSString *str = assetURL.absoluteString;
        [[DatabaseManager sharedManager] insertURLString:assetURL.absoluteString];
        
        [self fillPhotoLibraryFromURL:assetURL];
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




