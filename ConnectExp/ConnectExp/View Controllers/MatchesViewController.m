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
@property (weak, nonatomic) NSMutableArray *queriedUsers;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.arrayOfMatches = PFUser.currentUser[@"matches"];
    NSLog(@"array of matches: %@", self.arrayOfMatches);
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView                         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"forIndexPath:indexPath];
    PFUser *matchID = self.arrayOfMatches[indexPath.row];
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"objectId" equalTo:matchID.objectId];
    query.limit = 1;
    PFUser *match = [[query findObjects]objectAtIndex:0];
    
    // Configure rows
    NSLog(@"match: %@",match);
    cell.username.text = match.username;
    if (match[@"image"] != nil) {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqualToString:@"chatSegue"]) {
        //get the destination of the matched users' thread
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        PFUser *tappedUser = self.arrayOfMatches[indexPath.row];
        ChatViewController *chatViewController = [(UINavigationController *)segue.destinationViewController topViewController];
        NSLog(@"%@", chatViewController);
        NSLog(@"%@", tappedUser);
        chatViewController.userSelf = PFUser.currentUser;
        [self.queriedUsers addObject:PFUser.currentUser];
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"objectId" equalTo:tappedUser.objectId];
        userQuery.limit = 1;
        chatViewController.userOther = [userQuery findObjects].firstObject;
        NSLog(@"userOther: %@", chatViewController.userOther);
        [self.queriedUsers addObject:chatViewController.userOther];
        //create query to grab to show the thread
        PFQuery *query = [PFQuery queryWithClassName:@"MessageThread"];
        [query orderByAscending:@"createdAt"];
        [query includeKey:@"users"];
        [query includeKey:@"messages"];
        [query whereKey:@"users" containsAllObjectsInArray:self.queriedUsers ];
        query.limit = 1;
        NSLog(@"query: %@", self.queriedUsers);
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          if (!error) {
            // The find succeeded.
              NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"users"]);
            }
          } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
          }
        }];
    }
}

@end
