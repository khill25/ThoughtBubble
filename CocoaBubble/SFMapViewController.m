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
#import "SFPlace.h"
#import "SFPerson.h"
#import "SFPlaceAnnotation.h"
#import "SFPersonAnnotation.h"

@interface SFMapViewController ()

@property NSMutableArray* visibleAnnotation;

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
    CGRect frame = CGRectMake(0,64,32,32);
    UIButton* barItem = [[UIButton alloc] initWithFrame:frame];
    [barItem setBackgroundImage:refreshImage forState:UIControlStateNormal];

    [barItem addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:barItem];

    //UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:barItem];
    //[item setTarget:self];
    //[item setAction:@selector(refresh:)];

    //self.navigationItem.rightBarButtonItem = item;

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;

    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    // Should probably zoom in too because there is no reason to be staring at the entire country
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(37.7833,-122.4167); // start in SF!!!
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, .05, .05)];
    [self.mapView setRegion:adjustedRegion animated:YES];

}

-(void)refresh:(id)sender {

    hasUpdated = false;
    //[self.locationManager startUpdatingLocation];
    [self showPlacesWithCoordinate:self.mapView.centerCoordinate];

}
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    if (!hasUpdated) {
        __weak SFMapViewController* weakSelf = self;
        dispatch_after(5000, dispatch_get_main_queue(), ^{
            [weakSelf showPlaces:[locations lastObject]];
            hasUpdated = YES;
            [weakSelf.locationManager stopUpdatingLocation];
        });
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

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *cluster in views) {
        CGAffineTransform finalScale = CGAffineTransformIdentity;
        cluster.transform = CGAffineTransformMakeScale(.01, .01);

        [UIView animateWithDuration:0.3f delay:(1.0f/(rand()%25)) usingSpringWithDamping:.8f initialSpringVelocity:1.0f options:0 animations:^() {
            cluster.transform = finalScale;
        }                           completion:nil];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //[self showPlacesWithCoordinate:mapView.centerCoordinate];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[SFPlace class]]) {

        SFPlaceAnnotation* annotationView = (SFPlaceAnnotation*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"SFPlaceAnnotation"];

        if (!annotationView) {
            annotationView = [[SFPlaceAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:@"SFPlaceAnnotation"];
        } else {
            [annotationView updateAnnotationViewForAnnotation:annotation];
        }

        return annotationView;

    } else if ([annotation isKindOfClass:[SFPerson class]]) {

        SFPersonAnnotation* annotationView = [[SFPersonAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:@"SFPersonAnnotation"];
        [annotationView updateAnnotationViewForAnnotation:annotation];
        return annotationView;

    } else {

        NSLog(@"Unknown annotation type %@", [annotation class]);

    }
    return nil;
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
                           MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 2000, 2000)];
                           [self.mapView setRegion:adjustedRegion animated:YES];
                       }

    }];


}

-(void)showPlacesWithCoordinate:(CLLocationCoordinate2D)coordinate {
    //currentLocation.coordinate.latitude
    [SFApiAccess searchWithLatitude:coordinate.latitude
                          longitude:coordinate.longitude
                   finishedDelegate:^(NSArray* locations, NSError* error) {

                       if (error) {
                           // Bad news bears!
                       }

                       if (locations) {

                           [self.mapView removeAnnotations:[self.mapView annotations]];

                           // NSArray of SFPlaces
                           // Create dots on map
                           // dots are collapsed thoughtbubbles
                           [self.mapView addAnnotations:locations];
                           MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
                           [self.mapView setRegion:adjustedRegion animated:YES];
                       }

                   }];

}

@end
