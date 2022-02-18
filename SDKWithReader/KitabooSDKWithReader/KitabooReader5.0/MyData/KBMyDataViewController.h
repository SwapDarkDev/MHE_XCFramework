//
//  MyDataViewController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderHeader.h"
#import "HDReaderSettingModel.h"

@protocol KBMyDataControllerDelegate <NSObject>
@optional
/**
 *  Will be called when the user Navigate to specific pageID
 * @param1 pageID is the PageNumber where user navigates
 */
- (void)navigateTopage:(NSString *)pageID;

/**
 * Will be called when user is on Highlights segmant and tap on My highlights
 */
- (void)didTapOnHighlightsSegmentWithMyHighlights;

/**
 * Will be called when user is on Highlights segmant and tap on Shared with me
 */
- (void)didTapOnHighlightsSegmentWithSharedWithMe;

/**
 * Will be called when user is on Highlights segmant and tap on Important
 */
- (void)didTapOnImportantHighlights;


/**
 * Will be called when user is on Notes segmant and tap on My notes
 */
- (void)didTapOnNotesSegmentWithMyNotes;

/**
 * Will be called when user is on Notes segmant and tap on Shared with me
 */
- (void)didTapOnNotesSegmentWithSharedWithMe;

/**
 * Will be called when user is on Notes segmant and tap on Important
 */
- (void)didTapOnImportantNotes;


/**
 * Will be called when user tap on Share Settings
 */
- (void)didTapOnShareSettings;


/**
 * Will be called when user tap on Share Settings
 */
- (void)didTapOnNoteShareSettings:(SDKHighlightVO *)highlightVO;

- (void)didTapOnNotesComment:(SDKHighlightVO *)highlightVO;

/**
 * Will be called when user perform action to close the My Data
 */
-(void)didSelectActionToCloseMyData;

/**
 Will be called when user tap on accept/reject in note tab
 */
- (void)didAnsweredHighlight:(SDKHighlightVO *)highlightVO accepted:(BOOL) accepted;

/**
 * Will be called when user tap on Print Button
 */
- (void)didTapOnPrint;

@end
typedef void(^ShareCommentButtonAction)(SDKHighlightVO *highlightVO);

typedef enum{
    
    HIGHLIGHT = 100,
    NOTE = 101,
    NOTIFICATION = 102
} FilterMydata;

@interface KBMyDataViewController : UIViewController{
    
}
@property (nonatomic,strong)  KBHDThemeVO *themeVO;

@property (nonatomic,assign)  BOOL isMyDataNotificationController;
@property (nonatomic) ShareCommentButtonAction shareButtonAction;
@property (nonatomic) ShareCommentButtonAction commentButtonAction;
@property (nonatomic) BookOrientationMode bookOrientationMode;
@property (nonatomic, strong)HDReaderSettingModel *userSettingsModel;
@property (nonatomic,assign) FilterMydata selectedSegment;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIButton *highlightButton;
@property (weak, nonatomic) IBOutlet UILabel *highlightCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *notesButton;
@property (weak, nonatomic) IBOutlet UILabel *noteCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationIcon;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *shareSettingsButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedButonBorderView;
@property (weak, nonatomic) IBOutlet UIView *myDataContainerView;
@property (weak, nonatomic) IBOutlet UIButton *backButtonText;

@property (weak, nonatomic) IBOutlet UIButton *printButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *printBtnTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notesBtnLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedBtnLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterBtnLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareSettingWidthConstraint;

@property (nonatomic,assign) BOOL isShareSettingsDisabled;
@property (nonatomic,assign) BOOL isShareWithMeDisabled;

/**
 * User should set the necessary data for displaying the data/content
 @param1 data is the array object where user need to set for specific segment tap
 */
- (void)setData:(NSArray *)data;


/**
 * User should set the BOOL for disabling the Share Settings
 @param1 disable is the Boolean object for disabling the Share Settings
 */
- (void)disableShareSettings:(BOOL)disable;


/**
 * User should set the BOOL for disabling the Share with me
 @param1 disable is the Boolean object for disabling the Share with me
 */
- (void)disableShareWithMeTab:(BOOL)disable;

@property (nonatomic,weak)id<KBMyDataControllerDelegate>delegate;

/**
 * This method used to  set text color to no data label
 @param1 color pass the color to set the no data label text color
 */
-(void)setNoDataLabelTextColor:(UIColor *)color;

/**
 * This method used to reload the MyData tableview to update the data
 */
- (void)reloadMyDataTableView;
- (void)filterData;
@property (strong, nonatomic) KitabooBookVO * book;

- (void)disableShareSettingsIcon:(BOOL)disable;
- (void)disableNoteNotification:(BOOL)disable;
@end
