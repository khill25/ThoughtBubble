//
//  SFMessageTableViewCell.m
//  Lovely
//
//  Created by Kaili Hill on 5/13/15.
//  Copyright (c) 2015 Lovely. All rights reserved.
//

#import "SFMessageTableViewCell.h"
#import "SFSettings.h"

@interface SFMessageTableViewCell ()

@property (nonatomic) UIColor* messageBackgroundColor;

@property (nonatomic) NSMutableArray* dotViews;

@end

@implementation SFMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {

    for (UIView* view in self.dotViews) {
        [view removeFromSuperview];
    }

    [super prepareForReuse];
}

-(void)configureWithMessage:(NSString*)message style:(LVYMessageTableViewCellStyle)style {

    self.dotViews = [[NSMutableArray alloc] init];

    self.messageLabel.text = message;
    
    switch (style) {
        case LVYMessageTableViewCellStyleLeft:
            [self styleLeft];
            break;
        case LVYMessageTableViewCellStyleRight:
            [self styleRight];
            break;
            
        default:
            break;
    }



    // update if needed
    [self.contentView updateConstraintsIfNeeded];
    [self updateConstraintsIfNeeded];
    
}

-(void)styleLeft {
    
    CGFloat indent = self.frame.size.width/3.0f;
    self.leftIndentConstraint.constant = indent;
    self.rightIndetContraint.constant = 8.0f;
    self.messageStyleView.backgroundColor = [UIColor sf_secondaryColor];
    self.messageBackgroundColor = [UIColor sf_secondaryColor];
    self.messageLabel.textColor = [UIColor whiteColor];

    [self setupLeftBorderStyleWithColor:[UIColor sf_secondaryColor]];
    
}

-(void)styleRight {
    
    CGFloat indent = self.frame.size.width/3.0f;
    self.leftIndentConstraint.constant = 8.0f;
    self.rightIndetContraint.constant = indent;
    
    self.messageStyleView.backgroundColor = [UIColor sf_primaryColor];
    self.messageBackgroundColor = [UIColor sf_primaryColor];
    self.messageLabel.textColor = [UIColor whiteColor];

    [self setupRightBorderStyleWithColor:[UIColor sf_primaryColor]];
    
}

-(void)setupLeftBorderStyleWithColor:(UIColor*)color {
    
    self.messageStyleView.layer.borderColor = color.CGColor;

    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    CGRect circleFrame = CGRectMake(self.leftIndentConstraint.constant - 14, self.contentView.frame.size.height-20, 10, 10);
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,10,10)] CGPath]];

    CAShapeLayer *circleLayer2 = [CAShapeLayer layer];
    CGRect circleFrame2 = CGRectMake(self.leftIndentConstraint.constant-14 - 5, self.contentView.frame.size.height-16, 6, 6);
    [circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,6,6)] CGPath]];

    CAShapeLayer *circleLayer3 = [CAShapeLayer layer];
    CGRect circleFrame3 = CGRectMake(self.leftIndentConstraint.constant-14 - 5 - 2, self.contentView.frame.size.height-13, 3, 3);
    [circleLayer3 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,3,3)] CGPath]];

    [circleLayer setFillColor:color.CGColor];
    [circleLayer2 setFillColor:color.CGColor];
    [circleLayer3 setFillColor:color.CGColor];

    [circleLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [circleLayer2 setStrokeColor:[UIColor whiteColor].CGColor];
    [circleLayer3 setStrokeColor:[UIColor whiteColor].CGColor];

    circleLayer.borderWidth = 1.0;
    circleLayer2.borderWidth = 1.0;
    circleLayer3.borderWidth = 1.0;

    UIView* circleView1 = [[UIView alloc] initWithFrame:circleFrame];
    [circleView1.layer addSublayer:circleLayer];
    [self.contentView addSubview:circleView1];

    UIView* circleView2 = [[UIView alloc] initWithFrame:circleFrame2];
    [circleView2.layer addSublayer:circleLayer2];
    [self.contentView addSubview:circleView2];

    UIView* circleView3 = [[UIView alloc] initWithFrame:circleFrame3];
    [circleView3.layer addSublayer:circleLayer3];
    [self.contentView addSubview:circleView3];

    circleView1.transform = CGAffineTransformMakeScale(.1f, .1f);

    [UIView animateWithDuration:.30f delay:.28f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        circleView1.transform = CGAffineTransformIdentity;
    } completion:nil];

    circleView2.transform = CGAffineTransformMakeScale(.1f, .1f);

    [UIView animateWithDuration:.30f delay:.28f+.15f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        circleView2.transform = CGAffineTransformIdentity;
    } completion:nil];

    circleView3.transform = CGAffineTransformMakeScale(.1f, .1f);

    [UIView animateWithDuration:.30f delay:.28f+.3f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        circleView3.transform = CGAffineTransformIdentity;
    } completion:nil];

    [self.dotViews addObject:circleView1];
    [self.dotViews addObject:circleView2];
    [self.dotViews addObject:circleView3];

}

