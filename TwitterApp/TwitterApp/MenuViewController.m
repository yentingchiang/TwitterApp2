//
//  MenuViewController.m
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/5.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"
#import "MenuCell.h"
#import "UserCell.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource, TweetsViewControllerDelegate, MentionsViewControllerDelegate, UserCellDelegate, ProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *timelineTap;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TweetsViewController *tweetsVC;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (strong, nonatomic) MentionsViewController *mentionsVC;
@property (strong, nonatomic) UINavigationController *tweetsNVC;
@property (strong, nonatomic) UINavigationController *profileNVC;
@property (strong, nonatomic) UINavigationController *mentionsNVC;
//@property (strong, nonatomic) UINavigationController *tweetsNC;

@property (strong, nonatomic) NSArray *menuData;

@property (nonatomic, strong) User *user;

@property (nonatomic) BOOL menuOn;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.user = [User currentUser];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // home timeline
    self.tweetsNVC = [storyboard instantiateViewControllerWithIdentifier:@"tweetsNVC"];
    self.tweetsVC = [[self.tweetsNVC viewControllers] firstObject];
    self.tweetsVC.delegate = self;
    
    // profile
    self.profileNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNVC"];
    self.profileVC = [[self.profileNVC viewControllers] firstObject];
    self.profileVC.delegate = self;
    
    // mentions timeline
    self.mentionsNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mentionsNVC"];
    self.mentionsVC = [[self.mentionsNVC viewControllers] firstObject];
    self.mentionsVC.delegate = self;
    
    
    // set main vc
    [self displayViewContorller:self.profileNVC];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    
    self.menuData =
        [NSArray arrayWithObjects:@"Profile", @"Home Timeline", @"Mentions", @"Logout", nil];
    
    self.menuOn = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View

- (void)viewDidLayoutSubviews {
    self.menuView.frame = CGRectMake(-200, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    //self.menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    //self.tableView.backgroundView = self.menuView;
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"viewDidDisapper");
}


- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    NSLog(@"didMoveToParentViewController");
    
}


- (void)willMoveToParentViewController:(UIViewController *)parent {
    
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.user.
    if (section == 0) {
        return 1;
    } else {
        return  self.menuData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0 ) {
       UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
        // profile image
        [cell.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
        cell.usernameLabel.text = self.user.name;
        cell.screennameLabel.text = self.user.screenname;
        cell.delegate = self;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
        
    } else {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
        
        NSString *menuString = self.menuData[indexPath.row];
        cell.menuTextLabel.text = menuString;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1 ) {
        
        NSString *menuString = self.menuData[indexPath.row];
        NSLog(@"%@", menuString);
        
        [self changeContainer:menuString];
        self.menuOn = NO;
        [self swipeMenuAction:NO];
    }
    
}

- (void)changeContainer:(NSString *)menuString{
    
    if ([menuString isEqualToString:@"Profile"]) {
        self.profileNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNVC"];
        self.profileVC = [[self.profileNVC viewControllers] firstObject];
        self.profileVC.user = self.user;
        [self displayViewContorller:self.profileNVC];
    } else if ([menuString isEqualToString:@"Home Timeline"]) {
        [self displayViewContorller:self.tweetsNVC];
    } else if ([menuString isEqualToString:@"Mentions"]) {
        [self displayViewContorller:self.mentionsNVC];
    } else if ([menuString isEqualToString:@"Logout"]) {
        [self logout];
    }
}

- (IBAction)didTapTabButton:(UIButton *)sender {
    
    if (sender == self.timelineTap) {
        [self displayViewContorller:self.tweetsNVC];
        
    }
}


- (void)displayViewContorller:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void) addChildViewController:(UIViewController *)childController {
   
}

-(void)logout {
   
    [User logout];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - swipe gesture

- (IBAction)swipeMenu:(id)sender {
    
    UISwipeGestureRecognizer *recognizer = sender;
    
    switch (recognizer.direction) {
            
        case UISwipeGestureRecognizerDirectionRight:
            //self.menuView.hidden = NO;
            NSLog(@"right");
            //self.menuView.hidden = NO;
            self.menuOn = YES;
            [self swipeMenuAction:YES];
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            //self.menuView.hidden = YES;
            NSLog(@"left");
            //self.menuView.hidden = YES;
            self.menuOn = NO;
            [self swipeMenuAction:NO];
            break;
            
        default:
            break;
    }
}

-(void)swipeMenuAction:(BOOL)on{
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
        if (on) {
            self.menuView.frame = CGRectMake(0, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
            self.containerView.frame = CGRectMake(200, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        } else {
            self.menuView.frame = CGRectMake(-200, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
            self.containerView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        }
    } completion:nil];

}

#pragma mark - ProfileViewControllerDelegate

- (void)ProfileViewController:(ProfileViewController*)profileViewController didClickMenu:(BOOL)menuOn {
    self.menuOn = menuOn;
    [self swipeMenuAction:menuOn];
}

- (BOOL)ProfileViewController:(ProfileViewController*)profileViewController getMenuStatus:(BOOL)status {
    return self.menuOn;
}

#pragma mark - MentionsViewControllerDelegate

- (void)MentionsViewController:(MentionsViewController*)mentionsViewController didClickMenu:(BOOL)menuOn {
    self.menuOn = menuOn;
    [self swipeMenuAction:menuOn];
}

- (BOOL)MentionsViewController:(MentionsViewController*)MentionsViewController getMenuStatus:(BOOL)status {
    return self.menuOn;
}

#pragma mark - TweetsViewControllerDelegate

- (void)TweetsViewController:(TweetsViewController *)tweetsViewController didClickMenu:(BOOL)menuOn {
    self.menuOn = menuOn;
    [self swipeMenuAction:menuOn];
}


- (BOOL)TweetsViewController:(TweetsViewController*)tweetsViewController getMenuStatus:(BOOL)status {
    return self.menuOn;
}


- (void)TweetsViewContorller:(TweetsViewController *)tweetsViewController didChangedVC:(User*)user{
    

    NSLog(@"didChangedVC home timeline");
    
    self.profileNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNVC"];
    self.profileVC = [[self.profileNVC viewControllers] firstObject];
    self.profileVC.user = user;
    [self displayViewContorller:self.profileNVC];
    self.menuOn = NO;
    [self swipeMenuAction:NO];

}

#pragma mark - MentionsViewControllerDelegate

- (void)MentionsViewController:(MentionsViewController *)mentionsViewController didChangedVC:(User *)user {
    
    NSLog(@"didChangedVC from memtions timeline");
    
    self.profileNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNVC"];
    self.profileVC = [[self.profileNVC viewControllers] firstObject];
    self.profileVC.user = user;
    [self displayViewContorller:self.profileNVC];
    self.menuOn = NO;
    [self swipeMenuAction:NO];
}

#pragma mark - UserCellDelegate

- (void)UserCell:(UserCell *)cell onProfileImage:(BOOL)animated {
    
    NSLog(@"onProfileImage");
    
    User *user= [User currentUser];
    self.profileNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNVC"];
    self.profileVC = [[self.profileNVC viewControllers] firstObject];
    self.profileVC.user = user;
    
    [self displayViewContorller:self.profileNVC];
   
    self.menuOn = NO;
    [self swipeMenuAction:NO];

    /*
    self.profileNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileNVC"];
    self.profileVC = [[self.profileNVC viewControllers] firstObject];
    self.profileVC.user = user;
    [self displayViewContorller:self.profileNVC];
     */
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
