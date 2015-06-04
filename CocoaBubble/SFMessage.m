//
// Created by Kaili Hill on 5/7/15.
// Copyright (c) 2015 Lovely. All rights reserved.
//

#import "SFMessage.h"
#import "SFNetworkingManager.h"

@implementation SFMessage {

}

-(id)initWithMessage:(NSString*)message sent:(NSDate*)sent isMine:(BOOL)isMine {

    if (self = [super init]) {
        self.message = message;
        self.sent = sent;
        self.isMe = isMine;
    }

    return self;

}

-(id)initWithJSON:(NSDictionary*)json {

    if (self = [super init]) {
        self.message = json[kMessageKey];
        self.sent = [NSDate dateWithTimeIntervalSince1970:[json[kTimestapKey] doubleValue]];
        self.isMe = [json[kUserIdKey] isEqualToString:[SFNetworkingManager instance].currentUserId];
    }

    return self;
}

@end