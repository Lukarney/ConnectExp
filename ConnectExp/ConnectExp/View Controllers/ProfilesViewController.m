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
@property (strong, nonatomic) NSMutableArray *arrayOfInterest;
@end

@implementation ProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: set up image
    self.user = PFUser.currentUser;
    PFFileObject *image = self.user[@"image"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    [self.profileImage setImageWithURL:imageURL];
    //TODO: set up description & user
    NSLog(@"%@", self.user[@"description"]);
    NSLog(@"%@", self.user.description);
    self.profileDescription.text = self.user[@"description"];
    self.profileName.text = self.user[@"username"];
    //TODO: set up Interest
}

-(void)fetchPost{
    PFQuery *query = [PFQuery queryWithClassName:@"ConnectExpUser"];
    //[query getObjectInBackgroundWithId:(@"%", self.profile[@"Author"].objectId)]
}
- (IBAction)logOutPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)self.view.window.windowScene.delegate;
    NSLog(@"here");
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
