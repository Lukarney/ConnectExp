//
//  DraggableView.h
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DraggableView : UIView

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

NS_ASSUME_NONNULL_END