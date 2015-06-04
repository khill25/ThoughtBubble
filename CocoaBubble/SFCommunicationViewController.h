//
//  SFCommunicationViewController.h
//  CocoaBubble
//
//  Created by Kaili Hill on 6/3/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCommunicationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

-(id)initWithNibName:(NSString*)nibName bundle:(NSBundle *)nibBundleOrNil sendBlock:(void(^)(NSString* message))sentMessageTapped;

@end
