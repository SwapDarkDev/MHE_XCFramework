//
//  ePUBMyDataCell.m
//  ePUBSDK
//
//  Created by vikas on 11/03/16.
//
//

#import "KBMyDataHighlightCell.h"
#import "HSUIColor-Expanded.h"
#import "ReaderHeader.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define LocalizationBundleForKBMyDataHighlightCell  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]


@implementation KBMyDataHighlightCell
- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateCellWithChapterName:(NSString *)chapterName date:(NSString *)date text:(NSString *)highlightText color:(UIColor *)color{

   // _chapterTitleLabel.text = [NSString stringWithFormat:@"%@ : %@",[LocalizationHelper localizedStringWithKey:@"CHAPTER_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataHighlightCell], chapterName];
    _dateLabel.text = date;
    _noteTextLabel.text = highlightText;
    _iconLabel.textColor = color;
}

@end
