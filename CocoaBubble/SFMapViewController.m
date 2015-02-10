//
//  SFMapViewController.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFMapViewController.h"
#import "SFNetworkingManager.h"
#import "SFApiAccess.h"

@interface SFMapViewController ()

@end

NSString* kControllerTitle = @"Explore";

BOOL hasUpdated = NO;

@implementation SFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.title = kControllerTitle;

    // Setup the refresh button
    UIImage* refreshImage = [UIImage imageNamed:@"refresh62.png"];
    CGRect frame = CGRectMake(0,0,32,32);
    UIButton* barItem = [[UIButton alloc] initWithFrame:frame];
    [barItem setBackgroundImage:refreshImage forState:UIControlStateNormal];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:barItem];
    [item setAction:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = item;

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;

    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation = YES;

    // Should probably zoom in too because there is no reason to be staring at the entire country
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(37.7833,-122.4167); // start in SF!!!
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, .05, .05)];
    [self.mapView setRegion:adjustedRegion animated:YES];

}

-(void)refresh:(id)sender {

    hasUpdated = false;
    [self.locationManager startUpdatingLocation];

}
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    if (!hasUpdated) {
        [self showPlaces:[locations lastObject]];
        hasUpdated = YES;
        [self.locationManager stopUpdatingLocation];
    }
}

- (IBAction)zoomIn:(id)sender {

}

- (IBAction)changeMapType:(id)sender {

}

- (void)mapView:(MKMapView *)mapView
        didUpdateUserLocation:
                (MKUserLocation *)userLocation {
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

-(void)showPlaces:(CLLocation *)currentLocation {


    //currentLocation.coordinate.latitude
    [SFApiAccess searchWithLatitude:currentLocation.coordinate.latitude
                          longitude:currentLocation.coordinate.longitude
                   finishedDelegate:^(NSArray* locations, NSError* error) {

                       if (error) {
                           // Bad news bears!
                       }

                       if (locations) {

                           // NSArray of SFPlaces
                           // Create dots on map
                           // dots are collapsed thoughtbubbles
                           [self.mapView addAnnotations:locations];
                       }

    }];


}


@end
