//
//  KBShareSettingsCell.m
//  Kitaboo
//
//  Created by Priyanka Singh on 24/08/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "KBShareSettingsCell.h"
#import "ReaderHeader.h"
#define kThemeColor @"#52AE78"

@implementation KBShareSettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _shareButton.layer.borderWidth = _receiveButton.layer.borderWidth = 1.0;
//    _shareButton.layer.borderColor = _receiveButton.layer.borderColor = [UIColor colorWithHexString:kThemeColor].CGColor;
    
    [_shareButton setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateHighlighted];
    [_shareButton setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateSelected];
    
    [_receiveButton setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateNormal];
    [_receiveButton setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateHighlighted];
    [_receiveButton setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)shareButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.tag==kCellTypeStudentHeader)
    {
        [_delegate didShareNoteWillAllStudents:sender];
    }
    else if (sender.tag==kCellTypeTeacherHeader)
    {
        [_delegate didShareNoteWillAllTeachers:sender];
    }
    else
    {
        [_delegate didShareSettingEnabled:sender.selected forUser:_shareUserId];
    }
}

- (IBAction)receiveButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_delegate didReceiveSettingEnabled:sender.selected forUser:_shareUserId];
}


@end
