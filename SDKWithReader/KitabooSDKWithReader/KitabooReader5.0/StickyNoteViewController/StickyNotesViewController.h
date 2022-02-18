//
//  StickyNotesViewController.h
//  Kitaboo
//
//  Created by Priyanka Singh on 24/04/18.
//  Copyright © 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HighlightTool.h"
#import "ReaderHeader.h"
#import "HDReaderSettingModel.h"

typedef void(^NoteBtnAction)(SDKHighlightVO *currentHighLightVO);
typedef void(^NoteShareAction)(SDKHighlightVO *currentHighLightVO,NSString *selectedColor,NSString *noteText);

@interface StickyNotesViewController : UIViewController
@property (nonatomic,strong) SDKHighlightVO*  currentHighlightVO;
@property (strong,nonatomic) NoteBtnAction noteCancelAction;
@property (strong,nonatomic) NoteBtnAction notePostAction;
@property (strong,nonatomic) NoteBtnAction noteDeleteAction;
@property (strong,nonatomic) NoteShareAction noteShareAction;
@property (strong,nonatomic) NoteBtnAction postCommentAction;
@property (weak,nonatomic) IBOutlet UIView *stickyNoteContainerView;
@property (nonatomic,strong) HDReaderSettingModel *userSettingsModel;
-(void)showShareButton:(BOOL)showShare;
-(void)setCurrentUser:(KitabooUser*)kitabooUser;
-(void)setTheme:(KBHDThemeVO *)themeVO;
@end
