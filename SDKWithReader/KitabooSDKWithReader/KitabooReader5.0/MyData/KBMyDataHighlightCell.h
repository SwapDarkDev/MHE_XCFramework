//
//  ePUBMyDataCell.h
//  ePUBSDK
//
//  Created by vikas on 11/03/16.
//
//

#import <UIKit/UIKit.h>

@interface KBMyDataHighlightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTextLabel;

- (void)updateCellWithChapterName:(NSString *)chapterName date:(NSString *)date text:(NSString *)highlightText color:(UIColor *)color;

@end
