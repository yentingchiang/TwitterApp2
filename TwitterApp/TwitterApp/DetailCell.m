//
//  DetailCell.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/1.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (void)awakeFromNib {
    // Initialization code
    
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
