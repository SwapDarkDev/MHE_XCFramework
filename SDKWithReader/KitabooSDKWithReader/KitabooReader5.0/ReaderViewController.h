//
//  ReaderViewController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "HDReaderSettingModel.h"
#import "Constant.h"
#import "ReaderHeader.h"


#define playerTopBar_Height 60
#define playerTopBar_HeightIphone isIpad()?58:50
#define itemAction_width isIpad()?playerTopBar_Height -14:playerTopBar_HeightIphone-8
#define itemAction_top isIpad()?15:12
#define itemAction_bottom isIpad()?-15:-12

#define LocalizationBundleForReaderViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[ReaderViewController class]]

@protocol ReaderViewControllerDelegate<NSObject>

/**
This method should be called when ReaderViewController is closed/dismissed.
* @param1 reader  is the UIViewController object
* @param2 bookID  of the current book that is closed
* @param3 lastPageFolio  of the current book that is closed
* @param4 avgTimePerPage  of the current book that is closed
* @param5 isReaderForceClosed  is boolean which indicates whether the reader has been closed force fully i.e, if the session is expired for reader.If the user manually closes the reader i.e when tapped on back or signout button, then the value will be NO.
*/
@optional
-(void)didClosedReader:(UIViewController *)reader ForBookID:(NSNumber *)bookID withLastPageFolio:(NSString *)lastPageFolio withAvgTimePerPage:(NSNumber *)avgTimePerPage withIsReaderForceClosed:(BOOL)isReaderForceClosed;

/**
 This method should be called when ReaderViewController session is expired.
 * @param1 reader  is the UIViewController object
 */
- (void)didSessionExpiredForReader:(UIViewController *)reader;

/**
This method will be called when user tap on the profile pic icon
* @param1 view  UIView on which the user has tapped
*/
-(void)didTapOnProfilePic:(UIView*)view;

/**
This method will be called to remove the profile popover view
*/
-(void)didRemoveProfilePopOver;

/**
This method will be called when current user session is expired and when the Audio Login configuation is enabled for the user.It provides user the flexibilibity to renew the expired session
* @param1 user is the expired KitabooUser object
* @param2 expiredUserToken is the expired user token
* @param3 completionHandler is the block which will be executed when user session is successfully renewed.
*/
- (void)refreshUserTokenForUser:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken completed:(void (^)(KitabooUser *renewedUser))completionHandler;

/**
This method will be called when the ReaderViewController is closed/dismissed due to expiry of current user
* @param1 user is the expired KitabooUser object.
*/
- (void)didSignOutForUser:(KitabooUser *)user;


/**
This method will be called when user taps on the JumpToBook mark inside the Reader.
* @param1 bookID is the book where user need to launch
* @param2 pageId is the page number where used need to navigate after launching the desired book
*/
-(void)jumpToBookReaderForBookID:(NSString *)bookID withBookId:(NSString *)pageId;


/**
This method will be called to check whether the specific book is downloaded or not.This will be used when user want to launch the some other book when taps on the JumpToBook markup.
* @param1 bookID is the book where user need to check it is downloaded or not
*/
-(BOOL)isBookDownloadedForBookID:(NSString *)bookID;

/**
This method will be called when user closes/dismiss the Reader and newly created/updated ugc sync is in progress
* @param1 syncInProgress is the boolean which represents if the newly created/updated ugc is present or not.
*/
-(void)checkUgcSyncInProgress:(BOOL)syncInProgress;

/**
This method will be called when user the book is successfullt loaded.
* @param1 bookVO is the KitabooBookVO object which is successfully loaded.
*/
-(void)didBookLoadedSuccessfullyWithBook:(KitabooBookVO*)bookVO;

/**
This method will be called when user closes/dismiss the Reader
* @param1 bookID is the book which user has closed/dismissed
* @param2 lastPageFolio is the last page which user has been reading befor closing/dismissing the Reader
*/
-(void)didLastVisitedFolioNumberForBookID:(NSNumber *)bookID withLastPageFolio:(NSString *)lastPageFolio;

/**
This method will be called when there is any update in the book reading percentage
* @param1 bookID is the book
* @param2 percentageRead is the percentageRead of reflowable book
*/
-(void)didUpdatedReadPercentageTo:(NSInteger)percentageRead ForBookID:(NSString *)bookID;

