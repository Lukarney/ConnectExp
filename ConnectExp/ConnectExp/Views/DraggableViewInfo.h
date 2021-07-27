//
//  DraggableViewInfo.h
//  ConnectExp
//
//  Created by Luke Arney on 7/22/21.
//
#import "DraggableView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DraggableViewInfo : UIView <DraggableViewDelegate>

//methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@property (retain,nonatomic)NSMutableArray *exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray *allCards; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray *arrayOfMatches; 
@property (weak, nonatomic) DraggableView *card;


@end

NS_ASSUME_NONNULL_END
