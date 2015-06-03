//
//  SFThought.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/2/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SFPerson.h"

@interface SFThought : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@property (weak, nonatomic) SFPerson* owner;
@property (nonatomic) NSString* thoughtText;
@property (nonatomic) NSData* thoughtData;

-(UIColor*)colorForThought;

@end
