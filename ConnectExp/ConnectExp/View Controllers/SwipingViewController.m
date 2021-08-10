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
    // Add Global Queue here
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        PFQuery *query = [PFUser query];
        [query includeKey:@"username"];
        // TODO: Fetch data asynchronously
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    // Call users to get Array and dictionary
                    NSMutableArray *userIds = [self getListOfIds:users];
                    NSMutableDictionary *IID = [self createDictionaryOfInterests:users];
                    // Call algorithm to get matches
                    NSMutableDictionary *matchesDict = [self getMatchesV1:[userIds count] listOfIds:userIds InterestInDictionary:IID];
                    NSLog(@"matchesDict: %@", matchesDict);
                    NSMutableArray *orderedUsers = [self getUsersOrdered:PFUser.currentUser getUsers:users matchesDict:matchesDict];
                    NSLog(@"orderedUsers: %@", orderedUsers);
                    NSLog(@"self: %@", PFUser.currentUser.objectId);
                    // TODO: set out example cards to be equal to the users in the dictionary from current users keys
                    draggableBackground.exampleCardLabels = orderedUsers;
                });
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    });
    // Maybe make a delegate fxn for the draggable view

}
- (NSMutableArray *)getListOfIds:(NSMutableArray *)users {
    NSMutableArray *ArrayOfUserIds = [[NSMutableArray alloc] init];
    for (PFUser *user in users)
    {
        [ArrayOfUserIds addObject:user.objectId];
    }
    return ArrayOfUserIds;
}
- (NSMutableDictionary *)createDictionaryOfInterests:(NSMutableArray *)users {
    NSMutableDictionary *dictForUserInterest = [[NSMutableDictionary alloc] init];
    
    for (PFUser *user in users)
    {
        // Query User
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"objectId" equalTo:user.objectId];
        userQuery.limit = 1;
        PFUser *userObjects = [userQuery findObjects].firstObject;
        dictForUserInterest[user.objectId] = [[NSMutableArray alloc] init];
        dictForUserInterest[user.objectId] = userObjects[@"interests"];
        
    }
    return dictForUserInterest;
}

- (NSMutableDictionary *)getMatchesV1:(NSInteger)N
                            listOfIds:(NSMutableArray *)M
                 InterestInDictionary:(NSMutableDictionary *)IID {
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    NSArray *keyArray = [IID allKeys];
    for (id key in keyArray)
    {
        IID[key] = [NSMutableSet setWithArray:IID[key]];
        res[key] = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < N; i++) {
        id keyForI = [keyArray objectAtIndex:i];
        NSUInteger interestLengthOfI = [IID[keyForI] count];
        for (int j = i+1; j < N; j++) {
            id keyForJ = [keyArray objectAtIndex:j];
            NSUInteger interestLengthOfJ = [IID[keyForJ] count];
            int count = 0;
            for (NSString *interest in IID[keyForI]) {
                if ([IID[keyForJ] containsObject:interest]) {
                    count += 1;
                }
            }
            // Create arrays and add Ids then the percentage
            NSMutableArray *arrayForI = [[NSMutableArray alloc] init];
            NSMutableArray *arrayForJ = [[NSMutableArray alloc] init];
            [arrayForI addObject:keyForJ];
            [arrayForJ addObject:keyForI];
            // Add Score
            [arrayForI addObject:[NSNumber  numberWithFloat:(float)count/(float)interestLengthOfI]];
            [arrayForJ addObject:[NSNumber numberWithFloat:(float)count/(float)interestLengthOfJ]];
            // Add array to dictionary for respective keys
            [res[keyForI] addObject:arrayForI];
            [res[keyForJ] addObject:arrayForJ];
        }
    }
    for (id key in res)
    {
        // Sorts the array
        [res[key] sortUsingComparator:^(id obj1, id obj2) {
            NSLog(@"Obj1&2: %@, %@", [obj1 objectAtIndex:1], [obj2 objectAtIndex:1]);
            if ([[obj1 objectAtIndex:1] floatValue] > [[obj2 objectAtIndex:1] floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([[obj1 objectAtIndex:1] floatValue] < [[obj2 objectAtIndex:1] floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
    }
    return res;
        
}

- (NSMutableArray *)getUsersOrdered:(PFUser *)currentUser
                           getUsers:(NSArray *)users
                        matchesDict:(NSMutableDictionary *)matchesDict {
    NSMutableArray *usersOrdered = [[NSMutableArray alloc] init];
    NSMutableArray *returnedUsers = [[NSMutableArray alloc] init];
    NSMutableArray *potentialMatches = matchesDict[currentUser.objectId];
    for (NSMutableArray *matchesList in potentialMatches) {
        [usersOrdered addObject:[matchesList objectAtIndex:0]];
        [returnedUsers addObject:[matchesList objectAtIndex:0]];
    }
    for (PFUser *user in users){
        if ([usersOrdered containsObject:user.objectId]){
            NSUInteger userIndex = [usersOrdered indexOfObject:user.objectId];
            [returnedUsers replaceObjectAtIndex:userIndex withObject:user];
        }
        
    }
    return returnedUsers;
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
