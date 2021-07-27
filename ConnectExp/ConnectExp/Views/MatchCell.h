//
//  MatchCell.h
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

NS_ASSUME_NONNULL_END
