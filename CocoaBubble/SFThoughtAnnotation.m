//
//  SFThoughtAnnotation.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/2/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFThoughtAnnotation.h"
#import "SFThought.h"
#import "SFSettings.h"

@interface SFThoughtAnnotation()

@property (nonatomic) UILabel* textLabel;
@property (assign, nonatomic) CGFloat labelOffset;

@property (weak, nonatomic) SFThought* thought;

@end

@implementation SFThoughtAnnotation

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
    self.thought = (SFThought*)annotation;
    
    // Update the label and the graphic
    // based on type and availability
    
    //self.image = [self personAnnotationImageWithColor:[self.thought colorForThought]];

    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200, 100)];
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    self.textLabel.textColor = [UIColor sf_primaryColor];
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textLabel.numberOfLines = 3;
    self.textLabel.text = self.thought.thoughtText;
    self.image = [self thoughtAnnotationImageWithColor:[UIColor whiteColor]];
    
}

- (UIImage *)thoughtAnnotationImageWithColor:(UIColor *)color {

    CGRect sizeRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(200,1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textLabel.font} context:nil];
    CGFloat height = sizeRect.size.height + 16;

    CGRect pathRect = sizeRect;
    pathRect.size.height += 16;
    pathRect.size.width +=16;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4,4)];
    path.lineWidth = 1.75f;

    sizeRect.origin.x = 8.0f;
    sizeRect.origin.y = 8.0f;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(216, height+16), NO, [[UIScreen mainScreen] scale]);

    [color setFill];
    [path fill];

    [[UIColor sf_secondaryColor] setStroke];
    [path stroke];

    [self.textLabel.text drawInRect:sizeRect withAttributes:@{NSFontAttributeName : self.textLabel.font, NSForegroundColorAttributeName : self.textLabel.textColor}];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}


@end
