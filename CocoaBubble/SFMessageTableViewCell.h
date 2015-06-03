//
//  SFMessageTableViewCell.h
//  Lovely
//
//  Created by Kaili Hill on 5/13/15.
//  Copyright (c) 2015 Lovely. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LVYMessageTableViewCellStyle) {
    
    LVYMessageTableViewCellStyleLeft,
    LVYMessageTableViewCellStyleRight
    
};

@interface SFMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *messageStyleView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIndentConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIndetContraint;

-(void)configureWithMessage:(NSString*)message style:(LVYMessageTableViewCellStyle)style;
-(void)modifyColorDarknessForPercentToBottom:(CGFloat)percentToBottom;

@end
