//
//  SFNetworkingManager.h
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <Firebase/Firebase.h>

@class SFMessage;

extern NSString* chatServerAPI;

extern const NSString* kMessageKey;
extern const NSString* kUserIdKey;
extern const NSString* kTimestapKey;
extern const NSString* kDestinationKey;
extern const NSString* kUserKey;

@interface SFNetworkingManager : NSObject

@property (nonatomic) Firebase* firebase;

+(SFNetworkingManager*)instance;
+(void)postRequestWithUrl:(NSString*) url completionHandler:(void(^)(id reseponse, NSError* error))completionHandler;

-(Firebase*)getFirebaseRefForMessageThread:(NSString*)messagesTo;
-(void)sendMessage:(SFMessage*)toSend withFirebaseChatRef:(Firebase*)chatRef;
-(NSString*)currentUserId;

@end
