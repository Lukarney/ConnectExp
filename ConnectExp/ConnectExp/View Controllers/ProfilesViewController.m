//
//  ProfilesViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/19/21.
//

#import "ProfilesViewController.h"
#import "Profile.h"
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
    /*
    PFFileObject *image = self.profile[@"image"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    [self.profileImage setImageWithURL:imageURL];
    */
    //TODO: set up description & user
    
    //TODO: set up Interest
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
