//
//  ProfileHeaderCell.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/8.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "ProfileHeaderCell.h"

@implementation ProfileHeaderCell

- (void)awakeFromNib {
    // Initialization code
    
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 3;
    self.profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
