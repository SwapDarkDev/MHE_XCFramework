//
//  HSNoteCell.h
//  ePUBSDK
//
//  Created by Vikas Dalvi on 23/04/16.
//
//

#import <UIKit/UIKit.h>
#import "ReaderHeader.h"
@protocol MyDataNoteCellDelegate <NSObject>

-(void)showCommentsViewForIndex:(NSInteger)index;
-(void)showShareViewForIndex:(NSInteger)index;

@end

@interface KBMyDataNoteCell : UITableViewCell

@property (weak, nonatomic) id<MyDataNoteCellDelegate>delegate;

@property (strong, nonatomic) NSString *localId;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *highlightLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintOfNoteLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfCommentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightlightTextBottomConstraint;

@property (nonatomic,assign)NSInteger index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highlightLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfComment;

- (void)updateCellWithChapterName:(NSString *)chapterName date:(NSString *)date text:(NSString *)highlightText noteText:(NSString *)noteText color:(UIColor *)color commentsCount:(NSString *)commentCount shareCount:(NSString *)shareCount withButtonColors:(UIColor*)buttonsColor;
- (void)showShareButton:(BOOL)sharingEnabled;
- (void)showCommentButton:(BOOL)sharingEnabled;
@end
