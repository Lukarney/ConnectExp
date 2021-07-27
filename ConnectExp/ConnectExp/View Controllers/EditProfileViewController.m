//
//  EditProfileViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//
#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextView *bioField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;
@property (weak, nonatomic) UIImage *uiImageSelected;
@property (weak, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *arrayOfInterest;
@property (strong, nonatomic) NSMutableArray *arrayOfMatches;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.isNewUser){
        [self.updateButton setTitle:@"update info" forState:UIControlStateNormal];
        [self.navigationTitle setTitle:@"Edit Profile"];
        self.user = PFUser.currentUser;
        self.usernameField.text = self.user.username;
        self.passwordField.text = self.user.password;
        //see if description is nil
        if (self.user[@"description"] != nil ){
            self.bioField.text = self.user[@"description"];
        }
        //see if picture is nil
        if (self.user[@"image"] != nil ){
            PFFileObject *imageObject = self.user[@"image"];
            NSURL *imageURL = [NSURL URLWithString:imageObject.url];
            UIImage *imageFromURL = [UIImage imageWithData: [NSData dataWithContentsOfURL:imageURL]];
            CGSize imgSize = CGSizeMake(150, 150);
            UIImage *imgResized = [self resizeImage:imageFromURL withSize:imgSize];
            self.uiImageSelected = imgResized;
            [self.imageButton setBackgroundImage:self.uiImageSelected forState:UIControlStateNormal];
        }
        //see if matches is nil
        if (self.user[@"matches"] != nil){
            self.arrayOfMatches = self.user[@"matches"];
        }
        else {
            self.arrayOfMatches = [[NSMutableArray array] init];
        }
        //see if interests is nil
        if (self.user[@"interests"] != nil){
            self.arrayOfInterest = self.user[@"interests"];
        }
        else {
            self.arrayOfInterest = [[NSMutableArray array] init];
        }
    }
    else if(self.isNewUser){
        [self.updateButton setTitle:@"Create account" forState:UIControlStateNormal];
        [self.navigationTitle setTitle:@"Registration"];
        self.arrayOfInterest = [[NSMutableArray array] init];
        self.arrayOfMatches = [[NSMutableArray array] init];
    }
}
- (IBAction)updateInfoPressed:(id)sender {
    if (!self.isNewUser){
        //TODO: Query user and update information
        NSLog(@"Updated profile");
        [self updateUser];
        
    }
    else if(self.isNewUser){
        [self signupUser];
    }
    
}


- (void)signupUser {
    // initialize a user object
    PFUser *newPFUser = [PFUser user];
    // set user properties
    newPFUser.username = self.usernameField.text;
    newPFUser.password = self.passwordField.text;
    self.user = newPFUser;
    if( self.uiImageSelected !=nil){
        NSData *imgData = UIImagePNGRepresentation(self.uiImageSelected);
        newPFUser[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
        
    }
    else{
        NSData *imgData = UIImagePNGRepresentation(self.imageButton.currentBackgroundImage);
        newPFUser[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
    }
    newPFUser[@"description"] = self.bioField.text;
    newPFUser[@"username"] = self.usernameField.text;
    [self.arrayOfInterest addObject:@1];
    newPFUser[@"interests"] = self.arrayOfInterest;
    newPFUser[@"matches"] = self.arrayOfMatches;
    // TODO: Adding properties to Profile
    NSLog(@"%@", newPFUser);
    // call sign up function on the object
    [newPFUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
        }
    }];
}

- (void)updateUser {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        currentUser.username = self.usernameField.text;
        currentUser.password = self.passwordField.text;
        currentUser[@"description"] = self.bioField.text;
        currentUser[@"interests"] = self.arrayOfInterest;
        currentUser[@"matches"] = self.arrayOfMatches;
        if( self.uiImageSelected !=nil){
            NSData *imgData = UIImagePNGRepresentation(self.uiImageSelected);
            currentUser[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
        }
        else{
            NSData *imgData = UIImagePNGRepresentation(self.imageButton.currentBackgroundImage);
            currentUser[@"image"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
        }
      [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"User updated successfully");
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
      }];
    }
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

//TODO: Pick Interest
- (IBAction)FoodDrinkPushed:(id)sender {
    NSLog(@"Food & Drink pressed");
}
- (IBAction)musicPushed:(id)sender {
    NSLog(@"Music pressed");
}
- (IBAction)gamesPushed:(id)sender {
    NSLog(@"Games pressed");
}
//TODO: Pick what you're looking for
- (IBAction)buddyPushed:(id)sender {
    NSLog(@"Buddy pressed");
}
- (IBAction)masterExchangePushed:(id)sender {
    NSLog(@"Master Exchange pressed");
}
- (IBAction)noviceExchangedPushed:(id)sender {
    NSLog(@"Novice Exchange pressed");
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@", segue.identifier);
    if([segue.identifier isEqualToString:@"updateInfoSegue"]){
        
    }
}


@end
