//
//  HSNoteAnswerCell.m
//  Kitaboo
//
//  Created by vikas on 13/07/16.
//  Copyright © 2016 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "KBMyDataNoteAnswerCell.h"
#import "HSUIColor-Expanded.h"
#import "Constant.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define LocalizationBundleForKBMyDataNoteAnswerCell  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

@implementation KBMyDataNoteAnswerCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _rejectButton.layer.borderWidth = 1.0f;
    _rejectButton.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
    [_acceptButton setTitle:NSLocalizedStringFromTableInBundle(@"MY_DATA_ACCEPT",READER_LOCALIZABLE_TABLE, LocalizationBundleForKBMyDataNoteAnswerCell, "") forState:UIControlStateNormal];
    [_rejectButton setTitle:NSLocalizedStringFromTableInBundle(@"MY_DATA_DECLINE",READER_LOCALIZABLE_TABLE, LocalizationBundleForKBMyDataNoteAnswerCell, "") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)acceptButtonTapped:(UIButton *)sender {
    [_delegate didTapOnAcceptButton:_ugcId];
}

- (IBAction)rejectButtonTapped:(UIButton *)sender {
    [_delegate didTapOnRejectButton:_ugcId];
}

@end
