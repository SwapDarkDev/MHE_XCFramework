//
//  TeacherAnnotationTableViewCell.m
//  Kitaboo
//
//  Created by Hurix System on 27/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "TeacherAnnotationTableViewCell.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "HSUIColor-Expanded.h"
#import "ReaderHeader.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define LocalizationBundleForTeacherAnnotationTableViewCell  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

@implementation TeacherAnnotationTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.dotView.clipsToBounds=YES;
    [self bringSubviewToFront:_activityIndicatorView];
    [self.checkMarkLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:25]];
    [self.checkMarkLabel setText:ICON_CHECK];
    [self.checkMarkLabel setHidden:YES];
    [self.refreshButton layoutIfNeeded];
    self.refreshButton.layer.cornerRadius = 8;
    [self.refreshButton.layer setBorderWidth:1.0];
    self.refreshButton.hidden = YES;
    self.refreshButton.titleLabel.font = getCustomFont(isIpad()?12:10);
    [self.refreshButton setTitle:NSLocalizedStringFromTableInBundle(@"REFRESH",READER_LOCALIZABLE_TABLE, LocalizationBundleForTeacherAnnotationTableViewCell, nil) forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapOnRefreshButton:(id)sender
{
    if (self.refreshButtonAction)
    {
        self.refreshButtonAction(self.studentName, self.studenId, self.indexpath);
    }
}

@end
