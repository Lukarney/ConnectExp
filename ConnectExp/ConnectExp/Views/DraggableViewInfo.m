//
//  DraggableViewInfo.m
//  ConnectExp
//
//  Created by Luke Arney on 7/22/21.
//

#import "DraggableViewInfo.h"
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
        // fetch data asynchronously
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                // do something with the array of object returned by the call
                self.exampleCardLabels = (NSMutableArray *) users;
                loadedCards = [[NSMutableArray alloc] init];
                self.allCards = [[NSMutableArray alloc] init];
                cardsLoadedIndex = 0;
                NSLog(@"list :%@", self.exampleCardLabels);
                [self loadCards];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
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

#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    PFUser *user = self.exampleCardLabels[index];
    draggableView.userPointer = user;
    draggableView.information.text = user[@"username"];
    if(user[@"image"] != nil){
        PFFileObject *image = user[@"image"];
        NSURL *imageURL = [NSURL URLWithString:image.url];
        [draggableView.picture setImageWithURL:imageURL];
    }
    
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
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
-(void)cardSwipedRight:(UIView *)card
{
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
    
    //[PFUser.currentUser addObject:<#(nonnull id)#> forKey:<#(nonnull NSString *)#>];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }

}
- (NSMutableDictionary *)getMatchesV1:(NSInteger *)N
                     listOfIds:(NSMutableArray *)M
          InterestInDictionary:(NSMutableDictionary *)IID
{
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    for (id key in IID)
    {
        IID[key] = [NSMutableSet setWithArray:IID[key]];
        res[key] = [[NSMutableArray alloc] init];
    }
    for (NSInteger i = 0; i < N; i++ )
    {
        NSInteger *interestLengthOfI = [IID[(id *)i] count];
        for (NSInteger j = i+1; i < N; i++)
        {
            NSInteger *interestLengthOfJ = [IID[(id *)j] count];
            NSInteger *count = 0;
            for (NSString *interest in IID[i])
            {
                if (interest in IID[j])
                {
                    count += 1;
                }
            }
            [res[i] addObject:@(j,count/interestLengthOfI)];
            [res[j] addObject:@(i,count/interestLengthOfJ)];
        }
    }
    for (id key in res)
    {
        //find out how to sort by the number
        res[key] = [res[key] sortedArray]
    }
    return res;
        
}

//%%% when you hit the right button, this is called and substitutes the swipe
//-(void)swipeRight
//{
//    DraggableView *dragView = [loadedCards firstObject];
//    dragView.overlayView.mode = GGOverlayViewModeRight;
//    [UIView animateWithDuration:0.2 animations:^{
//        dragView.overlayView.alpha = 1;
//    }];
//    [dragView rightClickAction];
//}
//
////%%% when you hit the left button, this is called and substitutes the swipe
//-(void)swipeLeft
//{
//    DraggableView *dragView = [loadedCards firstObject];
//    dragView.overlayView.mode = GGOverlayViewModeLeft;
//    [UIView animateWithDuration:0.2 animations:^{
//        dragView.overlayView.alpha = 1;
//    }];
//    [dragView leftClickAction];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

