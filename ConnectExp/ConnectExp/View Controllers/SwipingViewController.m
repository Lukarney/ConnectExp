//
//  SwipingViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/12/21.
//

#import "SwipingViewController.h"
#import "DraggableView.h"

@interface SwipingViewController ()
@property (weak, nonatomic) IBOutlet UIView *card;
@property (strong, nonatomic) DraggableView *draggableView;
@property (strong, nonatomic) NSMutableArray* arrayOfProfiles;

@end

@implementation SwipingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DraggableView *draggableBackground = [[DraggableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:draggableBackground];
}
- (IBAction)panCard:(UIPanGestureRecognizer *)sender {
    
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
