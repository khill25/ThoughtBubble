//
// Created by Kaili Hill on 5/5/15.
// Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SFPerson : NSObject <MKAnnotation>

typedef NS_ENUM(NSInteger, SFPersonType) {
    SFPersonTypeCocoaDeveloper,
    SFPersonTypeAndriodDeveloper,
    SFPersonTypeDeveloper,
    SFPersonTypeDesigner,
    SFPersonTypeUndisclosed
};

typedef NS_ENUM(NSInteger, SFPersonMood) {
    SFPersonMoodHappy,
    SFPersonMoodSad,
    SFPersonMoodExcited,
    SFPersonMoodAdventurist,
    SFPersonMoodChatty,
    SFPersonMoodChilling
};

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) SFPersonType personType;
@property (nonatomic) BOOL seekingHelp;
@property (nonatomic) BOOL offeringHelp;
@property (nonatomic) BOOL wantsToHangingOut;
@property (nonatomic) SFPersonMood mood;

@property (nonatomic) NSString* bio;
@property (nonatomic) NSString* email;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* alias;
@property (nonatomic) BOOL usingRealName;
@property (nonatomic) BOOL isMe;

-(UIColor*)colorForPersonType;
+(UIColor*)colorForPersonType:(SFPersonType)type;

@end