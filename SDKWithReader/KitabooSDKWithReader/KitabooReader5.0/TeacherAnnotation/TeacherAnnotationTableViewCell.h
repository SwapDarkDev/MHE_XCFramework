//
//  TeacherAnnotationTableViewCell.h
//  Kitaboo
//
//  Created by Hurix System on 27/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RefreshButtonAction)(NSString *studentName, NSString *studenId, NSIndexPath *indexpath);

@interface TeacherAnnotationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *checkMarkLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) NSString *studenId;
@property (weak, nonatomic) NSIndexPath *indexpath;
@property (weak, nonatomic) NSString *studentName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dotViewLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property(strong,nonatomic) RefreshButtonAction refreshButtonAction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthConstraint;

@end
