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
@property (nonatomic) CGPoint controlPoint;

@end
