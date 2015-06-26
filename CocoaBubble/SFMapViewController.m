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
#import "SFCommunicationViewController.h"
#import "SFUtilities.h"
#import "SFProfileViewController.h"
#import "SFGraphRenderingView.h"

@interface SFMapViewController () <UIGestureRecognizerDelegate>

@property NSMutableArray* visibleAnnotation;

@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) IBOutlet UIView *navMenuView;
@property (weak, nonatomic) IBOutlet UIButton *thinkButton;
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *interactButton;
@property (weak, nonatomic) IBOutlet UIImageView* profileImage;
@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (weak, nonatomic) id<MKAnnotation> selectedAnnotation;

@property (nonatomic) SFCommunicationViewController* thoughtController;
@property (nonatomic) SFMessageThreadsViewController* messageThreadsController;

@property (nonatomic) BOOL messagesHidden;
@property (nonatomic) NSLayoutConstraint* messageThreadsHeight;
@property (nonatomic) NSLayoutConstraint* messageThreadsTop;

@property (nonatomic) BOOL setUserLocation;

@end

NSString* kControllerTitle = @"Explore";

BOOL hasUpdated = NO;

@implementation SFMapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.setUserLocation = YES;
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
    self.currentLocation = startCoord;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    CGRect profileFrame = self.profileImage.frame;
    profileFrame.size.height = 64;
    profileFrame.size.width = 64;
    profileFrame.origin.y = 64 + 10;
    profileFrame.origin.x = self.view.frame.size.width - 20;

    self.profileImage.clipsToBounds = YES;
    self.profileImage.image = [UIImage imageNamed:@"sampleProfile.jpg"];
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 32;
    self.profileImage.layer.borderWidth = 1.0f;

    self.profileImage.frame = profileFrame;
    [self.view addSubview:self.profileImage];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapped:)];
    [self.profileImage addGestureRecognizer:tap];
}

-(void)refresh:(id)sender {

    hasUpdated = false;
    [self showPlacesWithCoordinate:self.mapView.centerCoordinate];

}
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    if (locations.count > 0) {
        self.currentLocation = ((CLLocation *) [locations lastObject]).coordinate;
    }

    if (!hasUpdated) {
        hasUpdated = YES;
        NSLog(@"LocationManager didUpdateLocations");
        [self showPlaces:[locations lastObject]];
        [self.locationManager stopUpdatingLocation];
    }

}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
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

    if (self.setUserLocation) {
        _mapView.centerCoordinate = userLocation.location.coordinate;
        self.setUserLocation = NO;
    }
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

    if (self.navMenuView.alpha >= .999f) {
        [UIView animateWithDuration:.45f delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:.0f options:0 animations:^{
            self.navMenuView.alpha = .35f;
        } completion:nil];
    }

}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

    if (self.navMenuView.alpha < 1.0f) {
        [UIView animateWithDuration:.45f delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:.0f options:0 animations:^{
            self.navMenuView.alpha = 1.0f;
        } completion:nil];
    }
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {

    for (MKAnnotationView *cluster in views) {

        BOOL useExtraAnimation = NO;

        if ([cluster isKindOfClass:[SFThoughtAnnotation class]]) {
            cluster.layer.zPosition = 10.0f;

            useExtraAnimation = ((SFThought*)cluster.annotation).isMine;
        }

        CGAffineTransform finalScale = CGAffineTransformIdentity;
        cluster.transform = CGAffineTransformMakeScale(.01, .01);

        [UIView animateWithDuration:0.3f delay:(1.0f/(rand()%25)) usingSpringWithDamping:.8f initialSpringVelocity:1.0f options:0 animations:^() {
            cluster.transform = finalScale;
        } completion:^(BOOL finished) {

            if (finished) {
                if (useExtraAnimation) {
                    CGAffineTransform finalScale2 = CGAffineTransformMakeTranslation(0.0f, -200.0f);

                    [UIView animateWithDuration:4.5f delay:2.5f usingSpringWithDamping:.8f initialSpringVelocity:1.0f options:0 animations:^() {
                        cluster.transform = finalScale2;
                        cluster.alpha = 0;
                    } completion:nil];
                }
            }

        }];

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

            if ([annotation isKindOfClass:[MKUserLocation class]]) continue;

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

    if ([hitTestView isKindOfClass:[SFPlaceAnnotation class]]) {
        UIView* otherView = [hitTestView extendedHitTest:[sender locationInView:self.mapView] withEvent:nil];

        hitTestView = otherView;
    }

    if ([hitTestView isKindOfClass:[SFThoughtAnnotation class]]) {
        NSLog(@"HitTest is SFThoughtAnnotation");

        SFThoughtAnnotation *clusterMapAnnotationView = (SFThoughtAnnotation *)hitTestView;

        if (self.selectedAnnotation == clusterMapAnnotationView.annotation) {
            [self deselectAnnotation:clusterMapAnnotationView.annotation];
        } else {
            if (self.selectedAnnotation) {
                [self deselectAnnotation:self.selectedAnnotation];
            }
            [self selectAnnotationView:clusterMapAnnotationView];
        }

    } else if (self.selectedAnnotation) {
        [self deselectAnnotation:self.selectedAnnotation];
    }
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

                           //MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
                           //[self.mapView setRegion:adjustedRegion animated:YES];
                       }

                   }];

}

