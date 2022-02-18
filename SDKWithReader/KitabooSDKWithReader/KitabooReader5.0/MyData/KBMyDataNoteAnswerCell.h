//
//  HSNoteAnswerCell.h
//  Kitaboo
//
//  Created by vikas on 13/07/16.
//  Copyright © 2016 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDataNoteAnswerCellDelegate <NSObject>

- (void)didTapOnAcceptButton:(NSString *)ugcId;
- (void)didTapOnRejectButton:(NSString *)ugcId;

@end


@interface KBMyDataNoteAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (strong, nonatomic) NSString *ugcId;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) id<MyDataNoteAnswerCellDelegate>delegate;

@end
