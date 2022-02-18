//
//  StickyNoteCommentCell.h
//  Kitaboo
//
//  Created by Naidu on 04/06/2015.
//  Copyright (c) 2015 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickyNoteCommentCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *stickyCommentDateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *stickyCommentCreatedBy;
@property (weak, nonatomic) IBOutlet UILabel *stickyCommentLbl;
@property (weak, nonatomic) IBOutlet UIView *containerViewForMyComment;
@property (weak, nonatomic) IBOutlet UILabel *nameLablForMyComment;
@property (weak, nonatomic) IBOutlet UILabel *timeLblOfMyComments;
@property (weak, nonatomic) IBOutlet UILabel *myCommentLbl;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
