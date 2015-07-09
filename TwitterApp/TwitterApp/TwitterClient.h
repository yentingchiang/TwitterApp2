//
//  TwitterClient.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;


- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void)openURL:(NSURL *)url;

- (void)homeTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)getTweetByIDWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)postFavoritesWithParams:(NSDictionary *)params withAction:(NSString *)action completion:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)postReTweetWithParams:(NSDictionary *)params withAction:(NSString *)action completion:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)userTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)mentionsTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
@end

