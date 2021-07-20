//
//  Messages.h
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Messages : PFObject

@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) PFFileObject *profileImage;
@property (nonatomic, strong) NSMutableArray *arrayOfMessages;

@end

NS_ASSUME_NONNULL_END
