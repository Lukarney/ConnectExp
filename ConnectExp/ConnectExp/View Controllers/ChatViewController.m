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

// TODO: Order chats by DESC Createdate
- (void)loadMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;
    // Fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // TODO: Go through post array and assign data of post to respective property in chat model.
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
    // Save in background
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}
/*
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // TODO: Get indexPath and assign the chat to the tableView chat model
}
*/

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
