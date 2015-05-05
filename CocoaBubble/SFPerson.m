//
// Created by Kaili Hill on 5/5/15.
// Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFPerson.h"


@implementation SFPerson {

}

-(UIColor*)colorForPersonType {

    return [SFPerson colorForPersonType:self.personType];

}

+(UIColor*)colorForPersonType:(SFPersonType)type {

    UIColor* ret = [UIColor colorWithWhite:1.0 alpha:1.0];

    if (type == SFPersonTypeCocoaDeveloper) {
        //233,221,204 iphone gold
        ret = [UIColor colorWithRed:(233.0f/255.0f) green:221.0f/255.0f blue:204.0f/255.0f alpha:1.0];
    } else if (type == SFPersonTypeAndriodDeveloper) {
        // 164,199,57 android green
        ret = [UIColor colorWithRed:164.0f/255.0f green:199.0f/255.0f blue:57.0f/255.0f alpha:1.0];
    } else if (type == SFPersonTypeDesigner) {
        // blue
        ret = [UIColor colorWithRed:21.0f/255.0f green:101.0f/255.0f blue:178.0f/255.0f alpha:1.0];
    } else if (type == SFPersonTypeDeveloper) {
        //orangeish
        ret = [UIColor colorWithRed:255.0f/255.0f green:95.0f/255.0f blue:25.0f/255.0f alpha:1.0];
    } else if (type == SFPersonTypeUndisclosed) {
        ret = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1.0];
    }

    return ret;

}

@end