/**
This method will be called when furthest visited page updated.
 * @param1 furthestPageData is the information for the further visited page.
 * @param2 bookID of type NSString.
 * @param3 userID of type NSNumber.
*/
-(void)didUpdateFurthestPageData:(NSString *)furthestPageData ForBookID:(NSString *)bookID ForUserID:(NSNumber *)userID;


-(void)didLoadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum forBookID:(KFBookVO *)book andUser:(KitabooUser *)user andPreviousPageNumber:(NSNumber *)previousPageNumber;
@end

// This enumerator is used to provide tags for Highlight View Items.
typedef enum : NSUInteger {
kHighlightItemTypeColor,
kHighlightItemTypeNote,
kHighlightItemTypeDelete,
kHighlightItemTypeSearch,
kHighlightItemTypeShare,
kHighlightItemTypeSpeech
} HighlightItemType;

@class PlayerActionBottomBar;
@class KBMyDataViewController;
@class PlayerActionTopBar;
@class TOCViewController;
@class HelpScreen;
@class TextSearchView;
@class HighlightView;
@class TeacherReviewViewController;
@interface ReaderViewController : UIViewController
{
    PlayerActiveMode activeMode;
    PlayerActiveMode backgroundActiveMode;
    KitabooBookVO *currentBook;
    NSInteger currentChapter;
    NSString *currentChapterName;
    HSDBManager *_dbManager;
    KitabooUser *_user;
    KBHDThemeVO *hdThemeVO;
    HDReflowableLayoutSettingController *reflowableLayoutSettingController;
    HDReflowableLayoutSettingsViewController *reflowableLayoutController;
    __strong TOCViewController *_tocViewController;
    //PlayerActionTopBar *playerTopActionBarView;
    TextSearchView *searchTextViewForIpad;
    HDReflowableSliderPopUpView *_reflowableSliderPopUpView;
    BookMarkView *helpBookmark;
    PlayerActionTopBar *penToolActionBarView;
    NSLayoutConstraint *topConstOfTeacherReview,*bottomConstOfTeacherReview;
    TeacherReviewViewController *_teacherAnnotationController;
}
/**
 This property is used to set the Micro Services Base URL
 */
@property (nonatomic, strong) NSString *microServicesBaseURLString;

@property (strong, nonatomic) HelpScreen *helpScreen;
/**
 Setting/Getter for delegate (callback listener)
 */
@property (nonatomic,weak) id<ReaderViewControllerDelegate> delegate;

/**
 This property is used to set the classID
 */
@property (nonatomic,strong) NSString *classID;

/**
This property is used to set the Reader configurations i.e, the settings which provide configurations to enable/disbale various features in Reader
*/
@property (nonatomic,strong) HDReaderSettingModel *userSettingsModel;

/**
Setting/Getter for playerBottomActionBarView
*/
@property (nonatomic,strong) PlayerActionBottomBar *playerBottomActionBarView;

/**
Setting/Getter for playerBottomActionBarView
*/
@property (nonatomic,strong) KBMyDataViewController *myDataViewController;

/**
This property is used to set the array of components that are necessary to be displayed with HelpScreen
*/
@property (nonatomic,strong) NSMutableArray *helpDescriptorsForHelpScreen;

/**
This property is used to set the text which is searched through elastic search.This text enables the user to search the text inside reader with elastic search mode.
*/
@property (nonatomic,strong) NSString *elasticSearchText;

/**
This property is used to set page id where user need to navigate after launching the book
*/
@property (nonatomic,strong) NSString *jumpToPageId;

/**
Setting/Getter for RendererViewController
*/
@property (nonatomic,strong) RendererViewController *rendererView;

/**
Setting/Getter for HDReflowableLayoutSettingsViewController
*/
@property (nonatomic,strong) HDReflowableLayoutSettingsViewController *reflowableLayoutController;

/**
Setting/Getter for HDReflowableLayoutSettingController
*/
@property (nonatomic,strong) HDReflowableLayoutSettingController *reflowableLayoutSettingController;

/**
This property is used to set the last page content that should be displayed
*/
@property (nonatomic,strong) NSString *lastPageFolio;

/**
This property is used to set the print enable status for reflowable epub.
*/
@property BOOL isReflowPrintEnable;

/**
This property is used to set the average reading time per page
*/
@property (nonatomic,strong) NSNumber *avgTimePerPage;

/**
 To Initialise/Launch book
 * @param1 bookPath Device Physical path of book
 * @param2 bookID  of the current book
 * @param3 user for the current loggedin user
 * @param4 userSettingsModel is the HDReaderSettingModel instance which is used to maintain the configuration of various components inside reader
 */
