//
//  ThreeViewController.m
//  hw5-social-sbadrina
//
//  Created by Shrinath on 6/25/16.
//  Copyright © 2016 cmu. All rights reserved.
//
//  Modified from code reference: https://github.com/ThornTechPublic/MapKitTutorialObjC

#import "ThirdViewController.h"
#import "LocationSearch.h"

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLPlacemark *placeMark;
@property (strong, nonatomic) CLLocation *nLoc;
@end

@implementation ThirdViewController

CLLocationManager *locationManager;
UISearchController *resultSearchController;
MKPlacemark *selectedPin;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestLocation];
    [locationManager requestWhenInUseAuthorization];
    
    _geoCoder = [[CLGeocoder alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LocationSearch *locationSearch = [storyboard instantiateViewControllerWithIdentifier:@"LocationSearch"];
    resultSearchController = [[UISearchController alloc] initWithSearchResultsController:locationSearch];
    resultSearchController.searchResultsUpdater = locationSearch;
    
    UISearchBar *searchPlaceBar = resultSearchController.searchBar;
    [searchPlaceBar sizeToFit];
    searchPlaceBar.placeholder = @"Search place";
    
    self.navigationItem.titleView = resultSearchController.searchBar;
    
    resultSearchController.hidesNavigationBarDuringPresentation = NO;
    resultSearchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    
    locationSearch.mapView = _mapView;
    
    locationSearch.handleMapSearchDelegate = self;
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:true];
}

- (void)dropPinZoomIn:(MKPlacemark *)placemark
{
    
    selectedPin = placemark;
    
    //Reverse Geocoding to get the whole address information
    
    [_geoCoder reverseGeocodeLocation:_nLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            _placeMark = [placemarks lastObject];
        }}];
    
    [_mapView removeAnnotations:(_mapView.annotations)];
    
    if(placemark == nil)
    {
        NSLog(@"Placemark object is nil");
    }
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = placemark.coordinate;
    annotation.title = placemark.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                           (placemark.subThoroughfare == nil ? @"" : placemark.subThoroughfare),
                           (placemark.thoroughfare == nil ? @"" : placemark.thoroughfare),
                           (placemark.locality == nil ? @"" : placemark.locality),
                           (placemark.administrativeArea == nil ? @"" : placemark.administrativeArea),
                           (placemark.postalCode == nil ? @"" : placemark.postalCode)
                           ];
    [_mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, span);
    [_mapView setRegion:region animated:true];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
    
        return nil;
    }
    
    static NSString *reuseId = @"pin";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        pinView.tintColor = [UIColor orangeColor];
    }
    
    else {
        pinView.annotation = annotation;
    }
   
    return pinView;
     
}
@end
