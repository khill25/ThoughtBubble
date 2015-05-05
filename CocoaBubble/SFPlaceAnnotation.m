

//
//  SFPersonAnnotation.m
//  CocoaBubble
//
//  Created by Kaili Hill on 5/5/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFPlaceAnnotation.h"
#import "SFPlace.h"

@interface SFPlaceAnnotation()

@property (nonatomic) UILabel* textLabel;
@property (assign, nonatomic) CGFloat labelOffset;

@property (weak, nonatomic) SFPlace* place;

@end

@implementation SFPlaceAnnotation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self updateAnnotationViewForAnnotation:annotation];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.textLabel sizeToFit];
    self.textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - self.labelOffset);
}

-(void)updateAnnotationViewForAnnotation:(id<MKAnnotation>)annotation {

    self.annotation = annotation;
    self.place = (SFPlace*)annotation;

    // Update the label and the graphic
    // based on type and availability

    self.image = [self placeAnnotationImageWithColor:[self.place colorForRating]];
}

- (UIImage *)placeAnnotationImageWithColor:(UIColor *)color {
    CGSize textSize = [self.place.title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];

    CGFloat lineWidth = 2.5f;
    CGFloat shadowBlurRadius = 1.5f;
    CGSize shadowOffset = CGSizeMake(0.0f, 0.5f); // 2.0f);

    CGFloat clusterDiameter = 20.0; // just a little bigger than the apple maps ones

    CGFloat textWidth = ceil(textSize.width);
    CGFloat textHeight = ceil(textSize.height);

    clusterDiameter = clusterDiameter + lineWidth;

    CGFloat clusterDiameterWithShadow = clusterDiameter + (shadowBlurRadius * 2);

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(clusterDiameterWithShadow, clusterDiameterWithShadow), NO, [[UIScreen mainScreen] scale]);

    CGRect rectForClusterBorder = CGRectMake(lineWidth + shadowBlurRadius, lineWidth + shadowBlurRadius, clusterDiameter - lineWidth * 2, clusterDiameter - lineWidth * 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rectForClusterBorder];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [[UIColor colorWithWhite:0.0f alpha:0.6f] CGColor]);

    path.lineWidth = lineWidth;

    [[UIColor whiteColor] setStroke];
    [path stroke];

    CGContextRestoreGState(context);

    [color setFill];
    [path fill];

    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithOvalInRect:rectForClusterBorder];
    [[UIColor colorWithWhite:0.0f alpha:1.0f] set];
    [innerCirclePath strokeWithBlendMode:kCGBlendModeMultiply alpha:0.1f];

    /*
    CGFloat xCoordinateForTextRect = (clusterDiameterWithShadow / 2) - (textWidth / 2) + 0.5f;
    CGFloat yCoordinateForTextRect = (clusterDiameterWithShadow / 2) - (textHeight / 2);
    CGRect newTextRect = CGRectMake(xCoordinateForTextRect, yCoordinateForTextRect, xCoordinateForTextRect+textWidth, yCoordinateForTextRect+textHeight);

    [self.place.title drawInRect:newTextRect withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    */

    return UIGraphicsGetImageFromCurrentImageContext();
}

@end