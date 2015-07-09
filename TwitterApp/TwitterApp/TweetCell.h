//
//  TweetCell.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/30.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)TweetCell:(TweetCell *)cell didUpdateAction:(NSString*)action;
- (int)TweetCell:(TweetCell *)cell getActionStatus:(NSString*)action;
- (void)TweetCell:(TweetCell *)cell setCell:(BOOL)required;

@optional
- (void)TweetCell:(TweetCell *)cell onProfileImage:(BOOL)animated;


@end

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ceatedAtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *reTweetButton;
@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;

@end
