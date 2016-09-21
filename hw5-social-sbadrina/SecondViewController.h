//
//  SecondViewController.h
//  hw5-social-sbadrina
//
//  Created by Shrinath on 6/25/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tweetTimeline;

@property (strong, nonatomic) NSArray *sourceArray;

@end

