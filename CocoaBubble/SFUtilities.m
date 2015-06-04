//
// Created by Kaili Hill on 6/3/15.
// Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFUtilities.h"


@implementation SFUtilities {

}
@end

@implementation UIView (ExtendedHitTest)
- (UIView *)extendedHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    __block UIView *result;
    NSArray *hitTestSiblings = [self hitTest:point withEvent:event].superview.subviews;
    [hitTestSiblings enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            result = view;
            *stop = YES;
        }
    }];
    return result;
}
@end