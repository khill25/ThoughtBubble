//
// Created by Kaili Hill on 5/7/15.
//

#import <Foundation/Foundation.h>


@interface SFMessage : NSObject
@property (nonatomic) NSString* message;
@property (nonatomic) NSDate* sent;
@property (nonatomic) BOOL isRead;
@property (nonatomic) BOOL isSent;
@property (nonatomic) NSInteger authorId;
@property (nonatomic) BOOL isMe;

-(id)initWithMessage:(NSString*)message sent:(NSDate*)sent isMine:(BOOL)isMine;
-(id)initWithJSON:(NSDictionary*)json;

@end