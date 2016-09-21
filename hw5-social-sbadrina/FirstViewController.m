//
//  FirstViewController.m
//  hw5-social-sbadrina
//
//  Created by Shrinath on 6/25/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import "FirstViewController.h"
#import "Reachability.h"

@interface FirstViewController ()

@end

NSString *stringToTweet;
long output;

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [formatter setLocale:posix];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    NSDate *currentTimestamp = [NSDate date];
    
    NSString *prettyDate = [formatter stringFromDate:currentTimestamp];
    
    NSString *deviceType = [[UIDevice currentDevice] model];
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *final = [deviceType stringByAppendingString:@" "];
    final = [final stringByAppendingString:OSVersion];
    
    self.timeStamp.text = prettyDate;
    self.modelAndVersion.text = final;
    
    
    stringToTweet = [@"@MobileApp4 " stringByAppendingString:@"[sbadrina] "];
    stringToTweet = [stringToTweet stringByAppendingString:final];
    stringToTweet = [stringToTweet stringByAppendingString:@" "];
    stringToTweet = [stringToTweet stringByAppendingString:prettyDate];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToTweet:(id)sender {
    
    ACAccountStore *twitterAccount = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterAccountType = [twitterAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [twitterAccount requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         //NSLog(@"%@",error);
         
         NSArray *accountArray = [twitterAccount accountsWithAccountType:twitterAccountType];
         
         Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
         NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
         if (networkStatus == NotReachable) {
             NSLog(@"Network connection not available");
             UIAlertView *noAccountAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                      message:@"Network connection is not available. Check your internet settings."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
             
             [noAccountAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

         } //no network
         
         
         else {
         
         
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
         }
         
         else if([accountArray count] > 0)
         {
             
                 ACAccount *twitterAccounts = [accountArray lastObject];
             
                 NSDictionary *post = @{@"status": stringToTweet};
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
                 
                 SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:post];
                 
                 postRequest.account = twitterAccounts;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@"Twitter HTTP response: %li",
                            (long)[urlResponse statusCode]);
                      output = [urlResponse statusCode];
                      
                      if(output == 200)
                      {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweeted"
                                                                          message:@"Your tweet has been posted."
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      
                      if(output == 403)
                      {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"403 Forbidden"
                                                                          message:@"You cannot post the same tweet again."
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      
                      if(output == 401)
                      {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unauthorized"
                                                                          message:@"Unauthorized - incorrect or missing credentials."
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      
                      if(output == 500)
                      {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"Internal Server Error"
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }

                      
                      

                  }];
             
         }//else if
         }//if granted
         
         else
         {   NSLog(@"Permission not granted!");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                             message:@"You have denied permission for this app to access your Twitter. Change this in the Settings menu."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             
             [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
         }//else
         
         } // if network
     } ];
}//pushToTweet

@end
