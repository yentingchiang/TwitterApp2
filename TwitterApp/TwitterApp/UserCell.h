//
//  UserCell.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/7.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserCell;

@protocol UserCellDelegate <NSObject>

- (void)UserCell:(UserCell *)cell onProfileImage:(BOOL)animated;

@end

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@property (nonatomic, weak) id<UserCellDelegate> delegate;

@end
