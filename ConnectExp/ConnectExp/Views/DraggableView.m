//
//  DraggableView.m
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#import "DraggableView.h"

@implementation DraggableView

//- (id)init{
//    self = [super init];
//    if (!self) return nil;
//    //self.panGestureRecognizer = [UIPanGestureRecognizer alloc] initWithTarget:self action:@selector([self addGestureRecognizer:self._panGestureRecognizer]);
//
//    [self loadImagePlusStyle];
//
//}

-(void)dragged:(UIGestureRecognizer *)gestureRecognizer{
    
}

-(void)loadImagePlusStyle{
    //ad image UIImageView *image
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(7, 7);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}

-(void)dealloc{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
