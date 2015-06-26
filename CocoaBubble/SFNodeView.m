//
//  SFNodeView.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/23/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFNodeView.h"
#import "SFEdge.h"

@interface SFNodeView()


@end

@implementation SFNodeView

-(id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        self.layer.cornerRadius = 16.0f;
        self.backgroundColor = [UIColor redColor];
        self.edges = [[NSMutableArray alloc] init];

    }

    return self;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(SFEdge*)createEdge:(SFNodeView*)destination {
    SFEdge* e = [[SFEdge alloc] init];
    e.origin = self;
    e.destination = destination;
    [self.edges addObject:e];
    return e;
}

@end
