//
//  UserCell.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/7.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
    
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage)];
    singleTap.numberOfTapsRequired = 1;
    [self.profileImage setUserInteractionEnabled:YES];
    [self.profileImage addGestureRecognizer:singleTap];

}


-(void)tapProfileImage{
    NSLog(@"Tap profile image");
    [self.delegate UserCell:self onProfileImage:YES];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
