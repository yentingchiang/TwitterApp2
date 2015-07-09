//
//  TwitterClient.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString *const twitterConsumerKey = @"6lvLN86Gz3kOGsSpEH2KUUO2G";
NSString *const twitterConsumerSecret = @"CrfuBjMMzDyPQ3mMUBkvNblNVMkKn3Ik3rSlZ4UuJxAJzJPED3";
NSString *const twitterBaseUrl = @"https://api.twitter.com";


@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
   
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        
        NSURL *baseUrl = [[NSURL alloc]initWithString:twitterBaseUrl];
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:baseUrl consumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"timtwitterapp://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        
        
        NSLog(@"got the request token!!!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
 
        
    } failure:^(NSError *error) {
       NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];
}


- (void)openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST"  requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        
        NSLog(@"got the access token!");
        
        [self.requestSerializer saveAccessToken:accessToken];
      
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"current user: %@", responseObject);
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            
            [User setCurrentUser:user];
            
            NSLog(@"current user: %@", user.name);
            
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"failed getting current user!");
            
            self.loginCompletion(nil, error);

        }];
       
      
        /*
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
         */
        
       //[[TwitterClient sharedInstance] GET:@"1.1/account/]
        
        
    } failure:^(NSError *error) {
       
        NSLog(@"failed to get the access token!");
    }];
}


- (void)homeTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
  
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSLog(@"fetch hometimeline");
        NSArray * tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}

- (void)getTweetByIDWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *result, NSError *error))completion {
  
    [self GET:@"1.1/statuses/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSLog(@"get tweet");
        completion(responseObject, nil);
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}

- (void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *result, NSError *error))completion {
    
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //NSArray * tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"post tweet");
        completion(responseObject, nil);
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}


- (void)postReTweetWithParams:(NSDictionary *)params withAction:(NSString *)action completion:(void (^)(NSDictionary *result, NSError *error))completion {
  
    //https://api.twitter.com/1.1/statuses/retweet/:id.json
   
    NSString *reTweetUri = [NSString stringWithFormat:@"1.1/statuses/%@/%@.json", action, params[@"id"]];
    
    NSLog(@"ret tweet uri: %@", reTweetUri);
    
    [self POST:reTweetUri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //NSArray * tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"ret tweet");
        completion(responseObject, nil);
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}




- (void)postFavoritesWithParams:(NSDictionary *)params withAction:(NSString *)action completion:(void (^)(NSDictionary *result, NSError *error))completion {
    
    //https://api.twitter.com/1.1/favorites/create.json
    
    
    NSString *uri = [NSString stringWithFormat:@"1.1/favorites/%@.json", action];
    
    [self POST:uri parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //NSArray * tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"post favorite tweet");
        completion(responseObject, nil);
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}

- (void)userTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSLog(@"fetch usertimeline");
        
        NSLog(@"%@" ,responseObject);
        
        NSArray * tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}

- (void)mentionsTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSLog(@"fetch mentionsTimeline");
        NSArray * tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        completion(nil, error);
    }];
}

@end
