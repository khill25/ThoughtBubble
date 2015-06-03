//
//  SFSettings.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/3/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFSettings.h"

@implementation SFSettings

@end

@implementation UIColor (SFTheme)

+(UIColor*)sf_primaryColor {
    return [UIColor colorWithRed:(20.0f/255.0f) green:(84.0f/255.0f) blue:(160.0f/255.0f) alpha:1.0];
}

+(UIColor*)sf_secondaryColor {
    return [UIColor colorWithRed:(160.0f/255.0f) green:(200.0f/255.0f) blue:(22.0f/255.0f) alpha:1.0];
}

+(UIColor*)sf_accentColor {
    return [UIColor colorWithRed:(180.0f/255.0f) green:(32.0f/255.0f) blue:(72.0f/255.0f) alpha:1.0];
}

@end

