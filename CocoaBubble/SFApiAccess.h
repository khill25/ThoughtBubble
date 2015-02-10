//
//  SFApiAccess.h
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SFNetworkingManager.h"

@interface SFApiAccess : NSObject

+(void)searchWithLatitude:(double)latitude
                    longitude:(double)longitude
             finishedDelegate:(void (^)(NSArray*, NSError*))finishedDelegate;

@end