-(IBAction)exploreTapped:(id)sender {

    SFGraphRenderingView *renderer = [[SFGraphRenderingView alloc] initWithFrame:self.view.frame];
    renderer.alpha = 0;
    [self.view addSubview:renderer];

    [UIView animateWithDuration:.35f delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        renderer.alpha = 1;
    } completion:nil];

}

-(IBAction)thinkTapped:(id)sender {

    if (!self.thoughtController) {

        self.thoughtController = [[SFCommunicationViewController alloc] initWithNibName:@"SFCommunicationViewController" bundle:nil sendBlock:^(NSString* message){
            // Send the thought
            NSLog(@"Thought sent!");

            SFThought* newThought = [[SFThought alloc] initWithTitle:@"newThought" AndCoordinate:self.currentLocation];
            newThought.isMine = YES;
            newThought.thoughtText = message;
            newThought.sentTime = [NSDate new];

            [self.mapView addAnnotation:newThought];

            self.thoughtController.textView.text = @"";
            [self dismissComposeView:nil];
            [self thinkTapped:self.thinkButton];


        }];

        CGRect thinkFrame = self.thoughtController.view.frame;
        thinkFrame.origin.x = 0;
        thinkFrame.origin.y = self.view.frame.size.height;
        thinkFrame.size.width = self.view.frame.size.width;
        thinkFrame.size.height = 92.0f;
        self.thoughtController.view.frame = thinkFrame;

        // TODO do the stupid auto layout to make sure that we can resize the text box if needed.

        //[self.thoughtController willMoveToParentViewController:self];
        [self.view addSubview:self.thoughtController.view];

        NSArray* hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[think]-0-|" options:0 metrics:nil views:@{@"think" : self.thoughtController.view}];
        NSArray* vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[think(==92)]-0-|" options:0 metrics:nil views:@{@"think" : self.thoughtController.view}];

        [self.view addConstraints:hConstraints];
        [self.view addConstraints:vConstraints];
        //[self addChildViewController:self.thoughtController];
        //[self.thoughtController didMoveToParentViewController:self];
        [self.view layoutIfNeeded];

        self.thoughtController.view.hidden = YES;
    }

    if (self.thoughtController.view.hidden) {

        CGRect thinkFrame = self.thoughtController.view.frame;
        thinkFrame.origin.x = 0;
        thinkFrame.size.width = self.view.frame.size.width;
        thinkFrame.size.height = 92.0f;
        self.thoughtController.view.frame = thinkFrame;
        self.thoughtController.view.hidden = NO;

        thinkFrame.origin.y = self.view.frame.size.height - thinkFrame.size.height;

        [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.75f initialSpringVelocity:.5f options:0 animations:^{

            self.thoughtController.view.frame = thinkFrame;

        } completion:nil];

    } else {

        CGRect thinkFrame = self.thoughtController.view.frame;
        thinkFrame.origin.x = 0;
        thinkFrame.origin.y = self.view.frame.size.height + 92.0f;
        thinkFrame.size.width = self.view.frame.size.width;
        thinkFrame.size.height = 92.0f;

        [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.75f initialSpringVelocity:.5f options:0 animations:^{
            self.thoughtController.view.frame = thinkFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.thoughtController.view.hidden = YES;
            }
        }];

    }

}

