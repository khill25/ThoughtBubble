//
//  SFApiAccess.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFApiAccess.h"
#import "SFPlace.h"

@implementation SFApiAccess

const NSString* baseAPIRoute = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
const NSString* kRadiusKey = @"radius=";
const NSString* kLocationKey = @"location=";
const NSString* kQueryKey = @"keyword=";
const NSString* kTerms = @"radius=";
const NSString* kAPIKey = @"key=AIzaSyBDZYf-1dMAoIY9bAzP1jh-o-hzJxD0lbs";

NSString* query = @"coffee";
int configuredRadiusInMeters = 1500;

//(returnType (^)(parameterTypes))blockName
+(void)searchWithLatitude:(double)latitude
                    longitude:(double)longitude
             finishedDelegate:(void (^)(NSArray*, NSError*))finishedDelegate {

    // This formatted string is super ugly
    NSString* formatted = [NSString stringWithFormat:@"%@?%@%f,%f&%@%d&%@%@&%@", baseAPIRoute, kLocationKey, latitude, longitude, kRadiusKey, configuredRadiusInMeters, kQueryKey, query, kAPIKey];

    [SFNetworkingManager postRequestWithUrl:formatted completionHandler:^(id response, NSError *error) {
        // Parse the json response and create SFPlaces. Return array of SFPlaces

        if (error) {
            NSLog(@"Error processing api request. %@" ,error);
        } else {

            NSDictionary *json = (NSDictionary *) response;
            /*
             * results :
             *      geometry :
             *          location : {
                            "lat" : number,
                            "lng" : number

                    name :
                    rating :
                    vicinity
            }
             */


            NSMutableArray *ret = [[NSMutableArray alloc] init];
            NSArray *results = json[@"results"];

            for (NSDictionary *result in results) {

                NSDictionary *geometry = result[@"geometry"];
                NSDictionary *location = geometry[@"location"];
                NSNumber *lat = location[@"lat"];
                NSNumber *lng = location[@"lng"];

                NSString *title = result[@"name"];

                CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);

                SFPlace *place = [[SFPlace alloc] initWithTitle:title AndCoordinate:coordinate2D];

                [ret addObject:place];
            }

            finishedDelegate(ret, nil);
        }

    }];
    
}

@end
