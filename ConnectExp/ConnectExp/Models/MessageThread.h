//
//  MessageThread.h
//  ConnectExp
//
//  Created by Luke Arney on 7/21/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageThread : PFObject
@property (strong, nonatomic) NSMutableArray *arrayOfMessages;
@property (strong, nonatomic) NSMutableArray *arrayOfUsers;
@end

NS_ASSUME_NONNULL_END
