//
// Created by Kaili Hill on 6/3/15.
// Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SFUtilities : NSObject
@end

@interface UIView (ExtendedHitTest)
- (UIView *)extendedHitTest:(CGPoint)point withEvent:(UIEvent *)event;
@end

