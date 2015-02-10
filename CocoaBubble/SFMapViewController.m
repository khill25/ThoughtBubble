//
//  SFMapViewController.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFMapViewController.h"
#import "SFNetworkingManager.h"

@interface SFMapViewController ()

@end

BOOL hasUpdated = NO;

@implementation SFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.title = @"Map";
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;

    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation = YES;

    // Should probably zoom in too because there is no reason to be staring at the entire country
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(37.7833,-122.4167);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, .05, .05)];
    [self.mapView setRegion:adjustedRegion animated:YES];

}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"%@", [locations lastObject]);


    if (!hasUpdated) {
        [self showPlaces:[locations lastObject]];
        hasUpdated = YES;
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


    NSString* location = [NSString stringWithFormat:@"location=%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    NSString* baseUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?%@&keyword=", location];
    NSString* queryTerms = @"coffee+shops+hacker+spaces";

    // The authkey here is super janky but this is still a work in progress.
    NSString* authKey = @"AIzaSyBDZYf-1dMAoIY9bAzP1jh-o-hzJxD0lbs";

    // Pull out the 1500 to a pref so the user can change it.
    NSString* formatted = [NSString stringWithFormat:@"%@%@&raduis=1500&key=%@", baseUrl, queryTerms, authKey];

    // Do network call
    [SFNetworkingManager postRequestWithUrl:formatted completionHandler:^(id response, NSError* error) {

        if (error) {
            NSLog(@"Error getting data from network. %@", error);
            [UIAlertController alertControllerWithTitle:@"Oops!" message:@"This is embarassing. We are having trouble getting nearby locations. Give it a second and try again." preferredStyle:UIAlertControllerStyleAlert];
        } else {
            // do some stuff with this data!!!
            NSDictionary *json = (NSDictionary*)response;
            // Parse it!
            [json valueForKey:@""];
            [json valueForKey:@""];
            [json valueForKey:@""];
            [json valueForKey:@""];
        }

        }
    ];


}


@end
