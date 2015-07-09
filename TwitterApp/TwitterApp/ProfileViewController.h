//
//  ProfileViewController.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/6.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>

@optional
- (void)ProfileViewController:(ProfileViewController*)profileViewController didClickMenu:(BOOL)menuOn;
- (BOOL)ProfileViewController:(ProfileViewController*)profileViewController getMenuStatus:(BOOL)status;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;

@end
