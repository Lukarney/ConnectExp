//
//  ChatViewController.h
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//
#import "Message.h"
#import "MessageThread.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (strong, nonatomic) PFUser *userSelf;
@property (strong, nonatomic) PFUser *userOther;
@property (strong, nonatomic) MessageThread *thread;

@end

NS_ASSUME_NONNULL_END
