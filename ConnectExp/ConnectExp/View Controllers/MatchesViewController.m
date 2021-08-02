//
//  MatchesViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//

#import "ChatViewController.h"
#import "MatchCell.h"
#import "MatchesViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;
@property (weak, nonatomic) NSMutableArray *queriedUsers;
@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.arrayOfMatches = PFUser.currentUser[@"matches"];
    NSLog(@"array of matches: %@", self.arrayOfMatches);
    [self.tableView reloadData];
}

/*
 TODO: Order Matches by DESC Createdat of last message
 */

- (void)fetchMatches {
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"forIndexPath:indexPath];
    PFUser *matchID = self.arrayOfMatches[indexPath.row];
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"objectId" equalTo:matchID.objectId];
    query.limit = 1;
    PFUser *match = [[query findObjects]objectAtIndex:0];
    
    //configure rows
    NSLog(@"match: %@",match);
    cell.username.text = match.username;
    if(match[@"image"] != nil){
        PFFileObject *image = match[@"image"];
        NSURL *imageURL = [NSURL URLWithString:image.url];
        [cell.userImage setImageWithURL:imageURL];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMatches.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@", segue.identifier);
    if([segue.identifier isEqualToString:@"chatSegue"]){
        //get the destination of the matched users' thread
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        PFUser *tappedUser = self.arrayOfMatches[indexPath.row];
        ChatViewController *chatViewController = [(UINavigationController *)segue.destinationViewController topViewController];
        NSLog(@"%@", chatViewController);
        NSLog(@"%@", tappedUser);
        chatViewController.userOther = tappedUser;
        chatViewController.userSelf = PFUser.currentUser;
        //create query to grab to show the thread
        PFQuery *query = [PFQuery queryWithClassName:@"MessageThread"];
        [query orderByAscending:@"createdAt"];
        [query includeKey:@"users"];
        query.limit = 1;
        [query findObjectsInBackgroundWithBlock:^(NSArray *threads, NSError *error) {
            if (threads != nil) {
                // do something with the array of object returned by the call
                self.queriedUsers = (NSMutableArray *) threads;
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
//        [query whereKey:@"users" containsAllObjectsInArray: self.queriedUsers]
//        [query getObjectInBackgroundWithId:@"<PARSE_OBJECT_ID>" block:^(PFObject *parseObject, NSError *error) {
//            // Do something with the returned PFObject in the parseObject variable.
//            NSLog(@"%@", parseObject);
//        }];
    }
}


@end
