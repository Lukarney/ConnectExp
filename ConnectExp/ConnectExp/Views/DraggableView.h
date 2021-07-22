//
//  DraggableView.h
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface DraggableView : UIView

@property (weak) id <DraggableViewDelegate> delegate;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UIImageView *profilePicture;
@property (nonatomic) CGPoint originalPoint;
@property (nonatomic,strong)UILabel *information;
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic,strong)UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cardInformation;
@property (weak, nonatomic) IBOutlet DraggableView *card;

@end

NS_ASSUME_NONNULL_END
