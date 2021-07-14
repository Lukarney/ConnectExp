//
//  DraggableView.h
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

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
@property (strong, nonatomic) UILabel *author;
@property (strong, nonatomic) UILabel *information;
@property (nonatomic) CGPoint originalPoint;

@end

NS_ASSUME_NONNULL_END