-(IBAction)interactTapped:(id)sender {

    CGRect threadFrame = self.view.frame;
    threadFrame.size.height = (self.view.frame.size.height - (64.0f + 45.0f + self.interactButton.frame.origin.y));
    threadFrame.origin.y = self.view.frame.size.height;

    if (!self.messageThreadsController) {

        self.messageThreadsController = [[SFMessageThreadsViewController alloc] initWithNibName:@"SFMessageThreadsViewController" bundle:nil];
        self.messageThreadsController.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.messageThreadsController.view.frame = threadFrame;

        [self.view addSubview:self.messageThreadsController.view];
        [self.messageThreadsController willMoveToParentViewController:self];
        [self addChildViewController:self.messageThreadsController];
        [self.messageThreadsController didMoveToParentViewController:self];

        self.messageThreadsHeight = [NSLayoutConstraint constraintWithItem:self.messageThreadsController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(self.view.frame.size.height - (64.0f + 45.0f + self.interactButton.frame.origin.y))];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.messageThreadsController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.messageThreadsController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.messageThreadsController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        self.messageThreadsTop = [NSLayoutConstraint constraintWithItem:self.messageThreadsController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:self.view.frame.size.height];
        [self.view addConstraint:self.messageThreadsHeight];
        [self.view addConstraint:left];
        [self.view addConstraint:right];
        [self.view addConstraint:bottom];
        [self.view addConstraint:self.messageThreadsTop];

        [self.view layoutIfNeeded];

        self.messagesHidden = YES;
    }

    if (self.messagesHidden) {
        self.messagesHidden = NO;

        self.messageThreadsTop.constant = 64 + self.interactButton.frame.origin.y + 45;
        //self.messageThreadsHeight.constant = self.view.frame.size.height - 64 - self.interactButton.frame.origin.y - 45;
                [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.75f initialSpringVelocity:.5f options:0 animations:^{
                    [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {

        }];
    } else {
        self.messagesHidden = YES;
        self.messageThreadsTop.constant = self.view.frame.size.height;
        //self.messageThreadsHeight.constant = 0;
        [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.75f initialSpringVelocity:.5f options:0 animations:^{
                    [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {

            }
        }];
    }

    //[self.navigationController pushViewController:controller animated:YES];
}

- (void)deselectAnnotation:(id <MKAnnotation>)annotation {
    /*
    LVYClusterMapAnnotationView *annotationView = (LVYClusterMapAnnotationView *)[self.mapView viewForAnnotation:annotation];
    annotationView.enabled = NO;
    [annotationView updateClusterAnnotationViewForAnnotation:self.selectedAnnotation];
    */
    self.selectedAnnotation = nil;
}

- (void)selectAnnotationView:(SFThoughtAnnotation*)view {
    self.selectedAnnotation = view.annotation;
    view.enabled = YES;

    SFThought *thought = (SFThought*)view.annotation;
    NSLog(@"Selected thought: %@", thought.thoughtText);

    // TODO do something with this. Maybe view the person that sent it?

}

#pragma mark - Keyboard showing and hiding

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

-(void)dismissComposeView:(UITapGestureRecognizer *)recognizer {

    [self.thoughtController.textView resignFirstResponder];

}

-(void)profileTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    SFProfileViewController *controller = [[SFProfileViewController alloc] initWithNibName:@"SFProfileViewController" bundle:nil];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

@end
