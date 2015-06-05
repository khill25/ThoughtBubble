//
//  SFBannerViewController.h
//  Lovely
//
//  Created by Kaili Hill on 4/13/15.
//  Copyright (c) 2015 Lovely. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat LVYBannerViewHeight;

@interface SFBannerViewController : UIViewController

typedef NS_ENUM(NSInteger, LVYBannerViewStyle) {
    LVYBannerViewStyleAlert,
    LVYBannerViewStyleDefault,
    LVYBannerViewStyleSuccess,
    LVYBannerViewStyleError,
    LVYBannerViewStyleInfo,
    LVYBannerViewStyleZoom
};

typedef NS_ENUM(NSInteger, LVYBannerViewAnimation) {
    LVYBannerViewAnimationAlphaFade,
    LVYBannerViewAnimationHeight,
    LVYBannerViewAnimationSlide,
    LVYBannerViewAnimationNova
};

@property (nonatomic) BOOL autoDismiss;
@property (assign, nonatomic) IBOutlet UIImageView* imageView;
@property (assign, nonatomic) IBOutlet UILabel* titleTextView;
@property (assign, nonatomic) IBOutlet UILabel* subtitleTextView;

@property (nonatomic) BOOL dismissing;
@property (nonatomic) BOOL dismissed;

// Actions
+(SFBannerViewController *)bannerInViewController:(UIViewController*)parentViewController withStyle:(LVYBannerViewStyle)bannerStyle;
-(void)showBanner;
-(void)displayAutoDismissBannerWithCompletionHandler:(void(^)())completionHandler;
-(void)hideBanner;

// Customization options
-(void)customizeWithStyle:(LVYBannerViewStyle)style; // sets all the variables for the banner
-(void)setTitleText:(NSString*)titleText color:(UIColor*)color;
-(void)setSubtitleText:(NSString*)subtitleText color:(UIColor*)color;
-(void)setImage:(UIImage*)image;
-(void)setBackgroundColor:(UIColor*)backgroundColor;
-(void)setAnimationInStyle:(LVYBannerViewAnimation)animationIn;
-(void)setAnimationOutStyle:(LVYBannerViewAnimation)animationOut;

@end
