//
//  SFPlace.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SFPlace : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

// Expanded info
@property (nonatomic, retain) NSString* name;
@property (nonatomic) NSInteger* rating;
@property (nonatomic, retain) NSDate* hours;
@property (nonatomic) NSInteger* distance;

@property (nonatomic) NSInteger* rank;

@end