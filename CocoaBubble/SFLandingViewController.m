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
    
    _tabController = [[UITabBarController alloc] init];
    _mapViewController = [[SFMapViewController alloc] init];
    _mapViewController.tabBarItem.title = @"Map";

    _tabController.view.frame = self.view.frame;

    [_tabController setViewControllers:@[_mapViewController]];
    
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
