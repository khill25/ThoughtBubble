//
//  SFCommunicationViewController.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/3/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFCommunicationViewController.h"

@interface SFCommunicationViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;

@property (nonatomic) NSInteger MAX_MESSAGE_LENGTH;

@property (nonatomic, copy) void(^sendMessage)(NSString* message);
@end

@implementation SFCommunicationViewController

-(id)initWithNibName:(NSString*)nibName bundle:(NSBundle *)nibBundleOrNil sendBlock:(void(^)(NSString* message))sendMessage {

    if (self = [super initWithNibName:nibName bundle:nibBundleOrNil]) {

        self.MAX_MESSAGE_LENGTH = 140;
        self.sendMessage = sendMessage;
    }

    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.textView.layer.cornerRadius = 4;
    self.textView.layer.borderWidth = 1.5;
    self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSInteger totalLength = textView.text.length + range.length;

    if (totalLength > self.MAX_MESSAGE_LENGTH-1) {
        return NO;
    }

    self.totalCharactersLabel.text = [NSString stringWithFormat:@"%d / %d", totalLength+1, self.MAX_MESSAGE_LENGTH];
    self.charactersRemainingLabel.text = [NSString stringWithFormat:@"%d left", self.MAX_MESSAGE_LENGTH - (totalLength + 1)];

    return YES;
}

-(IBAction)sendButtonTapped:(id)sender {
    self.sendMessage(self.textView.text);
}

@end
