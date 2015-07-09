//
//  PostViewController.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/30.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class PostViewController;

@protocol PostViewControllerDelegate <NSObject>

- (void)postViewController:(PostViewController *)postViewController didPostTweet:(BOOL)update;

@end

@interface PostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputText;

@property (nonatomic, weak) id<PostViewControllerDelegate> delegate;


@property (nonatomic, strong) User *replyUser;
@property (nonatomic, strong) NSString *replyTweetID;

@property int fromMain;

@end
