//
//  DetailViewController.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/30.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

@end
