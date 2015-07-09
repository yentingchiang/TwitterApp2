//
//  TweetsViewController.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/6/28.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "TweetsViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>


@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource, PostViewControllerDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *tweets;

@property (strong,nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) TweetCell *nowCell;


- (NSString *)getDateString:(NSDate *)date;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadHomeTimeLineData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIImage *menuImage = [UIImage imageNamed:@"simpleMenuButton.png"];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(onSwipeMenu)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // add new button
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onPost)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.title = @"Home Timeline";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]init];
    [self.tableView addSubview:self.refreshControl];
    
}

- (void)addNavigationButton {
    
}

- (void)onSwipeMenu{
   
    BOOL status = [self.delegate TweetsViewController:self getMenuStatus:YES];
    [self.delegate TweetsViewController:self didClickMenu:!status];
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

- (void)viewWillAppear:(BOOL)animated {

    [self.tableView reloadData];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
   
    NSLog(@"ccccc");
}

- (void)loadHomeTimeLineData {
  
    NSLog(@"load ************* data");
    
    [SVProgressHUD show];
    [[TwitterClient sharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.tweets = tweets;
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }];
    
}

- (void)handleRefresh:(UIRefreshControl *) refreshControl{
    [self loadHomeTimeLineData];
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
}

- (void)refreshData {
    
    [self.refreshControl endRefreshing];
    //[self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLogout:(id)sender {
    [User logout];
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return self.user.
    return  self.tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
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

- (NSString *)getDateString:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

#pragma mark - PostViewControllerDelegate

- (void)postViewController:(PostViewController *)postViewController didPostTweet:(BOOL)update {
    
    [self loadHomeTimeLineData];
}


#pragma mark - TweetCellDelegate

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

- (void)TweetCell:(TweetCell *)cell onProfileImage:(BOOL)animated {
   
    NSLog(@"onProfileImage");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    User *user= tweet.user;
    [self.delegate TweetsViewContorller:self didChangedVC:user];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TweetCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
   
    NSString * segueID = segue.identifier;
    
    NSLog(@"segue id : %@", segueID);
  
    
    if ([segueID isEqualToString:@"Post"]) {
        UINavigationController *navVC = segue.destinationViewController;
        PostViewController *post = (PostViewController*)navVC.topViewController;
        post.delegate = self;
    } else if ([segueID isEqualToString:@"Reply"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.nowCell];
        Tweet *tweet = self.tweets[indexPath.row];
        
        UINavigationController *navVC = segue.destinationViewController;
        PostViewController *post = (PostViewController*)navVC.topViewController;
        post.delegate = self;
        post.replyUser = tweet.user;
        post.replyTweetID = tweet.tweetID;
        post.fromMain = 1;
        
    } else if ([segueID isEqualToString:@"Detail"]) {
        UINavigationController *navVC = segue.destinationViewController;
        DetailViewController *detail = (DetailViewController*)navVC.topViewController;
        detail.tweet = tweet;
    }
   
}

@end
