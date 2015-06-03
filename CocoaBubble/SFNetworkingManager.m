//
//  SFNetworkingManager.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/7/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFNetworkingManager.h"
#import "SFThought.h"
#import <Firebase/Firebase.h>

NSString* chatServerAPI = @"https://flickering-heat-2355.firebaseio.com";

@interface SFNetworkingManager()

@property (nonatomic) Firebase* firebase;
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


-(void)sendThought:(SFThought*)thought {



    // Write data to Firebase
    //[self.firebase setValue:thought.thoughtText];
    [self.firebase setValue:@"Test!!! YAY it worked."];

}

@end
