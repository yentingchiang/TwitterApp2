//
//  ActionCell.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/1.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionCell;

@protocol ActionCellDelegate <NSObject>

- (void)ActionCell:(ActionCell *)cell didUpdateAction:(NSString*)action;
- (int)ActionCell:(ActionCell *)cell getActionStatus:(NSString*)action;

@end


@interface ActionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;

@property (nonatomic, weak) id<ActionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *replyTweetButton;
@property (weak, nonatomic) IBOutlet UIButton *reTweetButton;

@end
