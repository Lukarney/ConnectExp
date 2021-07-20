//
//  ChatViewController.m
//  ConnectExp
//
//  Created by Luke Arney on 7/16/21.
//
#import "ChatViewController.h"
#import <Parse/Parse.h>

@interface ChatViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) PFUser *sender;
@property (weak, nonatomic) PFUser *receiver;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
 TODO: In segue send in PFUser for the sender and receiver
 
 TODO: set up messages classes and associate it with keys Text, sender, and reciever - did
 
 TODO: Declare controller to be UITableViewDataSource -did
 
 TODO: Order chats by DESC Createdat
 */
- (IBAction)sendPressed:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_ConnectExp"];
    chatMessage[@"text"] = self.inputField.text;
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

@end
