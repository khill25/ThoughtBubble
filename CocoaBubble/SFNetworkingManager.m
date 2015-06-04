//
//  SFNetworkingManager.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFNetworkingManager.h"
#import "SFThought.h"
#import "SFMessage.h"

NSString* chatServerAPI = @"https://flickering-heat-2355.firebaseio.com/users";
const NSString* kMessageKey = @"message";
const NSString* kUserIdKey = @"userId";
const NSString* kTimestapKey = @"timestamp";
const NSString* kDestinationKey = @"chatDestination";
const NSString* kUserKey = @"users";

@interface SFNetworkingManager()
@property (nonatomic) NSString* loggedInUserId;

@end

static SFNetworkingManager * _instance;

@implementation SFNetworkingManager

+(SFNetworkingManager*)instance {

    if (!_instance) {
        _instance = [[SFNetworkingManager alloc] init];
    }

    return _instance;

}

-(id)init {

    if (self = [super init]) {
        self.loggedInUserId = @"hashstringhere";
        [self setupFirebase];
        [self setupMessageListener];
    }

    return self;

}

-(void)setupFirebase {

    self.firebase = [[Firebase alloc] initWithUrl:chatServerAPI];
}

-(void)setupMessageListener {

    // Read data and react to changes
    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];

}

-(Firebase*)getFirebaseRefForMessageThread:(NSString*)messagesTo {
    Firebase* userStore = [self.firebase childByAppendingPath:[NSString stringWithFormat:@"/%@/messageThreads/%@", [self currentUserId], messagesTo]];
    return userStore;
}

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

-(void)createUser:(NSString*)email password:(NSString*)password {
    [self.firebase createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        if (error) {
         // There was an error creating the account
            NSLog(@"Error creating account");
        } else {
            self.loggedInUserId = [result objectForKey:@"uid"];
            NSLog(@"Successfully created user account with uid: %@", self.loggedInUserId);
        }
    }];
}

-(void)login:(NSString*)email password:(NSString*)password {
    [self.firebase authUser:email password:password
            withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    // There was an error logging in to this account
                    NSLog(@"Error logging in %@", email);
                } else {
                    // We are now logged in
                    NSLog(@"Success!! Logged in.");
                }
            }];
}


-(void)sendMessage:(SFMessage*)toSend withFirebaseChatRef:(Firebase*)chatRef {
    NSDictionary* message = @{kMessageKey : toSend.message, kTimestapKey : [NSNumber numberWithDouble:[toSend.sent timeIntervalSince1970]], kUserIdKey : [self currentUserId]};
    [[chatRef childByAutoId] setValue:message];
}

-(NSString*)currentUserId {
    return self.loggedInUserId;
}

@end
