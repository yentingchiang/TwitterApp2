//
//  DetailViewController.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/30.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "DetailViewController.h"
#import "PostViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "DetailCell.h"
#import "ActionCell.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource, ActionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0 ) {
        
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"  forIndexPath:indexPath];
        Tweet *tweet = self.tweet;
        
        // profile image
        [cell.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
        
        NSLog(@"%@", tweet.user.profileImageUrl);
    
        cell.profileImage.layer.cornerRadius = 3;
        cell.profileImage.clipsToBounds = YES;

        cell.usernameLabel.text = tweet.user.name;
        cell.screennameLabel.text = tweet.user.screenname;
        cell.contentLabel.text = tweet.text;
        NSString *dateStr = [self getDateString:tweet.createdAt];
        cell.createdAtLabel.text = dateStr;
    
        return cell;
        
    } else if (indexPath.section == 1) {
        
        ActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"  forIndexPath:indexPath];
        cell.delegate = self;
        
        if (self.tweet.favorited > 0) {
            [cell.addFavoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
        } else {
            
            [cell.addFavoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        }
        
        
        if (self.tweet.reTweeted > 0) {
            [cell.reTweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
        } else {
            
            [cell.reTweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
    
   
    return nil;
}

- (NSString *)getDateString:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (int)ActionCell:(ActionCell *)cell getActionStatus:(NSString*)action {
   
    int status = 0;
    
    if ([action isEqualToString:@"addFavorite"]) {
       status =  self.tweet.favorited;
    } else if ([action isEqualToString:@"reTweet"]) {
       status = self.tweet.reTweeted;
    }
   
    return status;
}

- (void)ActionCell:(ActionCell *)cell didUpdateAction:(NSString*)action {
   
    NSLog(@"%@", action);
    
    if ([action isEqualToString:@"addFavorite"]) {
        
        NSLog(@"id: %@", self.tweet.tweetID);
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweet.tweetID, @"id", nil];
       
        if (self.tweet.favorited == 0) {
            [[TwitterClient sharedInstance] postFavoritesWithParams:params withAction:@"create" completion:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
        } else {
            [[TwitterClient sharedInstance] postFavoritesWithParams:params withAction:@"destroy" completion:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
            
        }
        self.tweet.favorited = self.tweet.favorited > 0 ? 0: 1;
        
    } else if([action isEqualToString:@"reTweet"])  {
        
        NSLog(@"id: %@", self.tweet.tweetID);
       
        if (self.tweet.reTweeted == 0) {
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweet.tweetID, @"id", nil];
            [[TwitterClient sharedInstance] postReTweetWithParams:params withAction:@"retweet" completion:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    Tweet *retweet = [[Tweet alloc] initWithDictionary:result];
                    self.tweet.reTweetID = retweet.tweetID;
                }
            }];
        } else {
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweet.reTweetID, @"id", nil];
            [[TwitterClient sharedInstance] postReTweetWithParams:params withAction:@"destroy" completion:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
        }
        
        self.tweet.reTweeted = self.tweet.reTweeted > 0 ? 0: 1;
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navVC = segue.destinationViewController;
    PostViewController *post = (PostViewController*)navVC.topViewController;
    post.replyUser = self.tweet.user;
    post.replyTweetID = self.tweet.tweetID;
}

@end
