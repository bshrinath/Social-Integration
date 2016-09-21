//
//  ThreeViewController.h
//  hw5-social-sbadrina
//
//  Created by Shrinath on 6/25/16.
//  Copyright © 2016 cmu. All rights reserved.

#import <UIKit/UIKit.h>
@import MapKit;

@protocol HandleMapSearch <NSObject>
- (void)dropPinZoomIn:(MKPlacemark *)placemark;
@end

@interface ThirdViewController : UIViewController <CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate>

@end
