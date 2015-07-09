//
//  Common.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/8.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (Common *)sharedInstance;
+ (NSString *)getDateString:(NSDate *)date;

@end
