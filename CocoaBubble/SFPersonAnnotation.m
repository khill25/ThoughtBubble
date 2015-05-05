//
//  SFPersonAnnotation.m
//  CocoaBubble
//
//  Created by Kaili Hill on 5/5/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFPersonAnnotation.h"
#import "SFPerson.h"

@interface SFPersonAnnotation()

@property (nonatomic) UILabel* textLabel;
@property (assign, nonatomic) CGFloat labelOffset;

@property (weak, nonatomic) SFPerson* person;

@end

@implementation SFPersonAnnotation

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
    self.person = (SFPerson*)annotation;

    // Update the label and the graphic
    // based on type and availability

    self.image = [self personAnnotationImageWithColor:[self.person colorForPersonType]];

}

- (UIImage *)personAnnotationImageWithColor:(UIColor *)color {

    CGFloat lineWidth = 0.0f;
    CGFloat shadowBlurRadius = 1.5f;
    CGSize shadowOffset = CGSizeMake(0.0f, 0.5f); // 2.0f);

    CGFloat clusterDiameter = 28.0;
    clusterDiameter = clusterDiameter + lineWidth;

    CGFloat clusterDiameterWithShadow = clusterDiameter + (shadowBlurRadius * 2);

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(clusterDiameterWithShadow, clusterDiameterWithShadow), NO, [[UIScreen mainScreen] scale]);

    CGRect rectForClusterBorder = CGRectMake(lineWidth + shadowBlurRadius, lineWidth + shadowBlurRadius, clusterDiameter - lineWidth * 2, clusterDiameter - lineWidth * 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rectForClusterBorder];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]);


    path.lineWidth = lineWidth;

    [[UIColor whiteColor] setStroke];
    [path stroke];

    CGContextRestoreGState(context);

    [color setFill];
    [path fill];

    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithOvalInRect:rectForClusterBorder];
    [[UIColor colorWithWhite:0.0f alpha:1.0f] set];
    [innerCirclePath strokeWithBlendMode:kCGBlendModeMultiply alpha:0.1f];

    return UIGraphicsGetImageFromCurrentImageContext();
}

@end