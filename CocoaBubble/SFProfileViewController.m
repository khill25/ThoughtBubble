//
//  SFProfileViewController.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/4/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFProfileViewController.h"
#import "SFBannerViewController.h"
#import "SFSettings.h"

@interface SFProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *boopButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation SFProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 2.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)boopButtonTapped:(id)sender {
    
    // You can't boop yourself!

    SFBannerViewController *bannerView = [SFBannerViewController bannerInViewController:self withStyle:-1];

    CGRect bannerFrame = bannerView.view.frame;
    bannerFrame.origin.y = 20;
    bannerView.view.frame = bannerFrame;
    [bannerView setTitleText:@"You can't boop yourself!" color:[UIColor whiteColor]];
    [bannerView setBackgroundColor:[UIColor sf_secondaryColor]];
    [bannerView setAnimationInStyle:LVYBannerViewAnimationSlide];
    [bannerView setAnimationOutStyle:LVYBannerViewAnimationSlide];
    [bannerView displayAutoDismissBannerWithCompletionHandler:nil];

}

@end
