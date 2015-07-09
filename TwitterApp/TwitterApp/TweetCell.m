//
//  TweetCell.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/30.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
    
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage)];
    singleTap.numberOfTapsRequired = 1;
    [self.profileImage setUserInteractionEnabled:YES];
    [self.profileImage addGestureRecognizer:singleTap];

}

-(void)tapProfileImage{
    NSLog(@"Tap profile image");
   [self.delegate TweetCell:self onProfileImage:YES];
   
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.reTweetButton = nil;
    self.addFavoriteButton = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
}



- (IBAction)onClick:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    int status = [self.delegate TweetCell:self getActionStatus:button.titleLabel.text];
    
    if (status > 0) {
        
        if ([button.titleLabel.text isEqualToString:@"addFavorite"]) {
            [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        } else {
            [sender setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
        }
    } else {
        if ([button.titleLabel.text isEqualToString:@"addFavorite"]) {
            [sender setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
        } else {
            [sender setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
        }
    }
    
    [self.delegate TweetCell:self didUpdateAction:button.titleLabel.text];
    
}
- (IBAction)onReply:(id)sender {
    [self.delegate TweetCell:self setCell:YES];
}

@end
