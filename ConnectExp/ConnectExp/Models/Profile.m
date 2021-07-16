//
//  Profile.m
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#import "Profile.h"

@implementation Profile

@dynamic profileID;
@dynamic userID;
@dynamic author;
@dynamic biography;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)postProfileImage:(UIImage *_Nullable)image
              withCaption:(NSString *_Nullable)caption
           withCompletion:(PFBooleanResultBlock _Nullable)completion {
    
    Profile *newProfile = [Profile new];
    newProfile.image = [self getPFFileFromImage:image];
    newProfile.author = [PFUser currentUser];
    newProfile.biography = caption;
    [newProfile saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
