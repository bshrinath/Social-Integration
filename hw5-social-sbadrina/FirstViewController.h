//
//  FirstViewController.h
//  hw5-social-sbadrina
//
//  Created by Shrinath on 6/25/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *modelAndVersion;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (strong, nonatomic) NSString *postString;

@end
