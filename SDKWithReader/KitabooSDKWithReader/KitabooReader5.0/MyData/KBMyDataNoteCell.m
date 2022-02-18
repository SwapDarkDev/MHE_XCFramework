//
//  HSNoteCell.m
//  ePUBSDK
//
//  Created by Vikas Dalvi on 23/04/16.
//
//

#import "KBMyDataNoteCell.h"
#import "HSUIColor-Expanded.h"
#import "ReaderHeader.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define LocalizationBundleForKBMyDataNoteCell  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

@implementation KBMyDataNoteCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateCellWithChapterName:(NSString *)chapterName date:(NSString *)date text:(NSString *)highlightText noteText:(NSString *)noteText color:(UIColor *)color commentsCount:(NSString *)commentCount shareCount:(NSString *)shareCount withButtonColors:(UIColor*)buttonsColor{
    
    _chapterNameLabel.text = [NSString stringWithFormat:@"%@ : %@",[LocalizationHelper localizedStringWithKey:@"CHAPTER_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataNoteCell], chapterName];
    
    _dateLabel.text = date;
//    _noteTextLabel.textColor =  _highlightLabel.textColor = [UIColor lightGrayColor];
    _noteTextLabel.text = noteText;
    if(highlightText.length){
        _hightlightTextBottomConstraint.constant = 6;
         _highlightLabelHeightConstraint.constant = 34;
    }
    else{
        _hightlightTextBottomConstraint.constant = 0;
        _highlightLabelHeightConstraint.constant = 0;
    }
    _highlightLabel.text = highlightText;
    _iconLabel.textColor = color;
    if(isRTL()){
        [_commentButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_COMMENT Text:[NSString stringWithFormat:@"  %@ %@",[LocalizationHelper localizedStringWithKey:@"MY_DATA_COMMENTS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataNoteCell], commentCount] withTitleColor:buttonsColor] forState:UIControlStateNormal];
    }
    else{
        [_commentButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_COMMENT Text:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"MY_DATA_COMMENTS", READER_LOCALIZABLE_TABLE, LocalizationBundleForKBMyDataNoteCell, nil), commentCount]  withTitleColor:buttonsColor] forState:UIControlStateNormal];
    }
    if([commentCount intValue] == 0){
        [_commentButton setAlpha:0.4];
        [_commentButton setUserInteractionEnabled:NO];
    }
    else{
        [_commentButton setAlpha:1];
        [_commentButton setUserInteractionEnabled:YES];
    }
    [_shareButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_SHARE Text:[NSString stringWithFormat:@"  %@ %@",[LocalizationHelper localizedStringWithKey:@"SHARE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataNoteCell], shareCount] withTitleColor:buttonsColor] forState:UIControlStateNormal];
    
    self.heightConstraintOfComment.constant = 30;
    [self layoutIfNeeded];
}

- (void)showShareButton:(BOOL)sharingEnabled{
    if (!sharingEnabled) {
        _shareButtonHeightConstraint.constant = 0.0f;
        _shareButton.hidden = YES;
    } else {
        _shareButtonHeightConstraint.constant = 30.0f;
        _shareButton.hidden = NO;
        _shareButton.contentHorizontalAlignment = NSTextAlignmentNatural;
    }
}

- (void)showCommentButton:(BOOL)sharingEnabled{
    if (!sharingEnabled) {
        _heightConstraintOfCommentButton.constant = 0.0f;
        _commentButton.hidden = YES;
    } else {
        _heightConstraintOfCommentButton.constant = 30.0f;
        _commentButton.hidden = NO;
        _commentButton.contentHorizontalAlignment = NSTextAlignmentNatural;
    }
}

-(void)disableCommentAndShareSection{
    _heightConstraintOfCommentButton.constant = 0;
    _shareButtonHeightConstraint.constant = 0;
    _bottomConstraintOfNoteLbl.constant = 2;
}


- (IBAction)shareNoteTapped:(id)sender {
    [_delegate showShareViewForIndex:_index];
}

-(IBAction)commentButtonAction:(id)sender{
    [_delegate showCommentsViewForIndex:_index];
}

-(NSMutableAttributedString *)getAttributtedTextWithIcon:(NSString *)icon Text:(NSString*)textStr withTitleColor:(UIColor*)titleColor{
    
    UIFont *font1 = [UIFont fontWithName:[HDIconFontConstants getFontName]
                                    size:isIpad()? 16.0 : 15.0];
    UIFont *font2 = getCustomFont(isIpad()? 15.0 :14);
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:font1,NSBaselineOffsetAttributeName:@-1.5};
    NSDictionary *dict2 = @{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:font2};

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    if(isRTL())
    {
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\u200e%@  ",textStr]  attributes:dict2]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:icon  attributes:dict1]];
    }
    else
    {
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:icon  attributes:dict1]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:textStr  attributes:dict2]];
    }
  
    return  attString;
}
@end
