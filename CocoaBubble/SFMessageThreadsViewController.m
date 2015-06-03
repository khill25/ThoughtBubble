//
//  SFMessageThreadsViewController.m
//  Lovely
//
//  Created by Kaili Hill on 5/7/15.
//  Copyright (c) 2015 Lovely. All rights reserved.
//

#import "SFMessageThreadsViewController.h"
#import "SFMessageThreadViewController.h"

@interface SFMessageThreadsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView* tableView;

@property NSMutableArray* openThreads;

@end

@implementation SFMessageThreadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.openThreads = [[NSMutableArray alloc] init];

    [self.openThreads addObject:@"Message goes here. Probably want an object to represent this"];

    self.title = @"Messages";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ThreadCell"];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openThreads.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"ThreadCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ThreadCell"];
        cell.textLabel.text = @"Sara";
        cell.detailTextLabel.text = @"Thanks for messaging me Sara. I appricate your reply.";
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SFMessageThreadViewController * controller = [[SFMessageThreadViewController alloc] initWithNibName:@"SFMessageThreadViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

@end
