//
//  SwipingViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/12/21.
//

#import "DraggableView.h"
#import "DraggableViewInfo.h"
#import "SwipingViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface SwipingViewController ()
@property (weak, nonatomic) IBOutlet UIView *card;
@property (strong, nonatomic) DraggableView *draggableView;
@property (strong, nonatomic) NSMutableArray* arrayOfProfiles;

@end

@implementation SwipingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DraggableViewInfo *draggableBackground = [[DraggableViewInfo alloc]initWithFrame:self.view.frame];
    [self.view addSubview:draggableBackground];
    // Add Global Queue here?
    // Maybe make a delegate fxn for the draggable view

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