-(void)setupRightBorderStyleWithColor:(UIColor*)color {

    self.messageStyleView.layer.borderColor = color.CGColor;

    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    CGRect circleFrame = CGRectMake(self.messageStyleView.frame.origin.x+(self.contentView.frame.size.width-self.rightIndetContraint.constant) - 4, self.contentView.frame.size.height-20, 10, 10);
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,10,10)] CGPath]];

    CAShapeLayer *circleLayer2 = [CAShapeLayer layer];
    CGRect circleFrame2 = CGRectMake(self.messageStyleView.frame.origin.x+(self.contentView.frame.size.width-self.rightIndetContraint.constant) - 4 + 8, self.contentView.frame.size.height-16, 6, 6);
    [circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,6,6)] CGPath]];

    CAShapeLayer *circleLayer3 = [CAShapeLayer layer];
    CGRect circleFrame3 = CGRectMake(self.messageStyleView.frame.origin.x+(self.contentView.frame.size.width-self.rightIndetContraint.constant) -4 + 8 + 4, self.contentView.frame.size.height-13, 3, 3);
    [circleLayer3 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,3,3)] CGPath]];

    [circleLayer setFillColor:color.CGColor];
    [circleLayer2 setFillColor:color.CGColor];
    [circleLayer3 setFillColor:color.CGColor];

    [circleLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [circleLayer2 setStrokeColor:[UIColor whiteColor].CGColor];
    [circleLayer3 setStrokeColor:[UIColor whiteColor].CGColor];

    circleLayer.borderWidth = 1.0;
    circleLayer2.borderWidth = 1.0;
    circleLayer3.borderWidth = 1.0;

    UIView* circleView1 = [[UIView alloc] initWithFrame:circleFrame];
    [circleView1.layer addSublayer:circleLayer];
    [self.contentView addSubview:circleView1];

    UIView* circleView2 = [[UIView alloc] initWithFrame:circleFrame2];
    [circleView2.layer addSublayer:circleLayer2];
    [self.contentView addSubview:circleView2];

    UIView* circleView3 = [[UIView alloc] initWithFrame:circleFrame3];
    [circleView3.layer addSublayer:circleLayer3];
    [self.contentView addSubview:circleView3];

    circleView1.transform = CGAffineTransformMakeScale(.1f, .1f);

    [UIView animateWithDuration:.30f delay:.28f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        circleView1.transform = CGAffineTransformIdentity;
    } completion:nil];

    circleView2.transform = CGAffineTransformMakeScale(.1f, .1f);

    [UIView animateWithDuration:.30f delay:.28f+.15f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        circleView2.transform = CGAffineTransformIdentity;
    } completion:nil];

    circleView3.transform = CGAffineTransformMakeScale(.1f, .1f);

    [UIView animateWithDuration:.30f delay:.28f+.3f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        circleView3.transform = CGAffineTransformIdentity;
    } completion:nil];

    [self.dotViews addObject:circleView1];
    [self.dotViews addObject:circleView2];
    [self.dotViews addObject:circleView3];

}

// Modifies the light and dark values of the background colors based on the percent to bottom. So where this cell
// lives in correspondance to physical screen space. This should only apply to visible cells and in a relative
// sense
-(void)modifyColorDarknessForPercentToBottom:(CGFloat)percentToBottom {

    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;

    [self.messageBackgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    saturation = 1 - .3f + (.3f*percentToBottom);

    self.messageStyleView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];



}

@end
