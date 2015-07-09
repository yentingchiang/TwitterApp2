//
//  Tweet.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject


@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *tweetID;
@property int favorited;
@property int reTweetCount;
@property int reTweeted;
@property (nonatomic, strong) NSString *reTweetID;


- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
