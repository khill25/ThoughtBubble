//
//  SFNodeView.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/23/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFEdge;

@interface SFNodeView : UIView

@property (nonatomic) NSMutableArray* edges;

-(SFEdge*)createEdge:(SFNodeView*)destination;

@end
