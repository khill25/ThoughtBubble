//
//  SFEdge.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/23/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class SFNodeView;

@interface SFEdge : NSObject

@property (weak, nonatomic) SFNodeView* origin;
@property (weak, nonatomic) SFNodeView* destination;
@property (nonatomic) BOOL isGeoConnection;
@property (nonatomic) BOOL isFriendConnection;
@property (nonatomic) CGPoint controlPoint; // to make pretty looking bezier lines I guess

@end
