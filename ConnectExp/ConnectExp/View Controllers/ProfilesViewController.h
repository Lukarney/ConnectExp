//
//  ProfilesViewController.h
//  ConnectExp
//
//  Created by Luke Arney on 7/19/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfilesViewController : UIViewController
@property (strong, nonatomic) PFUser *user;
@end

NS_ASSUME_NONNULL_END
