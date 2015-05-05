#import "SFPlace.h"

@interface SFPlace ()

@end

@implementation SFPlace

@synthesize coordinate=_coordinate;
@synthesize title=_title;

-(id)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate2D {
    self = [super init];

    if (self) {
        _title = title;
        _coordinate = coordinate2D;
    }

    return self;
}

-(UIColor*)colorForRating {

    UIColor* ret;

    //hue blue = 255
    // red = 0

    if (self.rating == 0) {

        ret = [UIColor colorWithHue:270.0f/360.f saturation:.8 brightness:0.7 alpha:1.0];

    } else if (self.rating == 1) {
        ret = [UIColor colorWithHue:225.0f/360.f saturation:.8 brightness:0.7 alpha:1.0];
    } else if (self.rating == 2) {
        ret = [UIColor colorWithHue:180.0f/360.f saturation:.8 brightness:0.7 alpha:1.0];
    } else if (self.rating == 3) {
        ret = [UIColor colorWithHue:135.0f/360.f saturation:.8 brightness:0.7 alpha:1.0];
    } else if (self.rating == 4) {
        ret = [UIColor colorWithHue:90.0f/360.f saturation:.8 brightness:0.7 alpha:1.0];
    } else if (self.rating == 5) {
        ret = [UIColor colorWithHue:0.0f/360.f saturation:.8 brightness:0.7 alpha:1.0];
    } else {
        ret = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.8];
    }

    return ret;
}

@end