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
#import "SFMessageThreadsViewController.h"
#import "SFThought.h"
#import "SFThoughtAnnotation.h"

@interface SFMapViewController () <UIGestureRecognizerDelegate>

@property NSMutableArray* visibleAnnotation;

@property (strong, nonatomic) IBOutlet UIView *navMenuView;
@property (weak, nonatomic) IBOutlet UIButton *thinkButton;
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *interactButton;
@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (weak, nonatomic) id<MKAnnotation> selectedAnnotation;

@end

NSString* kControllerTitle = @"Explore";

BOOL hasUpdated = NO;

@implementation SFMapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.title = kControllerTitle;
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

    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerReceivedTap:)];
    self.tapRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:self.tapRecognizer];

    // Refresh button
    UIImage* refreshImage = [UIImage imageNamed:@"refresh62"];
    CGRect refreshFrame = CGRectMake(0,0,32,32);
    UIButton* refresh = [[UIButton alloc] initWithFrame:refreshFrame];
    refresh.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [refresh setImage:refreshImage forState:UIControlStateNormal];

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithCustomView:refresh];

    self.navigationItem.rightBarButtonItem = refreshButton;

    [self.thinkButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [self.exploreButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [self.createButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [self.interactButton setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];

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

-(void)viewDidAppear:(BOOL)animated {


    CGRect navFrame = self.navMenuView.frame;
    navFrame.origin.x = 5;
    navFrame.origin.y = -navFrame.size.height;

    self.navMenuView.frame = navFrame;

    [self.view addSubview:self.navMenuView];

    navFrame.origin.y = 44 + 10;

    [UIView animateWithDuration:.35f delay:.12f usingSpringWithDamping:.75f initialSpringVelocity:.5f options:0 animations:^{

        self.navMenuView.frame = navFrame;

    } completion:nil];

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

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

    if (self.navMenuView.alpha >= .999f) {
        self.navMenuView.alpha = .989f;
        [UIView animateWithDuration:.45f delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:.0f options:0 animations:^{
            self.navMenuView.alpha = .45f;
        } completion:nil];
    }

}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //[self showPlacesWithCoordinate:mapView.centerCoordinate];

    if (self.navMenuView.alpha <= .999f) {
        [UIView animateWithDuration:.45f delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:.0f options:0 animations:^{
            self.navMenuView.alpha = 1.0f;
        } completion:nil];
    }
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

- (void)mapView:(MKMapView*)mapView removeAnnotations:(NSArray*)annotations animated:(BOOL)aniamted {
    if (annotations.count > 0) {

        // Get the currently visible annotations in the map
        NSSet *visibleAnnotations = [mapView annotationsInMapRect:[mapView visibleMapRect]];

        NSMutableArray *annotationsToRemove = [NSMutableArray array];
        NSMutableArray *removeWithoutAnimation = [NSMutableArray array];

        // Filter the ones we want to actually animate
        for (id<MKAnnotation> annotation in annotations) {
            if ([visibleAnnotations containsObject:annotation]) {
                // Go ahead and add the view in directly
                MKAnnotationView *view = [mapView viewForAnnotation:annotation];
                if (view) {
                    [annotationsToRemove addObject:view];
                }
            } else {
                [removeWithoutAnimation addObject:annotation];
            }
        }

        // Remove all the annotations we don't care about
        [mapView removeAnnotations:removeWithoutAnimation];

        for (MKAnnotationView *cluster in annotationsToRemove) {
            CGAffineTransform finalScale = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^() {
                cluster.transform = finalScale;
            } completion:^(BOOL finished) {
                [mapView removeAnnotation:cluster.annotation];
            }];
        }
    }
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

    } else if ([annotation isKindOfClass:[SFThought class]]) {

        SFThoughtAnnotation* annotationView = [[SFThoughtAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:@"SFThoughtAnnotation"];
        [annotationView updateAnnotationViewForAnnotation:annotation];
        return annotationView;

    } else {

        NSLog(@"Unknown annotation type %@", [annotation class]);

    }
    return nil;
}

- (void)tapRecognizerReceivedTap:(UITapGestureRecognizer *)sender {

    UIView *hitTestView = [self.mapView hitTest:[sender locationInView:self.mapView] withEvent:nil];

    if ([hitTestView isKindOfClass:[SFThoughtAnnotation class]]) {

        SFThoughtAnnotation *clusterMapAnnotationView = (SFThoughtAnnotation *)hitTestView;

        if (self.selectedAnnotation == clusterMapAnnotationView.annotation) {
            //[self deselectAnnotation:clusterMapAnnotationView.annotation];
        } else {
            if (self.selectedAnnotation) {
                //[self deselectAnnotation:self.selectedAnnotation];
            }
            //[self selectAnnotationView:clusterMapAnnotationView];
        }

    } else if (self.selectedAnnotation) {
        //[self deselectAnnotation:self.selectedAnnotation];
    }

    // Do stuff
}

-(void)showPlaces:(CLLocation *)currentLocation {


    //currentLocation.coordinate.latitude
    [SFApiAccess searchWithLatitude:currentLocation.coordinate.latitude
                          longitude:currentLocation.coordinate.longitude
                   finishedDelegate:^(NSArray* locations, NSError* error) {

                       if (error) {
                           // Bad news bears!
                           NSLog(@"Error searching for places");
                       }

                       if (locations) {

                           [self mapView:self.mapView removeAnnotations:[self.mapView annotations] animated:YES];

                           // NSArray of SFPlaces
                           // Create dots on map
                           // dots are collapsed thoughtbubbles
                           [self.mapView addAnnotations:locations];

                           SFPlace* place = locations.firstObject;
                           SFThought* newThought = [[SFThought alloc] initWithTitle:@"newThought" AndCoordinate:place.coordinate];
                           newThought.thoughtText = @"I wonder what would happen if you divided a cat by a donut?";
                           [self.mapView addAnnotation:newThought];

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
                           NSLog(@"Error searching for places");
                       }

                       if (locations) {

                           [self mapView:self.mapView removeAnnotations:[self.mapView annotations] animated:YES];

                           // NSArray of SFPlaces
                           // Create dots on map
                           // dots are collapsed thoughtbubbles
                           [self.mapView addAnnotations:locations];

                           SFPlace* place = locations.firstObject;
                           SFThought* newThought = [[SFThought alloc] initWithTitle:@"newThought" AndCoordinate:place.coordinate];
                           newThought.thoughtText = @"I wonder what would happen if you divided a cat by a donut?";
                           [self.mapView addAnnotation:newThought];

                           MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
                           [self.mapView setRegion:adjustedRegion animated:YES];
                       }

                   }];

}

-(IBAction)thinkTapped:(id)sender {
    
}

-(IBAction)interactTapped:(id)sender {
    SFMessageThreadsViewController *controller = [[SFMessageThreadsViewController alloc] initWithNibName:@"SFMessageThreadsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

//- (void)deselectAnnotation:(id <MKAnnotation>)annotation {
//    LVYClusterMapAnnotationView *annotationView = (LVYClusterMapAnnotationView *)[self.mapView viewForAnnotation:annotation];
//    annotationView.enabled = NO;
//    [annotationView updateClusterAnnotationViewForAnnotation:self.selectedAnnotation];
//    self.selectedAnnotation = nil;
//}
//
//- (void)selectAnnotationView:(LVYClusterMapAnnotationView *)view {
//    self.selectedAnnotation = view.annotation;
//    view.enabled = YES;
//
//    LVYCluster *cluster = (LVYCluster *)view.annotation;
//
//    if (cluster.type == LVYClusterTypeChild) {
//        LVYClusterMapAnnotationView *clusterMapAnnotationView = view;
//
//        dispatch_block_t selectAnnotation = ^{
//            [clusterMapAnnotationView setAnnotationImageForChildCluster:cluster toSelected:YES];
//            [self.delegate mapViewController:self didSelectAnnotationObject:view.annotation];
//        };
//
//        if ([self.delegate respondsToSelector:@selector(mapViewController:canSelectAnnotationObject:)]) {
//            if ([self.delegate mapViewController:self canSelectAnnotationObject:view.annotation] == YES) {
//                selectAnnotation();
//            }
//        } else {
//            selectAnnotation();
//        }
//
//    } else if (cluster.type == LVYClusterTypeParent) {
//        [self didSelectParentCluster:cluster];
//    } else if (cluster.type == LVYClusterTypeCity) {
//        [self didSelectCityCluster:cluster];
//    }
//}

@end
