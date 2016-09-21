//
//  LocationSearch.h
//  hw5-social-sbadrina
//
//  Created by Shrinath Badrinarayanan on 6/28/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
#import "ThirdViewController.h"

@interface LocationSearch : UITableViewController <UISearchResultsUpdating>
@property MKMapView *mapView;
@property id <HandleMapSearch>handleMapSearchDelegate;

@end
