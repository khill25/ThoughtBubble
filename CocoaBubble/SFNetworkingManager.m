//
//  SFNetworkingManager.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFNetworkingManager.h"

@implementation SFNetworkingManager

+(void)postRequestWithUrl:(NSString*) url completionHandler:(void(^)(id reseponse, NSError* error))completionHandler {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             completionHandler(responseObject, nil);
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // Handle failure
             
             completionHandler(nil, error);
             
         }];
    
}

@end
