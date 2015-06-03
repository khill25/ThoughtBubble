//
//  SFSettings.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/3/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFSettings : NSObject

@end

@interface UIColor (SFTheme)

+(UIColor*)sf_primaryColor;
+(UIColor*)sf_secondaryColor;
+(UIColor*)sf_accentColor;

@end
