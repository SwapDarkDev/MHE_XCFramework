//
//  KBShareSettingsCell.h
//  Kitaboo
//
//  Created by Priyanka Singh on 24/08/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : short {

    kCellTypeStudentHeader = 1001,
    kCellTypeTeacherHeader = 1002,
    kCellTypeNormal = 1003
} CellType;

@protocol KBShareSettingsCellDelegate <NSObject>
- (void)didShareSettingEnabled:(BOOL)enabled forUser:(NSNumber *)shareUserId;
- (void)didReceiveSettingEnabled:(BOOL)enabled forUser:(NSNumber *)shareUserId;
- (void)didShareNoteWillAllStudents:(UIButton *)sender;
- (void)didShareNoteWillAllTeachers:(UIButton *)sender;
@end

@interface KBShareSettingsCell : UITableViewCell
@property (strong, nonatomic) NSNumber *shareUserId;
@property (weak, nonatomic) id<KBShareSettingsCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *shareUserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sharingButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameLblLeadingConstraint;
@property (nonatomic, assign) BOOL isStudentAllForNote;
@property (nonatomic, assign) BOOL isTeacherAllForNote;
@end
