//
//  SecondViewController.m
//  hw5-social-sbadrina
//
//  Created by Shrinath on 6/25/16.
//  Copyright © 2016 cmu. All rights reserved.
//
//  Modified from code reference: http://www.techotopia.com/index.php/An_iOS_7_Twitter_Integration_Tutorial_using_SLRequest

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getTweetTimeline];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tweetTimeline
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tweet = _sourceArray[[indexPath row]];
    
    NSDictionary *entity = [tweet objectForKey:@"entities"];
    NSArray *media = [entity objectForKey:@"media"];
    NSDictionary *media1 = [media objectAtIndex:0];
    NSString *media_url = [media1 objectForKey:@"media_url_https"];
    
    NSLog(@"%@", media_url);
    
    /*
                 if([[[tweet objectForKey:@"entities"] allKeys] containsObject:@"media"])
                     
                 {
                     if([[tweet objectForKey:@"entities"] objectForKey:@"media"] != nil)
                     {
                     NSDictionary *tweetDict = [[tweet objectForKey:@"entities"] objectForKey:@"media"];
                    
                         str = tweetDict;
                         
                         //NSLog(@"%@", str);
                         
                         
                     }
                 }
    
    //NSLog(@"hello");
    */
    
    //NSLog(@"%@",hash);
   // NSLog(@"%@", hashtag[1]);
   // NSLog(@"%@", hashtag[2]);
   // NSLog(@"%@", hashtag[3]);
   // NSLog(@"%@", hashtag[4]);
    // NSLog(@"%@", hashtag[5]);
    
    cell.textLabel.text = tweet[@"text"];
    
    return cell;
}

- (void)getTweetTimeline {
    
    ACAccountStore *twitterAccount = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterAccountType = [twitterAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [twitterAccount requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         
         
         NSArray *accountArray = [twitterAccount accountsWithAccountType:twitterAccountType];
         
         if(granted)
         {
             if([accountArray count] == 0)
             {
                 NSLog(@"No Twitter Account setup.");
                 UIAlertView *noAccountAlert = [[UIAlertView alloc] initWithTitle:@"Setup Twitter Account"
                                                                          message:@"You need to setup atleast one Twitter account in your Settings menu."
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                 
                 [noAccountAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
             }//if
             
             else if([accountArray count] > 0)
             {
                 
                 ACAccount *twitterAccounts = [accountArray lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:
                                      @"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSDictionary *parameters =
                 @{@"screen_name" : @"@twittibyrde",
                   @"include_rts" : @"0",
                   @"exclude_replies" : @"0",
                   @"include_entities" : @"1",
                   @"trim_user" : @"1",
                   @"count" : @"100"};
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccounts;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      self.sourceArray = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      
                      if (self.sourceArray.count != 0)
                      {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tweetTimeline reloadData];
                          });
                      }
                  }];
             }//else if

         }
         
     }];
}

@end
