//
//  MentionsViewController.h
//  TwitterApp
//
//  Created by Tim Chiang on 2015/7/8.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@class MentionsViewController;

@protocol MentionsViewControllerDelegate <NSObject>

- (void)MentionsViewController:(MentionsViewController*)mentionsViewController didChangedVC:(User*)user;

@optional
- (void)MentionsViewController:(MentionsViewController*)mentionsViewController didClickMenu:(BOOL)menuOn;
- (BOOL)MentionsViewController:(MentionsViewController*)MentionsViewController getMenuStatus:(BOOL)status;

@end

@interface MentionsViewController : UIViewController

@property (nonatomic, weak) id<MentionsViewControllerDelegate> delegate;

@end