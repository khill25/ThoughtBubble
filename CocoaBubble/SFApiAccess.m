//
//  SFApiAccess.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFApiAccess.h"

@implementation SFApiAccess

const NSString* baseAPIRoute = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
const NSString* kRadiusKey = @"radius=";
const NSString* kLocationKey = @"location=";
const NSString* kQueryKey = @"keyword=";
const NSString* kTerms = @"radius=";
const NSString* kAPIKey = @"key=AIzaSyBDZYf-1dMAoIY9bAzP1jh-o-hzJxD0lbs";

NSString* query = @"coffee+shops+hacker+spaces";
int configuredRadiusInMeters = 1500;

//(returnType (^)(parameterTypes))blockName
+(void)searchWithLatitude:(double)latitude
                    longitude:(double)longitude
             finishedDelegate:(void (^)(NSArray*, NSError*))finishedDelegate {

    // This formatted string is super ugly
    NSString* formatted = [NSString stringWithFormat:@"%@?%@%f,%f&%@%d&%@%@", baseAPIRoute, kLocationKey, latitude, longitude, kRadiusKey, configuredRadiusInMeters, kQueryKey, query];

    [SFNetworkingManager postRequestWithUrl:formatted completionHandler:^(id response, NSError *error) {
        // Parse the json response and create SFPlaces. Return array of SFPlaces

    }];
    
}

@end
