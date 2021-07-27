//
//  DraggableView.m
//  ConnectExp
//
//  Created by Luke Arney on 7/13/21.
//

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation


#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
//placeholder stuff, replace with card-specific information
//TODO: have card information here and make it pattern with of the 
        self.information = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.frame.size.width, 100)];
        self.information.text = @"no info given";
        [self.information setTextAlignment:NSTextAlignmentCenter];
        self.information.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
// placeholder stuff
        self.picture = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/4, 0, self.frame.size.width/2, self.frame.size.width/2)];
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragged:)];
        //add gesture recognizer and add subview to the hierarchy
        [self addGestureRecognizer:self.panGestureRecognizer];
        [self addSubview:self.information];
        [self addSubview:self.picture];
        
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

-(void)dragged:(UIPanGestureRecognizer *)gestureRecognizer{
    
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
       xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
       yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
       
       //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
       switch (gestureRecognizer.state) {
               //%%% just started swiping
           case UIGestureRecognizerStateBegan:{
               self.originalPoint = self.center;
               break;
           };
               //%%% in the middle of a swipe
           case UIGestureRecognizerStateChanged:{
               //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
               CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
               
               //%%% degree change in radians
               CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
               
               //%%% amount the height changes when you move the card up to a certain point
               CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
               
               //%%% move the object's center by center + gesture coordinate
               self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
               
               //%%% rotate by certain amount
               CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
               
               //%%% scale by certain amount
               CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
               
               //%%% apply transformations
               self.transform = scaleTransform;
               //[self updateOverlay:xFromCenter];
               break;
           };
               //%%% let go of the card
           case UIGestureRecognizerStateEnded: {
               [self afterSwipeAction];
               break;
           };
           case UIGestureRecognizerStatePossible:break;
           case UIGestureRecognizerStateCancelled:break;
           case UIGestureRecognizerStateFailed:break;
       }
    
}

-(void)loadImagePlusStyle{
    //ad image UIImageView *image
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(7, 7);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
//-(void)updateOverlay:(CGFloat)distance
//{
//    if (distance > 0) {
//        overlayView.mode = GGOverlayViewModeRight;
//    } else {
//        overlayView.mode = GGOverlayViewModeLeft;
//    }
//
//    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
//}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             //overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    //TODO: Implement cardSwipedRight that will provide an action to do after swiping right
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    //TODO: Implement cardSwipedLeft that will provide an action to do after swiping left
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}


@end
