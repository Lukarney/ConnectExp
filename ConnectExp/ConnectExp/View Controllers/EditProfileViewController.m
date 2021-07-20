//
//  EditProfileViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//
#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import "Profile.h"
#import <Parse/Parse.h>


@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextView *bioField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;
@property (weak, nonatomic) UIImage *uiImageSelected;
@property (weak, nonatomic) PFUser *userID;
@property (strong, nonatomic) NSMutableArray *arrayOfInterest;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.isNewUser){
        [self.updateButton setTitle:@"update info" forState:UIControlStateNormal];
        [self.navigationTitle setTitle:@"Edit Profile"];
    }
    else if(self.isNewUser){
        [self.updateButton setTitle:@"Create account" forState:UIControlStateNormal];
        [self.navigationTitle setTitle:@"Registration"];
    }
}
- (IBAction)updateInfoPressed:(id)sender {
    if (!self.isNewUser){
        //TODO: Query user and update information
        
    }
    else if(self.isNewUser){
        Profile *newProfile = (Profile *)[PFObject objectWithClassName:@"ConnectExpProfile"];
        [self signupUser];
        //gets image and saves it
        if( self.uiImageSelected !=nil){
            NSData *imgData = UIImagePNGRepresentation(self.uiImageSelected);
            newProfile[@"photo"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
        }
        else{
            NSData *imgData = UIImagePNGRepresentation(self.imageButton.currentBackgroundImage);
            newProfile[@"photo"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
        }
        
        newProfile[@"bio"] = self.bioField.text;
        newProfile[@"username"] = self.usernameField.text;
        self.arrayOfInterest = [[NSMutableArray array] init];
        [self.arrayOfInterest addObject:@1];
        newProfile[@"Interest"] = self.arrayOfInterest;
        // TODO: Adding properties to Profile
        
        
    }
    
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

-(void)signupUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    self.userID = newUser;
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
        }
    }];
}

- (IBAction)imagePressed:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    //resizing image
    CGSize imgSize = CGSizeMake(150, 150);
    UIImage *imgResized = [self resizeImage:editedImage withSize:imgSize];
    // Do something with the images (based on your use case)
    //self.imageButton.currentBackgroundImage = imgResized;
    self.uiImageSelected = imgResized;
    [self.imageButton setBackgroundImage:imgResized forState:UIControlStateNormal];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
/*
 TODO: Pick Interest
 
 TODO: Pick what you're looking for
 
 
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
