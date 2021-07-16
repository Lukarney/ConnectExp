//
//  EditProfileViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//

#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)logoutPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"User log out failed: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Logged out successfully");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
