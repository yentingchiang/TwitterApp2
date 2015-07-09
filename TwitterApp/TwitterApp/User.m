//
//  User.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"


@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        self.dictionary = dictionary;
        self.name =  dictionary[@"name"];
        self.screenname  =  dictionary[@"screen_name"];
        self.profileImageUrl =  dictionary[@"profile_image_url"];
        self.tagLine =  dictionary[@"description"];
        
        self.tweetCount = (int)[dictionary[@"statuses_count"] integerValue];
        self.followerCount = (int)[dictionary[@"followers_count"] integerValue];
        self.friendCount = (int)[dictionary[@"friends_count"] integerValue];
        
        self.backgroundImageUrl = dictionary[@"profile_background_image_url"];
        
    }
    
    return self;
}


static User *_currentUser = nil;


NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
 
    if (_currentUser == nil ) {
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if ( data != nil ) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}


+ (void)setCurrentUser:(User *)currentUser {

    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        
    } else  {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    
    [User setCurrentUser:nil];
    
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
}

@end
