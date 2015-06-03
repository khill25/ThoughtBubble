//
//  SFThoughtAnnotation.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/2/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SFThoughtAnnotation : MKAnnotationView

-(void)updateAnnotationViewForAnnotation:(id<MKAnnotation>)annotation;

@end
