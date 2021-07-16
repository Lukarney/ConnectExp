//
//  Profile.h
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : PFObject

@property (nonatomic, strong) NSString *profileID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *biography;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSMutableArray *interest;

+ (void) postProfileImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