- (id)initWithBookPath:(NSString*)bookPath WithBookID:(NSNumber*)bookID WithUser:(KitabooUser*)user withBaseURL:(NSString*)baseURL withClientID:(NSString*)clientID withUserSettingsModel:(HDReaderSettingModel *)userSettingsModel;

/**
To Initialise/Launch book
* @param1 bookPath Device Physical path of book
* @param2 bookID  of the current book
* @param3 isbn for the current book to be launched
* @param4 userSettingsModel is the HDReaderSettingModel instance which is used to maintain the configuration of various components inside reader
*/
- (id)initWithBookPath:(NSString *)bookPath WithBookID:(NSNumber *)bookID WithUser:(KitabooUser*)user withISBN:(NSString *)isbn withBaseURL:(NSString*)baseURL withClientID:(NSString*)clientID withUserSettingsModel:(HDReaderSettingModel *)userSettingsModel;

/**
 To draw FIB on Particular page
 * @param1 fibArray to be drawn on page
 * @param2 pageNumber on which fib to be drawn
 */
-(void)drawFIB:(NSArray*)fibArray OnPageNumber:(NSInteger)pageNumber;

/**
 This method should be called to get the current BookOrientationMode of the Reader.
 */
- (BookOrientationMode)getOrientationMode;

/**
 This method sets Reader settings for the reflowable ePub book
 * @param1 epubBook is the EPUBBookVO object for which are being set.
 */
-(void)setEPUBReaderSettings:(EPUBBookVO *)epubBook;

/**
 This method should be called to reset the Reader settings for the reflowable ePub book
 */
-(void)setResetReaderSettingForRenderer;

/**
 This method should be called to reset the views on PlayerActionBar too normal state.
 */
-(void)resetAllPlayerActionBar;
-(void)rendererViewController:(RendererViewController*)rendererViewController didBookLoadedSuccessfullyWithBook:(KitabooBookVO*)bookVO;

/**
 This method should be called to close the Search view i.e TextSearchController
 */
-(void)closeSearchView;

/**
 This property is used to enable/disable teacher/student annotation. For false value teacher/student annotation will not be shown for that user.
 */
@property BOOL hasClassAssociation;

/*
 This method should be called to show/add the Print Page Preview on particular page
 * @param1 pageNo is the page number on which the Print Page Preview should be displayed
 * @param2 displayNum is the folio number on which the Print Page Preview should be displayed
 */
-(void)addPrintPageViewOnPageNumber:(NSString*)pageNo OnDisplayNumber:(NSString*)displayNum;


/**
 This method should be called to get the Resources data.
 */
- (NSMutableArray *)getResourceData;

/**
 This method should be called to get the chapter name/title with EPUBChapter object
 * @param1 chapter is the EPUBChapter object to which we get the chapter name/title
 */
- (NSString *)getChapterNameForChapter:(EPUBChapter *)chapter;

/**
 This method should be called to draw mark up resources on the page for Kitaboo Fixed type books
 * @param1 number is the page number on which the mark up resources needs to be drawn/added
 * @param2 displayNum is the folio number on which the mark up resources needs to be drawn/added
 */
-(void)drawMarkupsOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum;

/**
 This methods should be called to get the font string for individual markup type
 * @param1 link is the KFLinkVO object to which font string is needed.
 */
-(NSString*)getIconForLinkType:(KFLinkVO *)link;

/**
 This method should be called to get the frame of the markup resource that is being drawn/added
 * @param1 link is the KFLinkVO object
 */
-(CGRect)getRectForLinkMarkups:(KFLinkVO*)link;
- (void)compareAndShowInstantFeedbackForDropDownLink:(KFLinkVO *)link andDropDownText:(NSString *)userEnteredText;

/**
 This method should be called to get the array of invisible/hidden multi link markups
 * @param1 finalLinksArray is the total number of markups on the page
 * @param2 number is the page number on which the markups drawn
 */
-(NSMutableArray*)checkInvisibleMultiLinkMarkup:(NSArray*)finalLinksArray withPageNumber:(NSString*)number;

/**
 This method should be called to get the current font name used to update the icons in Reader
 */
-(NSString *)getFontName;

/**
 This method should be called to configure the default Reader settings for the reflowable epub book
 */
-(void)configureFontSettingView;

/**
 This method should be called close/dismiss the Reader when the user session is expired
 */
