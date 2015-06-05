//
//  SFBannerViewController.m
//  Lovely
//
//  Created by Kaili Hill on 4/13/15.
//  Copyright (c) 2015 Lovely. All rights reserved.
//

#import "SFBannerViewController.h"
#import "SFSettings.h"


CGFloat LVY_banner_view_animation_time = 0.35f;
CGFloat LVY_dismiss_time = 3.0f;
CGFloat LVYBannerViewHeight = 53.0f;

@interface SFBannerViewController ()

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSTimer* dismissTimer;

@property (nonatomic) BOOL userInteractionAllowed;
@property (nonatomic) BOOL wasTapped;

@property (nonatomic) LVYBannerViewAnimation animationTypeIn;
@property (nonatomic) LVYBannerViewAnimation animationTypeOut;

@property (nonatomic, copy) void(^storedCompletionHandler)();

@end

@implementation SFBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPushNotification:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGestureRecognizer];

    self.userInteractionAllowed = YES;
    self.autoDismiss = YES;

    [self startDismissTimer];
}

#pragma mark - Style setup and display
- (void)customizeWithStyle:(LVYBannerViewStyle)style {

    // Default animation style
    self.animationTypeIn = LVYBannerViewAnimationAlphaFade;
    self.animationTypeOut = LVYBannerViewAnimationAlphaFade;
    self.userInteractionAllowed = NO;
    self.titleTextView.text = @"";
    self.subtitleTextView.text = @"";
    self.autoDismiss = NO;

    switch (style) {

        case LVYBannerViewStyleAlert: {
            self.view.backgroundColor = [UIColor sf_primaryColor];
            self.titleTextView.textColor = [UIColor whiteColor];
            self.subtitleTextView.textColor = [UIColor whiteColor];
            self.titleTextView.text = @"You have a fresh listing";
            self.subtitleTextView.text = @"Tap to view";
            self.imageView.image = [UIImage imageNamed:@"cup3"];
            self.animationTypeIn = LVYBannerViewAnimationSlide;
            self.animationTypeOut = LVYBannerViewAnimationSlide;
            self.userInteractionAllowed = YES;
            self.autoDismiss = YES;
            break;
        }

            /*
        case LVYBannerViewStyleSuccess: {
            self.backgroundColor = [UIColor lvy_feedbackBarColorSuccess];
            self.imageView.image = [UIImage imageNamed:@"FeedbackIconSuccess"];
            self.titleTextView.textColor = [UIColor whiteColor];
            self.subtitleTextView.textColor = [UIColor whiteColor];
            break;
        }

        case LVYBannerViewStyleError: {
            self.backgroundColor = [UIColor lvy_feedbackBarColorError];
            self.imageView.image = [UIImage imageNamed:@"FeedbackIconError"];
            self.titleTextView.textColor = [UIColor whiteColor];
            self.subtitleTextView.textColor = [UIColor whiteColor];
            break;
        }

        case LVYBannerViewStyleInfo: {
            self.backgroundColor = [UIColor lvy_feedbackBarColorDefault];
            self.imageView.image = [UIImage imageNamed:@"FeedbackIconInfo"];
            self.titleTextView.textColor = [UIColor whiteColor];
            self.subtitleTextView.textColor = [UIColor whiteColor];
            break;
        }

        case LVYBannerViewStyleZoom: {
            self.backgroundColor = [UIColor lvy_feedbackBarColorDefault];
            self.imageView.image = [UIImage imageNamed:@"FeedbackIconZoom"];
            self.titleTextView.textColor = [UIColor whiteColor];
            self.subtitleTextView.textColor = [UIColor whiteColor];
            break;
        }
             */

        default: {
            self.backgroundColor = [UIColor sf_secondaryColor];
            self.titleTextView.textColor = [UIColor whiteColor];
            self.userInteractionAllowed = YES;
            self.subtitleTextView.textColor = [UIColor whiteColor];
            break;
        }
    }
}

