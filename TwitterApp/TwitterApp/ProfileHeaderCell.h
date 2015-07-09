//
//  ProfileHeaderCell.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/8.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
