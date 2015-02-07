//
//  SFApiAccess.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFApiAccess.h"

@implementation SFApiAccess

-(void)searchWithLocation {
    NSString* baseUrl = @"https://maps.googleapis.com/maps/api/place/textsearch/json?query=";
    NSString* queryTerms = @"coffee+shops+hacker+spaces";
    
    //location — The latitude/longitude around which to retrieve place information. This must be specified as latitude,longitude.
    NSString* location = @"&location=GET_LOCATION_FROM_MAP";
    NSString* authKey = @"AIzaSyBDZYf-1dMAoIY9bAzP1jh-o-hzJxD0lbs";
    
    NSString* formatted = [NSString stringWithFormat:@"%@%@&sensor=false&key=%@", baseUrl, queryTerms, authKey];
    
    
    [SFNetworkingManager postRequestWithUrl:formatted completionHandler:^(id reseponse, NSError *error) {
        // TODO write code here
    }];
    
}

@end