+(SFBannerViewController *)bannerInViewController:(UIViewController*)parentViewController withStyle:(LVYBannerViewStyle)bannerStyle {

    __block SFBannerViewController * bannerView = [[SFBannerViewController alloc] init];

    bannerView.view.frame = CGRectMake(0, 0, parentViewController.view.frame.size.width, 0);

    [parentViewController addChildViewController:bannerView];
    [parentViewController.view addSubview:bannerView.view];
    [bannerView didMoveToParentViewController:parentViewController];

    [bannerView customizeWithStyle:bannerStyle];

    return bannerView;
}

-(void)showBanner {

    self.dismissing = NO;
    self.dismissed = NO;

    if(!self.userInteractionAllowed) {

        [self.view removeGestureRecognizer:self.panGestureRecognizer];
        self.panGestureRecognizer = nil;

        [self.view removeGestureRecognizer:self.tapGestureRecognizer];
        self.tapGestureRecognizer = nil;
    }

    if (!self.autoDismiss) {
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
    }

    switch(self.animationTypeIn) {

        case LVYBannerViewAnimationSlide:
            [self animateInRight];
            break;
        case LVYBannerViewAnimationAlphaFade:
            [self animateInAlpha];
            break;
        case LVYBannerViewAnimationHeight:
            [self animateInHeight];
            break;
        case LVYBannerViewAnimationNova:
            [self animateInNova];
            break;
        default:
            [self animateInRight];
            break;
    }

}

-(void)displayAutoDismissBannerWithCompletionHandler:(void(^)())completionHandler {
    self.autoDismiss = YES;
    self.storedCompletionHandler = completionHandler;
    [self showBanner];
}

-(void)hideBanner {
    self.dismissing = YES;
    [self animateDismissal];
}

#pragma mark - Theme Overrides or custom themeing
-(void)setTitleText:(NSString*)titleText color:(UIColor*)color {
    if (titleText) [self.titleTextView setText:titleText];
    if (color) self.titleTextView.textColor = color;
}

-(void)setSubtitleText:(NSString*)subtitleText color:(UIColor*)color {
    
    if(subtitleText) self.subtitleTextView.text = subtitleText;
    if (color) self.subtitleTextView.textColor = color;
}

-(void)setImage:(UIImage*)image {
    [self.imageView setImage:image];
}

-(void)setBackgroundColor:(UIColor*)backgroundColor {
    self.view.backgroundColor = backgroundColor ? backgroundColor : [UIColor sf_primaryColor];
}

-(void)setAnimationInStyle:(LVYBannerViewAnimation)animationIn {
    self.animationTypeIn = animationIn;
}

-(void)setAnimationOutStyle:(LVYBannerViewAnimation)animationOut {
    self.animationTypeOut = animationOut;
}

#pragma mark - Timer functionality

-(void)startDismissTimer {

    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:LVY_dismiss_time target:self selector:@selector(timerDismissFinished:) userInfo:nil repeats:NO];
}

-(void)delayDismissalTimer {

    if ([self.dismissTimer isValid]) {
        [self.dismissTimer invalidate];
    }

    self.dismissTimer = nil;
}

-(void)timerDismissFinished:(NSTimer*)timer {
    [self animateDismissal];
}

-(void)animateDismissal {

    [self delayDismissalTimer];

    if (self.userInteractionAllowed && self.wasTapped) {
        [self animateOutAlpha];
    } else {
        switch (self.animationTypeOut) {
            case LVYBannerViewAnimationAlphaFade:
                [self animateOutAlpha];
                break;
            case LVYBannerViewAnimationSlide:
                [self animateOutLeft];
                break;
            case LVYBannerViewAnimationHeight:
                [self animateOutHeight];
                break;
            case LVYBannerViewAnimationNova:
                [self animateOutSingularity];
                break;
        }
    }
}

-(void)animateOutLeft {

    __weak __block SFBannerViewController *weakSelf = self;
    __block CGRect final = self.view.frame;
    final.origin.x = 0.0f - final.size.width - 35.0f;

    [UIView animateWithDuration:.6f delay:0.0f usingSpringWithDamping:.8f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.frame = final;
        weakSelf.view.alpha = 0;

    }                completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissBanner];
        }
    }];

}

-(void)animateOutAlpha {

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.35f delay:0.0f usingSpringWithDamping:.8f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissBanner];
        }
    }];

}

-(void)animateOutHeight {
    __block CGRect final = self.view.frame;
    final.size.height = 0;

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.frame = final;
        weakSelf.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissBanner];
        }
    }];
}

