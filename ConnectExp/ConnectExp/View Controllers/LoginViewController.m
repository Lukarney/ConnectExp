//
//  LoginViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) PFUser *queriedUser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)signupPressed:(id)sender {
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];
}

- (IBAction)loginPressed:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    PFQuery *query = [PFUser query];
    [query whereKey:username equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
           // Found the user!
           self.queriedUser = (PFUser *)object;
            NSLog(@"Queried user successfully");
        } else {
            NSLog(@"Queried user UNsuccessfully");
        }
    }];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user,NSError *error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // Display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqualToString:@"signupSegue"]) {
        UINavigationController *nav = [segue destinationViewController];
        EditProfileViewController *newuser = (EditProfileViewController *)[nav topViewController];
        newuser.isNewUser = (BOOL *)YES;
    }
    else if([segue.identifier isEqualToString:@"loginSegue"]) {
        TabBarViewController *tab = [segue destinationViewController];
        tab.user = self.queriedUser;
    }
}

@end
