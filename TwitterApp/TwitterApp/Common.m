//
//  Common.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/8.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "Common.h"

@implementation Common


+ (Common *)sharedInstance {
    
    static Common *instance = nil;
    
    if (instance == nil) {
        
        instance = [[Common alloc] init];
    }
    
    return instance;
}


+ (NSString *)getDateString:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

@end
