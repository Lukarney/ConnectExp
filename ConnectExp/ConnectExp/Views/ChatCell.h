//
//  ChatCell.h
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorField;
@property (weak, nonatomic) IBOutlet UILabel *messageField;

@end

NS_ASSUME_NONNULL_END
