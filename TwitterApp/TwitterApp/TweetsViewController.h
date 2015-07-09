//
//  TweetsViewController.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/28.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class TweetsViewController;

@protocol TweetsViewControllerDelegate <NSObject>

- (void)TweetsViewContorller:(TweetsViewController*)tweetsViewController didChangedVC:(User*)user;

@optional
- (void)TweetsViewController:(TweetsViewController*)tweetsViewController didClickMenu:(BOOL)menuOn;
- (BOOL)TweetsViewController:(TweetsViewController*)tweetsViewController getMenuStatus:(BOOL)status;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, weak) id<TweetsViewControllerDelegate> delegate;

@end
