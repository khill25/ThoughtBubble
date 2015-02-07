//
//  SFMapViewController.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFMapViewController.h"

@interface SFMapViewController ()

@end

@implementation SFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(MKUserLocation*)getCurrentLocation {
    return _mapView.userLocation;
}

@end
