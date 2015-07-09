//
//  ProfileViewController.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/6.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ProfileHeaderCell.h"
#import <SVProgressHUD.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TweetCell *nowCell;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Profile";
    
    UIImage *menuImage = [UIImage imageNamed:@"simpleMenuButton.png"];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(onSwipeMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // add new button
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onPost)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (void)onSwipeMenu{

    BOOL status = [self.delegate ProfileViewController:self getMenuStatus:YES];
    [self.delegate ProfileViewController:self didClickMenu:!status];
}

- (void)onPost {
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"postNVC"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)onLogout {
    
    [User logout];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self presentViewController:controller animated:YES completion:nil];
}



- (void)loadUserTimeLineData {
    
    NSLog(@"load ************* data");
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.screenname, @"screen_name", @"1", @"include_rts", nil];
    
    [SVProgressHUD show];
    [[TwitterClient sharedInstance] userTimeLineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.tweets = tweets;
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }];
    
}

- (void)initUser {
    
    if (self.user == nil) {
        self.user = [User currentUser];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"********* viewWillAppear ");
}

- (void)viewDidAppear:(BOOL)animated {
  
    [self initUser];
    [self loadUserTimeLineData];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    
    NSLog(@"********* viewDidAppear ");
    NSLog(@"********* %@", self.user.name);
    
    [self.tableView reloadData];
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"11111");
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"222222");
}


- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)TweetCell:(TweetCell *)cell getActionStatus:(NSString*)action {
    
    int status = 0;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    
    if ([action isEqualToString:@"addFavorite"]) {
        status =  tweet.favorited;
    } else if ([action isEqualToString:@"reTweet"]) {
        status = tweet.reTweeted;
    }
    
    return status;
}

- (void)TweetCell:(TweetCell *)cell didUpdateAction:(NSString *)action {
    
    NSLog(@"%@", action);
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    
    if ([action isEqualToString:@"addFavorite"]) {
        
        NSLog(@"id: %@", tweet.tweetID);
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:tweet.tweetID, @"id", nil];
        
        if (tweet.favorited == 0) {
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
        tweet.favorited = tweet.favorited > 0 ? 0: 1;
        
    } else if([action isEqualToString:@"reTweet"])  {
        
        NSLog(@"id: %@", tweet.tweetID);
        
        if (tweet.reTweeted == 0) {
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:tweet.tweetID, @"id", nil];
            [[TwitterClient sharedInstance] postReTweetWithParams:params withAction:@"retweet" completion:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    Tweet *retweet = [[Tweet alloc] initWithDictionary:result];
                    tweet.reTweetID = retweet.tweetID;
                }
            }];
        } else {
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:tweet.reTweetID, @"id", nil];
            [[TwitterClient sharedInstance] postReTweetWithParams:params withAction:@"destroy" completion:^(NSDictionary *result, NSError *error) {
                NSLog(@"%@", result);
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
        }
        
        tweet.reTweeted = tweet.reTweeted > 0 ? 0: 1;
    }
}

- (void)TweetCell:(TweetCell *)cell setCell:(BOOL)required {
    self.nowCell = cell;
}

/*
- (void)TweetCell:(TweetCell *)cell onProfileImage:(BOOL)animated {
    
    NSLog(@"onProfileImage");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    User *user= tweet.user;
    [self.delegate TweetsViewContorller:self didChangedVC:user];
}
 */




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.user.
    //return  self.tweets.count;
    if (section == 0 ) {
        return 1;
    } else {
        return self.tweets.count;
    }
        
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if (indexPath.section == 0 ) {
        
        ProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderCell" forIndexPath:indexPath];
        
        // profile image
        [cell.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
        
        cell.usernameLabel.text = self.user.name;
        cell.screennameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
        cell.tweetsNumberLabel.text  = [NSString stringWithFormat:@"%d", self.user.tweetCount];
        cell.followerNumberLabel.text  = [NSString stringWithFormat:@"%d", self.user.followerCount];
        cell.followingNumberLabel.text  = [NSString stringWithFormat:@"%d", self.user.friendCount];
        [cell.backgroundImage setImageWithURL:[NSURL URLWithString:self.user.backgroundImageUrl]];
        
        return cell;
    } else {
        
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
        
        Tweet *tweet = self.tweets[indexPath.row];
        
        
        // profile image
        [cell.profileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
        
        cell.usernameLabel.text = tweet.user.name;
        cell.contentLabel.text = tweet.text;
        NSString *dateStr = [self getDateString:tweet.createdAt];
        cell.ceatedAtLabel.text = dateStr;
        
        
        cell.delegate = self;
        
        
        if (tweet.favorited > 0) {
            [cell.addFavoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
        } else {
            
            [cell.addFavoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        }
        
        
        if (tweet.reTweeted > 0) {
            [cell.reTweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
        } else {
            
            [cell.reTweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
        
}

- (NSString *)getDateString:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSLog(@"TTTTTTT");
    
}

@end
