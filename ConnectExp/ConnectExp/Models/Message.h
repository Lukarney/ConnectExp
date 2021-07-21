//
//  Message.h
//  ConnectExp
//
//  Created by Luke Arney on 7/21/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject
@property (strong, nonatomic) PFUser *sender;
@property (strong, nonatomic) PFUser *receiver;
@property (strong, nonatomic) PFFileObject *image;
@property (strong, nonatomic) NSString *text;
@property (nonatomic, strong) NSDate *createdAtDate;
@end

NS_ASSUME_NONNULL_END
