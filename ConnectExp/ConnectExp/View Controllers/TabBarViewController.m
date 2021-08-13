//
//  TabBarViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/22/21.
//
#import "SwipingViewController.h"
#import "TabBarViewController.h"
#import "MatchesViewController.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController

@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(nonnull UITabBarItem *)item{
    NSLog(@"tab bar: %@", item.title);
    if ([item.title isEqualToString:@"Feed"]){
        
    } else if ([item.title isEqualToString:@"Matches"]){
        
    }
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
