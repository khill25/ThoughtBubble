//
//  SFNetworkingManager.h
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface SFNetworkingManager : NSObject

+(void)postRequestWithUrl:(NSString*) url completionHandler:(void(^)(id reseponse, NSError* error))completionHandler;

@end
