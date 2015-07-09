//
//  AppDelegate.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    [[TwitterClient sharedInstance] openURL:url];
    
    /*
    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST"  requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        
        
        TwitterClient *client = [TwitterClient sharedInstance];
       
        NSLog(@"got the access token!");
        
        [client.requestSerializer saveAccessToken:accessToken];
      
        [client GET:@"1.1/account/verify_credentials.json" parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"current user: %@", responseObject);
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            
            NSLog(@"current user: %@", user.name);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"failed getting current user!");
        }];
       
       
        NSLog(@"********************************************");
        
        [client GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //NSLog(@"tweets: %@", responseObject);
            
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            for (Tweet *tweet in tweets) {
                NSLog(@"tweet: %@, created: %@", tweet.text, tweet.createdAt);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error get tweets");
        }];
        
       //[[TwitterClient sharedInstance] GET:@"1.1/account/]
        
        
    } failure:^(NSError *error) {
       
        NSLog(@"failed to get the access token!");
    }];
   //[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token"
     */
    return YES;
     
}

@end