-(void)closeReaderForSessionExpiry;

/**
 This method should be called to update the UGC on the book
  * @param1 bookID is the book on which the UGC is being updated.
 */
-(void)updateUGCForBook:(NSString *)bookID;

/**
 This method should be called to perform the respective action when user tap on the specific link
 * @param1 sender is the MarkupView object on which the user has tapped.
 */
-(void)didTapOnLink:(MarkupView*)sender;

/**
 This mwethod should be called to perform the respective action when user tap on DropDown markup
 * @param1 iconView is the MarkupView object on which the user has tapped.
 */
-(void)didTapOnSubmittedDropDown:(MarkupView*)iconView;

/**
 This method should be called to get array of links within the specific link
  * @param1 linkVO is the KFLinkVO object
 */
-(NSMutableArray*)getLinksArrayForMultiLink:(KFLinkVO*)linkVO;

/**
This method should be called to get the number of items are being added on the PlayerActionBar for iPhone.
* @param1 themeVO is the KBHDThemeVO object to set the color for PlayerActionBar
* @param2 playerActionBar is the PlayerActionBar object on which the items are being added.
*/
-(int)addItemsOnPlayerActionVerticalBarForIPhone:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar;

/**
 This method should be called to get the number of items are being added on the PlayerActionBar for iPad.
 * @param1 themeVO is the KBHDThemeVO object to set the color for PlayerActionBar
 * @param2 playerActionBar is the PlayerActionBar object on which the items are being added.
 */
-(int)addItemsOnPlayerActionVerticalBarForIPad:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar;

/**
 This method should be called to get the PlayerActionBarItem for thumbnail
  */
-(PlayerActionBarItem *)getPlayerItemForThumbnail;

/**
 This method should be called to add the KBMyDataViewController
 * @param1 button is the view to which the action is received to add the KBMyDataViewController
 */
- (void)showMyData:(UIView *)button;

/**
 This method should be called when user to perform the respestive action user taps on the Singout Button on the profile settings view inside Reader
 */
-(void)signOutAction;

/**
 This method should be called to hide the profile settings view.If this method is not being called then by default the profile settings view will be displayed.
 * @param1 isHidden is a boolean value.If this boolean is set to false, then the profile settings view will be hidden and vice versa.
 */
-(void)hideProfileSettings:(BOOL)isHidden;

/**
 This method should be called to perform the respective action when user tap on any of the item/view on PlayerActionBar
 * @param1 playerActionBar is the PlayerActionBar object on which the item/view is added
 * @param2 item is the PlayerActionBarItem object on which the item/view is being tapped.
 */
-(void)didTapOnPlayerActionBar:(PlayerActionBar*)playerActionBar withItem:(PlayerActionBarItem *)item;

/**
 This method should be called to navigate to specific page within the book
 * @param1 pageNo is the KFLinkVO object
 */
-(void)navigateToPageNumber:(NSString *)pageNo;

/**
This method will be called when the language of Application is changed
*/
-(void)updateReaderForLanguageChange;

/**
This method should be called to uninitialize reader and clear it's objects.
*/
-(void)uninitializeReader;

/**
 To hide Top and bottom view from screen
 */
- (void)moveTopAndBottomOffScreenWithIsAnimate:(BOOL)animated WithCompletionHandler:(void (^)(void))completionHandler;
- (void)moveTopAndBottomOnScreenWithIsAnimate:(BOOL)animated WithCompletionHandler:(void (^)(void))completionHandler;
- (void)webPlayer:(NSURL *)path withLinkVO:(KFLinkVO *)linkVO;
-(void)didTapOnBackButton:(UIButton*)button;
-(void)showAlertWithTitle:(NSString*)title WithMessage:(NSString*)message;
- (NSArray *)getTOCContentData;
- (NSArray*)getBookmarkData;
-(void)showHelpScreen:(BOOL)isForTeacherReview;
-(NSMutableArray *)getAllAppBarButton;
-(NSMutableArray *)getAllAppBarButtonForTeacherReview;
-(void)createSearchTextView:(NSString *)searchText;
-(void)enableDisableVerticalSlider:(BOOL)enable;

/**
 This method will be called to add a new Highlight Tool on Highlight View.
 * @param1 titleStr is the title of the Highlight Tool added on Highlight View.
 * @param2 icon is the icon of the Highlight Tool added on Highlight View.
 * @param3 typeOfItem is the HighlightItemType which shows the tag of the Highlight View item.
 */
