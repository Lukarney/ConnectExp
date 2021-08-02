//
//  ChatViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//
#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) ChatCell *chatCell;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
/*
 TODO: In segue send in PFUser for the sender and receiver
 
 TODO: set up messages classes and associate it with keys Text, sender, and reciever - did
 
 TODO: Declare controller to be UITableViewDataSource -did
 
 TODO: Order chats by DESC Createdat
 */
- (void)loadMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (IBAction)sendPressed:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message"];
    chatMessage[@"text"] = self.inputField.text;
    chatMessage[@"sender"] = self.userSelf;
    chatMessage[@"receiver"] = self.userOther;
    //save in background
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
//                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
