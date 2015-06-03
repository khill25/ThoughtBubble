//
//  SFThought.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/2/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFThought.h"
#import "SFSettings.h"

@implementation SFThought

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];

    if (self) {
        _title = title;
        _coordinate = coordinate;
    }

    return self;
}

-(UIColor*)colorForThought {

    return [UIColor sf_primaryColor];

}

@end
