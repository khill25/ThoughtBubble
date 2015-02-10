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

@end