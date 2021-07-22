//
//  TabBarViewController.h
//  ConnectExp
//
//  Created by Luke Arney on 7/22/21.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarViewController : UITabBarController
@property (strong, nonatomic) PFUser *user;
@end

NS_ASSUME_NONNULL_END
