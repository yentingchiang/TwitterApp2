//
//  ActionCell.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/1.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "ActionCell.h"

@implementation ActionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
   [super prepareForReuse]; 
    self.replyTweetButton = nil;
    self.addFavoriteButton = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReTweet:(UIButton *)sender {
   
    int status = [self.delegate ActionCell:self getActionStatus:sender.titleLabel.text];
    
    if (status > 0) {
        [sender setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    }
        
    [self.delegate ActionCell:self didUpdateAction:sender.titleLabel.text];
}


- (IBAction)onAddFavorite:(UIButton *)sender {
    
    int status = [self.delegate ActionCell:self getActionStatus:sender.titleLabel.text];
    
    if (status > 0) {
        [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    }
    
    [self.delegate ActionCell:self didUpdateAction:sender.titleLabel.text];
}

- (IBAction)onReplyTweet:(UIButton *)sender {
    
    [self.delegate ActionCell:self didUpdateAction:sender.titleLabel.text];
}


@end
