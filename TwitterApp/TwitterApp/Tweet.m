//
//  Tweet.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/27.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
   
  
    self = [super init];
    if (self) {
       
        NSLog(@"%@", dictionary);
        
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        self.favorited = [dictionary[@"favorited"] intValue];
        self.reTweetCount = [dictionary[@"retweet_count"] intValue];
        self.reTweeted = [dictionary[@"retweeted"] intValue];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat  = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
        
        self.tweetID = dictionary[@"id_str"];
        //self.createdAt
    }
    
    return self;
}




+ (NSArray *)tweetsWithArray:(NSArray *)array {
   
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
       
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
    
}

@end
