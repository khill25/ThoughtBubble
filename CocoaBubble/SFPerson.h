//
// Created by Kaili Hill on 5/5/15.
// Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SFPerson : NSObject <MKAnnotation>

typedef NS_ENUM(NSInteger, SFPersonType) {
    SFPersonTypeCocoaDeveloper,
    SFPersonTypeAndriodDeveloper,
    SFPersonTypeDeveloper,
    SFPersonTypeDesigner,
    SFPersonTypeUndisclosed
};

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) SFPersonType personType;
@property BOOL seekingHelp;
@property BOOL offeringHelp;
@property BOOL wantsToHangingOut;

-(UIColor*)colorForPersonType;
+(UIColor*)colorForPersonType:(SFPersonType)type;

@end