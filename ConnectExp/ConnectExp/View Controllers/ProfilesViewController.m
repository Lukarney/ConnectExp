//
//  ProfilesViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/19/21.
//

#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import "ProfilesViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface ProfilesViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileDescription;
@property (weak, nonatomic) IBOutlet UILabel *interestsText;
@property (weak, nonatomic) NSMutableArray *arrayOfInterest;

@end

@implementation ProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = PFUser.currentUser;
    PFFileObject *image = self.user[@"image"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    [self.profileImage setImageWithURL:imageURL];
    // Sets up description & user
    self.profileDescription.text = self.user[@"description"];
    self.profileName.text = self.user[@"username"];
    //TODO: set up Interest
    self.arrayOfInterest = self.user[@"interests"];
    self.interestsText.text = @"No interests :(";
    if ([self.arrayOfInterest count]!=0){
        for (NSString *interest in self.arrayOfInterest) {
            // Check if string is empty so (Null) doesn't show
            if ([self.interestsText.text isEqualToString:@"No interests :("]){
                self.interestsText.text = [NSString stringWithFormat:@"%@", interest];
            } else {
                self.interestsText.text = [NSString stringWithFormat:@"%@, %@", self.interestsText.text, interest];
            }
        }
    }
}

- (IBAction)logOutPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)self.view.window.windowScene.delegate;
    NSLog(@"here");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"Logged out successfully");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
