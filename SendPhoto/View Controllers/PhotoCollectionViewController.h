//
//  PhotoCollectionViewController.h
//  SendPhoto
//
//  Created by Александр on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewController : UICollectionViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)addPhoto:(UIBarButtonItem *)sender;

@end
