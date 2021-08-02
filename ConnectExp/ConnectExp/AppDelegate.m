//
//  AppDelegate.m
//  ConnectExp
//
//  Created by Luke Arney on 7/12/21.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"ledMwPW4gaZE2cv1JB1R3Jj7XbqhXq9i9orlhwBb";
        configuration.clientKey = @"r728IQGzOtHu5XBLXljLN3nb1IgKqnWs9QnWRo1k";
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)   application:(UIApplication *)application
  configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                                 options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

@end
