//
//  SFMessageThreadViewController.m
//  Lovely
//
//  Created by Kaili Hill on 5/7/15.
//  Copyright (c) 2015 Lovely. All rights reserved.
//

#import "SFMessageThreadViewController.h"
#import "SFMessage.h"
#import "SFMessageTableViewCell.h"
#import "SFNetworkingManager.h"

@interface SFMessageThreadViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic) IBOutlet UIView* sendMessageContainer;
@property (nonatomic) IBOutlet UITextView* composeTextField;
@property (nonatomic) IBOutlet UIButton* sendButton;
@property (nonatomic) NSMutableArray* messages;

@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) IBOutlet NSLayoutConstraint *sendMessageContainerHeightConstant;

@property (nonatomic) Firebase* firebase;

@end

@implementation SFMessageThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // most recent at bottom
    // scroll bottom
    [self.tableView setContentInset:UIEdgeInsetsMake(64.0f, 0, 0, 0)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped:)];
    [self.tableView addGestureRecognizer:self.tapGestureRecognizer];

    self.composeTextField.layer.cornerRadius = 4;
    self.composeTextField.layer.borderWidth = 1.5;
    self.composeTextField.layer.borderColor = [UIColor whiteColor].CGColor;

    self.messages = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftAlignCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightAlignCell"];

    __block BOOL initialAdds = YES;
    __block BOOL hadUpdate = NO;

    self.firebase = [[SFNetworkingManager instance] getFirebaseRefForMessageThread:@"sarahexidhere"];
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.

        // Make a message from the snapshot value

        if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
            SFMessage *message = [[SFMessage alloc] initWithJSON:snapshot.value];
            [self.messages addObject:message];

            if (!initialAdds) {
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                NSIndexPath *ipath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

        } else {
            NSLog(@"Not dictionary value: %@", snapshot.value);
        }

    }];

    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        if (initialAdds) {
            [self.tableView reloadData];
        }

        initialAdds = NO;
    }];

}

-(void)viewDidDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [super viewDidDisappear:animated];

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
    return self.messages.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SFMessage * message = self.messages[indexPath.row];

    CGSize size = [message.message boundingRectWithSize:CGSizeMake(tableView.frame.size.width*(.66f)-24.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size;

    //CGSize size = [message.message sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}];

    return MAX(size.height + 12, 44) + 16;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SFMessageTableViewCell * cell;

    SFMessage * message = self.messages[indexPath.row];

    if (message.isMe) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LeftAlignCell" forIndexPath:indexPath];
        [cell configureWithMessage:message.message style:LVYMessageTableViewCellStyleLeft];

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RightAlignCell" forIndexPath:indexPath];
        [cell configureWithMessage:message.message style:LVYMessageTableViewCellStyleRight];
    }


    CGFloat offset = 0.0f;//tableView.contentOffset.y;
    /*if (tableView.contentOffset.y < 0) {
        offset = offset + 64.0f;
    }*/
    CGPoint origin = cell.frame.origin;
    CGFloat percent = (origin.y-offset) / self.view.frame.size.height;

    percent = MIN(1.0f, percent);
    percent = MAX(0.0f, percent);


    [cell modifyColorDarknessForPercentToBottom:percent];

    return cell;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y < 0) {
        offset = offset + 64.0f;
    }

    for(SFMessageTableViewCell * cell in self.tableView.visibleCells) {

        CGPoint origin = cell.frame.origin;

        CGFloat percent = (origin.y-offset) / self.view.frame.size.height ;

        percent = MIN(1.0f, percent);
        percent = MAX(0.0f, percent);

        [cell modifyColorDarknessForPercentToBottom:percent];
    }

}

-(IBAction)sendMessage:(id)sender {

    SFMessage * message = [[SFMessage alloc] initWithMessage:self.composeTextField.text sent:[NSDate new] isMine:YES];

    [[SFNetworkingManager instance] sendMessage:message withFirebaseChatRef:self.firebase];

    /*
    [self.messages addObject:message];

    //[self.tableView reloadData];

    [self.tableView beginUpdates];

    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];

    [self.tableView endUpdates];

    NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.messages.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    */

    self.composeTextField.text = @"";

    [self textViewDidChange:self.composeTextField];
}

-(void)newMessageReceived {

    // TODO probably should take in the message

    [self.tableView reloadData];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.messages.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

-(void)tableViewTapped:(UITapGestureRecognizer *)recognizer {

    [self.composeTextField resignFirstResponder];

}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : textView.font} context:nil].size;
    textView.scrollEnabled = NO;
    self.sendMessageContainerHeightConstant.constant = MIN(self.view.frame.size.height-64 , MAX(MAX(size.height+35.0f, 32.0f), 48.0f)); // Let this fill the entire screen??
    textView.scrollEnabled = YES;

    [self.sendMessageContainer setNeedsLayout];
    [self.view setNeedsLayout];

}

@end
