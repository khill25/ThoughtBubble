//
//  SFNodeView.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/23/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFEdge;
@class SFNodeView;

@protocol SFNodeViewDelegate

-(void)nodeTapped:(SFNodeView*)node;

@end

@interface SFNodeView : UIView

@property (nonatomic) BOOL LAYOUT_visited;

@property (nonatomic) id<SFNodeViewDelegate> delegate;
@property (nonatomic) int nodeId;
@property (nonatomic) NSMutableArray* edges;

-(SFEdge*)createEdge:(SFNodeView*)destination;

@end
