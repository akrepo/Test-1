//
//  RearMenuViewViewController.m
//  SendPhoto
//
//  Created by Александр on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "RearMenuViewController.h"
#import "AppDelegate.h"
#import "DatabaseManager.h"

@interface RearMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) MFMailComposeViewController *mailVC;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

@implementation RearMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuItems = [NSArray arrayWithObjects:@"sendEmail",@"clear", nil];
    self.mailVC = [[MFMailComposeViewController alloc] init];
}

- (void)showEmailViewController {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [appDelegate.globalMailComposer setMessageBody:nil isHTML:NO];
        appDelegate.globalMailComposer.mailComposeDelegate = self;
        
        [self presentViewController:appDelegate.globalMailComposer animated:YES completion:^{
            
        }];
        
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to mail. No email on this device?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [appDelegate cycleTheGlobalMailComposer];
    }

}

//drop table in database
- (void)clearSelectedPhotos {
    BOOL succsess = [[DatabaseManager sharedManager] clearDatabase];
    
    if (succsess) {
        NSLog(@"Clear database: OK");
    }else {
        NSLog(@"Clear database: ERROR");
    }
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
        
    switch (result) {
    
         case MFMailComposeResultCancelled:
             NSLog(@"Mail cancelled");
         break;
         case MFMailComposeResultSaved:
             NSLog(@"Mail saved");
         break;
         case MFMailComposeResultSent:
             NSLog(@"Mail sent");
         break;
         case MFMailComposeResultFailed:
             NSLog(@"Mail sent failure: %@", [error localizedDescription]);
         break;
         default:
         break;
     }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [appDelegate cycleTheGlobalMailComposer];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self showEmailViewController];
            break;
        case 1:
            [self clearSelectedPhotos];
            break;
            
        default:
            break;
    }
}

@end
