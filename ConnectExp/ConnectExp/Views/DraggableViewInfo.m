//
//  DraggableViewInfo.m
//  ConnectExp
//
//  Created by Luke Arney on 7/22/21.
//

#import "DraggableViewInfo.h"
#import "SwipingViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@implementation DraggableViewInfo{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    UIButton *menuButton;
    UIButton *messageButton;
    UIButton *checkButton;
    UIButton *xButton;
    
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 386; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards
@synthesize card;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
        self.exampleCardLabels = [[NSMutableArray alloc] init];
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
          // do stuff with the user
            self.arrayOfMatches = [[NSMutableArray alloc] init];
            NSLog(@"got current user");
            // TODO: Add below code later when matching algo is correct
//            if ([currentUser[@"matches"] count] > 0){
//                self.arrayOfMatches = currentUser[@"matches"];
//                NSLog(@"array at the beg: %@", self.arrayOfMatches);
//            }
        }
        else{
            NSLog(@"Did not get user");
            
        }
        PFQuery *query = [PFUser query];
        [query includeKey:@"username"];
        // TODO: Fetch data asynchronously
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                // Do something with the array of object returned by the call
                // Call users to get Array and dictionary
                NSMutableArray *userIds = [self getListOfIds:users];
                NSMutableDictionary *IID = [self createDictionaryOfInterests:users];
                NSLog(@"userIds: %@", userIds);
                NSLog(@"IID: %@", IID);
                // Call algorithm to get matches
                NSMutableDictionary *matchesDict = [self getMatchesV1:[userIds count] listOfIds:userIds InterestInDictionary:IID];
                NSLog(@"matchesDict: %@", matchesDict);
                NSMutableArray *orderedUsers = [self getUsersOrdered:PFUser.currentUser getUsers:users matchesDict:matchesDict];
                NSLog(@"orderedUsers: %@", orderedUsers);
                NSLog(@"self: %@", PFUser.currentUser.objectId);
                // TODO: set out example cards to be equal to the users in the dictionary from current users keys
                self.exampleCardLabels = orderedUsers;
                loadedCards = [[NSMutableArray alloc] init];
                self.allCards = [[NSMutableArray alloc] init];
                cardsLoadedIndex = 0;
                [self loadCards];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView {
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
//    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
//    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
//    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
//    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
//    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
//    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
//    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
//    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
//    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
//    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:menuButton];
//    [self addSubview:messageButton];
//    [self addSubview:xButton];
//    [self addSubview:checkButton];
}
//%%% creates a card and returns it.  This should be customized to fit your needs.
// Use "index" to indicate where the information should be pulled.
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    PFUser *user = self.exampleCardLabels[index];
    draggableView.userPointer = user;
    draggableView.information.text = user[@"username"];
    draggableView.desc.text = user[@"description"];
    draggableView.interests = user[@"interests"];
    for (NSString *interest in draggableView.interests) {
        // Check if string is empty so (Null) doesn't show
        if ([draggableView.interestInformation.text length] == 0){
            draggableView.interestInformation.text = [NSString stringWithFormat:@"%@", interest];
        } else {
            draggableView.interestInformation.text = [NSString stringWithFormat:@"%@, %@", draggableView.interestInformation.text, interest];
        }
    }
    if(user[@"image"] != nil){
        PFFileObject *image = user[@"image"];
        NSURL *imageURL = [NSURL URLWithString:image.url];
        [draggableView.picture setImageWithURL:imageURL];
    }
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards {
    DISPATCH_QUEUE_PRIORITY_BACKGROUND;
    NSLog(@"count: %lu", (unsigned long)[self.exampleCardLabels count]);
    if([self.exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap =(([self.exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[self.exampleCardLabels count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[self.exampleCardLabels count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
// TODO: Add concurrency to card swiped right to update the matches list
-(void)cardSwipedRight:(UIView *)card {
    //do whatever you want with the card that was swiped
//    DraggableView *c = (DraggableView *)card;
    DraggableView *currentCard = [loadedCards objectAtIndex:0];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *matchedUser = currentCard.userPointer;
    NSLog(@"loaded card user: %@", matchedUser);
    NSLog(@"loaded card now: %@", [loadedCards objectAtIndex:0]);
    NSLog(@"current User: %@", currentUser);
    NSLog(@"current matches: %@", self.arrayOfMatches);
    //add matched user to matched list of current user
    if (!([currentUser[@"matches"] containsObject:matchedUser]) &&
        !([matchedUser.objectId isEqual:currentUser.objectId])){
        //add new match to current user
        [self.arrayOfMatches addObject:matchedUser];
        if (currentUser) {
            //save matches
            currentUser[@"matches"] = self.arrayOfMatches;
            NSLog(@"updated user: %@", currentUser);
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"PFUser updated successfully");
                }
                else {
                    NSLog(@"Update Failed. Error: %@", error.localizedDescription);
                }
            }];
            //create a message thread for new match
            PFObject *messageThread = [PFObject objectWithClassName:@"MessageThread"];
            NSMutableArray *matchedUsers = [[NSMutableArray alloc] init];
            [matchedUsers addObject:currentUser];
            [matchedUsers addObject:matchedUser];
            messageThread[@"users"] = matchedUsers;
            messageThread[@"messages"] = [[NSMutableArray alloc] init];
            [messageThread saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    NSLog(@"The messageThread was saved!");
                } else {
                    NSLog(@"Problem saving messageThread: %@", error.localizedDescription);
                }
            }];
        }
        else {
            NSLog(@"User did not add matched user");
        }
    }
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }

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
            NSLog(@"count before calc: %d", count);
            NSLog(@"length before calc: %lu", (unsigned long)interestLengthOfI);
            NSLog(@"calc before calc: %f", (float)count/(float)interestLengthOfI);
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
            if ([obj1 objectAtIndex:1] > [obj2 objectAtIndex:1]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if ([obj1 objectAtIndex:1] < [obj2 objectAtIndex:1]) {
                return (NSComparisonResult)NSOrderedAscending;
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
    }
    for (PFUser *user in users){
        if ([usersOrdered containsObject:user.objectId]){
            [returnedUsers addObject:user];
        }
        
    }
    return returnedUsers;
}

@end