-(void)animateInRight {
    __block CGRect final = self.view.frame;
    final.origin.x = final.size.width;
    final.size.height = LVYBannerViewHeight;

    self.view.frame = final;

    final.origin.x = 0;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && (!self.subtitleTextView.text || self.subtitleTextView.text.length == 0) ) {
        CGRect titleFrame = self.titleTextView.frame;
        titleFrame.size.height = LVYBannerViewHeight - 16;
        self.titleTextView.frame = titleFrame;
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    }

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.frame = final;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

-(void)animateInHeight {
    __block CGRect final = self.view.frame;
    final.size.height = LVYBannerViewHeight;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && (!self.subtitleTextView.text || self.subtitleTextView.text.length == 0) ) {
        CGRect titleFrame = self.titleTextView.frame;
        titleFrame.size.height = LVYBannerViewHeight - 16;
        self.titleTextView.frame = titleFrame;
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    }

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.frame = final;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

-(void)animateInAlpha {

    CGRect newRect = self.view.frame;
    newRect.size.height = LVYBannerViewHeight;
    self.view.frame = newRect;
    self.view.alpha = 0;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && (!self.subtitleTextView.text || self.subtitleTextView.text.length == 0) ) {
        CGRect titleFrame = self.titleTextView.frame;
        titleFrame.size.height = LVYBannerViewHeight - 16;
        self.titleTextView.frame = titleFrame;
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    }

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.alpha = 1.0f;

    } completion:^(BOOL finished) {

    }];
}

-(void)animateInNova {

    __block CGRect final = self.view.frame;
    final.size.height = LVYBannerViewHeight;

    CGRect newRect = self.view.frame;
    newRect.size.height = 0;
    newRect.size.width = 0;
    newRect.origin.x = self.view.frame.origin.x + self.view.frame.size.width/2; // offset
    newRect.origin.y = self.view.frame.origin.y + self.view.frame.size.height/2; // offset

    self.view.frame = newRect;
    //self.view.alpha = 0;

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.6f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        //weakSelf.view.alpha = 1.0f;
        weakSelf.view.frame = final;
    } completion:nil];

}

-(void)animateOutSingularity {

    __block CGRect final = self.view.frame;
    final.size.height = 0;
    final.size.width = 0;
    final.origin.x = self.view.frame.size.width/2;
    final.origin.y = self.view.frame.size.height/2;

    __weak __block SFBannerViewController *weakSelf = self;
    [UIView animateWithDuration:.6f delay:0 usingSpringWithDamping:.5f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^() {
        weakSelf.view.frame = final;
        //weakSelf.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissBanner];
        }
    }];

}


-(void)dismissBanner {
    self.dismissed = NO;
    self.view.hidden = YES;
    [self removeFromParentViewController];
    [self.view removeFromSuperview];

    if (self.storedCompletionHandler) {
        self.storedCompletionHandler();
    }

    if (self.wasTapped) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LVYBannerWasTappedMessage"/*LVYBannerWasTappedMessage*/ object:nil userInfo:nil];
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer*)recognizer {

    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect next = recognizer.view.frame;
        next.origin.x = next.origin.x + translation.x;
        recognizer.view.frame = next;
        CGFloat a = 1.0f - (fabs(next.origin.x) / recognizer.view.frame.size.width);
        recognizer.view.alpha = a;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

        [self delayDismissalTimer];

    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        //DDLogInfo(@"Mag: %f", magnitude);
        //DDLogInfo(@"Origin: x: %f y: %f", recognizer.view.frame.origin.x, recognizer.view.frame.origin.y);

        if (magnitude > 1500) {
            //DDLogInfo(@"Dismissed");
            [self animateDismissal];

        } else {

            CGRect final = recognizer.view.frame;
            final.origin.x = 0;

            [UIView animateWithDuration:.35f delay:0.0f usingSpringWithDamping:.8f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recognizer.view.frame = final;
            } completion:^(BOOL finished) {
                [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
                [self startDismissTimer];
            }];

        }
    }
}

-(void)openPushNotification:(UITapGestureRecognizer*)recognizer {
    self.wasTapped = YES;
    [self animateDismissal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
