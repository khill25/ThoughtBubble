//
//  SFPersonAnnotation.h
//  CocoaBubble
//
//  Created by Kaili Hill on 5/5/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SFPersonAnnotation : MKAnnotationView

-(void)updateAnnotationViewForAnnotation:(id<MKAnnotation>)annotation;

@end
