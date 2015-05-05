//
//  SFLandingViewController.m
//  CocoaBubble
//
//  Created by Kaili Hill on 2/9/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFLandingViewController.h"
#import "SFMapViewController.h"

@interface SFLandingViewController ()

@end

@implementation SFLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabController = [[UITabBarController alloc] init];
    self.mapViewController = [[SFMapViewController alloc] init];

    UIImage* cup = [UIImage imageNamed:@"cup3.png"];

    /*CGRect frame = CGRectMake(0,0,64,64);
    UIButton* barItem = [[UIButton alloc] initWithFrame:frame];
    [barItem setBackgroundImage:cup forState:UIControlStateNormal];
    */

    UITabBarItem *item = [[UITabBarItem alloc] init];
    [item setImage:cup];

    [self.tabController setTabBarItem:item];

    //_mapViewController.tabBarItem.title = @"Explore";

    self.tabController.view.frame = self.view.frame;

    // Wrap up the map into navigaton controller
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:_mapViewController];

    [self.tabController setViewControllers:@[controller]];

    UIImage* refreshImage = [UIImage imageNamed:@"refresh62.png"];
    CGRect refreshFrame = CGRectMake(0,0,64,64);
    UIButton* refresh = [[UIButton alloc] initWithFrame:refreshFrame];
    [refresh setImage:refreshImage forState:UIControlStateNormal];

    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc] initWithCustomView:refresh];
    [self.navigationController.navigationItem setLeftBarButtonItem:refreshButton animated:YES];

    [self.view addSubview:_tabController.view];

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

@end
