//
//  PostViewController.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/30.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "PostViewController.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"


@interface PostViewController ()

@property (nonatomic, strong) User *user;


@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.user = [User currentUser];
    
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    
    self.usernameLabel.text = self.user.name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenname];
    
    if (self.replyUser) {
        
        self.inputText.text = [NSString stringWithFormat:@"@%@ ",self.replyUser.screenname];
        
    }
    
    [self.inputText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSend:(id)sender {
    
    NSString *input = self.inputText.text;
    NSLog(@"%@", input);
    NSDictionary *params;
   
    if (self.replyUser) {
        
        params = [[NSDictionary alloc] initWithObjectsAndKeys:input, @"status", self.replyTweetID, @"in_reply_to_status_id", nil];
        
    } else {
        
        params = [[NSDictionary alloc] initWithObjectsAndKeys:input, @"status", nil];
        
    }
    
    [[TwitterClient sharedInstance] postTweetWithParams:params completion:^(NSDictionary *result, NSError *error) {
        NSLog(@"%@", result);
        if (error) {
            NSLog(@"%@", error);
        } else {
            if (self.replyUser) {
                [self dismissViewControllerAnimated:YES completion:nil];
                if (self.fromMain > 0) {
                    [self.delegate postViewController:self didPostTweet:YES];
                }
            } else {
                [self.delegate postViewController:self didPostTweet:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