-(UIView *)addHighlightTool:(NSString *)titleStr icon:(NSString *)icon ofType:(HighlightItemType)typeOfItem;

/**
 This method will be called when Contextual Note on Highlight View is tapped.
 * @param1 selectedColor is the color of the Contextual Note in which it is created.
 */
-(void)addContextualNoteWithTextColor:(NSString *)selectedColor;

/**
 This method will be called when Search Button on Highlight View is tapped.
 */
-(void)actionForSearchTool;

/**
 This method will be called when Delete Button on Highlight View is tapped.
 * @param1 selectedColor is the color of the highlight which is to be deleted.
 */
-(void)actionForHighlightDelete:(NSString*)selectedColor;

/**
 This method is used to set the Help Button Title and Description on Reader Help Screen.
 * @param1 eachBtn is the Help Button on Reader Help Screen for which Title and Description is needed.
 */
-(NSDictionary*)getHelpTextTitleAndDescriptionForView:(UIView *)eachBtn;

/**
 To set the furthest page data.
 * @param1 furthestPageData Further visited page detail of type NSString.
 */
-(void)setFurthestPageData:(NSString *)furthestPageData;

/*!
 * To enable/Disable furthest page implementation.
 * @param1 isEnable of type BOOL.
 */
-(void)enableFurthestPage:(BOOL)isEnable;

/*!
 * To enable/Disable Share Settings in MyData
 * @param1 disable of type BOOL.
 */
- (void)disableShareSettings:(BOOL)disable;

/*!
 * To enable/Disable Note Notification in MyData
 * @param1 disable of type BOOL.
 */
- (void)disableNoteNotification:(BOOL)disable;

/*!
 * To enable/Disable Two Page Seperation Line for reflowable epub books in landscape orientation
 * @param1 disable of type BOOL.
 */
- (void)disableTwoPageSeperationLine:(BOOL)disable;
/**
Setter/Getter for playerTopActionBarView
*/
@property (nonatomic,strong) PlayerActionTopBar *playerTopActionBarView;

-(void)updateChapterNameForTopBar;

@property(nonatomic, weak) NSLayoutConstraint *topBarTopMarginConstraint;

/**
This property is used to set the list of print supported pages.
*/
-(void)setPrintEnabledPageArray:(NSString*)printEnabledPages;
/**
This property is used to set the app display name.
*/
@property (nonatomic,strong) NSString *appDisplayName;
/**
This property is used to set the book title.
*/
@property (nonatomic,strong) NSString *bookTitle;
/**
This property is used to set book author name.
*/
@property (nonatomic,strong) NSString *authorName;
@property (nonatomic,strong) NSString *bookThumbnailImage;

@property (nonatomic, strong) HighlightView *highlightView;

@property (nonatomic, strong)     NSArray *activePageBeforeStudentReviewMode;

@property (nonatomic, strong)  NSNumber *bookID;


-(UIView *)addHighlightColor:(NSString *)ColorStr;
-(void)deleteHighightItemWithTextColor:(NSString *)selectedColor;
-(void)addPlayerTopBarForIPhone;
-(void)showReadAloudController;
-(void)enablePlayButton:(BOOL)enable;
-(void)rendererViewDidLoadPageWithPageNumber:(NSNumber*)number;
-(void)removeHighlightPopup;
- (void)didChangePageIdentifier:(NSString *)pageOrCFI;
-(CGRect)get220PercentScaleRectForLinkMarkups:(KFLinkVO*)link;

/**
 This property is used to set the value for FIB keyboard type.
*/
@property (nonatomic) BOOL isFIBLevelKeyboardEnabled;

-(void)actionForTeacherReview;
-(void)didSelectLearner:(NSString *)learnerName WithLearnerID:(NSString *)learnerID;
-(void)setSelectedLearnerData:(NSMutableDictionary *)learnerDict withLearnerID:learnerID;
-(void)removeAnnotationController;
- (void)didTapOnGenerateReportButton;
-(UIViewController *) getTeacherAnnocationViewController;
-(void)addTeacherReviewTopBarView;
-(void)updatePlayerSelectedItem:(KBHDThemeVO *)themeColor;
-(NSArray *)getSortedPageArrayOfStudentSubmitedUgc;
-(PlayerActionBarItem*)getPenToolItemWithTag:(PenToolBarItemType)penToolBarItemType;
-(void)initiateMyDataViewController;
@end
