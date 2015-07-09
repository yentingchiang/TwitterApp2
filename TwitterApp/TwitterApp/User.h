//
//  User.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic) int tweetCount;
@property (nonatomic) int followerCount;
@property (nonatomic) int friendCount;
@property (nonatomic, strong) NSString *backgroundImageUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;


+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

+ (void)logout;

@end
