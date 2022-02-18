//
//  ReaderViewController.m
//  KitabooSDK
//
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

#import "ReaderViewController.h"


#import "HDPopOverBackgroundView.h"
//#import "IconFontConstants.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
//For Integrating Framework
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>

#define NoteViewHeightForIpad 550
#define NoteViewWidthForIpad 400
#define RedColor @"#F74742"
#define GreenColor @"#82F675"
#define AudioSyncColor @"#6F73FF"
#define DefaultPenColor "#000000"
#define DefaultPenColorThickness 4.0

#define icon_bookShelf @"a"
#define icon_TOC @"ƈ"
#define icon_myData @"0"
#define icon_penTool @"f"
#define icon_stickyNotes @"¸"
#define icon_TeacherReview @"/"
#define icon_StudentSubmit @":"
#define icon_search @"d"
#define icon_sound @"i"
#define icon_play @"L"
#define icon_thumbnail @"g"
#define icon_editMenu @"9"
#define icon_submit @"ď"
#define icon_eraser @"$"
#define icon_delete @"C"
#define font_name [HDKitabooFontManager getFontName]
//#define item_fontSize isIpad()?32:20
#define item_searchFontSize isIpad()?28:24
#define item_ThumbnailFontSize isIpad()?25:24

#define playerBar_borderColor [UIColor blackColor]
#define playerBar_borderHeight 0.3
#define playerBar_itemWidth 50   //
#define playerBar_verticalLineWidth 8
#define playerBar_itemTextFieldWidth 200
#define playerBottomBar_Height (isIpad()?58:50)
#define playerBottomBar_itemWidthIphone 46
#define playerBar_itemSliderWidth isIpad()?350:250
#define statusBarHight 20
#define PlayerActionBarAnimationTime 0.5
#define PenToolBar_ItemWidth isIPAD ? 62:58.4

#define penToolBar_HeightIPad 45
#define penToolBar_HeightIPhone 50
#define penToolBar_Height (isIpad()?64:54)
#define teacherViewVerticalBar_Height (isIpad()?160:90)

#define penToolBar_itemPointWidth 35
#define penToolBar_itemDoneButtonWidth 60
#define penToolBar_itemUndoWidth 35

#define penToolBar_BorderHeight 0.8
#define penTool_itemFontSize isIpad()?26:24
#define penTool_eraserFontSize isIpad()?22:22
#define penTool_DeleteitemFontSize isIpad()?20:20

//next prevous button for teacher annotation
#define prevAndNextPageButtonHeight isIpad()?48:36
#define prevPageButtonConrnerRadius isIpad()?48/2:36/2
#define prevPageButtonSpace isIpad()?20:10
#define nextPageButtonSpace isIpad()?-20:-10

#define penTool_itemActionWidth isIpad()?penToolBar_HeightIPad -10:penToolBar_HeightIPhone-10

#define itemAction_verticalLineWidth 1
#define item_color [UIColor colorWithHexString:@"#4aaf7c"]
#define slider_tintColor [UIColor colorWithHexString:@"#4aaf0a"]
#define item_bgcolor [UIColor whiteColor]

#define instructionMarkup_BgColor [UIColor colorWithHexString:@"#fdffdb"]
#define instructionMarkup_ShadowColor [[UIColor whiteColor] colorWithAlphaComponent:0.16]

#define activityIndicator_Width isIpad()?300:250
#define activityIndicator_Height isIpad()?130:100

#define MininumSearchStringLenght 3
#define MaximumSearchStringLength 300
#define SeacherMaskColor "#BBA3D0"
#define SeacherHighlightColor "#757575"
#define POPVIEW_MARGIN 3

#define SERVICE_CODE_TOKEN_EXPIRED  103
#define TYPE_KALTURA    1
#define KUGCTypeFIB 5
#define KUGCTypeEquation 7
#define DEFAULT_PROTRACTOR_LINE_THICKNESS 3.0
#define EquationEditorIconFontSize isIpad()?35:18
#define EquationEditorButtonHeightWidth isIpad()?75:45
#define EquationEditorButtonRadius isIpad()?5:2.5

#define itemWidthForVerticalActionBar isIpad()?50:45
#define userTokenKey "expiredToken"

#define readAloudItem_Width isIpad()?65:45
#define readAloudItemDone_Width isIpad()? 100:60
#define readAloudItemSpeed_Width isIpad()? 100 : 76
#define readAloudItem_font isIpad()? 23 : 18
#define readAloudItemClose_font isIpad()? 26 : 18
#define readAloudAudioSpeedActionBarWidth 280
#define audioSpeedBarLeft 15
#define readAloudAudioSpeedItemWidth (readAloudAudioSpeedActionBarWidth - (audioSpeedBarLeft*2))

#define sliderRightAndBottom (isIpad()?(isRTL()?10:15):(isRTL()?6:10))
#define topConstantsForVerticalSliderView (isIPAD?(playerTopBar_Height+20):(playerTopBar_HeightIphone+10))
#define bottomConstantsForVerticalSliderView (isIPAD?((2*playerBottomBar_Height)+30):(2*playerBottomBar_Height+10))
#define topBottomMargin 35

#define DefaultAverageTime 5
#define AnalyticsScheduledTimerInterval 10

#define kFontSize @[ @"Default", @"Small", @"Medium", @"Large", @"XLarge", @"XXLarge" ]
#define kFontAlignment @[ @"Left Align", @"Center Align", @"Right Align", @"Justify Align", @"Default Align" ]
#define kFontLineSpacing @[ @"Default Line Spacing", @"Narrow Line Spacing", @"Normal Line Spacing", @"Wide Line Spacing" ]
#define kFontMargin @[ @"Default Margin", @"Narrow Margin", @"Normal Margin", @"Wide Margin" ]
#define kFontReadingMode @[ @"Day Mode", @"Sepia Mode", @"Night Mode", @"Default Mode" ]
#define LocalizationBundleForReaderViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[ReaderViewController class]]
#define MICRO_SERVICE_BASE_URL @"https://microservices.kitaboo.com/"
#define WatermarkTextColor @"#668A96"
#define AudioSyncColorPalleteItem_Width isIpad()?50:40
#define AudioSyncMenuColorPalletes @[ @"#D17D00", @"#FC5454", @"#C061FF", @"#6F9C21", @"#009CC7" ]
#define AudioSyncHighlightColorPalletes @[ @"#E8BD7F", @"#FDA9A9", @"#DFAFFF", @"#B6CD8F", @"#7FCDE3" ]

@interface ReaderViewController ()<RendererViewControllerDelegate,HighlightActionViewDelegate,TOCControllerDelegate,UIPopoverPresentationControllerDelegate,HSNoteControllerDelegate,BookMarkViewDelegate,BookmarkControllerDelegate,StickyNoteControllerDelegate,KBThumbnailDelegate,PlayerActionDelegate,KBMyDataControllerDelegate,PenToolControllerDelegate,PenToolItemDelegate,PointToolItemDelegate,KBShareSettingsControllerDelegate,KitabooDataSyncingManagerDelegate,TeacherReviewDelegate,UITextFieldDelegate,TextSearchControllerDelegate,AudioSyncControllerDelegate,UIGestureRecognizerDelegate,AudioPlayerDelegate,KitabooWebPlayerDelegate,KitabooDocumentPlayerDelegate,KitabooVideoPlayerDelegate,HDReflowableLayoutControllerDelegate,KitabooYTPlayerDelegate,KitabooImageControllerDelegate,MultiLinkControllerDelegate,TOCViewControllerDelegate,HDBookDownloaderManagerDelegate,LinkDropDownViewControllerDelegate,EquationEditorKeyboardViewControllerDelegate,FIBMathEquationViewDelegate,HelpDelegate,GlossaryViewControllerDelegate,HDReadToMeViewControllerDelegates,PrintPageViewDelegate,PrintPageViewControllerDelegate,HDFIBDelegate,KBFixedEpubThumbnailViewControllerDelegate,GenerateReportViewControllerDelegate,GenerateReportMailViewControllerDelegate,TextSearchViewDelegate, KBMyDataPrintOptionsControllerDelegate>
{
    BookMarkController *_bookMarkController;
    StickyNotesViewController *_noteController;
    KBThumbnailViewController *_thumbnailViewController;
    NSString *_bookPath;
    PenToolController *penToolController;
    //PlayerActionTopBar *penToolActionBarView;
    PlayerActionTopBar *penToolActionBottomBarView;
    UIView *penToolPalleteContainer;
    KBShareSettingsController *_shareSettingsController;
    KitabooPenToolThicknessPalleteViewController *penToolThicknessPalleteViewController;
    KitabooPenToolColorPalleteViewController *penColorPallete;

    //NSLayoutConstraint *_topBarTopMarginConstraint;
    NSLayoutConstraint *_bottomBarBottomMarginConstraint;
//    NSLayoutConstraint *topConstOfTeacherReview,*bottomConstOfTeacherReview;
    BOOL isPlayerActionBarHidden;
    NSLayoutConstraint *widthConstaint,*heightConstaint;
    UIView *sliderPageDetailsView;
    UILabel *sliderPageNumberLabel;
    UILabel *sliderChapterNameLabel;
    NSMutableDictionary *pageDataForSliderDict;
    UISlider *pageSliderForiPhoneBottomBar;
    UILabel *activePagesInfoLabel;
    KitabooDataSyncingManager *_dataSyncManager;
    KitabooAnalyticsAdapter *_analyticsAdapter;
    UIView *_activityIndicatorView;
    UIButton *prevButton,*nextButton;
    TextSearchController *_searchController;
    TextSearchResult *_searchResult;
    NSString *searchTextStr;
    //TextSearchView *searchTextViewForIpad;
    NSLayoutConstraint *bottomConstraintOfTextSearchView;
    NSMutableArray *_navigationHistoryPagesArray;
    BOOL isPageNavigateByScroll;
    int activeHistoryPageCount;
    int currentHistoryPageIndex;
    AudioSyncController *_audioSyncController;
    UIView *_playerView;
    KitabooImageController *_kitabooImageController;
    KitabooAudioPlayer *_audioPlayer;
    KitabooYTPlayer *_youtubePlayer;
    KitabooVideoPlayer *videoPlayer;
    KitabooWebPlayer *webPlayer;
    KitabooWebPlayer *internalWebPlayer;
    NSMutableDictionary *pagesLoadStartTimeDictionary;
    MultiLinkController *_multiLinkController;
    //TeacherReviewViewController *_teacherAnnotationController;
    NSLayoutConstraint *bottomConstraintOfPenTool;
    PlayerActionTopBar *textAnnotationtopBar;
    //For ElasticSearch
    BOOL isSearchResultOpened;
    
    PlayerActionBar *playerActionVerticalBar;
    UIView *viewForVerticalPlayerActionBar;
    UIView *activityViewForTeacherReview;
    BOOL doneButtonSelectedForTeacherReview;
    NSMutableDictionary *_teacherAnnotationData;
    NSMutableDictionary *_studentFolioPagesUGCData;
    NSString *pageIdentifierForTeacherReview;
    NSString *selectLearnerIDForTeacherReview;;
    UIViewController *fibAnswerViewController;
    LinkDropDownViewController *_linkDropDownController;
    InfomationPopOverContentViewController *instructionPopOverContentVC;
    EquationEditorKeyboardViewController *equationEditorKeyboardViewController;
    UIButton *equationEditorButton;
    HDFIB *_hdFIB;
    //BookMarkView *helpBookmark;
    GlossaryViewController *glossaryViewController;
    TextAnnotationActionView *textAnnotationPlayerBottomActionBarView;
    TextAnnotationPalleteActionView *textAnnotationColorActionBarView;
    TextAnnotationAlignmentActionView *textAnnotationAlignmentActionBarView;
    UITextView *textAnnotationView;

    ReadAloudMode readAloudMode;
    HDReadToMeViewController *readToMeViewController;
    PlayerActionBar *playerTopActionBarViewForReadAloud;
    PlayerActionTopBar *playerBottomActionBarViewForAudioSync;
    //PlayerActionBar *audioSpeedActionBarForReadAloud,*audioSpeedBar;
    //UISlider* changeReadAloudAudioSlider;
    NSLayoutConstraint *_readAloudBarTopMarginConstraint;
    UIView *viewForReadAloudActionBar;
    UIAlertController *actionSheet;
    PrintPageViewController *printPageVC;
    
    /*For Reflowable vertical Slider.*/
    HDSliderBarView *viewForSliderBar;
    NSLayoutConstraint *topConstraintForVerticalSliderView;
    NSLayoutConstraint *widthConstraintForVerticalSliderView;
    NSLayoutConstraint *bottomConstraintForVerticalSliderView;
    NSLayoutConstraint *rightConstraintForVerticalSliderView;
    BOOL isVerticalsliderEnable;
    BOOL isSliderEnableForReflowable;
    BOOL sliderCompletedValue;
    CGFloat sliderTottalPages;
    NSMutableDictionary *CFIsLoadStartTimeDictionary;
    ReadingTimeManager *readingTimeManager;
    NSTimer *analyticsScheduledTimer;
    SDKBookClassInfoVO *bookClassInfo;
    NSDate *bookOpenTimeStamp;
    NSString *validLastPageFolio;
    BOOL hideProfileSettingsButton;
    NSString *_baseURL;
    NSString *_clientID;
    NSString *readerSeatingID;
    
    HDReflowablePageCountView *_reflowableSliderPageCountView;
    BOOL enableSliderPopUp;
    BOOL disableReflowablePageCountView;
    NSTimer *scormDataSavetimer;
    
    BOOL isShareSettingsDisabled;
    BOOL isNoteNotificationDisabled;
    BOOL isTwoPageSeperationDisabled;
    KBFixedEpubThumbnailViewController *fixedEpubThumbnailVC;
    GenerateReportViewController *generateReportVC;
    GenerateReportMailViewController *mailVC;
    NSDictionary *generateReportData;
    UIPopoverPresentationController *generateReportPopoverpresentationController ;
    NSArray *printEnabledPageArray;
    HDKitabooAnalyticsHandler *analyticsHandler;
    NSString *audioSyncSelectedColor;
    AudioSyncSpeedRateOption audioSyncSpeedRateOption;
    BOOL fibKeyBoardPresent;
    BOOL isExternalResource;
    BOOL isDragBoxModeEnabled;
    UIInterfaceOrientation deviceOrientation;
    NSNumber *previousPageNumber;
    
}
//@property(nonatomic,strong) HighlightView *highlightView;
//@property (strong, nonatomic) HelpScreen *helpScreen;
@end

@implementation ReaderViewController
@synthesize rendererView = _rendererView;
@synthesize reflowableLayoutController = reflowableLayoutController;
@synthesize reflowableLayoutSettingController = reflowableLayoutSettingController;
/**
 To Initialise/Launch book
 * @param1 bookPath Device Physical path of book
 * @param2 bookID  of the current book
 * @param3 user for the current loggedin user
 */
- (id)initWithBookPath:(NSString*)bookPath WithBookID:(NSNumber*)bookID WithUser:(KitabooUser*)user withBaseURL:(NSString*)baseURL withClientID:(NSString*)clientID withUserSettingsModel:(HDReaderSettingModel *)userSettingsModel
{
    [self initializeLocalizationBundle];
    [UIFont jbs_registerFontWithFilenameString:font_name bundle:[[HDFontManagerHelper getInstance] getFontBundle]];
    [self initializeReaderSeatingID];
    [self setLogsEnabled:NO];
    [self setVerboseEnabled:NO];
    _dbManager = [[HSDBManager alloc] init];
     _userSettingsModel = userSettingsModel;
    _rendererView = [[RendererViewController alloc] initWithBookPath:bookPath WithDelegate:self];
    _user=user;
    _bookID=bookID;
    _bookPath = bookPath;
    _baseURL = baseURL;
    _clientID = clientID;
    [_rendererView setColorForSharedUGC:@"#8fd5e1"];
    [_rendererView setIsHihghlightEnabled:[_userSettingsModel isHighLightEnabled]];
    [_rendererView setVerticalMarginForReflowableEpubBook:[NSNumber numberWithInteger:30]];
    _dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_baseURL clientID:_clientID];
    return self;
}


- (id)initWithBookPath:(NSString*)bookPath WithBookID:(NSNumber*)bookID WithUser:(KitabooUser*)user withISBN:(NSString *)isbn withBaseURL:(NSString*)baseURL withClientID:(NSString*)clientID withUserSettingsModel:(HDReaderSettingModel *)userSettingsModel
{
    [self initializeLocalizationBundle];
    [UIFont jbs_registerFontWithFilenameString:font_name bundle:[[HDFontManagerHelper getInstance] getFontBundle]];
    [self initializeReaderSeatingID];
    [self setLogsEnabled:NO];
    [self setVerboseEnabled:NO];
    _dbManager = [[HSDBManager alloc] init];
    _userSettingsModel = userSettingsModel;
    _rendererView = [[RendererViewController alloc] initWithBookPath:bookPath WithDelegate:self withISBN:isbn];
    _user=user;
    _bookID=bookID;
    _bookPath = bookPath;
    _baseURL = baseURL;
    _clientID = clientID;
    [_rendererView setColorForSharedUGC:@"#8fd5e1"];
    [_rendererView setIsHihghlightEnabled:[_userSettingsModel isHighLightEnabled]];
    [_rendererView setVerticalMarginForReflowableEpubBook:[NSNumber numberWithInteger:30]];
    _dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_baseURL clientID:_clientID];
    return self;
}

- (id)initWithBookPath:(NSString*)bookPath WithBookID:(NSNumber*)bookID WithUser:(KitabooUser*)user withISBN:(NSString *)isbn withBaseURL:(NSString*)baseURL withClientID:(NSString*)clientID withUserSettingsModel:(HDReaderSettingModel *)userSettingsModel withAdditionalInfo:(NSDictionary *)additionalInfo
{
    [self initializeLocalizationBundle];
    [UIFont jbs_registerFontWithFilenameString:font_name bundle:[[HDFontManagerHelper getInstance] getFontBundle]];
    [self initializeReaderSeatingID];
    [self setLogsEnabled:NO];
    [self setVerboseEnabled:NO];
    _dbManager = [[HSDBManager alloc] init];
    _userSettingsModel = userSettingsModel;
    _rendererView = [[RendererViewController alloc] initWithBookPath:bookPath withDelegate:self withISBN:isbn withAdditionalInfo:additionalInfo];
    _user=user;
    _bookID=bookID;
    _bookPath = bookPath;
    _baseURL = baseURL;
    _clientID = clientID;
    [_rendererView setColorForSharedUGC:@"#8fd5e1"];
    [_rendererView setIsHihghlightEnabled:[_userSettingsModel isHighLightEnabled]];
    [_rendererView setVerticalMarginForReflowableEpubBook:[NSNumber numberWithInteger:30]];
    _dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_baseURL clientID:_clientID];
    return self;
}

- (void)setMicroServicesBaseURLString:(NSString *)microServicesBaseURLString
{
    _microServicesBaseURLString = microServicesBaseURLString;
    [_dataSyncManager setMicroServicesBaseURLString:_microServicesBaseURLString];
}
/**
 ViewController LifeCycle Methods
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
    readAloudMode = ReadAloudModeLetMeRead;
    [self initiateReaderAnalyticsSession];
    enableSliderPopUp = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initializeHighlight];
}

-(void)initialSetup{
    [self initializeTheme];
    _rendererView.bookThumbnailImage = _bookThumbnailImage;
    [self performSelector:@selector(addViewControllerAsSubView:) withObject:_rendererView afterDelay:0.5];
    
    //[_dataSyncManager synchUGCForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
//    [_dataSyncManager fetchUGCOperationForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
    [self initializePageHistory];
//    [HDIconFontConstants setFontName:font_name];
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appMovedToBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appMovedToForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self startAnalyticsScheduledTimer];
}

-(void)initializeTheme
{
    //check if theme file is available at user's location
    NSString *themeFilePath = [self getThemeFilePath];
    
    if (!themeFilePath)
    {
        themeFilePath = [[NSBundle bundleForClass:[ReaderViewController class]] pathForResource:@"ReaderTheme" ofType:@"json"];
    }
    hdThemeVO = [ [KBHDThemeVO alloc]init];
    [hdThemeVO updateThemeFromFileAtPath:themeFilePath];
}

-(NSString *)getThemeFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"ReaderTheme" ofType:@"json"];
}

- (void)hideProfileSettings:(BOOL)isHidden
{
    hideProfileSettingsButton = isHidden;
}

/**
 ViewController LifeCycle Methods
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 ViewController LifeCycle Methods
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([_thumbnailViewController isBeingPresented])
        return;
    [self resetAudioPlayer];
    [super viewWillDisappear:animated];
}

- (double)zoomScalePercentageForBook:(KitabooBookVO *)bookVO
{
    return 400;
}
-(void)initiateReaderAnalyticsSession
{
    pagesLoadStartTimeDictionary=[[NSMutableDictionary alloc]init];
    CFIsLoadStartTimeDictionary=[[NSMutableDictionary alloc]init];
//    [_dbManager createReaderAnalyticsSessionForUserID:_user.userID WithBookID:[NSString stringWithFormat:@"%@",_bookID]];
//    NSString *trackingJSON= [_dbManager getReaderAnalyticsForUser:[NSNumber numberWithInt:_user.userID.intValue]  WithBookID:_bookID];
//    NSLog(@"Saved Record--%@",trackingJSON);
//    if(trackingJSON)
//    {
//        [[AnalyticsManager getInstance] setTrackingDataFromJSONString:trackingJSON];
//    }
}
-(void)updateReaderForLanguageChange
{
    if(_reflowableSliderPageCountView)
    {
        if(_reflowableSliderPageCountView.pageLabel.text.length > 0)
        {
            NSArray *subStringsOfPageLabelText = [_reflowableSliderPageCountView.pageLabel.text componentsSeparatedByString:@"|"];
            NSString *pageString = [subStringsOfPageLabelText objectAtIndex:0];
            NSString *bookCountString = [subStringsOfPageLabelText objectAtIndex:1];
            NSString *pageNumber,*totalPageNumber;
            NSString *numbersInPageString = [[pageString componentsSeparatedByCharactersInSet:
             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@" "];
            NSString *removeWhiteSpace = [numbersInPageString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSMutableArray *arrayOfNumbersInPageString = [[removeWhiteSpace componentsSeparatedByString:@" "] mutableCopy];
            if([arrayOfNumbersInPageString containsObject:@""])
            {
                [arrayOfNumbersInPageString removeObject:@""];
            }
            if(arrayOfNumbersInPageString.count == 2)
            {
                pageNumber = arrayOfNumbersInPageString[0];
                totalPageNumber = arrayOfNumbersInPageString[1];
            }
            
            if(isLandScape && !isVerticalsliderEnable)
            {
                if(arrayOfNumbersInPageString.count == 3)
                {
                    pageNumber = arrayOfNumbersInPageString[0];
                    NSString *secondPageNumber = arrayOfNumbersInPageString[1];
                    pageNumber = [pageNumber stringByAppendingFormat:@", %@",secondPageNumber];
                    totalPageNumber = arrayOfNumbersInPageString[2];
                }
            }
            
            if(pageNumber!=nil && totalPageNumber!=nil)
            {
                NSString *pageText = [[[[[LocalizationHelper localizedStringWithKey:@"PAGE"] stringByAppendingFormat:@" %@ ",pageNumber ] stringByAppendingString:[LocalizationHelper localizedStringWithKey:@"OF_KEY"]] stringByAppendingFormat:@" %@", totalPageNumber] stringByAppendingFormat:@" | %@",bookCountString];
                [_reflowableSliderPageCountView setPageData:pageText];
            }
        }
        if(_reflowableSliderPageCountView.readingTimeLeftLabel.text.length > 0)
        {
            NSString *timeLeft = [[_reflowableSliderPageCountView.readingTimeLeftLabel.text componentsSeparatedByCharactersInSet:
                                   [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                  componentsJoinedByString:@""];
            

            [_reflowableSliderPageCountView setTimeLeftData:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@ %@",[NumberLocalizationHandler localizeNumberWithNumber:@([timeLeft intValue])],NSLocalizedStringFromTableInBundle(@"MIN_LEFT",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)],NSLocalizedStringFromTableInBundle(@"MIN_LEFT",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)]];
        }
    }
}

-(void)initializePageHistory
{
    _navigationHistoryPagesArray = [[NSMutableArray alloc]init];
    isPageNavigateByScroll = YES;
    activeHistoryPageCount = 0;
    currentHistoryPageIndex =0;
}


/**
 Will be called to the add the PenToolTopBarView
 */
-(void)addPentoolTopBarAnimate:(BOOL)animate
{
    if(penToolActionBarView)
    {
        [penToolActionBarView removeFromSuperview];
        [penToolPalleteContainer removeFromSuperview];
        penToolPalleteContainer=nil;
        penToolActionBarView =nil;
    }
    [penToolActionBarView resetPlayerActionBarSelection];
    [self addPenToolTopBarViewWithAnimation:animate];
//    penToolActionBarView.hidden=YES;
}

-(void)addPlayerActionBarForTopAndBottom
{
        [self addPlayerTopBarForIPhone];
        [self addPlayerBottomBarForIPhone];
        [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
}

- (void) orientationChanged:(NSNotification *)note
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsPortrait(deviceOrientation)) || (UIInterfaceOrientationIsLandscape(deviceOrientation) && UIInterfaceOrientationIsPortrait(interfaceOrientation)) || deviceOrientation == UIInterfaceOrientationUnknown) {
        deviceOrientation = interfaceOrientation;
        if (penToolActionBottomBarView && activeMode == kPlayerActiveModeTeacherReview) {
            PlayerActionBarItem *item = [penToolActionBottomBarView getSelectedItem];
            int itemType = -1;
            if (item) {
                itemType = (int)item.tag;
            }
            [penToolActionBottomBarView removeFromSuperview];
            penToolActionBottomBarView = nil;
            [self singleTapOnPentoolPalleteContainer:nil];
            [self addTeacherReviewBottomBarView];
            if (itemType > 0) {
                [self getPenToolItemWithTag:itemType].selected = true;
                [self getPenToolItemWithTag:itemType].backgroundColor = hdThemeVO.top_toolbar_icons_color;
                for (UILabel *subView in [[self getPenToolItemWithTag:itemType] subviews])
                {
                    if([subView isKindOfClass:[UILabel class]])
                    {
                        subView.textColor = UIColor.whiteColor;
                    }
                }
            }
        }
        if(activeMode == kPlayerActiveModeMarkupPlayerAudio || _playerView)
        {
            _playerView.center = self.view.center;
        }
    }
    if (penToolActionBarView && activeMode == kPlayerActiveModeTeacherReview) {
        [penToolActionBarView removeFromSuperview];
        penToolActionBarView = nil;
        [self addTeacherReviewTopBarView];
    }
    if (_user)
    {
        BOOL isTopBottmOnScreen = (_topBarTopMarginConstraint.constant == -(playerTopBar_Height+statusBarHight))?NO:YES;
        if([self.playerTopActionBarView superview] != nil && [_playerBottomActionBarView superview] != nil)
        {
            [self removePlayerBottomBar];
            [self addPlayerTopBarForIPhone];
            [self addPlayerBottomBarForIPhone];
            if (viewForVerticalPlayerActionBar)
            {
                [self removeVerticalBarViewForTeacherReview];
                [self addPlayerVerticalBarForTeacherView];
            }
            [self changeAudioButtonStatus];
        }
        
        if(isTopBottmOnScreen)
        {
            [self moveTopAndBottomOnScreenWithIsAnimate:NO WithCompletionHandler:nil];
        }else
        {
            [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
        }
        
        if(!isIpad()){
            if(kPlayerActiveModePentool==activeMode){
                //ZU5-119
                [self addPentoolTopBarAnimate:NO];
                [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
            }
            [self removeProfilePopOver];
        }
        if(self.helpScreen)
        {
            if(self.helpScreen.isOnSecondScreenOnHelpScreen && !self.helpScreen.isForTeacherReview)
            {
                [UIView animateWithDuration:PlayerActionBarAnimationTime
                                 animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished){
                    [self.playerTopActionBarView setHidden:YES];
                }];
            }
            [self.view bringSubviewToFront:self.helpScreen.view];
            if(self.helpScreen.isForTeacherReview)
            {
                self.helpScreen.helpDescriptors = [self getAllAppBarButtonForTeacherReview];
            }
            else
            {
                self.helpScreen.helpDescriptors = [self getAllAppBarButton];
            }
        }
        if(kPlayerActiveModeInstruction==activeMode){
            if (instructionPopOverContentVC != NULL){
                [self removeInstructionMarkupPopOver];
            }
        }
    }
}

/**
 Will be called to add viewController as childView
 */
- (void)addViewControllerAsSubView:(UIViewController *)controller
{
    [self.view insertSubview:controller.view atIndex:0];
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [controller.view.safeAreaLayoutGuide.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = YES;
        [controller.view.safeAreaLayoutGuide.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = YES;
        [controller.view.safeAreaLayoutGuide.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
        [controller.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
    } else {
        // Fallback on earlier versions
        [controller.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [controller.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
        [controller.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
        [controller.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    }
    [controller.view layoutIfNeeded];
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.view layoutIfNeeded];
}

/**
 Removes the RendererViewController
 */
-(void)removeRendererViewController
{
    [_rendererView.view removeFromSuperview];
    [_rendererView removeFromParentViewController];
    _rendererView=nil;
}

/**
 Will be called when tap back button on reader topbar
 */
-(void)didTapOnBackButton:(UIButton*)button
{
    if (_audioPlayer)
        [self resetAudioPlayer];
    
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.homeButtonEventName eventInfo:nil];
    /* Enable Pagination with Boolean YES */
//      [_rendererView enablePagination:NO];
    [self saveReaderAnalytics];
    [self getUnSyncedUgc];
    CATransition *transition = [CATransition animation];
    transition.duration = 0;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionMoveIn;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [_delegate didClosedReader:self ForBookID:_bookID withLastPageFolio:_lastPageFolio withAvgTimePerPage:_avgTimePerPage withIsReaderForceClosed:NO];
}

-(void)signOutAction
{
    [self saveReaderAnalytics];
    [_delegate didClosedReader:self ForBookID:_bookID withLastPageFolio:_lastPageFolio withAvgTimePerPage:_avgTimePerPage withIsReaderForceClosed:NO];
}

-(void)clearObjects
{
    [self stopAnalyticsScheduledTimer];
    [self removeRendererViewController];
    [self stopAudioSyncIfAny];
    [self removePlayerBottomBar];
    _highlightView=nil;
    _tocViewController = nil;
    _bookMarkController=nil;
    _noteController=nil;
    _thumbnailViewController=nil;
    fixedEpubThumbnailVC = nil;
    _dbManager=nil;
    currentBook=nil;
    penToolController=nil;
    self.playerTopActionBarView=nil;
    _playerBottomActionBarView=nil;
    penToolActionBarView=nil;
    _myDataViewController=nil;
    _topBarTopMarginConstraint=nil;
    _bottomBarBottomMarginConstraint=nil;
    _audioSyncController=nil;
    viewForSliderBar = nil;
    _readAloudBarTopMarginConstraint = nil;
    analyticsHandler = nil;
}

-(void)getUnSyncedUgc
{
    BOOL isUgcCreated = NO;
    NSDictionary *ugcDict = [_dbManager getUnsynedUGCDictionaryForUserID:[_user.userID numberValue]];
    
    NSDictionary *collabUgcDict = [_dbManager getUnsyncedCollabDataDictionaryForUserID:[_user.userID numberValue]];
    if([[ugcDict valueForKey:@"ugcBookList"] count]>0 || collabUgcDict.count>0)
    {
        isUgcCreated = YES;
    }
     if ([_delegate respondsToSelector:@selector(checkUgcSyncInProgress:)])
     {
         [_delegate checkUgcSyncInProgress:isUgcCreated];
     }
}
/**
 Will be called to save the Reader Analytics to database
 */
-(void)saveReaderAnalytics
{
    NSArray *activePages=[_rendererView getActivePages];
    [self trackBookOpenEvent];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if ([activePages count] > 0) {
            KFPageVO *lastPage  = [activePages objectAtIndex:0];
            NSString *lastPageFolio=lastPage.displayNum;
            _lastPageFolio = lastPageFolio;
            [self trackBookCloseEvent:lastPageFolio];
        }
    }
    else
    {
        
        EPUBPage *lastPage  = [activePages objectAtIndex:0];
        NSString *lastPageFolio;
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        if(book.meta.layout==ePUBReflowable)
        {
            NSString *CFIString = [_rendererView getCurrentCFI];
            NSString *rangeString = [_rendererView getLastVisitedRangeInfo];
            NSString *bookDataCFI = [_rendererView getCurrentBookDataCFI];
            NSString *fileIndex = [NSString stringWithFormat:@"%ld",(long)lastPage.fileIndex];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: fileIndex, @"chapterid", rangeString, @"page",CFIString, @"positionIdentifier",bookDataCFI, @"pageCFI", nil];
            if (@available(iOS 13.0, *)) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingWithoutEscapingSlashes error:nil];
                lastPageFolio = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } else {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                lastPageFolio = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                lastPageFolio = [lastPageFolio stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
            }
        }
        else
        {
            lastPageFolio = [NSString stringWithFormat:@"%ld",(long)lastPage.fileIndex];
        }
        _lastPageFolio = lastPageFolio;
        [self trackBookCloseEvent:lastPageFolio];
    }
    [self createAndSaveReaderAnalyticsSessionWithCalledUsingTimer:false];
     if (readingTimeManager) {
         NSInteger avgTime = [self getAvgTimePerPageFromAnalyticsEvents];
         _avgTimePerPage = [NSNumber numberWithInteger:(avgTime+[_avgTimePerPage integerValue])/2];
     }
}
- (void)trackBookOpenEvent {
    HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithBookOpen:[NSString stringWithFormat:@"%@",_bookID] openTimeStamp:[NSString hsStringFromUTCDate:bookOpenTimeStamp] classId:[NSString stringWithFormat:@"%@",bookClassInfo.classId] suspendData:nil uniqueId:[NSString stringWithFormat:@"%@",_bookID]];
    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeBookOpen metadata:metadata];
}

- (void)trackBookCloseEvent:(NSString*)lastPageFolioStr {
    HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithBookClose:[NSString hsStringFromUTCDate:[NSDate date]] lastPageFolio:lastPageFolioStr uniqueId:[NSString stringWithFormat:@"%@",_bookID]];
    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeBookClose metadata:metadata];
}

-(void)createAndSaveReaderAnalyticsSessionWithCalledUsingTimer:(BOOL)isUsingTimer
{
    NSArray *activePages=[_rendererView getActivePages];
    //CPI-1710
    //Check if active pages are not empty
    if ([activePages count] == 0) {
        return;
    }
    if (isUsingTimer) {
        NSString *lastPageFolio;
        if ([currentBook isKindOfClass:[KFBookVO class]]) {
            KFPageVO *lastPage  = [activePages objectAtIndex:0];
            lastPageFolio = lastPage.displayNum;
        }
        else
        {
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            EPUBPage *lastPage  = [activePages objectAtIndex:0];
            if (book.meta.layout==ePUBReflowable) {
                NSString *CFIString = [_rendererView getCurrentCFI];
                NSString *rangeString = [_rendererView getLastVisitedRangeInfo];
                NSString *bookDataCFI = [_rendererView getCurrentBookDataCFI];
                NSString *fileIndex = [NSString stringWithFormat:@"%ld",(long)lastPage.fileIndex];
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: fileIndex, @"chapterid", rangeString, @"page",CFIString, @"positionIdentifier",bookDataCFI, @"pageCFI", nil];
                if (@available(iOS 13.0, *)) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingWithoutEscapingSlashes error:nil];
                    lastPageFolio = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                } else {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                    lastPageFolio = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    lastPageFolio = [lastPageFolio stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                }
                if (!(fileIndex && rangeString && CFIString) && validLastPageFolio) {
                    lastPageFolio = validLastPageFolio;
                }
                else
                {
                    validLastPageFolio = lastPageFolio;
                }
            }
            else
            {
                lastPageFolio = [NSString stringWithFormat:@"%ld",(long)lastPage.fileIndex];
                
            }
        }
        if ([_delegate respondsToSelector:@selector(didLastVisitedFolioNumberForBookID: withLastPageFolio:)])
        {
            [_delegate didLastVisitedFolioNumberForBookID:_bookID withLastPageFolio:lastPageFolio];
        }
        [self trackBookCloseEvent:lastPageFolio];
        [self trackBookOpenEvent];
    }
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        for (KFPageVO *page in activePages)
        {
            KFBookVO *book=(KFBookVO*)currentBook;
            KFChapterVO *chapter=[book getChapterForPageID:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
            NSDate *startPageTime = [pagesLoadStartTimeDictionary objectForKey:page.displayNum];
            NSDate *endPageTime = [NSDate date];
            NSTimeInterval secondsBetween = [endPageTime timeIntervalSinceDate:startPageTime];
            if (activePages.count>1) {
                secondsBetween = secondsBetween/2;
            }
            HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:nil pageId:page.displayNum timeSpent:[NSString stringWithFormat:@"%f",secondsBetween] chapterId:[NSString stringWithFormat:@"%ld",(long)chapter.chapterID] chapterName:chapter.title uniqueId:[[NSUUID UUID] UUIDString]];
            [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
            [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:page.displayNum];
        }
    }
    else
    {
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        if(book.meta.layout==ePUBReflowable)
        {
            EPUBPage *page1 = [activePages objectAtIndex:0];
            for (NSString* cfi in [CFIsLoadStartTimeDictionary allKeys]) {
                NSDate *startPageTime = [CFIsLoadStartTimeDictionary valueForKey:cfi];
                NSDate *endPageTime = [NSDate date];
                NSTimeInterval secondsBetween = [endPageTime timeIntervalSinceDate:startPageTime];
                if (CFIsLoadStartTimeDictionary.count>1) {
                    secondsBetween = secondsBetween/CFIsLoadStartTimeDictionary.count;
                }
                HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:cfi pageId:[NSString stringWithFormat:@"%ld",(long)page1.fileIndex] timeSpent:[NSString stringWithFormat:@"%f",secondsBetween] chapterId:[NSString stringWithFormat:@"%ld",(long)page1.fileIndex] chapterName:[NSString stringWithFormat:@"%@",page1.idref] uniqueId:[[NSUUID UUID] UUIDString]];
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
                [CFIsLoadStartTimeDictionary setObject:[NSDate date] forKey:cfi];
            }
        }

        for (EPUBPage *page in activePages)
        {
            if (pagesLoadStartTimeDictionary.count) {
                NSDate *startPageTime = [pagesLoadStartTimeDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
                NSDate *endPageTime = [NSDate date];
                NSTimeInterval secondsBetween = [endPageTime timeIntervalSinceDate:startPageTime];
                if (activePages.count>1) {
                    secondsBetween = secondsBetween/2;
                }
                HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:nil pageId:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] timeSpent:[NSString stringWithFormat:@"%d",(int)secondsBetween] chapterId:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] chapterName:[NSString stringWithFormat:@"%@",page.idref] uniqueId:[[NSUUID UUID] UUIDString]];
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
                [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
            }
        }
    }
    NSString *eventTrackingJSON = [analyticsHandler getTrackingJSON];
    if(eventTrackingJSON)
    {
        [_dbManager createReaderAnalyticsSessionForUserID:_user.userID WithBookID:[NSString stringWithFormat:@"%@",_bookID] withAnalyticsData:eventTrackingJSON];

//        [_dbManager updateReaderAnalyticsSessionForUser:[NSNumber numberWithInt:_user.userID.intValue] WithBookID:_bookID WithAnalyticsData:eventTrackingJSON];
    }
 
}


-(void)actionForTeacherReviewPageChanged
{

    if(!penToolController)
    {
        penToolController = [[PenToolController alloc]init];
        [penToolController setDelegate:self];
        [penToolController setPenDrawingCanvas:[_rendererView getPenDrawingCanvas]];
        [penToolController setDrawingMode:DRAWING_MODE_NORMAL];
        [penToolController setPenMode:PenModeMarkupTap];
        [penToolController setPenColor:GreenColor];
        [penToolController setPenStrokeThickness:[self getLastUpdatedPenThickness]];
        [penToolController setDeleteOnSelectionEnabled:YES];
    }
    else
    {
        if (isDragBoxModeEnabled) {
            [_rendererView setTeacherReviewDragBoxModeEnabled:true];
        } else {
            if([penToolController getPenMode] == PenModeMarkupTap)
            {
                [_rendererView setPenDrawingModeEnabled:NO withReviewModeEnable:YES];
            } else if ([penToolController getPenMode] == PenModeDrawing) {
                [_rendererView setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
                [penToolController setPenMode:PenModeDrawing];
            } else if ([penToolController getPenMode] == PenModeSelection) {
                [_rendererView setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
                [penToolController setPenMode:PenModeSelection];
            }
        }
        [penToolController setPenDrawingCanvas:[_rendererView getPenDrawingCanvas]];
        [penToolController setPenMode:penToolController.getPenMode];
        [penToolController setPenColor:penToolController.getPenColor];
        [penToolController setPenStrokeThickness:penToolController.getPenStrokeThickness];
        [penToolController setDeleteOnSelectionEnabled:YES];
    }
    [self addTeacherAnnotationTopBar];
    [self updatePentoolButtonStatus];
    [self showHelpScreenForTeacherReview];
}

#pragma TeacherReviewDelegate Implementation
/**
 TeacherReviewDelegate Implementation
 */
-(void)didSelectPenTypeForTeacherReview
{
    if([penToolController getPenMode] != PenModeDrawing)
    {
        [penToolController setPenMode:PenModeDrawing];
        [_rendererView setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
    }
    else
    {
        [penToolController setPenMode:PenModeMarkupTap];
        [_rendererView setPenDrawingModeEnabled:NO withReviewModeEnable:YES];
    }
}

/**
 TeacherReviewDelegate Implementation
 */
-(void)didSelectPenColorForTeacherReview:(NSString *)color
{
    //////// uncomment this if FIB is enable and comment above////////
    
        if ([penToolController getPenColor] == color)
        {
            if ([penToolController getPenMode] == PenModeDrawing)
            {
                [_rendererView setPenDrawingModeEnabled:NO withReviewModeEnable:YES];
                [penToolController setPenMode:PenModeMarkupTap];
                [penToolController setPenColor:GreenColor];
            }else
            {
                [_rendererView setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
                [penToolController setPenMode:PenModeDrawing];
                [penToolController setPenColor:color];
            }
        }else
        {
            [_rendererView setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
            [penToolController setPenMode:PenModeDrawing];
            [penToolController setPenColor:color];
        }
        [self singleTapOnPentoolPalleteContainer:nil];
        [self actionForTeacherReviewPageChanged];
    
}

/**
 TeacherReviewDelegate Implementation
 */
-(void)didSelectEraserForTeacherReview
{
//        if([penToolController getPenMode] != PenModeSelection)
//        {
//            [penToolController setPenMode:PenModeSelection];
//        }
    
   //////// uncomment this if FIB is enable and comment above////////
    [penToolController setPenColor:GreenColor];
    if ([penToolController getPenMode] == PenModeMarkupTap)
    {
        [_rendererView setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
        [penToolController setPenMode:PenModeDrawing];
        [penToolController setPenMode:PenModeSelection];
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].backgroundColor = hdThemeVO.top_toolbar_icons_color;
        for (UILabel *subView in [[self getPenToolItemWithTag:kPenToolBarItemTypeEraser] subviews])
        {
            if([subView isKindOfClass:[UILabel class]])
            {
                subView.textColor = UIColor.whiteColor;
            }
        }
    }else if ([penToolController getPenMode] == PenModeSelection)
    {
        [penToolController setPenMode:PenModeMarkupTap];
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].selected = false;
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].backgroundColor = UIColor.clearColor;
        for (UILabel *subView in [[self getPenToolItemWithTag:kPenToolBarItemTypeEraser] subviews])
        {
            if([subView isKindOfClass:[UILabel class]])
            {
                subView.textColor = hdThemeVO.top_toolbar_icons_color;
            }
        }
    }else if ([penToolController getPenMode] == PenModeDrawing)
    {
        [_rendererView setPenDrawingModeEnabled:NO withReviewModeEnable:YES];
        [penToolController setPenMode:PenModeSelection];
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].backgroundColor = hdThemeVO.top_toolbar_icons_color;
        for (UILabel *subView in [[self getPenToolItemWithTag:kPenToolBarItemTypeEraser] subviews])
        {
            if([subView isKindOfClass:[UILabel class]])
            {
                subView.textColor = UIColor.whiteColor;
            }
        }
    }
    [self actionForTeacherReviewPageChanged];
}

-(void)updateNextPrevStudentButtonStatus {
    if ([_teacherAnnotationController isAvailableNextStudent]) {
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeNextStudent].alpha=1.0;
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeNextStudent].userInteractionEnabled = YES;
    } else {
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeNextStudent].alpha=0.5;
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeNextStudent].userInteractionEnabled = NO;
    }
    if ([_teacherAnnotationController isAvailablePreviousStudent]){
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypePrevStudent].alpha=1.0;
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypePrevStudent].userInteractionEnabled = YES;
    } else {
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypePrevStudent].alpha=0.5;
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypePrevStudent].userInteractionEnabled = NO;
    }
}

-(PlayerActionBarItem*)getActionBarItemItemWithTag:(PlayerActionBarItemType)penToolBarItemType
{
    for (PlayerActionBarItem *playerActionBarItem in [penToolActionBarView getTappableItems]) {
        if(playerActionBarItem.tag==penToolBarItemType)
        {
            return playerActionBarItem;
        }
    }
    return nil;
}

-(void)didSelectDragBoxForTeacherReview
{
    if ([penToolController getPenMode] != PenModeMarkupTap)
    {
        [penToolController setPenColor:GreenColor];
        [penToolController setPenMode:PenModeMarkupTap];
        [_rendererView setPenDrawingModeEnabled:NO withReviewModeEnable:YES];
    }
    if (isDragBoxModeEnabled) {
        isDragBoxModeEnabled = false;
        [penToolActionBottomBarView resetPlayerActionBarSelection];
        [_rendererView setTeacherReviewDragBoxModeEnabled:false];
    } else {
        isDragBoxModeEnabled = true;
        [self getPenToolItemWithTag:kPlayerActionBarItemTypeDragBox].selected = true;
        [self getPenToolItemWithTag:kPlayerActionBarItemTypeDragBox].backgroundColor = hdThemeVO.top_toolbar_icons_color;
        for (UILabel *subView in [[self getPenToolItemWithTag:kPlayerActionBarItemTypeDragBox] subviews])
        {
            if([subView isKindOfClass:[UILabel class]])
            {
                subView.textColor = UIColor.whiteColor;
            }
        }
        [_rendererView setTeacherReviewDragBoxModeEnabled:true];
    }
}

/**
 TeacherReviewDelegate Implementation
 */
-(void)didSelectDeleteForTeacherReview
{
    ResetAllViewController *resetViewController = [[ResetAllViewController alloc] init];
    [resetViewController setOkButtonAction:^(BOOL isCurrentPage) {
        if (isCurrentPage) {
            [self clearAllFIBs];
            [self clearAllPenDrawings];
        } else {
            [self clearAllPageFIBs];
            [self clearAllPagePenDrawings];
        }
        
        [penToolActionBarView resetPlayerActionBarSelection];
        [penToolActionBottomBarView resetPlayerActionBarSelection];

        PenMode currentPenMode = [penToolController getPenMode];
        [penToolController deleteActivePagePenDrawings];
        [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
        [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].selected = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].alpha = 0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].userInteractionEnabled = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].selected = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].alpha = 0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].userInteractionEnabled = NO;
        if (currentPenMode == PenModeSelection)
        {
            [penToolController setPenMode:PenModeDrawing];
            [penToolActionBarView updateSelectedPenColor:penToolController.getPenColor withTheme:hdThemeVO];
            [penToolActionBottomBarView updateSelectedPenColor:penToolController.getPenColor withTheme:hdThemeVO];
        }else
        {
            [penToolController setPenMode:currentPenMode];
        }
        [self actionForTeacherReviewPageChanged];
    }];
    [resetViewController setCancelButtonAction:^{
        [penToolActionBarView resetPlayerActionBarSelection];
        [penToolActionBottomBarView resetPlayerActionBarSelection];
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].selected = NO;
        [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
        [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
    }];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:resetViewController];
    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIPopoverPresentationController *popPC = navController.popoverPresentationController;
    popPC.permittedArrowDirections = 0;
    navController.popoverPresentationController.sourceView = self.view;
    [navController setNavigationBarHidden:YES];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

/**
 TeacherReviewDelegate Implementation
 */
-(void)didStudentPopUpOpen:(BOOL)isStudentPopUpOpen
{
    if(isStudentPopUpOpen)
    {
        [_rendererView.view setUserInteractionEnabled:NO];
    }
   else
   {
       [_rendererView.view setUserInteractionEnabled:YES];
   }
}


/**
 Call this method to Initialise the Pentool
 */
-(void)actionForPentool
{
    if(activeMode != kPlayerActiveModePentool)
    {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.pentoolEventName eventInfo:nil];
        penToolActionBarView.hidden=NO;
        activeMode=kPlayerActiveModePentool;
        [_rendererView setPenDrawingModeEnabled:YES];
        penToolController=nil;
        penToolController = [[PenToolController alloc]init];
        [penToolController setDelegate:self];
        penToolController.hasClassAssociation = _hasClassAssociation;
        [penToolController setPenDrawingCanvas:[_rendererView getPenDrawingCanvas]];
        [penToolController setDrawingMode:DRAWING_MODE_NORMAL];
        [penToolController setPenMode:PenModeDrawing];
        [penToolController setPenColor:[self getLastUpdatedPenColor]];
        [penToolController setPenStrokeThickness:[self getLastUpdatedPenThickness]];
        [penToolController setDeleteOnSelectionEnabled:YES];
        [self updatePentoolButtonStatus];
        [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:^{
            [self addPentoolTopBarAnimate:YES];

        }];
    }
    else
    {
        [penToolController setPenMode:PenModeDrawing];
        [_rendererView setPenDrawingModeEnabled:NO];
        penToolController=nil;
        if (backgroundActiveMode != kPlayerActiveModeNone) {
            activeMode = backgroundActiveMode;
        } else {
            activeMode = kPlayerActiveModeNone;
        }
        [self resetAllPlayerActionBar];
        [UIView animateWithDuration:0.4 animations:^{
            bottomConstraintOfPenTool.constant = penToolBar_Height;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self moveTopAndBottomOnScreenWithIsAnimate:YES WithCompletionHandler:^{
                penToolActionBarView.hidden=YES;
                [penToolActionBarView removeFromSuperview];
                penToolActionBarView =nil;
                //activeMode=kPlayerActiveModeNone;
            }];
        }];
        [self relaodPageUGCForActivePages];
    }
}

/**
 Call this method to Set the Pentool Erase mode
 */
-(void)actionForPentoolErase
{
    if([penToolController getPenMode] != PenModeSelection)
    {
        [penToolController setPenMode:PenModeSelection];
    }
    else
    {
        [self disableEraseMode];
        [penToolController setPenMode:PenModeDrawing];
    }
}


/**
 Call this method to disable the Pentool Erase mode
 */
-(void)disableEraseMode
{
    [penToolActionBarView resetPlayerActionBarSelection];
 
}


/**
 Call this method to Set the Pentool Delete mode
 */
-(void)actionForPentoolDeleteSelection
{
    
    [[AlertView sharedManager] presentAlertWithTitle:NSLocalizedStringFromTableInBundle(@"ALERT_BUTTON",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) message:NSLocalizedStringFromTableInBundle(@"DO_YOU_WISH_TO_DELETE_ALL_DOODLES",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) andButtonsWithTitle:@[[NSLocalizedStringFromTableInBundle(@"NO_ALERT_BUTTON",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) uppercaseString],[NSLocalizedStringFromTableInBundle(@"YES_ALERT_BUTTON",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) uppercaseString]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        [penToolActionBarView resetPlayerActionBarSelection];
        if([buttonTitle isEqualToString:[NSLocalizedStringFromTableInBundle(@"YES_ALERT_BUTTON",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) uppercaseString]]){
            [penToolController deleteActivePagePenDrawings];
            [self updatePentoolButtonStatus];
        }
    }];
}

-(void)actionForPentoolDrawingMode
{
    [penToolController setPenMode:PenModeDrawing];
    [self actionForPenColorPalletePicker];
}

/**
 Call this method to undo the pentool drawing
 */
-(void)actionForPentoolUndoDrawing
{
    if([penToolController getPenMode] == PenModeSelection){
        [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].selected = YES;
        [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
    }
    
    [penToolController undoDrawing];
}

-(void)updatePentoolButtonStatus{
    if(activeMode == kPlayerActiveModeTeacherReview){
        
        if([_teacherAnnotationController isFIBsAndPentoolAvailable]){
            [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].alpha = 1;
            [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].userInteractionEnabled = YES;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].alpha = 1;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].userInteractionEnabled = YES;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].enabled = true;
        }
        else{
            [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].alpha = 0.5;
            [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].selected = NO;
            [self getPenToolItemWithTag:kPenToolBarItemTypeEraser].userInteractionEnabled = NO;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].alpha = 0.5;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].selected = NO;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].userInteractionEnabled = NO;
        }
        if([penToolController getPenMode] == PenModeSelection)
        {
            PlayerActionBarItem *eraserItemView = [self getPenToolItemWithTag:kPenToolBarItemTypeEraser];
            NSPredicate *predicateToFindClass = [NSPredicate predicateWithFormat:
                                                 @"self isMemberOfClass: %@", [UILabel class]];
            NSArray *araayOfBurrEffectView = [[eraserItemView subviews] filteredArrayUsingPredicate:predicateToFindClass];

            if(araayOfBurrEffectView.count)
            {
                for (UILabel *label in araayOfBurrEffectView)
                {
                    eraserItemView.backgroundColor = hdThemeVO.pen_tool_selected_icon_background;
                    label.textColor = hdThemeVO.pen_tool_selected_icon_color;
                    break;
                }
            }
        }
    }
    else {
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray *activePages = [_rendererView getActivePages];
        BOOL isAnyDrwawingavailable = NO;
        if([currentBook isKindOfClass:[KFBookVO class]])
        {
            for (KFPageVO *page in activePages)
            {
                NSArray* penDrawings=[_dbManager pentoolDrawingForPageID:[NSString stringWithFormat:@"%ld",(long)page.pageID]  ForDisplayNumber:page.displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
                
                if(penDrawings.count)
                {
                    isAnyDrwawingavailable = YES;
                    break;
                }
            }
        }
        if(!isAnyDrwawingavailable){
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].alpha=0.5;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].userInteractionEnabled = NO;
        }
        else{
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].alpha=1;
            [self getPenToolItemWithTag:kPenToolBarItemTypeDelete].userInteractionEnabled = YES;
          
        }
    }
    }
}

/**
 Call this method to Show TOC when tapped on TOC button on Reader Top bar
 */
- (void)didTapOnTOCButton:(UIView *)button
{
    [self showTOC:button];
}


/**
 Call this method to Show MyData when tapped on TOC button on Reader Top bar
 */
- (void)didTapOnMyDataButton:(UIButton *)button
{
    [self showMyData:button];
}

#pragma mark Highlight Action UI
/**
 Call this Method to Initalise the HighlightActionView and to add Highlight Items
 */
- (void)initializeHighlight{
    
    _highlightView = [[HighlightView alloc] initWithFrame:CGRectMake(5, 0,isIpad()?(HighlightItemWidthForIpad) * 8 : (HighlightItemWidthForIphone) * 8,isIpad()?HighlightItemHeightForIpad:HighlightItemHeightForIphone) selectedColor:@"" selectedBorderColor:hdThemeVO.note_selected_icon_border];
    _highlightView.contentView.backgroundColor = hdThemeVO.highlight_popup_background;

    for (UIView *view in _highlightView.subviews) {
        if([view isKindOfClass:[UITapGestureRecognizer class]])
            [view removeFromSuperview];
    }
    _highlightView.backgroundColor = [UIColor clearColor];
    [self addHighlightColorsOnHighlightView];
    [self addHighlightToolsOnHighlightView];
    __weak typeof(self) weakSelf = self;
    [_highlightView setHighlightTextAction:^(HighLightToolView *highLightView,NSString * _Nonnull colorString) {
        [weakSelf.rendererView highlight:weakSelf.highlightView WithTextColor:colorString WithBackgroundColor:colorString WithIsImportant:NO];
    }];
    
    [_rendererView setHighlightView:_highlightView];
}

-(void)addHighlightColorsOnHighlightView
{
    for (NSString *colorStr in hdThemeVO.highlight_Color_Array)
    {
        [_highlightView addColorViewWithHightlighColorView:[self addHighlightColor:colorStr] color:colorStr];
    }
}

-(void)addHighlightToolsOnHighlightView
{
    if (_userSettingsModel.isContextualNoteEnabled) {
         [_highlightView addHighLightToolbuttonWithHighLightTool:[self addHighlightTool:@"Note" icon:NOTE_TEXT_ICON ofType:kHighlightItemTypeNote]];
    }
    if (_userSettingsModel.isSearchEnabled) {
        [_highlightView addHighLightToolbuttonWithHighLightTool:[self addHighlightTool:@"Search" icon:ICON_SEARCH ofType:kHighlightItemTypeSearch]];
    }
    [_highlightView addHighLightToolbuttonWithHighLightTool:[self addHighlightTool:@"Delete" icon:ICON_DELETE_OUTLINE ofType:kHighlightItemTypeDelete]];
    
    if (!_userSettingsModel.isContextualNoteEnabled && !_userSettingsModel.isSearchEnabled) {
        _highlightView.frame = CGRectMake(5 , 0, isIpad()?(HighlightItemWidthForIpad) * 6 : (HighlightItemWidthForIphone) * 6,isIpad()?HighlightItemHeightForIpad:HighlightItemHeightForIphone);
    }
    
   else if (!_userSettingsModel.isContextualNoteEnabled || !_userSettingsModel.isSearchEnabled) {
        _highlightView.frame = CGRectMake(5 , 0, isIpad()?(HighlightItemWidthForIpad) * 7 : (HighlightItemWidthForIphone) * 7,isIpad()?HighlightItemHeightForIpad:HighlightItemHeightForIphone);
    }
    
    __weak typeof(self) weakSelf = self;

    [_highlightView setHighLightToolActions:^(HighLightToolView *highlighToolView,NSString *selectedColor) {
        
        switch (highlighToolView.tag) {
                    case kHighlightItemTypeNote:{
                        [weakSelf addContextualNoteWithTextColor:selectedColor];
                    }
                        break;
                        
                    case kHighlightItemTypeSearch:{
                        [weakSelf actionForSearchTool];
                        break;
                    }
                    case kHighlightItemTypeDelete:{
                        [weakSelf actionForHighlightDelete:selectedColor];
                    }
                        break;
                    default:
                        break;
                }
    }];
}

-(void)addContextualNoteWithTextColor:(NSString *)selectedColor{
    if ([currentBook isKindOfClass:[KFBookVO class]])
    {
        SDKHighlightVO *sdkHighlightVO = [self.rendererView getHighlightForSelectedTextWithTextColor:selectedColor WithBackgroundColor:selectedColor];
        if(sdkHighlightVO)
        {
            [self removeHighlightPopup];
            [self showNotesForHighlight:sdkHighlightVO forMyDate:NO];
        }
    }
    else{
        [self.rendererView  getHighlightForSelectedTextEpubWithTextColor:@YellowColor WithBackgroundColor:@YellowColor andCallBack:^(SDKHighlightVO *sdkHighlightVO)
         {
             if (sdkHighlightVO)
             {
                 [self removeHighlightPopup];
                 [self showNotesForHighlight:sdkHighlightVO forMyDate:NO];
             }
         }];
    }
}

-(void)deleteHighightItemWithTextColor:(NSString *)selectedColor{
    if ([currentBook isKindOfClass:[KFBookVO class]]) {
        [self.rendererView deleteSelectedHighlight:[self.rendererView getHighlightForSelectedTextWithTextColor:selectedColor WithBackgroundColor:selectedColor]];
    }
    else{
        [self.rendererView  getHighlightForSelectedTextEpubWithTextColor:@YellowColor WithBackgroundColor:@YellowColor andCallBack:^(SDKHighlightVO *sdkHighlightVO) {
            if (sdkHighlightVO) {
                [self.rendererView deleteSelectedHighlight:sdkHighlightVO];
            }
        }];
    }
}

-(HighLightToolView*)initializeHighlightToolView
{
    HighLightToolView *highlightToolV = [[HighLightToolView alloc] initWithFrame:CGRectMake(0, 0,isIpad()?HighlightItemWidthForIpad:HighlightItemWidthForIphone ,isIpad()?HighlightItemHeightForIpad:HighlightItemHeightForIphone)];
    return highlightToolV;
}

-(UIView *)addHighlightTool:(NSString *)titleStr icon:(NSString *)icon ofType:(HighlightItemType)typeOfItem{
    HighLightToolView *highlightToolV = [self initializeHighlightToolView];
    highlightToolV.tag = typeOfItem;
    
    highlightToolV.iconLabel.text = icon;
    CGFloat itemSize =  (windowWidth == 320)? 19 :21;
    highlightToolV.iconLabel.font = [UIFont fontWithName:font_name size:isIpad()? 24.0:(itemSize)];
    highlightToolV.iconLabel.textColor = hdThemeVO.highlight_popup_icon_color;
    highlightToolV.contentView.backgroundColor = [UIColor clearColor];
    highlightToolV.widthConstraintOfIcon.constant = highlightToolV.heightConstraintOfIcon.constant = 32;
    highlightToolV.accessibilityIdentifier = titleStr;
    return highlightToolV;
}

-(UIView *)addHighlightColor:(NSString *)ColorStr{
    HighLightToolView *highlightToolV = [self initializeHighlightToolView];
    highlightToolV.contentView.backgroundColor = [UIColor clearColor];
    highlightToolV.iconLabel.backgroundColor = [UIColor colorWithHexString:ColorStr];
    CGFloat itemSize =  (windowWidth == 320)? 20 :22;
    [highlightToolV resetViewForColorPalletWithColorHeight:isIpad()?25:itemSize];
    if(!isIPAD){
    highlightToolV.heightConstraintOfBorderView.constant = highlightToolV.widthConstraintOfBorderView.constant  = 26;
    highlightToolV.heightConstraintOfIcon.constant = highlightToolV.widthConstraintOfIcon.constant  = 18;
    highlightToolV.borderView.layer.cornerRadius = highlightToolV.widthConstraintOfBorderView.constant/2;
        highlightToolV.iconLabel.layer.cornerRadius = 9;
        highlightToolV.borderView.clipsToBounds = YES;
        highlightToolV.iconLabel.clipsToBounds = YES;

    }
     highlightToolV.borderView.layer.borderWidth = 1.0;
    highlightToolV.borderView.layer.borderColor = [UIColor clearColor].CGColor;

    return highlightToolV;
}

-(void)actionForHighlightDelete:(NSString*)selectedColor
{
    [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"Delete_Highlight" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]  message:[LocalizationHelper localizedStringWithKey:@"Do_you_wish_to_delete_highlight" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"NO_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController],[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if([buttonTitle isEqualToString:[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]]){
            [self deleteHighightItemWithTextColor:selectedColor];
        }
    }];
}

/**
 Call this method to perform action for the Search HighlightItem
 */
-(void)actionForSearchTool
{
    if ([currentBook isKindOfClass:[KFBookVO class]])
    {
        SDKHighlightVO *sdkHighlightVO = [_rendererView getHighlightForSelectedTextWithTextColor:@YellowColor WithBackgroundColor:@YellowColor];
        if(sdkHighlightVO)
        {
            [self removeHighlightPopup];
            [self moveTopAndBottomOnScreenWithIsAnimate:NO WithCompletionHandler:nil];
            //        UITextField *searchTextField = [self getSearchTextField];
            //        [searchTextField setText:sdkHighlightVO.text];
            [self addSearchForText:sdkHighlightVO.text isElasticSearch:NO];
        }
    }
    else{
        [self actionForSearchToolEpub];
    }
}

-(void)actionForSearchToolEpub
{
    [_rendererView getHighlightForSelectedTextEpubWithTextColor:@YellowColor WithBackgroundColor:@YellowColor andCallBack:^(SDKHighlightVO *sdkHighlightVO)
     {
         if (sdkHighlightVO)
         {
             [self removeHighlightPopup];
             if([sdkHighlightVO.text length]>=MininumSearchStringLenght)
             {
                 [self moveTopAndBottomOnScreenWithIsAnimate:NO WithCompletionHandler:nil];
                 [self addSearchForText:sdkHighlightVO.text isElasticSearch:NO];
             }
         }
     }];
}

/**
 Will be called to Enable/Disable the logs
 */
- (void)setLogsEnabled:(BOOL)logEnabled
{
    [KitabooDebugLog enableLogsWithIsenabled:logEnabled];
}

/**
 Will be called to Enable/Disable the Verbose
 */
- (void)setVerboseEnabled:(BOOL)verboseEnabled
{
    [KitabooDebugLog enableVerboseWithIsenabled:verboseEnabled];
}

#pragma mark RendererViewControllerDelegate Implementation

/**
 RendererViewControllerDelegate Implementation
 */
-(void)rendererViewController:(RendererViewController*)rendrerViewController didLoadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum
{
    [KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:[NSString stringWithFormat:@"didLoadPageWithPageNumber--%ld and With DisplayNumber--%@",(long)number.integerValue,displayNum] verboseMesage:@""];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
      NSString *documentPath = [paths objectAtIndex:0];
      NSURL *url = [NSURL fileURLWithPath:documentPath];
    KFBookVO *book=(KFBookVO*)currentBook;

    [_delegate didLoadPageWithPageNumber:number WithDisplayNumber:displayNum forBookID:book andUser:_user andPreviousPageNumber:previousPageNumber];
    
    MHEReaderViewController *mheReaderViewController = [[MHEReaderViewController alloc] init];

    [mheReaderViewController saveUGCPerPageForBookID:book.bookID forPageID:number.integerValue forUser:_user completion:^{
            [self didUGCDataSuccessfullyParsed];
    }];
    [self stopInlineVideo];
    [self resetAudioPlayerPosition];
    if(readAloudMode != ReadAloudModeAutoPlay){
        [self closeAudioSync];
    }
    [self stopAudioSyncIfAny];
    if([book isKindOfClass:[KFBookVO class]]){
        KFChapterVO *chapter = [book getChapterForPageID:[NSString stringWithFormat:@"%ld",(long)number.integerValue]];
        currentChapterName = chapter.title;
        currentChapter = chapter.chapterID;
    }
    else{
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        NSPredicate *predicateToFindClass = [NSPredicate predicateWithFormat:
                                             @"self.fileIndex == %d",displayNum.intValue];
        NSArray *araayOfChapters = [book.chapters filteredArrayUsingPredicate:predicateToFindClass];
        [self updateChapterTitleForChapter:[araayOfChapters objectAtIndex:0] withTOCData:[self getTOCContentData]];
    }
    [self updateChapterNameForTopBar];
    if(activeMode != kPlayerActiveModeTeacherReview)
    {
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            if(book.meta.layout!=ePUBReflowable)
            {
                if(activeMode==kPlayerActiveModeNone && !self.helpScreen)
                {
                    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
                }
            }
        }else{
            if(activeMode==kPlayerActiveModeNone && !self.helpScreen)
            {
                [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
            }
        }
        [self updateIphoneBottomBarPageSliderForPageNumber:number];
        [self drawHighlightsOnPageNumber:[number stringValue] OnDisplayNumber:displayNum];
        if([_userSettingsModel isBookmarkEnabled])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addBookmarkOnPageNumber:[number stringValue] OnDisplayNumber:displayNum];
                [self addPrintPageViewOnPageNumber:number OnDisplayNumber:displayNum];
            });
        } else {
            [self addPrintPageViewOnPageNumber:number OnDisplayNumber:displayNum];
        }
        
        [self drawPenDrawingsOnPageNumber:[number stringValue] OnDisplayNumber:displayNum];
        [self drawMarkupsOnPageNumber:[number stringValue] OnDisplayNumber:displayNum];
        /*TextAnnotation feature disable , uncomment to enable*/
        [self drawTextAnnotationsOnPageNumber:[number stringValue] OnDisplayNumber:displayNum];
        [self drawProtractorOnPageNumber:[number stringValue] OnDisplayNumber:displayNum];
        [self performSelector:@selector(updateActivePagesInfoLabel) withObject:nil afterDelay:0.5];
        
        if(activeMode == kPlayerActiveModePentool)
        {
            [_rendererView setPenDrawingModeEnabled:YES];
        }
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            if (book.meta.layout == ePUBFixedLayout){
                [self setpagesIntoHistoryArray:[NSString stringWithFormat:@"%@",number]];
            }
            if(book.meta.layout==ePUBReflowable)
            {
                NSString *context = [[[_searchResult.searchResultAttributedString string] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
                
                if(_searchResult && ![_searchResult.searchedWord isEqualToString:@""] && (number.integerValue == [[self getFileIndexForHREF:_searchResult.href] integerValue]))
                    
                {
                    if (activeMode == kplayerActiveModeElasticSearch)
                    {
                        if ((number.integerValue != [self getHrefFromFileIndex:_searchResult.pageIndex]) && (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)))
                        {
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor];
                        }
                        else if ((number.integerValue != [self getHrefFromFileIndex:_searchResult.pageIndex]) && (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))){
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherHighlightColor WithParagraph:context];
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:number.stringValue withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                            
                        }
                        else
                        {
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherHighlightColor WithParagraph:context];
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                        }
                    }
                    else
                    {
                        [_rendererView highlightText:_searchResult.searchedWord OnPageNo:0 WithColor:@SeacherMaskColor WithParagraph:context];
                    }
                }
                if (_lastPageFolio) {
                    validLastPageFolio = _lastPageFolio;
                    NSData * data = [_lastPageFolio dataUsingEncoding:NSUTF8StringEncoding];
                    if(data)
                    {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        if ([json valueForKey:@"positionIdentifier"])
                        {
                            NSString *lastPageCFIString = [json valueForKey:@"positionIdentifier"];
                            [_rendererView jumpToCFIString:lastPageCFIString];
                            _lastPageFolio = nil;
                        }
                        else
                        {
                            //jump to range
                            _lastPageFolio = nil;
                        }
                    }
                }
            }
            else
         {
                if(_searchResult && ![_searchResult.searchedWord isEqualToString:@""] && (number.integerValue == [[self getFileIndexForHREF:_searchResult.href] integerValue]))
                {
                    
                    if (activeMode == kplayerActiveModeElasticSearch)
                    {
                        if ((number.integerValue != [self getHrefFromFileIndex:_searchResult.pageIndex]) && (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)))
                        {
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor];
                        }
                        else if ((number.integerValue != [self getHrefFromFileIndex:_searchResult.pageIndex]) && (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))){
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:number.stringValue withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                        }
                        else
                        {
                            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                        }
                    }
                    else
                    {
                        [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor];
                        
                    }
                    
                }
            }
        }

        else
        {
            if(_searchResult && ![_searchResult.searchedWord isEqualToString:@""])
            {
                if (activeMode == kplayerActiveModeElasticSearch)
                {
                    if ((number.integerValue != _searchResult.pageIndex.integerValue) && (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)))
                    {
                        [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor];
                    }
                    else if ((number.integerValue != _searchResult.pageIndex.integerValue) && (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))){
                        [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:number.stringValue withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                    }
                    else
                    {
                        [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                    }
                }
                else
                {
                    if ((number.integerValue == _searchResult.pageIndex.integerValue))
                    {
                        [_rendererView highlightText:_searchResult.searchedWord OnPageNo:number.intValue WithColor:@SeacherMaskColor];
                    }
                }
            }
        }
        
//        [self resignSearchTextField];
        if (self.helpScreen) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.helpScreen.helpDescriptors = [self getAllAppBarButton];
                [self.helpScreen setUpViews];
            });

        }
    }
    else
    {
        if (activeMode == kPlayerActiveModeTeacherReview && penToolController)
        {
            if (_teacherAnnotationController.isAnnotationEnabled) {
                [self drawTeacherReviewPenDrawingsOnPageNumber:number];
            }
            [self drawTeacherReviewFIBOnPageNumber:number];
            [self drawTeacherReviewDropDownOnPageNumber:number];
            [self actionForTeacherReviewPageChanged];
            [self updateTeacherReviewUI];
        }
    }
}
-(void)refreshTeacherReviewPage:(NSNumber*)number{
    if (_teacherAnnotationController.isAnnotationEnabled) {
        [self drawTeacherReviewPenDrawingsOnPageNumber:number];
    }
    [self drawTeacherReviewFIBOnPageNumber:number];
    [self drawTeacherReviewDropDownOnPageNumber:number];
}
- (void)rendererViewController:(RendererViewController *)rendererViewController didRendererChangedAvailabilityForActionState:(RendererAvailabilityForActionState)state forPageNumber:(NSNumber *)number WithDisplayNumber:(NSString *)displayNum
{
    if(state == RendererAvailabilityForActionStateBegin)
    {
    }
    else if(state == RendererAvailabilityForActionStateComplete)
    {
        if(readAloudMode != ReadAloudModeLetMeRead)
        {
            if(_audioSyncController)
            {
                NSString* audioPlayingOnPageID = [_audioSyncController audioPlayingForPageIdentifier];
                if(![[self getActivePageIDs] containsObject:audioPlayingOnPageID])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self actionForReadAloud];
                    });
                    
                }
            }
            else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self actionForReadAloud];
                });
            }
        }
        [self setpagesIntoHistoryArray:[NSString stringWithFormat:@"%@",number]];
        [self updateClearAllFIBsButtonStatus];
    }
    if(readAloudMode != ReadAloudModeLetMeRead)
    [self enableNextPrevButtonForReadAloud];
}
-(void)updateChapterNameForTopBar{
    for (UIView *view in self.playerTopActionBarView.chapterNameItem.subviews) {
        if([view isKindOfClass:[UILabel class]]){
            ((UILabel*)view).text = currentChapterName;
        }
    }
    
}
/**
 Call to method to stop playing Inline Video
 */
-(void)stopInlineVideo
{
    if (activeMode == kPlayerActiveModeMarkupPlayerInLineVideo)
    {
        [self removeInlineLocalPlayer];
        [self removeInlineYoutubePlayer];
    }
}


/**
 Call this method to Reset the position of Audio Player
 */
-(void)resetAudioPlayerPosition
{
    if (_audioPlayer.isAudioResourcePlaybackground)
        return;
    
    if(activeMode == kPlayerActiveModeMarkupPlayerAudio)
    {
        _playerView.center = self.view.center;
    }
}

-(void)stopAudioSyncIfAny
{
    if(_audioSyncController)
    {
        [_rendererView.view setUserInteractionEnabled:YES];
        [_audioSyncController stop];
        _audioSyncController=nil;
        activeMode=kPlayerActiveModeNone;
        [self changePlayButtonState];
        [self enablePlayButton:NO];
    }
    
}
-(void)pauseAudioSyncIfAny
{
    if(_audioSyncController)
    {
        [_audioSyncController pause];
        [self changePlayButtonState];
    }
}
-(void)playPauseAudioSyncIfAny
{
    if(_audioSyncController)
    {
        [_audioSyncController playPauseAction];
        [self changePlayButtonState];
    }
}

/**
 Call this method to load/play Audio sync on Specific page
 */
-(void)loadAudioSyncIdAvailableForPageNumber:(NSNumber*)number
{
    if (activeMode == kPlayerActiveModeReadAloud && readAloudMode == ReadAloudModeAutoPlay) {
        [self stopAudioSyncIfAny];
    }
    KFBookVO *book=(KFBookVO*)currentBook;
    KFPageVO *page=[book.pages objectForKey:[NSString stringWithFormat:@"%d",number.intValue]];
    if(page)
    {
        NSArray *audioSyncLinks=[page getAudioSyncTypeLinks];
        if(audioSyncLinks.count)
        {
            activeMode=kPlayerActiveModeReadAloud;
            _audioSyncController = nil;
            _audioSyncController=[[AudioSyncController alloc]initWithLinks:audioSyncLinks  WithDelegate:self WithKitabooBook:book WithPlayerUIEnable:NO];
            [_audioSyncController start];
            if(readAloudMode != ReadAloudModeLetMeRead)
            {
//                [_audioSyncController increaseAudioPlayingSpeed:[self getReadAloudValume]];
                [_rendererView.view setUserInteractionEnabled:NO];
                [self addPlayerBottomBarForAudioSync];
                [self changeAudioSyncSpeedRateWithOption];
                [self changePlayButtonState];
                [self enablePlayButton:YES];
            }
        } else {
            [self closeAudioSync];
        }
    }
}
-(void)changeAudioSyncSpeedRateWithOption
{
    UILabel *speedRateLabel = [self getAudioSyncSpeedRateLabel];
    float speedRate = 0.0;
    switch (audioSyncSpeedRateOption) {
        case kAudioSyncSpeedRateOption1:
        {
            [self readAloudItemEnable:NO withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypePrev]];
            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypeNext]];
            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption1]]]];
            speedRate = AudioSyncSpeedRateOption1;
        }
            break;
        case kAudioSyncSpeedRateOption2:
        {
            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypePrev]];
            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypeNext]];
            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption2]]]];
            speedRate = AudioSyncSpeedRateOption2;
        }
            break;
        case kAudioSyncSpeedRateOption3:
        {
            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypePrev]];
            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypeNext]];
            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption3]]]];
            speedRate = AudioSyncSpeedRateOption3;
        }
            break;
        case kAudioSyncSpeedRateOption4:
        {
            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypePrev]];
            [self readAloudItemEnable:NO withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypeNext]];
            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption4]]]];
            speedRate = AudioSyncSpeedRateOption4;
        }
            break;
        default:
            break;
    }
    if (_audioSyncController) {
        speedRateLabel.tag = audioSyncSpeedRateOption;
        [_audioSyncController changeAudioPlayingSpeed:speedRate];
    }
}
#pragma AudioSyncControllerDelegate Implementation
/**
 AudioSyncControllerDelegate Implementation
 */
-(void)didJumpToTextWithFrame:(CGRect)frame WithPageIdentifier:(NSString *)pageIdentifier
{
    [_rendererView highlightTextWithFrame:frame OnPageNo:pageIdentifier.intValue WithColor:audioSyncSelectedColor];
}

- (void)didJumpToSentenceWithWordFrames:(NSArray *)frames WithPageIdentifier:(NSString *)pageIdentifier
{
    [_rendererView highlightSentenceWithWordFrames:frames OnPageNo:pageIdentifier.intValue WithColor:audioSyncSelectedColor];
}

-(void)didJumpToTextWithWordId:(NSString *)wordId WithPageIdentifier:(NSString *)pageIdentifier
{
    [_rendererView highlightWordByWordId:wordId WithColor:@SeacherMaskColor];
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didTapOnWordWithWordId:(NSString *)wordId WithWordText:(NSString *)wordText{
    if (_audioSyncController && _audioSyncController.isPlaying) {
        [_audioSyncController playAudioFromWordId:wordId];
    }
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didChangeFirstVisibleWordWithWord:(NSDictionary *)wordDictionary
{
    if (_audioSyncController && _audioSyncController.isPlaying && [wordDictionary valueForKey:@"wordId"]) {
        [_audioSyncController playAudioFromWordId:[wordDictionary valueForKey:@"wordId"]];
    }
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didTapOnResource:(EPUBResource *)resource {
    [self actionForResource:resource];
}

- (void)closeAudioSync {
    if (activeMode == kPlayerActiveModeAudioSync || activeMode == kPlayerActiveModeMarkupPlayer || activeMode == kPlayerActiveModeReadAloud)
    {
        [penColorPallete.view removeFromSuperview];
        penColorPallete=nil;
        [penToolPalleteContainer removeFromSuperview];
        penToolPalleteContainer =nil;
        readAloudMode = ReadAloudModeLetMeRead;
        activeMode = kPlayerActiveModeNone;
        [self stopAudioSyncIfAny];
        [self removeAudioSyncBottomBar];
        [_rendererView highlightWordByWordId:@"" WithColor:@""];
    }
}


/**
 AudioSyncControllerDelegate Implementation
 */
-(void)audioSyncdidComplete
{
    [_rendererView.view setUserInteractionEnabled:YES];
    [_playerView removeFromSuperview];
    _audioSyncController=nil;
    activeMode=kPlayerActiveModeNone;
}

- (void)audioSyncdidCompleteForPageIdentifier:(NSString *)pageIdentifier
{
    if ([currentBook isKindOfClass:[KFBookVO class]]) {
        if(readAloudMode == ReadAloudModeLetMeRead)
        {
            [self closeAudioSync];
            [_rendererView.view setUserInteractionEnabled:YES];
            [_playerView removeFromSuperview];
            _audioSyncController=nil;
            activeMode=kPlayerActiveModeNone;
        }
        else
        {
            [self changePlayButtonState];
            [self enablePlayButton:NO];
            if(readAloudMode == ReadAloudModeAutoPlay)
            {
                KFBookVO *book=(KFBookVO*)currentBook;
                KFPageVO *nextAudioPage = [book getNextAudioLinkPagefromCurrentPageNumber:pageIdentifier];
                if(nextAudioPage)
                {
                    NSString *nextPageID = [NSString stringWithFormat:@"%ld",(long)nextAudioPage.pageID];
                    if(![[self getActivePageIDs]containsObject:nextPageID])
                    {
                        [_rendererView navigateToPageNumber:nextPageID];
                    }
                    else
                    {
                        [self loadAudioSyncIdAvailableForPageNumber:[NSNumber numberWithInteger:nextAudioPage.pageID]];
                    }
                } else {
                    [self closeAudioSync];
                }
            }
            else if(readAloudMode == ReadAloudModeReadToMe)
            {
                NSString *activePageID = [[self getActivePageIDs]lastObject];
                if([activePageID isEqualToString:pageIdentifier])
                {
                    [self closeAudioSync];
                    _audioSyncController=nil;
                }
                else
                {
                    [self loadAudioSyncIdAvailableForPageNumber:[NSNumber numberWithInteger:activePageID.integerValue]];
                }
            }
        }
    }
    else {
        [_rendererView.view setUserInteractionEnabled:YES];
        [_playerView removeFromSuperview];
        [_audioSyncController stop];
        _audioSyncController=nil;
        activeMode=kPlayerActiveModeNone;
        //jump to next chapter & play audio if available
        [self closeAudioSync];
        NSInteger fileIndex = [self getHrefFromFileIndex:pageIdentifier];
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if ((fileIndex+1) < epubBook.chapters.count) {
            EPUBChapter *currentChapter = epubBook.chapters[fileIndex+1];
            if (currentChapter) {
                [_rendererView navigateToPageNumber:currentChapter.href];
                [self playAudioSyncForChapter:currentChapter];
            }
        }
    }
}
/**
 AudioSyncControllerDelegate Implementation
 */
-(void)audioSyncDidStopped
{
    [_rendererView.view setUserInteractionEnabled:YES];
    [_playerView removeFromSuperview];
    _audioSyncController=nil;
    activeMode=kPlayerActiveModeNone;
}

/**
 AudioSyncControllerDelegate Implementation
 */
-(void)audioSyncDidPaused
{
    
}


/**
 Call this method to resign Search TextField
 */
-(void)resignSearchTextField
{
    [self.view endEditing:YES];
}

/**
 Returns an array of Active pageIds
 */
-(NSArray*)getActivePageIDs
{
    NSMutableArray *activePageIds=[[NSMutableArray alloc]init];
    NSArray *activePages=[_rendererView getActivePages];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        for (KFPageVO *page in activePages)
        {
            [activePageIds addObject:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
        }
    }
    else
    {
        for (EPUBPage *page in activePages)
        {
            [activePageIds addObject:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
        }
    }
    
    return [NSArray arrayWithArray:activePageIds];
}

/**
 Call this method to draw/add Teacher review pen drawings on specific page
 */
-(void)drawTeacherReviewPenDrawingsOnPageNumber:(NSNumber*)number
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        pageIdentifierForTeacherReview = [number stringValue];
        NSArray* penDrawings= [_teacherAnnotationController getPenToolUGCForPageIdentifier:[number stringValue]];
        if(penDrawings.count)
        {
            [_rendererView drawPenDrawings:penDrawings OnPageNo:[number integerValue]];
        }
        [self updatePentoolButtonStatus];
    }
}

-(void)drawTeacherReviewFIBOnPageNumber:(NSNumber*)number
{
    NSArray* fibArray= [_teacherAnnotationController getFIBUGCForPageIdentifier:[number stringValue]];
        KFBookVO *book=(KFBookVO*)currentBook;
        NSArray* links=[book getLinksForForPagenumber:[NSNumber numberWithInteger:number.integerValue]];
        NSMutableArray *hdFIBArray = [[NSMutableArray alloc]init];
        for (KFLinkVO *link in links)
        {
            if(link.linkType == kLinkTypeInput)
            {
                NSArray *filterArray = [fibArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"linkID = %@",[NSNumber numberWithInteger:link.linkID]]];
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"ugcID" ascending:NO];
                filterArray = [filterArray sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
                
                SDKFIBVO *fibVO;
                if(filterArray.count)
                {
                    fibVO = filterArray.firstObject;
                }
                
                HDFIB *_fib = [[HDFIB alloc]initWithLinkVO:link withFIBVO:fibVO isTeacher:![_user.role isEqualToString:@"LEARNER"]];
                _fib.delegate=self;
                _fib.isDefaultKeyboardDisabled = [self isDefaultKeyboardDisabled:_fib];
                [hdFIBArray addObject:_fib];
                if(fibVO.isEquation && fibVO.status != DELETE && [self isMathKeyboardEnabled:_fib])
                {
                    FIBMathEquationView *fibMathEquationView = [[FIBMathEquationView alloc]initWithLink:_fib.linkVo fibVO:fibVO frame:_fib.frame];
                    fibMathEquationView.isTeacher = ![_user.role isEqualToString:@"LEARNER"];
                    [self setColorToMathKeyboard:fibMathEquationView withFIBVO:fibVO withFIB:_fib];
                    fibMathEquationView.delegate = self;
                    [hdFIBArray addObject:fibMathEquationView];
                }
            }
        }
        if(hdFIBArray.count)
        {
            [self drawFIB:hdFIBArray OnPageNumber:number.integerValue];
        }
}
-(void)drawTeacherReviewDropDownOnPageNumber:(NSNumber*)number
{
    NSArray* fibArray= [_teacherAnnotationController getFIBUGCForPageIdentifier:[number stringValue]];
        KFBookVO *book=(KFBookVO*)currentBook;
        NSArray* links=[book getLinksForForPagenumber:[NSNumber numberWithInteger:number.integerValue]];
        NSMutableArray *dropDownArray = [[NSMutableArray alloc]init];
        for (KFLinkVO *link in links)
        {
            if (link.linkType == kLinkTypeDropDown)
            {
                link.iconView=[[MarkupView alloc]init];
                [link.iconView addTarget:self action:@selector(didTapOnLink:) forControlEvents:UIControlEventTouchUpInside];
                link.iconView.pageID=number.integerValue;
                link.iconView.linkID=link.linkID;
                link.iconView.frame = link.boxTansformedRect;
                
                NSArray *filterArray = [fibArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"linkID = %@",[NSNumber numberWithInteger:link.linkID]]];
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"ugcID" ascending:NO];
                filterArray = [filterArray sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
                
                SDKFIBVO *fibVO;
                if(filterArray.count)
                {
                    fibVO = filterArray.firstObject;
                    link.iconView.sdkFIBVO = fibVO;
                }
                
                if(!fibVO.text || fibVO.text.length == 0)
                {
                    [link.iconView updateForDropDownWithInputText:[LocalizationHelper localizedStringWithKey:@"SELECT_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withLinkProperties:link.properties];
                }
                else
                {
                    [link.iconView updateForDropDownWithInputText:fibVO.text withLinkProperties:link.properties];
                }
                [link.iconView removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
                if (fibVO) {
                    [link.iconView addTarget:self action:@selector(didTapOnSubmittedDropDown:) forControlEvents:UIControlEventTouchUpInside];
                    [self compareAndShowInstantFeedbackForDropDownLink:link andFibVO:fibVO isForTeacherReview:true];
                }
                [dropDownArray addObject:link];
                
            }
        }
        
        if(dropDownArray.count)
        {
            [_rendererView drawMarkups:dropDownArray OnPageNo:number.integerValue];
        }
}
/**
 Call this method to reload the page UGC of the active pages
 */
-(void)relaodPageUGCForActivePages
{
    NSArray *activePages=[_rendererView getActivePages];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        for (KFPageVO *page in activePages)
        {
            [self drawHighlightsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
            if ([_userSettingsModel isBookmarkEnabled])
            {
                [self addBookmarkOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
            }
            [self drawPenDrawingsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
            [self drawMarkupsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
        /*TextAnnotation feature disable , uncomment to enable*/
            [self drawTextAnnotationsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
            [self drawProtractorOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
        }
    }
    else
    {
        for (EPUBPage *page in activePages)
        {
            [self drawHighlightsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] OnDisplayNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
            if ([_userSettingsModel isBookmarkEnabled])
            {
                [self addBookmarkOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] OnDisplayNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
            }
            [self drawPenDrawingsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] OnDisplayNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
        }
    }
}



-(void)updateIphoneBottomBarPageSliderForPageNumber:(NSNumber*)number
{
    if(!isIpad())
    {
        [pageSliderForiPhoneBottomBar setValue:number.integerValue];
    }
}

/**
 Call this method to perform action for the Note HighlightItem
 */
-(void)actionForStickNote
{
    [_rendererView resetZoomScaleToDefault];
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    
    StickyNoteController *stickyNoteController=[[StickyNoteController alloc]initWithFrame:self.view.bounds WithDelegate:self];
    [self.view addSubview:stickyNoteController];
    stickyNoteController.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dictionary = NSDictionaryOfVariableBindings(stickyNoteController);
    NSString *vfString = @"H:|-0-[stickyNoteController]-0-|";
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vfString
                                                                             options:0
                                                                             metrics:nil
                                                                               views:dictionary];
    vfString = @"V:|-0-[stickyNoteController]-0-|";
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vfString
                                                                           options:0
                                                                           metrics:nil
                                                                             views:dictionary];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
}
-(void)showStickyNote
{
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        SDKHighlightVO *sdkHighlightVO = [_rendererView getHighlightVOForStickyNoteWithDefaultPosition];
        if(sdkHighlightVO)
        {
            [self showNotesForHighlight:sdkHighlightVO forMyDate:NO];
        }
        else
        {
            [KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:@"Invalid Points" verboseMesage:@""];
        }
    }else{
        [_rendererView getHighlightVOForStickyNoteWithDefaultPositionWithCallBack:^(SDKHighlightVO *result, NSError *error){
            SDKHighlightVO *sdkHighlightVO = result;
            if(sdkHighlightVO){
                [self showNotesForHighlight:sdkHighlightVO forMyDate:NO];
            }
            else{
                [KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:@"Invalid Points" verboseMesage:@""];
            }
        }];
    }
    
}
-(BOOL)didStickyNoteAllowedTwoPagePanning
{
    return YES;
}
/**
 Call this method to add/draw highlights on specific page
 */
-(void)drawHighlightsOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray* highlights=[_dbManager highlightForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];

//        if(highlights.count)
//        {
            [_rendererView drawHighlights:highlights OnPageNo:[number integerValue]];
//        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    NSArray* highlights=[_dbManager highlightForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                [_rendererView drawHighlights:highlights OnPageNo:[number integerValue]];
            });
        });
    }
}


/**
 Call this method to add/draw pen drawingds on specific page
 */
-(void)drawPenDrawingsOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray* penDrawings=[_dbManager pentoolDrawingForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [_rendererView drawPenDrawings:penDrawings OnPageNo:[number integerValue]];
    }
    else if ([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        NSArray* penDrawings=[_dbManager pentoolDrawingForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [_rendererView drawPenDrawings:penDrawings OnPageNo:[number integerValue]];
    }
}


/**
 Call this method to add/draw markups on specific page
 */
-(void)drawMarkupsOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *book=(KFBookVO*)currentBook;
        NSArray* links=[book getLinksForForPagenumber:[NSNumber numberWithInteger:number.integerValue]];
        
        NSMutableArray *multiLinkGroupNameArray = [[NSMutableArray alloc]init];
        NSMutableArray *finalLinksArray = [[NSMutableArray alloc]initWithArray:links];
        NSMutableArray *fibArray = [[NSMutableArray alloc]init];
        for (KFLinkVO *link in links)
        {
            if(link.linkType==kLinkTypeOther)
            {
                [finalLinksArray removeObject:link];
                continue;
            }
            if(link.isMultiLinkMember)
            {
                NSString *key = [NSString stringWithFormat:@"%@_%@",link.xCoordinate,link.yCoordinate];
                if(![multiLinkGroupNameArray containsObject:key])
                {
                    KFLinkVO *multiLink=[[KFLinkVO alloc]init];
                    multiLink.iconView=[[MarkupView alloc]init];
                    [multiLink.iconView addTarget:self action:@selector(didTapOnLink:) forControlEvents:UIControlEventTouchUpInside];
                    multiLink.iconView.pageID=number.integerValue;
                    multiLink.linkType = kLinkTypeMultiLink;
                    multiLink.transformedRect = link.transformedRect;
                    multiLink.boxTansformedRect = link.boxTansformedRect;
                    multiLink.iconView.xCordinate = link.xCoordinate;
                    multiLink.iconView.yCordinate = link.yCoordinate;
                    multiLink.iconHitAreaLabel=[[MarkupHitAreaLabel alloc]init];
                    multiLink.iconHitAreaLabel.pageID=number.integerValue;
                    multiLink.iconView.frame= [self get220PercentScaleRectForLinkMarkups:multiLink];
                    [multiLink.iconView setTitle:MULTIFILE_ICON forState:UIControlStateNormal];
                    multiLink.iconView.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] CGColor];
                    multiLink.iconView.layer.borderWidth = isIpad() ? 2.8 : 1.0;
                    multiLink.iconView.layer.cornerRadius=CGRectGetHeight(multiLink.iconView.frame)/2;
                    multiLink.iconView.titleLabel.font = [UIFont fontWithName:[self getFontName] size:CGRectGetHeight(multiLink.iconView.frame) * 0.5];
                    [multiLink.iconView.titleLabel setTextAlignment:NSTextAlignmentCenter];
                    [multiLink.iconView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    multiLink.iconView.backgroundColor=[UIColor colorWithHexString:@"#3b3b3b"];
                    multiLink.iconHitAreaLabel.iconView = multiLink.iconView;
                    multiLink.iconHitAreaLabel.frame = CGRectMake(multiLink.iconView.frame.origin.x, multiLink.iconView.frame.origin.y, CGRectGetWidth(link.boxTansformedRect), CGRectGetHeight(link.boxTansformedRect));
                    [multiLinkGroupNameArray addObject:key];
                    [finalLinksArray addObject:multiLink];
                }
                
                link.iconView=[[MarkupView alloc]init];
                link.iconView.pageID=number.integerValue;
                link.iconView.linkID=link.linkID;
                link.iconView.frame=[self getRectForLinkMarkups:link];;
                [link.iconView setTitle:[self getIconForLinkType:link] forState:UIControlStateNormal];
                link.iconView.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] CGColor];
                link.iconView.layer.borderWidth = isIpad() ? 2.8 : 1.0;
                link.iconView.layer.cornerRadius=link.transformedRect.size.width/2;
                [link.iconView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                link.iconView.backgroundColor=[UIColor colorWithHexString:@"#3b3b3b"];
                
                [finalLinksArray removeObject:link];
            }
            else if(link.linkType == kLinkTypeGlossary){
                link.iconView=[[MarkupView alloc]init];
                
                [link.iconView addTarget:self action:@selector(didTapOnLink:) forControlEvents:UIControlEventTouchUpInside];
                link.iconView.pageID=number.integerValue;
                link.iconView.linkID=link.linkID;
                link.iconView.frame = link.boxTansformedRect;
                
                //Calculated GlossaryUndrLineView Height is 5% of the markup button height,minimum is 1 pixel.
                CGFloat underlineHeight = (CGRectGetHeight(link.iconView.frame)*0.05 < 1)?1:
                CGRectGetHeight(link.iconView.frame)*0.05;
                
                UIImageView *underlineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(link.boxTansformedRect)-underlineHeight, CGRectGetWidth(link.boxTansformedRect), underlineHeight)];
                underlineView.backgroundColor = hdThemeVO.glossary_underline_color;
                [link.iconView addSubview:underlineView];
            }
            else
            {
                if(link.linkType!=kLinkTypeInput && link.linkType!=kLinkTypeDropDown)
                {
                    link.iconView=[[MarkupView alloc]init];
                    [link.iconView addTarget:self action:@selector(didTapOnLink:) forControlEvents:UIControlEventTouchUpInside];
                    link.iconHitAreaLabel=[[MarkupHitAreaLabel alloc]init];
                    link.iconHitAreaLabel.pageID=number.integerValue;
                    link.iconHitAreaLabel.linkID=link.linkID;
                    link.iconView.pageID=number.integerValue;
                    link.iconView.linkID=link.linkID;
                    
                    if(link.isInLine && (link.linkType == kLinkTypeVideo || link.linkType == kLinkTypeKaltura || link.linkType == kLinkTypeYoutube || link.linkType == kLinkTypeVimeoVideo))
                    {
//                    link.iconView.frame=CGRectMake(link.transformedRect.origin.x+((link.boxTansformedRect.size.width/2)-(link.transformedRect.size.width/2)), link.transformedRect.origin.y+((link.boxTansformedRect.size.height/2)-(link.transformedRect.size.height/2)), link.transformedRect.size.width, link.transformedRect.size.height) ;
                        link.iconView.frame=CGRectMake(link.transformedRect.origin.x+((link.boxTansformedRect.size.width/2)-(link.transformedRect.size.width/2)), link.transformedRect.origin.y+((link.boxTansformedRect.size.height/2)-(link.transformedRect.size.height/2)), CGRectGetWidth([self get220PercentScaleRectForLinkMarkups:link]), CGRectGetHeight([self get220PercentScaleRectForLinkMarkups:link])) ;
                        [link.iconView setTitle:ICON_MEDIA_PLAY forState:UIControlStateNormal];
                        link.iconView.titleLabel.font = [UIFont fontWithName:[self getFontName] size:CGRectGetHeight(link.iconView.frame) * 0.5];
                        [link.iconView.titleLabel setTextAlignment:NSTextAlignmentCenter];
                        [link.iconView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        link.iconView.backgroundColor=[UIColor colorWithHexString:@"#3b3b3b"];
                        link.iconHitAreaLabel.frame = CGRectMake(link.iconView.frame.origin.x, link.iconView.frame.origin.y, CGRectGetWidth(link.boxTansformedRect), CGRectGetHeight(link.boxTansformedRect));
                    }
                    else
                    {
//                        CGRect rect = CGRectMake(link.transformedRect.origin.x+((link.boxTansformedRect.size.width/2)-(link.transformedRect.size.width/2)), link.transformedRect.origin.y+((link.boxTansformedRect.size.height/2)-(link.transformedRect.size.height/2)), link.transformedRect.size.width, link.transformedRect.size.height);
//                        if (rect.size.width == 0 || rect.size.height == 0) {
//                            rect = [self getRectForLinkMarkups:link];
//                        }
//                        link.iconView.frame = rect;
                        link.iconHitAreaLabel.frame = link.boxTansformedRect;
                        link.iconView.frame = [self get220PercentScaleRectForLinkMarkups:link];
                        [link.iconView setTitle:[self getIconForLinkType:link] forState:UIControlStateNormal];
                        link.iconView.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] CGColor];
                        link.iconView.layer.borderWidth = isIpad() ? 2.8 : 1.0;
                        link.iconView.layer.cornerRadius=link.iconView.frame.size.width/2;
                        link.iconView.titleLabel.font = [UIFont fontWithName:[self getFontName] size:CGRectGetHeight(link.iconView.frame) * 0.5];
                        [link.iconView.titleLabel setTextAlignment:NSTextAlignmentCenter];
                        [link.iconView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        link.iconView.backgroundColor=[UIColor colorWithHexString:@"#3b3b3b"];
                    }
                    
                    if(link.iconView.titleLabel.text==nil ||  [link.iconView.titleLabel.text isEqualToString:@""])
                    {
                        [finalLinksArray removeObject:link];
                    }
                    
                    if(![link isVisible])
                    {
                        [link.iconView setAsInvisibleMarkup];
                    }
                }
                else
                {
                    if(link.linkType == kLinkTypeInput)
                    {
                        //fetch data from ugc table for link
                        SDKFIBVO *fibVO =[_dbManager getFIBObjectWithLinkId:[NSNumber numberWithInteger:link.linkID] forUserId:[NSNumber numberWithInt:_user.userID.intValue]];
                        
                        HDFIB *_fibController = [[HDFIB alloc]initWithLinkVO:link withFIBVO:fibVO isTeacher:![_user.role isEqualToString:@"LEARNER"]];
                        _fibController.delegate=self;
                        _fibController.isDefaultKeyboardDisabled = [self isDefaultKeyboardDisabled:_fibController];
                        [fibArray addObject:_fibController];
                        if(fibVO.isEquation && [self isMathKeyboardEnabled:_fibController])
                        {
                            FIBMathEquationView *fibMathEquationView = [[FIBMathEquationView alloc]initWithLink:_fibController.linkVo fibVO:fibVO frame:_fibController.frame];
                            [self setColorToMathKeyboard:fibMathEquationView withFIBVO:fibVO withFIB:_fibController];
                            fibMathEquationView.delegate = self;
                            [fibArray addObject:fibMathEquationView];
                        }
                        [finalLinksArray removeObject:link];
                    }
                    else if (link.linkType == kLinkTypeDropDown)
                    {
                        link.iconView=[[MarkupView alloc]init];
                        [link.iconView addTarget:self action:@selector(didTapOnLink:) forControlEvents:UIControlEventTouchUpInside];
                        link.iconView.pageID=number.integerValue;
                        link.iconView.linkID=link.linkID;
                        link.iconView.frame = link.boxTansformedRect;

                        SDKFIBVO *fibVO = [_dbManager getFIBObjectWithLinkId:[NSNumber numberWithInteger:link.linkID] forUserId:[NSNumber numberWithInt:_user.userID.intValue]];
                        link.iconView.sdkFIBVO = fibVO;
                        if(!fibVO.text || fibVO.text.length == 0)
                        {
                            [link.iconView updateForDropDownWithInputText:[LocalizationHelper localizedStringWithKey:@"SELECT_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withLinkProperties:link.properties];
                        }
                        else
                        {
                            [link.iconView updateForDropDownWithInputText:fibVO.text withLinkProperties:link.properties];
                        }

                        if (fibVO.isSubmitted && [_user.role isEqualToString:@"LEARNER"])
                        {
                            [link.iconView removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
                            [link.iconView addTarget:self action:@selector(didTapOnSubmittedDropDown:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        if (fibVO) {
                            [self compareAndShowInstantFeedbackForDropDownLink:link andFibVO:fibVO isForTeacherReview:false];
                        }
                    }
                }
            }
        }
        
        finalLinksArray= [self checkInvisibleMultiLinkMarkup:finalLinksArray withPageNumber:number];
        if(finalLinksArray.count)
        {
            [_rendererView drawMarkups:finalLinksArray OnPageNo:number.integerValue];
        }
        if(fibArray.count)
        {
            [self drawFIB:fibArray OnPageNumber:number.integerValue];
        }
    }
}
#pragma mark DropDown
- (void)compareAndShowInstantFeedbackForDropDownLink:(KFLinkVO *)link andFibVO:(SDKFIBVO *)fibVO isForTeacherReview:(BOOL)isTeacher{
    UIColor *textColor = [UIColor lightGrayColor];
    BOOL isEnable;
    if (isTeacher) {
        isEnable = ![fibVO.review boolValue];
    } else {
        isEnable = fibVO.isSubmitted;
    }
    if(link.isInstantFeedback && isEnable)
   {
       if (![self isAnswerCorrect:link andUserEnteredText:fibVO.text])
       {
           [link.iconView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
           [link.iconView setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
           textColor = [UIColor colorWithHexString:@"#870000"];
       }else{
           [link.iconView setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
           [link.iconView setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
           textColor = [UIColor colorWithHexString:@"#006400"];
       }
   }
   else if(!link.isInstantFeedback && isEnable)
   {
       [link.iconView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
       [link.iconView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
   }
    
    if ([fibVO.answerStatus isEqualToString:@"correct"]) {
        [link.iconView setTitleColor:textColor forState:UIControlStateNormal];
        [link.iconView setTitleColor:textColor forState:UIControlStateHighlighted];
        link.iconView.backgroundColor = [UIColor colorWithHexString:@"#00FF00"];
    } else if ([fibVO.answerStatus isEqualToString:@"incorrect"]) {
        [link.iconView setTitleColor:textColor forState:UIControlStateNormal];
        [link.iconView setTitleColor:textColor forState:UIControlStateHighlighted];
        link.iconView.backgroundColor = [UIColor colorWithHexString:@"#ff4a54"];
    }
}
- (BOOL)isAnswerCorrect:(KFLinkVO *)link andUserEnteredText:(NSString *)userEnteredText
{
    BOOL isCorrectAnswer = NO;
    if(link.linkType == kLinkTypeDropDown && link.isCaseSenstive)
    {
        isCorrectAnswer = [userEnteredText isEqualToString:link.answer];
    }
    else
    {
        isCorrectAnswer = [userEnteredText caseInsensitiveCompare:link.answer] == NSOrderedSame;
    }
    return isCorrectAnswer;
}
-(void)didTapOnSubmittedDropDown:(MarkupView*)iconView
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if (activeMode == kPlayerActiveModeTeacherReview) {
            if (iconView.sdkFIBVO) {
                [_rendererView addReviewViewOnFib:iconView.sdkFIBVO];
            }
            return;
        }
        KFBookVO *book=(KFBookVO*)currentBook;
        KFPageVO *page=[book.pages objectForKey:[NSString stringWithFormat:@"%ld",(long)iconView.pageID]];
        KFLinkVO *link=[page.links objectForKey:[NSString stringWithFormat:@"%ld",(long)iconView.linkID]];
        
        if(link.isInstantFeedback && ![self isAnswerCorrect:link andUserEnteredText:iconView.titleLabel.text])
        {
            SDKFIBVO *fibVO = [_dbManager getFIBObjectWithLinkId:[NSNumber numberWithInteger:link.linkID] forUserId:[NSNumber numberWithInt:_user.userID.intValue]];
            [self didSelectSubmittedFIB:fibVO withLinkAnswer:link.answer withSourceView:iconView];
        }
    }
    
}
-(void)didTapOnDropDownLink:(KFLinkVO*)link
{
    if(activeMode == kPlayerActiveModeFIB)
    {
        [_rendererView.view endEditing:YES];
        activeMode = kPlayerActiveModeNone;
        return;
    }
    //[rendererView resetZoomScaleToDefault];
    NSArray *dropdownItems = [self getDropDownItemsArrayForPropertyDictionary:link.properties];
    if(dropdownItems != nil && dropdownItems.count > 0)
    {
        _linkDropDownController = nil;
        _linkDropDownController = [[LinkDropDownViewController alloc]initWithDropDownData: dropdownItems withDropDown:link.iconView];
        _linkDropDownController.delegate = self;
        
        if(isIpad())
        {
            _linkDropDownController.modalPresentationStyle = UIModalPresentationPopover;
            _linkDropDownController.preferredContentSize =  CGSizeMake(220, 220);
            UIPopoverPresentationController *popoverpresentationController = [_linkDropDownController popoverPresentationController];
            popoverpresentationController.backgroundColor = UIColor.blackColor;
            popoverpresentationController.delegate=self;
            popoverpresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popoverpresentationController.sourceView = link.iconView;
            popoverpresentationController.sourceRect = link.iconView.bounds;
            [self presentViewController:_linkDropDownController animated:NO completion:nil];
        }
        else
        {
            [self addChildViewController:_linkDropDownController];
            [self.view addSubview:_linkDropDownController.view];
        }
        
    }
    
}

- (NSArray *)getDropDownItemsArrayForPropertyDictionary:(NSString *)propertiesString
{
    NSString *pXMLString = @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
    CFStringRef eStr1 = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)propertiesString,nil, NSUTF8StringEncoding);
    NSString *propertiesStr = (NSString *)CFBridgingRelease(eStr1);
    propertiesStr = [[propertiesStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"] stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    pXMLString = [pXMLString stringByAppendingString:propertiesStr];
    NSData *pXMLData = [pXMLString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *pError = nil;
    NSDictionary *pDictionary = [HDTBXML dictionaryWithXMLData:pXMLData error:&pError];
    
    NSMutableArray *array = nil;
    if(!pError)
    {
        array = [[NSMutableArray alloc] init];
        NSDictionary *aDictionary = [pDictionary valueForKey:@"activity"];
        NSObject *itemObject = [aDictionary valueForKey:@"items"];
        
        if ([itemObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *iDictionary = (NSDictionary *)itemObject;
            NSObject *node = [iDictionary valueForKey:@"node"];
            
            [array addObject:[LocalizationHelper localizedStringWithKey:@"SELECT_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
            
            if ([node isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *tempDictionary = (NSDictionary *) node;
                
                [array addObject:[tempDictionary valueForKey:@"nodeName"]];
            }
            else if ([node isKindOfClass:[NSArray class]])
            {
                NSArray *dropDownItemsArray = (NSArray *) node;
                
                for (NSDictionary *item in dropDownItemsArray)
                {
                    [array addObject:[item valueForKey:@"nodeName"]];
                }
            }
        }
        else if ([itemObject isKindOfClass:[NSString class]])
        {
            NSString *iString = (NSString *)itemObject;
            NSArray *itemArray = [iString componentsSeparatedByString:@","];
            
            if (itemArray.count > 0)
            {
                [array addObject:[LocalizationHelper localizedStringWithKey:@"SELECT_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController ]];
                [array addObjectsFromArray:itemArray];
            }
        }
    }
    return array;
}
# pragma mark DropDown Delegates
-(void)didSelectActionToCloseDropDown
{
    if (_linkDropDownController)
    {
        if (isIpad())
        {
            [_linkDropDownController dismissViewControllerAnimated:NO completion:nil];
            _linkDropDownController = nil;
        }
        else
        {
            [_linkDropDownController removeFromParentViewController];
            [_linkDropDownController.view removeFromSuperview];
            _linkDropDownController = nil;
        }
    }
}

- (void)didSelectDropDownItemWithText:(NSString *)selectedText forDropDown:(UIButton *)dropDown
{
    if (selectedText)
    {
        MarkupView *dropDownMarkup = (MarkupView*)dropDown;
        
        KFBookVO *book=(KFBookVO*)currentBook;
        KFPageVO *page=[book.pages objectForKey:[NSString stringWithFormat:@"%ld",(long)dropDownMarkup.pageID]];
        KFLinkVO *link=[page.links objectForKey:[NSString stringWithFormat:@"%ld",(long)dropDownMarkup.linkID]];
        
        [link.iconView setTitle:selectedText forState:UIControlStateNormal];
        [link.iconView setTitle:selectedText forState:UIControlStateHighlighted];
        if(activeMode == kPlayerActiveModeTeacherReview)
        {
            NSArray* fibArray= [_teacherAnnotationController getFIBUGCForPageIdentifier:link.pageID];
            if(fibArray.count)
            {
                NSArray *filterArray = [fibArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"linkID = %@",[NSNumber numberWithInteger:link.linkID]]];
                
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"ugcID" ascending:NO];
                filterArray = [filterArray sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
                if(filterArray.count)
                {
                    SDKFIBVO *fibVO = filterArray.firstObject;
                    fibVO.text = selectedText;
                    fibVO.review = [NSNumber numberWithInt:1];
                    [_teacherAnnotationController updateFIBData:fibVO];
                }
            }
            
            [self drawTeacherReviewDropDownOnPageNumber:[NSNumber numberWithInteger:dropDownMarkup.pageID]];
            
        }else
        {
            if([selectedText isEqualToString:[LocalizationHelper localizedStringWithKey:@"SELECT_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]])
            {
                [self saveDropDownLink:link WithText:@""];
            }
            else
            {
                [self saveDropDownLink:link WithText:selectedText];
            }
        }
    }
    
}

-(void)saveDropDownLink:(KFLinkVO*)link WithText:(NSString*)selectedValue
{
    SDKFIBVO *fibVO =[_dbManager getFIBObjectWithLinkId:[NSNumber numberWithInteger:link.linkID] forUserId:[NSNumber numberWithInt:_user.userID.intValue]];
    
    if (fibVO == nil)
    {
        fibVO = [[SDKFIBVO alloc]init];
        fibVO.status = NEW;
        fibVO.createdDate = [NSDate date];
        fibVO.ugcID = @"-1";
        fibVO.localID = [[NSUUID UUID] UUIDString];
    }
    else
    {
        fibVO.status = UPDATE;
    }
    
    fibVO.modifiedDate = [NSDate date];
    fibVO.isSubmitted = NO;
    fibVO.review = [NSNumber numberWithInt:0];
    fibVO.isSynced = NO;
    fibVO.text = selectedValue;
    fibVO.linkID = [NSNumber numberWithInteger:link.linkID];
    fibVO.pageIdentifier = link.pageID;
    fibVO.displayNum = link.folioNumber;
    if (selectedValue.length == 0)
    {
        fibVO.status = DELETE;
    }
    [self didUpdateSDKFIBVO:fibVO];
}
-(CGRect)get220PercentScaleRectForLinkMarkups:(KFLinkVO*)link
{
    CGRect linkRect = link.boxTansformedRect;
    linkRect.size.width = linkRect.size.height = isIpad() ? UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?50:35 : UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?35:25;
    if(linkRect.size.width > link.boxTansformedRect.size.width || linkRect.size.height > link.boxTansformedRect.size.height)
    {
        linkRect.size.width = linkRect.size.height = link.boxTansformedRect.size.width > link.boxTansformedRect.size.height ? link.boxTansformedRect.size.height : link.boxTansformedRect.size.width;
    }
    return linkRect;
}
-(CGRect)getRectForLinkMarkups:(KFLinkVO*)link
{
    CGRect linkRect = link.boxTansformedRect;
    if(![link isInLine] && !([[link.iconURL lastPathComponent]isEqualToString:@"flexibleicon.png"]))
    {
        if(isIpad())
        {
            linkRect.size.width = linkRect.size.height = UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?50:35;
        }
        else
        {
            linkRect.size.width = linkRect.size.height = UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?35:25;
        }
    }
    
    return linkRect;
}
-(void)drawFIB:(NSArray*)fibArray OnPageNumber:(NSInteger)pageNumber
{
    [_rendererView drawFIBs:fibArray OnPageNo:pageNumber];
}

-(NSMutableArray*)checkInvisibleMultiLinkMarkup:(NSArray*)finalLinksArray withPageNumber:(NSString*)number
{
    KFBookVO *book=(KFBookVO*)currentBook;
    NSArray* allLinks=[book getLinksForForPagenumber:[NSNumber numberWithInteger:number.integerValue]];
    
    for (KFLinkVO *multiLink in finalLinksArray)
    {
        if(multiLink.linkType==kLinkTypeMultiLink)
        {
            BOOL isAllLinksInvisible=YES;
            for (KFLinkVO *link in allLinks)
            {
                if(([multiLink.iconView.xCordinate integerValue] == [link.xCoordinate integerValue]) && ([multiLink.iconView.yCordinate integerValue] == [link.yCoordinate integerValue]))
                {
                    if([link isVisible])
                    {
                        isAllLinksInvisible=NO;
                        break;
                    }
                    
                }
            }
            if(isAllLinksInvisible)
            {
                [multiLink.iconView setAsInvisibleMarkup];
            }
        }
    }
    return [finalLinksArray mutableCopy];
}

/**
 Returns the font string for individual markup type
 */
-(NSString*)getIconForLinkType:(KFLinkVO *)link
{
    NSString *iconString = nil;
    switch (link.linkType)
    {
        case kLinkTypeAudioSync:     iconString = ICON_AUDIO;
            break;

        case kLinkTypeAudio:         iconString = ICON_AUDIO;
            break;

        case kLinkTypeImage:         iconString = ICON_IMAGE1;
            break;

        case kLinkTypeYoutube:       iconString = ICON_VIDEO1;
            break;

        case kLinkTypeKaltura:       iconString = ICON_VIDEO1;
            break;

        case kLinkTypeVideo:         iconString = ICON_VIDEO1;
            break;

        case kLinkTypeWebLink:       iconString = ICON_WEBLINK;
            break;

        case kLinkTypeDocument:      iconString = ICON_ASSESSMENT;
            break;

        case kLinkTypeDictera:       iconString = HTMLWRAP_ICON;
            break;

        case kLinkTypeMultiLink:     iconString = MULTIFILE_ICON;
            break;

        case kLinkTypeInput:         iconString = ICON_FILL_IN_THE_BLANK_INPUT_TYPE;
            break;

        case kLinkTypeDropDown:      iconString = ICON_FILL_IN_THE_BLANK_DROP_DOWN;
            break;

        case kLinkTypeComments:      iconString = COMMENT_ICON;
            break;

        case kLinkTypePageLink:      iconString = ICON_JUMP_TO_SCREEN;
            break;

        case kLinkTypeWidget:        iconString = KITABOO_LOGO_ICON;
            break;

        case kLinkTypeSlideShow:     iconString = SLIDE_SHOW_ICON;
            break;

        case kLinkTypeGroupNotes:    iconString = MULTIFILE_ICON;
            break;

        case kLinkTypeSurvey:        iconString =  ICON_SURVEY;
            break;

        case kLinkTypeGlossary:      iconString =   ICON_GLOSSARY;
            break;

        case kLinkTypeJumpToBook:    iconString  = ICON_JUMP_TO_BOOK;
            break;

        case kLinkTypeImageZoom:     iconString = ICON_IMAGE_ZOOM;
            break;

        case kLinkTypeInstruction:   iconString = INFO_ICON;
            break;

        case kLinkTypeVimeoVideo:    iconString = ICON_VIDEO1;
            break;

        case kLinkTypeHtmlWrap:      iconString = HTMLWRAP_ICON;
            break;

        case kLinkTypeTracerMedia:    iconString = HTMLWRAP_ICON;
            break;
        default:
            break;
    }
    
    
    return iconString;
}
- (void)didTapOnMarkupHitArea:(MarkupHitAreaLabel *)markupHitAreaLabel
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *book=(KFBookVO*)currentBook;
        KFPageVO *page=[book.pages objectForKey:[NSString stringWithFormat:@"%ld",(long)markupHitAreaLabel.pageID]];
        KFLinkVO *link=[page.links objectForKey:[NSString stringWithFormat:@"%ld",(long)markupHitAreaLabel.linkID]];
        if(link)
        {
            [self actionForLink:link];
        }
        else
        {
            KFLinkVO *multiLink = [[KFLinkVO alloc]init];
            multiLink.xCoordinate=markupHitAreaLabel.iconView.xCordinate;
            multiLink.yCoordinate=markupHitAreaLabel.iconView.yCordinate;
            multiLink.linkType = kLinkTypeMultiLink;
            multiLink.pageID = [NSString stringWithFormat:@"%ld",(long)markupHitAreaLabel.pageID];
            multiLink.iconView=markupHitAreaLabel.iconView;
            [self actionForLink:multiLink];
        }
    }
}

-(void)didTapOnLink:(MarkupView*)sender
{
    if(activeMode == kPlayerActiveModeHighlight)
    {
        [self removeHighlightPopup];
    }
    [self stopInlineVideo];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *book=(KFBookVO*)currentBook;
        KFPageVO *page=[book.pages objectForKey:[NSString stringWithFormat:@"%ld",(long)sender.pageID]];
        KFLinkVO *link=[page.links objectForKey:[NSString stringWithFormat:@"%ld",(long)sender.linkID]];
        if(link)
        {
            [self actionForLink:link];
        }
        else
        {
            KFLinkVO *multiLink = [[KFLinkVO alloc]init];
            multiLink.xCoordinate=sender.xCordinate;
            multiLink.yCoordinate=sender.yCordinate;
            multiLink.linkType = kLinkTypeMultiLink;
            multiLink.pageID = [NSString stringWithFormat:@"%ld",(long)sender.pageID];
            multiLink.iconView=sender;
            [self actionForLink:multiLink];
        }
    }
}

-(void)actionForResource:(EPUBResource*)resource {
    EPUBBookVO *epub = (EPUBBookVO *)currentBook;
    NSString *assetPath = [epub.rootPath stringByAppendingPathComponent:resource.assetPath];
    switch (resource.epubLinkType) {
        case kEPUBLinkTypeWebLink:
            [self webPlayer:[NSURL URLWithString:resource.assetPath]];
            break;
        case kEPUBLinkTypeDocument:
            [self documentPlayer:[NSURL URLWithString:assetPath]];
            break;
        case kEPUBLinkTypePageLink:
            [self navigateTopage:resource.assetPath];
            break;
        case kEPUBLinkTypeVideo:
            [self videoPlayerWithVideoPath:assetPath withResource:resource];
            break;
        case kEPUBLinkTypeAudio:
            [self AudioPlayerWithURL:assetPath WithPlayerUIEnable:YES withIsEncrypted:NO playInBackground:NO];
            break;
        case kEPUBLinkTypeImage:
            [self ImageControllerWithImagePath:assetPath isEncrypted:NO];
            break;
        default:
            break;
    }
}

-(void)actionForLink:(KFLinkVO*)linkVO
{
    
    if (_audioPlayer)
        [self resetAudioPlayer];
    
    if(_multiLinkController)
    {
        [self removeMultiLinkPopOver];
    }
    if(instructionPopOverContentVC){
        [self removeInstructionMarkupPopOver];
    }
    if (linkVO.isExternal) {
        if(![[KitabooNetworkManager getInstance] isInternetAvailable]) {
            [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
            return;
        }
    }
    isExternalResource = linkVO.isExternal;
        
        if(linkVO.toolTip)
        {
            HDKitabooAnalyticsMetaData *analyticsMetadata = [[HDKitabooAnalyticsMetaData alloc] initWithResourceTracking:[NSDictionary dictionaryWithObjectsAndKeys:linkVO.folioNumber,@"pageID",[NSString stringWithFormat:@"%ld",(long)linkVO.linkID],@"id",linkVO.toolTip,@"title",@"Online",@"type",linkVO.type,@"category", nil] uniqueId:[NSString stringWithFormat:@"%ld",(long)linkVO.linkID]];
            [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeLinkOpen metadata:analyticsMetadata];
            [self createAndSaveReaderAnalyticsSessionWithCalledUsingTimer:false];
        }
        
        [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
        switch (linkVO.linkType)
        {
            case kLinkTypeWidget:
            case kLinkTypeHtmlWrap:
            case kLinkTypeWebLink:
            case kLinkTypeDictera:
                 activeMode=kPlayerActiveModeMarkupPlayer;
                if ([linkVO.url containsString:@"http"])
                {
                    if ([[KitabooNetworkManager getInstance] isInternetAvailable])
                    {
                        [self webPlayer:[NSURL URLWithString:linkVO.url] withLinkVO:linkVO];
                    }
                    else
                    {
                        activeMode = kPlayerActiveModeNone;
                        [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                    }
                }
                else{
                    [self webPlayer:[NSURL URLWithString:[_bookPath stringByAppendingPathComponent:linkVO.url]] withLinkVO:linkVO];
                }
                break;
            case kLinkTypeDocument:
                 activeMode=kPlayerActiveModeMarkupPlayer;
                if (isExternalResource) {
                    [self documentPlayer:[NSURL URLWithString:linkVO.url]];
                } else {
                    [self documentPlayer:[NSURL URLWithString:[_bookPath stringByAppendingPathComponent:linkVO.url]]];
                }
                break;
            case kLinkTypePageLink:
                {
                    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventGotoPageParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                    if([currentBook isKindOfClass:[EPUBBookVO class]])
                    {
                      [_rendererView navigateToPageNumber:linkVO.url];
                    }
                    else
                    {
                        [_rendererView navigateToPageNumber:[NSString stringWithFormat:@"%ld",(long)[self getPageIDForDisplayNumber:linkVO.url]]];
                    }
                }
                break;
                
            case kLinkTypeVideo:
                activeMode = kPlayerActiveModeMarkupPlayer;
                if (isExternalResource) {
                    [self videoPlayer:linkVO.url withLinkVO:linkVO];
                } else {
                    [self videoPlayer:[_bookPath stringByAppendingPathComponent:linkVO.url] withLinkVO:linkVO];
                }
                break;
                
            case kLinkTypeImageZoom:
            case kLinkTypeImage:
            case kLinkTypeSlideShow:
                {
                    [self loadImageMarkup:linkVO];
                }
                break;
                
            case kLinkTypeAudioSync:
            case kLinkTypeAudio:
            {
                if(linkVO.linkType == kLinkTypeAudioSync)
                {
                    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventAudioSyncParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                }
                else if(linkVO.linkType == kLinkTypeAudio)
                {
                    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventAudioParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                }

                [_rendererView resetZoomScaleToDefault];
                if(linkVO.audioSync && linkVO.audioSync.count)
                {
                    [self stopAudioSyncIfAny];
                    activeMode=kPlayerActiveModeMarkupPlayer;
                    readAloudMode = ReadAloudModeLetMeRead;
                    KFBookVO *book=(KFBookVO*)currentBook;
                    _audioSyncController=[[AudioSyncController alloc]initWithLinks:@[linkVO]  WithDelegate:self WithKitabooBook:book WithPlayerUIEnable:YES];
                    [_rendererView.view setUserInteractionEnabled:NO];
                    [_audioSyncController start];
                    [self addPlayerBottomBarForAudioSync];
                    [self changePlayButtonState];
                }
                else
                {
                    [self AudioPlayerWithURL:linkVO.url WithPlayerUIEnable:YES withIsEncrypted:YES playInBackground:linkVO.isPlaybackground];
                }
            }
                break;
            case kLinkTypeComments:
                [self alertForNoMarkUp];
                break;
            case kLinkTypeMultiLink:
                [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventMultilinkMarkupParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                [self loadMultiLinkMarkup:linkVO];
                break;
            case kLinkTypeDropDown:
                [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventDropDownParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                 [self didTapOnDropDownLink:linkVO];
                break;
            case kLinkTypeGroupNotes:
                [self alertForNoMarkUp];
                break;
            case kLinkTypeKaltura:
            {
                if ([[KitabooNetworkManager getInstance] isInternetAvailable])
                {
                    [self addPreLoaderView];
                    [self loadKalturaVideoPlayer:linkVO];
                }
                else
                {
                    [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                }
            }
                break;
            case kLinkTypeYoutube:
            {
                if ([[KitabooNetworkManager getInstance] isInternetAvailable])
                {
                    [self loadYoutubeMarkup:linkVO];
                }
                else
                {
                    [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                }
            }
                break;
            case kLinkTypeSurvey:
                if ([[KitabooNetworkManager getInstance] isInternetAvailable])
                {
                    [self webPlayer:[NSURL URLWithString:linkVO.url] withLinkVO:linkVO];
                }
                else
                {
                   [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                }
               break;
            case kLinkTypeJumpToBook:
                [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventJumpToBookParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                [self loadJumpToBookMarkUp:linkVO];
                break;
            case kLinkTypeGlossary:
                [self loadGlossaryMarkUp:linkVO];
                break;
            case kLinkTypeInstruction:
                [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventInstructionMarkupParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
                [self loadInstructionMarkup:linkVO];
                break;
            case kLinkTypeVimeoVideo:
                if ([[KitabooNetworkManager getInstance] isInternetAvailable])
                {
                   //[self loadVimeoPlayer:linkVO];
                }
                else
                {
                   [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                }
                break;
            case kLinkTypeTracerMedia:
                [self alertForNoMarkUp];
                break;
            default:
                break;
        }
   
}

-(void)actionForLinkWithLinkVO:(KFLinkVO *)linkVO
{
    [self actionForLink:linkVO];
}
- (void)alertForNoMarkUp{
    [self showAlertControllerWithMsg:NSLocalizedStringFromTableInBundle(@"MARKUP_NOT_SUPPORTED",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) withTitle:NSLocalizedStringFromTableInBundle(@"ERROR_ALERT_TITLE",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)];
}

-(void)loadJumpToBookMarkUp:(KFLinkVO *)link
{
    NSString *bookId;
    NSString *pageId;
    NSArray *propertyArray = [link.properties componentsSeparatedByString:@";"];
    for (NSString *property in propertyArray)
    {
        if ([property hasPrefix:@"id"] || [property hasPrefix:@"bookId"])
        {
            NSArray *tempArray = [property componentsSeparatedByString:@":"];
            bookId = tempArray[1];
        }
        if ([property hasPrefix:@"folio"])
        {
            NSArray *tempArray = [property componentsSeparatedByString:@":"];
            pageId = tempArray[1];
        }
    }
    if([_delegate isBookDownloadedForBookID:bookId])
    {
        [self didTapOnBackButton:nil ];
        [_delegate jumpToBookReaderForBookID:bookId withBookId:pageId];
    }
    else
    {
        NSURL *targetURL = nil;
        NSString *targetURLString = link.url;
        NSString *urlStringCopy = targetURLString;
        targetURLString = [self createTargetURLForWebPlayer:urlStringCopy];
        targetURLString  = [targetURLString stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        
        NSRange rOriginal = [targetURLString rangeOfString:@"%23"];
        if (NSNotFound != rOriginal.location) {
            targetURLString = [targetURLString stringByReplacingCharactersInRange:rOriginal withString:@"#"];
        }
        targetURL = [NSURL URLWithString:targetURLString];
        if ([link.url containsString:@"http"])
        {
            if([[KitabooNetworkManager getInstance] isInternetAvailable])
            {
                [self loadWebPlayerForStandardActivityWithURL:targetURL];
            }
            else
            {
                [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
            }
        }
    }
}

-(NSString *)createTargetURLForWebPlayer:(NSString *)targetURL
{
    NSString *targetNewURL = targetURL;
    
    if ([targetNewURL rangeOfString:@"DesktopReader"].location != NSNotFound)
    {
        targetNewURL = [targetNewURL stringByReplacingOccurrencesOfString:@"DesktopReader" withString:@"MobileReader"];
    }
    
    //UserVO *userVo = (UserVO *)[[UserController getInstance] getUser];
    
    NSString *userInfoParameters = [NSString stringWithFormat:@"&sharetoken=%@&cloudUserId=%@&cloudUserName=%@&cloudFirstName=%@&cloudLastName=%@&cloudRoleName=%@&cloudProfilePic=%@",[self encodeStringWithString:_user.userToken],_user.userID,[self encodeStringWithString:_user.userName],[self encodeStringWithString:_user.firstName],[self encodeStringWithString:_user.lastName],[self encodeStringWithString:_user.role],[self encodeStringWithString:_user.profilePicURL]];
    
    targetNewURL = [targetNewURL stringByAppendingString:userInfoParameters];
    
    return targetNewURL;
}
- (NSString *)encodeStringWithString:(NSString *)string
{
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
    NSString *escapedString = (__bridge NSString *)(newString);
    return escapedString;
}
                                                                                                                                                                                        
-(void)loadGlossaryMarkUp:(KFLinkVO *)link
{
    if (glossaryViewController != nil) {
        [self removeGlossaryController];
    }
    if ([currentBook isKindOfClass:[KFBookVO class]]) {
        activeMode = kPlayerActiveModeGlossary;
        KFBookVO *bookVo = (KFBookVO *)currentBook;
        KFGlossaryVO *glossary = [bookVo.glossary valueForKey:link.url];
        
        glossaryViewController = [[GlossaryViewController alloc] init];
        [glossaryViewController setColorsForGlossaryViewWithIconColor:hdThemeVO.glossary_icon_color iconBorderColor:hdThemeVO.glossary_icon_border_color alphabetTextColor:hdThemeVO.glossary_alphabet_label_color keyWordTextColor:hdThemeVO.glossary_keyword_label_color descriptionTextColor:hdThemeVO.glossary_description_color];
        [glossaryViewController setGlossaryItem:glossary];
        glossaryViewController.view.backgroundColor = hdThemeVO.glossary_popup_background_color;
        glossaryViewController.delegate = self;
        
        if (isIPAD)
        {
            glossaryViewController.modalPresentationStyle = UIModalPresentationPopover;
            glossaryViewController.preferredContentSize = CGSizeMake(300, 300);
            UIPopoverPresentationController *popoverpresentationController = [glossaryViewController popoverPresentationController];
            popoverpresentationController.backgroundColor = UIColor.clearColor;
            popoverpresentationController.delegate=self;
            popoverpresentationController.sourceView = link.iconView;
            popoverpresentationController.sourceRect = link.iconView.bounds;
            
            [HDPopOverBackgroundView setArrowColor:[UIColor clearColor]];
            popoverpresentationController.popoverBackgroundViewClass = [HDPopOverBackgroundView class];
            
            [self presentViewController:glossaryViewController animated:NO completion:nil];
        }
        else
        {
            CGFloat xValue = link.iconView.frame.origin.x;
            CGFloat yValue = link.iconView.frame.origin.y + link.iconView.frame.size.height + POPVIEW_MARGIN;
            CGFloat view_width_height = 250;
            
            if (self.view.frame.size.width < (xValue + view_width_height))
            {
                CGFloat diff = self.view.frame.size.width - (link.iconView.frame.origin.x + view_width_height) - 10;
                xValue = xValue + diff;
            }
            if (self.view.frame.size.height < (yValue + view_width_height))
            {
                CGFloat diff = self.view.frame.size.height - (link.iconView.frame.origin.y + view_width_height) - 20;
                yValue = yValue + diff;
                
                CGFloat availableHeight = self.view.frame.size.height - link.iconView.frame.origin.y;
                CGFloat upperHeight = self.view.frame.size.height - availableHeight;
                
                if (upperHeight - view_width_height> 0)
                {
                    yValue = link.iconView.frame.origin.y - view_width_height ;
                }
            }
            
            glossaryViewController.view.frame = CGRectMake(xValue, yValue, view_width_height, view_width_height);
            
            glossaryViewController.view.layer.shadowRadius  = 2.0f;
            glossaryViewController.view.layer.shadowColor   = [UIColor blackColor].CGColor;
            glossaryViewController.view.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
            glossaryViewController.view.layer.shadowOpacity = 1.2f;
            glossaryViewController.view.layer.masksToBounds = NO;
            
            [self addChildViewController:glossaryViewController];
            [self.view addSubview:glossaryViewController.view];
        }
    }
}
-(void)removeGlossaryController
{
    if (isIPAD) {
        [glossaryViewController dismissViewControllerAnimated:NO completion:nil];
        glossaryViewController=nil;
    }
    else
    {
        [glossaryViewController removeFromParentViewController];
        [glossaryViewController.view removeFromSuperview];
        glossaryViewController=nil;
    }
    activeMode = kPlayerActiveModeNone;
}

#pragma mark Glossary Delegates


- (void)didSelectGlossaryItemWithType:(enum GlossaryResourceType)selectedType withPath:(NSString *)resorcePath
{
    [self removeGlossaryController];
    switch (selectedType) {
        case GlossaryResourceTypeKGlossaryResourceTypeAudio:
        {
            [self AudioPlayerWithURL:resorcePath WithPlayerUIEnable:YES withIsEncrypted:YES playInBackground:NO];
        }
        break;
            
            
        case GlossaryResourceTypeKGlossaryResourceTypeVideo:
        {
            KFBookVO *book=(KFBookVO*)currentBook;
            [self VideoPlayerWithVideoPath:[book.path stringByAppendingString:resorcePath] withType:kVideoTypeLocal withDecrytionKey:[book.ISBN stringByAppendingString:[resorcePath lastPathComponent]]];
        }
        break;
            
        case GlossaryResourceTypeKGlossaryResourceTypeImage:
        {
            [self ImageControllerWithImagePath:resorcePath withImageProperties:@"" withLinkType:kLinkTypeImage isEncrypted:YES];

        }
        break;
            
        case GlossaryResourceTypeKGlossaryResourceTypeURL:
        {
            [self webPlayer:[NSURL URLWithString:resorcePath] withLinkVO:nil];
        }
        break;
    }
    
}

#pragma mark FIB Delegates

-(void)didUpdateSDKFIBVO:(SDKFIBVO *)sdkFIBVO
{
    if(activeMode!= kPlayerActiveModeTeacherReview)
    {
        if(sdkFIBVO.status == DELETE)
        {
            [_dbManager deleteFIB:sdkFIBVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
            [self reloadFIB];
        }
        else if(sdkFIBVO.status == UPDATE)
        {
            [_dbManager updateFIB:sdkFIBVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        }
        else
        {
            [_dbManager saveFIB:sdkFIBVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        }
    }
    else
    {
        [_teacherAnnotationController updateFIBData:sdkFIBVO];
    }
    [self updateClearAllFIBsButtonStatus];
}
- (void)fibDidBeginEditing:(HDFIB *)hdFIBVO
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventFIBParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    if(activeMode == kPlayerActiveModeBookmark)
    {
        [self removeBookmarkVC];
    }
    if(activeMode != kPlayerActiveModeTeacherReview)
    {
        [_rendererView resetZoomScaleToDefault];
        [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
        activeMode = kPlayerActiveModeFIB;
    }
    [self showMathKeyboardForFIB:hdFIBVO];
}

-(void)keyboardDidShowForFIB:(HDFIB *)hdFIBView withKeyboardFrame:(CGRect)keyboardRect {
    if (!fibKeyBoardPresent) {
        fibKeyBoardPresent = YES;
        float overlapHeight = 0;
        if(activeMode == kPlayerActiveModeFIB || activeMode == kPlayerActiveModeTeacherReview) {
            keyboardRect = [_rendererView.view convertRect:keyboardRect toView:nil];
            CGSize keyboardSize = keyboardRect.size;
            
            _rendererView.view.frame =
            CGRectMake(CGRectGetMinX(_rendererView.view.frame), 0,  CGRectGetWidth(_rendererView.view.frame), CGRectGetHeight(_rendererView.view.frame));
            
            CGRect referanceRect = CGRectMake(0, CGRectGetHeight(_rendererView.view.frame) - (keyboardSize.height), CGRectGetWidth(_rendererView.view.frame), keyboardSize.height);
            
            if (CGRectContainsRect(referanceRect, hdFIBView.frame) || CGRectGetMinY(referanceRect) <= CGRectGetMaxY(hdFIBView.frame)) {
                overlapHeight =  (hdFIBView.frame.origin.y + hdFIBView.frame.size.height) - referanceRect.origin.y + 30;
                
                [UIView animateWithDuration:0.3 animations:^{
                    self->_rendererView.view.frame = CGRectMake(CGRectGetMinX(self->_rendererView.view.frame), CGRectGetMinY(self->_rendererView.view.frame) - overlapHeight, CGRectGetWidth(self->_rendererView.view.frame), CGRectGetHeight(self->_rendererView.view.frame));
                } completion:^(BOOL finished) {
                }];
            }
        }
        _hdFIB = hdFIBView;
        if ([self isMathKeyboardEnabled:hdFIBView]) {
            [self addEquationEditorButton:keyboardRect WithOffset:overlapHeight];
        }
    }
}
- (void)keyboardDidHideForFIB:(HDFIB *)hdFIBView withKeyboardFrame:(CGRect)keyboardRect
{
    [self removeEquationEditorButton];
}
- (void)fibDidEndEditing:(HDFIB *)hdFIBVO
{
    if(activeMode == kPlayerActiveModeFIB){
        activeMode = kPlayerActiveModeNone;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self->_rendererView.view.frame =
        CGRectMake(CGRectGetMinX(self->_rendererView.view.frame),
                   0,
                   CGRectGetWidth(self->_rendererView.view.frame),
                   CGRectGetHeight(self->_rendererView.view.frame));
        
    } completion:^(BOOL finished) {
        
        [self->_rendererView.view endEditing:YES];
    }];
    [self removeEquationEditorButton];
    fibKeyBoardPresent = NO;
}
- (void)didSelectSubmittedEquation:(SDKFIBVO *)fibVO withLinkAnswer:(NSString *)linkAnswer withSourceView:(FIBMathEquationView *)sourceView {
    [self didSelectSubmittedFIB:fibVO withLinkAnswer:linkAnswer withSourceView:sourceView];
}
- (void)showCorrectAnswerPopup:(NSString *)linkAnswer sourceView:(UIView *)sourceView {
    if(isIpad())
    {
        fibAnswerViewController =nil;
        fibAnswerViewController = [[UIViewController alloc]init];
        UILabel *fibAnswerLabel = [[UILabel alloc]init];
        fibAnswerLabel.numberOfLines = 0;
        fibAnswerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        fibAnswerLabel.font =[UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
        [fibAnswerLabel sizeToFit];
        [fibAnswerViewController.view addSubview:fibAnswerLabel];
        fibAnswerLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [fibAnswerLabel.centerXAnchor constraintEqualToAnchor:fibAnswerViewController.view.centerXAnchor constant:0].active = YES;
        [fibAnswerLabel.centerYAnchor constraintEqualToAnchor:fibAnswerViewController.view.centerYAnchor constant:-5].active = YES;
        [fibAnswerLabel.leadingAnchor constraintEqualToAnchor:fibAnswerViewController.view.leadingAnchor constant:0].active = YES;
        
        fibAnswerLabel.textAlignment = NSTextAlignmentCenter;
        if(linkAnswer)
        {
            NSString *visibleAnswer = [linkAnswer stringByReplacingOccurrencesOfString:@"##" withString:@" | "];
            NSString *incorrectAnswerText = [LocalizationHelper localizedStringWithKey:@"INCORRECT_ANSWER_TEXT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            NSString *msgStr = [NSString stringWithFormat:@"%@%@", incorrectAnswerText, visibleAnswer];
            [fibAnswerLabel setText:msgStr];
        }
        else
        {
            NSString *msgStr = [NSString stringWithFormat:@"%@ ", [LocalizationHelper localizedStringWithKey:@"INCORRECT_ANSWER_TEXT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
            [fibAnswerLabel setText:msgStr];
        }
        
        fibAnswerViewController.modalPresentationStyle = UIModalPresentationPopover;
        fibAnswerViewController.preferredContentSize =  CGSizeMake(250, 90);
        UIPopoverPresentationController *popoverpresentationController = [fibAnswerViewController popoverPresentationController];
        popoverpresentationController.delegate=self;
        popoverpresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popoverpresentationController.sourceView =sourceView;
        popoverpresentationController.sourceRect = sourceView.bounds;
        [self presentViewController:fibAnswerViewController animated:NO completion:nil];
    }
    else
    {
        fibAnswerViewController =nil;
        fibAnswerViewController = [[UIViewController alloc]init];
        fibAnswerViewController.view.frame = self.view.bounds;
        fibAnswerViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFIBPopOver)];
        tapGesture.delegate=self;
        [fibAnswerViewController.view addGestureRecognizer:tapGesture];
        
        [self addChildViewController:fibAnswerViewController];
        [self.view addSubview:fibAnswerViewController.view];
        
        UILabel *fibAnswerLabel = [[UILabel alloc]init];
        fibAnswerLabel.backgroundColor =[UIColor whiteColor];
        fibAnswerLabel.numberOfLines = 0;
        fibAnswerLabel.font =[UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
        [fibAnswerViewController.view addSubview:fibAnswerLabel];
        fibAnswerLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        fibAnswerLabel.textAlignment = NSTextAlignmentCenter;
        if(linkAnswer)
        {
            NSString *visibleAnswer = [linkAnswer stringByReplacingOccurrencesOfString:@"##" withString:@" | "];
            NSString *incorrectAnswerText = [LocalizationHelper localizedStringWithKey:@"INCORRECT_ANSWER_TEXT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            NSString *msgStr = [NSString stringWithFormat:@"%@%@", incorrectAnswerText, visibleAnswer];
            [fibAnswerLabel setText:msgStr];
        }
        else
        {
            NSString *msgStr = [NSString stringWithFormat:@"%@ ", [LocalizationHelper localizedStringWithKey:@"INCORRECT_ANSWER_TEXT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
            [fibAnswerLabel setText:msgStr];
        }

        [fibAnswerLabel.centerXAnchor constraintEqualToAnchor:fibAnswerViewController.view.centerXAnchor constant:0].active = YES;
        [fibAnswerLabel.centerYAnchor constraintEqualToAnchor:fibAnswerViewController.view.centerYAnchor constant:0].active = YES;
        [fibAnswerLabel.widthAnchor constraintEqualToConstant:250].active = YES;
        [fibAnswerLabel.heightAnchor constraintEqualToConstant:90].active = YES;
        
    }
}

-(void)didSelectSubmittedFIB:(SDKFIBVO *)sdkFIBVO withLinkAnswer:(NSString *)linkAnswer withSourceView:(UIView *)sourceView
{
    if (activeMode == kPlayerActiveModeTeacherReview) {
        if (sdkFIBVO) {
            [_rendererView addReviewViewOnFib:sdkFIBVO];
        }
        return;
    }
    if(activeMode == kPlayerActiveModeFIB)
    {
        [_rendererView.view endEditing:YES];
        activeMode = kPlayerActiveModeNone;
        return;
    }
    if (activeMode != kPlayerActiveModeTeacherReview) {
        activeMode = kPlayerActiveModeFIB;
    }
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    [self showCorrectAnswerPopup:linkAnswer sourceView:sourceView];
}

-(void)removeFIBPopOver
{
    if (activeMode != kPlayerActiveModeTeacherReview) {
        activeMode = kPlayerActiveModeNone;
    }
    if (isIpad())
    {
        [fibAnswerViewController dismissViewControllerAnimated:NO completion:nil];
        fibAnswerViewController = nil;
    }
    else
    {
        [fibAnswerViewController removeFromParentViewController];
        [fibAnswerViewController.view removeFromSuperview];
        fibAnswerViewController=nil;
    }
}

-(void)reloadFIB
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray *activePages = [self getActivePageIDs];
        for (NSString *page in activePages)
        {
            NSInteger number = [page integerValue];
            KFBookVO *book=(KFBookVO*)currentBook;
            NSArray* links=[book getLinksForForPagenumber:[NSNumber numberWithInteger:number]];
            NSMutableArray *fibArray = [[NSMutableArray alloc]init];
            for (KFLinkVO *link in links)
            {
                if(link.linkType == kLinkTypeInput)
                {
                    SDKFIBVO *fibVO =[_dbManager getFIBObjectWithLinkId:[NSNumber numberWithInteger:link.linkID] forUserId:[NSNumber numberWithInt:_user.userID.intValue]];
                    
                    HDFIB *_fib = [[HDFIB alloc]initWithLinkVO:link withFIBVO:fibVO isTeacher:![_user.role isEqualToString:@"LEARNER"]];
                    _fib.delegate=self;
                    _fib.isDefaultKeyboardDisabled = [self isDefaultKeyboardDisabled:_fib];
                    [fibArray addObject:_fib];
                    if(fibVO.isEquation && [self isMathKeyboardEnabled:_fib])
                    {
                        FIBMathEquationView *fibMathEquationView = [[FIBMathEquationView alloc]initWithLink:_fib.linkVo fibVO:fibVO frame:_fib.frame];
                        [self setColorToMathKeyboard:fibMathEquationView withFIBVO:fibVO withFIB:_fib];
                        fibMathEquationView.delegate = self;
                        [fibArray addObject:fibMathEquationView];
                    }
                }
            }
            if(fibArray.count)
            {
                [self drawFIB:fibArray OnPageNumber:number];
            }
        }
    }
}

#pragma VimeoPlayer
//-(void)loadVimeoPlayer:(KFLinkVO*)linkVO
//{
//    [self addPreLoaderView];
//    [KitabooVimeoExtractor fetchVideoURLFromURL:linkVO.url quality:YTVimeoVideoQualityHigh
//                     completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality)
//    {
//         if (error)
//         {
//             UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"ERROR" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
//             UIAlertAction *okAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK"] style:UIAlertActionStyleDefault handler:nil];
//             [alert addAction:okAction];
//             [self presentViewController:alert animated:YES completion:nil];
//
//             [self removePreLoaderView];
//         }
//         else if (videoURL)
//         {
//             KFBookVO *book=(KFBookVO*)currentBook;
//             videoPlayer = [[KitabooVideoPlayer alloc] initWithVideoPath:[videoURL absoluteString] withBookVO:book withLinkVO:linkVO];
//             videoPlayer.delegate = self;
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self removePreLoaderView];
//                 if (linkVO.isInLine)
//                 {
//                     activeMode = kPlayerActiveModeMarkupPlayerInLineVideo;
//                     [_rendererView addInLineVideo:[videoPlayer getInlineVideoPlayer] atRect:linkVO.boxTansformedRect onPageNO:linkVO.pageID.integerValue];
//                     [videoPlayer playVideo];
//                 }
//                 else
//                 {
//                     videoPlayer.view.frame = self.view.bounds;
//                     [self addChildViewController:videoPlayer];
//                     [self.view addSubview:videoPlayer.view];
//                     [videoPlayer playVideo];
//
//                 }
//            });
//        }
//    }];
//
//}

#pragma MultiLinkMarkup
/* gets All links of current Page Number and from that all links picks selected MultiLink relevant Links.and pass that relevant links array to MultiLink controller.*/

-(void)loadMultiLinkMarkup:(KFLinkVO*)linkVo
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSMutableArray *multilinksArray = [self getLinksArrayForMultiLink:linkVo];
        if(multilinksArray.count)
        {
            if(_multiLinkController)
            {
                [self removeMultiLinkPopOver];
            }
            _multiLinkController = [[MultiLinkController alloc] initWithFrame:CGRectMake(linkVo.xCoordinate.floatValue, linkVo.yCoordinate.floatValue, (linkVo.iconView.frame.size.width*4)+30,(multilinksArray.count*linkVo.iconView.frame.size.height)) WithMultiLinkArray:multilinksArray];
            _multiLinkController.delegate=self;
             [_rendererView addMultiLinkController:_multiLinkController atSourceView:linkVo.iconView onPageNO:[linkVo.pageID intValue]];
            if(!isIpad())
                activeMode=kPlayerActiveModeMarkupMutilink;
        }
    }
}
-(NSMutableArray*)getLinksArrayForMultiLink:(KFLinkVO*)linkVO
{
    NSMutableArray *multilinksArray = [[NSMutableArray alloc]init];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *book=(KFBookVO*)currentBook;
        NSArray* links=[book getLinksForForPagenumber:[NSNumber numberWithInteger:linkVO.pageID.integerValue]];
        for (KFLinkVO *link in links)
        {
            if(link.isMultiLinkMember)
            {
                if(([linkVO.xCoordinate integerValue] == [link.xCoordinate integerValue]) && ([linkVO.yCoordinate integerValue] == [link.yCoordinate integerValue]))
                {
                    [multilinksArray addObject:link];
                }
            }
        }
    }
    return multilinksArray;
}
/* delegate method of MultiLink Controller.It remove multiLinkPopup and call didTapOnLink method for selected Link.*/
-(void)didSelectLinkVo:(KFLinkVO *)linkVo
{
    [self removeMultiLinkPopOver];
    [self didTapOnLink:linkVo.iconView];
}
-(void)loadImageMarkup:(KFLinkVO*)linkVO
{
    if(linkVO.linkType == kLinkTypeImage)
    {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventImageParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    }
    else if(linkVO.linkType == kLinkTypeSlideShow)
    {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventImageSlideShowParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    }
    else if(linkVO.linkType == kLinkTypeImageZoom)
    {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventImageMagnificationParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    }
    [self ImageControllerWithImagePath:linkVO.url withImageProperties:linkVO.properties withLinkType:linkVO.linkType isEncrypted:YES];
}

-(NSMutableArray *)getImageURLsForImageMarkup:(NSArray*)arrayOfImagesPath
{
        KFBookVO *book=(KFBookVO *)currentBook;
        NSString *bookPath=book.path;
        NSMutableArray *slideShowImagesPath = [[NSMutableArray alloc] init];
        for (NSString *imageUrl in arrayOfImagesPath)
        {
            NSString *imagePath = [bookPath stringByAppendingPathComponent:imageUrl];
            if (isExternalResource) {
                [slideShowImagesPath addObject:imageUrl];
            } else{
                [slideShowImagesPath addObject:imagePath];
            }
        }
    return slideShowImagesPath;
}

#pragma AudioPlayerDelegates
/*Delegate Method of Audio Player. remove Audio Player View*/
-(void)audioPlayerFinishPlaying
{
    if (activeMode == kPlayerActiveModeMarkupPlayerAudio)
        activeMode = kPlayerActiveModeNone;
    backgroundActiveMode = kPlayerActiveModeNone;
    _audioPlayer.delegate=nil;
    [_playerView removeFromSuperview];
    _playerView = nil;
    _audioPlayer=nil;
    
    [_rendererView.view setUserInteractionEnabled:YES];
}
-(void)audioPlayerDidStart
{
    
}
-(void)audioPlayerDidStopped
{
    
}
- (void)remoteAudioDidLoad {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(_audioPlayer) {
            [self startAudio:_audioPlayer];
        }
        [self removePreLoaderView];
    });
}

- (void)remoteAudioLoadingDidFailed:(NSError *)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removePreLoaderView];
        [_rendererView.view setUserInteractionEnabled:YES];
        if(_audioPlayer) {
            if (error.code == -1009) {
                if (![[KitabooNetworkManager getInstance] isInternetAvailable]) {
                    [self showAlertForExternalResourceLoadingFailedWithTitle:@"FAILED_ALERT_TITLE" WithMessage:@"INTERNET_UNAVAILABLE_MESSAGE"];
                }
            }
            else {
                [self showAlertForExternalResourceLoadingFailedWithTitle:@"ERROR_ALERT_TITLE" WithMessage:@"LOADING_FAILED"];
            }
        }
    });
}
- (void)showAlertForExternalResourceLoadingFailedWithTitle:(NSString*)title WithMessage:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:title]
                                                                   message:[LocalizationHelper localizedStringWithKey:message]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* retryAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"RETRY"] style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
        if (![[KitabooNetworkManager getInstance] isInternetAvailable]) {
            [self showAlertForExternalResourceLoadingFailedWithTitle:@"FAILED_ALERT_TITLE" WithMessage:@"INTERNET_UNAVAILABLE_MESSAGE"];
        }
        else {
            if(_kitabooImageController){
                [_kitabooImageController retryImageLoading];
            }
            if(_audioPlayer){
                [self addPreLoaderView];
                [_audioPlayer retryAudioLoading];
            }
        }
    }];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK_BUTTON"] style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:retryAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:NO completion:nil];
}

-(NSMutableArray *)getImagePropertiesForImageMarkup:(NSArray *)properties
{
    NSMutableDictionary *captionDictionary=[[NSMutableDictionary alloc]init];
    NSMutableArray *imageValues=[[NSMutableArray alloc]init];
    for (NSString *property in properties)
    {
        NSArray *propertykeyValue=[property componentsSeparatedByString:@":"];
        if([propertykeyValue count]==2)
        {
            if([[propertykeyValue objectAtIndex:0]
                isEqualToString:@"captions"])
            {
                NSString *captionsString=[propertykeyValue objectAtIndex:1];
                NSArray *captions=[captionsString componentsSeparatedByString:@"#$#"];
                for (NSString *caption in captions) {
                    NSArray *captionkeyValue=[caption componentsSeparatedByString:@"="];
                    if([captionkeyValue count]==2)
                    {
                        [captionDictionary setObject:[captionkeyValue objectAtIndex:1] forKey:[captionkeyValue objectAtIndex:0]];
                        [imageValues addObject:[captionkeyValue objectAtIndex:1]];
                    }
                }
            }
        }
    }
    return imageValues;
}

-(void)showAlertControllerWithMsg:(NSString *)text withTitle:(NSString *)title;
{
    [[AlertView sharedManager] presentAlertWithTitle:title message:text andButtonsWithTitle:@[NSLocalizedStringFromTableInBundle(@"OK",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
     {
     }];
}

#pragma ImageContollerDelegate
-(void)didTapOnCloseForImageContoller
{
    [_kitabooImageController removeFromParentViewController];
    [_kitabooImageController.view removeFromSuperview];
    _kitabooImageController=nil;
}

-(void)didFailedLoadingImage
{
    [self showAlertControllerWithMsg:[LocalizationHelper localizedStringWithKey:@"RESOURCE_NOT_FOUND" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
}

-(void)didFailedLoadingImage: (NSError *)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(_kitabooImageController) {
            if (error.code == -1009) {
                if (![[KitabooNetworkManager getInstance] isInternetAvailable]) {
                    [self showAlertForExternalResourceLoadingFailedWithTitle:@"FAILED_ALERT_TITLE" WithMessage:@"INTERNET_UNAVAILABLE_MESSAGE"];
                }
            }
            else if (error.code == -1001) {
                [self showAlertForExternalResourceLoadingFailedWithTitle:@"ERROR_ALERT_TITLE" WithMessage:@"LOADING_FAILED"];
            }
        }
    });
}

- (void)didLoadRemoteImage:(NSInteger)position {
    if(_kitabooImageController) {
        [_kitabooImageController setDownloadedImageAtPosition:position];
    }
    
}

-(void)loadImagePlayer
{
    
}

#pragma YoutubePlayer
/*Add Youtube Player*/

- (void)loadYoutubeMarkup:(KFLinkVO*)linkVo
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventYoutubeVideoParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    if (_youtubePlayer != nil)
    {
        [_youtubePlayer close];
        _youtubePlayer=nil;
    }
    
    _youtubePlayer = [[KitabooYTPlayer alloc]initWithLinkVO:linkVo];
    _youtubePlayer.delegate=self;
    if (linkVo.isInLine)
    {
        activeMode = kPlayerActiveModeMarkupPlayerInLineVideo;
        [_rendererView addInLineVideo:[_youtubePlayer getYoutubeInlinePlayer] atRect:linkVo.boxTansformedRect onPageNO:linkVo.pageID.integerValue];
    }
    else
    {
        activeMode = kPlayerActiveModeMarkupPlayer;
        [self addChildViewController:_youtubePlayer];
        [self.view addSubview:_youtubePlayer.view];
        _youtubePlayer.view.translatesAutoresizingMaskIntoConstraints=NO;

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_youtubePlayer.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_youtubePlayer.view attribute:NSLayoutAttributeBottom  relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_youtubePlayer.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_youtubePlayer.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        
        [self animateViewController:_youtubePlayer
                           fromRect:linkVo.iconView.frame
                             toRect:self.view.bounds
                       withDuration:0.4];
    }
}
/*Delegate Method of YTPlayer.Remove Added Youtube Player*/

-(void)didCloseYoutubePlayer
{
    [self dismissViewController:_youtubePlayer
                       fromRect:_youtubePlayer.view.frame
                         toRect:self.view.frame
                   withDuration:0.4];
    
    [_youtubePlayer.view removeFromSuperview];
    [_youtubePlayer removeFromParentViewController];
    _youtubePlayer = nil;
    activeMode = kPlayerActiveModeNone;
}

#pragma Kaltura Video Player
/*Hit the Service with userToken,link url and type.Service Success gives Video URL from Server or Failure with Failure reasons*/

-(void)loadKalturaVideoPlayer:(KFLinkVO*)linkVo
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventKalturaVideoParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:_baseURL clientID:_clientID];
    [kitabooServiceInterface getKalturaSessionURL:_user.userToken entryID:linkVo.url type:TYPE_KALTURA successHandler:^(NSDictionary *dict)
    {
        NSString *videoURL = [dict valueForKey:@"responseMsg"];
        [self requestDidFinishLoadingForKalturaPlayer:linkVo withVideoURL:videoURL];
    } failureHandler:^(NSError *err)
    {
         NSDictionary *userDictionary = err.userInfo;
         NSDictionary *invalidDic = userDictionary[@"invalidFields"];
         NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
         if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
         {
             if ([_userSettingsModel isAutoLoginEnabled])
             {
                 if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                     [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                         _user = renewedUser;
                         [self loadKalturaVideoPlayer:linkVo];
                     }];
                 }
             }else
             {
                 [self showSessionExpiredAlert];
             }
         }else
         {
            [self requestErrorOccureForKalturaPlayer:err];
         }
    }];
}
/*Add Kaltura Video Player*/

-(void)requestDidFinishLoadingForKalturaPlayer:(KFLinkVO*)linkVo withVideoURL:(NSString*)videoURL
{
    [self removePreLoaderView];
    KFBookVO *book=(KFBookVO*)currentBook;
    videoPlayer = [[KitabooVideoPlayer alloc] initWithVideoPath:videoURL withBookVO:book withLinkVO:linkVo];
    videoPlayer.delegate = self;
    
    if (linkVo.isInLine)
    {
        activeMode = kPlayerActiveModeMarkupPlayerInLineVideo;
        [videoPlayer playVideo];
        [_rendererView addInLineVideo:[videoPlayer getInlineVideoPlayer] atRect:linkVo.boxTansformedRect onPageNO:linkVo.pageID.integerValue];
    }
    else
    {
        videoPlayer.view.frame = self.view.bounds;
        [self addChildViewController:videoPlayer];
        [self.view addSubview:videoPlayer.view];
        [videoPlayer playVideo];
    }
}
/*Shows Alert Message For Kaltura Video Player */

-(void)requestErrorOccureForKalturaPlayer:(NSError*)err
{
    [self removePreLoaderView];
    NSDictionary *dictionary = err.userInfo;
    NSDictionary *tempDictionary = [dictionary valueForKey:@"invalidFields"];
    NSNumber *number = [tempDictionary valueForKey:@"usertoken"];
    
    if ([number integerValue] != SERVICE_CODE_TOKEN_EXPIRED)
    {
        NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
        NSString *alert_Msg = [LocalizationHelper localizedStringWithKey:@"KALTURA_INITIALIZATION_ERROR_MESSAGE_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
        [self showAlertControllerWithMsg:alert_Msg withTitle:alert_Title];
    }
}
/*Show Activity Indiactor and Loading Data Message Before Kaltura Video Player Service Result Occures From Server*/

-(void)addPreLoaderView
{
    _activityIndicatorView=nil;
    _activityIndicatorView = [[UIView alloc]init];
    [_activityIndicatorView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.65]];
    _activityIndicatorView.tintColor=[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    [self.view addSubview:_activityIndicatorView];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    UIView *view = [[UIView alloc]init];
    [_activityIndicatorView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:280]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];

    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    [view addSubview:activityIndicator];
    activityIndicator.translatesAutoresizingMaskIntoConstraints =NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
    
    UILabel *loadingDataLabel = [[UILabel alloc]init];
    [loadingDataLabel setText:[LocalizationHelper localizedStringWithKey:@"LOADING_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
    [loadingDataLabel setTextColor:[UIColor whiteColor]];
    [loadingDataLabel setFont:getCustomFont(20)];
    [loadingDataLabel sizeToFit];
    loadingDataLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:loadingDataLabel];
    loadingDataLabel.translatesAutoresizingMaskIntoConstraints =NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:activityIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
}
/*Stop activity Indicator when gets Kaltura Service Request*/

-(void)removePreLoaderView
{
    [_activityIndicatorView removeFromSuperview];
    _activityIndicatorView=nil;
}

-(void)didUpdateFibArray:(NSArray*)fibArray {
    if (fibArray && fibArray.count > 0) {
        for (SDKFIBVO* fibVo in fibArray) {
            if (_teacherAnnotationController) {
                [_teacherAnnotationController updateFIBData:fibVo];
            }
        }
        [self refreshTeacherReviewPage:((SDKFIBVO*)fibArray[0]).pageIdentifier.numberValue];
    }
}

-(void)didTapOnTeacherComment:(NSArray*)fibArray {
    if (fibArray && fibArray.count > 0) {
        if (_teacherAnnotationController) {
            _teacherAnnotationController.selectedFibArray = fibArray;
        }
        [self showNoteForTeacherCommentWithFib:fibArray[0]];
    }
}

-(void)didTapOnInstantFeedBack:(UIView*)fibView {
    if ([fibView isKindOfClass:[HDFIB class]]) {
        HDFIB *fib = (HDFIB*)fibView;
        [self showCorrectAnswerPopup:fib.linkVo.answer sourceView:fibView];
    } else if ([fibView isKindOfClass:[MarkupView class]]) {
        MarkupView *dropDown = (MarkupView*)fibView;
        KFBookVO *book=(KFBookVO*)currentBook;
        KFPageVO *page=[book.pages objectForKey:[NSString stringWithFormat:@"%ld",(long)dropDown.pageID]];
        KFLinkVO *link=[page.links objectForKey:[NSString stringWithFormat:@"%ld",(long)dropDown.linkID]];
        [self showCorrectAnswerPopup:link.answer sourceView:fibView];
    }
}

-(UGCLabel *)noteIconViewForHighlight:(SDKHighlightVO*)highlightVO
{

    UGCLabel *noteLabel;
    CGRect frame = CGRectMake(0, 0,isIpad()?45:50, isIpad()?45:50);
    if([highlightVO isStickyNote])
    {
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            if(book.meta.layout==ePUBFixedLayout) {
                frame = CGRectMake(0, 0,isIpad()?65:50, isIpad()?65:50);
            }
        }
        noteLabel = [[UGCLabel alloc] initWithFrame:frame];
        noteLabel.backgroundColor = [UIColor clearColor];
        noteLabel.text = ICON_TAPPABLE_STICKY_NOTE;
        
        noteLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        noteLabel.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        noteLabel.font = [UIFont fontWithName:[HDIconFontConstants getFontName]
                                         size:noteLabel.frame.size.height*0.5];
        if (highlightVO.isReceived)
            noteLabel.textColor = [[UIColor colorWithHexString:SharedColor]colorWithAlphaComponent:0.85];
        else
            noteLabel.textColor = [[UIColor colorWithHexString:highlightVO.backgroundColor]colorWithAlphaComponent:0.85];

        noteLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        noteLabel = [[UGCLabel alloc] initWithFrame:frame];
        noteLabel.backgroundColor = [UIColor clearColor];
        noteLabel.text = @"V";
        noteLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        noteLabel.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        noteLabel.font = [UIFont fontWithName:[HDIconFontConstants getFontName]
                                         size:noteLabel.frame.size.height*0.5];
        if (highlightVO.isReceived) {
            noteLabel.textColor = [[UIColor colorWithHexString:SharedColor]colorWithAlphaComponent:0.85];
        }
        else {
            noteLabel.textColor = [[UIColor colorWithHexString:highlightVO.backgroundColor] colorWithAlphaComponent:0.85];
        }
        noteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return noteLabel;
}

-(void)rendererViewController:(RendererViewController*)rendrerViewController didBookLoadingFailedWithError:(NSError*)error
{

}

-(NSString*)initialDisplayNumber:(RendererViewController *)rendererViewController
{
    //_lastPageFolio = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastPageID"];
    if(_searchResult)
    {
        _lastPageFolio =  _searchResult.displayNumber;
    }
    NSString *displayNumber;
    if (_lastPageFolio && [_lastPageFolio containsString:@"chapterid"]) {
        NSData * data = [_lastPageFolio dataUsingEncoding:NSUTF8StringEncoding];
        if(data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if([json valueForKey:@"chapterid"])
            {
                displayNumber = [json valueForKey:@"chapterid"];
            }
        }
    }
    else
    {
        displayNumber = _lastPageFolio;
    }
    
    if(displayNumber && [currentBook isKindOfClass:[KFBookVO class]])
    {
        NSString *pageId = [NSString stringWithFormat:@"%ld",(long)[self getPageIDForDisplayNumber:displayNumber]];
        return pageId;
    }
    return displayNumber;
}

-(void)rendererViewController:(RendererViewController*)rendererViewController didBookLoadedSuccessfullyWithBook:(KitabooBookVO*)bookVO
{
    analyticsHandler = [[HDKitabooAnalyticsHandler alloc] init];
    audioSyncSelectedColor = [AudioSyncHighlightColorPalletes firstObject];
    audioSyncSpeedRateOption = kAudioSyncSpeedRateOption2;
    currentBook=bookVO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didBookLoadedSuccessfullyWithBook:)]) {
        [_delegate didBookLoadedSuccessfullyWithBook:bookVO];
    }
    
    //-- For ElasticSearch
    if (_elasticSearchText && ![_elasticSearchText isEqualToString:@""])
    {
        if([currentBook isKindOfClass:[KFBookVO class]] || [currentBook isKindOfClass:[EPUBBookVO class]])
        {
            [self addSearchForText:_elasticSearchText isElasticSearch:YES];
            if (_searchResult)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_rendererView navigateToPageNumber:_searchResult.pageIndex];
                });
                [self enablePreviousButtonForElasticSearch:NO];
//                if (searchResultArray.count == 1)
//                {
//                    [self enablePreviousButtonForElasticSearch:NO];
//                    [self enableNextButtonForElasticSearch:NO];
//                }
            }
            else
            {
                [self enablePreviousButtonForElasticSearch:NO];
                [self enableNextButtonForElasticSearch:NO];
            }
        }
        else
        {
            [self addSearchForText:_elasticSearchText isElasticSearch:NO];
        }
    }
    else if(_jumpToPageId && ![_jumpToPageId isEqualToString:@""])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)[self getPageIDForDisplayNumber:_jumpToPageId]];
            [_rendererView navigateToPageNumber:inStr];
        });
    }
    //--
    
    if ([currentBook isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *pdfBookVO = (KFBookVO *)currentBook;
        if (pdfBookVO.bookOrientationType == kBookOrientationTypeLandscapeOnly)
        {
            [rendererViewController setBookOrientationMode:kBookOrientationModeLandscapeOnePageOnly];
        }
        else if (pdfBookVO.bookOrientationType == kBookOrientationTypePortraitOnly)
        {
            [rendererViewController setBookOrientationMode:kBookOrientationModePortrait];
        }
        else
        {
            [rendererViewController setBookOrientationMode:kBookOrientationModeDynamic];
        }
    }
    else
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        _userSettingsModel.isAudioSyncEnabled = epubBook.isAudioSyncSupported;
        [rendererViewController setBookOrientationMode:kBookOrientationModeDynamic];
        if (epubBook.meta.layout == ePUBReflowable && (_isReflowPrintEnable || printEnabledPageArray.count > 0)) {
            _userSettingsModel.isPrintEnabled = true;
            if (isTwoPageSeperationDisabled) {
                [rendererViewController disableTwoPageSeperation:YES];
            }
        }
    }
    [_dbManager setBook:currentBook];
    [self addPlayerActionBarForTopAndBottom];
    [self updatePlayerActionBarForSelectedBook];
    [self changeAudioButtonStatus];
    NSArray *array = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    if (array.count>0)
    {
        bookClassInfo = [array objectAtIndex:0];
    }
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        [self setEPUBReaderSettings:(EPUBBookVO*)currentBook];
    }
    bookOpenTimeStamp = [NSDate date];
    [self trackBookOpenEvent];
   // [_dataSyncManager fetchUGCOperationForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
    [_dataSyncManager fetchAndSaveSormDataForUserID:[NSNumber numberWithInteger:[_user.userID integerValue]] bookID:_bookID andClassId:_classID WithDelegate:self WithUserToken:_user.userToken];
    if([_rendererView isFurthestPageEnabled])
    {
        [_dataSyncManager fetchFurthestPageDataForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
    }

//    [self relaodPageUGCForActivePages];
    if (!(_elasticSearchText && ![_elasticSearchText isEqualToString:@""]))
    {
    [self showHelpScreen:NO];
    }
}

-(void)setEPUBReaderSettings:(EPUBBookVO *)epubBook
{
    if (epubBook.meta.layout == ePUBReflowable)
    {
        isVerticalsliderEnable = epubBook.userReaderFontSettings.scrollEnabled;
        
        /*Add Slider For Reflowable Book.*/
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            [self addSliderBarForReflowableBook];
            [self addReflowablePageCountView];
        }
    }
}

-(void)updatePlayerActionBarForSelectedBook
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if(isIpad())
        {
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStickyNote WithIsHidden:NO];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypePenTool WithIsHidden:NO];
            [_playerBottomActionBarView hideItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsHidden:NO];
            [_playerBottomActionBarView enableItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsEnabled:YES];
            [self.playerTopActionBarView layoutIfNeeded];
        }
        else
        {
            [self updatePageSliderForiPhoneBottom];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStickyNote WithIsHidden:NO];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypePenTool WithIsHidden:NO];
            [_playerBottomActionBarView hideItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsHidden:NO];
            [_playerBottomActionBarView enableItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsEnabled:YES];
            [_playerBottomActionBarView hideItemWithTag:kPlayerActionBarItemTypeSlider WithIsHidden:NO];
            [self.playerTopActionBarView layoutIfNeeded];
        }
        
    }
    else if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(isIpad())
        {
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStickyNote WithIsHidden:NO];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypePenTool WithIsHidden:NO];
//            [_playerBottomActionBarViewIPad hideItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsHidden:YES];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeTeacherReview WithIsHidden:YES];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStudentSubmit WithIsHidden:YES];
//            [_playerBottomActionBarViewIPad enableItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsEnabled:NO];
            if(epubBook.meta.layout == ePUBReflowable)
            {
                [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStickyNote WithIsHidden:YES];
                [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypePenTool WithIsHidden:YES];
            }

        }
        else
        {
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStickyNote WithIsHidden:NO];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypePenTool WithIsHidden:NO];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeTeacherReview WithIsHidden:YES];
            [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypeStudentSubmit WithIsHidden:YES];
            [_playerBottomActionBarView hideItemWithTag:kPlayerActionBarItemTypeSlider WithIsHidden:YES];
            
            if(epubBook.meta.layout == ePUBReflowable)
            {
                [_playerBottomActionBarView hideItemWithTag:kPlayerActionBarItemTypeStickyNote WithIsHidden:YES];
                [self.playerTopActionBarView hideItemWithTag:kPlayerActionBarItemTypePenTool WithIsHidden:YES];
                
                [_playerBottomActionBarView hideItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsHidden:YES];
                [_playerBottomActionBarView enableItemWithTag:kPlayerActionBarItemTypeThumbnail WithIsEnabled:NO];
            }
        }
        
        switch (epubBook.meta.layout)
        {
                case ePUBReflowable:
                {
                    
                }
                    break;
                case ePUBFixedLayout:
                {
                    if(!isIpad())
                    {
                        [self updatePageSliderForiPhoneBottom];
                    }
                }
                default:
                    break;
            }
    }
}

-(void)updatePageSliderForiPhoneBottom
  {
      if(pageSliderForiPhoneBottomBar)
      {
          NSArray *totalPages = [self getFolioPagesForIphoneSlider];
          if(!totalPages.count)
          {
              pageSliderForiPhoneBottomBar.enabled=NO;
          }
          pageSliderForiPhoneBottomBar.maximumValue =totalPages.count;
      }
  }


-(void)rendererViewController:(RendererViewController*)rendererViewController didPageLoadingFailedForPageNumber:(NSNumber*)number WithError:(NSError*)error
{
    
}
- (void)rendererViewController:(RendererViewController *)rendererViewController willLoadCFI:(NSArray *)cfiArray withPageNumber:(NSNumber *)number WithDisplayNumber:(NSString *)displayNum
{
    [self trackCFIAnalyticsEventWith:displayNum];
    for (NSString* cfi in cfiArray) {
        [CFIsLoadStartTimeDictionary removeObjectForKey:cfi];
        [CFIsLoadStartTimeDictionary setObject:[NSDate date] forKey:cfi];
    }
}
- (void)rendererViewController:(RendererViewController *)rendererViewController willLoadPageWithPageNumber:(NSNumber *)number WithDisplayNumber:(NSString *)displayNum
{
    if (readAloudMode != ReadAloudModeAutoPlay) {
        [self closeAudioSync];
    }
    if ([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        EPUBChapter *chapter = epubBook.chapters[displayNum.intValue];
        PlayerActionBarItem *soundButtonForAudioSync = [self getAudioButtonForPlayer:_playerBottomActionBarView];
        if (chapter.isAudioSyncSupported) {
            soundButtonForAudioSync.enabled = true;
            soundButtonForAudioSync.alpha =  1.0;
        }
        else{
            soundButtonForAudioSync.enabled = false;
            soundButtonForAudioSync.alpha =  0.5;
        }
        [self configurePrintIconForChapter:chapter];
    }
    if(displayNum)
    {
        [pagesLoadStartTimeDictionary removeObjectForKey:displayNum];
        if(!([currentBook isKindOfClass:[EPUBBookVO class]] && ((EPUBBookVO*)currentBook).meta.layout == ePUBReflowable))
        {
            //For kitaboo fixed & epub fixed.
            [self trackAnalyticsEvent];
        }
        [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:displayNum];
    }
    else
    {
        NSLog(@"NO DISPLAY NUMBER DETECTED");
    }
    
    switch (activeMode)
    {
        case kPlayerActiveModeHighlight:
            [rendererViewController removeHighlightView];
            activeMode=kPlayerActiveModeNone;
            break;
        case kPlayerActiveModeMarkupMutilink:
        {
            [self removeMultiLinkPopOver];
        }
            break;
        case kPlayerActiveModeInstruction:
        {
            [self removeInstructionMarkupPopOver];
        }
            break;
        case kPlayerActiveModeBookmark:
            [self removeBookmarkVC];
            activeMode = kPlayerActiveModeNone;
            break;
        case kPlayerActiveModeGlossary:
            [self removeGlossaryController];
            break;
        default:
            break;
    }
    
}
- (void)rendererViewController:(RendererViewController *)rendererViewController willUnloadCFI:(NSArray *)cfiArray withPageNumber:(NSNumber *)number WithDisplayNumber:(NSString *)displayNum
{
    [self trackCFIAnalyticsEventWith:displayNum];
    for (NSString* cfi in cfiArray)
    {
        [CFIsLoadStartTimeDictionary removeObjectForKey:cfi];
    }
    NSString *eventTrackingJSON = [analyticsHandler getTrackingJSON];
    if(eventTrackingJSON)
    {
        [_dbManager createReaderAnalyticsSessionForUserID:_user.userID WithBookID:[NSString stringWithFormat:@"%@",_bookID] withAnalyticsData:eventTrackingJSON];
    }
}

-(void)rendererViewController:(RendererViewController*)rendererViewController willUnloadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString *)displayNum
{
    NSDate *startPageTime = [pagesLoadStartTimeDictionary objectForKey:displayNum];
    NSDate *endPageTime = [NSDate date];
    NSTimeInterval secondsBetween = [endPageTime timeIntervalSinceDate:startPageTime];
    if(([currentBook isKindOfClass:[EPUBBookVO class]] && ((EPUBBookVO*)currentBook).meta.layout == ePUBReflowable))
    {
        //For reflowable epub.
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        EPUBChapter *chapter = epubBook.chapters[displayNum.intValue];
        NSString *chapterName = chapter.idref;
        HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:nil pageId:displayNum timeSpent:[NSString stringWithFormat:@"%d",(int)secondsBetween] chapterId:displayNum chapterName:chapterName uniqueId:[[NSUUID UUID] UUIDString]];
        [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
    }
    else
    {
        //For kitaboo fixed & epub fixed.
        [self trackAnalyticsEvent];
    }
    [pagesLoadStartTimeDictionary removeObjectForKey:displayNum];
    NSString *eventTrackingJSON = [analyticsHandler getTrackingJSON];
    if(eventTrackingJSON)
    {
        [_dbManager createReaderAnalyticsSessionForUserID:_user.userID WithBookID:[NSString stringWithFormat:@"%@",_bookID] withAnalyticsData:eventTrackingJSON];
    }
}

-(void)trackAnalyticsEvent
{
    if (pagesLoadStartTimeDictionary.count) {
        NSArray *pageDisplayNumbers = pagesLoadStartTimeDictionary.allKeys;
        KFBookVO *book=(KFBookVO*)currentBook;
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        for (NSString *pageDisplayNum in pageDisplayNumbers)
        {
            NSDate *pageStartTime = [pagesLoadStartTimeDictionary objectForKey:pageDisplayNum];
            NSDate *pageEndTime = [NSDate date];
            NSTimeInterval secondsBetween = [pageEndTime timeIntervalSinceDate:pageStartTime];
            if (secondsBetween>1)
            {
                if (pagesLoadStartTimeDictionary.count>1) {
                    secondsBetween = secondsBetween/2;
                }
                NSString *pageNum;
                NSString *chapterName;
                if ([currentBook isKindOfClass:[KFBookVO class]]) {
                    //For kitaboo fixed.
                    pageNum =[NSString stringWithFormat:@"%ld",(long)[self getPageIDForDisplayNumber:pageDisplayNum]];
                    KFChapterVO *chapter=[book getChapterForPageID:pageNum];
                    chapterName = chapter.title;
                }
                else
                {
                    //For epub fixed.
                    pageNum = pageDisplayNum;
                    EPUBChapter *eachChapter = epubBook.chapters[pageDisplayNum.intValue];
                    chapterName = eachChapter.idref;
                }
                
                HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:nil pageId:pageDisplayNum timeSpent:[NSString stringWithFormat:@"%d",(int)secondsBetween] chapterId:pageNum chapterName:chapterName uniqueId:[[NSUUID UUID] UUIDString]];
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
                [pagesLoadStartTimeDictionary removeObjectForKey:pageDisplayNum];
                [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:pageDisplayNum];
            }
        }
    }
}

-(void)trackCFIAnalyticsEventWith:(NSString*)displayNum
{
    if (CFIsLoadStartTimeDictionary.count) {
        NSArray *CFIs = CFIsLoadStartTimeDictionary.allKeys;
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        EPUBChapter *chapter = epubBook.chapters[displayNum.intValue];
        NSString *chapterName = chapter.idref;
        for (NSString *CFI in CFIs)
        {
            NSDate *CFIStartTime = [CFIsLoadStartTimeDictionary objectForKey:CFI];
            NSDate *CFIEndTime = [NSDate date];
            NSTimeInterval secondsBetween = [CFIEndTime timeIntervalSinceDate:CFIStartTime];
            if (secondsBetween>1)
            {
                secondsBetween = secondsBetween/CFIs.count;
                HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:CFI pageId:displayNum timeSpent:[NSString stringWithFormat:@"%f",secondsBetween] chapterId:displayNum chapterName:chapterName uniqueId:[[NSUUID UUID] UUIDString]];
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
                [CFIsLoadStartTimeDictionary removeObjectForKey:CFI];
                [CFIsLoadStartTimeDictionary setObject:[NSDate date] forKey:CFI];
            }
        }
    }
}


- (void)didPageBeginScroll:(NSNumber *)pageNumber
{
    switch (activeMode)
    {
        case kPlayerActiveModeBookmark:
            [self removeBookmarkVC];
            activeMode = kPlayerActiveModeNone;
            break;
            
        default:
            break;
    }
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didPageBeginScroll:(NSNumber *)pageNumber
{
    
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didEndScrollingWithContentOffset:(CGPoint)offset WithPageNumber:(NSNumber *)pageNumber
{
    
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didZoomInPage:(NSArray *)pageNumbers
{
    if (activeMode == kPlayerActiveModeInstruction){
        [self removeInstructionMarkupPopOver];
    }
}
- (void)rendererViewController:(RendererViewController *)rendererViewController didZoomOutPage:(NSArray *)pageNumbers
{
    if (activeMode == kPlayerActiveModeInstruction){
        [self removeInstructionMarkupPopOver];
    }
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didSingleTapOnPage:(NSNumber *)pageNumber
{
    switch (activeMode)
    {
        case kPlayerActiveModeMarkupPlayerAudio:
            [self manageTopBottomBar];
            break;
        case kPlayerActiveModeMarkupPlayerInLineVideo:
        case kPlayerActiveModeReflowableLayout:
        case kPlayerActiveModeNone:
        {
            if(isPlayerActionBarHidden)
            {
                [self moveTopAndBottomOnScreenWithIsAnimate:YES WithCompletionHandler:nil];
            }
            else
            {
                [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
            }
        }
            break;
        case kPlayerActiveModeHighlight:
        {
                [self removeHighlightPopup];
        }
            break;
        case kPlayerActiveModeMarkupMutilink:
        {
            [self removeMultiLinkPopOver];
        }
            break;
            case kPlayerActiveModeBookmark:
        {
                [self removeBookmarkVC];
        }
            break;
        case kPlayerActiveModeTOC:
        {
            [self removeTOC];
        }
            break;
        case kPlayerActiveModeFIB:
        {
            [_rendererView.view endEditing:YES];
            activeMode = kPlayerActiveModeNone;
        }
            break;
        case kPlayerActiveModeTeacherReview:
        {
            [_rendererView.view endEditing:YES];
        }
            break;
        case kPlayerActiveModeGlossary:
            [self removeGlossaryController];
            break;
        case kPlayerActiveModeInstruction:
        {
            [self removeInstructionMarkupPopOver];
        }
            break;
        default:
            break;
    };
    
    [UIView animateWithDuration:PlayerActionBarAnimationTime animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)manageTopBottomBar {
    if (!_audioPlayer.isAudioResourcePlaybackground) {
        return;
    }
    if(isPlayerActionBarHidden) {
        [self moveTopAndBottomOnScreenWithIsAnimate:YES WithCompletionHandler:nil];
    } else {
        [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    }
}

-(void)rendererViewController:(RendererViewController*)rendererViewController didHighlightTextWithHighlightSelectionRect:(CGRect)highlightSelectionRect OnPageNo:(NSInteger)pageNo
{
    [self closeAudioSync];
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    if([rendererViewController openHighlightView:_highlightView OnPageNo:pageNo AtCoordinates:CGPointMake(highlightSelectionRect.origin.x, highlightSelectionRect.origin.y)])
    {
        [_highlightView resetHighlightView];
        if (isVerticalsliderEnable){
            if (@available(iOS 11.0, *)) {
                if (rightConstraintForVerticalSliderView.constant == -(sliderRightAndBottom+self.view.safeAreaInsets.right+15)) {
                        rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom)+self.view.safeAreaInsets.right;
                }
            } else {
                if (rightConstraintForVerticalSliderView.constant == -sliderRightAndBottom-15) {
                    rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom);
                }
            }
        }
        activeMode = kPlayerActiveModeHighlight;
    }
}

-(void)didHighlighCompleteWithHighlight:(SDKHighlightVO*)highlightVO
{
    [self trackEventForHighlight:highlightVO];

    if(highlightVO.status==DELETE)
    {
        [_dbManager deleteHighlight:highlightVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    }
    else
    {
        [_dbManager saveHighlight:highlightVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    }
    
    
    if(activeMode == kPlayerActiveModeNote)
    {
        [self removeNoteView];
    }
}

-(void)trackEventForHighlight:(SDKHighlightVO*)highlightVO
{
    HDKitabooAnalyticsMetaData *analyticsMetaData = [[HDKitabooAnalyticsMetaData alloc] initWithUGCTracking:highlightVO.displayNum uniqueId:highlightVO.localID];
    NSArray* highlights=[_dbManager highlightForPageID:highlightVO.pageIdentifier ForDisplayNumber:highlightVO.displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    bool isValidTrackingUGCData = true;
    for (SDKHighlightVO *actualHighlightVO in highlights) {
        if ([highlightVO.localID isEqualToString:actualHighlightVO.localID]) {
            if ((highlightVO.noteText.length>0) && ((actualHighlightVO.noteText.length == 0) || !actualHighlightVO.noteText)) {
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNormHighlightDeleted metadata:analyticsMetaData];
                if (!(!highlightVO.ugcID || [highlightVO.ugcID isEqualToString:@"-1"])) {
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteCreated metadata:analyticsMetaData];
                }
            } else if ((highlightVO.noteText.length>0 && (highlightVO.text.length == 0) && (actualHighlightVO.text.length == 0)) || (highlightVO.text.length > 0 && (actualHighlightVO.text.length > 0))) {
                isValidTrackingUGCData = false;
            }
        }
    }
    NSArray *array = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    SDKBookClassInfoVO *bookClassInfo;
    if (array.count>0)
    {
        bookClassInfo = [array objectAtIndex:0];
    }
    //Note/HL is deleted
    if(highlightVO.status==DELETE) {
        if(highlightVO.isImportant) {
            if(![highlightVO.noteText isEqualToString:@""] && highlightVO.noteText!=nil) {
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteDeleted metadata:analyticsMetaData];
            } else {
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeImpHighlightDeleted metadata:analyticsMetaData];
            }
        } else {
            if(![highlightVO.noteText isEqualToString:@""] && highlightVO.noteText!=nil) {
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteDeleted metadata:analyticsMetaData];
            } else {
                [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNormHighlightDeleted metadata:analyticsMetaData];
            }
        }
    } else {
        //Note/HL is newly created
        if(!highlightVO.ugcID || [highlightVO.ugcID isEqualToString:@"-1"]) {
            //Note/HL is deleted
            if(highlightVO.isImportant) {
                if(![highlightVO.noteText isEqualToString:@""] && highlightVO.noteText!=nil) {
                    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteCreated metadata:analyticsMetaData];
                } else {
                    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNormHighlightCreated metadata:analyticsMetaData];
                    if (bookClassInfo.shareList.count>0) {
                        [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNormHighlightShared metadata:analyticsMetaData];
                    }
                }
            } else {
                if (isValidTrackingUGCData) {
                    if(![highlightVO.noteText isEqualToString:@""] && highlightVO.noteText!=nil) {
                        [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteCreated metadata:analyticsMetaData];
                    } else {
                        [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNormHighlightCreated metadata:analyticsMetaData];
                        if (bookClassInfo.shareList.count>0) {
                            [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNormHighlightShared metadata:analyticsMetaData];
                        }
                    }
                }
            }
        }
    }
    
    [self createAndSaveReaderAnalyticsSessionWithCalledUsingTimer:false];
}

-(void)didTapOnNoteHighligh:(SDKHighlightVO*)highlightVO
{
    if(highlightVO)
    {
        [self closeAudioSync];
        [self showNotesForHighlight:highlightVO forMyDate:NO];
    }
}

-(void)didHighlightClosed
{
    activeMode=kPlayerActiveModeNone;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    switch (activeMode)
    {
        case kPlayerActiveModeHighlight:
        {
            [self removeHighlightPopup];
        }
            break;
        case kPlayerActiveModeMarkupMutilink:
        {
            [self removeMultiLinkPopOver];
        }
            break;
        case kPlayerActiveModeNote:
        {
            [self removeNoteView];
        }
            break;
        case kPlayerActiveModeBookmark:
        {
            [self removeBookmarkVC];
        }
            break;
        case kPlayerActiveModePentool:
        {
            [self singleTapOnPentoolPalleteContainer:nil];
            [penToolController setPenDrawingCanvas:[_rendererView getPenDrawingCanvas]];
            [penToolController setDrawingMode:DRAWING_MODE_NORMAL];
            //ZU5-119
            [penToolController setPenMode:PenModeDrawing];
            [penToolController setPenColor:[self getLastUpdatedPenColor]];
            [penToolController setPenStrokeThickness:[self getLastUpdatedPenThickness]];
            [_rendererView setPenDrawingModeEnabled:YES];
            [penToolController setDeleteOnSelectionEnabled:YES];
            //ZU5-119
           [self disableEraseMode];
           [_rendererView reloadPages];
        }
            break;
        case kPlayerActiveModeThumbnail:
        {
            if(_thumbnailViewController.pageIndexArray.count)
            {
                [_thumbnailViewController.pageIndexArray removeAllObjects];
            }
           
            if([currentBook isKindOfClass:[KFBookVO class]])
            {
                NSArray *activePages=[_rendererView getActivePages];
                if(activePages.count)
                {
                    KFPageVO *page1=[activePages objectAtIndex:0];
                    [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)page1.pageID]];
                    if(activePages.count==2)
                    {
                        KFPageVO *page2=[activePages objectAtIndex:1];
                        [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)page2.pageID]];
                    }
                }
            }
            else if([currentBook isKindOfClass:[EPUBBookVO class]])
            {
                EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
                if(epubBook.meta.layout==ePUBFixedLayout)
                {
                    NSArray *activePages=[_rendererView getActivePages];
                    if(activePages.count)
                    {
                        EPUBPage *page1 = [activePages objectAtIndex:0];
                        EPUBChapter *chapter1 = [self getEpubChapterForIndex:page1.fileIndex];
                        [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)chapter1.fileIndex]];
                        EPUBTOCPage *tocPage = [self getEpubTOCPageFromHref:chapter1.href];
                        [_thumbnailViewController setActiveDisplayNumber:tocPage.displayNumber];
                        if(activePages.count==2)
                        {
                            page1 = [activePages objectAtIndex:1];
                            chapter1 = [self getEpubChapterForIndex:page1.fileIndex];
                            [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)chapter1.fileIndex]];
                        }
                    }
                }
            }
        }
            break;
        case kPlayerActiveModeTeacherReview:
        {
            
        }
            break;
        case kPlayerActiveModeSearchText:
        {
            [self removeSearchController];
        }
            break;
        case kplayerActiveModeTextAnnotation:
        {
            [_rendererView exitTextAnnotationMode];
            [self removeTextAnnotationView];
        }
            break;
        case kplayerActiveModeElasticSearch:
        {
            
        }
            break;
        case kPlayerActiveModeProtractor:
        {
            [self removeProtractorView];
        }
            break;
        case kPlayerActiveModeFIB:
        {
            [self removeFIBPopOver];
        }
            break;
        case kPlayerActiveModeGlossary:
        {
            [self removeGlossaryController];
        }
            break;
        case kPlayerActiveModeInstruction:
        {
            [self removeInstructionMarkupPopOver];
        }
            break;
        case kPlayerActiveModeReadAloud:
        {
            [self closeAudioSync];
        }
            break;
        default:
            break;
    }
    [self reloadSearchHighlightText];
    [self resetPageHistoryIndexOnTransition];
    [self removeInlineYoutubePlayer];
    [self removeMultiLinkPopOver];
    [self removeProfilePopOver];
    [self removeVerticalBarViewForTeacherReview];
    [self didSelectActionToCloseDropDown];
    [self removeMultiLinkPopOver];
    /**Teacher Review :- If Loaded page is not present in Page Array Of Student Submited Ugc, then get the next page.*/
    NSString *displayNumber;
//    if ((activeMode == kPlayerActiveModeTeacherReview) && ![self isLoadedPageContainsUGC]) {
//        displayNumber = [self getNextPageNumberToNavigateWithUGC];
//    }
    
    __block BOOL isAudioPlaying = NO;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if(_audioSyncController.isPlaying)
        {
            isAudioPlaying = YES;
            [self pauseAudioSyncIfAny];
        }
        [self didJumpToTextWithFrame:CGRectZero WithPageIdentifier:_audioSyncController.audioPlayingForPageIdentifier];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self restoreReadAloudController];
        if(isAudioPlaying)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self->_audioSyncController resume];
                [self changePlayButtonState];
            });
        }
        if(viewForReadAloudActionBar)
        {
            viewForReadAloudActionBar.frame = self.view.bounds;
        }
        [self updateClearAllFIBsButtonStatus];
        
        /**Reflowable Slider :- Changes slider constaints when orientation change.*/
        [self addSliderBarForReflowableBook];
        if (isVerticalsliderEnable){
            if (!isPlayerActionBarHidden) {
                if (@available(iOS 11.0, *)) {
                    rightConstraintForVerticalSliderView.constant = -sliderRightAndBottom-self.view.safeAreaInsets.right+15;
                } else {
                    rightConstraintForVerticalSliderView.constant = -sliderRightAndBottom+15;
                }
            }else{
                if (@available(iOS 11.0, *)) {
                    rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom)+self.view.safeAreaInsets.right;
                } else {
                    rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom);
                }
            }
        }
        
        /**Teacher Review :- If Loaded page is not present in Page Array Of Student Submited Ugc, then load the next page.*/
        if ((activeMode == kPlayerActiveModeTeacherReview) && displayNumber) {
            [self didSelectNavigatePageButtonForTeacherReview:displayNumber];
        }
        if (isIpad() && activeMode == kPlayerActiveModeTeacherReview && generateReportVC)
        {
            generateReportPopoverpresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
        }
    }];
    
    /*Virtual Page count View.*/
    [_reflowableSliderPageCountView setPageData:@""];
    [self hideReflowablePageCountView];
}

-(void)removeProfilePopOver
{
    if ([_delegate respondsToSelector:@selector(didRemoveProfilePopOver)])
    {
        [_delegate didRemoveProfilePopOver];
    }
}

-(void)removePlayerBottomBar{
    [_playerBottomActionBarView removeFromSuperview];
    [self.playerTopActionBarView removeFromSuperview];
    _playerBottomActionBarView=nil;
    self.playerTopActionBarView=nil;
}

-(void)removeMultiLinkPopOver
{
    if(_multiLinkController)
    {
        if(isIpad())
        {
            [_multiLinkController dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
        else
        {
            activeMode=kPlayerActiveModeNone;
            [_multiLinkController.view removeFromSuperview];
            _multiLinkController=nil;
        }
    }
    
}
-(void)removeInlineLocalPlayer
{
    if (videoPlayer)
    {
        [[videoPlayer getInlineVideoPlayer] removeFromSuperview];
        videoPlayer = nil;
    }
}
-(void)removeInlineYoutubePlayer
{
    if(_youtubePlayer && [_youtubePlayer isInline])
    {
        [_youtubePlayer close];
        _youtubePlayer=nil;
    }
}

-(void)removeHighlightPopup
{
    [_rendererView removeHighlightView];
    activeMode=kPlayerActiveModeNone;
}

-(void)removeNoteView
{
    [_noteController dismissViewControllerAnimated:NO completion:^{
        activeMode=kPlayerActiveModeNone;
        [self resetAllPlayerActionBar];
        _noteController =nil;
    }];
    if(!isIpad())
    {
        [_rendererView reloadPages];
    }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];

}

#pragma mark Instruction Markup
- (void)loadInstructionMarkup:(KFLinkVO *)link{
    
    [_rendererView resetZoomScaleToDefault];
    NSString *propertyString = link.properties;
    NSArray *propertyArray = [propertyString componentsSeparatedByString:@";"];
    NSString *instructionString;
    if (instructionPopOverContentVC != NULL){
        [self removeInstructionMarkupPopOver];
    }
    instructionPopOverContentVC = [[InfomationPopOverContentViewController alloc]init];
    [instructionPopOverContentVC.view setBackgroundColor:instructionMarkup_BgColor];
    instructionPopOverContentVC.view.layer.masksToBounds = NO;
    instructionPopOverContentVC.view.layer.shadowColor =  instructionMarkup_ShadowColor.CGColor;
    instructionPopOverContentVC.view.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    instructionPopOverContentVC.view.layer.shadowOpacity = 0.4f;
    instructionPopOverContentVC.view.layer.shadowRadius = 3.0f;
    [instructionPopOverContentVC setInstructionTextBackgroundColor:UIColor.clearColor];
    [instructionPopOverContentVC setInstructionTextFont:getCustomFont(isIPAD? 18 : 12)];
    [instructionPopOverContentVC setLinkVo:link];

    for (NSString *property in propertyArray)
    {
        if ([property hasPrefix:@"instruction"])
        {
            NSArray *tempArray = [property componentsSeparatedByString:@":"];
            instructionString = [tempArray objectAtIndex:1];
        }
    }
    if (instructionString.length == 0) {
        [self showAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE"] WithMessage:[LocalizationHelper localizedStringWithKey:@"NO_INSTRUCTION_AVAILABLE"]];
    }
    else
    {
        activeMode = kPlayerActiveModeInstruction;
        [instructionPopOverContentVC setInstructionText:instructionString];
        [_rendererView addInstructionPopup:instructionPopOverContentVC atSourceView:link.iconView onPageNO:[link.pageID intValue]];
    }
}
-(void)removeInstructionMarkupPopOver
{
    activeMode = kPlayerActiveModeNone;
    [instructionPopOverContentVC.view removeFromSuperview];
    instructionPopOverContentVC = nil;
}

#pragma mark Web Player

- (void)webPlayer:(NSURL *)path withLinkVO:(KFLinkVO *)linkVO{
    if (linkVO.linkType == kLinkTypeWidget) {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventKitabooWidgetParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    }
    else if (linkVO.linkType == kLinkTypeHtmlWrap){
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventHTMLActivityParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    }
    else if (linkVO.linkType == kLinkTypeWebLink){
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventWebLinkParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    }
    KFBookVO *bookVO = (KFBookVO *)currentBook;
    if([self CheckIfSCORMType:[[path relativeString] stringByReplacingOccurrencesOfString:@"/index.html" withString:@""]])
    {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventScormParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
        NSString *scormData = [_dbManager fetchScormDataWithBookID:_bookID forUser:[NSNumber numberWithInteger:[_user.userID intValue]] forSCORMId:[NSNumber numberWithInteger:(long)linkVO.linkID]];
        webPlayer = [[KitabooScormWebPlayer alloc] initWithURL:[path relativeString] withScormID:[NSString stringWithFormat:@"%ld",(long)linkVO.linkID] withScormData:scormData];
        scormDataSavetimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(saveScormData) userInfo:nil repeats:YES];
    }
    else
    {
        webPlayer = [[KitabooWebPlayer alloc] initWithURL:path withLinkVO:linkVO WithBook:bookVO];
    }
    webPlayer.delegate = self;
    [webPlayer setThemeColorToView:hdThemeVO.top_toolbar_icons_color];
    [self addChildViewController:webPlayer];
    [self.view addSubview:webPlayer.view];
    webPlayer.view.translatesAutoresizingMaskIntoConstraints = NO;
    [webPlayer.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [webPlayer.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [webPlayer.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
    [webPlayer.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
}

-(BOOL)CheckIfSCORMType:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *scormFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/imsmanifest.xml"]];
    
    
    if ([fileManager fileExistsAtPath:scormFilePath]) {
        return TRUE;
    }
    return FALSE;
}

- (void)webPlayer:(NSURL *)path {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:path];
    webPlayer = [[KitabooWebPlayer alloc] initWithURL:request configuration:configuration];
    
    webPlayer.delegate = self;
    [webPlayer setThemeColorToView:hdThemeVO.top_toolbar_icons_color];
    [self addChildViewController:webPlayer];
    [self.view addSubview:webPlayer.view];
    webPlayer.view.frame = self.view.bounds;
}

#pragma mark - : KitabooWebPlayer delegates
- (void)saveScormData
{
    if ([webPlayer isKindOfClass:[KitabooScormWebPlayer class]])
    {
        KitabooScormWebPlayer *scormPlayer = (KitabooScormWebPlayer *)webPlayer;
        [scormPlayer getScormActivityData:^(NSString * _Nonnull scormData, NSDictionary * _Nonnull scormDetails) {
            NSNumber *pageID = [NSNumber numberWithInt:[[scormDetails valueForKey:@"PageID"] intValue]];
            NSString *scormID = [scormDetails valueForKey:@"ScormID"];
            NSString *activityName = [scormDetails valueForKey:@"ActivityName"];
            [_dbManager saveSCORMdataToDB:_bookID  forUser:[NSNumber numberWithInteger:[_user.userID intValue]] forSCORMId:scormID withSCORMString:scormData andClassId:_classID andPageID:pageID andActivityname:activityName andIsSynced:NO];
        }];
    }
}


- (void)webPlayerWillCloseWithScormData:(NSString *)scormData activityName:(NSString *)activityName withScormID:(NSString*)scormID withPageID:(NSString*)pageID{
    [scormDataSavetimer invalidate];
    scormDataSavetimer = nil;
    [_dbManager saveSCORMdataToDB:_bookID forUser:[NSNumber numberWithInteger:[_user.userID intValue]] forSCORMId:scormID withSCORMString:scormData andClassId:_classID andPageID:[NSNumber numberWithInteger:[pageID intValue]] andActivityname:activityName andIsSynced:NO];
    [_dataSyncManager saveSormDataForUserID:[NSNumber numberWithInteger:[_user.userID intValue]] bookID:_bookID andClassId:_classID WithDelegate:self WithUserToken:_user.userToken];
}

- (void)webPLayerDidClosed{
    [self removeInternalWebPlayer];
    activeMode = kPlayerActiveModeNone;
    webPlayer = nil;
}

- (void)webPlayerDidFailedWithError:(NSError *)error{
    if (error.code != 204)
    {
        activeMode = kPlayerActiveModeNone;
        [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
    }
}
- (WKWebView *)webView:(WKWebView *)webView createKitabooPlayerWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction
{
    if(internalWebPlayer)
    {
        [self removeInternalWebPlayer];
    }
    internalWebPlayer = [[KitabooWebPlayer alloc]initWithURL:navigationAction.request configuration:configuration];
    //internalWebPlayer.delegate = self;
    [internalWebPlayer setThemeColorToView:hdThemeVO.top_toolbar_icons_color];
    [webView addSubview:internalWebPlayer.view];

    internalWebPlayer.view.translatesAutoresizingMaskIntoConstraints = false;

    [internalWebPlayer.view.leadingAnchor constraintEqualToAnchor:webView.leadingAnchor constant:0].active = true;
    [internalWebPlayer.view.trailingAnchor constraintEqualToAnchor:webView.trailingAnchor constant:0].active = true;
    [internalWebPlayer.view.topAnchor constraintEqualToAnchor:webView.topAnchor constant:0].active = true;
    [internalWebPlayer.view.bottomAnchor constraintEqualToAnchor:webView.bottomAnchor constant:0].active = true;
    [internalWebPlayer setDoneButtonTitle:[LocalizationHelper localizedStringWithKey:@"Back" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
    return internalWebPlayer.webView;
}
-(void)removeInternalWebPlayer
{
    [internalWebPlayer removeFromParentViewController];
    [internalWebPlayer.view removeFromSuperview];
    internalWebPlayer = nil;
}
#pragma mark Document Player
- (void)documentPlayer:(NSURL *)url{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventDocumentParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    [KitabooDocumentPlayer setIsExternalResource:isExternalResource];
    KitabooDocumentPlayer *documentPlayer = [[KitabooDocumentPlayer alloc] initWithURL:url];
    documentPlayer.delegate = self;
    [documentPlayer setThemeColorToView:hdThemeVO.top_toolbar_icons_color];
    [self addChildViewController:documentPlayer];
    [self.view addSubview:documentPlayer.view];
    documentPlayer.view.frame = self.view.bounds;
}

- (void)documentPLayerDidClosed{
    activeMode = kPlayerActiveModeNone;
}

#pragma mark Audio Player
-(void)AudioPlayerWithURL:(NSString *)targetURL WithPlayerUIEnable:(BOOL)playerUIEnabled withIsEncrypted:(BOOL)encrypted playInBackground:(BOOL)isPlaybackground
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if(isExternalResource){
            [self addPreLoaderView];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([currentBook isKindOfClass:[EPUBBookVO class]]) {
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            _audioPlayer = [[KitabooAudioPlayer alloc]initWithURL:targetURL withBookPath:book.rootPath withISBN:@"" WithPlayerUIEnable:playerUIEnabled withIsEncrypted:encrypted];
            if (![fileManager fileExistsAtPath:targetURL] && !isExternalResource){
                [self showAlertControllerWithMsg:[LocalizationHelper localizedStringWithKey:@"RESOURCE_NOT_FOUND" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                return;
            }
        } else {
            KFBookVO *book=(KFBookVO*)currentBook;
            if (![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",book.path,targetURL]] && !isExternalResource){
                [self showAlertControllerWithMsg:[LocalizationHelper localizedStringWithKey:@"RESOURCE_NOT_FOUND" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                return;
            }
            activeMode=kPlayerActiveModeMarkupPlayerAudio;
            [KitabooAudioPlayer setIsExternalResource:self->isExternalResource];
            _audioPlayer = [[KitabooAudioPlayer alloc]initWithURL:targetURL withBookPath:book.path withISBN:book.ISBN WithPlayerUIEnable:playerUIEnabled withIsEncrypted:encrypted];
        }
        
        activeMode = kPlayerActiveModeMarkupPlayerAudio;
        backgroundActiveMode = kPlayerActiveModeMarkupPlayerAudio;
        _audioPlayer.isAudioResourcePlaybackground = isPlaybackground;
        _audioPlayer.delegate=self;
        if(!isExternalResource) {
            [self startAudio:_audioPlayer];
        }
    });
}

-(void)startAudio: (KitabooAudioPlayer*)audioPlayer{
    [_rendererView.view setUserInteractionEnabled:_audioPlayer.isAudioResourcePlaybackground];
    [audioPlayer start];
    _playerView = [audioPlayer getPlayerView];
    _playerView.center = self.view.center;
    [self.view addSubview:_playerView];
}

- (void)resetAudioPlayer {
    if (activeMode = kPlayerActiveModeMarkupPlayerAudio && _audioPlayer) {
        [_audioPlayer stop];
        [self audioPlayerFinishPlaying];
    }
}

#pragma mark Image Controller
-(void)ImageControllerWithImagePath:(NSString *)imageLocation withImageProperties:(NSString *)properties withLinkType:(MarkupLinkType )type isEncrypted:(BOOL)encryption
{
    if(_kitabooImageController)
    {
        _kitabooImageController=nil;
    }
    KFBookVO *book=(KFBookVO*)currentBook;
    NSString *imagePath= imageLocation;
    NSArray *arrayOfImagePaths=[imagePath componentsSeparatedByString:@";"];
    NSArray *arrayOfProperties=[properties componentsSeparatedByString:@";"];
    NSMutableArray *imageURLs=[self getImageURLsForImageMarkup:arrayOfImagePaths];
    NSMutableArray *imageProperties=[self getImagePropertiesForImageMarkup:arrayOfProperties];
    [KitabooImageController setIsExternalResource:self->isExternalResource];
    if(type == kLinkTypeImageZoom){
        _kitabooImageController=[[KitabooImageController alloc]initWithImageURLs:imageURLs withProperties:imageProperties withISBN:book.ISBN isEncrypted:encryption isZoomable:YES WithDelegate:self];
    }
    else
    {
        _kitabooImageController=[[KitabooImageController alloc]initWithImageURLs:imageURLs withProperties:imageProperties withISBN:book.ISBN isEncrypted:encryption isZoomable:NO WithDelegate:self];
    }
    if(_kitabooImageController!=nil)
    {
        [self addChildViewController:_kitabooImageController];
        [self.view addSubview:_kitabooImageController.view];
    }
}

-(void)ImageControllerWithImagePath:(NSString *)imageLocation isEncrypted:(BOOL)encryption
{
    if(_kitabooImageController)
    {
        _kitabooImageController=nil;
    }
    _kitabooImageController=[[KitabooImageController alloc]initWithImageURLs:@[imageLocation] withProperties:@[] withISBN:@"" isEncrypted:encryption isZoomable:NO WithDelegate:self];
    if(_kitabooImageController!=nil)
    {
        [self addChildViewController:_kitabooImageController];
        [self.view addSubview:_kitabooImageController.view];
    }
}

#pragma mark Video Player

- (void)videoPlayer:(NSString *)videoPath withLinkVO:(KFLinkVO *)linkVO{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:videoPath] && !isExternalResource){
        activeMode = kPlayerActiveModeNone;
        [self showAlertControllerWithMsg:[LocalizationHelper localizedStringWithKey:@"RESOURCE_NOT_FOUND" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
        return;
    }
    KFBookVO *book=(KFBookVO*)currentBook;
    [KitabooVideoPlayer setIsExternalResource:self->isExternalResource];
    videoPlayer = [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withBookVO:book withLinkVO:linkVO];
    videoPlayer.delegate = self;
    if (linkVO.isInLine)
    {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventInlineVideoParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
        activeMode = kPlayerActiveModeMarkupPlayerInLineVideo;
        [videoPlayer playVideo];
        [_rendererView addInLineVideo:[videoPlayer getInlineVideoPlayer] atRect:linkVO.boxTansformedRect onPageNO:linkVO.pageID.integerValue];
    }
    else{
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventNormalVideoParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
        videoPlayer.view.frame = self.view.bounds;
        [self addChildViewController:videoPlayer];
        [self.view addSubview:videoPlayer.view];
        [videoPlayer playVideo];
    }
}

- (void)VideoPlayerWithVideoPath:(NSString *)videoPath withType:(VIDEOTYPE)videoType withDecrytionKey:(NSString *)key
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.markupEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:KitabooReaderEventConstant.markupEventNormalVideoParameterValue,KitabooReaderEventConstant.markupEventParameterKey, nil]];
    videoPlayer = [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withType:videoType withDecrytionKey:key];
    videoPlayer.delegate = self;
    videoPlayer.view.frame = self.view.bounds;
    [self addChildViewController:videoPlayer];
    [self.view addSubview:videoPlayer.view];
    [videoPlayer playVideo];
}

- (void)videoPlayerWithVideoPath:(NSString *)videoPath withResource:(EPUBResource *)resource {
    EPUBBookVO *epubBook = (EPUBBookVO *)currentBook;
    videoPlayer = [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withBookVO:epubBook withResource:resource];
    videoPlayer.delegate = self;
    videoPlayer.view.frame = self.view.bounds;
    [self addChildViewController:videoPlayer];
    [self.view addSubview:videoPlayer.view];
    [videoPlayer playVideo];
}

- (void)videoPlayerDidStopPlaying{
    activeMode = kPlayerActiveModeNone;
}

- (void)videoPlayerDidFinishPlaying
{
    
}

- (void)videoPlayerDidPausePlaying{
    
}

- (void)videoPlayerDidEnterFullScreen{
    
}

- (void)videoPlayerDidExitFullScreen{
    if (activeMode == kPlayerActiveModeMarkupPlayer || activeMode == kPlayerActiveModeMarkupPlayerInLineVideo) {
        if (!isIpad()) {
            [_rendererView reloadPages];
        }
    }
}

#pragma mark TOC

/**
 Initiates the TOCController and present the TOCController as popover on Reader
 */
- (void)showTOC:(UIView*)view
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.tocEventName eventInfo:nil];
    if (_tocViewController)
    {
        _tocViewController = nil;
    }
    activeMode=kPlayerActiveModeTOC;
    
    NSArray *pages=[_rendererView getActivePages];
    NSArray *standardsArray = [[NSArray alloc] init];
    if ([currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TEKS"] && [currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TEKS"].count>0)
    {
        standardsArray = [currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TEKS"];
    }
    _tocViewController = [[TOCViewController alloc] initWithThemeVO:hdThemeVO book:currentBook chapter:currentChapter activePage:pages bookMarkDataArray:[self getBookmarkData] resourceDataArray:[self getResourceData] tocDataArray:[self getTOCContentData] standardResourceArray:standardsArray];
    _tocViewController._delegate = self;
    _tocViewController.userSettingsModel = _userSettingsModel;
    _tocViewController.user = _user;
    if ([[currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TOR"] count] > 0 && [currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TOR"])
    {
        _tocViewController.isExternalResourceAvailable = YES;
    }
    [_tocViewController setDataWithData:[self getTOCContentData]];
    _tocViewController.bookOrientation = [_rendererView getBookOrientationMode];
    [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
    
    if(isIPAD){
        _tocViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _tocViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:_tocViewController
                           animated:NO
                         completion:^{
                             [self.playerTopActionBarView resetPlayerActionBarSelection];
                         }];
    }
    else{
        _tocViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:_tocViewController
                           animated:YES
                         completion:^{
                             [self.playerTopActionBarView resetPlayerActionBarSelection];
                         }];
        
    }
    
    [self.view layoutIfNeeded];
}
- (void)sessionExpiredOnTOC{
    [self removeTOC];
    [self showSessionExpiredAlert];
}
- (void)didSelectTEKSStandard
{
    [_tocViewController setStandardDataWithData:[currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TEKS"]];
}

- (void)didSelectELPSStandard
{
    [_tocViewController setStandardDataWithData:[currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"ELPS"]];
}

- (NSArray *)didSelectInternalResources
{
    return [self getResourceData];
}

- (void)didSelectExternalResources
{
    if ([[currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TOR"] count] > 0 && [currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TOR"])
    {
        _tocViewController.isExternalResourceAvailable = YES;
        [_tocViewController setExternalResourcesDataWithData:[currentBook getBookResourcesForTORSubnodesForRole:_user.role ofStandardType:@"TOR"]];
    }
}

- (void)didLoadWebLinkForExternalResourcesWithWebLink:(NSString *)webLink
{
    NSString *urlString = [webLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *finalPath = [NSString stringWithFormat:@"%@/%@",_bookPath,urlString];
    if ([webLink rangeOfString:@"http"].location != NSNotFound ||  [webLink rangeOfString:@"https"].location != NSNotFound)
    {
        [self loadWebPlayerForStandardActivityWithURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        [self loadWebPlayerForStandardActivityWithURL:[NSURL fileURLWithPath:finalPath]];
    }
}

- (void)didLoadWebLinkForStandardsWithWebLink:(NSString *)webLink
{
    NSString *urlString = [webLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([webLink rangeOfString:@"http"].location != NSNotFound ||  [webLink rangeOfString:@"https"].location != NSNotFound)
    {
        [self loadWebPlayerForStandardActivityWithURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        [self loadWebPlayerForStandardActivityWithURL:[NSURL fileURLWithPath:urlString]];
    }
}

- (void)loadWebPlayerForStandardActivityWithURL:(NSURL *)url
{
    KitabooWebPlayer *player = [[KitabooWebPlayer alloc] initWithURL:url withLinkVO:nil WithBook:nil];
    player.delegate = self;
    [player setThemeColorToView:hdThemeVO.top_toolbar_icons_color];
    [self addChildViewController:player];
    [self.view addSubview:player.view];
    player.view.translatesAutoresizingMaskIntoConstraints = NO;
    [player.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [player.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [player.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
    [player.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
}

#pragma TOCControllerDelegate Implementation

/**
 TOCControllerDelegate Implementation
 */
- (NSMutableArray *)getResourceData{
    NSMutableArray *resourceArray = [NSMutableArray new];
    //Resource for Epub books
    EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
    if([epubBook isKindOfClass:[EPUBBookVO class]] && epubBook.meta.layout == ePUBFixedLayout) {
        for (NSDictionary *dict in [self getTOCContentData]) {
            NSMutableDictionary *chapterDict = [[NSMutableDictionary alloc] init];
            NSArray *arrayOfSubnodes = [self resourcesForChapter:dict];
            if (arrayOfSubnodes.count == 0)
                continue;
            [chapterDict setValue:arrayOfSubnodes forKey:@"resourceArray"];
            NSString *chapterName = [dict objectForKey:@"title"];
            NSString *src = [dict objectForKey:@"src"];
            [chapterDict setValue:chapterName forKey:@"ChapterName"];
            [chapterDict setValue:src forKey:@"src"];
            if(currentChapterName.length > 0 && [currentChapterName isEqualToString:chapterName]){
                [chapterDict setValue:[NSNumber numberWithBool:YES] forKey:@"isExpanded"];
                [chapterDict setValue:[NSNumber numberWithBool:YES] forKey:@"isCurrentChapter"];
            }
            else{
                [chapterDict setValue:[NSNumber numberWithBool:NO] forKey:@"isExpanded"];
                [chapterDict setValue:[NSNumber numberWithBool:NO] forKey:@"isCurrentChapter"];
            }
            [resourceArray addObject:chapterDict];
        }
        return resourceArray;
    }
    
    //Resource for PDF Books
    NSMutableArray *resourceTempArray = [[currentBook getBookResourcesForTOC] mutableCopy];
    KFBookVO *book=(KFBookVO*)currentBook;
    
    for (id bookDict in resourceTempArray) {
        if([book isKindOfClass:[KFBookVO class]])
            [bookDict setValue:[book getChapterForPageID:[NSString stringWithFormat:@"%@",[bookDict valueForKey:@"pageID"]]] forKey:@"chapterId"];
    }
    
    while (resourceTempArray.count) {
        
        if([book isKindOfClass:[KFBookVO class]]){
            NSDictionary *dict = [resourceTempArray objectAtIndex:0];
            NSPredicate *predicateToFindSameChapter = [NSPredicate predicateWithFormat:
                                                       @"(chapterId == %@)", [dict valueForKey:@"chapterId"]];
            NSArray *araayOfSubnodes = [resourceTempArray filteredArrayUsingPredicate:predicateToFindSameChapter];
            NSMutableDictionary *chapterDict = [[NSMutableDictionary alloc] init];
            [chapterDict setValue:araayOfSubnodes forKey:@"resourceArray"];
            [resourceTempArray removeObjectsInArray:araayOfSubnodes];
            [resourceArray addObject:chapterDict];
            KFChapterVO *chapter = [book getChapterForPageID:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pageID"]]];
            if(chapter.title != nil){
                [chapterDict setValue:chapter.title forKey:@"ChapterName"];
            }
            else{
                [chapterDict setValue:currentChapterName forKey:@"ChapterName"];
            }
            [chapterDict setValue:[dict valueForKey:@"pageID"] forKey:@"pageID"];
            [chapterDict setValue:[NSNumber numberWithInteger:chapter.chapterID] forKey:@"ChapterId"];
            if(currentChapter == chapter.chapterID){
                [chapterDict setValue:[NSNumber numberWithBool:YES] forKey:@"isExpanded"];
                [chapterDict setValue:[NSNumber numberWithBool:YES] forKey:@"isCurrentChapter"];
            }
            else{
                [chapterDict setValue:[NSNumber numberWithBool:NO] forKey:@"isExpanded"];
                [chapterDict setValue:[NSNumber numberWithBool:NO] forKey:@"isCurrentChapter"];
            }
        }
        else{
            NSDictionary *dict = [resourceTempArray objectAtIndex:0];
            NSPredicate *predicateToSameEpubChapter = [NSPredicate predicateWithFormat:
                                                       @"(folioNumber == %@)",                                  [dict valueForKey:@"folioNumber"]];
            NSArray *araayOfSubnodes = [resourceTempArray filteredArrayUsingPredicate:predicateToSameEpubChapter];
            NSMutableDictionary *chapterDict = [[NSMutableDictionary alloc] init];
            [chapterDict setValue:araayOfSubnodes forKey:@"resourceArray"];
            [resourceTempArray removeObjectsInArray:araayOfSubnodes];
            [resourceArray addObject:chapterDict];
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            NSPredicate *predicateToFindClass = [NSPredicate predicateWithFormat:
                                                 @"self.fileIndex == %d",[dict valueForKey:@"folioNumber"]];
            NSArray *araayOfChapters = [book.chapters filteredArrayUsingPredicate:predicateToFindClass];
            NSString *chapterName = [self getChapterNameForChapter:[araayOfChapters objectAtIndex:0]];
            [chapterDict setValue:chapterName forKey:@"ChapterName"];
            if(currentChapterName.length > 0 && [currentChapterName isEqualToString:chapterName]){
                [chapterDict setValue:[NSNumber numberWithBool:YES] forKey:@"isExpanded"];
                [chapterDict setValue:[NSNumber numberWithBool:YES] forKey:@"isCurrentChapter"];
            }
            else{
                [chapterDict setValue:[NSNumber numberWithBool:NO] forKey:@"isExpanded"];
                [chapterDict setValue:[NSNumber numberWithBool:NO] forKey:@"isCurrentChapter"];
            }
        }
    }
    
    return resourceArray;
}

- (NSArray *)resourcesForChapter:(NSDictionary *)chapter {
    EPUBBookVO *book = (EPUBBookVO*)currentBook;
    NSMutableArray *resourceArray = [NSMutableArray new];
    for (EPUBResource *resource in book.resources) {
        NSString *chapterName = [resource.chapter objectForKey:@"title"];
        if ([[chapter objectForKey:@"title"] isEqualToString:chapterName])
            [resourceArray addObject:resource];
    }
    return [resourceArray mutableCopy];
}

/**
 TOCControllerDelegate Implementation
 */
- (NSArray*)getBookmarkData{
    NSArray *bookmarks = [_dbManager bookMarkBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    if(bookmarks.count > 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(displayNum != nil)"];
        NSArray *filteredArray = [bookmarks filteredArrayUsingPredicate:predicate];
        return filteredArray;
    }
    else
    {
        return [NSArray array];
    }
}

/**
 TOCControllerDelegate Implementation
 */
- (void)navigateTopage:(NSString *)pageID
{
    if ([self isNavigatedPageValid:pageID]) {
        if (!viewForSliderBar.hidden) {
            NSArray *tempArray = [pageID componentsSeparatedByString:@"#"];
            NSString *fileName = [tempArray firstObject];
            [self navigateSliderToPage:fileName];
        }
        [self addPageIntoPageHistoryArray:pageID];
        isPageNavigateByScroll = NO;
        switch (activeMode) {
            case kPlayerActiveModeTOC:{
                [_rendererView navigateToPageNumber:pageID];
                break;
            }
            case kPlayerActiveModeMyData:{
                [_rendererView navigateToPageNumber:pageID];
                break;
            }
            default:
                break;
        }
        activeMode=kPlayerActiveModeNone;
        [self resetAllPlayerActionBar];
    }
}

-(BOOL)isNavigatedPageValid:(NSString *)pageID {
    BOOL isPageValid = false;
    if ([currentBook isKindOfClass:[KFBookVO class]]) {
        NSArray *totalPages = [self getTotalPagesArray];
        if ([totalPages containsObject:pageID]) {
            isPageValid = true;
        }
    }else if ([currentBook isKindOfClass:[EPUBBookVO class]]){
        NSArray *tempArray = [pageID componentsSeparatedByString:@"#"];
        NSString *fileName = [tempArray firstObject];
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        for (EPUBChapter *chapter in epubBook.chapters) {
            if ([chapter.href isEqualToString:fileName]) {
                isPageValid = true;
                break;
            }
        }
    }
    return isPageValid;
}

-(void)navigateSliderToPage:(NSString *)pageID
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        for (EPUBChapter *chapter in epubBook.chapters) {
            if ([chapter.href isEqualToString:pageID]) {
                if (epubBook.isBookContentLoaded) {
                    NSInteger sliderValue = chapter.bookContentSizeTillChapter;
                    [viewForSliderBar.pageSlider setValue: sliderValue animated:YES];
                }else {
                    NSInteger sliderValue = [self getSliderCFIValueForChapter:chapter];
                    [viewForSliderBar.pageSlider setValue: sliderValue animated:YES];
                }
                break;
            }
        }
    }
}
-(void)navigateToPageWithPageId:(NSString *)pageId
{
    if (![pageId isEqualToString:@"null"]) {
        [self navigateTopage:pageId];
    }
}

/**
 Returns the array of TOC Content data
 */
- (NSArray *)getTOCContentData{
    return [currentBook getBookContentForTOC];
}

/**
 Returns the array of TOC Resource data
 */
- (NSArray *)getTOCResourceData{
    return [currentBook getBookResourcesForTOC];
}

#pragma mark MyData

/**
 Initiates the MyDataViewController and present the MyDataViewController as popover on Reader
 */
-(void)initiateMyDataViewController
{
    _myDataViewController = [[KBMyDataViewController alloc] initWithNibName:@"MyDataViewController"
                                                                     bundle:[NSBundle bundleForClass:[KBMyDataViewController class]]];
}

- (void)showMyData:(UIView *)button
{
    if (_myDataViewController)
    {
        _myDataViewController = nil;
    }
    activeMode=kPlayerActiveModeMyData;
    [self initiateMyDataViewController];
    _myDataViewController.book = currentBook;
    _myDataViewController.delegate = self;
    _myDataViewController.userSettingsModel = _userSettingsModel;
    [_myDataViewController setNoDataLabelTextColor:hdThemeVO.mydata_note_text_color];
    [_myDataViewController setBookOrientationMode:[_rendererView getBookOrientationMode]];
    NSArray *classList = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    if ([classList count] == 0 || classList == nil)
    {
        [_myDataViewController disableShareSettings:YES];
        [_myDataViewController disableShareWithMeTab:YES];
    }
    else{
        if ([_userSettingsModel isSharingEnabled]) {
            [_myDataViewController disableShareSettings:NO];
            [_myDataViewController disableShareWithMeTab:NO];
            if (isShareSettingsDisabled) {
                [_myDataViewController disableShareSettingsIcon:YES];
            }
            if (isNoteNotificationDisabled) {
                [_myDataViewController disableNoteNotification:YES];
            }
        }
        else{
            [_myDataViewController disableShareSettings:YES];
            [_myDataViewController disableShareWithMeTab:YES];
        }
        
    }
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    NSArray *myDataArray = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    [_myDataViewController setData:myDataArray];
    [_myDataViewController setThemeVO:hdThemeVO];
    
    if (isIpad())
    {
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_myDataViewController];
        navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIPopoverPresentationController *popPC = navController.popoverPresentationController;
        popPC.permittedArrowDirections = 0;
        navController.popoverPresentationController.sourceView = self.view;
        [navController setNavigationBarHidden:YES];
        [self presentViewController:navController
                           animated:NO
                         completion:^{
                             [self.playerTopActionBarView resetPlayerActionBarSelection];
                         }];
        
    }
    else
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_myDataViewController];
        [navController setNavigationBarHidden:YES];
        navController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:navController
                           animated:YES
                         completion:^{
                             [self.playerTopActionBarView resetPlayerActionBarSelection];
                         }];
    }
}

#pragma MyDataControllerDelegate Implementation

- (void)didTapOnPrint {
    KBMyDataPrintOptionsController *controller = [KBMyDataPrintOptionsController new];
    controller.delegate = self;
    controller.kbthemeVO = hdThemeVO;
    [self configPrintOptionController:controller];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [_myDataViewController presentViewController:controller animated:YES completion:nil];
}

- (void)didTapOnNotesComment:(SDKHighlightVO *)highlightVO{
    [self showNotesForHighlight:highlightVO forMyDate:YES];
}
/**
 MyDataControllerDelegate Implementation
 */
- (void)didTapOnShareSettings{
    
    if (_shareSettingsController)
    {
        _shareSettingsController = nil;
    }
    _shareSettingsController = [[KBShareSettingsController alloc] initWithNibName:@"ShareSettingsController" bundle:[NSBundle bundleForClass:[KBShareSettingsController class]]];
    _shareSettingsController.delegate = self;
    _shareSettingsController.settingsType = kHighlightShareSettings;
    NSArray *classList = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    [_shareSettingsController setData:classList];
    [_shareSettingsController setThemeVO:hdThemeVO];
    if(isIpad()){
        _shareSettingsController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _shareSettingsController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_shareSettingsController.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [_myDataViewController.navigationController presentViewController:_shareSettingsController animated:YES completion:nil];
    }
    else{
        _shareSettingsController.view.frame = CGRectMake(CGRectGetMaxX(self.view.bounds),
                                                         0.0,
                                                         CGRectGetWidth(self.view.bounds),
                                                         CGRectGetHeight(self.view.bounds));
        [_myDataViewController addChildViewController:_shareSettingsController];
        [_myDataViewController.view addSubview:_shareSettingsController.view];
        [UIView animateWithDuration:0.5
                         animations:^{
                             _shareSettingsController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_myDataViewController.view.frame), CGRectGetHeight(_myDataViewController.view.frame));
                         }];
    }
}

/**
 MyDataControllerDelegate Implementation
 */
- (void)didTapOnNoteShareSettings:(SDKHighlightVO *)highlightVO{
    if (_shareSettingsController)
    {
        _shareSettingsController = nil;
    }
    _shareSettingsController = [[KBShareSettingsController alloc] initWithNibName:@"ShareSettingsController" bundle:[NSBundle bundleForClass:[KBShareSettingsController class]]];
    _shareSettingsController.delegate = self;
    _shareSettingsController.settingsType = kNoteShareSettings;
    _shareSettingsController.highlightVO = highlightVO;
    _shareSettingsController.isFromMydataController = YES;
    NSArray *classList = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    [_shareSettingsController setData:classList];
    [_shareSettingsController setThemeVO:hdThemeVO];
    if(isIpad()){
        _shareSettingsController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _shareSettingsController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_shareSettingsController.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [_myDataViewController.navigationController presentViewController:_shareSettingsController animated:YES completion:nil];
    }
    else{
        _shareSettingsController.view.frame = CGRectMake(CGRectGetMaxX(self.view.bounds),
                                                         0.0,
                                                         CGRectGetWidth(self.view.bounds),
                                                         CGRectGetHeight(self.view.bounds));
        [_myDataViewController.view addSubview:_shareSettingsController.view];
        [_myDataViewController addChildViewController:_shareSettingsController];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _shareSettingsController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_myDataViewController.view.frame), CGRectGetHeight(_myDataViewController.view.frame));
                         }];
    }
}


#pragma ShareSettingsControllerDelegate Implementation

/**
 ShareSettingsControllerDelegate Implementation
 */
- (void)didClickOnShareSettingsCancelButton
{
    
    if((_shareSettingsController.settingsType == kNoteShareSettings || !isIpad()) && (!_shareSettingsController.isFromMydataController || !isIpad()))
        [UIView animateWithDuration:0.5
                         animations:^{
                             _shareSettingsController.view.frame = CGRectMake((CGRectGetWidth(_shareSettingsController.view.frame)), 0, (CGRectGetWidth(_shareSettingsController.view.frame)), CGRectGetHeight(_shareSettingsController.view.frame));
                             [_shareSettingsController.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             [_shareSettingsController.view removeFromSuperview];
                             [_shareSettingsController removeFromParentViewController];
                         }];
    
}


/**
 ShareSettingsControllerDelegate Implementation
 */
- (void)didClickOnShareSettingsSaveButton:(SDKBookClassInfoVO *)bookClassInfoVO
{
    NSMutableDictionary *finalDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    [finalDictionary setObject:bookClassInfoVO.shareList forKey:@"shareList"];
    [finalDictionary setObject:bookClassInfoVO.receiveList forKey:@"recieveList"];
    [_dataSyncManager saveHighlightData:finalDictionary ForBookID:_bookID ForUserToken:_user.userToken];
    [_dbManager saveSharedReceivedInfo:finalDictionary ofBook:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    
    if(!isIpad())
        [UIView animateWithDuration:0.5
                         animations:^{
                             _shareSettingsController.view.frame = CGRectMake((CGRectGetWidth(_shareSettingsController.view.frame)), 0, (CGRectGetWidth(_shareSettingsController.view.frame)), CGRectGetHeight(_shareSettingsController.view.frame));
                             [_shareSettingsController.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             [_shareSettingsController.view removeFromSuperview];
                             [_shareSettingsController removeFromParentViewController];
                         }];
}

/**
 ShareSettingsControllerDelegate Implementation
 */
- (void)didClickOnNoteShareSettingsSaveButton:(SDKHighlightVO *)highlightVO
{
    HDKitabooAnalyticsMetaData *analyticsMetaData = [[HDKitabooAnalyticsMetaData alloc] initWithUGCTracking:highlightVO.displayNum uniqueId:highlightVO.localID];
    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteShared metadata:analyticsMetaData];
    [self didTapOnPostNote:highlightVO];
    if(_shareSettingsController.isFromMydataController){
        NSArray *myDataArray = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [_myDataViewController setData:myDataArray];
        [_myDataViewController reloadMyDataTableView];
        if(!isIpad())
            [UIView animateWithDuration:0.5
                             animations:^{
                                 _shareSettingsController.view.frame = CGRectMake((CGRectGetWidth(_shareSettingsController.view.frame)), 0, (CGRectGetWidth(_shareSettingsController.view.frame)), CGRectGetHeight(_shareSettingsController.view.frame));
                                 [_shareSettingsController.view layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 [_shareSettingsController.view removeFromSuperview];
                                 [_shareSettingsController removeFromParentViewController];
                             }];
    }
    else{
        [_noteController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

/**
 ShareSettingsControllerDelegate Implementation
 */
- (void)didAnsweredHighlight:(SDKHighlightVO *)highlightVO accepted:(BOOL)accepted{
    if (accepted) {
        HDKitabooAnalyticsMetaData *analyticsMetaData = [[HDKitabooAnalyticsMetaData alloc] initWithUGCTracking:highlightVO.displayNum uniqueId:highlightVO.localID];
        [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeNoteReceived metadata:analyticsMetaData];
    }
    [_dataSyncManager acceptOrRejectCollab:highlightVO.ugcID andIsAccepted:accepted ForUserToken:_user.userToken];
}


#pragma mark BookMarkViewDelegate Implementation
/**
 BookMarkViewDelegate Implementation
 */
- (void)didTapOnBookMark:(BookMarkView *)bookmarkView
{
    [self closeAudioSync];
    if (activeMode == kPlayerActiveModeGlossary) {
        [self removeGlossaryController];
    }
    if (activeMode == kPlayerActiveModeHighlight) {
        [self removeHighlightPopup];
    }
    if (activeMode == kPlayerActiveModeInstruction) {
        [self removeInstructionMarkupPopOver];
    }
    if (activeMode == kPlayerActiveModeBookmark && [bookmarkView.bookmarkVO isEqual:_bookMarkController.getBookmarkVO]) {
        return;
    }
    else
    {
        activeMode = kPlayerActiveModeBookmark;
        
        _bookMarkController = [[BookMarkController alloc] initWithNibName:@"BookMarkController"
                                                                   bundle:[NSBundle bundleForClass:[BookMarkController class]]];
        _bookMarkController.delegate = self;
        [_bookMarkController setBookmarkVO:[_rendererView getBookmarkVOForPageNo:[bookmarkView.pageNumber integerValue]]];
        _bookMarkController.view.backgroundColor = [UIColor clearColor];
        UIView *mainView =  [_bookMarkController.view.subviews objectAtIndex:0];
        mainView.translatesAutoresizingMaskIntoConstraints = NO;
        mainView.clipsToBounds = YES;
        [mainView.leadingAnchor constraintEqualToAnchor:_bookMarkController.view.leadingAnchor constant:2].active = YES;
        [mainView.trailingAnchor constraintEqualToAnchor:_bookMarkController.view.trailingAnchor constant:-2].active = YES;
        [mainView.topAnchor constraintEqualToAnchor:_bookMarkController.view.topAnchor constant:2].active = YES;
        [mainView.bottomAnchor constraintEqualToAnchor:_bookMarkController.view.bottomAnchor constant:-2].active = YES;
        mainView.backgroundColor = hdThemeVO.bookmark_input_panel_bg;
        mainView.layer.cornerRadius = 11;
        mainView.layer.borderWidth = 1;
        mainView.layer.borderColor = hdThemeVO.bookmark_popup_border.CGColor;
        
        UITextField *textFieldView =  [mainView.subviews objectAtIndex:0];
        if([textFieldView isKindOfClass:[UITextField class]]){
            textFieldView.translatesAutoresizingMaskIntoConstraints = NO;
            [textFieldView.leadingAnchor constraintEqualToAnchor:mainView.leadingAnchor constant:12].active = YES;
            [textFieldView.trailingAnchor constraintEqualToAnchor:mainView.trailingAnchor constant:-12].active = YES;
            [textFieldView.topAnchor constraintEqualToAnchor:mainView.topAnchor].active = YES;
            [textFieldView.bottomAnchor constraintEqualToAnchor:mainView.bottomAnchor].active = YES;
            textFieldView.font = getCustomFont(isIPAD? 20 : 18);
            textFieldView.textColor = hdThemeVO.bookmark_text_color;
            if ([textFieldView respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                textFieldView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFieldView.placeholder attributes:@{NSForegroundColorAttributeName: hdThemeVO.bookmark_hint_text_color}];
            }
            
        }
        
        if (isIpad())
        {
            _bookMarkController.modalPresentationStyle = UIModalPresentationPopover;
            _bookMarkController.preferredContentSize = CGSizeMake(256, 46);
            _bookMarkController.view.clipsToBounds = YES;
            _bookMarkController.view.layer.cornerRadius = 0;
            [self presentViewController:_bookMarkController animated:YES completion:nil];
            UIPopoverPresentationController *popoverpresentationController = [_bookMarkController popoverPresentationController];
            popoverpresentationController.permittedArrowDirections = 0;
            popoverpresentationController.delegate = self;
            popoverpresentationController.sourceView = bookmarkView;
            popoverpresentationController.sourceRect = bookmarkView.bounds;
            popoverpresentationController.backgroundColor = [UIColor clearColor];
            [_bookMarkController setBackgroundColorForView:[NSString stringWithFormat:@"#%@",[hdThemeVO.bookmark_input_panel_bg hexStringFromColor]]];
        }
        else{
            sliderPageDetailsView = [[UIView alloc]init];
            [self.view addSubview: sliderPageDetailsView];
            sliderPageDetailsView.translatesAutoresizingMaskIntoConstraints = false;
            
            [sliderPageDetailsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = true;
            [sliderPageDetailsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = true;
            [sliderPageDetailsView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = true;
            [sliderPageDetailsView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSingleTapToRemoveBookMark:)];
            singleTap.numberOfTapsRequired = 1;
            [sliderPageDetailsView addGestureRecognizer:singleTap];
            
            _bookMarkController.view.layer.masksToBounds = NO;
            _bookMarkController.view.layer.shadowColor = [UIColor blackColor].CGColor;
            _bookMarkController.view.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
            _bookMarkController.view.layer.shadowOpacity = 0.4f;
            
            [self addChildViewController:_bookMarkController];
            [self.view addSubview:_bookMarkController.view];
            _bookMarkController.view.translatesAutoresizingMaskIntoConstraints = NO;
            [_bookMarkController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16].active = YES;
            [_bookMarkController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:48].active = YES;
            [_bookMarkController.view.widthAnchor constraintEqualToConstant:260].active = YES;
            [_bookMarkController.view.heightAnchor constraintEqualToConstant:43].active = YES;
            [_bookMarkController setBackgroundColorForView:[NSString stringWithFormat:@"#%@",[hdThemeVO.bookmark_input_panel_bg hexStringFromColor]]];
            
        }
        
    }
    
}
-(void)didSingleTapToRemoveBookMark:(UITapGestureRecognizer*)gesture
{
    [self removeBookmarkVC];
}
/**
 BookMarkViewDelegate Implementation
 */
- (void)didBookmarkCompleteWithBookmarkVO:(SDKBookmarkVO *)bookmarkVO
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.bookmarkEventName eventInfo:nil];
    if (bookmarkVO)
    {
        [_rendererView setBookmarkVO:bookmarkVO];
        
        if (bookmarkVO.status == DELETE)
        {
            [_dbManager deleteBookmark:bookmarkVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
            [self removeBookmarkVC];
            
        }
        else
        {
            [_dbManager saveBookmark:bookmarkVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        }
    }
}


/**
 Remove the BookmarkView from ReaderViewController
 */
- (void)removeBookmarkVC
{
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    if (isIpad())
    {
        [_bookMarkController dismissViewControllerAnimated:NO completion:nil];
        [self resetAllPlayerActionBar];
        _bookMarkController = nil;
    }
    else
    {
        [sliderPageDetailsView removeFromSuperview];
        sliderPageDetailsView = nil;
        [_bookMarkController removeFromParentViewController];
        [_bookMarkController.view removeFromSuperview];
        [self resetAllPlayerActionBar];
        _bookMarkController = nil;
    }
}

/**
 Add the BookmarkView on the page where bookmark tapped
 */
- (void)addBookmarkOnPageNumber:(NSString*)pageNo OnDisplayNumber:(NSString*)displayNum
{
    BookMarkView *_bookMarkView = [[BookMarkView alloc] initWithBookmarkIcon:@"q" WithSelectedBookmarkIcon:@"p"];
    [_bookMarkView setPageNumber:[NSNumber numberWithInteger:[pageNo integerValue]]];
    [_bookMarkView setDelegate:self];
    [_rendererView addBookmarkView:_bookMarkView onPageNO:[pageNo integerValue]];
    _bookMarkView.tag = 40;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSArray* bookmarks = [_dbManager bookmarkForPageID:pageNo ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (bookmarks.count)
            {
                [_rendererView addBookmark:bookmarks OnPageNo:[pageNo integerValue]];
            }
            [_bookMarkView setBookmarkColorForNormalState:hdThemeVO.bookmark_icon_color];
            [_bookMarkView setBookmarkColorForSelectedState:hdThemeVO.bookmark_selected_icon_color];
        });
    });
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((UIInterfaceOrientationIsPortrait(interfaceOrientation)) || (pageNo.intValue % 2 != 0)) {
        helpBookmark = _bookMarkView;
        if (self.helpScreen) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.helpScreen.helpDescriptors = [self getAllAppBarButton];
                [self.helpScreen setUpViews];
            });
            
        }
    }
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didUpdateBookmarkVOFrom:(SDKBookmarkVO *)bookmarkVO To:(SDKBookmarkVO *)updatedBookmarkVO
{
    
}


#pragma mark Notes

-(void)showNotesForHighlight:(SDKHighlightVO*)highlight forMyDate:(BOOL)isForMyData
{
    if (activeMode == kPlayerActiveModeGlossary) {
        [self removeGlossaryController];
    }
    if (_noteController)
    {
        _noteController = nil;
    }
    activeMode=kPlayerActiveModeNote;
    
    _noteController = [[StickyNotesViewController alloc] initWithNibName:@"StickyNotesViewController" bundle:[NSBundle bundleForClass:[ReaderViewController class]]];
    //    [_noteController showShareButton:YES];
    [_noteController setCurrentUser:_user];
    _noteController.userSettingsModel = _userSettingsModel;
    __weak typeof(self) weakSelf = self;
    
    _noteController.currentHighlightVO = highlight;
    [_noteController setNotePostAction:^(SDKHighlightVO *currentHighLightVO) {
        [weakSelf didTapOnPostNote:currentHighLightVO];
    }];
    [_noteController setNoteCancelAction:^(SDKHighlightVO *currentHighLightVO) {
        
        [weakSelf didTapOnCancelNote:currentHighLightVO];
    }];
    
    [_noteController setNoteDeleteAction:^(SDKHighlightVO *currentHighLightVO) {
        [weakSelf didTapOnDeleteNote:currentHighLightVO];
    }];
    
    [_noteController setPostCommentAction:^(SDKHighlightVO *currentHighLightVO) {
        currentHighLightVO.isSynced=NO;
        currentHighLightVO.status = UPDATE;
        [weakSelf didTapOnPostNoteComment:currentHighLightVO];
    }];
    [_noteController setNoteShareAction:^(SDKHighlightVO *currentHighLightVO,NSString *selectedColor,NSString* noteText) {
        [weakSelf didTapOnShareNote:currentHighLightVO withSelectedColor:selectedColor withNoteText:noteText];
    }];
    
    [_noteController setTheme:hdThemeVO];
    if (isIpad())
    {
        _noteController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        UIPopoverPresentationController *popPC = _noteController.popoverPresentationController;
        popPC.permittedArrowDirections = 0;
        _noteController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _noteController.popoverPresentationController.sourceView = self.view;
        if(isForMyData)
            [_myDataViewController.navigationController presentViewController:_noteController animated:YES completion:nil];
        else
            if (!self.navigationController) {
                [self presentViewController:_noteController animated:YES completion:nil];
            }
            else{
                [self.navigationController presentViewController:_noteController animated:YES completion:nil];
            }
    }
    else
    {
        _noteController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if(isForMyData)
            [_myDataViewController.navigationController presentViewController:_noteController animated:YES completion:nil];
        else
            if (!self.navigationController) {
                [self presentViewController:_noteController animated:YES completion:^{
                    
                }];
            }else{
                [self.navigationController presentViewController:_noteController animated:YES completion:^{
                    
                }];
            }
        
    }
    NSArray *classList = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    if ([classList count] == 0 || classList == nil)
    {
        [_noteController showShareButton:NO];
    }
    else{
        if ([_userSettingsModel isSharingEnabled]) {
            [_noteController showShareButton:YES];
        }
        else{
            [_noteController showShareButton:NO];
        }
    }
}

-(void)showNoteForTeacherCommentWithFib:(SDKFIBVO*)fibVo
{
    SDKHighlightVO *highlight = [[SDKHighlightVO alloc] init];
    highlight.ugcID = fibVo.ugcID;
    highlight.isTeacherReviewNote = true;
    highlight.noteText = fibVo.teacherComment;
    StickyNotesViewController *teacherNoteController = [[StickyNotesViewController alloc] initWithNibName:@"StickyNotesViewController" bundle:[NSBundle bundleForClass:[ReaderViewController class]]];
    [teacherNoteController setCurrentUser:_user];
    teacherNoteController.userSettingsModel = _userSettingsModel;
    //__weak typeof(self) weakSelf = self;
    teacherNoteController.currentHighlightVO = highlight;
    [teacherNoteController setNotePostAction:^(SDKHighlightVO *currentHighLightVO) {
        SDKFIBVO *currentFibVo;
        if (_teacherAnnotationController && _teacherAnnotationController.selectedFibArray.count > 0) {
            for (SDKFIBVO * eachfibVo in _teacherAnnotationController.selectedFibArray) {
                currentFibVo = eachfibVo;
                if (!eachfibVo.commentCreatedDate) {
                    eachfibVo.commentCreatedDate = [NSDate date];
                }
                eachfibVo.commentModifiedDate = [NSDate date];
                eachfibVo.teacherComment = currentHighLightVO.noteText;
                [_teacherAnnotationController updateFIBData:eachfibVo];
            }
            if (currentFibVo) {
                [self refreshTeacherReviewPage:currentFibVo.pageIdentifier.numberValue];
            }
        }
        _teacherAnnotationController.selectedFibArray = nil;
    }];
    [teacherNoteController setNoteCancelAction:^(SDKHighlightVO *currentHighLightVO) {
        _teacherAnnotationController.selectedFibArray = nil;
    }];
    [teacherNoteController setNoteDeleteAction:^(SDKHighlightVO *currentHighLightVO) {
        SDKFIBVO *currentFibVo;
        if (_teacherAnnotationController && _teacherAnnotationController.selectedFibArray.count > 0) {
            for (SDKFIBVO * eachfibVo in _teacherAnnotationController.selectedFibArray) {
                currentFibVo = eachfibVo;
                eachfibVo.commentCreatedDate = nil;
                eachfibVo.commentModifiedDate = nil;
                eachfibVo.teacherComment = @"";
                [_teacherAnnotationController updateFIBData:eachfibVo];
            }
            if (currentFibVo) {
                [self refreshTeacherReviewPage:currentFibVo.pageIdentifier.numberValue];
            }
        }
        _teacherAnnotationController.selectedFibArray = nil;
    }];
    [teacherNoteController setTheme:hdThemeVO];
    if (isIpad())
    {
        teacherNoteController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIPopoverPresentationController *popPC = teacherNoteController.popoverPresentationController;
        popPC.permittedArrowDirections = 0;
        teacherNoteController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        teacherNoteController.popoverPresentationController.sourceView = self.view;
        if (!self.navigationController) {
            [self presentViewController:teacherNoteController animated:YES completion:nil];
        }
        else{
            [self.navigationController presentViewController:teacherNoteController animated:YES completion:nil];
        }
    }
    else
    {
        teacherNoteController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (!self.navigationController) {
            [self presentViewController:teacherNoteController animated:YES completion:^{
                
            }];
        }else{
            [self.navigationController presentViewController:teacherNoteController animated:YES completion:^{
                
            }];
        }
    }
    [teacherNoteController showShareButton:NO];
}

- (void)didTapOnCancelNote:(SDKHighlightVO *)highlight
{
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    [self resetAllPlayerActionBar];
    if(!isIpad())
        [_rendererView reloadPages];
}
- (void)didTapOnPostNote:(SDKHighlightVO *)highlight
{
    if ([highlight isStickyNote]) {
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.stickyNoteEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:highlight.backgroundColor,KitabooReaderEventConstant.stickyNoteEventParameterNoteColor, nil]];
    }else{
        [analyticsHandler notifyEvent:KitabooReaderEventConstant.contextualNoteEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:highlight.backgroundColor,KitabooReaderEventConstant.contextualNoteEventParameterNoteColor, nil]];
    }
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    [_rendererView postNoteWithHighlightVO:highlight];
}
- (void)didTapOnDeleteNote:(SDKHighlightVO *)highlight
{
    highlight.status = DELETE;
    highlight.isSynced = NO;
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    [_rendererView deleteNoteWithHighlightVO:highlight];
    [self resetAllPlayerActionBar];
    [_rendererView reloadPages];
}

-(void)didTapOnPostNoteComment:(SDKHighlightVO *)highlight
{
    [_dbManager saveHighlight:highlight bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
}

- (void)didTapOnShareNote:(SDKHighlightVO *)highlight withSelectedColor:(NSString*)selectedColor withNoteText:(NSString *)noteText
{
    if (_shareSettingsController)
    {
        _shareSettingsController = nil;
    }
    _shareSettingsController = [[KBShareSettingsController alloc] initWithNibName:@"ShareSettingsController" bundle:[NSBundle bundleForClass:[KBShareSettingsController class]]];
    _shareSettingsController.delegate = self;
    _shareSettingsController.settingsType = kNoteShareSettings;
    _shareSettingsController.highlightVO = highlight;
    _shareSettingsController.noteText = noteText;
    [_shareSettingsController setSelectedColor:selectedColor];
    [_shareSettingsController setThemeVO:hdThemeVO];
    NSArray *classList = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    [_shareSettingsController setData:classList];
    _shareSettingsController.view.frame = CGRectMake(CGRectGetMaxX(self.view.bounds),
                                                     0.0,
                                                     CGRectGetWidth(self.view.bounds),
                                                     CGRectGetHeight(self.view.bounds));
    
    [_noteController.stickyNoteContainerView addSubview:_shareSettingsController.view];
    [_noteController addChildViewController:_shareSettingsController];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         _shareSettingsController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_noteController.view.frame), CGRectGetHeight(_noteController.view.frame));
                     }];
    
    _shareSettingsController.view.translatesAutoresizingMaskIntoConstraints =NO;
    [_noteController.stickyNoteContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_shareSettingsController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_noteController.stickyNoteContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_noteController.stickyNoteContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_shareSettingsController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_noteController.stickyNoteContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_noteController.stickyNoteContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_shareSettingsController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_noteController.stickyNoteContainerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [_noteController.stickyNoteContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_shareSettingsController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_noteController.stickyNoteContainerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    switch (activeMode) {
        case kPlayerActiveModeBookmark:
        {
            [_bookMarkController resignFirstResponder];
            activeMode=kPlayerActiveModeNone;
        }
            break;
        case kPlayerActiveModeNote:
        {
            activeMode=kPlayerActiveModeNone;
        }
            break;
        case kPlayerActiveModeSearchText:
        {
            [self resignSearchTextField];
            [self removeSearchController];
        }
            break;
        case kPlayerActiveModeTOC:
        case kPlayerActiveModeMyData:
        {
            activeMode = kPlayerActiveModeNone;
        }
            break;
        case kPlayerActiveModeReflowableLayout:
        {
            activeMode = kPlayerActiveModeNone;
        }
            break;
        case kPlayerActiveModeFIB:
        {
            activeMode = kPlayerActiveModeNone;
        }
        case kPlayerActiveModeGlossary:
        {
            activeMode = kPlayerActiveModeNone;
        }
            break;
        default:
            break;
    }
    //activeMode=kPlayerActiveModeNone;
    [self resetAllPlayerActionBar];
}

#pragma mark Sticky Note Controller Delegate

-(void)didTapOnStickNoteController:(StickyNoteController*)stickyNoteController AtPoint:(CGPoint)tapPoint
{
    SDKHighlightVO *sdkHighlightVO = [_rendererView getHighlightVOForStickyNoteTouchPoint:tapPoint];
    [self removeStickNoteController:stickyNoteController];
    if(sdkHighlightVO)
    {
        [self showNotesForHighlight:sdkHighlightVO forMyDate:NO];
    }
    else
    {
        [KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:@"Invalid Points" verboseMesage:@""];
    }
}

-(void)removeStickNoteController:(StickyNoteController*)stickNoteController
{
    [stickNoteController removeFromSuperview];
    stickNoteController=nil;
}

- (void)bookDownloadRequestCanceled:(HDBookDownloadDetails *)bookDownloadDetail bookID:(NSString *)bookID
{
}

- (void)bookDownloadRequestDidPopulatedInterruptedTasks:(NSArray<HDBookDownloadDetails *> *)bookDownloadDetail
{
    
}

#pragma mark Teacher Review

-(void)actionForTeacherReview {
//    activeMode = kPlayerActiveModeTeacherReview;
    TeacherReviewClassListViewController *classList = [[TeacherReviewClassListViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    __weak typeof(classList) weakclassList = classList;
    [classList setRemoveAnnotataionController:^{
        [weakSelf removeAnnotationController];
    }];
    [classList setDidSelectClassName:^(NSString *className, NSArray *learnerList) {
        [weakclassList closeViewController];
        [weakSelf actionForTeacherReviewLearnerList:className withStudentList:learnerList];
    }];
    [classList setClassesWithClassesInfoArray:[_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]]];
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    _activePageBeforeStudentReviewMode = [_rendererView getActivePages];
    if (isIpad())
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:classList];
        navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIPopoverPresentationController *popPC = navController.popoverPresentationController;
        popPC.permittedArrowDirections = 0;
        navController.popoverPresentationController.sourceView = self.view;
        [navController setNavigationBarHidden:YES];
        [self presentViewController:navController
                           animated:YES
                         completion:^{
                         }];
        
    }
    else
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:classList];
        navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [navController setNavigationBarHidden:YES];
        [self presentViewController:navController
                           animated:YES
                         completion:^{
                             //                             [playerTopActionBarView resetPlayerActionBarSelection];
                         }];
    }
}

-(void)actionForTeacherReviewLearnerList:(NSString*)className withStudentList:(NSArray*)studentList {
    _teacherAnnotationController = [[TeacherReviewViewController alloc] init];
    [_teacherAnnotationController setThemeVo:hdThemeVO];
    [_teacherAnnotationController setDataWithClassName:className studentList:studentList];
    __weak typeof(self) weakSelf = self;
    [_teacherAnnotationController setRemoveAnnotataionController:^{
        [weakSelf removeAnnotationController];
    }];
    
    [_teacherAnnotationController setDidTapOnChangeClassButton:^{
        [weakSelf actionForTeacherReview];
    }];
    
    [_teacherAnnotationController setFetchEachLearnerData:^(NSString *learnerName, NSString *learnerId) {
        [weakSelf didSelectLearner:learnerName WithLearnerID:learnerId];
    }];
    
    [_teacherAnnotationController setLearnerSelectionAction:^(NSArray *learnerDict, NSString *learnerId) {
        if (activeMode != kPlayerActiveModeTeacherReview) {
            activeMode = kPlayerActiveModeTeacherReview;
        }
        [weakSelf setSelectedLearnerData:learnerDict withLearnerID:learnerId];
        [weakSelf updateNextPrevStudentButtonStatus];
    }];

    if (isIpad())
    {
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_teacherAnnotationController];
        navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIPopoverPresentationController *popPC = navController.popoverPresentationController;
        popPC.permittedArrowDirections = 0;
        navController.popoverPresentationController.sourceView = self.view;
        [navController setNavigationBarHidden:YES];
        [self presentViewController:navController
                           animated:YES
                         completion:^{
                         }];
        
    }
    else
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_teacherAnnotationController];
        navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [navController setNavigationBarHidden:YES];
        [self presentViewController:navController
                           animated:YES
                         completion:^{
                         }];
    }
    
}

-(UIViewController *) getTeacherAnnocationViewController
{
    return [[TeacherAnnotationViewController alloc]init];;
}

-(void)removeAnnotationController
{
    if (penToolActionBarView)
    {
        activeMode=kPlayerActiveModeTeacherReview;
    }else
    {
        activeMode=kPlayerActiveModeNone;
    }
}

-(void)removeTeacherAnnotation
{
    activeMode=kPlayerActiveModeNone;
    [_teacherAnnotationController dismissViewControllerAnimated:YES completion:nil];
    topConstOfTeacherReview.constant = -(penToolBar_Height);
    if (!isIpad())
    {
        bottomConstOfTeacherReview.constant = penToolBar_Height;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        [penToolActionBarView removeFromSuperview];
        penToolActionBarView = nil;
        [penToolActionBottomBarView removeFromSuperview];
        penToolActionBottomBarView = nil;
    }];
    [self resetAllPlayerActionBar];
}

-(void)addTeacherAnnotationTopBar{
    if(penToolActionBarView == nil && penToolActionBottomBarView == nil)
    {
        PlayerActionBarItem *item;
        if (isIpad())
        {
            [self addTeacherReviewTopBarView];
            [self addTeacherReviewBottomBarView];
            [penToolActionBarView resetPlayerActionBarSelection];
            item = [self getPenToolItemWithTag:kPlayerActionBarItemTypePenColor];
            [item.metaData setValue:GreenColor forKey:@"penColor"];
            [penToolActionBarView updateSelectedPenColor:GreenColor withTheme:hdThemeVO];
        }else
        {
            [self addTeacherReviewTopBarView];
            [self addTeacherReviewBottomBarView];
            [penToolActionBarView resetPlayerActionBarSelection];
            [penToolActionBottomBarView resetPlayerActionBarSelection];
            for (PlayerActionBarItem *playerActionBarItem in [penToolActionBottomBarView getTappableItems]) {
                if(playerActionBarItem.tag==kPlayerActionBarItemTypePenColor)
                {
                    item =  playerActionBarItem;
                    [item.metaData setValue:GreenColor forKey:@"penColor"];
                    [penToolActionBottomBarView updateSelectedPenColor:GreenColor withTheme:hdThemeVO];
                    return;
                }
            }
        }
    }
}

-(void)addTeacherAnnotaionTopBarViewForIPhone
{
    penToolActionBarView =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    penToolActionBarView.delegate =self;
    penToolActionBarView.user = _user;
    penToolActionBarView.backgroundColor = hdThemeVO.teacherSettings_popup_background;
    penToolActionBarView.tag = kPlayerActionBarItemTypeTeacherReview;
    [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
    [self.view addSubview:penToolActionBarView];
    penToolActionBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [penToolActionBarView addPlayerTopBarForTeacherAnnotationForIPhone:hdThemeVO studentName:_teacherAnnotationController.selectedLearnerName andImageUrl:_teacherAnnotationController.selectedLearnerImageUrl withAllTeacherAnnotationPages:[self getSortedPageArrayOfStudentSubmitedUgc]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.4]];
    topConstOfTeacherReview = [NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-penToolBar_Height];
    [self.view addConstraint:topConstOfTeacherReview];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:penToolBar_Height]];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        topConstOfTeacherReview.constant = -0.4;
        [self.view layoutIfNeeded];
    }];
    penToolActionBarView.layer.borderColor = hdThemeVO.teacherSettings_popup_border.CGColor;
    penToolActionBarView.layer.borderWidth = 1.0;
    penToolActionBarView.layer.masksToBounds = false;
    penToolActionBarView.layer.shadowOffset = CGSizeMake(0,-1);
    penToolActionBarView.layer.shadowRadius = 4.0;
    penToolActionBarView.layer.shadowOpacity = 0.6;
    if ([self getSortedPageArrayOfStudentSubmitedUgc].count == 1)
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].userInteractionEnabled = NO;
    }else
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
    }
    [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
}

-(void)addTeacherReviewTopBarView
{
    penToolActionBarView =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    penToolActionBarView.delegate =self;
    penToolActionBarView.user = _user;
    penToolActionBarView.backgroundColor = hdThemeVO.teacherSettings_popup_background;
    penToolActionBarView.tag = kPlayerActionBarItemTypeTeacherReview;
    [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
    [self.view addSubview:penToolActionBarView];
    penToolActionBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [penToolActionBarView addPlayerTopBarForTeacherReviewAnnotation:hdThemeVO studentName:_teacherAnnotationController.selectedLearnerName imageUrl:_teacherAnnotationController.selectedLearnerImageUrl studentCount:[_teacherAnnotationController getStudentCount] studentIndex:[_teacherAnnotationController getStudentIndex]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.4]];
    topConstOfTeacherReview = [NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-penToolBar_Height];
    [self.view addConstraint:topConstOfTeacherReview];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:penToolBar_Height]];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        topConstOfTeacherReview.constant = -0.4;
        [self.view layoutIfNeeded];
    }];
    penToolActionBarView.layer.borderColor = hdThemeVO.teacherSettings_popup_border.CGColor;
    penToolActionBarView.layer.borderWidth = 1.0;
    penToolActionBarView.layer.masksToBounds = false;
    penToolActionBarView.layer.shadowOffset = CGSizeMake(0,-1);
    penToolActionBarView.layer.shadowRadius = 4.0;
    penToolActionBarView.layer.shadowOpacity = 0.6;
    if ([self getSortedPageArrayOfStudentSubmitedUgc].count == 1)
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].userInteractionEnabled = NO;
    }else
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
    }
    [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
}

-(void)addTeacherReviewBottomBarView
{
    penToolActionBottomBarView =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    penToolActionBottomBarView.delegate =self;
    penToolActionBottomBarView.user = _user;
    penToolActionBottomBarView.backgroundColor = hdThemeVO.teacherSettings_popup_background;
    penToolActionBottomBarView.tag = kPlayerActionBarItemTypeTeacherReview;
    [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
    [self.view addSubview:penToolActionBottomBarView];
    penToolActionBottomBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [penToolActionBottomBarView addPlayerBottomBarForTeacherReviewAnnotation:hdThemeVO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.4]];
    bottomConstOfTeacherReview = [NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:penToolBar_Height];
    [self.view addConstraint:bottomConstOfTeacherReview];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:penToolBar_Height]];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        bottomConstOfTeacherReview.constant = 0.4;
        [self.view layoutIfNeeded];
    }];
    penToolActionBottomBarView.layer.borderColor = hdThemeVO.teacherSettings_popup_border.CGColor;
    penToolActionBottomBarView.layer.borderWidth = 1.0;
    penToolActionBottomBarView.layer.masksToBounds = false;
    penToolActionBottomBarView.layer.shadowOffset = CGSizeMake(0,-1);
    penToolActionBottomBarView.layer.shadowRadius = 4.0;
    penToolActionBottomBarView.layer.shadowOpacity = 0.6;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].userInteractionEnabled = NO;
//    [self getPenToolItemWithTag:kPenToolBarItemTypeRedo].alpha=0.5;
//    [self getPenToolItemWithTag:kPenToolBarItemTypeRedo].userInteractionEnabled = NO;
    [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
}

-(void)addTeacherAnnotaionBottomBarViewForIPhone
{
    penToolActionBottomBarView =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    penToolActionBottomBarView.delegate =self;
    penToolActionBottomBarView.user = _user;
    penToolActionBottomBarView.backgroundColor = hdThemeVO.teacherSettings_popup_background;
    penToolActionBottomBarView.tag = kPlayerActionBarItemTypeTeacherReview;
    [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
    [self.view addSubview:penToolActionBottomBarView];
    penToolActionBottomBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [penToolActionBottomBarView addPlayerBottomBarForTeacherAnnotationForIPhone:hdThemeVO withPenColors:@[[hdThemeVO.teacherSettings_pen1_color hexStringFromColor],[hdThemeVO.teacherSettings_pen2_color hexStringFromColor]] withSelectedPenColor:penToolController.getPenColor];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.4]];
    bottomConstOfTeacherReview = [NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:penToolBar_Height];
    [self.view addConstraint:bottomConstOfTeacherReview];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBottomBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:penToolBar_Height]];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        bottomConstOfTeacherReview.constant = 0.4;
        [self.view layoutIfNeeded];
    }];
    penToolActionBottomBarView.layer.borderColor = hdThemeVO.teacherSettings_popup_border.CGColor;
    penToolActionBottomBarView.layer.borderWidth = 1.0;
    penToolActionBottomBarView.layer.masksToBounds = false;
    penToolActionBottomBarView.layer.shadowOffset = CGSizeMake(0,-1);
    penToolActionBottomBarView.layer.shadowRadius = 4.0;
    penToolActionBottomBarView.layer.shadowOpacity = 0.6;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].userInteractionEnabled = NO;
//    [self getPenToolItemWithTag:kPenToolBarItemTypeRedo].alpha=0.5;
//    [self getPenToolItemWithTag:kPenToolBarItemTypeRedo].userInteractionEnabled = NO;
    [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
}

-(void)addTeacherAnnotaionTopBarViewForIPad
{
    penToolActionBarView =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    penToolActionBarView.delegate =self;
    penToolActionBarView.user = _user;
    penToolActionBarView.backgroundColor = hdThemeVO.teacherSettings_popup_background;
    penToolActionBarView.tag = kPlayerActionBarItemTypeTeacherReview;
    [penToolActionBarView addPlayerTopBarForTeacherAnnotationForIPad:hdThemeVO withPenColors:@[[hdThemeVO.teacherSettings_pen1_color hexStringFromColor],[hdThemeVO.teacherSettings_pen2_color hexStringFromColor]] studentName:_teacherAnnotationController.selectedLearnerName andImageUrl:_teacherAnnotationController.selectedLearnerImageUrl withSelectedPenColor:penToolController.getPenColor withCurrentPageNumber:@""];
    [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
    [self.view addSubview:penToolActionBarView];
    penToolActionBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.4]];
    topConstOfTeacherReview = [NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-penToolBar_Height];
    [self.view addConstraint:topConstOfTeacherReview];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:penToolBar_Height]];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        topConstOfTeacherReview.constant = -0.4;
        [self.view layoutIfNeeded];
    }];
    penToolActionBarView.layer.borderColor = hdThemeVO.teacherSettings_popup_border.CGColor;
    penToolActionBarView.layer.borderWidth = 0.4;
    penToolActionBarView.layer.masksToBounds = false;
    penToolActionBarView.layer.shadowOffset = CGSizeMake(0,-1);
    penToolActionBarView.layer.shadowRadius = 4.0;
    penToolActionBarView.layer.shadowOpacity = 0.6;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].userInteractionEnabled = NO;
    [self getPenToolItemWithTag:kPenToolBarItemTypeRedo].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeRedo].userInteractionEnabled = NO;
    if ([self getSortedPageArrayOfStudentSubmitedUgc].count == 1)
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].userInteractionEnabled = NO;
    }else
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
    }
    [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
}

-(void)didSelectDoneForTeacherReviewWithUpdatedAnotations:(NSArray *)anotations ForLearnerID:(NSString *)learnerID
{
    doneButtonSelectedForTeacherReview = YES;
    [self addIndicatorViewForTeacherReview];
    [_dataSyncManager saveTeacherAnnotationsForAnnotation:anotations forLearnerID:learnerID withBookID:_bookID WithDelegate:self WithUserToken:_user.userToken];
}

-(void)addIndicatorViewForTeacherReview
{
    activityViewForTeacherReview = [[UIView alloc]init];
    activityViewForTeacherReview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:activityViewForTeacherReview];
    activityViewForTeacherReview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [activityViewForTeacherReview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [activityViewForTeacherReview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [activityViewForTeacherReview.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [activityViewForTeacherReview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    [activityViewForTeacherReview addSubview:activityIndicator];
    activityIndicator.translatesAutoresizingMaskIntoConstraints =NO;
    
    [activityViewForTeacherReview addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:activityViewForTeacherReview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [activityViewForTeacherReview addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:activityViewForTeacherReview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = NSLocalizedStringFromTableInBundle(@"SAVING_THE_DATA",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil);
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    [activityViewForTeacherReview addSubview:label];
    
    [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [label.topAnchor constraintEqualToAnchor:activityIndicator.bottomAnchor constant:10].active = YES;
    [label.heightAnchor constraintEqualToConstant:50].active = YES;
    [label.widthAnchor constraintGreaterThanOrEqualToConstant:100].active = YES;
}

-(void)loadPagesBeforeTeacherReview
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        for (KFPageVO *page in _activePageBeforeStudentReviewMode)
        {
            [UIView animateWithDuration:0.4 animations:^{
                
                [_rendererView navigateToPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
            }];
            return;
        }
    }
    else
    {
        for (EPUBPage *page in _activePageBeforeStudentReviewMode)
        {
            [UIView animateWithDuration:0.4 animations:^{
                [_rendererView navigateToPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageNumber]];
            }];
            
            return;
        }
    }
    _activePageBeforeStudentReviewMode=nil;
}

-(void)actionForFurtherPage
{
    if ([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if (epubBook.meta.layout == ePUBReflowable && epubBook.bookCFIArray.count == 0)
        {
            [self showFurthestPageNotSupportedAlert];
            return;
        }
    }
    [_rendererView navigateToFurthestPageWithSuccessHandler:^{
        
    } withFailureHandler:^{
        [self showAlreadyOnFurthestPageAlert];
    }];
}

-(void)showAlreadyOnFurthestPageAlert
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:@"YOU_ARE_ALREADY_ON_FURTHEST_PAGE"]message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK"] style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showFurthestPageNotSupportedAlert
{
    UIAlertController *furthestPageNotSupportedAlert = [UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:@"" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"FURTHEST_PAGE_NOT_SUPPORTED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
    }];
    [furthestPageNotSupportedAlert addAction:okAction];
    [self presentViewController:furthestPageNotSupportedAlert animated:YES completion:nil];
}
/**
 To
 */
-(void)actionForThumbnail
{
    if (activeMode != kPlayerActiveModeTeacherReview) {
        activeMode=kPlayerActiveModeThumbnail;
    }
    _thumbnailViewController = [[KBThumbnailViewController alloc]init];
    if (activeMode == kPlayerActiveModeTeacherReview) {
        NSArray *submittedPageArray = _teacherAnnotationController.studentSubmittedPageArray;
        [_thumbnailViewController setStudentSubmittedPageArray:submittedPageArray];
    }
    [_thumbnailViewController setDataArray:[currentBook getThumbnailData]];
    _thumbnailViewController.bookOrientationMode = [_rendererView getBookOrientationMode];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray *activePages=[_rendererView getActivePages];
        if(activePages.count)
        {
            KFPageVO *page1=[activePages objectAtIndex:0];
            [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)page1.pageID]];
            [_thumbnailViewController setActivePageNumber:page1.pageNum];
            [_thumbnailViewController setActiveDisplayNumber:page1.displayNum];
            if(activePages.count==2)
            {
                KFPageVO *page2=[activePages objectAtIndex:1];
                [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)page2.pageID]];
            }
        }
    }
    else if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(epubBook.meta.layout==ePUBFixedLayout)
        {
            NSArray *activePages=[_rendererView getActivePages];
            if(activePages.count)
            {
                EPUBPage *page1 = [activePages objectAtIndex:0];
                EPUBChapter *chapter1 = [self getEpubChapterForIndex:page1.fileIndex];
                [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)chapter1.fileIndex]];
                EPUBTOCPage *tocPage = [self getEpubTOCPageFromHref:chapter1.href];
                [_thumbnailViewController setActiveDisplayNumber:tocPage.displayNumber];
                if(activePages.count==2)
                {
                    page1 = [activePages objectAtIndex:1];
                    chapter1 = [self getEpubChapterForIndex:page1.fileIndex];
                    [_thumbnailViewController selectPageAt:[NSString stringWithFormat:@"%ld",(long)chapter1.fileIndex]];
                }
            }
        }
    }
    //,hdThemeVO.reader_thumbnail_panel_backgroundColor
    [_thumbnailViewController setThemeVo:hdThemeVO];
    [_thumbnailViewController setThumbnailBackgroundColor:hdThemeVO.thumbnail_slider_popup_background];
    [_thumbnailViewController setChapterIdAndTitleTextColor:[UIColor whiteColor]];
    [_thumbnailViewController setTotalNumberOfPages:(int)[self getTotalPagesArray].count];
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    _thumbnailViewController.delegate=self;
    [self enableHistoryButtons];
    
    if (isIpad())
    {
        _thumbnailViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        UIPopoverPresentationController *popPC = _thumbnailViewController.popoverPresentationController;
        _thumbnailViewController.popoverPresentationController.sourceView = self.view;
        popPC.permittedArrowDirections = 0;
        [self presentViewController:_thumbnailViewController animated:YES completion:nil];
        
    }
    else
    {
        [self presentViewController:_thumbnailViewController animated:YES completion:nil];
    }
}

/**
 ThumbnailViewDelegate Implementation
 */
-(void)didSelectActionToCloseThumbnail
{
    [self removeThumbnail];
    if(!isIpad())
    {
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
            if(epubBook.meta.layout==ePUBFixedLayout)
            {
                NSString *activePage=[[self getActivePageIDs]firstObject];
                EPUBChapter *chapter = [self getEpubChapterForIndex:activePage.integerValue];
                if (chapter.href)
                [_rendererView navigateToPageNumber:chapter.href];
            }
        }
        else
        {
            [_rendererView reloadPages];
        }
    }
}

/**
 TOCControllerDelegate Implementation
 */
-(void)didSelectActionToCloseTOC
{
    [self removeTOC];
    if(!isIpad())
    {
        [_rendererView reloadPages];
    }
}

/**
 MyDataControllerDelegate Implementation
 */
-(void)didSelectActionToCloseMyData
{
    [self removeMyData];
    if(!isIpad())
    {
        [_rendererView reloadPages];
    }
}
/**
 Removed My data view controller
 */
-(void)removeMyData
{
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    //    [_myDataViewController dismissViewControllerAnimated:YES completion:nil];
    [self resetAllPlayerActionBar];
    
}
/**
 Removed TOC view controller
 */
-(void)removeTOC
{
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    [self resetAllPlayerActionBar];
}
/**
 Removed thumbnail view controller
 */
-(void)removeThumbnail
{
    if (activeMode != kPlayerActiveModeTeacherReview) {
        if (backgroundActiveMode != kPlayerActiveModeNone) {
            activeMode = backgroundActiveMode;
        } else {
            activeMode = kPlayerActiveModeNone;
        }
    }
    [_thumbnailViewController dismissViewControllerAnimated:YES completion:nil];
    [self resetAllPlayerActionBar];
}

#pragma Thumbnail Delegate
/**
 ThumbnailDelegate Implementation
 */
-(void)didSelectThumbnailPageNo:(NSString *)pageNo
{
    [self addPageIntoPageHistoryArray:pageNo];
    isPageNavigateByScroll = NO;
    
    [self removeThumbnail];
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(epubBook.meta.layout==ePUBFixedLayout)
        {
            EPUBChapter *chapter = [self getEpubChapterForIndex:pageNo.integerValue];
            pageNo = chapter != nil ? chapter.href : pageNo;
            [_rendererView navigateToPageNumber:pageNo];
        }
    }
    else
    {
        [_rendererView navigateToPageNumber:pageNo];
    }
}

#pragma Initialize Player Top Bar
/**
 To Render Player Top Bar For IPhone
 */

-(void)addPlayerTopBarForIPhone
{
    self.playerTopActionBarView = [[PlayerActionTopBar alloc] initWithFrame:CGRectZero];
    self.playerTopActionBarView.tag =kPlayerActionBarTypeTopForIphone;
    self.playerTopActionBarView.bookVO = currentBook;
    self.playerTopActionBarView.delegate =self;
    self.playerTopActionBarView.userSettingsModel = _userSettingsModel;
    self.playerTopActionBarView.user = _user;
    self.playerTopActionBarView.hideProfileSettingsButton = hideProfileSettingsButton;
    [self.playerTopActionBarView addPlayerTopBarForIPhoneWithTheme:hdThemeVO isEpub:kPdfBookType];
    self.playerTopActionBarView.backgroundColor = hdThemeVO.top_toolbar_background;
    [self.view addSubview:self.playerTopActionBarView];
    self.playerTopActionBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playerTopActionBarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:-0.4].active = YES;
    [self.playerTopActionBarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.4].active = YES;
    _topBarTopMarginConstraint = [self.playerTopActionBarView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    _topBarTopMarginConstraint.active = YES;
    _topBarTopMarginConstraint.constant = -(playerTopBar_Height+statusBarHight);
    [self.playerTopActionBarView.heightAnchor constraintEqualToConstant:(playerTopBar_HeightIphone)].active = YES;
    self.playerTopActionBarView.layer.borderColor = hdThemeVO.top_toolbar_icons_color.CGColor;
    self.playerTopActionBarView.layer.borderWidth = 0.4;
    self.playerTopActionBarView.layer.masksToBounds = false;
    self.playerTopActionBarView.layer.shadowOffset = CGSizeMake(0,-1);
    self.playerTopActionBarView.layer.shadowRadius = 4.0;
    self.playerTopActionBarView.layer.shadowOpacity = 0.6;
    [self updateChapterNameForTopBar];
}

#pragma Initialize Player Bottom Bar
/**
 To Render Player Bottom Bar For IPhone
 */
-(void)initiatePlayerActionBottomBarView
{
    _playerBottomActionBarView = [[PlayerActionBottomBar alloc] initWithFrame:CGRectZero];
}

-(void)addPlayerBottomBarForIPhone
{
    [self initiatePlayerActionBottomBarView];
    _playerBottomActionBarView.isFurthestPageEnabled = [_rendererView isFurthestPageEnabled];
    _playerBottomActionBarView.delegate = self;
    _playerBottomActionBarView.userSettingsModel = _userSettingsModel;
    _playerBottomActionBarView.hasClassAssociation = _hasClassAssociation;
    _playerBottomActionBarView.tag = kPlayerActionBarTypeBottomForIphone;
    _playerBottomActionBarView.backgroundColor = hdThemeVO.side_bottom_background;
    BOOL isTeacher = ![_user.role isEqualToString:@"LEARNER"];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            [_playerBottomActionBarView addPlayerBottomBarForPortraitMode:hdThemeVO isEpub:kPdfBookType isTeacherAnnotationEnable:isTeacher];
        }else
        {
            [_playerBottomActionBarView addPlayerBottomBarForLandscapeMode:hdThemeVO isEpub:kPdfBookType isTeacherAnnotationEnable:isTeacher];
        }
        [self updateClearAllFIBsButtonStatus];
    }
    else if(((EPUBBookVO*)currentBook).meta.layout == ePUBReflowable){
        [_playerBottomActionBarView addPlayerBottomBarForPortraitMode:hdThemeVO isEpub:kEpubReflowableType isTeacherAnnotationEnable:NO];
    }
    else{
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            [_playerBottomActionBarView addPlayerBottomBarForPortraitMode:hdThemeVO isEpub:kEpubFixedType isTeacherAnnotationEnable:NO];
        } else {
            [_playerBottomActionBarView addPlayerBottomBarForLandscapeMode:hdThemeVO isEpub:kEpubFixedType isTeacherAnnotationEnable:NO];
        }
    }
    
    [self.view addSubview:_playerBottomActionBarView];
    _playerBottomActionBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_playerBottomActionBarView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-0.3]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_playerBottomActionBarView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.3]];
    _bottomBarBottomMarginConstraint = [NSLayoutConstraint constraintWithItem:_playerBottomActionBarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:playerBottomBar_Height + 4];
    [self.view addConstraint:_bottomBarBottomMarginConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_playerBottomActionBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:playerBottomBar_Height]];
    _playerBottomActionBarView.layer.borderColor = hdThemeVO.side_bottom_icons_color.CGColor;
    _playerBottomActionBarView.layer.borderWidth = 0.3;
    _playerBottomActionBarView.layer.masksToBounds = false;
    _playerBottomActionBarView.layer.shadowOffset = CGSizeMake(-0.4,0);
    _playerBottomActionBarView.layer.shadowRadius = 2.0;
    _playerBottomActionBarView.layer.shadowOpacity = 0.6;
}
/**
 Create and returns instance of PlayerActionBarItem for Player top bar VerticalBar item
 */
-(PlayerActionBarItem *)getPlayerItemForVerticalBar
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    UIView *lineView =[[UIView alloc]init];
    lineView.backgroundColor= hdThemeVO.side_bottom_icons_color;
    [actionBarItem addSubview:lineView];
    lineView.translatesAutoresizingMaskIntoConstraints= NO;
    
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:itemAction_verticalLineWidth]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    return actionBarItem;
}

/**
 Create and returns instance of PlayerActionBarItem for Player top bar for Audio Sync button
 */
-(PlayerActionBarItem *)getPlayerItemForSound
{
    
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeSound;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:icon_sound];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:font_name size:item_fontSize]];
    textForAction.textColor = hdThemeVO.side_bottom_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:itemAction_width]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    return actionBarItem;
}


/**
 Create and returns instance of PlayerActionBarItem for Player top bar for Play button
 */
-(PlayerActionBarItem *)getPlayerItemForPlay
{
    
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypePlay;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:icon_play];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:font_name size:item_fontSize]];
    textForAction.textColor = hdThemeVO.side_bottom_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:itemAction_width]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    return actionBarItem;
}

/**
 Returns Array of Folio Number in a book
 */
- (NSArray *)getFolioPagesForIphoneSlider
{
    NSMutableArray *totalPageArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray *pageDataArray = [currentBook getThumbnailData];
        pageDataForSliderDict =[[NSMutableDictionary alloc]initWithCapacity:0];
        for(int i=0;i<pageDataArray.count;i++)
        {
            NSDictionary *dict = pageDataArray [i];
            NSArray *pageArray = [dict valueForKey:@"Pages"];
            NSString *chapterName =[dict valueForKey:@"ChapterTitle"];
            
            for( NSDictionary *d in pageArray)
            {
                NSString *folioNO = [self getDisplayNumber:[d valueForKey:@"DisplayNumber"]];
                [totalPageArray addObject:folioNO];
                [pageDataForSliderDict setObject:chapterName forKey:folioNO];
            }
        }
    }
    else if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(epubBook.meta.layout==ePUBFixedLayout)
        {
            
        }
    }
    return totalPageArray;
}

/**
 Returns Array of Page Number in a book
 */
-(NSArray *)getTotalPagesArray
{
    NSMutableArray *totalPageArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray *pageDataArray = [currentBook getThumbnailData];
        for(int i=0;i<pageDataArray.count;i++)
        {
            NSDictionary *dict = pageDataArray [i];
            NSArray *pageArray = [dict valueForKey:@"Pages"];
            for( NSDictionary *d in pageArray)
            {
                NSString *pageNO = [[d valueForKey:@"PageNo"]stringValue];
                [totalPageArray addObject:pageNO];
            }
        }
    }
    else if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(epubBook.meta.layout==ePUBFixedLayout)
        {
            totalPageArray = [epubBook.chapters mutableCopy];
        }
    }
    return totalPageArray;
}

/**
 Returns NSstring from integer
 */
-(NSString *)getDisplayNumber:(id)displayNumber
{
    if(![displayNumber isKindOfClass:[NSString class]])
    {
        return  [displayNumber stringValue];
    }
    return displayNumber;
}

/**
 Create and returns instance of PlayerActionBarItem for Iphone bottom thumbnail slider
 */
-(PlayerActionBarItem *)getPlayerItemForIphoneSlider
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeSlider;
    pageSliderForiPhoneBottomBar =[[UISlider alloc]init];
    pageSliderForiPhoneBottomBar.minimumValue = 1;
    pageSliderForiPhoneBottomBar.continuous =YES;
    [self updatePageSliderForiPhoneBottom];
    [pageSliderForiPhoneBottomBar addTarget:self action:@selector(movePagesUsingSlider:) forControlEvents:UIControlEventValueChanged];
    [pageSliderForiPhoneBottomBar addTarget:self action:@selector(didEndIphoneSliderScrolling:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];
    
    pageSliderForiPhoneBottomBar.thumbTintColor = hdThemeVO.thumbnail_slider_filled_color;
    pageSliderForiPhoneBottomBar.tintColor = hdThemeVO.thumbnail_slider_slider_color;
    [actionBarItem addSubview:pageSliderForiPhoneBottomBar];
    pageSliderForiPhoneBottomBar.translatesAutoresizingMaskIntoConstraints =NO;
    
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: pageSliderForiPhoneBottomBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: pageSliderForiPhoneBottomBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: pageSliderForiPhoneBottomBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: pageSliderForiPhoneBottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    return actionBarItem;
}

/**
 Update page info lable
 */
-(void)updateActivePagesInfoLabel
{
    NSArray *activePages=[_rendererView getActivePages];
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSString *totalNoOfPages= [self getTotalNoOfFolioPages];
        NSString *activePagesDisplayString=@"";
        for (KFPageVO *page in activePages)
        {
            if([activePagesDisplayString isEqualToString:@""])
            {
                activePagesDisplayString=[NSString stringWithFormat:@"%@",page.displayNum];
            }
            else
            {
                activePagesDisplayString=[NSString stringWithFormat:@"%@-%@",activePagesDisplayString,page.displayNum];
            }
        }
        activePagesInfoLabel.text=[NSString stringWithFormat:@"Page %@ of %@",activePagesDisplayString,totalNoOfPages];
    }
    else if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        //        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        //
        //        long totalNoOfPages=[epubBook.chapters count];
        //        NSString *activePagesDisplayString=@"";
        //        for (EPUBPage *page in activePages)
        //        {
        //            if([activePagesDisplayString isEqualToString:@""])
        //            {
        //                activePagesDisplayString=[NSString stringWithFormat:@"%ld",page.pageNumber];
        //            }
        //            else
        //            {
        //                activePagesDisplayString=[NSString stringWithFormat:@"%@-%ld",activePagesDisplayString,page.pageNumber];
        //            }
        //        }
        //        activePagesInfoLabel.text=[NSString stringWithFormat:@"%@ of %ld",activePagesDisplayString,totalNoOfPages];
        
        //        switch (epubBook.meta.layout)
        //        {
        //            case ePUBReflowable:
        //            {
        //            }
        //            break;
        //            case ePUBFixedLayout:
        //            {
        //                [self updatePageSliderForiPhoneBottom];
        //            }
        //            default:
        //                break;
        //        }
    }
}

/**
 Returns Last page folio
 */
-(NSString*)getTotalNoOfFolioPages
{
    NSArray *dataArray=  [currentBook getThumbnailData];
    NSMutableArray *totalFolioNumberArray =[[NSMutableArray alloc]init];
    for(int i=0;i<dataArray.count;i++)
    {
        NSDictionary *dict = dataArray [i];
        NSArray *pageArray = [dict valueForKey:@"Pages"];
        for( NSDictionary *d in pageArray)
        {
            NSString *folioNumber = [d valueForKey:@"DisplayNumber"];
            [totalFolioNumberArray addObject:folioNumber];
        }
    }
    if(totalFolioNumberArray.count >0)
    {
        return totalFolioNumberArray.lastObject;
    }
    return @"";
}

- (NSString *)getDisplayNumberForPageID:(NSNumber *)pageID
{
    if ([currentBook isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *bookVO = (KFBookVO *)currentBook;
        KFPageVO *pageVO = [self getPageByPageID:[bookVO.pages allValues] and:pageID.intValue];
        return pageVO.displayNum;
    } else {
        if ([pageID isKindOfClass:[NSString class]]) {
            return pageID;
        } else {
            return pageID.stringValue;
        }
    }
    return @"";
}

-(KFPageVO *) getPageByPageID:(NSArray *)pages and:(int)pageid
{
    for (KFPageVO *pageVO in pages)
    {
        if(pageVO.pageNum == pageid)
        {
            return pageVO;
        }
    }
    return nil;
}

- (NSInteger)getPageIDForDisplayNumber:(NSString *)displayNumber
{
    KFBookVO *bookVO = (KFBookVO *)currentBook;
    KFPageVO *pageVO = [self getPageByDisplayNum:[bookVO.pages allValues] and:displayNumber];
    if(pageVO)
    {
        return pageVO.pageID;
    }
    else
    {
        KFPageVO *pageVO = [[bookVO.pages allValues] firstObject];
        return pageVO.pageID;
    }
}
-(KFPageVO *)getPageByDisplayNum:(NSArray *)pages and:(NSString *)displayNum
{
    for (KFPageVO *pageVO in pages)
    {
        if([pageVO.displayNum isEqualToString:displayNum])
        {
            return pageVO;
        }
    }
    return nil;
}

#pragma Player Pen tool Top bar

/**
 Create and add Pen tool action bar
 */
-(void)addPenToolTopBarViewWithAnimation:(BOOL)animate
{
    penToolActionBarView =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    penToolActionBarView.delegate =self;
    penToolActionBarView.user = _user;
    penToolActionBarView.backgroundColor = hdThemeVO.pen_tool_toolbar_background;
    penToolActionBarView.tag =kPlayerActionBarTypePenToolBar;
//    [penToolActionBarView updatedPlayerForPenTool:hdThemeVO withPenToolColors:[_userSettingsModelpentoolPenColors]];
    if (hdThemeVO.pen_Color_Array == nil || (hdThemeVO.pen_Color_Array!= nil && hdThemeVO.pen_Color_Array.count == 0)) {
        [penToolActionBarView updatedPlayerForPenTool:hdThemeVO withPenToolColors:_userSettingsModel.pentoolPenColors];
    }else{
        [penToolActionBarView updatedPlayerForPenTool:hdThemeVO withPenToolColors:hdThemeVO.pen_Color_Array ];
    }
    [self.view addSubview:penToolActionBarView];
    penToolActionBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.4]];
    bottomConstraintOfPenTool = [penToolActionBarView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:penToolBar_Height];
    [self.view addConstraint:bottomConstraintOfPenTool];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolActionBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:penToolBar_Height]];
    [self.view layoutIfNeeded];
    if(animate)
        [UIView animateWithDuration:0.4 animations:^{
            bottomConstraintOfPenTool.constant = 0.3;
            [self.view layoutIfNeeded];
        }];
    else{
        bottomConstraintOfPenTool.constant = 0.3;
        [self.view layoutIfNeeded];
    }
    penToolActionBarView.layer.borderColor = hdThemeVO.side_bottom_icons_color.CGColor;
    penToolActionBarView.layer.borderWidth = 0.3;
    penToolActionBarView.layer.masksToBounds = false;
    penToolActionBarView.layer.shadowOffset = CGSizeMake(-0.4,0);
    penToolActionBarView.layer.shadowRadius = 2.0;
    penToolActionBarView.layer.shadowOpacity = 0.6;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].userInteractionEnabled = NO;
    
}

-(void)movePagesUsingSlider:(UISlider *)slider
{
    if(!pageDataForSliderDict)
    {
        return;
    }
    
    if(sliderPageDetailsView ==nil )
    {
        sliderPageDetailsView =[[UIView alloc]init];
        sliderPageDetailsView.backgroundColor =hdThemeVO.thumbnail_slider_filled_color;
        [self.view addSubview:sliderPageDetailsView];
        sliderPageDetailsView.translatesAutoresizingMaskIntoConstraints =NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageDetailsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageDetailsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageDetailsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:280]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageDetailsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120]];
        
        sliderPageNumberLabel =[[UILabel alloc]init];
        [sliderPageDetailsView addSubview:sliderPageNumberLabel];
        sliderPageNumberLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageNumberLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sliderPageDetailsView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageNumberLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:sliderPageDetailsView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageNumberLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderPageNumberLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sliderPageDetailsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15]];
        
        sliderChapterNameLabel =[[UILabel alloc]init];
        [sliderPageDetailsView addSubview:sliderChapterNameLabel];
        [sliderChapterNameLabel sizeToFit];
        sliderChapterNameLabel.numberOfLines=0;
        sliderChapterNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderChapterNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sliderPageDetailsView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderChapterNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:sliderPageDetailsView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [sliderPageDetailsView addConstraint:[NSLayoutConstraint constraintWithItem:sliderChapterNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sliderPageNumberLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-30]];
    }
    
    if(pageDataForSliderDict)
    {
        NSArray *totalFolioPagesArray = [self getFolioPagesForIphoneSlider];
        NSString *currentPage = totalFolioPagesArray[(int)slider.value - 1];
        NSString *totalFolioPages = totalFolioPagesArray.lastObject;
        [sliderPageNumberLabel setText:[NSString stringWithFormat:@"Page: %@/%@",currentPage,totalFolioPages]];
        [sliderPageNumberLabel setTextColor:[UIColor whiteColor]];
        [sliderChapterNameLabel setText:[NSString stringWithFormat:@"%@ :%@",[LocalizationHelper localizedStringWithKey:@"CHAPTER_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController],[pageDataForSliderDict valueForKey:currentPage]]];
        [sliderChapterNameLabel setTextColor:[UIColor whiteColor]];
    }
}
-(void)didEndIphoneSliderScrolling:(UISlider *)slider
{
    [sliderPageDetailsView removeFromSuperview];
    sliderPageDetailsView =nil;
    sliderPageNumberLabel=nil;
    sliderChapterNameLabel=nil;
    
    NSArray *totalPages = [self getTotalPagesArray];
    [_rendererView navigateToPageNumber:totalPages[(int)slider.value - 1]];
}
#pragma Player Action Bar Delegates
/**
 PlayerActionBarDelegate Implementation
 */
-(void)didSelectedPlayerActionBar:(PlayerActionBar*)playerActionBar withItem:(PlayerActionBarItem *)item;
{
    [self didTapOnPlayerActionBar:playerActionBar withItem:item];
}

-(void)didTapOnPlayerActionBar:(PlayerActionBar*)playerActionBar withItem:(PlayerActionBarItem *)item
{
    [self removeVerticalBarViewForTeacherReview];
    switch (playerActionBar.tag)
    {
        case kPlayerActionBarItemTypeTeacherReview:{
            [_rendererView.view endEditing:YES];
            [self updatePentoolButtonStatus];
            [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
            [penToolActionBottomBarView updatePlayerSelectedItem:hdThemeVO];
            if (item.tag != kPlayerActionBarItemTypeDragBox) {
                if (isDragBoxModeEnabled) {
                    isDragBoxModeEnabled = false;
                    [_rendererView setTeacherReviewDragBoxModeEnabled:false];
                }
            }
            switch (item.tag)
            {
                case kPenToolBarItemTypeStudentName:
                {
                    [_teacherAnnotationController setStudentPageUGCDictionary:_teacherAnnotationData];
                    [_teacherAnnotationController setSelectedLearnerID:selectLearnerIDForTeacherReview];
                    [self saveTeacherReviewedDataWhenUseTapOnStudentnameForAnnotations:[_teacherAnnotationController getAnotationToSave] ForLearnerID:_teacherAnnotationController.selectedLearnerID];
                }
                    break;
                case kPenToolBarItemTypePrevPage:
                {
                    [self didClickOnPageButton:kPenToolBarItemTypePrevPage];
                }
                    break;
                case kPenToolBarItemTypeNextPage:
                {
                    [self didClickOnPageButton:kPenToolBarItemTypeNextPage];
                }
                    break;
                case kPlayerActionBarItemTypePrevStudent:
                {
                    [_teacherAnnotationController jumpToPreviousStudent];
                }
                    break;
                case kPlayerActionBarItemTypeNextStudent:
                {
                    [_teacherAnnotationController jumpToNextStudent];
                }
                    break;
                case kPlayerActionBarItemTypeGenerateReport:
                {
                    [self didTapOnGenerateReportButton];
                }
                    break;
                case kPlayerActionBarItemTypeDragBox:
                {
                    [self didSelectDragBoxForTeacherReview];
                }
                    break;
                case kPlayerActionBarItemTypeThumbnail:
                {
                    [self actionForThumbnail];
                }
                    break;
                case kPenToolBarItemTypePen:
                {
                    [self actionForTeacherReviewPenColorPalletePicker];
                }
                    break;
                case kPlayerActionBarItemTypePenColor:
                {
                    if (isIpad())
                    {
                        [penToolActionBarView updateSelectedPenColor:[item.metaData valueForKey:@"penColor"] withTheme:hdThemeVO];
                    }else
                    {
                        [penToolActionBottomBarView updateSelectedPenColor:[item.metaData valueForKey:@"penColor"] withTheme:hdThemeVO];
                    }
                    [self didSelectPenColorForTeacherReview:[item.metaData valueForKey:@"penColor"]];
                }
                    break;
                case kPenToolBarItemTypeEraser:
                {
                    [self didSelectEraserForTeacherReview];
                }
                    break;
                case kPenToolBarItemTypeDelete:
                {
                    if(![[KitabooNetworkManager getInstance] isInternetAvailable])
                    {
                        [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
                        [penToolActionBarView resetPlayerActionBarSelection];

                    }
                    else{
                        [self removeVerticalBarViewForTeacherReview];
                        [self didSelectDeleteForTeacherReview];
                    }
                }
                    break;
                case kPenToolBarItemTypeDone:
                {
                    [self removeVerticalBarViewForTeacherReview];
                    [_teacherAnnotationController setStudentPageUGCDictionary:_teacherAnnotationData];
                    [_teacherAnnotationController setSelectedLearnerID:selectLearnerIDForTeacherReview];
                    [self didSelectDoneForTeacherReviewWithUpdatedAnotations:[_teacherAnnotationController getAnotationToSave] ForLearnerID:_teacherAnnotationController.selectedLearnerID];
                }
                    break;
                case kPenToolBarItemTypeOverFlow:
                {
                    [self addPlayerVerticalBarForTeacherView];
                }
                    break;
                case kPlayerActionBarItemTypeProfile:
                {
                    [self backToStudentList];
                }
                    break;
                case kPenToolBarItemTypeUndo:
                {
                    [self actionForPentoolUndoDrawing];
                    return;
                }
                default:
                    break;
            }
        }
            break;
        case kPlayerActionBarTypePenToolBar:
        {
            [self updatePentoolButtonStatus];
            [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
            switch (item.tag)
            {
                case kPlayerActionBarItemTypePenColor:
                {
                    [self didSelectPenColor:[item.metaData valueForKey:@"penColor"]];
                }
                    break;
                case kPenToolBarItemTypeThickness:
                {
                    [penToolController setPenMode:PenModeDrawing];
                    [self actionForPenToolThicknessSelected];
                    return;
                }
                    break;
                case kPenToolBarItemTypePen:
                {
                    if(!isIpad()){
                        [self actionForPentoolDrawingMode];
                    }
                    else{
                        item.selected = NO;
                        [penToolActionBarView updatePlayerSelectedItem:hdThemeVO];
                    }
                    return;
                }
                    break;
                case kPenToolBarItemTypeUndo:
                {
                    [self actionForPentoolUndoDrawing];
                    return;
                }
                    break;
                case kPenToolBarItemTypeEraser:
                {
                    [self actionForPentoolErase];
                    return;
                }
                    break;
                case kPenToolBarItemTypeDelete:
                {
                    [penToolController setPenMode:PenModeDrawing];
                    [self actionForPentoolDeleteSelection];
                    return;
                }
                    break;
                case kPenToolBarItemTypeDone:
                {
                    [self actionForPentool];
                    return;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kPlayerActionBarTypeTextAnnotation:
        {
            switch (item.tag)
            {
                case kTextAnnotationBarItemTypeClose:
                {
                    [_rendererView removeTextAnnotationModeWithoutSave];
                    [self removeTextAnnotationView];
                }
                    break;
                case kTextAnnotationItemTypeAlignment:
                {
                    [self addTextAnnotationAlignmentView];
                    [self removeTextAnnotationColorView];
                }
                    break;
                case kTextAnnotationItemTypeTextColor:
                {
                    [self addTextAnnotationTextColorView];
                    [self removeTextAnnotationAlignmentView];
                }
                    break;
                case kTextAnnotationItemTypeAdd:
                {
                    [_rendererView exitTextAnnotationMode];
                    [self actionForTextAnnotation];
                    [self removeTextAnnotationColorView];
                    [self removeTextAnnotationAlignmentView];
                }
                    break;
                case kTextAnnotationItemTypeSave:
                {
                    [_rendererView exitTextAnnotationMode];
                    [self removeTextAnnotationView];
                }
                    break;
                case kTextAnnotationItemTypeDelete:
                {
                    [self actionForDeleteTextAnnotation];
                }
                    break;
                case kTextAnnotationItemTypeKeyboard:
                {
                    [self actionForTextAnnotationKeyBoard];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kPlayerActionBarTypeTextAnnotationAlignment:
        {
            switch (item.tag)
            {
                case kTextAnnotationAlignmentTypeLeft:
                {
                    [_rendererView updateTextAnnotationAlignment:NSTextAlignmentLeft];
                    [self removeTextAnnotationAlignmentView];
                }
                    break;
                case kTextAnnotationAlignmentTypeCenter:
                {
                    [_rendererView updateTextAnnotationAlignment:NSTextAlignmentCenter];
                    [self removeTextAnnotationAlignmentView];
                }
                    break;
                case kTextAnnotationAlignmentTypeRight:
                {
                    [_rendererView updateTextAnnotationAlignment:NSTextAlignmentRight];
                    [self removeTextAnnotationAlignmentView];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case kPlayerActionBarTypeTextAnnotationColor:
        {
            switch (item.tag)
            {
                case kTextAnnotationColorTypeColor1:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color1_background withTextColor:hdThemeVO.textAnnotation_color_popup_color1_text_color];
                    textAnnotationColorActionBarView.selectedColor = hdThemeVO.textAnnotation_color_popup_color1_background;
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor2:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color2_background withTextColor:hdThemeVO.textAnnotation_color_popup_color2_text_color];
                    textAnnotationColorActionBarView.selectedColor = hdThemeVO.textAnnotation_color_popup_color2_background;
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor3:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color3_background withTextColor:hdThemeVO.textAnnotation_color_popup_color3_text_color];
                    [self removeTextAnnotationColorView];
                    textAnnotationColorActionBarView.selectedColor = hdThemeVO.textAnnotation_color_popup_color3_background;
                    break;
                case kTextAnnotationColorTypeColor4:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color4_background withTextColor:hdThemeVO.textAnnotation_color_popup_color4_text_color];
                    textAnnotationColorActionBarView.selectedColor = hdThemeVO.textAnnotation_color_popup_color4_background;
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor5:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color5_background withTextColor:hdThemeVO.textAnnotation_color_popup_color5_text_color];
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor6:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color6_background withTextColor:hdThemeVO.textAnnotation_color_popup_color6_text_color];
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor7:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color7_background withTextColor:hdThemeVO.textAnnotation_color_popup_color7_text_color];
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor8:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color8_background withTextColor:hdThemeVO.textAnnotation_color_popup_color8_text_color];
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor9:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color9_background withTextColor:hdThemeVO.textAnnotation_color_popup_color9_text_color];
                    [self removeTextAnnotationColorView];
                    break;
                case kTextAnnotationColorTypeColor10:
                    [_rendererView updateTextAnnotationWithBackground:hdThemeVO.textAnnotation_color_popup_color10_background withTextColor:hdThemeVO.textAnnotation_color_popup_color10_text_color];
                    [self removeTextAnnotationColorView];
                    break;
                default:
                    break;
            }
        }
            break;
        case kPlayerActionBarTypeForReadAloud:
        {
            switch (item.tag) {
                case kPlayerActionBarItemTypePrev:
                {
                    KFBookVO *book=(KFBookVO*)currentBook;
                    KFPageVO *prevAudioPage = [book getPrevAudioLinkPagefromCurrentPageNumber:[[self getActivePageIDs]firstObject]];
                    if(prevAudioPage)
                    {
                        NSString *prevPageID = [NSString stringWithFormat:@"%ld",(long)prevAudioPage.pageID];
                        if(![[self getActivePageIDs]containsObject:prevPageID])
                        {
                            [_rendererView navigateToPageNumber:prevPageID];
                        }
                    }
                    [self enableNextPrevButtonForReadAloud];
                }
                    break;
                case kPlayerActionBarItemTypePlay:
                {
                    [self playPauseAudioSyncIfAny];
                }
                    break;
                case kPlayerActionBarItemTypeNext:
                {
                    KFBookVO *book=(KFBookVO*)currentBook;
                    KFPageVO *nextAudioPage = [book getNextAudioLinkPagefromCurrentPageNumber:[[self getActivePageIDs]lastObject]];
                    if(nextAudioPage)
                    {
                        NSString *nextPageID = [NSString stringWithFormat:@"%ld",(long)nextAudioPage.pageID];
                        if(![[self getActivePageIDs]containsObject:nextPageID])
                        {
                            [_rendererView navigateToPageNumber:nextPageID];
                        }
                    }
                    [self enableNextPrevButtonForReadAloud];
                }
                    break;
                case kPlayerActionBarItemTypeClose:
                {
                    readAloudMode = ReadAloudModeLetMeRead;
                    [self stopAudioSyncIfAny];
                    [self removeReadAloudTopBar];
                }
                    break;
                case kPlayerActionBarItemTypeSpeedText:
                {
                    //                    if(audioSpeedActionBarForReadAloud)
                    //                    {
                    //                        [self removeReadAloudAudioSpeedBarForIphone];
                    //                        break;
                    //                    }
                    //                    [self addReadAloudAudioSpeedBarForIphone];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kPlayerActionBarTypeAudioSync:
        {
            switch (item.tag) {
                case kPlayerActionBarItemTypePlay:
                {
                    [self playPauseAudioSyncIfAny];
                }
                    break;
                case kPlayerActionBarItemTypePrev:
                {
                    UILabel *speedRateLabel = [self getAudioSyncSpeedRateLabel];
                    float speedRate = 0.0;
                    switch (speedRateLabel.tag) {
                        case kAudioSyncSpeedRateOption1:
                        {
                            
                        }
                            break;
                        case kAudioSyncSpeedRateOption2:
                        {
                            [self readAloudItemEnable:NO withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypePrev]];
                            speedRateLabel.tag = kAudioSyncSpeedRateOption1;
                            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption1]]]];
                            speedRate = AudioSyncSpeedRateOption1;
                        }
                            break;
                        case kAudioSyncSpeedRateOption3:
                        {
                            speedRateLabel.tag = kAudioSyncSpeedRateOption2;
                            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption2]]]];
                            speedRate = AudioSyncSpeedRateOption2;
                        }
                            break;
                        case kAudioSyncSpeedRateOption4:
                        {
                            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypeNext]];
                            speedRateLabel.tag = kAudioSyncSpeedRateOption3;
                            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption3]]]];
                            speedRate = AudioSyncSpeedRateOption3;
                        }
                            break;
                        default:
                            break;
                    }
                    if (_audioSyncController) {
                        audioSyncSpeedRateOption = (AudioSyncSpeedRateOption)speedRateLabel.tag;
                        [_audioSyncController changeAudioPlayingSpeed:speedRate];
                    }
                }
                    break;
                case kPlayerActionBarItemTypeNext:
                {
                    UILabel *speedRateLabel = [self getAudioSyncSpeedRateLabel];
                    float speedRate = 0.0;
                    switch (speedRateLabel.tag) {
                        case kAudioSyncSpeedRateOption1:
                        {
                            [self readAloudItemEnable:YES withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypePrev]];
                            speedRateLabel.tag = kAudioSyncSpeedRateOption2;
                            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption2]]]];
                            speedRate = AudioSyncSpeedRateOption2;
                        }
                            break;
                        case kAudioSyncSpeedRateOption2:
                        {
                            speedRateLabel.tag = kAudioSyncSpeedRateOption3;
                            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption3]]]];
                            speedRate = AudioSyncSpeedRateOption3;
                        }
                            break;
                        case kAudioSyncSpeedRateOption3:
                        {
                            [self readAloudItemEnable:NO withItem:[self getAudioSyncItemWithTag:kPlayerActionBarItemTypeNext]];
                            speedRateLabel.tag = kAudioSyncSpeedRateOption4;
                            [speedRateLabel setText:[NSString stringWithFormat:@"%@ x",[NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption4]]]];
                            speedRate = AudioSyncSpeedRateOption4;
                        }
                            break;
                        case kAudioSyncSpeedRateOption4:
                        {
                            
                        }
                            break;
                        default:
                            break;
                    }
                    if (_audioSyncController) {
                        audioSyncSpeedRateOption = (AudioSyncSpeedRateOption)speedRateLabel.tag;
                        [_audioSyncController changeAudioPlayingSpeed:speedRate];
                    }
                }
                    break;
                case kPlayerActionBarItemTypeClose:
                {
                    [self closeAudioSync];
                    [self moveTopAndBottomOnScreenWithIsAnimate:YES WithCompletionHandler:nil];
                }
                    break;
                case kPlayerActionBarItemTypeAudioSyncColor:
                {
                    [self didSelectAudioSyncColor:[item.metaData valueForKey:@"penColor"]];
                }
                    break;
                case kPlayerActionBarItemTypeAudioSyncColorSelector:
                {
                    [self selectAudioSyncColorPalleteSelectionButton:true];
                    [self actionForAudioSyncColorPalletePicker];
                }
                    break;
            }
        }
            break;
        case kPlayerActionBarTypeBottom:
        case kPlayerActionBarTypeTopForIphone:
        case kPlayerActionBarTypeBottomForIphone:
        case kPlayerActionBarTypeTop:
        {
            //Handle Action for selected item
            switch (item.tag)
            {
                case kPlayerActionBarItemTypeBookshelf:
                {
                    [self didTapOnBackButton:nil];
                }
                    break;
                case kPlayerActionBarItemTypeTOC:
                {
                    [self didTapOnTOCButton:[_playerBottomActionBarView getSelectedItem]];
                }
                    break;
                case kPlayerActionBarItemTypeMyData:
                {
                    [self showMyData:[_playerBottomActionBarView getSelectedItem]];
                }
                    break;
                case kPlayerActionBarItemTypePenTool:
                {
                    [self actionForPentool];
                }
                    break;
                case kPlayerActionBarItemTypeStickyNote:
                {
                    [self showStickyNote];
                }
                    break;
                case kPlayerActionBarItemTypeThumbnail:
                {
                    if ([currentBook isKindOfClass:[EPUBBookVO class]]) {
                        EPUBBookVO *bookVO = (EPUBBookVO *)currentBook;
                        if (bookVO.meta.layout == ePUBFixedLayout) {
                            
                            if ([bookVO isKitabooEpubThumbnailSupported])
                            {
                                [self actionForThumbnail];
                            }
                            else
                            {
                                [self actionForFixedEpubThumbnail];
                            }
                        }
                    }
                    else{
                        [self removeVerticalBarViewForTeacherReview];
                        [self actionForThumbnail];
                    }
                }
                    break;
                case kPlayerActionBarItemTypeFurthestPage:
                {
                    [self actionForFurtherPage];
                }
                    break;
                case kPlayerActionBarItemTypeSearch:
                {
                    if(searchTextStr != nil)
                        [self addSearchForText:searchTextStr isElasticSearch:NO];
                    else
                        [self addSearchForText:@"" isElasticSearch:NO];
                    
                }
                    break;
                case kPlayerActionBarItemTypeTeacherReview:
                {
                    [analyticsHandler notifyEvent:KitabooReaderEventConstant.teacherReviewEventName eventInfo:nil];
                    [self removeVerticalBarViewForTeacherReview];
                    [self actionForTeacherReview];
                }
                    break;
                case kPlayerActionBarItemTypeStudentSubmit:
                {
                    [self actionForSubmitAnotation];
                }
                    break;
                case kPlayerActionBarItemTypeSound:
                {
                    if([currentBook isKindOfClass:[KFBookVO class]]){
                        [analyticsHandler notifyEvent:KitabooReaderEventConstant.readAloudEventName eventInfo:nil];
                        [self showReadAloudController];
                    }
                    else{
                        [self didTapOnAudioSyncIcon];
                    }
                }
                    break;
                case kPlayerActionBarItemTypePlay:
                {
                    //[self playPauseAudioSyncIfAny];
                }
                    break;
                case kPlayerActionBarItemTypeAddText:
                {
                    [self actionForTextAnnotation];
                }
                    break;
                case kPlayerActionBarItemTypeProfile:
                {
                    [self didTapOnProfilePic:item];
                }
                    break;
                case kPlayerActionBarItemTypeFontSetting:
                    [self showReflowableLayoutSettingControllerView:item];
                    break;
                case kPlayerActionBarItemTypeVerticalBar:
                {
                    [self addPlayerVerticalBarForTeacherView];
                }
                    break;
                case kPlayerActionBarItemTypeProtractor:
                {
                    [self didTapOnProtractor];
                }
                    break;
                case kPlayerActionBarItemTypeOverFlow:
                {
                    
                }
                    break;
                case kPlayerActionBarItemTypeClearAllFIBs:
                {
                     [self didTapOnClearAllFIBs];
                }
                     break;
                case kPlayerActionBarItemTypePrint:
                {
                    [self didTapOnPrintPageWithWatermark:nil];
                }
                    break;
            }
            //Handle UI for selected item
            switch (item.tag)
            {
                case kPlayerActionBarItemTypeBookshelf:
                    //case kPlayerActionBarItemTypeSound:
                {
                    for (UIView *view in item.subviews)
                    {
                        if([view isKindOfClass:[UILabel class]])
                        {
                            [self makeSelectionBorderForPlayerActionBarItem:view];
                        }
                    }
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(void)addPlayerVerticalBarForTeacherView
{
    viewForVerticalPlayerActionBar = [[UIView alloc]init];
    viewForVerticalPlayerActionBar.backgroundColor = UIColor.clearColor;
    [self.view addSubview:viewForVerticalPlayerActionBar];
    viewForVerticalPlayerActionBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [viewForVerticalPlayerActionBar.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [viewForVerticalPlayerActionBar.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [viewForVerticalPlayerActionBar.heightAnchor constraintEqualToConstant:self.view.frame.size.height].active = YES;
    [viewForVerticalPlayerActionBar.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeVerticalBarViewForTeacherReview)];
    [viewForVerticalPlayerActionBar addGestureRecognizer:gesture];
    
    playerActionVerticalBar = [[PlayerActionBar alloc] init];
    [playerActionVerticalBar setPlayerActionBarAlignmentMode:PlayerActionBarVerticalMode];
    playerActionVerticalBar.delegate = self;
    if (activeMode == kPlayerActiveModeTeacherReview)
    {
        playerActionVerticalBar.tag = kPlayerActionBarItemTypeTeacherReview;
    }else
    {
        playerActionVerticalBar.tag = kPlayerActionBarTypeBottomForIphone;
    }
    playerActionVerticalBar.backgroundColor = hdThemeVO.pen_tool_toolbar_background;
    [viewForVerticalPlayerActionBar addSubview:playerActionVerticalBar];
    playerActionVerticalBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [viewForVerticalPlayerActionBar addConstraint:[NSLayoutConstraint constraintWithItem:playerActionVerticalBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewForVerticalPlayerActionBar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:isIpad()?-45:-15]];
    [viewForVerticalPlayerActionBar addConstraint:[NSLayoutConstraint constraintWithItem:playerActionVerticalBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad()?60:50]];
    NSLayoutConstraint *topConstOfVerticalBar;
    if (isIpad())
    {
        if (activeMode == kPlayerActiveModeTeacherReview)
        {
            topConstOfVerticalBar = [NSLayoutConstraint constraintWithItem:playerActionVerticalBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewForVerticalPlayerActionBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        }else
        {
            topConstOfVerticalBar = [NSLayoutConstraint constraintWithItem:playerActionVerticalBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewForVerticalPlayerActionBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-12];
        }
        
    }else
    {
        topConstOfVerticalBar = [NSLayoutConstraint constraintWithItem:playerActionVerticalBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewForVerticalPlayerActionBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-7];
    }
    [viewForVerticalPlayerActionBar addConstraint:topConstOfVerticalBar];
    
    if (activeMode == kPlayerActiveModeTeacherReview)
    {
        playerActionVerticalBar.layer.borderColor = hdThemeVO.pen_tool_toolbar_icons_color.CGColor;
        playerActionVerticalBar.layer.borderWidth = 1;
        playerActionVerticalBar.layer.cornerRadius = 5;
    }else
    {
        playerActionVerticalBar.layer.masksToBounds = false;
        playerActionVerticalBar.layer.shadowOffset = CGSizeMake(0,-1);
        playerActionVerticalBar.layer.shadowRadius = 2.0;
        playerActionVerticalBar.layer.shadowOpacity = 0.8;
    }
    
    int totalNumberOfItems;
    if (isIpad())
    {
        if (activeMode == kPlayerActiveModeTeacherReview)
        {
            totalNumberOfItems = [self addItemsOnPlayerActionVerticalBarForTeacherAnnotationForIPad:hdThemeVO withPlayerActionBar:playerActionVerticalBar];
        }else
        {
            totalNumberOfItems = [self addItemsOnPlayerActionVerticalBarForIPad:hdThemeVO withPlayerActionBar:playerActionVerticalBar];
        }
    }else
    {
        if ([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            totalNumberOfItems = [self addItemsOnPlayerActionVerticalBarForFixedEpubForIPhone:hdThemeVO withPlayerActionBar:playerActionVerticalBar];
        }
        else{
            if (activeMode == kPlayerActiveModeTeacherReview)
            {
                totalNumberOfItems = [self addItemsOnPlayerActionVerticalBarForTeacherAnnotationForIPhone:hdThemeVO withPlayerActionBar:playerActionVerticalBar];
            }else
            {
                totalNumberOfItems = [self addItemsOnPlayerActionVerticalBarForIPhone:hdThemeVO withPlayerActionBar:playerActionVerticalBar];
            }
        }
    }
    
    [viewForVerticalPlayerActionBar addConstraint:[NSLayoutConstraint constraintWithItem:playerActionVerticalBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(isIpad()?50:45)*totalNumberOfItems]];
}

-(void)removeVerticalBarViewForTeacherReview
{
    if(viewForVerticalPlayerActionBar)
    {
        [viewForVerticalPlayerActionBar removeFromSuperview];
        viewForVerticalPlayerActionBar = nil;
    }
}

-(int)addItemsOnPlayerActionVerticalBarForTeacherAnnotationForIPhone:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    int totalNumberOfItems = 0;
    if ([_teacherAnnotationController doesCurrentPageHaveActiveUGC])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForDeleteWithAlpha:1] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }else
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForDeleteWithAlpha:0.5] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    
    [playerActionBar addActionBarItem:[self getPlayerItemForDoneText] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
    totalNumberOfItems++;
    
    [self getPenToolItemWithTag:kPenToolBarItemTypeTextAnnotation].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeTextAnnotation].userInteractionEnabled = NO;
    
    return totalNumberOfItems;
}

-(int)addItemsOnPlayerActionVerticalBarForTeacherAnnotationForIPad:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    int totalNumberOfItems = 0;
    if ([_teacherAnnotationController doesCurrentPageHaveActiveUGC])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForDeleteWithAlpha:1] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }else
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForDeleteWithAlpha:0.5] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    
    [playerActionBar addActionBarItem:[self getPlayerItemForDoneText] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
    totalNumberOfItems++;
    
    [self getPenToolItemWithTag:kPenToolBarItemTypeTextAnnotation].alpha=0.5;
    [self getPenToolItemWithTag:kPenToolBarItemTypeTextAnnotation].userInteractionEnabled = NO;
    
    return totalNumberOfItems;
}

-(int)addItemsOnPlayerActionVerticalBarForFixedEpubForIPhone:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    int totalNumberOfItems = 0;
    [playerActionBar addActionBarItem:[self getPlayerItemForThumbnail] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
    totalNumberOfItems++;
    
    if ([_userSettingsModel isTextAnnotationEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForTextAnnotation] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
  
    if([_rendererView isFurthestPageEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForFurthestPage] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
   
    if ([_userSettingsModel isAudioSyncEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForAudioSync] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    return totalNumberOfItems;
}

-(int)addItemsOnPlayerActionVerticalBarForIPhone:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    int totalNumberOfItems = 0;
    BOOL isTeacher = ![_user.role isEqualToString:@"LEARNER"];
    
    if ([_userSettingsModel isTextAnnotationEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForTextAnnotation] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    if (isTeacher && (_userSettingsModel.isReviewEnabled) && _hasClassAssociation)
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForTeacherReview] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }else if ((!isTeacher && (_userSettingsModel.isPenToolEnabled) && _hasClassAssociation) || !_hasClassAssociation)
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForStudentAnnotation] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    if ([_userSettingsModel isProtractorEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForProtractor] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    
    [playerActionBar addActionBarItem:[self getPlayerItemForThumbnail] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
    totalNumberOfItems++;
    
    if([_rendererView isFurthestPageEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForFurthestPage] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    
       if (_userSettingsModel.isClearAllFIBsEnabled)
       {
           [playerActionBar addActionBarItem:[self getPlayerItemForClearAllFIBs] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
           [self updateClearAllFIBsButtonStatus];
           totalNumberOfItems++;
       }
    
    return totalNumberOfItems;
}


-(int)addItemsOnPlayerActionVerticalBarForIPad:(KBHDThemeVO*)themeVO withPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    int totalNumberOfItems = 0;
    BOOL isTeacher = ![_user.role isEqualToString:@"LEARNER"];
    
    if ([_rendererView isFurthestPageEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForFurthestPage] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    if ([_userSettingsModel isTextAnnotationEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForTextAnnotation] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    if (isTeacher && (_userSettingsModel.isReviewEnabled) && _hasClassAssociation)
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForTeacherReview] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }else if ((!isTeacher && (_userSettingsModel.isPenToolEnabled) && _hasClassAssociation) || !_hasClassAssociation)
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForStudentAnnotation] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    if ([_userSettingsModel isProtractorEnabled])
    {
        [playerActionBar addActionBarItem:[self getPlayerItemForProtractor] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
        totalNumberOfItems++;
    }
    
      if (_userSettingsModel.isClearAllFIBsEnabled)
      {
          [playerActionBar addActionBarItem:[self getPlayerItemForClearAllFIBs] withItemsWidth:playerActionBar.frame.size.height/3 withItemAlignments:PlayerActionBarAlignmentTop isTappable:YES];
          [self updateClearAllFIBsButtonStatus];
          totalNumberOfItems++;
      }
    
    return totalNumberOfItems;
}

-(PlayerActionBarItem *)getPlayerItemForProtractor
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeProtractor;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:ICON_PROTRACTOR];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:item_fontSize]];
    textForAction.textColor =hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:itemAction_top].active = YES;
    [textForAction.centerXAnchor constraintEqualToAnchor:actionBarItem.centerXAnchor constant:0].active = YES;
    [textForAction.widthAnchor constraintEqualToConstant:itemAction_width].active = YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:itemAction_bottom].active = YES;
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
     return actionBarItem;
}
-(PlayerActionBarItem *)getPlayerItemForTextAnnotation
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeAddText;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:ICON_TEXTANNOTATION];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad()?22:18]];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForFurthestPage
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeFurthestPage;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:STUDENT_TEACHER_ICON];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:item_fontSize]];
    textForAction.textColor =hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:itemAction_top].active = YES;
    [textForAction.centerXAnchor constraintEqualToAnchor:actionBarItem.centerXAnchor constant:0].active = YES;
    [textForAction.widthAnchor constraintEqualToConstant:itemAction_width].active = YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:itemAction_bottom].active = YES;
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
     return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForDeleteWithAlpha:(CGFloat)alpha
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPenToolBarItemTypeDelete;
    actionBarItem.alpha = alpha;
    if (alpha == 1)
    {
        actionBarItem.userInteractionEnabled = YES;
    }else
    {
        actionBarItem.userInteractionEnabled = NO;
    }
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:ICON_CLEAR];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad()?22:18]];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForDoneText
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPenToolBarItemTypeDone;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:NSLocalizedStringFromTableInBundle(@"DONE",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(isIpad()?22:18)];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForAudioSyncSpeedLabel
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag= kPlayerActionBarItemTypeAudioSyncSpeedRateLabel;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:[NSString stringWithFormat:@"%@ x", [NumberLocalizationHandler localizeNumberWithNumber: [NSNumber numberWithFloat:AudioSyncSpeedRateOption2]]]];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(isIpad()?18:14)];
    textForAction.textColor = [UIColor blackColor];
    textForAction.tag = kAudioSyncSpeedRateOption2;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForThumbnail
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeThumbnail;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:ICON_THUMBNAIL];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad()?22:18]];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForAudioSync
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeSound;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:ICON_AUDIO_SYNC];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad()?22:18]];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForTeacherReview
{
    
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeTeacherReview;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:TEACHER_ANNOTATION_ICON];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:22]];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForStudentAnnotation
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeStudentSubmit;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:icon_StudentSubmit];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:22]];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:itemAction_top]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:itemAction_bottom]];
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
    return actionBarItem;
}
-(PlayerActionBarItem *)getPlayerItemForClearAllFIBs
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeClearAllFIBs;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:ICON_CLEAR];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:item_fontSize]];
    textForAction.textColor =hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:itemAction_top].active = YES;
    [textForAction.centerXAnchor constraintEqualToAnchor:actionBarItem.centerXAnchor constant:0].active = YES;
    [textForAction.widthAnchor constraintEqualToConstant:itemAction_width].active = YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:itemAction_bottom].active = YES;
    [_playerBottomActionBarView setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
     return actionBarItem;
}
-(void)removePlayerActionVerticalBar
{
    [playerActionVerticalBar removeFromSuperview];
    playerActionVerticalBar = nil;
}

-(void)saveTeacherReviewedDataWhenUseTapOnStudentnameForAnnotations:(NSArray *)anotations ForLearnerID:(NSString *)learnerID
{
    doneButtonSelectedForTeacherReview = NO;
    [self addIndicatorViewForTeacherReview];
    [_dataSyncManager saveTeacherAnnotationsForAnnotation:anotations forLearnerID:learnerID withBookID:_bookID WithDelegate:self WithUserToken:_user.userToken];
}

/**
 Update UI for selected state of PlayerActionBarItem
 */
-(void)makeSelectionBorderForPlayerActionBarItem:(UIView *)view
{
    if([view isKindOfClass:[UILabel class]])
    {
        UILabel *label=(UILabel*)view;
        [label setTextColor:hdThemeVO.side_bottom_selected_icon_color];
        label.backgroundColor = hdThemeVO.side_bottom_selected_icon_bg;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = CGRectGetHeight(view.frame)/2 ;
        
    }
}

/**
 PlayerActionBarDelegate Implementation
 */
-(void)willResetPlayerActionBar:(PlayerActionBar*)playerActionBar
{
    switch (playerActionBar.tag)
    {
        case kPlayerActionBarTypePenToolBar: case kPlayerActionBarItemTypeTeacherReview:{
            for (UIView *subItems in [playerActionBar getTappableItems]) {
                if([subItems isKindOfClass:[PlayerActionBarItem class]]){
                    for (UILabel *subView in [subItems subviews]) {
                        subItems.backgroundColor = hdThemeVO.pen_tool_toolbar_background;
                        if([subView isKindOfClass:[UILabel class]]){
                            subView.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
                        }
                    }
                }
            }
            
        }
            break;
        case kPlayerActionBarTypeBottom:
        case kPlayerActionBarTypeTop:
        case kPlayerActionBarTypeTopForIphone:
        case kPlayerActionBarTypeBottomForIphone:
        {
            //            for (UIView *view in selectedItem.subviews)
            //            {
            //                if([view isKindOfClass:[UILabel class]])
            //                {
            //                    UILabel *label=(UILabel*)view;
            //                    [label setTextColor:hdThemeVO.reader_icon_color];
            //                    label.backgroundColor = hdThemeVO.reader_icon_backgroundColor ;
            //                    label.layer.cornerRadius=0;
            //                }
            //            }
        }
            break;
            
        default:
            break;
    }
}

/**
 To Reset all player action bar item from selected to Non-selected
 */
-(void)resetAllPlayerActionBar
{
    if(isIpad())
    {
        [self.playerTopActionBarView resetPlayerActionBarSelection];
        [_playerBottomActionBarView resetPlayerActionBarSelection];
        [penToolActionBarView resetPlayerActionBarSelection];
        [penToolActionBottomBarView resetPlayerActionBarSelection];
    }
    else
    {
        [self.playerTopActionBarView resetPlayerActionBarSelection];
        [_playerBottomActionBarView resetPlayerActionBarSelection];
        [penToolActionBarView resetPlayerActionBarSelection];
        [penToolActionBottomBarView resetPlayerActionBarSelection];
        [penToolActionBottomBarView resetPlayerActionBarSelection];
    }
}

#pragma Show-Hide Player Action Bar
/**
 To hide Top and bottom view from screen
 */
- (void)moveTopAndBottomOffScreenWithIsAnimate:(BOOL)animated WithCompletionHandler:(void (^)(void))completionHandler
{
    isPlayerActionBarHidden=YES;
    [self.view layoutIfNeeded];
    _topBarTopMarginConstraint.constant = -(playerTopBar_Height+statusBarHight);
    _bottomBarBottomMarginConstraint.constant = playerBottomBar_Height + 4;
    if (isVerticalsliderEnable){
        if (@available(iOS 11.0, *)) {
            rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom)+self.view.safeAreaInsets.right;
        } else {
            rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom);
        }
    }
    
    if(animated)
    {
        [UIView animateWithDuration:PlayerActionBarAnimationTime
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                             
                         } completion:^(BOOL finished){
                             [_playerBottomActionBarView setHidden:YES];
                             [self.playerTopActionBarView setHidden:YES];
                             [viewForSliderBar setHidden:YES];
                             if(completionHandler)
                             {
                                 completionHandler();
                             }
                         }];
    }
    else
    {
        [_playerBottomActionBarView setHidden:YES];
        [self.playerTopActionBarView setHidden:YES];
        [self.view layoutIfNeeded]; // Called on parent view
    }
}

/**
 To show Top and bottom view on screen
 */
- (void)moveTopAndBottomOnScreenWithIsAnimate:(BOOL)animated WithCompletionHandler:(void (^)(void))completionHandler
{
    [_playerBottomActionBarView setHidden:NO];
    [self.view bringSubviewToFront:_playerBottomActionBarView];
    [self.playerTopActionBarView setHidden:NO];
    [viewForSliderBar setHidden:NO];
    isPlayerActionBarHidden=NO;
    [self.view layoutIfNeeded];
    _topBarTopMarginConstraint.constant = -0.4;
    _bottomBarBottomMarginConstraint.constant =  0.4;
    if (isVerticalsliderEnable) {
        if (@available(iOS 11.0, *)) {
            rightConstraintForVerticalSliderView.constant = -sliderRightAndBottom-self.view.safeAreaInsets.right+15;
        } else {
            rightConstraintForVerticalSliderView.constant = -sliderRightAndBottom+15;
        }
    }
    
    
    if(animated)
    {
        [UIView animateWithDuration:PlayerActionBarAnimationTime
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished) {
                             if(completionHandler)
                             {
                                 completionHandler();
                                 
                             }
                         }];
    }
    else
    {
        [self.view layoutIfNeeded]; // Called on parent view
    }
}

#pragma Pentool controller delagate
/**
 PenToolControllerDelegate Implementation
 */
- (void)didCreatePenDrawing:(SDKPentoolVO *)drawingObject
{
    if(activeMode != kPlayerActiveModeTeacherReview)
    {
        [_dbManager savePentoolDrawing:drawingObject bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [self drawPenDrawingsOnPageNumber:drawingObject.pageIdentifier OnDisplayNumber:drawingObject.displayNum];
    }
    else
    {
        [_teacherAnnotationController setSelectedPageIdentifier:pageIdentifierForTeacherReview];
        [_teacherAnnotationController setStudentPageUGCDictionary:_teacherAnnotationData];
        [_teacherAnnotationController setSelectedLearnerID:selectLearnerIDForTeacherReview];
        [_teacherAnnotationController addPenDrawing:drawingObject];
    }
    [self updatePentoolButtonStatus];
}
/**
 PenToolControllerDelegate Implementation
 */
- (void)didUpdatePenDrawing:(SDKPentoolVO *)drawingObject
{
    if(activeMode != kPlayerActiveModeTeacherReview)
    {
        if(drawingObject.status==DELETE)
        {
            [_dbManager deletePentoolDrawing:drawingObject bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        }
        else
        {
            [_dbManager savePentoolDrawing:drawingObject bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        }
    }
    else
    {
        [_teacherAnnotationController setSelectedPageIdentifier:pageIdentifierForTeacherReview];
        [_teacherAnnotationController setStudentPageUGCDictionary:_teacherAnnotationData];
        [_teacherAnnotationController setSelectedLearnerID:selectLearnerIDForTeacherReview];
        if(drawingObject.status==DELETE)
        {
            [_teacherAnnotationController updatePenDrawing:drawingObject];
        }
        else
        {
            [_teacherAnnotationController addPenDrawing:drawingObject];
        }
    }
    [self updatePentoolButtonStatus];
    
}
/**
 PenToolControllerDelegate Implementation
 */
-(void)didChangeUndoableStatus
{
    if([penToolController isUndoable])
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].alpha=1.0;
        [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].userInteractionEnabled = YES;
    }
    else
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeUndo].userInteractionEnabled = NO;
    }
}
/**
 PenToolControllerDelegate Implementation
 */
-(void)didUpdatedSelectedPenDrawing
{
}

#pragma pentool UI controller delegate
/**
 To render PenTool Thickness pallete  view
 */
-(void)actionForPenToolThicknessSelected
{
    penToolThicknessPalleteViewController = [[KitabooPenToolThicknessPalleteViewController alloc]init];
    penToolThicknessPalleteViewController.delegate= self;
    [penToolThicknessPalleteViewController setSelectedThicknessValue:[self getLastUpdatedPenThickness]];
    [penToolThicknessPalleteViewController setThicknessColor:[self getLastUpdatedPenColor]];
    [penToolThicknessPalleteViewController setThickenessSliderTintColor:hdThemeVO.pen_tool_slider_filled_color];
    [penToolThicknessPalleteViewController setSliderFilledColor:hdThemeVO.pen_tool_slider_color];
    [penToolThicknessPalleteViewController setThicknessPickerViewBackgroundColor:hdThemeVO.pen_tool_thicknessPopUp_backgroundColor];
    [penToolThicknessPalleteViewController setVerticalSeperatorColor:hdThemeVO.pen_tool_thicknessPopUp_border];
    penToolPalleteContainer =[[UIView alloc]init];
    penToolThicknessPalleteViewController.view.layer.borderColor = hdThemeVO.pen_tool_thicknessPopUp_border.CGColor;
    UILongPressGestureRecognizer *singleTapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnPentoolPalleteContainer:)];
    singleTapGesture.delegate = self;
    singleTapGesture.minimumPressDuration = 0;
    [penToolPalleteContainer addGestureRecognizer:singleTapGesture];
    [self.view addSubview:penToolPalleteContainer];
    penToolPalleteContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [penToolPalleteContainer addSubview:penToolThicknessPalleteViewController.view];
    penToolThicknessPalleteViewController.view.translatesAutoresizingMaskIntoConstraints=NO;
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penToolThicknessPalleteViewController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:isIPAD?isRTL()?-218:218 : 0]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penToolThicknessPalleteViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:- (penToolBar_Height + 1)]];
    
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penToolThicknessPalleteViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? 238 : 214]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penToolThicknessPalleteViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? 62 : 54]];
    [penToolActionBarView updateColorSelectedView:[UIColor colorWithHexString:[self getLastUpdatedPenColor]] withColorThickness:[self getLastUpdatedPenThickness]];
}

/**
 To render color pallete picker view
 */
-(void)actionForPenColorPalletePicker
{
    penColorPallete = [[KitabooPenToolColorPalleteViewController alloc]init];
    penColorPallete.delegate=self;
//    [penColorPallete setPenColors:[[_userSettingsModel]pentoolPenColors]];
    [penColorPallete setPenColors:hdThemeVO.pen_Color_Array];
    [penColorPallete setSelectedPenColor:[self getLastUpdatedPenColor]];
    [penColorPallete setColorPickerBackgroundColor:hdThemeVO.pen_tool_pen_popup_background];
    [penColorPallete setSelectionBorderColor:hdThemeVO.pen_tool_pen_popup_border];
    [penColorPallete setContainerBorderColor:hdThemeVO.pen_tool_pen_popup_border];
    //    if(isIpad())
    //    {
    //        penColorPallete.preferredContentSize = CGSizeMake([penColorPallete.penColors count]*(PenToolBar_ItemWidth),64);
    //        penColorPallete.modalPresentationStyle = UIModalPresentationPopover;
    //        UIPopoverPresentationController *penToolPopOV = penColorPallete.popoverPresentationController;
    //        //penToolPopOV.delegate = self;
    //        penToolPopOV.permittedArrowDirections = 0;
    //        penToolPopOV.backgroundColor = hdThemeVO.reader_default_panel_backgroundColor;
    //        penToolPopOV.sourceView = [penToolActionBarView getSelectedItem];
    //        penToolPopOV.sourceRect = CGRectMake([penToolActionBarView getSelectedItem].frame.origin.x , (penToolBar_Height) + 8, [penColorPallete.penColors count]*(PenToolBar_ItemWidth), [penToolActionBarView getSelectedItem].frame.size.height);
    //
    //        [self.navigationController presentViewController:penColorPallete animated:YES completion:nil];
    //    }
    //    else
    //    {
    penToolPalleteContainer = [[UIView alloc]init];
    UILongPressGestureRecognizer *singleTapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnPentoolPalleteContainer:)];
    singleTapGesture.delegate = self;
    [penToolPalleteContainer addGestureRecognizer:singleTapGesture];
    singleTapGesture.minimumPressDuration = 0;
    
    [self.view addSubview:penToolPalleteContainer];
    penToolPalleteContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    
    [penToolPalleteContainer addSubview:penColorPallete.view];
    penColorPallete.view.translatesAutoresizingMaskIntoConstraints=NO;
    CGFloat widthForIpad = [penColorPallete.penColors count]*(PenToolBar_ItemWidth);
    CGFloat widthForIphone = ([hdThemeVO.pen_Color_Array count] > 5) ? (5*(PenToolBar_ItemWidth)) + 8 :([hdThemeVO.pen_Color_Array count]*(PenToolBar_ItemWidth)) + 8;
    CGFloat heightForIpad = 64;
    CGFloat heightForIphone = ([hdThemeVO.pen_Color_Array count] > 5)?(2 * 50) + 12:62;
    
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(penToolBar_Height + 1)]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? widthForIpad : widthForIphone]];
    // [penColorPallete.penColors count]*60
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? heightForIpad : heightForIphone]];
    //    }
    
    
}

/**
 To Profile Pic
 */
-(void)didTapOnProfilePic:(UIView*)view
{
    if ([_delegate respondsToSelector:@selector(didTapOnProfilePic:)])
    {
        [_delegate didTapOnProfilePic:view];
    }
}

/**
 To Submit Anotation
 */
-(void)actionForSubmitAnotation
{
    BOOL isSubmitAnnotationAllowed;
    if (_hasClassAssociation) {
        isSubmitAnnotationAllowed = [_dbManager isSubmitAnotationAllowedForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue]];
    } else {
        isSubmitAnnotationAllowed = [_dbManager isSubmitAnotationAllowedForFibForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue]];
    }
    if(isSubmitAnnotationAllowed)
    {
        [self addAlertForSubmitDataForStudentAnnotation];
    }
    else
    {
        NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"NO_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
        NSString *alert_Msg = [LocalizationHelper localizedStringWithKey:@"NO_DATA_TO_SUBMIT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
        [self showAlertControllerWithMsg:alert_Msg withTitle:alert_Title];
        
    }
}
///////
#pragma mark ReadAloud
-(void)showReadAloudController
{
    readToMeViewController= [[HDReadToMeViewController alloc]initWithReadAloudMode:readAloudMode];
    [readToMeViewController setTheme:hdThemeVO];
    readToMeViewController.delegate=self;
    readToMeViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [self presentViewController:readToMeViewController animated:NO completion:nil];
}
-(void)didCloseReadToMeView
{
    [self resetAllPlayerActionBar];
    if(readToMeViewController)
    {
        [readToMeViewController dismissViewControllerAnimated:NO completion:nil];
        readToMeViewController = nil;
    }
}

- (void)didTapOnReadToMeForReadAloud
{
    [self resetAudioPlayer];
    [_rendererView resetZoomScaleToDefault];
    readAloudMode = ReadAloudModeReadToMe;
    [self didCloseReadToMeView];
    [self addReadAloudTopBar];
    audioSyncSpeedRateOption = kAudioSyncSpeedRateOption2;
    [self actionForReadAloud];
}
- (void)didTapOnAutoPlayForReadAloud
{
    [self resetAudioPlayer];
    [_rendererView resetZoomScaleToDefault];
    readAloudMode = ReadAloudModeAutoPlay;
    [self didCloseReadToMeView];
    [self addReadAloudTopBar];
    audioSyncSpeedRateOption = kAudioSyncSpeedRateOption2;
    [self actionForReadAloud];
}
- (void)didTapOnLetMeReadForReadAloud
{
    [self resetAudioPlayer];
    [_rendererView resetZoomScaleToDefault];
    readAloudMode = ReadAloudModeLetMeRead;
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    [self didCloseReadToMeView];
    [self stopAudioSyncIfAny];
}
-(void)actionForReadAloud
{
    if(readAloudMode != ReadAloudModeLetMeRead)
    {
        [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
        if([currentBook isKindOfClass:[KFBookVO class]])
        {
            NSArray *activePages = [self->_rendererView getActivePages];
            KFPageVO *page = [activePages firstObject];
            if([page getAudioSyncTypeLinks] != nil)
            {
                [self loadAudioSyncIdAvailableForPageNumber:[NSNumber numberWithInteger:page.pageID]];
            }
            else
            {
                page = [activePages lastObject];
                if([page getAudioSyncTypeLinks] == nil && self->readAloudMode == ReadAloudModeAutoPlay)
                {
                    KFBookVO *book=(KFBookVO*)self->currentBook;
                    page = [book getNextAudioLinkPagefromCurrentPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
                    if(page)
                        [self->_rendererView navigateToPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
                }
                else
                {
                    [self loadAudioSyncIdAvailableForPageNumber:[NSNumber numberWithInteger:page.pageID]];
                }
            }
        }
    }
}
-(void)changePlayButtonState
{
    NSArray *itemArray;
    if (playerTopActionBarViewForReadAloud) {
        itemArray = [playerTopActionBarViewForReadAloud getTappableItems];
    }
    else if (playerBottomActionBarViewForAudioSync){
        itemArray = [playerBottomActionBarViewForAudioSync getTappableItems];
    }
    itemArray = [itemArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %ld", kPlayerActionBarItemTypePlay]];
    if(itemArray.count)
    {
        PlayerActionBarItem *item = [itemArray objectAtIndex:0];
        for (UIView *view in item.subviews)
        {
            if([view isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel*)view;
                if(_audioSyncController.isPlaying)
                {
                    [label setText:ICON_MEDIA_PAUSE];
                }
                else
                {
                    [label setText:ICON_MEDIA_PLAY];
                }
                break;
            }
        }
    }
}

-(UILabel*)getAudioSyncSpeedRateLabel
{
    NSArray *itemArray;
    if (playerTopActionBarViewForReadAloud) {
        itemArray = [playerTopActionBarViewForReadAloud getTappableItems];
    }
    else if (playerBottomActionBarViewForAudioSync){
        itemArray = [playerBottomActionBarViewForAudioSync getTappableItems];
    }
    itemArray = [itemArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %ld", kPlayerActionBarItemTypeAudioSyncSpeedRateLabel]];
    if(itemArray.count)
    {
        PlayerActionBarItem *item = [itemArray objectAtIndex:0];
        for (UIView *view in item.subviews)
        {
            if([view isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel*)view;
                return label;
            }
        }
    }
    return nil;
}

-(void)enablePlayButton:(BOOL)enable
{
    NSArray *itemArray = [playerTopActionBarViewForReadAloud getTappableItems];
    for (PlayerActionBarItem *playerActionBarItem in itemArray) {
        if(playerActionBarItem.tag==kPlayerActionBarItemTypePlay)
        {
            playerActionBarItem.enabled = enable;
            playerActionBarItem.alpha = enable ? 1.0:0.5;
        }
    }
}
-(void)restoreReadAloudController
{
    if(readAloudMode != ReadAloudModeLetMeRead)
    {
        if(_audioSyncController)
        {
            NSString* audioPlayingOnPageID = [_audioSyncController audioPlayingForPageIdentifier];
            if(![[self getActivePageIDs] containsObject:audioPlayingOnPageID])
            {
                [self->_rendererView navigateToPageNumber:audioPlayingOnPageID];
            }
        }
        [self enableNextPrevButtonForReadAloud];
    }
}
-(void)addReadAloudTopBar
{
    [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
//    if(playerTopActionBarViewForReadAloud)
//    {
//        [self removeReadAloudTopBar];
//    }
//    [self addPlayerTopBarForReadAloudView];
}
- (void)playAudioSyncForChapter:(EPUBChapter *)currentChapter {
    if (currentChapter.audioSyncArray) {
        [_rendererView getFirstVisibleWordForScreenWithCallBack:^(NSDictionary *wordDict) {
            _audioSyncController=[[AudioSyncController alloc]initWithLinks:currentChapter.audioSyncArray  WithDelegate:self WithKitabooBook:currentBook WithPlayerUIEnable:NO];
            if (wordDict) {
                if ([wordDict valueForKey:@"wordId"]) {
                    [_audioSyncController playAudioFromWordId:[wordDict valueForKey:@"wordId"]];
                }
            }
            [_audioSyncController start];
            [self changePlayButtonState];
        }];
    }
}

//-(void)actionForPlayAnotation
//{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Detected"
//                                                                             message:@"Play Button Pressed"
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                       style:UIAlertActionStyleDefault
//                                                     handler:nil]; //You can use a block here to handle a press on this button
//    [alertController addAction:actionOk];
//    [self presentViewController:alertController animated:YES completion:nil];
//    NSLog(@"Play pressed");
//
//}

-(void)didTapOnAudioSyncIcon{
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    activeMode = kPlayerActiveModeAudioSync;
    [self addPlayerBottomBarForAudioSync];
    NSArray *activePages=[_rendererView getActivePages];
    EPUBPage *firstPage  = [activePages objectAtIndex:0];
    EPUBChapter *currentChapter = [self getEpubChapterForIndex:firstPage.fileIndex];
    [self playAudioSyncForChapter:currentChapter];
}

/**
 To show alert on success of submitting student anotation
 */
-(void)addAlertForSubmitDataForStudentAnnotation
{
    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"SUBMIT_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
    NSString *alert_Msg = [LocalizationHelper localizedStringWithKey:@"ANSWER_WILL_BE_SUBMITTED_AND_CANNOT_BE_CHANGED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
    [[AlertView sharedManager] presentAlertWithTitle:alert_Title message:alert_Msg andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController],[LocalizationHelper localizedStringWithKey:@"NO_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
     {
         if ([buttonTitle isEqualToString:[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]])
         {
             [_dataSyncManager submitAnotationForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
             [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
         }
     }];
}

/**
 To show alert on success of saving student anotation
 */
-(void)showAlertForSuccessfullySaveDataForStudentAnnotation
{
    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"YOUR_DATA_HAS_BEEN_SUCCESSFULLY_SAVED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
    [self showAlertControllerWithMsg:@"" withTitle:alert_Title];
}

/**
 Will be called when  anotation is successfully submitted
 */
-(void)didSubmitedAnotationSuccessfully
{
    //[self stopActivityIndicator];
    if (_hasClassAssociation) {
        [_dbManager submitAnotationForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue]];
    } else {
        [_dbManager submitAnotationForFibForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue]];
    }
    [self showAlertForSuccessfullySaveDataForStudentAnnotation];
    [self relaodPageUGCForActivePages];
    [self updateClearAllFIBsButtonStatus];
}

/**
 Will be called when failed to Submit anotation
 */
-(void)didFailedToSubmitAnotationWithError:(NSError*)error
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager submitAnotationForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
        }else
        {
            [self showSessionExpiredAlert];
        }
    }else
    {
        if ([[KitabooNetworkManager getInstance] isInternetAvailable])
        {
            [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_SUBMIT_ANOTATIONS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
        }
        else{
            [self showAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_SUBMIT_ANOTATIONS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
        }
        
    }
}

/**
 Will be called when student anotation is successfully saved
 */
-(void)didSavedStudentAnotationSuccessfully
{
    [_rendererView disableTeacherReviewMode];
    if (doneButtonSelectedForTeacherReview)
    {
        activeMode=kPlayerActiveModeNone;
        [_rendererView setPenDrawingModeEnabled:NO];
        penToolController=nil;
        [_rendererView.view setUserInteractionEnabled:YES];
        [self removeTeacherAnnotation];
        [activityViewForTeacherReview removeFromSuperview];
        activityViewForTeacherReview = nil;
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:NSLocalizedStringFromTableInBundle(@"DATA_SUBMITTED_SUCCESSFULLY",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            [self loadPagesBeforeTeacherReview];
        }];
    }else
    {
        [activityViewForTeacherReview removeFromSuperview];
        activityViewForTeacherReview = nil;
        activeMode=kPlayerActiveModeNone;
        [_rendererView.view setUserInteractionEnabled:YES];
        [self actionForTeacherReview];
    }
    
}

-(void)backToStudentList{
    [_rendererView disableTeacherReviewMode];
    activeMode=kPlayerActiveModeNone;
    [_rendererView setPenDrawingModeEnabled:NO];
    penToolController=nil;
    [_rendererView.view setUserInteractionEnabled:YES];
    [self removeTeacherAnnotation];
    [activityViewForTeacherReview removeFromSuperview];
    activityViewForTeacherReview = nil;
    [self loadPagesBeforeTeacherReview];
    if (_teacherAnnotationController) {
        if (isIpad())
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_teacherAnnotationController];
            navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            UIPopoverPresentationController *popPC = navController.popoverPresentationController;
            popPC.permittedArrowDirections = 0;
            navController.popoverPresentationController.sourceView = self.view;
            [navController setNavigationBarHidden:YES];
            [self presentViewController:navController
                               animated:YES
                             completion:^{
            }];
            
        }
        else
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_teacherAnnotationController];
            navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [navController setNavigationBarHidden:YES];
            [self presentViewController:navController
                               animated:YES
                             completion:^{
            }];
        }
    }
}

/*!
 * Will be called when save highlight request is succeeded.
 - This is a delegate method used when save highlight request execute successfully.
 */
- (void)didSaveHighlightDataSuccessfully{
    
}

/*!
 * Will be called when save highlight request is failed.
 */
-(void)didSaveHighlightDataFailedWithError:(NSError *)error withShareAndRecieveDict:(NSDictionary *)shareAndRecieveDict ForBookID:(NSNumber *)bookID
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager saveHighlightData:shareAndRecieveDict ForBookID:bookID ForUserToken:_user.userToken];
                }];
            }
            
        }else
        {
            [self showSessionExpiredAlert];
        }
    }else
    {
        if ([[KitabooNetworkManager getInstance] isInternetAvailable])
        {
            [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_SAVE_HIGHLIGHT_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
        }
        else{
            [self showAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
        }
        
    }
}


/*!
 * Will be called when save tracking request is succeeded.
 - This is a delegate method used when save tracking request execute successfully.
 */
- (void)didSaveTrackingDataSuccessfully{
    
}

/*!
 * Will be called when save tracking request is failed.
 * @param1 error Is the save tracking request fail error of type NSError.
 */
- (void)didSaveTrackingDataFailedWithError:(NSError *)error{
    
}


/*!
 * Will be called when AcceptOrReject request is succeeded.
 - This is a delegate method used when AcceptOrReject request execute successfully.
 */
- (void)didAcceptOrRejectDataSuccessfully{
    
}

- (void)didAcceptOrRejectDataSuccessfullywithUGCId:(NSString *)ugcID andIsAccepted:(BOOL)accepted
{
    NSArray *highlightsArray = [_dbManager highlightBookID:_bookID userID:_user.userID.numberValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"self.ugcID == %@",ugcID];
    NSArray *filteredArray = [highlightsArray filteredArrayUsingPredicate:predicate];
    SDKHighlightVO *highlightVO;
    if (filteredArray.count) {
        highlightVO = filteredArray.firstObject;
    }
    if (highlightVO.ugcID)
       {
           [_dbManager updateAnsweredUGC:highlightVO.ugcID accepted:accepted andUserId:_user.userID];
           NSArray *activePages=[_rendererView getActivePages];
           if([currentBook isKindOfClass:[KFBookVO class]])
           {
               for (KFPageVO *page in activePages)
               {
                   [self drawHighlightsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
               }
           }
           else
           {
               for (EPUBPage *page in activePages)
               {
                   [self drawHighlightsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] OnDisplayNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
               }
           }
       }
    NSArray *myDataArray = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    [_myDataViewController setData:myDataArray];
    [_myDataViewController reloadMyDataTableView];
    if (!isIPAD)
    {
        NSArray *childConterollerArray = [[_myDataViewController navigationController] childViewControllers];
        for (KBMyDataViewController *controller in childConterollerArray) {
            if (controller != _myDataViewController) {
                    [controller setData:myDataArray];
                    [controller reloadMyDataTableView];
                }
            }
    }
}

/*!
 * Will be called when AcceptOrReject request is failed.
 * @param1 error Is the AcceptOrReject request fail error of type NSError.
 */
-(void)didAcceptOrRejectDataFailedWithError:(NSError *)error withUGCId:(NSString *)ugcID andIsAccepted:(BOOL)accepted
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager acceptOrRejectCollab:ugcID andIsAccepted:accepted ForUserToken:_user.userToken];
                }];
            }
            
        }else
        {
            if (isIPAD) {
                [self showSessionExpiredAlert];
            }
            else
            {
                if (![[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] isKindOfClass:[UIAlertController class]])
                {
                    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"YOUR_SESSION_HAS_EXPIRED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
                    NSString *alert_Msg  = [LocalizationHelper localizedStringWithKey:@"PLEASE_SIGN_IN_AGAIN" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
                    [[AlertView sharedManager] presentAlertWithTitle:alert_Title message:alert_Msg andButtonsWithTitle:@[@"Ok"] onController:[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                        [self closeReaderForSessionExpiry];
                    }];
                }
            }
        }
    }else
    {
        if(isIPAD){
            [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_ACCEPT_OR_REJECT_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
        }
        else
        {
            [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_ACCEPT_OR_REJECT_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:NSLocalizedStringFromTableInBundle(error.localizedDescription,READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
            }];
        }
    }
    NSArray *myDataArray = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    [_myDataViewController setData:myDataArray];
    [_myDataViewController reloadMyDataTableView];
}

/*!
 * Will be called when save collab request is succeeded.
 * @discussion This method is used for Shared Notes (Collab Data). When user wants to save collab Data for book, he/she will use this method. Data will be fetched from local storage and saved on server.[For Managing Local Storage, it use HSDBManager].
 
 - This is a delegate method used when save collab request execute successfully.
 */
- (void)didSaveCollabDataSuccessfully{
    
}

/*!
 * Will be called when save collab request is failed.
 */
- (void)didSaveCollabDataFailedWithError:(NSError *)error
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                }];
            }
            
        }else
        {
            [self showSessionExpiredAlert];
        }
    }else
    {
        [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_SAVE_COLLAB_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
    }
}


/**
 Will be called when failed to save student anotation
 */
-(void)didFailedToSaveStudentAnotationWithError:(NSError*)error
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager saveTeacherAnnotationsForAnnotation:[_teacherAnnotationController getAnotationToSave] forLearnerID:_teacherAnnotationController.selectedLearnerID withBookID:_bookID WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
        }else
        {
            [self showSessionExpiredAlert];
        }
    }else
    {
        if (activityViewForTeacherReview)
        {
            [activityViewForTeacherReview removeFromSuperview];
            activityViewForTeacherReview = nil;
        }
        
        if (doneButtonSelectedForTeacherReview)
        {
            [self saveTeacherAnnotationFailedForDoneButtonWithError:error];
        }else
        {
            [self saveTeacherAnnotationFailedForStudentNameWithError:error];
        }
    }
}

-(void)saveTeacherAnnotationFailedForDoneButtonWithError:(NSError *)error
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"ALERT_BUTTON",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) message:NSLocalizedStringFromTableInBundle(@"FAILED_TO_SAVE_STUDENT_ANOTATION",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * noButton = [UIAlertAction actionWithTitle:[NSLocalizedStringFromTableInBundle(@"CANCEL",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) uppercaseString] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    activeMode=kPlayerActiveModeNone;
                                    [_rendererView setPenDrawingModeEnabled:NO];
                                    penToolController=nil;
                                    [_rendererView.view setUserInteractionEnabled:YES];
                                    [self removeTeacherAnnotation];
                                    [self loadPagesBeforeTeacherReview];
                                    return;
                                }];
    [noButton setValue:UIColor.blackColor forKey:@"titleTextColor"];
    UIAlertAction * yesButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"RETRY",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self didSelectDoneForTeacherReviewWithUpdatedAnotations:[_teacherAnnotationController getAnotationToSave] ForLearnerID:_teacherAnnotationController.selectedLearnerID];
                                     return;
                                 }];
    [yesButton setValue:UIColor.blackColor forKey:@"titleTextColor"];
    
    [alertController addAction:noButton];
    [alertController addAction:yesButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)saveTeacherAnnotationFailedForStudentNameWithError:(NSError *)error
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"ALERT_BUTTON",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) message:NSLocalizedStringFromTableInBundle(@"FAILED_TO_SAVE_STUDENT_ANOTATION",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * noButton = [UIAlertAction actionWithTitle:[NSLocalizedStringFromTableInBundle(@"CANCEL",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) uppercaseString] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    [self actionForTeacherReview];
                                    return;
                                }];
    [noButton setValue:UIColor.blackColor forKey:@"titleTextColor"];
    UIAlertAction * yesButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"RETRY",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self saveTeacherReviewedDataWhenUseTapOnStudentnameForAnnotations:[_teacherAnnotationController getAnotationToSave] ForLearnerID:_teacherAnnotationController.selectedLearnerID];
                                     return;
                                 }];
    [yesButton setValue:UIColor.blackColor forKey:@"titleTextColor"];
    
    [alertController addAction:noButton];
    [alertController addAction:yesButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 Will be called when save scrom request is successful
 */
-(void)didSavedScormDataSuccessfully{
    
}
/**
 Will be called when save scorm request is failed
 *@param1 error is the scorm request fail error
 */
-(void)didFailedToSaveScormWithError:(NSError *)error withBookID:(NSNumber *)bookID withScormID:(NSString *)scormID withClassID:(NSString *)classID
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager saveSormDataForUserID:[NSNumber numberWithInt:_user.userID.intValue] bookID:_bookID andClassId:_classID WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
        }else
        {
            [self showSessionExpiredAlert];
        }
    }
}

/**
 Will be called when fetch scrom request is successful
 */
-(void)didFetchScormDataSuccessfully{
    
}
/**
 Will be called when save scorm request is failed
 *@param1 error is the Fetch request fail error
 */
-(void)didFailedToFetchScormWithError:(NSError*)error
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager fetchAndSaveSormDataForUserID:[NSNumber numberWithInteger:[_user.userID integerValue]] bookID:_bookID andClassId:_classID WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
        }else
        {
            [self showSessionExpiredAlert];
        }
    }
}

/**
 Will be called when fetch furthest page request is successful
 *  @param1 bookID Is the book id for which further page data has been fetched.
 *  @param1 furthestPageData Is the Fetch further response.
 */
-(void)didFetchFurthestPageDataSuccessfullyForBookID:(NSNumber*)bookID WithFurthestPageData:(NSString *)furthestPageData
{
    NSLog(@"didFetchFurthestPageDataSuccessfully with book id = %@ and furthest page data = %@",bookID,furthestPageData);
    if(furthestPageData!=nil)
    {
        [_rendererView setFurthestPageData:furthestPageData];
    }
}

/**
 Will be called when fetch further page request is failed
 *@param1 error is the Fetch request fail error
 *@param2 bookID Is the book id for which fetch further page data has been failed.

 */
-(void)didFailedToFetchFurthestPageDataWithError:(NSError *)error ForBookID:(NSNumber*)bookID
{
    NSLog(@"didFailedToFetchFurthestPageDataWithError = %@ and book id = %@",error,bookID);
    if ([error code] == 401)
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager fetchFurthestPageDataForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
            else
            {
                [self showSessionExpiredAlert];
            }
        }
        else{
            [self showSessionExpiredAlert];
        }
    }
}

/**
 Will be called when user tap outside Pallete
 */
-(void)singleTapOnPentoolPalleteContainer:(UITapGestureRecognizer *)gesture
{
    [penColorPallete.view removeFromSuperview];
    penColorPallete=nil;
    
    [penToolPalleteContainer removeFromSuperview];
    penToolPalleteContainer =nil;
    
    [penToolThicknessPalleteViewController.view removeFromSuperview];
    penToolThicknessPalleteViewController=nil;
    
   //if([penToolController getPenMode] != PenModeSelection)
    [penToolActionBarView resetPlayerActionBarSelection];
    
    [penToolActionBottomBarView resetPlayerActionBarSelection];
    
    [self selectAudioSyncColorPalleteSelectionButton:false];
}

/**
 Will be called when user selects pen color from pen color pallet
 */
-(void)didSelectPenColor:(NSString *)color //delegate Method
{
    if (activeMode == kPlayerActiveModePentool) {
        [penToolController setPenColor:color];
        [penToolController setPenMode:PenModeDrawing];
        [penToolActionBarView updateColorSelectedView:[UIColor colorWithHexString:color] withColorThickness:[self getLastUpdatedPenThickness]];
        [self persistLastUpdatedPenColor:color];
        [self updateThicknessColor:color];
        [penToolActionBarView updateSelectedPenColor:color withTheme:hdThemeVO];
    } else if (activeMode == kPlayerActiveModeMarkupPlayer || activeMode == kPlayerActiveModeReadAloud){
        [self didSelectAudioSyncColor:color];
    } else if (activeMode == kPlayerActiveModeTeacherReview) {
        [self didSelectPenColorForTeacherReview:color];
    }
}

/**
 Update pen Color based on the color value passed
 */
-(void)updateThicknessColor:(NSString *)color
{
    NSArray *itemsArray = [penToolActionBarView getTappableItems];
    for (PlayerActionBarItem *actionBarItem in itemsArray)
    {
        if(actionBarItem.tag == kPenToolBarItemTypeThickness)
        {
            for(UIView *view in actionBarItem.subviews)
            {
                if([view isKindOfClass:[UILabel class]])
                {
                    UILabel *label=(UILabel*)view;
                    if([label.subviews count])
                        [label.subviews objectAtIndex:0].backgroundColor=[UIColor colorWithHexString:color];
                }
            }
        }
    }
}

-(void)updateAudioSyncColorPalleteSelectionColor:(NSString *)color
{
    NSArray *itemsArray = [playerBottomActionBarViewForAudioSync getTappableItems];
    for (PlayerActionBarItem *actionBarItem in itemsArray)
    {
        if(actionBarItem.tag == kPlayerActionBarItemTypeAudioSyncColorSelector)
        {
            for(UIView *view in actionBarItem.subviews)
            {
                if([view isKindOfClass:[HighLightToolView class]])
                {
                    HighLightToolView *highlightToolV=(HighLightToolView*)view;
                    highlightToolV.iconLabel.backgroundColor = [UIColor colorWithHexString:color];
                }
            }
        }
    }
}

-(void)selectAudioSyncColorPalleteSelectionButton:(BOOL)isSelect
{
    NSArray *itemsArray = [playerBottomActionBarViewForAudioSync getTappableItems];
    for (PlayerActionBarItem *actionBarItem in itemsArray)
    {
        if(actionBarItem.tag == kPlayerActionBarItemTypeAudioSyncColorSelector)
        {
            if (isSelect) {
                actionBarItem.backgroundColor = hdThemeVO.top_toolbar_icons_color;
            } else {
                actionBarItem.backgroundColor = UIColor.clearColor;
            }
            for(UIView *view in actionBarItem.subviews)
            {
                if([view isKindOfClass:[UILabel class]])
                {
                    UILabel *label=(UILabel*)view;
                    if (isSelect) {
                        label.textColor = UIColor.whiteColor;
                    } else {
                        label.textColor = hdThemeVO.top_toolbar_icons_color;
                    }
                }
            }
        }
    }
}

/**
 Update pen thickness font based on the thickness value passed
 */
-(void)updateThicknessFont:(float)font
{
    NSArray *itemsArray = [penToolActionBarView getTappableItems];
    for (PlayerActionBarItem *actionBarItem in itemsArray)
    {
        if(actionBarItem.tag == kPenToolBarItemTypeThickness)
        {
            for(UIView *view in actionBarItem.subviews)
            {
                if([view isKindOfClass:[UILabel class]])
                {
                    UILabel *label=(UILabel*)view;
                    if([label.subviews count])
                    {
                        widthConstaint.constant=font;
                        heightConstaint.constant=font;
                        [label layoutIfNeeded];
                        [label.subviews objectAtIndex:0].layer.cornerRadius=font/2;
                    }
                }
            }
        }
    }
}

/**
 Will be called when PenTool Color Pallete View is dismissed
 */
-(void)willDismissPenToolColorPalleteView
{
    [penToolActionBarView resetPlayerActionBarSelection];
}

/**
 Will be called when PenTool Thickness Pallete View is dismissed
 */
-(void)willDismissPenToolThicknessPalleteView
{
    [penToolActionBarView resetPlayerActionBarSelection];
}
/**
 Will be called when user change pen thickness
 */
-(void)didSelectPenThickness:(float)value //delegate method
{
    [penToolController setPenStrokeThickness:value];
    [self persistLastUpdatedPenThickness:value];
    [self updateThicknessFont:value];
    [penToolActionBarView updateColorSelectedView:[UIColor colorWithHexString:[self getLastUpdatedPenColor]] withColorThickness:value];
}

/**
 Save Pen Color
 */
-(void)persistLastUpdatedPenColor:(NSString*)color
{
    [[NSUserDefaults standardUserDefaults] setObject:color forKey:@"PenColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 Save Pen Thickness
 */
-(void)persistLastUpdatedPenThickness:(float)thickness
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",thickness] forKey:@"PenThickness"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/**
 Returns Last used PenColor, if used first time, will return default PenColor
 */
-(NSString*)getLastUpdatedPenColor
{
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"PenColor"])
    {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"PenColor"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@DefaultPenColor forKey:@"PenColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return @DefaultPenColor;
    }
}

/**
 Returns Last used PenThickness, if used first time, will return default thickness
 */
-(float)getLastUpdatedPenThickness
{
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"PenThickness"])
    {
        return [[[NSUserDefaults standardUserDefaults] stringForKey:@"PenThickness"] floatValue];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",DefaultPenColorThickness] forKey:@"PenThickness"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return DefaultPenColorThickness;
    }
}
/**
 Return instance of PlayerActionBarItem for PenToolBarItemType
 */
-(PlayerActionBarItem*)getPenToolItemWithTag:(PenToolBarItemType)penToolBarItemType
{
    if (isIPAD)
    {
        for (PlayerActionBarItem *playerActionBarItem in [penToolActionBarView getTappableItems]) {
            if(playerActionBarItem.tag==penToolBarItemType)
            {
                return playerActionBarItem;
            }
        }
        for (PlayerActionBarItem *playerActionBarItem in [penToolActionBottomBarView getTappableItems]) {
            if(playerActionBarItem.tag==penToolBarItemType)
            {
                return playerActionBarItem;
            }
        }
    }else
    {
        for (PlayerActionBarItem *playerActionBarItem in [penToolActionBarView getTappableItems]) {
            if(playerActionBarItem.tag==penToolBarItemType)
            {
                return playerActionBarItem;
            }
        }
        for (PlayerActionBarItem *playerActionBarItem in [penToolActionBottomBarView getTappableItems]) {
            if(playerActionBarItem.tag==penToolBarItemType)
            {
                return playerActionBarItem;
            }
        }
    }
    return nil;
}

#pragma KitabooDataSyncingManagerDelegate Implementation
/**
 KitabooDataSyncingManagerDelegate Implementation
 */
-(void)didFetchedUGCSuccessfully
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self relaodPageUGCForActivePages];
        [self updateClearAllFIBsButtonStatus];
    });
}

- (void)migrateHighlightAndNoteColors
{
    NSArray* highlights = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    for (SDKHighlightVO *highlightVO in highlights)
    {
        if (!highlightVO.isTeacherReviewNote) {
            if (![hdThemeVO.highlight_Color_Array containsObject:[self getStringValue:highlightVO.backgroundColor]]){
                if (highlightVO.isImportant){
                    highlightVO.backgroundColor = hdThemeVO.highlight_Color_Array[1];
                }
                else{
                    highlightVO.backgroundColor = hdThemeVO.highlight_Color_Array[0];
                }
                highlightVO.isImportant = NO;
                highlightVO.status = UPDATE;
                [_dbManager saveHighlight:highlightVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
            }
        }
    }
}

-(NSString *)getStringValue:(id)object
{
    if([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    return [object stringValue];
}
/**
 KitabooDataSyncingManagerDelegate Implementation
 */
-(void)didFailedToFetchUGCWithError:(NSError*)error
{
    [self stopActivityIndicator];
    //    [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_TO_FETCH_UGC"]];
}
-(void)didUGCFetchCompletedSuccessfullyWithUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    [self migrateHighlightAndNoteColors];
    if(activeMode != kPlayerActiveModeTeacherReview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self relaodPageUGCForActivePages];
            [self updateClearAllFIBsButtonStatus];
            if(activeMode == kPlayerActiveModeInstruction)
            {
                [self loadInstructionMarkup:[instructionPopOverContentVC getLinkVo]];
            }
        });
    }
}
/**
 KitabooDataSyncingManagerDelegate Implementation
 */
-(void)didUGCSynchCompletedSuccessfully
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        if(book.meta.layout!=ePUBReflowable)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self relaodPageUGCForActivePages];
            });
        }
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self relaodPageUGCForActivePages];
        });
    }
}

-(void)didUGCFetchFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    [self stopActivityIndicator];
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    //[_dataSyncManager fetchUGCOperationForBookID:[NSNumber numberWithInt:bookID.intValue] ForUserID:[NSNumber numberWithInt:userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
            
            
        }else
        {
            [self showSessionExpiredAlert];
        }
    }else
    {
        //        [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"UGC_SYNCHING_FAILED"]];
    }
    [self relaodPageUGCForActivePages];
}

/**
 KitabooDataSyncingManagerDelegate Implementation
 */
-(void)didUGCSynchFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    [self stopActivityIndicator];
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                    _user = renewedUser;
                    [_dataSyncManager synchUGCForBookID:[NSNumber numberWithInt:bookID.intValue] ForUserID:[NSNumber numberWithInt:userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
                }];
            }
            
        }else
        {
            [self showSessionExpiredAlert];
        }
    }else
    {
        //        [self showAlertForError:error WithTitle:[LocalizationHelper localizedStringWithKey:@"UGC_SYNCHING_FAILED"]];
    }
}

/**
 To perform action when user select some learner from learner list on teacher review
 */
-(void)actionForSelectedLearnerData:(NSMutableDictionary*)learnerDict withLearnerID:(NSString *)learnerID
{
    if (_teacherAnnotationData)
    {
        _teacherAnnotationData = nil;
        _studentFolioPagesUGCData = nil;
    }
    _teacherAnnotationData = [[NSMutableDictionary alloc] init];
    _studentFolioPagesUGCData = [[NSMutableDictionary alloc] init];
    topConstOfTeacherReview.constant = -(penToolBar_Height);
    if (!isIpad())
    {
        bottomConstOfTeacherReview.constant = penToolBar_Height;
    }
    [UIView animateWithDuration:0.4 animations:^
     {
         [self.view layoutIfNeeded];
         [penToolActionBarView removeFromSuperview];
         penToolActionBarView = nil;
         [penToolActionBottomBarView removeFromSuperview];
         penToolActionBottomBarView = nil;
     }];
    penToolController = nil;
    [self resetAllPlayerActionBar];
    
    NSMutableDictionary *studentPageUGCDictionary=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *studentFolioUGCDictionary=[[NSMutableDictionary alloc]init];
    for (NSDictionary *pageUGCs in learnerDict)
    {
        if([[pageUGCs objectForKey:@"ugcList"] count]>0)
        {
            NSMutableArray *ugcArray=[[NSMutableArray alloc]init];
            for (NSDictionary *ugcDic in [pageUGCs objectForKey:@"ugcList"])
            {
                if([[ugcDic valueForKey:@"type"] integerValue] == KUGCTypeFIB || [[ugcDic valueForKey:@"type"] integerValue] == KUGCTypeEquation)
                {
                    [ugcArray addObject:[_dbManager getSDKFIBVOFromUGCDictionary:ugcDic]];
                }
                else
                {
                    [ugcArray addObject:[_dbManager getSDKPenToolVOFromUGCDictionary:ugcDic]];
                }
            }
            if([pageUGCs objectForKey:@"pageId"] && ugcArray.count)
            {
                [studentPageUGCDictionary setObject:ugcArray forKey:[[pageUGCs objectForKey:@"pageId"] stringValue]];
            }
            
            NSArray *ugcList = [pageUGCs objectForKey:@"ugcList"];
            NSString *folioID = [ugcList.firstObject objectForKey:@"folioID"];
            NSNumber *pageID = [pageUGCs objectForKey:@"pageId"];
            if(ugcArray.count>0){
                if (!folioID.integerValue) {
                    [studentFolioUGCDictionary setObject:ugcArray forKey:[NSString stringWithFormat:@"%@,%@",pageID.stringValue,folioID]];
                }else{
                    [studentFolioUGCDictionary setObject:ugcArray forKey:folioID];
                }
            }
        }
    }
    //sort
    NSArray *studentUgcPageArray = [studentPageUGCDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    _teacherAnnotationData = studentPageUGCDictionary;
    _studentFolioPagesUGCData = studentFolioUGCDictionary;
    selectLearnerIDForTeacherReview = learnerID;
    [_teacherAnnotationController setStudentPageUGCDictionary:studentPageUGCDictionary];
    [_teacherAnnotationController setSelectedLearnerID:learnerID];
    [_teacherAnnotationController setStudentSubmittedPageArray:studentUgcPageArray];
    [UIView animateWithDuration:0.4 animations:^{
        if (studentUgcPageArray.count != 0)
        {
            [_rendererView enableTeacherReviewModeWithPageArray:studentUgcPageArray];
        }
    }];
    [self actionForTeacherReviewPageChanged];
    [_rendererView.view setUserInteractionEnabled:YES];
}

-(void)actionForTeacherReviewForLearner:(NSString*)learnerName withLearnerID:(NSString*)learningID
{
    NSMutableDictionary *studentPageUGCDictionary=[[NSMutableDictionary alloc]init];
    KitabooServiceInterface *kitabooServiceInterface=[[KitabooServiceInterface alloc] initWithBaseURLString:_baseURL clientID:_clientID];
    NetworkDataTaskOperation *fetchStudentAnnotationsOperation = [kitabooServiceInterface fetchStudentAnnotations:_user.userToken bookId:[NSString stringWithFormat:@"%@",_bookID] learnerId:learningID successHandler:^(NSDictionary *json)
                                                                  {
                                                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                                          [studentPageUGCDictionary setObject:json forKey:learningID];
                                                                          [_teacherAnnotationController setSubmittedStudentUGCArray:studentPageUGCDictionary];
                                                                      });
                                                                  } failureHandler:^(NSError *error)
                                                                  {
                                                                      NSDictionary *userDictionary = error.userInfo;
                                                                      NSDictionary *invalidDic = userDictionary[@"invalidFields"];
                                                                      NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
                                                                      if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
                                                                      {
                                                                          if ([_userSettingsModel isAutoLoginEnabled])
                                                                          {
                                                                              if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                                                                                  [_delegate refreshUserTokenForUser:_user withExpiredToken:userDictionary[@userTokenKey] completed:^(KitabooUser *renewedUser) {
                                                                                      _user = renewedUser;
                                                                                      [self actionForTeacherReviewForLearner:learnerName withLearnerID:learningID];
                                                                                  }];
                                                                              }
                                                                              
                                                                          }else
                                                                          {
                                                                              [self showSessionExpiredAlert];
                                                                              return;
                                                                          }
                                                                      }else
                                                                      {
                                                                          [_teacherAnnotationController serviceFailedWithLearnerID:learningID];
                                                                      }
                                                                  }];
    [fetchStudentAnnotationsOperation start];
}

-(void)didClickOnPageButton:(int)tag{
    NSArray *totalSubmittedPages = [self getSortedPageArrayOfStudentSubmitedUgc];
    NSArray *displayesPages = [self getActivePageIDs];
    int indexOfCurrentPage;
    int navigatePageIndex;
    if(tag == kPenToolBarItemTypePrevPage) {
        if([totalSubmittedPages containsObject:[displayesPages firstObject]]) {
            indexOfCurrentPage = (int)[totalSubmittedPages indexOfObject:[displayesPages firstObject]];
        }
        else {
            indexOfCurrentPage = (int)[totalSubmittedPages indexOfObject:[displayesPages lastObject]];
        }
        navigatePageIndex = indexOfCurrentPage - 1;
    }else {
        if([totalSubmittedPages containsObject:[displayesPages lastObject]]) {
            indexOfCurrentPage = (int)[totalSubmittedPages indexOfObject:[displayesPages lastObject]];
        }
        else {
            indexOfCurrentPage = (int)[totalSubmittedPages indexOfObject:[displayesPages firstObject]];
        }
        navigatePageIndex = indexOfCurrentPage + 1;
    }
    
    if(navigatePageIndex >= 0 && (navigatePageIndex < totalSubmittedPages.count)){
        [self didSelectNavigatePageButtonForTeacherReview:[totalSubmittedPages objectAtIndex:navigatePageIndex]];
    }
}

-(NSArray *)getSortedPageArrayOfStudentSubmitedUgc{
    NSArray *totalPagesArray = [_teacherAnnotationController.studentPageUGCDictionary allKeys];
    if(totalPagesArray.count)
    {
        totalPagesArray = [totalPagesArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
    }
    return totalPagesArray;
}

-(UILabel *)getTeacherViewPlayerActionBarItemLabelWithTag:(PenToolBarItemType)tag
{
    UILabel *label = nil;
    if (penToolActionBarView)
    {
        if (penToolActionBarView.tag == kPlayerActionBarItemTypeTeacherReview)
        {
            NSArray *itemsArray = [penToolActionBarView getTappableItems];
            for (PlayerActionBarItem *actionBarItem in itemsArray)
            {
                if(actionBarItem.tag == tag)
                {
                    for(UIView *view in actionBarItem.subviews)
                    {
                        if([view isKindOfClass:[UILabel class]])
                        {
                            label =(UILabel*)view;
                        }
                    }
                }
            }
        }
    }
    return label;
}


/**
 Call is method to show alert for Error, with title to be shown in alert
 */
-(void)showAlertForError:(NSError*)error WithTitle:(NSString*)title
{
    BOOL isSessionExpire =NO;
    NSDictionary *userInfoDict = error.userInfo;
    NSDictionary *invalidFieldsDict = [userInfoDict valueForKey:@"invalidFields"];
    if(invalidFieldsDict.count>0)
    {
        NSString *userToken = [NSString stringWithFormat:@"%@",[invalidFieldsDict valueForKey:@"usertoken"]];
        if([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
        {
            isSessionExpire = YES;
        }
    }
    if(isSessionExpire)
    {
        [self showSessionExpiredAlert];
    }
    else
    {
        [self showAlertWithTitle:title WithMessage:NSLocalizedStringFromTableInBundle(error.localizedDescription,READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)];
    }
}

#pragma Teacher Review Delegate
/**
 TeacherReviewDelegate Implementation
 */
-(void)didSelectLearner:(NSString *)learnerName WithLearnerID:(NSString *)learnerID
{
    [self actionForTeacherReviewForLearner:learnerName withLearnerID:learnerID];
}

-(void)setSelectedLearnerData:(NSMutableDictionary *)learnerDict withLearnerID:learnerID
{
    [_teacherAnnotationController dismissViewControllerAnimated:YES completion:nil];
    [self actionForSelectedLearnerData:learnerDict withLearnerID:learnerID];
}

/**
 TeacherReviewDelegate Implementation
 */
-(void)didSelectNavigatePageButtonForTeacherReview:(NSString *)pageNumber
{
    [_rendererView navigateToPageNumber:pageNumber];
}


/**
 This is called automatically when class instance is about to release
 */
-(void)dealloc
{
    _rendererView=nil;
    _highlightView=nil;
    _tocViewController=nil;
    _bookMarkController=nil;
    _noteController=nil;
    _thumbnailViewController=nil;
    fixedEpubThumbnailVC = nil;
    _dbManager=nil;
    currentBook=nil;
    penToolController=nil;
    self.playerTopActionBarView=nil;
    _playerBottomActionBarView=nil;
    self.playerTopActionBarView=nil;
    penToolActionBarView=nil;
    _myDataViewController=nil;
    _topBarTopMarginConstraint=nil;
    _bottomBarBottomMarginConstraint=nil;
    _analyticsAdapter = nil;
    videoPlayer = nil;
    readToMeViewController=nil;
    hdThemeVO = nil;
    _readAloudBarTopMarginConstraint = nil;
    analyticsHandler = nil;
}


/**
 Create activity indicator view, call this method to add activity indicator
 */

-(void)addActivityIndicator
{
    _activityIndicatorView=nil;
    _activityIndicatorView = [[UIView alloc]init];
    _activityIndicatorView.backgroundColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:0.9];
    _activityIndicatorView.layer.masksToBounds = YES;
    _activityIndicatorView.layer.cornerRadius = 10;
    _activityIndicatorView.hidden=YES;
    [self.view addSubview:_activityIndicatorView];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints =NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:activityIndicator_Width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:activityIndicator_Height]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    [_activityIndicatorView addSubview:activityIndicator];
    activityIndicator.translatesAutoresizingMaskIntoConstraints =NO;
    
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
    
    UILabel *loadingDataLabel = [[UILabel alloc]init];
    [loadingDataLabel setText:[LocalizationHelper localizedStringWithKey:@"LOADING_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
    [loadingDataLabel setTextColor:[UIColor whiteColor]];
    [loadingDataLabel setFont:getCustomFont(20)];
    loadingDataLabel.textAlignment = NSTextAlignmentCenter;
    [_activityIndicatorView addSubview:loadingDataLabel];
    loadingDataLabel.translatesAutoresizingMaskIntoConstraints =NO;
    
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20]];
    [_activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
}


/**
 To start activity indicator
 */
-(void)startActivityIndicator
{
    [self addActivityIndicator];
    self.view.userInteractionEnabled=NO;
    _activityIndicatorView.hidden = NO;
}

/**
 TO stop activity indicator
 */
-(void)stopActivityIndicator
{
    [_activityIndicatorView removeFromSuperview];
    _activityIndicatorView =nil;
    self.view.userInteractionEnabled=YES;
}

#pragma mark : Keyboard notification method
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        if (isIphoneX || windowWidth == 812){
            CGFloat diff =  (windowWidth == 812) ? keyboardSize.size.height - 22 : keyboardSize.size.height - 34;
            bottomConstraintOfTextSearchView.constant = diff;
        }
        else
            bottomConstraintOfTextSearchView.constant = keyboardSize.size.height;
        [self.view layoutIfNeeded];
        
    }];
    [self updatePlayerBottomBarPositionWithKeyboardSize:keyboardSize];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.4 animations:^{
        bottomConstraintOfTextSearchView.constant = 0.0;
        [self.view layoutIfNeeded];
        
    }];
    [self updatePlayerBottomBarPositionWithKeyboardSize:CGRectZero];
}
/*
 Handle text added in search text field
 */

-(void)searchTapGestureAction{
    if (activeMode != kplayerActiveModeElasticSearch)
    {
        [self removeSearchController];
    }
    [self clearSearchHighlights];
}

-(void)closeSearchView{
    searchTextStr = @"";
    if (activeMode == kplayerActiveModeElasticSearch)
    {
        _searchController = nil;
        _elasticSearchText = nil;
        _searchResult  = nil;
        [self showHelpScreen:NO];
    }
    [self removeSearchController];
    [self clearSearchHighlights];
}

- (void)openSearchView
{
    if (activeMode == kplayerActiveModeElasticSearch)
    {
        isSearchResultOpened = !isSearchResultOpened;
        if (isSearchResultOpened){
            [searchTextViewForIpad showSearchResultView];
        }
        else{
            [searchTextViewForIpad removeSearchResultView];
        }
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([searchTextViewForIpad isDescendantOfView:self.view]){
        if (activeMode != kplayerActiveModeElasticSearch)
        {
            if ([touch.view isKindOfClass:[UIVisualEffectView class]]) {
                // Don't let selections of auto-complete entries fire the
                // gesture recognizer
                return YES;
            }
        }
        
        return NO;
    }
    if([touch.view isDescendantOfView:penToolThicknessPalleteViewController.view] || [touch.view isDescendantOfView:penColorPallete.view]){
        return NO;
    }
    if([touch.view isDescendantOfView:playerTopActionBarViewForReadAloud])
    {
        return NO;
    }
    return YES;
    
}

-(void)addBlurEffectToReaderView{
    //    only apply the blur if the user hasn't disabled transparency effects
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.rendererView.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //-- For ElasticSearch
        if (activeMode == kplayerActiveModeElasticSearch)
        {
            blurEffectView.alpha = 0.1;
        }
        else{
            blurEffectView.alpha = 0.6;
        }
        //--
        [searchTextViewForIpad insertSubview:blurEffectView atIndex:0]; //if you have more UIViews, use an insertSubview API to place it where needed
    } else {
        self.rendererView.view.alpha = 0.5;
    }
}

/**
 TextSearchControllerDelegate Implementation
 */
-(void)didSearchTextChanged
{
    if(_searchResult && ![_searchResult.searchedWord isEqualToString:@""])
    {
        _searchResult=nil;
        [self clearSearchHighlights];
    }
}

/**
 To reload all the Search text(Used in case of orientation is changes )
 */
-(void)reloadSearchHighlightText
{
    if(_searchResult && ![_searchResult.searchedWord isEqualToString:@""])
    {
        for (NSString *pageID in [self getActivePageIDs])
        {
            [_rendererView highlightText:_searchResult.searchedWord OnPageNo:pageID.integerValue WithColor:nil];
        }
    }
}

/**
 UITextFieldDelegate implementation
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchTextViewForIpad.searchBar){
        
        if([textField.text length]>=MininumSearchStringLenght)
        {
            [textField resignFirstResponder];
            [self addSearchForText:searchTextViewForIpad.searchBar.text isElasticSearch:NO];
        }else {
            [self addSearchForText:@"" isElasticSearch:NO];
        }
    }
    return true;
}

/**
 UITextFieldDelegate implementation
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    if(textField == searchTextViewForIpad.searchBar)
    {
        [self clearSearchHighlights];
        if(textField == searchTextViewForIpad.searchBar){
            [self addSearchForText:@"" isElasticSearch:NO];
            _searchResult=nil;
        }
        else{
            _searchResult=nil;
            [self removeSearchController];
        }
        
    }
    return YES;
}
/**
 UITextFieldDelegate implementation
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= MaximumSearchStringLength){
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *textStr = [textField.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.searchEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:textStr,KitabooReaderEventConstant.searchEventParameterSearchText, nil]];
    
    /** Removed Search on text field change and increased the char limit to 2 to 3 chars.*/
//    if (textField == searchTextViewForIpad.searchBar){
//        [self clearSearchHighlights];
//        if(textStr.length >= MininumSearchStringLenght)
//        {
//            [self addSearchForText:[textStr stringByTrimmingCharactersInSet:
//            [NSCharacterSet whitespaceAndNewlineCharacterSet]] isElasticSearch:NO];
//        }
//        else{
//            [self addSearchForText:@"" isElasticSearch:NO];
//        }
//    }
}
/**
 To Remove all highlighted text (Result of Search)
 */

-(void)clearSearchHighlights
{
    for (NSString *pageID in [self getActivePageIDs])
    {
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *book=(EPUBBookVO*)currentBook;
            if(book.meta.layout==ePUBReflowable)
            {
                [_rendererView highlightText:@"" OnPageNo:0 WithColor:@SeacherMaskColor WithParagraph:nil];
            }
            else
            {
                [_rendererView highlightText:@"" OnPageNo:pageID.integerValue WithColor:nil];
            }
        }
        else
        {
            [_rendererView highlightText:@"" OnPageNo:pageID.integerValue WithColor:nil];
        }
    }
}

/**
 Removes Search controller
 */
-(void)removeSearchController
{
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    self.rendererView.view.alpha = 1;
    NSPredicate *predicateToFindClass = [NSPredicate predicateWithFormat:
                                         @"self isMemberOfClass: %@", [UIVisualEffectView class]];
    NSArray *araayOfBurrEffectView = [[searchTextViewForIpad subviews] filteredArrayUsingPredicate:predicateToFindClass];
    if(araayOfBurrEffectView.count){
        for (UIVisualEffectView *view in araayOfBurrEffectView) {
            [view removeFromSuperview];
        }
        
    }
    [self resetAllPlayerActionBar];
    //    if (isIpad())
    //    {
    [searchTextViewForIpad removeFromSuperview];
    searchTextViewForIpad = nil;
    //        [_searchController dismissViewControllerAnimated:NO completion:nil];
    [self resignSearchTextField];
    [self resetAllPlayerActionBar];
    //        _searchController = nil;
    //    }
    //    else
    //    {
    //        [_searchController dismissViewControllerAnimated:NO completion:nil];
    //        [self resetAllPlayerActionBar];
    //        //_searchController=nil;
    //    }
}

/**
 To Show Alert with Title and Message
 */
-(void)showAlertWithTitle:(NSString*)title WithMessage:(NSString*)message
{
    [[AlertView sharedManager] presentAlertWithTitle:title message:message andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
    }];
}

/**
 To Show session expired Alert
 */
-(void)showSessionExpiredAlert
{
    if (![[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] isKindOfClass:[UIAlertController class]])
    {
        if ([_delegate respondsToSelector:@selector(didSessionExpiredForReader:)]) {
            [_delegate didSessionExpiredForReader:self];
        }
    }
}

/**
 Release all Global object when reader is closed when session is expired
 */
-(void)closeReaderForSessionExpiry
{
    [self saveReaderAnalytics];
    if (_user)
    {
        if ([_delegate respondsToSelector:@selector(didSignOutForUser:)])
        {
            [_delegate didSignOutForUser:_user];
        }
    }
    if ([_delegate respondsToSelector:@selector(didClosedReader:ForBookID:withLastPageFolio:withAvgTimePerPage:withIsReaderForceClosed:)]) {
        [_delegate didClosedReader:self ForBookID:_bookID withLastPageFolio:_lastPageFolio withAvgTimePerPage:_avgTimePerPage withIsReaderForceClosed:YES];
    }
}


#pragma Page History
-(void)setpagesIntoHistoryArray:(NSString*)page
{
    NSArray *activePages=[self getActivePageIDs];
    if(activePages.count)
    {
        if(isPageNavigateByScroll)
        {
            [self insertPageIntoArray:page];
        }
        else
        {
            activeHistoryPageCount++;
            if(activeHistoryPageCount == [activePages count])
            {
                isPageNavigateByScroll = YES;
                activeHistoryPageCount =0;
            }
        }
    }
}
-(void)insertPageIntoArray:(NSString*)page
{
    NSArray *activePages=[self getActivePageIDs];
    if(activePages.count == 1)
    {
        [self addSinglePage:page];
    }
    else if(activePages.count == 2)
    {
        [self addTwoPages];
    }
}
-(void)addSinglePage:(NSString*)page
{
    NSString *lastPage = [NSString stringWithFormat:@"%@",[_navigationHistoryPagesArray lastObject]];
    if(![lastPage isEqualToString:page])
        [self addPageIntoPageHistoryArray:page];
    
}
-(void)addTwoPages
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *activePages=[self getActivePageIDs];
        [self addPageIntoPageHistoryArray:[activePages objectAtIndex:0]];
    });
    
}
-(void)addPageIntoPageHistoryArray:(NSString*)pageNumber
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(epubBook.meta.layout==ePUBFixedLayout)
        {
            NSInteger pageNum = pageNumber.integerValue;
            if(pageNum !=0 || [pageNumber isEqualToString:@"0"])
            {
                EPUBChapter *chapter = [self getEpubChapterForIndex:pageNum];
                pageNumber = chapter != nil ? chapter.href : pageNumber;
            }
        }
    }
//    if([_navigationHistoryPagesArray lastObject] != pageNumber)
//    {
//        [_navigationHistoryPagesArray addObject:pageNumber];
//    }
//    currentHistoryPageIndex = (int)[_navigationHistoryPagesArray count]-1;
    
    if([_navigationHistoryPagesArray count])
    {
        if([_navigationHistoryPagesArray lastObject] != pageNumber && _navigationHistoryPagesArray[currentHistoryPageIndex] != pageNumber)
        {
            [_navigationHistoryPagesArray addObject:pageNumber];
            currentHistoryPageIndex = (int)[_navigationHistoryPagesArray count]-1;
            [self enableHistoryButtons];
        }
    }
    else
    {
        [_navigationHistoryPagesArray addObject:pageNumber];
        currentHistoryPageIndex = (int)[_navigationHistoryPagesArray count]-1;
        [self enableHistoryButtons];
    }
}
-(void)enableHistoryButtons
{
    int totalPagesInArray = (int)[_navigationHistoryPagesArray count];
    if(totalPagesInArray == 1 || totalPagesInArray == 0)
    {
        [_thumbnailViewController enablePreviousPageHistory:NO];
        [_thumbnailViewController enableNextPageHistory:NO];
    }
    else if (totalPagesInArray == currentHistoryPageIndex+1)
    {
        [_thumbnailViewController enablePreviousPageHistory:YES];
        [_thumbnailViewController enableNextPageHistory:NO];
    }
    else if (currentHistoryPageIndex == 0 && totalPagesInArray>1)
    {
        [_thumbnailViewController enablePreviousPageHistory:NO];
        [_thumbnailViewController enableNextPageHistory:YES];
    }
    else
    {
        [_thumbnailViewController enablePreviousPageHistory:YES];
        [_thumbnailViewController enableNextPageHistory:YES];
    }
}
#pragma History page delegates
-(void)didClickPreviousHistoryButtonWithCurrentPageNumber
{
    if(currentHistoryPageIndex>0)
    {
        isPageNavigateByScroll = NO;
        int navigateIndex = [self getPrevPageNavigateIndex];
        [_rendererView navigateToPageNumber:_navigationHistoryPagesArray[navigateIndex]];
        [self resetHistoryPageIndex];
        [self removeThumbnail];
    }
}
-(void)didClickNextHistoryButtonWithCurrentPageNumber
{
    if(currentHistoryPageIndex < [_navigationHistoryPagesArray count])
    {
        int navigateIndex = [self getNextPageNavigateIndex];
        isPageNavigateByScroll = NO;
        [_rendererView navigateToPageNumber:_navigationHistoryPagesArray[navigateIndex]];
        [self removeThumbnail];
    }
}
-(int)getPrevPageNavigateIndex
{
    NSArray *activePages=[self getActivePageIDs];
    if(activePages.count == 2)
    {
        NSString *pageNumber = [self getConvertedPageNumberForHistory:[activePages objectAtIndex:0]];
        if([pageNumber isEqualToString:_navigationHistoryPagesArray[currentHistoryPageIndex-1]])
        {
            currentHistoryPageIndex -=2;
            if(currentHistoryPageIndex<=0)
            {
                currentHistoryPageIndex = 0;
            }
        }
        else
        {
            currentHistoryPageIndex--;
        }
        
    }
    else
    {
        currentHistoryPageIndex--;
    }
    return currentHistoryPageIndex;
}
-(int)getNextPageNavigateIndex
{
    NSArray *activePages=[self getActivePageIDs];
    if(activePages.count == 2)
    {
        NSString *pageNumber = [self getConvertedPageNumberForHistory:[activePages objectAtIndex:1]];
        if([pageNumber isEqualToString:_navigationHistoryPagesArray[currentHistoryPageIndex+1]])
        {
            currentHistoryPageIndex +=2;
            int pagesCount  = (int)[_navigationHistoryPagesArray count]-1;
            if(currentHistoryPageIndex>=pagesCount)
            {
                currentHistoryPageIndex = pagesCount;
            }
        }
        else
        {
            currentHistoryPageIndex++;
        }
        
    }
    else
    {
        currentHistoryPageIndex++;
    }
    return currentHistoryPageIndex;
}
-(NSString*)getConvertedPageNumberForHistory:(NSString*)pageNumber
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if(epubBook.meta.layout==ePUBFixedLayout)
        {
            EPUBChapter *chapter = [self getEpubChapterForIndex:pageNumber.integerValue];
            if (chapter.href)
                return chapter.href;
        }
    }
    return pageNumber;
}
-(void)resetHistoryPageIndex
{
    if(currentHistoryPageIndex == 1)
    {
        NSArray *activePages=[self getActivePageIDs];
        if(activePages.count == 2)
        {
            NSString *pageNumber = [self getConvertedPageNumberForHistory:[activePages objectAtIndex:0]];
            if([pageNumber isEqualToString:_navigationHistoryPagesArray[currentHistoryPageIndex-1]])
            {
                currentHistoryPageIndex = 0;
            }
        }
    }
}
-(void)resetPageHistoryIndexOnTransition
{
    if([_navigationHistoryPagesArray count])
    isPageNavigateByScroll = NO;
    NSArray *activePages=[self getActivePageIDs];
    if(activePages.count == 1)
    {
        NSString *pageNumber = [self getConvertedPageNumberForHistory:[activePages objectAtIndex:0]];
        if(_navigationHistoryPagesArray.count)
        {
            if(![pageNumber isEqualToString:_navigationHistoryPagesArray[currentHistoryPageIndex]])
            {
                if(currentHistoryPageIndex)
                {
                    if([pageNumber isEqualToString:_navigationHistoryPagesArray[currentHistoryPageIndex-1]])
                    {
                        currentHistoryPageIndex--;
                    }
                }
            }
        }
    }
}
#pragma Search delegates
/**
 TextSearchControllerDelegate implementation
 */
-(void)didSelectSearchText:(TextSearchResult *)searchResult
{
    [_rendererView isNextSearchResultAvailableForSearchResult:searchResult];
    [self enableNextButtonForElasticSearch:YES];
    [self enablePreviousButtonForElasticSearch:YES];
    
    [searchTextViewForIpad removeSearchResultView];
    _searchResult=searchResult;
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        [_rendererView navigateToPageNumber:searchResult.href];
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        if(book.meta.layout==ePUBReflowable)
        {
            NSString *context = [[[searchResult.searchResultAttributedString string] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
            if(_searchResult && ![_searchResult.searchedWord isEqualToString:@""])
            {
                if(activeMode != kplayerActiveModeElasticSearch)
                {
                    [_rendererView highlightText:_searchResult.searchedWord OnPageNo:0 WithColor:@SeacherMaskColor WithParagraph:context];
                }
                else
                {
                    [_rendererView highlightText:_searchResult.searchedWord OnPageNo:[self getFileIndexForHREF:_searchResult.href].integerValue WithColor:@SeacherMaskColor WithParagraph:context];
                    [_rendererView highlightText:_searchResult.searchedWord OnPageNo:[self getFileIndexForHREF:_searchResult.href].integerValue WithColor:@SeacherMaskColor withSelectedWordHighlightColor:@SeacherHighlightColor withSearchArray:[_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)] withSelectedResult:_searchResult];
                }
            }
        }
    }
    else
    {
        [_rendererView navigateToPageNumber:searchResult.pageIndex];
    }
}

/**
 TextSearchControllerDelegate implementation
 */
-(void)didSelectActionForCloseSearch
{
    [self removeSearchController];
    if(!isIpad())
    {
        [_rendererView reloadPages];
    }
}

/**
 Return File index for href
 */
-(NSString*)getFileIndexForHREF:(NSString*)href
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        for (EPUBChapter *chapter in book.chapters)
        {
            if([chapter.href isEqualToString:href])
            {
                return [NSString stringWithFormat:@"%ld",(long)chapter.fileIndex];
            }
        }
    }
    return @"";
}

/**
 Return Event Name for Enum Event Type
 */
-(NSString*)analyticsEventNameForType:(AnalyticsEventType)type
{
    switch (type) {
        case kTypeNoteCreated:
            return @"NoteCreated";
            break;
        case kTypeNoteDeleted:
            return @"NoteDeleted";
            break;
        case kTypeNoteReceived:
            return @"NoteReceived";
            break;
        case kTypeImpHighlightCreated:
            return @"ImpHighlightCreated";
            break;
        case kTypeImpHighlightDeleted:
            return @"ImpHighlightDeleted";
            break;
        case kTypeNormHighlightCreated:
            return @"NormHighlightCreated";
            break;
        case kTypeNormHighlightDeleted:
            return @"NormHighlightDeleted";
            break;
        case kTypePageTracking:
            return @"PageTracking";
            break;
        case kTypeBookOpen:
            return @"BookOpen";
            break;
        case KTypeBookClose:
            return @"BookClose";
            break;
        case kTypeLinkOpen:
            return @"LinkOpen";
            break;
        case kTypeNoteShared:
            return @"NoteShared";
            break;
        case kTypeNormHighlightReceived:
            return @"NormHighlightReceived";
            break;
        case kTypeImpHighlightReceived:
            return @"ImpHighlightReceived";
            break;
        case kTypeNormHighlightShared:
            return @"NormalHighlightShared";
            break;
        case kTypeImpHighlightShared:
            return @"ImpHighlightShared";
            break;
        default:
            break;
    }
    return @"";
}

- (void)updateChapterTitleForChapter:(EPUBChapter *)chapter withTOCData:(NSArray *)tocData
{
    for (NSDictionary *toc in tocData)
    {
        NSArray *subnodes = [toc valueForKey:@"subnodes"];
        if (subnodes.count == 0 || [[toc objectForKey:@"src"] containsString:chapter.href])
        {
            if ([[toc objectForKey:@"src"] containsString:chapter.href])
            {
                currentChapterName = [toc objectForKey:@"title"];
                _reflowableSliderPopUpView.chapterNameLabel.text = currentChapterName;
                break;
            }
        }
        else
        {
            [self updateChapterTitleForChapter:chapter withTOCData:[toc valueForKey:@"subnodes"]];
        }
    }
}

- (NSString *)getChapterNameForChapter:(EPUBChapter *)chapter
{
    EPUBBookVO* epubBook=(EPUBBookVO*)currentBook;
    
    NSInteger index = [epubBook.toc indexOfObjectPassingTest:^BOOL(EPUBToc  *obj, NSUInteger idx, BOOL * _Nonnull stop)
                       {
                           if (chapter.href && [obj.src containsString:chapter.href])
                           {
                               *stop = YES;
                               return YES;
                           }
                           return NO;
                       }];
    if (index != NSNotFound)
    {
        EPUBToc *toc = epubBook.toc[index];
        return toc.tocLabel;
    }
    else
    {
        return @"";
    }
}

-(void)addShadow:(UIView *)view{
    
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    view.layer.shadowOpacity = 0.4f;
    view.clipsToBounds = NO;
}

#pragma mark HDReflowableLayoutController Methods

- (void)showReflowableLayoutSettingControllerView:(UIView *)sender
{
    __weak typeof(EPUBBookVO*) weakBook = (EPUBBookVO*)currentBook;
    if (!reflowableLayoutSettingController)
    {
        reflowableLayoutSettingController = [[HDReflowableLayoutSettingController alloc] init];
    }
    
    activeMode = kPlayerActiveModeReflowableLayout;
    reflowableLayoutSettingController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [reflowableLayoutSettingController setCustomFontNameForLayoutWithFontName:CustomFontNameForWeight];
    [self configureFontSettingOptions];
    [self configureFontSettingTheme];
    [reflowableLayoutSettingController setReaderModeEnable:weakBook.userReaderFontSettings.readerMode];
    //[reflowableLayoutController setEnableBrightnessSlider:YES];
    [reflowableLayoutSettingController setFontFamilyArray:[NSArray arrayWithObjects:@"FONTSETTING_FONTFAMILY_DEFAULT",@"Open Sans",@"Georgia",@"Noto Serif", nil]];
    [reflowableLayoutSettingController setFontSize:weakBook.userReaderFontSettings.fontSize];
    [reflowableLayoutSettingController setCurrentFontFamily:weakBook.userReaderFontSettings.fontFamily];
    [reflowableLayoutSettingController setPaginationEnable:!weakBook.userReaderFontSettings.scrollEnabled];
    [reflowableLayoutSettingController setCurrentTextAlignment:weakBook.userReaderFontSettings.textAlignment];
    [reflowableLayoutSettingController setCurrentLineSpacing:weakBook.userReaderFontSettings.lineSpacing];
    [reflowableLayoutSettingController setCurrentMargin:weakBook.userReaderFontSettings.margin];

    __weak typeof(self) weakSelf = self;
    __weak typeof(analyticsHandler) weakAnalyticsHandler = analyticsHandler;
    __weak typeof(_rendererView) weakRendererView= _rendererView;
    __weak typeof(reflowableLayoutSettingController) weakReflowableLayoutSettingController= reflowableLayoutSettingController;
    [self configureFontSettingView];

    [reflowableLayoutSettingController setFontFamilyDidChange:^(NSString * selectedFont)
    {
        weakBook.userReaderFontSettings.fontFamily = selectedFont;
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontFamilyEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:selectedFont,KitabooReaderEventConstant.fontFamilyEventParameterFontValue,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowableFontFamily:selectedFont];
        [weakRendererView setFontFamily:selectedFont];
        [weakSelf addSliderBarForReflowableBook];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];
    [reflowableLayoutSettingController setFontSizeDidChange:^(CGFloat fontSize)
    {
        weakBook.userReaderFontSettings.fontSize = fontSize;
        NSString *size = [weakSelf convertFontSettingsEnumToString:fontSize enumType:kFontSize];
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontSizeEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:size ,KitabooReaderEventConstant.fontSizeEventParameterFontSizeValue,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowableFontSize:fontSize];
        [weakRendererView didFontSizeChanged:fontSize];
        [weakSelf addSliderBarForReflowableBook];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setDidEnablePagination:^(BOOL isEnabled)
    {
        weakBook.userReaderFontSettings.scrollEnabled = !isEnabled;
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontScrollViewEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:isEnabled ? @"OFF" : @"ON",KitabooReaderEventConstant.fontScrollViewEventParameterFontScrollView,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowablePagination:isEnabled];
        [weakRendererView enablePagination:isEnabled];
        [weakSelf enableDisableVerticalSlider:!isEnabled];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setDidChangeReaderMode:^(NSInteger readerModeTypeValue)
    {
        weakBook.userReaderFontSettings.readerMode = readerModeTypeValue;
        NSString *mode = [weakSelf convertFontSettingsEnumToString:readerModeTypeValue enumType:kFontReadingMode];
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontReadingModeEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:mode ,KitabooReaderEventConstant.fontReadingModeEventParameterFontReadingMode,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowableReaderMode:readerModeTypeValue];
        [weakRendererView setReaderMode:readerModeTypeValue];
        [weakSelf setPageCountViewColor];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setDidChangeTextAliginment:^(NSInteger textAlignmentTypeValue)
    {
        weakBook.userReaderFontSettings.textAlignment = textAlignmentTypeValue;
        NSString *alignment = [weakSelf convertFontSettingsEnumToString:textAlignmentTypeValue enumType:kFontAlignment];
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontAlignmentDataEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:alignment ,KitabooReaderEventConstant.fontAlignmentDataEventParameterFontAlignment,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowableTextAlignment:textAlignmentTypeValue];
        [weakRendererView setTextAlignment:textAlignmentTypeValue];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setDidChangeLineSpacing:^(NSInteger lineSpacingTypeValue)
    {
        weakBook.userReaderFontSettings.lineSpacing = lineSpacingTypeValue;
        NSString *lineSpacing = [weakSelf convertFontSettingsEnumToString:lineSpacingTypeValue enumType:kFontLineSpacing];
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontLineSpacingEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:lineSpacing ,KitabooReaderEventConstant.fontLineSpacingEventParameterFontLineSpacing,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowableLineSpacing:lineSpacingTypeValue];
        [weakRendererView setLineSpacing:lineSpacingTypeValue];
        [weakSelf addSliderBarForReflowableBook];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setDidChangeMargin:^(NSInteger marginTypeValue)
    {
        weakBook.userReaderFontSettings.margin = marginTypeValue;
        NSString *margin = [weakSelf convertFontSettingsEnumToString:marginTypeValue enumType:kFontMargin];
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontMarginDataEventName eventInfo:[NSDictionary dictionaryWithObjectsAndKeys:margin ,KitabooReaderEventConstant.fontMarginDataEventParameterFontMarginData,nil]];
        [[HDReflowableReaderConfiguration sharedInstance] setReflowableMargin:marginTypeValue];
        [weakRendererView setMargin:marginTypeValue];
        [weakSelf addSliderBarForReflowableBook];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setResetReaderSetting:^
    {
        [weakAnalyticsHandler notifyEvent:KitabooReaderEventConstant.fontResetEventName eventInfo:nil];
        [[HDReflowableReaderConfiguration sharedInstance] reflowableReaderDefaultConfiguration];
        [weakRendererView resetReaderFontSetting];
        [weakReflowableLayoutSettingController dismissViewControllerAnimated:YES completion:nil];
        self->reflowableLayoutSettingController = nil;
        [weakSelf enableDisableVerticalSlider:YES];
        [weakSelf addSliderBarForReflowableBook];
        [weakSelf resetAllPlayerActionBar];
        [weakSelf setPageCountViewColor];
        [weakSelf saveReaderFontSetting:weakBook.userReaderFontSettings];
    }];

    [reflowableLayoutSettingController setWillDismissController:^{
        self->activeMode = kPlayerActiveModeNone;
        [weakSelf resetAllPlayerActionBar];
        self->reflowableLayoutSettingController = nil;
    }];

    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:^{
        [self presentViewController:self->reflowableLayoutSettingController animated:NO completion:nil];
    }];

}

-(NSString*) convertFontSettingsEnumToString:(NSUInteger)enumVal enumType:(id)type;
{
    return [type objectAtIndex:enumVal];
}

-(void)setPageCountViewColor{
    EPUBBookVO* epubBook = (EPUBBookVO*)currentBook;
    if (epubBook.userReaderFontSettings.readerMode == SEPIA_MODE) {
        [_reflowableSliderPageCountView setViewColors:UIColor.grayColor backgroundColor:[UIColor colorWithHexString:kSepiaModeBGColor]];
        _reflowableSliderPageCountView.backgroundColor = [UIColor colorWithHexString:kSepiaModeBGColor];
    }else if (epubBook.userReaderFontSettings.readerMode == NIGHT_MODE){
        [_reflowableSliderPageCountView setViewColors:UIColor.whiteColor backgroundColor:[UIColor colorWithHexString:kNightModeBGColor]];
        _reflowableSliderPageCountView.backgroundColor = [UIColor colorWithHexString:kNightModeBGColor];
    }else{
        [_reflowableSliderPageCountView setViewColors:UIColor.grayColor backgroundColor:[UIColor colorWithHexString:kDayModeBGColor]];
        _reflowableSliderPageCountView.backgroundColor = [UIColor colorWithHexString:kDayModeBGColor];
    }
}

-(void)hideReflowablePageCountView{
    if (([_reflowableSliderPageCountView.pageLabel.text isEqualToString:@""] && [_reflowableSliderPageCountView.readingTimeLeftLabel.text isEqualToString:@""]) || disableReflowablePageCountView) {
        _reflowableSliderPageCountView.hidden = YES;
    }else {
        _reflowableSliderPageCountView.hidden = NO;
    }
}

-(void)configureFontSettingTheme
{
    [reflowableLayoutSettingController setBackgroundColorForView:hdThemeVO.fontSettings_popup_background];
    [reflowableLayoutSettingController setBorderColor:hdThemeVO.fontSettings_popup_border];
    [reflowableLayoutSettingController setTextColor:hdThemeVO.fontSettings_font_text_color];
    [reflowableLayoutSettingController setTitleTextColor:hdThemeVO.fontSettings_selected_text_color];
    [reflowableLayoutSettingController setButtonBorderColor:hdThemeVO.fontSettings_font_box_border_color];
    [reflowableLayoutSettingController setButtonTitleColor:hdThemeVO.fontSettings_other_icon_color];
    [reflowableLayoutSettingController setSelectedButtonBorderColor:hdThemeVO.fontSettings_font_selected_icon_border];
    [reflowableLayoutSettingController setSelectedButtonTitleColor:hdThemeVO.fontSettings_other_selected_icon_color];
    [reflowableLayoutSettingController setResetButtonTitleColor:hdThemeVO.fontSettings_reset_color];
    [reflowableLayoutSettingController setSliderThumbColor:hdThemeVO.fontSettings_font_pointer_bg];
    [reflowableLayoutSettingController setSliderTrackTintColor:hdThemeVO.fontSettings_other_brightness_slider_color];
    [reflowableLayoutSettingController setScrollSwitchTintColor:hdThemeVO.fontSettings_Other_ScrollView_selected_Tab_bg];
    [reflowableLayoutSettingController setFontFamilyThemeColor:hdThemeVO.fontSettings_font_more_icon_color];
    [reflowableLayoutSettingController setSeparationLineColor:hdThemeVO.fontSettings_font_divider_color];
}

-(void)configureFontSettingOptions
{
    if (reflowableLayoutSettingController) {
        [reflowableLayoutSettingController setTextAlignmentOptions:[NSArray arrayWithObjects:[NSNumber numberWithInt:LEFT_ALIGNMENT],[NSNumber numberWithInt:CENTER_ALIGNMENT],[NSNumber numberWithInt:RIGHT_ALIGNMENT],[NSNumber numberWithInt:JUSTIFY_ALIGNMENT], nil]];
        [reflowableLayoutSettingController setLineSpacingOptions:[NSArray arrayWithObjects:[NSNumber numberWithInt:SMALL_LINESPACING],[NSNumber numberWithInt:MEDIUM_LINESPACING],[NSNumber numberWithInt:LARGE_LINESPACING], nil]];
        [reflowableLayoutSettingController setReaderMarginOptions:[NSArray arrayWithObjects:[NSNumber numberWithInt:SMALL_MARGIN],[NSNumber numberWithInt:MEDIUM_MARGIN],[NSNumber numberWithInt:LARGE_MARGIN], nil]];
        [reflowableLayoutSettingController setReaderModeOptions:[NSArray arrayWithObjects:[NSNumber numberWithInt:NIGHT_MODE],[NSNumber numberWithInt:DAY_MODE],[NSNumber numberWithInt:SEPIA_MODE], nil]];
    }
}

-(void)configureFontSettingView
{
    if (reflowableLayoutSettingController) {
        [reflowableLayoutSettingController enableFontFamilyView:true];
        [reflowableLayoutSettingController enableFontSizeView:true];
        [reflowableLayoutSettingController enableScrollModeView:true];
        [reflowableLayoutSettingController enableReaderModeView:true];
        [reflowableLayoutSettingController enableAlignmentView:true];
        [reflowableLayoutSettingController enableLineSpacingView:true];
        EPUBBookVO* epubBook = (EPUBBookVO*)currentBook;
        if (isIpad() || !epubBook.isEpubTypeAuthorReflow) {
            [reflowableLayoutSettingController enableMarginView:true];
        }
    }
}

-(ReaderFontSetting *)getReaderFontSetting:(RendererViewController *)rendererViewController {
    ReaderFontSetting *fontSetting = [_dbManager getReaderFontSettingForBookID:_bookID ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
    return fontSetting;
}

- (void)saveReaderFontSetting:(ReaderFontSetting *)fontSetting
{
    [_dbManager saveReaderFontSetting:fontSetting ForBookID:_bookID ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
}

-(void)setResetReaderSettingForRenderer
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(_rendererView) weakRendererView= _rendererView;
    __weak typeof(reflowableLayoutController) weakReflowableLayoutController= reflowableLayoutController;
    [reflowableLayoutController setResetReaderSetting:^ {
        [[HDReflowableReaderConfiguration sharedInstance] reflowableReaderDefaultConfiguration];
        [weakRendererView resetReaderSetting];
        [weakReflowableLayoutController dismissViewControllerAnimated:YES completion:nil];
        [weakSelf enableDisableVerticalSlider:YES];
        [weakSelf addSliderBarForReflowableBook];
        [weakSelf resetAllPlayerActionBar];
    }];
}


- (NSDictionary *)getClientConfigDictionary
{
    NSString *clientConfigFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ClientConfig" ofType:@"plist"];
    NSDictionary *clientDictionary = [NSDictionary dictionaryWithContentsOfFile:clientConfigFilePath];
    return clientDictionary;
}

#pragma mark - Gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    BookOrientationMode _bookOrientation = [_rendererView getBookOrientationMode];
    if(_bookOrientation == kBookOrientationModeLandscapeOnePageOnly || _bookOrientation == kBookOrientationModeLandscapeTwoPageOnly)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else if(_bookOrientation == kBookOrientationModePortrait)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

- (BookOrientationMode)getOrientationMode
{
    return [_rendererView getBookOrientationMode];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark TextAnnotation
-(void)actionForTextAnnotation
{
    [_rendererView resetZoomScaleToDefault];
    [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
    SDKTextAnnotationVO *sdkTextAnnotationVO = [_rendererView getTextAnnotationVOWithDefaultPosition];
    if (sdkTextAnnotationVO)
    {
        [_rendererView addTextAnnotation:sdkTextAnnotationVO];
    }
    if (textAnnotationView.text.length>0) {
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:YES themeVO:hdThemeVO];
    }
    else{
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:NO themeVO:hdThemeVO];
    }
    
    textAnnotationView.accessibilityIdentifier = TEXT_ANNOTATION_TEXT_VIEW;
}
-(void)didTextAnnotationCompleteWithTextAnnotation:(SDKTextAnnotationVO*)textAnnotationVO WithNewSDKTextAnnotationVO:(SDKTextAnnotationVO *)newSDKTextAnnotationVO
{
    if (textAnnotationVO.status == DELETE)
    {
        [_dbManager deleteTextAnnotation:textAnnotationVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [self removeTextAnnotationView];
    }
    else
    {
        [_dbManager saveTextAnnotation:textAnnotationVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [self removeTextAnnotationView];
    }
}
-(BOOL)textAnnotationShouldBeginEditing
{
    if (activeMode == kPlayerActiveModeNone || activeMode == kplayerActiveModeTextAnnotation || activeMode == kPlayerActiveModeMarkupPlayerAudio)
    {
        return YES;
    }
    return NO;
}
-(void)didTextAnnotationBeginEditing:(UITextView *)textView
{
    textAnnotationView = textView;
    activeMode = kplayerActiveModeTextAnnotation;
    [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
    if (textAnnotationView.text.length>0) {
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:YES themeVO:hdThemeVO];
    }
    else{
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:NO themeVO:hdThemeVO];
    }
}

- (void)didTextAnnotationValueChanged:(UITextView *)textView
{
    textAnnotationView = textView;
    if (textAnnotationView.text.length>0) {
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:YES themeVO:hdThemeVO];
    }
    else{
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:NO themeVO:hdThemeVO];
    }
}

-(void)drawTextAnnotationsOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum
{
    if ([_userSettingsModel isTextAnnotationEnabled])
    {
        EPUBBookVO *epubBook = (EPUBBookVO*)currentBook;
        if(([currentBook isKindOfClass:[KFBookVO class]] || ([currentBook isKindOfClass:[EPUBBookVO class]] && (epubBook.meta.layout==ePUBFixedLayout))))
        {
            NSArray* textAnnotations = [_dbManager textAnnotationVOForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
            
            [_rendererView drawTextAnnotation:textAnnotations OnPageNo:[number intValue]];
        }
    }
}

#pragma mark Search
- (void)addSearchForText:(NSString *)searchText isElasticSearch:(BOOL)isElasticSearch {
    activeMode = kplayerActiveModeElasticSearch;
    if(!_searchController) {
        _searchController = [[TextSearchController alloc]initWithBookVO:currentBook WithSearchText:searchText withSearchType:kTextSearchResultTypePage];
        [_searchController setSearchTextViewBackgroundColor:hdThemeVO.search_popup_background];
        [_searchController setSearchTextBorderColor:hdThemeVO.search_popup_border];
        _searchController.delegate=self;
    }
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    if (searchTextViewForIpad == nil) {
        [self createSearchTextView:searchText isElasticSearch:isElasticSearch];
    }
    searchTextViewForIpad.delegate = self;
    [self clearSearchHighlights];
    if (searchText.length >= MaximumSearchStringLength) {
        searchText = [searchText substringToIndex:MaximumSearchStringLength];
        searchTextViewForIpad.searchBar.text = searchText;
    }
    searchTextStr = searchText;
    if ([_searchController isSearchResultAvailable]) {
        if(searchText.length){
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[_searchController getSearchResultForText:searchText WithOffset:0 WithBatchSize:(int)searchTextViewForIpad.batchSize]];
            if (array.count > 0 && isElasticSearch) {
                _searchResult = [array firstObject];
            }
            [searchTextViewForIpad renderSearchResultWithSearchResult:array];
        } else if (!isElasticSearch){
            [searchTextViewForIpad renderSearchResultWithSearchResult:[NSArray array]];
        }
    } else {
        [searchTextViewForIpad showGeneratingSearchResultView];
    }
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didCompleteSearchDecryptionForBookPath:(NSString *)bookPath {
    if (searchTextViewForIpad) {
        [self addSearchForText:searchTextViewForIpad.searchBar.text isElasticSearch:NO];
    }
}

- (NSArray*)fetchNextSearchResultForText:(NSString *)searchText WithStartOffset:(NSInteger)startOffset WithBatchSize:(NSInteger)batchSize {
    NSArray *arrayBatch = [_searchController getSearchResultForText:searchText WithOffset:(int)startOffset WithBatchSize:(int)batchSize];
    return arrayBatch;
}

-(void)createSearchTextView:(NSString *)searchText isElasticSearch:(BOOL)isElasticSearch {
    if (isElasticSearch) {
         searchTextViewForIpad = [[TextSearchView alloc] initWithElasticSearch:CGRectMake(0, 0, windowWidth, windowHeight) themeVO:hdThemeVO currentBookVO:currentBook];
    } else {
         searchTextViewForIpad = [[TextSearchView alloc] initForReaderSearch:CGRectMake(0, 0, windowWidth, windowHeight) themeVO:hdThemeVO currentBookVO:currentBook];
    }
   
    if (searchText.length >= MaximumSearchStringLength) {
        searchText = [searchText substringToIndex:MaximumSearchStringLength];
    }
    searchTextViewForIpad.searchBar.text = searchText;
    [searchTextViewForIpad.searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:searchTextViewForIpad];
    
    UITapGestureRecognizer *tapGestureForSearchField = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapGestureAction)];
    tapGestureForSearchField.cancelsTouchesInView = NO;
    tapGestureForSearchField.delegate = self;
    [searchTextViewForIpad addGestureRecognizer:tapGestureForSearchField];
    
    searchTextViewForIpad.translatesAutoresizingMaskIntoConstraints = NO;
    [searchTextViewForIpad.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [searchTextViewForIpad.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [searchTextViewForIpad.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
    bottomConstraintOfTextSearchView = [self.view.bottomAnchor constraintEqualToAnchor:searchTextViewForIpad.bottomAnchor constant:0];
    bottomConstraintOfTextSearchView.active = YES;
    [self.view layoutIfNeeded];
    
    [searchTextViewForIpad.cancelBtn addTarget:self action:@selector(closeSearchView) forControlEvents:UIControlEventTouchUpInside];
    [searchTextViewForIpad.nextBtn addTarget:self action:@selector(didClickOnNextButtonForReaderSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchTextViewForIpad.PrevBtn addTarget:self action:@selector(didClickOnPreviousButtonForReaderSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchTextViewForIpad.openBtn addTarget:self action:@selector(openSearchView) forControlEvents:UIControlEventTouchUpInside];
    searchTextViewForIpad.searchBar.delegate = self;
    [searchTextViewForIpad.searchBar becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    [self addBlurEffectToReaderView];
    [searchTextViewForIpad setDidClickOnSearchResult:^(TextSearchResult *searchResult) {
        [weakSelf didSelectSearchText:searchResult];
    }];
}

-(void)didClickOnNextButtonForElasticSearch
{
    [self enablePreviousButtonForElasticSearch:YES];
    if ([_rendererView isNextSearchResultAvailable])
    {
        [_rendererView moveToNextSelectedSearch];
        if (![_rendererView isLastNextSearchResult]) {
            NSArray *nextPageResultArray = [_searchController getNextSearchResultForText:_searchResult.searchedWord withCurrentPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)];
            if (!nextPageResultArray || nextPageResultArray.count==0)
            {
                [self enableNextButtonForElasticSearch:NO];
            }
        }
    }
    else
    {
        NSArray *nextPageResultArray = [_searchController getNextSearchResultForText:_searchResult.searchedWord withCurrentPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)];
        if (nextPageResultArray && nextPageResultArray.count>0)
        {
            _searchResult = [nextPageResultArray objectAtIndex:0];
            [_rendererView navigateToPageNumber:_searchResult.pageIndex];
        }
        else{
            [self enablePreviousButtonForElasticSearch:YES];
            [self enableNextButtonForElasticSearch:NO];
        }
    }
}

- (void)didClickOnPreviousButtonForElasticSearch
{
    [self enableNextButtonForElasticSearch:YES];
    if ([_rendererView isPreviousSearchResultAvailable])
    {
        [_rendererView moveToPreviousSelectedSearch];
        if (![_rendererView isLastPreviousSearchResult])
        {
            NSArray *prevResultArray = [_searchController getPreviousSearchResultForText:_searchResult.searchedWord withCurrentPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)];
            if (!prevResultArray || prevResultArray.count == 0) {
                [self enablePreviousButtonForElasticSearch:NO];
            }
        }
    }
    else{
        NSArray *prevResultArray = [_searchController getPreviousSearchResultForText:_searchResult.searchedWord withCurrentPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)];
        if (prevResultArray && prevResultArray.count > 0)
        {
            _searchResult = [prevResultArray objectAtIndex:0];
            [_rendererView navigateToPageNumber:_searchResult.pageIndex];
        }
        else{
            [self enablePreviousButtonForElasticSearch:NO];
            [self enableNextButtonForElasticSearch:YES];
        }
    }
}

- (void)enableNextButtonForElasticSearch:(BOOL)enable
{
    if (!enable)
    {
        searchTextViewForIpad.nextBtn.userInteractionEnabled = NO;
        searchTextViewForIpad.nextBtn.alpha = 0.5;
    }
    else
    {
        searchTextViewForIpad.nextBtn.userInteractionEnabled = YES;
        searchTextViewForIpad.nextBtn.alpha = 1.0;
    }
}

- (void)enablePreviousButtonForElasticSearch:(BOOL)enable
{
    if (!enable)
    {
        searchTextViewForIpad.PrevBtn.userInteractionEnabled = NO;
        searchTextViewForIpad.PrevBtn.alpha = 0.5;
    }
    else
    {
        searchTextViewForIpad.PrevBtn.userInteractionEnabled = YES;
        searchTextViewForIpad.PrevBtn.alpha = 1.0;
    }
}

-(NSInteger)getHrefFromFileIndex:(NSString*)index
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *book=(EPUBBookVO*)currentBook;
        for (EPUBChapter *chapter in book.chapters)
        {
            if([chapter.href isEqualToString:index] )
            {
                return chapter.fileIndex;
            }
        }
    }
    return 0;
}
#pragma mark Protractor
-(void)didTapOnProtractor
{
    
}
//{
//    [analyticsHandler notifyEvent:KitabooReaderEventConstant.protractorEventName eventInfo:nil];
//    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
//    {
//        _rendererView.view.userInteractionEnabled =false;
//        [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
//        [_rendererView resetZoomScaleToDefault];
//        activeMode = kPlayerActiveModeProtractor;
//        protractorViewController=[[ProtractorViewController alloc] init];
//        [protractorViewController setProtractorCanvasWithCanvas:(PenDrawingView*)[[_rendererView getPenDrawingCanvas] objectAtIndex:0]];
//
//        protractorViewController.delegate=self;
//        [self addChildViewController:protractorViewController];
//        [self.view addSubview:protractorViewController.view];
//    }
//    else
//    {
//        UIAlertController *protractorNotAvailableAlert = [UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:@"PROTRACTOR_NOT_AVAILABLE_IN_LANDSCAPE_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"THE_FEATURE_CAN_BE_BEST_USED_IN_ONE_PAGE_VIEW_PLEASE_SWITCH_TO_ONE_PAGE_VIEW" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
//
//        }];
//        [protractorNotAvailableAlert addAction:okAction];
//        [self presentViewController:protractorNotAvailableAlert animated:YES completion:nil];
//    }
//
//}
- (void)didCloseProtractorWithProtractorVO:(SDKProtractorVO *)protractorVO
{
    [self removeProtractorView];
    if(protractorVO)
    {
        [_dbManager saveProtractor:protractorVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [self drawProtractorOnPageNumber:protractorVO.pageIdentifier OnDisplayNumber:protractorVO.displayNum];
    }
}
-(void)drawProtractorOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        NSArray* protractorDrawings=[_dbManager protractorDrawingForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        for (SDKProtractorVO *protractorVO in protractorDrawings)
        {
            if (protractorVO.protractorLineThickness == 0)
            {
                protractorVO.protractorLineThickness = DEFAULT_PROTRACTOR_LINE_THICKNESS;
            }
            if(!isIpad())
            {
                protractorVO.protractorLineThickness = protractorVO.protractorLineThickness*0.5;
            }
        }
        [_rendererView drawProtractorDrawings:protractorDrawings OnPageNo:[number integerValue]];
    }
}
- (void)deleteProtractorWithProtractorVO:(SDKProtractorVO *)protractorVO
{
    if(protractorVO)
    {
        [_dbManager deleteProtractorDrawing:protractorVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [self drawProtractorOnPageNumber:protractorVO.pageIdentifier OnDisplayNumber:protractorVO.displayNum];
    }
}
- (void)didSelectProtractorWithProtractorVO:(SDKProtractorVO *)protractorVO
{
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
}
-(void)removeProtractorView
{
    activeMode = kPlayerActiveModeNone;
    _rendererView.view.userInteractionEnabled =true;
}

#pragma mark Equation Editor

-(void)addEquationEditorButton:(CGRect)rect WithOffset:(CGFloat)offset
{
    if(equationEditorButton)
    {
        [self removeEquationEditorButton];
    }
    equationEditorButton = [[UIButton alloc]init];
    [equationEditorButton addTarget:self
                             action:@selector(didTapOnEquationEditorButton)
                   forControlEvents:UIControlEventTouchUpInside];
    [equationEditorButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:EquationEditorIconFontSize]];
    [equationEditorButton setTitle:ICON_EQUATION_EDITOR forState:UIControlStateNormal];
    equationEditorButton.backgroundColor=[UIColor colorWithHexString:@"#e7e7e8"];
    equationEditorButton.layer.borderColor = [[UIColor colorWithHexString:@"#babbbe"] CGColor];
    equationEditorButton.layer.shadowColor = [[UIColor grayColor] CGColor];
    CGFloat equationEditorButtonHW = EquationEditorButtonHeightWidth;
    equationEditorButton.layer.borderWidth =equationEditorButtonHW/9;
    equationEditorButton.layer.cornerRadius=equationEditorButtonHW/3.5;
    equationEditorButton.layer.shadowRadius = EquationEditorButtonRadius;
    equationEditorButton.layer.shadowOpacity = 0.5;
    [equationEditorButton setTitleColorForNormalState:[UIColor colorWithHexString:@"#095e8e"]];
    equationEditorButton.hidden = NO;
    [_rendererView.view addSubview:equationEditorButton];
    equationEditorButton.frame = CGRectMake(_rendererView.view.frame.size.width - equationEditorButtonHW, _rendererView.view.frame.size.height - (rect.size.height + equationEditorButtonHW) + offset, equationEditorButtonHW, equationEditorButtonHW);
}
-(void)removeEquationEditorButton
{
    [equationEditorButton removeFromSuperview];
    equationEditorButton = nil;
}
-(void)didTapOnEquationEditorButton
{
    NSString *fibText = @"";
    for (id view in _hdFIB.subviews)
    {
        if([view isKindOfClass:[UITextView class]])
        {
            UITextView *textView = (UITextView*)view;
            fibText = textView.text;
        }
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *textfield = (UITextField*)view;
            fibText = textfield.text;
        }
    }
    
    if(fibText.length > 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:@"EE_DATA_DELETE_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]  message:[LocalizationHelper localizedStringWithKey:@"EE_DATA_DELETE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             if (self)
                                             {
                                                 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissFIBAndLaunchEquationEditor) object:nil];
                                                 [self performSelector:@selector(dismissFIBAndLaunchEquationEditor) withObject:nil afterDelay:0.3];
                                             }
                                         }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"CANCEL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           [alertController dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alertController addAction:actionCancel];
        [alertController addAction:actionContinue];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        if (self)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissFIBAndLaunchEquationEditor) object:nil];
            [self performSelector:@selector(dismissFIBAndLaunchEquationEditor) withObject:nil afterDelay:0.3];
        }
    }
}

-(void)dismissFIBAndLaunchEquationEditor
{
    _hdFIB.isDefaultKeyboardDisabled = [self isDefaultKeyboardDisabled:_hdFIB];
    KFLinkVO *link = _hdFIB.linkVo;
    _hdFIB =nil;
    [self clearTextOnSwitchingKeyBoardFromNormalToEquationEditorForLinkID:link.linkID];
    if(activeMode==kPlayerActiveModeTeacherReview)
    {
        [self showEquationEditorKeyboardForLink:link withFIBVO:[_teacherAnnotationController getSDKFIBVOForLinkID:link.linkID]];
    }
    else
    {
        [self showEquationEditorKeyboardForLink:link withFIBVO:[_dbManager getEquationFIBObjectForText:@"" WithLink:link forUserId:[NSNumber numberWithInteger:_user.userID.integerValue]]];
    }
}

-(void)clearTextOnSwitchingKeyBoardFromNormalToEquationEditorForLinkID:(NSInteger)linkID
{
    UIView* fibView = [_rendererView getFIBViewForLinkId:linkID];
    for (id view in fibView.subviews)
    {
        if([view isKindOfClass:[UITextView class]])
        {
            UITextView *textView = (UITextView*)view;
            if(!textView.isFirstResponder)
                [textView becomeFirstResponder];
            textView.text = @"";
            [textView resignFirstResponder];
        }
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *textfield = (UITextField*)view;
            if(!textfield.isFirstResponder)
                [textfield becomeFirstResponder];
            textfield.text = @"";
            [textfield resignFirstResponder];
        }
    }
}

-(void)hideTopAndBottomBarForIphoneTeacherReview
{
    if(!isIpad() && activeMode==kPlayerActiveModeTeacherReview)
    {
        penToolActionBarView.hidden=YES;
        penToolActionBottomBarView.hidden=YES;
    }
    else if(activeMode==kPlayerActiveModeTeacherReview)
    {
        penToolActionBarView.hidden=YES;
    }
    
}
-(void)showTopAndBottomBarForIphoneTeacherReview
{
    if(!isIpad() && activeMode==kPlayerActiveModeTeacherReview)
    {
        penToolActionBarView.hidden=NO;
        penToolActionBottomBarView.hidden=NO;
    }
    else if(activeMode==kPlayerActiveModeTeacherReview)
    {
        penToolActionBarView.hidden=NO;
    }
    
}

- (void)showEquationEditorKeyboardForLink:(KFLinkVO *)link withFIBVO:(SDKFIBVO *)fibVO
{
    [analyticsHandler notifyEvent:KitabooReaderEventConstant.equationEditorEventName eventInfo:nil];
    if(activeMode == kPlayerActiveModeBookmark)
    {
        [self removeBookmarkVC];
    }
    [self hideTopAndBottomBarForIphoneTeacherReview];
    
    if(activeMode == kPlayerActiveModeFIB)
    {
        activeMode = kPlayerActiveModeNone;
    }
    [_rendererView.view endEditing:YES];
    [_rendererView resetZoomScaleToDefault];
    [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
    CGRect displayFrame = _rendererView.view.bounds;
    equationEditorKeyboardViewController=[[EquationEditorKeyboardViewController alloc]initWithEqfibVO:fibVO];
    equationEditorKeyboardViewController.link = link;
    equationEditorKeyboardViewController.view.frame=displayFrame;
    equationEditorKeyboardViewController.delegate=self;
    
    if(isIpad())
    {
        equationEditorKeyboardViewController.posY=[NSString stringWithFormat:@"%fpx",link.boxTansformedRect.origin.y];
    }
    else
    {
        equationEditorKeyboardViewController.posY=[NSString stringWithFormat:@"2px"];
    }
    
    [_rendererView addChildViewController:equationEditorKeyboardViewController];
    [_rendererView.view addSubview:equationEditorKeyboardViewController.view];
    [_rendererView.view bringSubviewToFront:equationEditorKeyboardViewController.view];
}

- (void)saveEquationEditorForLink:(KFLinkVO *)link FIBVO:(SDKFIBVO *)FIBVO :(NSString *)text
{
    [self showTopAndBottomBarForIphoneTeacherReview];
    [self removeEquationEditorKeyboard];
    [self saveEquationWithText:text forLink:link withFIB:FIBVO];
}

- (void)changeEquationKeyboardToNormalForLink:(KFLinkVO *)link FIBVO:(SDKFIBVO *)FIBVO withEnterText:(NSString *)text
{
    if(![text isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:@"EE_DATA_DELETE_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"EE_DATA_DELETE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             if(text)
                                             {
                                                 [self removeEquationEditorKeyboard];
                                                 [self changeEquationTypeToNormalTypeForLink:link withFIBVO:FIBVO];
                                                 return;
                                             }
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"CANCEL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           [alertController dismissViewControllerAnimated:YES completion:nil];
                                           if(self->equationEditorKeyboardViewController)
                                           {
                                               self->equationEditorKeyboardViewController.view.frame=_rendererView.view.bounds;
                                               [_rendererView addChildViewController:self->equationEditorKeyboardViewController];
                                               [_rendererView.view addSubview:self->equationEditorKeyboardViewController.view];
                                           }
                                       }];
        [alertController addAction:actionCancel];
        [alertController addAction:actionContinue];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self removeEquationEditorKeyboard];
        [self changeEquationTypeToNormalTypeForLink:link withFIBVO:FIBVO];
    }
}

-(void)saveEquationWithText:(NSString*)text forLink:(KFLinkVO*)link withFIB:(SDKFIBVO*)fibVO
{
    if(activeMode != kPlayerActiveModeTeacherReview)
    {
        fibVO = [_dbManager getEquationFIBObjectForText:text WithLink:link forUserId:[NSNumber numberWithInt:_user.userID.intValue]];
        fibVO.review = [NSNumber numberWithInt:0];
        [self didUpdateSDKFIBVO:fibVO];
        [self reloadFIB];
    }
    else
    {
        if(fibVO)
        {
            fibVO.review = [NSNumber numberWithInt:1];
            [self didUpdateSDKFIBVO:fibVO];
            [self drawTeacherReviewFIBOnPageNumber:[NSNumber numberWithInteger:fibVO.pageIdentifier.integerValue]];
        }
    }
}
-(void)removeEquationEditorKeyboard
{
    if(equationEditorKeyboardViewController)
    {
        [equationEditorKeyboardViewController.view removeFromSuperview];
        [equationEditorKeyboardViewController removeFromParentViewController];
        equationEditorKeyboardViewController=nil;
    }
}
-(void)changeEquationTypeToNormalTypeForLink:(KFLinkVO*)link withFIBVO:(SDKFIBVO*)fibVO
{
    [self showTopAndBottomBarForIphoneTeacherReview];
    [self saveEquationWithText:@"" forLink:link withFIB:fibVO];
    UIView *fibView =  [_rendererView getFIBViewForLinkId:link.linkID];
    HDFIB *fib = (HDFIB *)fibView;
    fib.isDefaultKeyboardDisabled = NO;
    for (id view in fibView.subviews)
    {
        if([view isKindOfClass:[UITextView class]])
        {
            UITextView *textView = (UITextView*)view;
            [textView becomeFirstResponder];
        }
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *textfield = (UITextField*)view;
            [textfield becomeFirstResponder];
        }
    }
}

-(BOOL)shouldAllowEditingForLinkVO:(KFLinkVO *)linkVO
{
    if(activeMode == kPlayerActiveModeTeacherReview)
    {
        return false;// [_teacherAnnotationController isEditingAllowedForLinkID:linkVO.linkID];
    }
    else
    {
        return true;
    }
}

//Create help screen data in user default
- (void) configureForHelpScreen
{
    NSNumber *showHelpScreenForPdf = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderForPdf"];
    if (showHelpScreenForPdf == nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"HelpScreenForReaderForPdf"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSNumber *showHelpScreenForReflowEpub = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderForReflowEpub"];
    if (showHelpScreenForReflowEpub == nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"HelpScreenForReaderForReflowEpub"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSNumber *showHelpScreenFixedEpub = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderFixedEpub"];
    if (showHelpScreenFixedEpub == nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"HelpScreenForReaderFixedEpub"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSNumber *showHelpScreenforTeacherReview = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForTeacherReview"];
    if (showHelpScreenforTeacherReview == nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"HelpScreenForTeacherReview"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//Create & show help screen
-(void)showHelpScreen:(BOOL)isForTeacherReview
{
    [self configureForHelpScreen];
    BOOL isShowHelpScreen = NO;
    if(isForTeacherReview)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForTeacherReview"] boolValue])
        {
            isShowHelpScreen = YES;
        }
    }
    else
    {
        if([currentBook isKindOfClass:[KFBookVO class]])
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderForPdf"] boolValue])
            {
                isShowHelpScreen = YES;
            }
        }
        else if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
            if(epubBook.meta.layout == ePUBReflowable && [[[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderForReflowEpub"] boolValue])
            {
                isShowHelpScreen = YES;
            }
            else if(epubBook.meta.layout == ePUBFixedLayout && [[[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderFixedEpub"] boolValue])
            {
                isShowHelpScreen = YES;
            }
        }
        
    }
    if(isShowHelpScreen)
    {
        if(!isForTeacherReview)
            [self moveTopAndBottomOnScreenWithIsAnimate:YES WithCompletionHandler:nil];
        if (self.helpScreen) {
            [self.helpScreen.view removeFromSuperview];
            [self.helpScreen removeFromParentViewController];
            self.helpScreen = nil;
        }
        self.helpScreen =  [self getHelpScreenInstance];
        
        [self.helpScreen setBackGroundColorWithColor:@"#000000"];
        [self.helpScreen setLineColorWithColor:@"#FFFFFF"];
        [self.helpScreen setEllipseColorWithColor:@"#00d9fa"];
        [self.helpScreen setIconColorWithColor:@"#FFFFFF"];
        [self.helpScreen setTitleTextColorWithColor:@"#00d9fa"];
        [self.helpScreen setDescriptionTextColorWithColor:@"#FFFFFF"];
        [self.helpScreen setGotItButtonBackgroundColorWithColor:@"#095E8E"];
        [self.helpScreen setGotItButtonTextColorWithColor:@"#FFFFFF"];
        [self.helpScreen setSkipButtonBackgroundColorWithColor:@"#FFFFFF"];
        [self.helpScreen setSkipButtonTextColorWithColor:@"#000000"];
        
        self.helpScreen.showSecondScreen = YES;
        if(isForTeacherReview)
        {
            self.helpScreen.isForTeacherReview = YES;
            self.helpScreen.helpDescriptors = [self getAllAppBarButtonForTeacherReview];
        }
        else
        {
            self.helpScreen.isForTeacherReview = NO;
            self.helpScreen.helpDescriptors = [self getAllAppBarButton];
        }
        self.helpScreen.delegate = self;
        self.helpScreen.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self.helpScreen.view setNeedsLayout];
        [self.view addSubview:self.helpScreen.view];
        if (@available(iOS 11.0, *))
        {
            [self.helpScreen.view.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
            [self.helpScreen.view.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
            [self.helpScreen.view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
            [self.helpScreen.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        }
        else
        {
            [self.helpScreen.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
            [self.helpScreen.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
            [self.helpScreen.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
            [self.helpScreen.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        }
        [self addChildViewController:self.helpScreen];
        [self.helpScreen.view layoutIfNeeded];
        [self.helpScreen didMoveToParentViewController:self];
        [self.helpScreen viewWillAppear:YES];
        [self.view bringSubviewToFront:self.helpScreen.view];
    }
}

-(HelpScreen*)getHelpScreenInstance {
    return [[HelpScreen alloc] init];
}

//Show help screen for teacher review
-(void)showHelpScreenForTeacherReview
{
    if(!self.helpScreen)
    {
        [self showHelpScreen:YES];
    }
}

//Fetch all buttons to show in helps screen for teacher review
-(NSMutableArray *)getAllAppBarButtonForTeacherReview
{
    if (_helpDescriptorsForHelpScreen) {
        _helpDescriptorsForHelpScreen = nil;
    }
    _helpDescriptorsForHelpScreen = [[NSMutableArray alloc] init];
        if(penToolActionBarView)
        {
            for(UIView *echView in penToolActionBarView.subviews)
            {
                if([echView isKindOfClass:[PlayerActionBarItem class]])
                {
                    [self setHelpTextForViewForTeacherReview:echView];
                }
                else if([echView isKindOfClass:[UIView class]])
                {
                    for(UIView *echBtn in echView.subviews)
                    {
                        [self setHelpTextForViewForTeacherReview:echBtn];
                    }
                }
                else
                {
                    
                }
            }
        }
        
        if(penToolActionBottomBarView)
        {
            for(UIView *echView in penToolActionBottomBarView.subviews)
            {
                if([echView isKindOfClass:[PlayerActionBarItem class]])
                {
                    [self setHelpTextForViewForTeacherReview:echView];
                }
                else if([echView isKindOfClass:[UIView class]])
                {
                    for(UIView *echBtn in echView.subviews)
                    {
                        [self setHelpTextForViewForTeacherReview:echBtn];
                    }
                }
                else
                {
                    
                }
            }
        }
    return _helpDescriptorsForHelpScreen;
}

//Set button title & detail text for teacher review help screen
-(void)setHelpTextForViewForTeacherReview:(UIView *)eachBtn{
    NSString *titleStr=@"";
    NSString *detailTextStr=@"";
    NSString *combinedTagName = NULL;
    BOOL onSeondScreen = false;
    UILabel *echLvl=(UILabel *)eachBtn.subviews[0];
    switch (eachBtn.tag) {
        case kPenToolBarItemTypeEraser:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_ERASER_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_ERASER_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPenToolBarItemTypeDelete:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_CLEAR_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_CLEAR_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
                onSeondScreen = YES;
            break;
        case kPenToolBarItemTypeUndo:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_UNDO_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_UNDO_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
                onSeondScreen = YES;
            break;
        case kPenToolBarItemTypeNextPage:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_ARROW_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_ARROW_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            combinedTagName = @"Arrow";
            break;
        case kPenToolBarItemTypePrevPage:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_ARROW_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_ARROW_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            combinedTagName = @"Arrow";
            break;
        case kPenToolBarItemTypeDone:
            titleStr = [LocalizationHelper localizedStringWithKey:@"DONE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_DONE_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeProfile:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_STUDENT_PROFILE_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_STUDENT_PROFILE_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypePenColor:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_MARKER_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_MARKER_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            combinedTagName=@"PenColor";
            break;
        case kPlayerActionBarItemTypeDragBox:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_DRAG_BOX_STUDENT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_DRAG_BOX_STUDENT_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeGenerateReport:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_GENERATE_REPORT_STUDENT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_GENERATE_REPORT_STUDENT_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeNextStudent:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_NEXT_STUDENT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_NEXT_STUDENT_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypePrevStudent:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_PREV_STUDENT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_PREV_STUDENT_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPenToolBarItemTypePen:
            titleStr =  [LocalizationHelper localizedStringWithKey:@"HELP_PEN_TOOL_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_PEN_TOOL_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeThumbnail:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_THUMBNAIL_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_THUMBNAIL_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        default:
            
            break;
    }
    if(![titleStr isEqualToString:@""])
    {
        HelpDescriptor *helpDesc = [[HelpDescriptor alloc] initWithIcon:echLvl helpTitle:titleStr helpText:detailTextStr tagName:combinedTagName];
        helpDesc.onSecondScreen = onSeondScreen;
        [_helpDescriptorsForHelpScreen addObject:helpDesc];
    }
}

//Fetch all buttons to show in helps screen for reader
-(NSMutableArray *)getAllAppBarButton
{
    _helpDescriptorsForHelpScreen = [[NSMutableArray alloc] init];
    for (UIView *echView in self.view.subviews)
    {
        if ([echView isKindOfClass:[PlayerActionBottomBar class]])
        {
            PlayerActionBottomBar *bottomBar = (PlayerActionBottomBar *)echView;
            for (UIView *echBtn in bottomBar.subviews[0].subviews)
            {
                [self setHelpTextForView:echBtn];
            }
        }
        if ([echView isKindOfClass:[PlayerActionTopBar class]])
        {
            PlayerActionTopBar *topBar = (PlayerActionTopBar *)echView;
            for (UIView *echBtn in topBar.subviews)
            {
                [self setHelpTextForView:echBtn];
            }
        }
        if ([echView isKindOfClass:[PlayerActionBar class]])
        {
            
        }
    }
    
    if (helpBookmark) {
        [self setHelpTextForView:helpBookmark];
    }
    
    return _helpDescriptorsForHelpScreen;
}

//Set button title & detail text for reader help screen
-(void)setHelpTextForView:(UIView *)eachBtn{
    NSString *titleStr=@"";
    NSString *detailTextStr=@"";
    BOOL onSeondScreen = false;
    UILabel *echLvl=(UILabel *)eachBtn.subviews[0];
    NSDictionary* helpTextDict = [self getHelpTextTitleAndDescriptionForView:eachBtn];
    if(helpTextDict.count>0)
    {
        titleStr = [helpTextDict valueForKey:@"TITLE"];
        detailTextStr = [helpTextDict valueForKey:@"DETAIL_TEXT"];
        onSeondScreen = [[helpTextDict valueForKey:@"ON_SECOND_SCREEN"] boolValue];
    }
    if(![titleStr isEqualToString:@""])
    {
        HelpDescriptor *helpDesc = [[HelpDescriptor alloc] initWithIcon:echLvl helpTitle:titleStr helpText:detailTextStr tagName:@""  ];
        helpDesc.onSecondScreen = onSeondScreen;
        [_helpDescriptorsForHelpScreen addObject:helpDesc];
    }
}

-(NSDictionary*)getHelpTextTitleAndDescriptionForView:(UIView *)eachBtn
{
    NSString *titleStr;
    NSString *detailTextStr;
    BOOL onSeondScreen = NO;
    switch (eachBtn.tag) {
        case kPlayerActionBarItemTypeBookshelf:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_HOME_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_HOME_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeTOC:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_TOC_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_TOC_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeMyData:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_MY_DATA_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_MY_DATA_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypePenTool:
            
            titleStr =  [LocalizationHelper localizedStringWithKey:@"HELP_PEN_TOOL_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_PEN_TOOL_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            if([currentBook isKindOfClass:[EPUBBookVO class]])
            {
                onSeondScreen = YES;
            }
            break;
        case kPlayerActionBarItemTypeStickyNote:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_NOTE_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_NOTE_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            {
                onSeondScreen = YES;
            }
            break;
        case kPlayerActionBarItemTypeSubmit:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_SUBMIT_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_SUBMIT_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeThumbnail:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_THUMBNAIL_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_THUMBNAIL_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeSearch:
            titleStr = [LocalizationHelper localizedStringWithKey:@"SEARCH" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_SEARCH_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeTeacherReview:
            titleStr = [LocalizationHelper localizedStringWithKey:@"SETTINGS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_SETTING_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeStudentSubmit:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_SUBMIT_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_SUBMIT_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeProfile:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_PROFILE_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_PROFILE_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            break;
        case kPlayerActionBarItemTypeFontSetting:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_FONT_SETTING_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_FONT_SETTING_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeVerticalBar:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_MORE_SETTINGS_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_MORE_SETTINGS_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeProtractor:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_PROTRACTOR_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_PROTRACTOR_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeAddText:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_ADDTEXT_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_ADDTEXT_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeClearAllFIBs:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_CLEAR_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_CLEAR_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case 40:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_BOOKMARK_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_BOOKMARK_BUTTON_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        case kPlayerActionBarItemTypeFurthestPage:
            titleStr = [LocalizationHelper localizedStringWithKey:@"HELP_FURTHEST_PAGE_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            detailTextStr = [LocalizationHelper localizedStringWithKey:@"HELP_FURTHEST_PAGE_DETAIL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController];
            onSeondScreen = YES;
            break;
        default:
            break;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:titleStr, @"TITLE", detailTextStr, @"DETAIL_TEXT", [NSNumber numberWithBool:onSeondScreen], @"ON_SECOND_SCREEN", nil];
}

//Delegate method for swipe gesture on help screen
- (void)swipeAtIndex:(NSInteger)index {
    if (index == 0) {
        self.helpScreen.isOnSecondScreenOnHelpScreen=NO;
        [UIView animateWithDuration:PlayerActionBarAnimationTime
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished){
                             [self.playerTopActionBarView setHidden:NO];
                         }];
    } else if (index == 1){
        self.helpScreen.isOnSecondScreenOnHelpScreen=YES;
        [UIView animateWithDuration:PlayerActionBarAnimationTime
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished){
                             [self.playerTopActionBarView setHidden:YES];
                         }];
    }
    [self.view bringSubviewToFront:self.helpScreen.view];
}

//Delegate method for closing help screen
-(void)didRemovedHelpScreen
{
    if(self.helpScreen)
    {
        if(self.helpScreen.isForTeacherReview)
        {
            NSNumber *showHelpScreen = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForTeacherReview"];
            if (showHelpScreen)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"HelpScreenForTeacherReview"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else
        {
            if([currentBook isKindOfClass:[KFBookVO class]])
            {
                NSNumber *showHelpScreen = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderForPdf"];
                if (showHelpScreen)
                {
                    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"HelpScreenForReaderForPdf"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            else if([currentBook isKindOfClass:[EPUBBookVO class]])
            {
                EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
                if(epubBook.meta.layout == ePUBReflowable)
                {
                    NSNumber *showHelpScreen = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderForReflowEpub"];
                    if (showHelpScreen)
                    {
                        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"HelpScreenForReaderForReflowEpub"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                else if(epubBook.meta.layout == ePUBFixedLayout)
                {
                    NSNumber *showHelpScreen = [[NSUserDefaults standardUserDefaults] objectForKey:@"HelpScreenForReaderFixedEpub"];
                    if (showHelpScreen)
                    {
                        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"HelpScreenForReaderFixedEpub"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
        }
        self.helpScreen = nil;
    }
}

#pragma mark TextAnnotation
/**
 To Render TextAnnotation Player Bottom Bar
 */
- (void)addPlayerBottomBarForTextAnnotation
{
    textAnnotationPlayerBottomActionBarView = [[TextAnnotationActionView alloc] initWithFrame:CGRectZero];
    textAnnotationPlayerBottomActionBarView.delegate = self;
    NSArray *pageIds = [self getActivePageIDs];
    if (pageIds.count == 1)
    {
        NSArray *textAnnotations = [_dbManager textAnnotationVOForPageID:[pageIds objectAtIndex:0] ForDisplayNumber:[self getDisplayNumberForPageID:[pageIds objectAtIndex:0]] bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        if (textAnnotations.count > 0)
        {
            textAnnotationPlayerBottomActionBarView.isTextAnnotationAvailable = YES;
        }
    }
    else if (pageIds.count == 2)
    {
        NSArray *textAnnotations1 = [_dbManager textAnnotationVOForPageID:[pageIds objectAtIndex:0] ForDisplayNumber:[self getDisplayNumberForPageID:[pageIds objectAtIndex:0]] bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        NSArray *textAnnotations2 = [_dbManager textAnnotationVOForPageID:[pageIds objectAtIndex:1] ForDisplayNumber:[self getDisplayNumberForPageID:[pageIds objectAtIndex:1]] bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        if (textAnnotations1.count > 0 || textAnnotations2.count > 0)
        {
            textAnnotationPlayerBottomActionBarView.isTextAnnotationAvailable = YES;
        }
    }
    [textAnnotationPlayerBottomActionBarView addPlayerBottomBarForTextAnnotationWithParentView:self.view hdThemeVO:hdThemeVO bookType:currentBook renderer:_rendererView];
    if (textAnnotationView.text.length>0) {
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:YES themeVO:hdThemeVO];
    }
    else{
        [textAnnotationPlayerBottomActionBarView updateTextAnnotationSaveItemWithIsTextAvailable:NO themeVO:hdThemeVO];
    }
}

- (void)updatePlayerBottomBarPositionWithKeyboardSize:(CGRect)keyboardSize
{
    if (activeMode == kplayerActiveModeTextAnnotation)
    {
        if (!textAnnotationPlayerBottomActionBarView)
        {
            [self addPlayerBottomBarForTextAnnotation];
        }
        if (CGRectEqualToRect(CGRectZero, keyboardSize))
        {
            if (activeMode == kplayerActiveModeTextAnnotation)
            {
                if (textAnnotationPlayerBottomActionBarView.textAnnotationBottomMarginConstraint.constant != 0)
                {
                    textAnnotationPlayerBottomActionBarView.textAnnotationBottomMarginConstraint.constant = 0;
                }
                [self updateReaderViewPositionWithTextAnnotation:keyboardSize];
            }
            textAnnotationPlayerBottomActionBarView.isTextAnnotationKeyboardAvailable = NO;
            [self actionForTextAnnotationKeyBoard];
        }
        else
        {
            if (isIphoneX || windowWidth == 812)
            {
                CGFloat diff =  (windowWidth == 812) ? keyboardSize.size.height - 22 : keyboardSize.size.height - 34;
                textAnnotationPlayerBottomActionBarView.textAnnotationBottomMarginConstraint.constant = -diff;
            }
            else
            {
                textAnnotationPlayerBottomActionBarView.textAnnotationBottomMarginConstraint.constant = -keyboardSize.size.height;
            }
            [self updateReaderViewPositionWithTextAnnotation:keyboardSize];
            textAnnotationPlayerBottomActionBarView.isTextAnnotationKeyboardAvailable = YES;
            [self actionForTextAnnotationKeyBoard];
        }
    }
}

- (void)addTextAnnotationAlignmentView
{
    if(!textAnnotationAlignmentActionBarView)
    {
    //As enum is being accessed from swift.h file, we have added the NSInteger value of the specific enum
    textAnnotationAlignmentActionBarView = [[TextAnnotationAlignmentActionView alloc]initWithFrame:CGRectZero];
    textAnnotationAlignmentActionBarView.delegate = self;
    textAnnotationAlignmentActionBarView.numberOfItems = textAnnotationPlayerBottomActionBarView.numberOfItems;
    textAnnotationAlignmentActionBarView.selectedAlignment = textAnnotationView.textAlignment;
    [textAnnotationPlayerBottomActionBarView getTextAnnotationViewItemWithTag:2].backgroundColor = hdThemeVO.textAnnotation_selected_icon_bg;
    CGPoint point = [textAnnotationPlayerBottomActionBarView convertPoint:[textAnnotationPlayerBottomActionBarView getTextAnnotationViewItemWithTag:2].frame.origin toView:self.view];
    textAnnotationAlignmentActionBarView.atPoint = point;
    [textAnnotationPlayerBottomActionBarView updateSelectedLabelItemWithIsSelected:YES themeVO:hdThemeVO tag:2];
    [textAnnotationAlignmentActionBarView addTextAnnotationAlignmentViewWithHdThemeVO:hdThemeVO currentBook:currentBook parentView:self.view onView:textAnnotationPlayerBottomActionBarView];
    }
}

- (void)addTextAnnotationTextColorView
{
    if(!textAnnotationColorActionBarView)
    {
    textAnnotationColorActionBarView = [[TextAnnotationPalleteActionView alloc] initWithFrame:CGRectZero];
    textAnnotationColorActionBarView.delegate = self;
    textAnnotationColorActionBarView.selectedColor = textAnnotationView.backgroundColor;
    //As enum is being accessed from swift.h file, we have added the NSInteger value of the specific enum
    [textAnnotationPlayerBottomActionBarView getTextAnnotationViewItemWithTag:3].backgroundColor = hdThemeVO.textAnnotation_selected_icon_bg;
    [textAnnotationPlayerBottomActionBarView updateSelectedLabelItemWithIsSelected:YES themeVO:hdThemeVO tag:3];
    [textAnnotationColorActionBarView addTextAnnotationTextColorViewWithHdThemeVO:hdThemeVO currentBook:currentBook parentView:self.view onView:textAnnotationPlayerBottomActionBarView];
    }
}

- (void)actionForTextAnnotationKeyBoard
{
    //As enum is being accessed from swift.h file, we have added the NSInteger value of the specific enum
    PlayerActionBarItem *item = [textAnnotationPlayerBottomActionBarView getTextAnnotationViewItemWithTag:7];
    textAnnotationPlayerBottomActionBarView.isTextAnnotationKeyboardAvailable =! textAnnotationPlayerBottomActionBarView.isTextAnnotationKeyboardAvailable;
    for (UIView *itemView in item.subviews)
    {
        if ([itemView isKindOfClass:[UILabel class]])
        {
            UILabel *itemLabel = (UILabel *)itemView;
            if (textAnnotationPlayerBottomActionBarView.isTextAnnotationKeyboardAvailable) {
                itemLabel.text = ICON_KEYBOARD_UP;
                [textAnnotationView resignFirstResponder];
            }
            else{
                itemLabel.text = ICON_KEYBOARD_DOWN;
                [textAnnotationView becomeFirstResponder];
            }
        }
    }
}

- (void)removeTextAnnotationView
{
    if (backgroundActiveMode != kPlayerActiveModeNone) {
        activeMode = backgroundActiveMode;
    } else {
        activeMode = kPlayerActiveModeNone;
    }
    [textAnnotationPlayerBottomActionBarView removeFromSuperview];
    [self removeTextAnnotationAlignmentView];
    [self removeTextAnnotationColorView];
    textAnnotationPlayerBottomActionBarView = nil;
    activeMode = kPlayerActiveModeNone;
    textAnnotationView = nil;
    [actionSheet dismissViewControllerAnimated:NO completion:nil];
}

- (void)removeTextAnnotationAlignmentView
{
    if (textAnnotationAlignmentActionBarView)
    {
        //As enum is being accessed from swift.h file, we have added the NSInteger value of the specific enum
        [textAnnotationPlayerBottomActionBarView getTextAnnotationViewItemWithTag:2].backgroundColor = hdThemeVO.textAnnotation_background;
        [textAnnotationPlayerBottomActionBarView updateSelectedLabelItemWithIsSelected:NO themeVO:hdThemeVO tag:2];
        [textAnnotationAlignmentActionBarView removeFromSuperview];
        textAnnotationAlignmentActionBarView = nil;
    }
}

- (void)removeTextAnnotationColorView
{
    if (textAnnotationColorActionBarView)
    {
        //As enum is being accessed from swift.h file, we have added the NSInteger value of the specific enum
        [textAnnotationPlayerBottomActionBarView getTextAnnotationViewItemWithTag:3].backgroundColor = hdThemeVO.textAnnotation_background;
        [textAnnotationPlayerBottomActionBarView updateSelectedLabelItemWithIsSelected:NO themeVO:hdThemeVO tag:3];
        [textAnnotationColorActionBarView removeFromSuperview];
        textAnnotationColorActionBarView = nil;
    }
}

- (void)actionForDeleteTextAnnotation
{
    if (isIpad())
    {
        actionSheet = [UIAlertController alertControllerWithTitle:@"" message:[LocalizationHelper localizedStringWithKey:@"DELETE_TEXT_ANNOTATION_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] preferredStyle:UIAlertControllerStyleAlert];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"CANCEL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"DELETE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_rendererView deleteTextAnnotation];
            [self removeTextAnnotationView];
        }]];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else
    {
        actionSheet = [UIAlertController alertControllerWithTitle:@"" message:[LocalizationHelper localizedStringWithKey:@"DELETE_TEXT_ANNOTATION_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"CANCEL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"DELETE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [_rendererView deleteTextAnnotation];
            [self removeTextAnnotationView];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    [self removeTextAnnotationColorView];
    [self removeTextAnnotationAlignmentView];
}

- (void)updateReaderViewPositionWithTextAnnotation:(CGRect)keyboardRect
{
    if (CGRectEqualToRect(CGRectZero, keyboardRect))
    {
        [UIView animateWithDuration:0.3 animations:^{
            _rendererView.view.frame = CGRectMake(CGRectGetMinX(_rendererView.view.frame),
                                                  CGRectGetMinY(_rendererView.view.frame),
                                                  CGRectGetWidth(_rendererView.view.frame),
                                                  CGRectGetHeight(_rendererView.view.frame));
            
        } completion:^(BOOL finished) {
            
        }];
        _rendererView.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    else{
        float overlapHeight = 0;
        CGRect textViewFrame = [textAnnotationView.superview.superview convertRect:textAnnotationView.superview.frame toView:_rendererView.view];//textAnnotationView.superview.frame;
        if(activeMode == kplayerActiveModeTextAnnotation || activeMode == kPlayerActiveModeTeacherReview)
        {
            keyboardRect = [_rendererView.view convertRect:keyboardRect toView:nil];
            CGSize keyboardSize = keyboardRect.size;
            
            _rendererView.view.frame =
            CGRectMake(CGRectGetMinX(_rendererView.view.frame),
                       0,
                       CGRectGetWidth(_rendererView.view.frame),
                       CGRectGetHeight(_rendererView.view.frame));
            
            CGRect referanceRect = CGRectMake(0,
                                              CGRectGetHeight(_rendererView.view.frame) - (keyboardSize.height),
                                              CGRectGetWidth(_rendererView.view.frame),
                                              keyboardSize.height);
            
            if (CGRectContainsRect(referanceRect, textViewFrame) || CGRectGetMinY(referanceRect) <= CGRectGetMaxY(textViewFrame)+(isIpad() ? 58 : 50))
            {
                overlapHeight =  textViewFrame.origin.y - referanceRect.origin.y + textViewFrame.size.height + (isIpad() ? 58 : 50);
                _rendererView.view.translatesAutoresizingMaskIntoConstraints = YES;
                
                [UIView animateWithDuration:0.3 animations:^{
                    _rendererView.view.frame = CGRectMake(CGRectGetMinX(_rendererView.view.frame),
                                                          _rendererView.view.frame.origin.y - overlapHeight,
                                                          CGRectGetWidth(_rendererView.view.frame),
                                                          CGRectGetHeight(_rendererView.view.frame));
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
}
-(void)addPlayerTopBarForReadAloudView
{
    playerTopActionBarViewForReadAloud =[[PlayerActionBar alloc]initWithFrame:CGRectZero];
    playerTopActionBarViewForReadAloud.delegate =self;
    playerTopActionBarViewForReadAloud.backgroundColor = hdThemeVO.pen_tool_toolbar_background;
    playerTopActionBarViewForReadAloud.tag =kPlayerActionBarTypeForReadAloud;
    [playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForReadAloudWithIcon:@"P" withActionTag:kPlayerActionBarItemTypePrev withItemSize:readAloudItem_font] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForReadAloudWithIcon:ICON_MEDIA_PLAY withActionTag:kPlayerActionBarItemTypePlay withItemSize:readAloudItem_font] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForReadAloudWithIcon:NEXT_ICON withActionTag:kPlayerActionBarItemTypeNext withItemSize:readAloudItem_font] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    
    [playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForReadAloudWithIcon:ICON_CLOSE withActionTag:kPlayerActionBarItemTypeClose withItemSize:readAloudItemClose_font] withItemsWidth:readAloudItemDone_Width withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
    //    if(isIpad())
    //    {
    //[playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForAudioSpeedSlider] withItemsWidth:playerBar_itemSliderWidth withItemAlignments:PlayerActionBarAlignmentRight isTappable:NO];
    //        [playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForSpeedText:@"Speed"] withItemsWidth:readAloudItemSpeed_Width withItemAlignments:PlayerActionBarAlignmentRight isTappable:NO];
    //    }
    //    else
    //    {
    //        [playerTopActionBarViewForReadAloud addActionBarItem:[self getPlayerItemForSpeedText:@"SPEED"] withItemsWidth:readAloudItemSpeed_Width withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    //    }
    
    [self.view addSubview:playerTopActionBarViewForReadAloud];
    playerTopActionBarViewForReadAloud.translatesAutoresizingMaskIntoConstraints = NO;
    
    [playerTopActionBarViewForReadAloud.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [playerTopActionBarViewForReadAloud.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    _readAloudBarTopMarginConstraint = [playerTopActionBarViewForReadAloud.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    _readAloudBarTopMarginConstraint.active = YES;
    _readAloudBarTopMarginConstraint.constant = -0.4;
    [playerTopActionBarViewForReadAloud.heightAnchor constraintEqualToConstant:(playerTopBar_HeightIphone)].active = YES;
    
    playerTopActionBarViewForReadAloud.layer.borderColor = UIColor.blackColor.CGColor;
    playerTopActionBarViewForReadAloud.layer.borderWidth = 0.4;
    playerTopActionBarViewForReadAloud.layer.masksToBounds = false;
    playerTopActionBarViewForReadAloud.layer.shadowOffset = CGSizeMake(0,-1);
    playerTopActionBarViewForReadAloud.layer.shadowRadius = 4.0;
    playerTopActionBarViewForReadAloud.layer.shadowOpacity = 0.6;
    
    if(viewForReadAloudActionBar)
    {
        [self removeViewForReadAloudTopBar];
    }
    viewForReadAloudActionBar = [[UIView alloc]init];
    viewForReadAloudActionBar.backgroundColor = UIColor.clearColor;
    viewForReadAloudActionBar.frame = self.view.bounds;
    [self.view addSubview:viewForReadAloudActionBar];
    [self.view bringSubviewToFront:viewForReadAloudActionBar];
    viewForReadAloudActionBar.translatesAutoresizingMaskIntoConstraints = NO;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveReadAloudActionBarOnAndOffscreen)];
    gesture.delegate = self;
    [viewForReadAloudActionBar addGestureRecognizer:gesture];
    
    [self.view bringSubviewToFront:playerTopActionBarViewForReadAloud];
    [self moveReadAloudActionBarOffScreen];
    [self enablePlayButton:NO];
    [self enableNextPrevButtonForReadAloud];
}

-(void)addPlayerBottomBarForAudioSync
{
    if (playerBottomActionBarViewForAudioSync) {
        [playerBottomActionBarViewForAudioSync removeFromSuperview];
        playerBottomActionBarViewForAudioSync = nil;
    }
    playerBottomActionBarViewForAudioSync =[[PlayerActionTopBar alloc]initWithFrame:CGRectZero];
    playerBottomActionBarViewForAudioSync.delegate =self;
    playerBottomActionBarViewForAudioSync.backgroundColor = hdThemeVO.pen_tool_toolbar_background;
    playerBottomActionBarViewForAudioSync.tag = kPlayerActionBarTypeAudioSync;
    [playerBottomActionBarViewForAudioSync addActionBarItem:[self getPlayerItemForReadAloudWithIcon:ICON_MEDIA_PLAY withActionTag:kPlayerActionBarItemTypePlay withItemSize:readAloudItem_font] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    
    [playerBottomActionBarViewForAudioSync addActionBarItem:[self getPlayerItemForReadAloudWithIcon: isRTL() ? ICON_NEXT : ICON_PREV_PAGE_ICON withActionTag:kPlayerActionBarItemTypePrev withItemSize:readAloudItem_font] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [playerBottomActionBarViewForAudioSync addActionBarItem:[self getPlayerItemForAudioSyncSpeedLabel] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [playerBottomActionBarViewForAudioSync addActionBarItem:[self getPlayerItemForReadAloudWithIcon: isRTL() ? ICON_PREV_PAGE_ICON :  ICON_NEXT withActionTag:kPlayerActionBarItemTypeNext withItemSize:readAloudItem_font] withItemsWidth:readAloudItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    if ([currentBook isKindOfClass:[KFBookVO class]]) {
        NSInteger selectedAudiosyncColorIndex = [AudioSyncHighlightColorPalletes indexOfObject:audioSyncSelectedColor];
        NSString *audioSyncSelectedPalleteColor = [AudioSyncMenuColorPalletes objectAtIndex:selectedAudiosyncColorIndex];
        if (isIpad()) {
            for (NSString *color in AudioSyncMenuColorPalletes) {
                [playerBottomActionBarViewForAudioSync addActionBarItem:[self getAudioSyncColorPalleteItemForColor:color WithTheme:hdThemeVO withSelectedColor:audioSyncSelectedPalleteColor] withItemsWidth:AudioSyncColorPalleteItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
            }
        } else {
            [playerBottomActionBarViewForAudioSync addActionBarItem:[self getAudioSyncColorPalleteSelectionItemForColor:audioSyncSelectedPalleteColor WithTheme:hdThemeVO withSelectedColor:audioSyncSelectedPalleteColor] withItemsWidth:AudioSyncColorPalleteItem_Width withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
        }
    }
    [playerBottomActionBarViewForAudioSync addActionBarItem:[self getPlayerItemForReadAloudWithIcon:ICON_CLOSE withActionTag:kPlayerActionBarItemTypeClose withItemSize:readAloudItemClose_font] withItemsWidth:readAloudItemDone_Width withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
    
    [self.view addSubview:playerBottomActionBarViewForAudioSync];
    playerBottomActionBarViewForAudioSync.translatesAutoresizingMaskIntoConstraints = NO;
    [playerBottomActionBarViewForAudioSync.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [playerBottomActionBarViewForAudioSync.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    _readAloudBarTopMarginConstraint = [playerBottomActionBarViewForAudioSync.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    _readAloudBarTopMarginConstraint.active = YES;
    _readAloudBarTopMarginConstraint.constant = -0.4;
    [playerBottomActionBarViewForAudioSync.heightAnchor constraintEqualToConstant:(playerTopBar_HeightIphone)].active = YES;
    playerBottomActionBarViewForAudioSync.layer.borderColor = UIColor.blackColor.CGColor;
    playerBottomActionBarViewForAudioSync.layer.borderWidth = 0.4;
    playerBottomActionBarViewForAudioSync.layer.masksToBounds = false;
    playerBottomActionBarViewForAudioSync.layer.shadowOffset = CGSizeMake(0,-1);
    playerBottomActionBarViewForAudioSync.layer.shadowRadius = 4.0;
    playerBottomActionBarViewForAudioSync.layer.shadowOpacity = 0.6;
    [self.view bringSubviewToFront:playerBottomActionBarViewForAudioSync];
    [self enablePlayButton:NO];
}

-(void)actionForAudioSyncColorPalletePicker
{
    penColorPallete = [[KitabooPenToolColorPalleteViewController alloc]init];
    penColorPallete.delegate=self;
    NSInteger selectedAudiosyncColorIndex = [AudioSyncHighlightColorPalletes indexOfObject:audioSyncSelectedColor];
    NSString *audioSyncSelectedPalleteColor = [AudioSyncMenuColorPalletes objectAtIndex:selectedAudiosyncColorIndex];
    [penColorPallete setPenColors:AudioSyncMenuColorPalletes];
    [penColorPallete setSelectedPenColor:audioSyncSelectedPalleteColor];
    [penColorPallete setColorPickerBackgroundColor:hdThemeVO.pen_tool_pen_popup_background];
    [penColorPallete setSelectionBorderColor:hdThemeVO.pen_tool_pen_popup_border];
    [penColorPallete setContainerBorderColor:hdThemeVO.pen_tool_pen_popup_border];

    penToolPalleteContainer = [[UIView alloc]init];
    UILongPressGestureRecognizer *singleTapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnPentoolPalleteContainer:)];
    singleTapGesture.delegate = self;
    [penToolPalleteContainer addGestureRecognizer:singleTapGesture];
    singleTapGesture.minimumPressDuration = 0;
    
    [self.view addSubview:penToolPalleteContainer];
    penToolPalleteContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    
    [penToolPalleteContainer addSubview:penColorPallete.view];
    penColorPallete.view.translatesAutoresizingMaskIntoConstraints=NO;
    CGFloat widthForIpad = [penColorPallete.penColors count]*(PenToolBar_ItemWidth);
    CGFloat widthForIphone = ([hdThemeVO.pen_Color_Array count] > 5) ? (5*(PenToolBar_ItemWidth)) + 8 :([hdThemeVO.pen_Color_Array count]*(PenToolBar_ItemWidth)) + 8;
    CGFloat heightForIpad = 64;
    CGFloat heightForIphone = ([hdThemeVO.pen_Color_Array count] > 5)?(2 * 50) + 12:62;
    
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(penToolBar_Height + 1)]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? widthForIpad : widthForIphone]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? heightForIpad : heightForIphone]];
}

-(void)actionForTeacherReviewPenColorPalletePicker
{
    penColorPallete = [[KitabooPenToolColorPalleteViewController alloc]init];
    penColorPallete.delegate=self;
    [penColorPallete setPenColors:@[[hdThemeVO.teacherSettings_pen1_color hexStringFromColor],[hdThemeVO.teacherSettings_pen2_color hexStringFromColor]]];
    [penColorPallete setSelectedPenColor:penToolController.getPenColor];
    [penColorPallete setColorPickerBackgroundColor:hdThemeVO.pen_tool_pen_popup_background];
    [penColorPallete setSelectionBorderColor:hdThemeVO.pen_tool_pen_popup_border];
    [penColorPallete setContainerBorderColor:hdThemeVO.pen_tool_pen_popup_border];

    penToolPalleteContainer = [[UIView alloc]init];
    UILongPressGestureRecognizer *singleTapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnPentoolPalleteContainer:)];
    singleTapGesture.delegate = self;
    [penToolPalleteContainer addGestureRecognizer:singleTapGesture];
    singleTapGesture.minimumPressDuration = 0;
    
    [self.view addSubview:penToolPalleteContainer];
    penToolPalleteContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penToolPalleteContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    
    [penToolPalleteContainer addSubview:penColorPallete.view];
    penColorPallete.view.translatesAutoresizingMaskIntoConstraints=NO;
    CGFloat widthForIpad = [penColorPallete.penColors count]*(PenToolBar_ItemWidth);
    CGFloat widthForIphone = ([hdThemeVO.pen_Color_Array count] > 5) ? (5*(PenToolBar_ItemWidth)) + 8 :([hdThemeVO.pen_Color_Array count]*(PenToolBar_ItemWidth)) + 8;
    CGFloat heightForIpad = 64;
    CGFloat heightForIphone = ([hdThemeVO.pen_Color_Array count] > 5)?(2 * 50) + 12:62;
    
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.view.bounds.size.width/5]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:penToolPalleteContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(penToolBar_Height + 1)]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:widthForIpad]];
    [penToolPalleteContainer addConstraint:[NSLayoutConstraint constraintWithItem:penColorPallete.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:isIpad() ? heightForIpad : heightForIphone]];
}

-(void)didSelectAudioSyncColor:(NSString *)color
{
    if (isIpad()) {
        [playerBottomActionBarViewForAudioSync updateSelectedAudioSyncColor:color withTheme:hdThemeVO];
    } else {
        [self updateAudioSyncColorPalleteSelectionColor:color];
        [self singleTapOnPentoolPalleteContainer:nil];
    }
    NSInteger selectedAudiosyncColorIndex = [AudioSyncMenuColorPalletes indexOfObject:color];
    audioSyncSelectedColor = [AudioSyncHighlightColorPalletes objectAtIndex:selectedAudiosyncColorIndex];
    [_rendererView updateBackgroundForAudioSyncFramesWithColor:audioSyncSelectedColor];
}

-(void)moveReadAloudActionBarOnAndOffscreen
{
    if(playerTopActionBarViewForReadAloud.isHidden)
    {
        [self moveReadAloudActionBarOnScreen];
    }
    else
    {
        [self moveReadAloudActionBarOffScreen];
    }
    
}
-(void)moveReadAloudActionBarOnScreen
{
    [playerTopActionBarViewForReadAloud setHidden:NO];
    [self.view layoutIfNeeded];
    _readAloudBarTopMarginConstraint.constant = -0.4;
    [UIView animateWithDuration:PlayerActionBarAnimationTime animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
-(void)moveReadAloudActionBarOffScreen
{
    [self.view layoutIfNeeded];
    _readAloudBarTopMarginConstraint.constant = -(playerTopBar_Height+statusBarHight);
    [UIView animateWithDuration:PlayerActionBarAnimationTime animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [playerTopActionBarViewForReadAloud setHidden:YES];
    }];
    
}
-(void)removeViewForReadAloudTopBar
{
    [viewForReadAloudActionBar removeFromSuperview];
    viewForReadAloudActionBar  = nil;
}
-(void)removeReadAloudTopBar
{
    _rendererView.view.userInteractionEnabled = true;
    [self moveTopAndBottomOnScreenWithIsAnimate:NO WithCompletionHandler:nil];
    [self removeReadAloudAudioSpeedBarForIphone];
    if(playerTopActionBarViewForReadAloud)
    {
        [playerTopActionBarViewForReadAloud removeFromSuperview];
        playerTopActionBarViewForReadAloud = nil;
    }
    [self removeViewForReadAloudTopBar];
}

-(void)removeAudioSyncBottomBar
{
    if(playerBottomActionBarViewForAudioSync)
    {
        [playerBottomActionBarViewForAudioSync removeFromSuperview];
        playerBottomActionBarViewForAudioSync = nil;
    }
}

-(void)addReadAloudAudioSpeedBarForIphone
{
    //    if(audioSpeedActionBarForReadAloud)
    //    {
    //        [self removeReadAloudAudioSpeedBarForIphone];
    //    }
    //
    //    audioSpeedActionBarForReadAloud = [[PlayerActionBar alloc]initWithFrame:CGRectZero];
    //    audioSpeedActionBarForReadAloud.delegate =self;
    //    audioSpeedActionBarForReadAloud.backgroundColor = hdThemeVO.pen_tool_toolbar_background;
    //    audioSpeedActionBarForReadAloud.tag =kPlayerActionBarTypeForAudioSpeed;
    //    [audioSpeedActionBarForReadAloud addActionBarItem:[self getPlayerItemForAudioSpeedSlider] withItemsWidth:readAloudAudioSpeedItemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:NO];
    //    [self.view addSubview:audioSpeedActionBarForReadAloud];
    //    audioSpeedActionBarForReadAloud.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    [audioSpeedActionBarForReadAloud.topAnchor constraintEqualToAnchor:playerTopActionBarViewForReadAloud.bottomAnchor constant:-3].active = true;
    //    [audioSpeedActionBarForReadAloud.centerXAnchor constraintEqualToAnchor:playerTopActionBarViewForReadAloud.centerXAnchor].active = true;
    //    [audioSpeedActionBarForReadAloud.heightAnchor constraintEqualToConstant:57].active = true;
    //    [audioSpeedActionBarForReadAloud.widthAnchor constraintEqualToConstant:readAloudAudioSpeedActionBarWidth].active = true;
    //
    //    audioSpeedActionBarForReadAloud.layer.borderColor = UIColor.blackColor.CGColor;
    //    audioSpeedActionBarForReadAloud.layer.borderWidth = 0.2;
    //    audioSpeedActionBarForReadAloud.layer.masksToBounds = false;
    //    audioSpeedActionBarForReadAloud.layer.shadowOffset = CGSizeMake(0,-1);
    //    audioSpeedActionBarForReadAloud.layer.shadowRadius = 4.0;
    //    audioSpeedActionBarForReadAloud.layer.shadowOpacity = 0.6;
    //
    //    audioSpeedBar = [[PlayerActionBar alloc]initWithFrame:CGRectZero];
    //    audioSpeedBar.delegate =self;
    //    audioSpeedBar.backgroundColor = UIColor.clearColor;
    //    //audioSpeedBar.userInteractionEnabled = false;
    //    audioSpeedBar.tag =kPlayerActionBarTypeForAudioSpeedBar;
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:0] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:1] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:2] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:3] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:4] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:5] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [audioSpeedBar addActionBarItem:[self getPlayerItemForAudioSpeedBarWithSpeedTag:6] withItemsWidth:readAloudAudioSpeedItemWidth/6 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    //    [self.view addSubview:audioSpeedBar];
    //    audioSpeedBar.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    [audioSpeedBar.topAnchor constraintEqualToAnchor:audioSpeedActionBarForReadAloud.topAnchor constant:0].active = true;
    //    [audioSpeedBar.bottomAnchor constraintEqualToAnchor:audioSpeedActionBarForReadAloud.bottomAnchor constant:0].active = true;
    //    [audioSpeedBar.leadingAnchor constraintEqualToAnchor:audioSpeedActionBarForReadAloud.leadingAnchor constant:audioSpeedBarLeft].active = true;
    //    [audioSpeedBar.trailingAnchor constraintEqualToAnchor:audioSpeedActionBarForReadAloud.trailingAnchor constant:-audioSpeedBarLeft].active = true;
}
-(void)removeReadAloudAudioSpeedBarForIphone
{
    //    if(audioSpeedActionBarForReadAloud)
    //    {
    //        [audioSpeedActionBarForReadAloud removeFromSuperview];
    //        audioSpeedActionBarForReadAloud = nil;
    //    }
    //    if(audioSpeedBar)
    //    {
    //        [audioSpeedBar removeFromSuperview];
    //        audioSpeedBar = nil;
    //    }
}
-(PlayerActionBarItem *)getPlayerItemForReadAloudWithIcon:(NSString *)iconStr withActionTag:(int)playerActionTag withItemSize:(CGFloat)size
{
    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = playerActionTag;
    actionBarItem.backgroundColor = [UIColor clearColor];
    UILabel *textForAction = [[UILabel alloc] init];
    [textForAction setText:iconStr];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:DefualtFont(size)];
    textForAction.textColor = hdThemeVO.top_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    return actionBarItem;
}
//-(PlayerActionBarItem*)getPlayerItemForAudioSpeedSlider
//{
//    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
//    actionBarItem.tag=kPlayerActionBarItemTypeSlider;
//    changeReadAloudAudioSlider = [[UISlider alloc]init];
//    changeReadAloudAudioSlider.value = 1.0;
//    changeReadAloudAudioSlider.minimumValue = 0.0;
//    changeReadAloudAudioSlider.maximumValue = 2.0;
//    changeReadAloudAudioSlider.continuous =YES;
//
//    [changeReadAloudAudioSlider addTarget:self action:@selector(didAudioSliderBeginChanged:) forControlEvents:UIControlEventValueChanged];
//    [changeReadAloudAudioSlider addTarget:self action:@selector(didEndAudioSliderScrolling:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];
//    changeReadAloudAudioSlider.thumbTintColor = hdThemeVO.share_icon_color;
//    changeReadAloudAudioSlider.tintColor = hdThemeVO.share_icon_color;
//    [actionBarItem addSubview:changeReadAloudAudioSlider];
//    changeReadAloudAudioSlider.translatesAutoresizingMaskIntoConstraints =NO;
//    [changeReadAloudAudioSlider.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active = true;
//    [changeReadAloudAudioSlider.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:0].active = true;
//    [changeReadAloudAudioSlider.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:0].active = true;
//    [changeReadAloudAudioSlider.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active = true;
//    return actionBarItem;
//}
-(PlayerActionBarItem *)getPlayerItemForSpeedText:(NSString*)text
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPlayerActionBarItemTypeSpeedText;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:text];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(isIpad()?28:18)];
    textForAction.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active = true;
    [textForAction.centerXAnchor constraintEqualToAnchor:actionBarItem.centerXAnchor constant:0].active = true;
    [textForAction.widthAnchor constraintEqualToConstant:80].active = true;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active = true;
    return actionBarItem;
}

-(PlayerActionBarItem *)getAudioSyncColorPalleteItemForColor:(NSString*)color WithTheme:(KBHDThemeVO*)themeVo withSelectedColor:(NSString *)selectedPenColor
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    [actionBarItem.metaData setValue:color forKey:@"penColor"];
    actionBarItem.tag = kPlayerActionBarItemTypeAudioSyncColor;
    HighLightToolView *highlightToolV = [[HighLightToolView alloc] init];
    highlightToolV.iconLabel.clipsToBounds = YES;
    highlightToolV.iconLabel.backgroundColor = [UIColor colorWithHexString:color];
    actionBarItem.backgroundColor = highlightToolV.contentView.backgroundColor = [UIColor clearColor];
    highlightToolV.borderView.layer.borderWidth = 1.2;
    highlightToolV.borderView.layer.borderColor = [UIColor clearColor].CGColor;
    [highlightToolV resetViewForColorPalletWithColorHeight: isIPAD?(PenToolBar_ItemWidth) - 36 : (PenToolBar_ItemWidth) - 18];
    highlightToolV.iconLabel.accessibilityIdentifier = [NSString stringWithFormat:@"penTool_%@", color];
    [actionBarItem addSubview:highlightToolV];
    highlightToolV.translatesAutoresizingMaskIntoConstraints = NO;
    actionBarItem.translatesAutoresizingMaskIntoConstraints = NO;
    [actionBarItem.heightAnchor constraintEqualToConstant:isIPAD?64:18].active = YES;
    [highlightToolV.leftAnchor constraintEqualToAnchor:actionBarItem.leftAnchor constant:0].active = YES;
    [highlightToolV.rightAnchor constraintEqualToAnchor:actionBarItem.rightAnchor constant:0].active = YES;;
    [highlightToolV.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active = YES;;
    [highlightToolV.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active = YES;
    
    [highlightToolV layoutIfNeeded];
    if([color isEqualToString:selectedPenColor])
    {
        actionBarItem.selected=YES;
        highlightToolV.borderView.layer.borderColor = themeVo.pen_tool_selected_icon_background.CGColor;

    }
    return actionBarItem;
}
-(PlayerActionBarItem *)getAudioSyncColorPalleteSelectionItemForColor:(NSString*)color WithTheme:(KBHDThemeVO*)themeVo withSelectedColor:(NSString *)selectedPenColor
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    [actionBarItem.metaData setValue:color forKey:@"penColor"];
    actionBarItem.tag = kPlayerActionBarItemTypeAudioSyncColorSelector;
    HighLightToolView *highlightToolV = [[HighLightToolView alloc] init];
    highlightToolV.iconLabel.clipsToBounds = YES;
    highlightToolV.iconLabel.backgroundColor = [UIColor colorWithHexString:color];
    actionBarItem.backgroundColor = highlightToolV.contentView.backgroundColor = [UIColor clearColor];
    highlightToolV.borderView.layer.borderWidth = 1.2;
    highlightToolV.borderView.layer.borderColor = [UIColor clearColor].CGColor;
    [highlightToolV resetViewForColorPalletWithColorHeight: 20];
    highlightToolV.iconLabel.accessibilityIdentifier = [NSString stringWithFormat:@"penTool_%@", color];
    [actionBarItem addSubview:highlightToolV];
    highlightToolV.translatesAutoresizingMaskIntoConstraints = NO;
    actionBarItem.translatesAutoresizingMaskIntoConstraints = NO;
    [actionBarItem.heightAnchor constraintEqualToConstant:isIPAD?64:18].active = YES;
    [highlightToolV.centerXAnchor constraintEqualToAnchor:actionBarItem.centerXAnchor constant:0].active = YES;
    [highlightToolV.centerYAnchor constraintEqualToAnchor:actionBarItem.centerYAnchor constant:0].active = YES;;
    [highlightToolV.heightAnchor constraintEqualToConstant:20].active = YES;;
    [highlightToolV.widthAnchor constraintEqualToConstant:20].active = YES;
    
    UILabel *textForAction = [[UILabel alloc] init];
    [textForAction setText:@"»"];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:DefualtFont(10)];
    textForAction.textColor = hdThemeVO.top_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5]];
    return actionBarItem;
}
//-(PlayerActionBarItem*)getPlayerItemForAudioSpeedBarWithSpeedTag:(NSInteger)tag
//{
//    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
//    actionBarItem.tag=kPlayerActionBarItemTypeAudioSpeedBarView;
//    UILabel *viewBar = [[UILabel alloc]init];
//    viewBar.tag = tag;
//    viewBar.backgroundColor = [hdThemeVO.share_icon_color colorWithAlphaComponent:0.8];
//    [actionBarItem addSubview:viewBar];
//    viewBar.translatesAutoresizingMaskIntoConstraints =NO;
//    [viewBar.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:0].active = true;
//    [viewBar.centerYAnchor constraintEqualToAnchor:actionBarItem.centerYAnchor constant:0].active = true;
//    [viewBar.widthAnchor constraintEqualToConstant:4].active = true;
//    [viewBar.heightAnchor constraintEqualToConstant:12].active = true;
//    return actionBarItem;
//}
-(void)didAudioSliderBeginChanged:(UISlider *)slider
{
    
}
-(void)didEndAudioSliderScrolling:(UISlider*)slider
{
    [_audioSyncController changeAudioPlayingSpeed:slider.value];
}
//-(float)getReadAloudValume
//{
//    return changeReadAloudAudioSlider ? changeReadAloudAudioSlider.value : 1.0;
//}
-(PlayerActionBarItem*)getReadAloudItemWithTag:(PlayerActionBarItemType)readAloudBarItemType
{
    for (PlayerActionBarItem *playerActionBarItem in [playerTopActionBarViewForReadAloud getTappableItems]) {
        if(playerActionBarItem.tag==readAloudBarItemType)
        {
            return playerActionBarItem;
        }
    }
    return nil;
}

-(PlayerActionBarItem*)getAudioSyncItemWithTag:(PlayerActionBarItemType)readAloudBarItemType
{
    for (PlayerActionBarItem *playerActionBarItem in [playerBottomActionBarViewForAudioSync getTappableItems]) {
        if(playerActionBarItem.tag==readAloudBarItemType)
        {
            return playerActionBarItem;
        }
    }
    return nil;
}

-(void)readAloudItemEnable:(BOOL)enable withItem:(PlayerActionBarItem*)readAloudItem
{
    readAloudItem.enabled = enable;
    readAloudItem.alpha = enable ? 1.0 : 0.5;
}
-(void)enableNextPrevButtonForReadAloud
{
    KFBookVO *book=(KFBookVO*)currentBook;
    KFPageVO *nextAudioPage = [book getNextAudioLinkPagefromCurrentPageNumber:[[self getActivePageIDs]lastObject]];
    if(nextAudioPage)
    {
        [self readAloudItemEnable:YES withItem:[self getReadAloudItemWithTag:kPlayerActionBarItemTypeNext]];
    }
    else
    {
        [self readAloudItemEnable:false withItem:[self getReadAloudItemWithTag:kPlayerActionBarItemTypeNext]];
    }
    
    KFPageVO *prevAudioPage = [book getPrevAudioLinkPagefromCurrentPageNumber:[[self getActivePageIDs]firstObject]];
    if(prevAudioPage)
    {
        [self readAloudItemEnable:YES withItem:[self getReadAloudItemWithTag:kPlayerActionBarItemTypePrev]];
    }
    else
    {
        [self readAloudItemEnable:false withItem:[self getReadAloudItemWithTag:kPlayerActionBarItemTypePrev]];
    }
}

-(void)configurePrintIconForChapter:(EPUBChapter*)chapter
{
    if (!_isReflowPrintEnable) {
        NSString* href = chapter.href;
        PlayerActionBarItem *printButton = [self getPrintButtonForPlayer:_playerTopActionBarView];
        if ([printEnabledPageArray containsObject:href]) {
            printButton.enabled = true;
            printButton.alpha =  1.0;
        }
        else{
            printButton.enabled = false;
            printButton.alpha =  0.0;
        }
    }
}

-(void)addPrintPageViewOnPageNumber:(NSNumber*)pageNo OnDisplayNumber:(NSString*)displayNum
{
    EPUBBookVO *epubBook = (EPUBBookVO*)currentBook;
    BOOL isPrintEnable = false;
    if (([currentBook isKindOfClass:[EPUBBookVO class]] && (epubBook.meta.layout==ePUBFixedLayout))) {
        NSString *thumbnailDisplayNo = [self getThumbnailDisplayNumberForPageNumber:pageNo];
        if ([printEnabledPageArray containsObject:thumbnailDisplayNo]) {
            isPrintEnable = true;
        }
    }
    if ([currentBook isKindOfClass:[KFBookVO class]] || ([currentBook isKindOfClass:[EPUBBookVO class]] && (epubBook.meta.layout==ePUBFixedLayout) && isPrintEnable)) {
        PrintPageButton *_printPageView = [[PrintPageButton alloc]init];
        [_printPageView setPageNumber:pageNo];
        _printPageView.delegate = self;
        [_printPageView setTitle:ICON_PRINT forState:UIControlStateNormal];
        [_printPageView.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad()?50.0:34]];
        [_printPageView setTitleColor:hdThemeVO.bookmark_icon_color forState:UIControlStateNormal];
        [_rendererView addPrintPageView:_printPageView onPageNO:[pageNo integerValue]];
    }
}
-(NSString*)getThumbnailDisplayNumberForPageNumber:(NSNumber*)pageNo
{
    NSArray *pageDataArray = [currentBook getThumbnailData];
    if (pageDataArray.count)
    {
        NSDictionary *dict = pageDataArray[0];
        NSArray *pageArray = [dict valueForKey:@"Pages"];
        for( NSDictionary *page in pageArray)
        {
            if ([page valueForKey:@"PageNo"] && [self getDisplayNumber:[page valueForKey:@"PageNo"]] == [pageNo stringValue]) {
                NSString *displayNumber = [self getDisplayNumber:[page valueForKey:@"DisplayNumber"]];
                return displayNumber;
            }
        }
    }
    return nil;
}
- (void)didTapOnPrintPageWithPageNumber:(NSNumber *)pageNumber
{
    [self didTapOnPrintPageWithWatermark:pageNumber];
    return;
    [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
    UIImage* pageImageToPrint = [_rendererView getPageImageToPrintForPageNumber:[pageNumber integerValue]];
    if(pageImageToPrint)
    {
        printPageVC = [[PrintPageViewController alloc]initWithPrintImage:pageImageToPrint];
        printPageVC.delegate = self;
        [self.view addSubview:printPageVC.view];
        [self.view bringSubviewToFront:printPageVC.view];
        printPageVC.view.translatesAutoresizingMaskIntoConstraints = false;
        [printPageVC.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = true;
        [printPageVC.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = true;
        [printPageVC.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = true;
        [printPageVC.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
    }
}
- (void)didTapOnPrintPageWithWatermark:(NSNumber *)pageNumber
{
    NSMutableArray *pageNumbers = [[NSMutableArray alloc] init];
    if (pageNumber) {
        [pageNumbers addObject:pageNumber];
    } else {
        if([currentBook isKindOfClass:[KFBookVO class]])
        {
            NSArray *activePages=[_rendererView getActivePages];
            if(activePages.count)
            {
                for (KFPageVO *page in activePages){
                    [pageNumbers addObject:[NSNumber numberWithInteger:page.pageID]];
                }
            }
        }
        else if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            NSArray *activePages=[_rendererView getActivePages];
            if(activePages.count)
            {
                for (EPUBPage *page in activePages){
                    [pageNumbers addObject:[NSNumber numberWithInteger:page.fileIndex]];
                }
            }
        }
    }
    if (pageNumbers.count) {
        [self moveTopAndBottomOffScreenWithIsAnimate:NO WithCompletionHandler:nil];
        NSString *watermarkText = [NSString stringWithFormat:@"%@, User id=%@, Book id=%@.",[LocalizationHelper localizedStringWithKey:@"WATERMARK_TEXT"],_user.userID,_bookID];
        [_rendererView printPagesWithWatermark:watermarkText WithTextColor:WatermarkTextColor ForPageNumbers:pageNumbers WithCallback:^(id printPage) {
            if(printPage)
            {
                printPageVC = [[PrintPageViewController alloc]initWithPrintPage:printPage];
                if (printPageVC) {
                    printPageVC.delegate = self;
                    [self.view addSubview: printPageVC.view];
                    printPageVC.view.translatesAutoresizingMaskIntoConstraints = false;
                    [printPageVC.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = true;
                    [printPageVC.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = true;
                    [printPageVC.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = true;
                    [printPageVC.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
                }
            }
        }];
    }
}
-(void)setPrintEnabledPageArray:(NSString*)printEnabledPages{
    if (printEnabledPages) {
        printEnabledPageArray = [printEnabledPages componentsSeparatedByString:@","];
    }
}
- (void)printPageViewControllerDidDismiss
{
    [self removePrintPageViewController];
}
- (void)PrintPageViewControllerDidFinishJob
{
    [self removePrintPageViewController];
}
- (void)deviceNotSupportsPagePrinting
{
    [self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@"DEVICE_NOT_SUPPORTS_PRINTING" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]];
    [self removePrintPageViewController];
}
- (void)didPagePrintedSuccessFully
{
    //[self showAlertWithTitle:@"" WithMessage:[LocalizationHelper localizedStringWithKey:@""]];
}
- (void)didPagePrintingFailedWithError:(NSError *)error
{
    if(error)
    {
        //[self showAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"PRINT_FAILED_ERROR_ALERT_TITLE"] WithMessage:error.localizedDescription];
    }
}
-(void)removePrintPageViewController
{
    [printPageVC.view removeFromSuperview];
    printPageVC=nil;
}


/*Reflowable Slider Implementation.*/
-(void)addSliderBarForReflowableBook
{
    if (viewForSliderBar) {
        [viewForSliderBar removeFromSuperview];
        viewForSliderBar = nil;
    }
    sliderCompletedValue = NO;
    /*comment this when horizontal slider is enable. And also comment enable pagination code in HDReaderController on SDK when horizontal slider is enable*/
    if (!isVerticalsliderEnable) {
        return;
    }
    
    sliderTottalPages = 0;
    viewForSliderBar = [[HDSliderBarView alloc] initWithVerticalSliderValue:isVerticalsliderEnable];
    viewForSliderBar.translatesAutoresizingMaskIntoConstraints = NO;
    viewForSliderBar.backgroundColor = UIColor.clearColor;
    [self.view addSubview:viewForSliderBar];
    [viewForSliderBar enableSliderThumbImage:NO];
    viewForSliderBar.percentageLabel.hidden = YES;
    viewForSliderBar.hidden = YES;
    
    /*Uncomment this line when horizontal slider is enable and comment below contraints.*/
    /*[self updateVerticalSliderViewConstraints];*/
    
    topConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:topConstantsForVerticalSliderView];
    widthConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:isIpad()?50:40];
    bottomConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    if (@available(iOS 11.0, *)) {
        rightConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:(3*sliderRightAndBottom)+self.view.safeAreaInsets.right];
    } else {
        rightConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:(3*sliderRightAndBottom)];
    }
    
    [self.view addConstraints:@[topConstraintForVerticalSliderView, widthConstraintForVerticalSliderView,bottomConstraintForVerticalSliderView,rightConstraintForVerticalSliderView]];
    
    __weak typeof(self) weakSelf = self;
    [viewForSliderBar setSliderValueChanged:^(float currentValue){
        [weakSelf didSliderScrollWithValue:currentValue];
    }];
    
    [viewForSliderBar setSliderMoves:^(float currentValue) {
        [weakSelf movesSlider:currentValue];
    }];
    
    if (enableSliderPopUp) {
        if (!_reflowableSliderPopUpView) {
            _reflowableSliderPopUpView = [[HDReflowableSliderPopUpView alloc] init];
            _reflowableSliderPopUpView.readingTimeLeftLabel.alpha=0;
        }
        _reflowableSliderPopUpView.backgroundColor = UIColor.clearColor;
        _reflowableSliderPopUpView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_reflowableSliderPopUpView];
        _reflowableSliderPopUpView.alpha = 0.0;
        
        [_reflowableSliderPopUpView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50].active = YES;
        [_reflowableSliderPopUpView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0].active = YES;
        [_reflowableSliderPopUpView.widthAnchor constraintEqualToConstant:(isIPAD ? 300 : 250)].active = YES;
        [_reflowableSliderPopUpView.heightAnchor constraintEqualToConstant:100].active = YES;
    }
}

-(void)addReflowablePageCountView {
    if (!_reflowableSliderPageCountView) {
        _reflowableSliderPageCountView = [[HDReflowablePageCountView alloc] init];
        _reflowableSliderPageCountView.alpha = 0.9;
        [_reflowableSliderPageCountView setPageData:@""];
        [_reflowableSliderPageCountView setCustomFontFamily:CustomFontNameForWeight];
        _reflowableSliderPageCountView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view insertSubview:_reflowableSliderPageCountView aboveSubview:_rendererView.view];
        [_reflowableSliderPageCountView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_reflowableSliderPageCountView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
        [_reflowableSliderPageCountView.heightAnchor constraintEqualToConstant:(isIpad() ? 40 :30 )].active = YES;
        [_reflowableSliderPageCountView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    }
    [self setPageCountViewColor];
    [self hideReflowablePageCountView];
    [_reflowableSliderPageCountView layoutIfNeeded];
}

-(void)updateVerticalSliderViewConstraints
{
    if (topConstraintForVerticalSliderView && widthConstraintForVerticalSliderView && bottomConstraintForVerticalSliderView && rightConstraintForVerticalSliderView) {
        [self.view removeConstraints:@[topConstraintForVerticalSliderView, widthConstraintForVerticalSliderView,bottomConstraintForVerticalSliderView,rightConstraintForVerticalSliderView]];
    }
    if (isVerticalsliderEnable) {
        topConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:50];
        widthConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
        bottomConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        rightConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:sliderRightAndBottom];
        
    }else
    {
        topConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
        widthConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
        bottomConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:(sliderRightAndBottom-5)];
        rightConstraintForVerticalSliderView = [NSLayoutConstraint constraintWithItem:viewForSliderBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    }
    [self.view addConstraints:@[topConstraintForVerticalSliderView, widthConstraintForVerticalSliderView,bottomConstraintForVerticalSliderView,rightConstraintForVerticalSliderView]];
}

-(void)movesSlider:(float)value {
    if([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if (epubBook.isBookContentLoaded){
            _reflowableSliderPopUpView.alpha = 1.0;
            EPUBChapter *chapter = [self getCurrentChapterWithSliderValue:value];
            NSArray *tocData = [self getTOCContentData];
            [self updateChapterTitleForChapter:chapter withTOCData:tocData];
            
            _reflowableSliderPopUpView.chapterNameLabel.font = getCustomFontForWeight(17,UIFontWeightBold);
            _reflowableSliderPopUpView.chapterNameLabel.text = currentChapterName;
            
            NSInteger content = chapter.bookContentSizeTillChapter;
            NSInteger currentPageOffset = value - content;
            NSInteger pageSize = self.view.frame.size.height;
            NSInteger pages = currentPageOffset/pageSize;
            if (currentPageOffset % pageSize) {
                pages += 1;
            }
            NSInteger totalPages = chapter.totalNumOfPagesTillChapter + pages;
            _reflowableSliderPopUpView.chapterLabel.font = getCustomFontForWeight(10,UIFontWeightRegular);
            if ([self isCoverPage:chapter]) {
                _reflowableSliderPopUpView.chapterLabel.text = @"";
            } else {
                _reflowableSliderPopUpView.chapterLabel.text = [NSLocalizedStringFromTableInBundle(@"PAGE",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil) stringByAppendingString:[NSString stringWithFormat:@" %@",[NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:totalPages]]]];
            }
        }else {
            _reflowableSliderPopUpView.alpha = 1.0;
            EPUBChapter *chapter = [self getChapterForSliderCFIValue:value];
            NSArray *tocData = [self getTOCContentData];
            [self updateChapterTitleForChapter:chapter withTOCData:tocData];
        }
    }
}
-(BOOL)isCoverPage:(EPUBChapter *)chapter {
    BOOL isCoverPage = NO;
    if([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *_book=(EPUBBookVO*)currentBook;
        for (EPUBGuide *guide in _book.guides) {
            if ([guide.href isEqualToString:chapter.href] && [guide.type isEqualToString: @"cover"]) {
                isCoverPage = YES;
                break;
            }
        }
    }
    return isCoverPage;
}

-(EPUBChapter *)getCurrentChapterWithSliderValue:(float)value
{
    EPUBChapter *chapter;
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        NSInteger targetPage = value;
        NSInteger pageSum = 0;
        NSInteger pageIndex = 0;
        for (chapter in epubBook.chapters) {
            pageSum = chapter.contentSize;
            if (pageSum>=targetPage) {
                pageIndex = targetPage;
                break;
            }else{
                targetPage = targetPage-pageSum;
            }
        }
    }
    return chapter;
}

-(void)didSliderScrollWithValue:(float)sliderValue
{
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if (epubBook.isBookContentLoaded) {
            NSInteger targetPage = sliderValue;
            NSInteger pageSum = 0;
            NSInteger pageIndex = 0;
            
            EPUBChapter *chapter;
            if (epubBook.chapters.count == 1) {
                chapter = epubBook.chapters[0];
                pageIndex = targetPage;
            }else {
                for (chapter in epubBook.chapters) {
                    pageSum = chapter.contentSize;
                    if (pageSum>=targetPage) {
                        pageIndex = targetPage;
                        break;
                    }else{
                        targetPage = targetPage-pageSum;
                    }
                }
            }
            NSString *navigateString = [chapter.href stringByAppendingString:[NSString stringWithFormat:@"#contentPosition%ld",(long)pageIndex]];
            [_rendererView navigateToPageNumber:navigateString];
        }else {
            NSString *currentCFI = [epubBook.bookCFIArray objectAtIndex:(((int)sliderValue)-1)];
            EPUBChapter *chapter = [self getChapterForSliderCFIValue:sliderValue];
            NSInteger currentSliderValue = [epubBook.bookCFIArray indexOfObject:currentCFI];
            if (currentSliderValue == 0 && chapter.fileIndex > 0 && epubBook.coverImageName != nil) {
                EPUBChapter *coverChapter = [self getEpubChapterForIndex:chapter.fileIndex-1];
                [_rendererView navigateToPageNumber:coverChapter.href];
            }else {
                NSString *navigateString = [chapter.href stringByAppendingString:[NSString stringWithFormat:@"#bookCFI%@",currentCFI]];
                [_rendererView navigateToPageNumber:navigateString];
            }
        }
    }
    
    [UIView transitionWithView:_reflowableSliderPopUpView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _reflowableSliderPopUpView.alpha = 0.0;
    }  completion:nil];
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didChangeContentPosition:(CGFloat)contentOffset forChapter:(NSInteger)chapterIndex withContentSize:(CGFloat)contentSize isCoverPage:(BOOL)coverPage {
    if (sliderCompletedValue) {
        if([currentBook isKindOfClass:[EPUBBookVO class]]) {
            EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
            EPUBChapter *chapter = [self getEpubChapterForIndex:chapterIndex];
            if (epubBook.isBookContentLoaded) {
                NSInteger availablePages = chapter.bookContentSizeTillChapter;
                if ((chapter.fileIndex == epubBook.chapters.count-1) && (contentOffset+self.view.frame.size.height >= contentSize)) {
                    [viewForSliderBar.pageSlider setValue:viewForSliderBar.pageSlider.maximumValue animated:NO];
                }else {
                    [viewForSliderBar.pageSlider setValue:(availablePages + contentOffset) animated:NO];
                }
                [viewForSliderBar updatePercentage];
            }else {
                if ((chapter.fileIndex == epubBook.chapters.count-1) && (contentOffset+self.view.frame.size.height >= contentSize)) {
                    [viewForSliderBar.pageSlider setValue:viewForSliderBar.pageSlider.maximumValue animated:NO];
                }
            }
        }
    }
}

-(EPUBChapter *)getEpubChapterForIndex:(NSInteger)fileIndex {
    EPUBChapter *epubChapter;
    if([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        epubChapter = [epubBook.chapters objectAtIndex:fileIndex];
    }
    return epubChapter;
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didChangeReflowableBookPage:(NSString *)pageNumber forChapter:(NSInteger)chapterIndex withTotalPagesInChapter:(NSString *)totalChapterPages withTotalPagesInBook:(NSString *)totalBookPages isCoverPage:(BOOL)coverPage{
    NSString *pageText = @"";
    if (pageNumber.integerValue > totalBookPages.integerValue) {
        pageNumber = totalBookPages;
    }
    if (totalChapterPages.integerValue > totalBookPages.integerValue) {
        totalChapterPages = totalBookPages;
    }
    NSString *totalPagesString = @"";
    
    EPUBChapter *chapter = [self getEpubChapterForIndex:chapterIndex];
    NSInteger totalPages = chapter.totalNumOfPagesTillChapter + pageNumber.integerValue;
    EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
    if (!epubBook.userReaderFontSettings.scrollEnabled) {
        if(isRTL()) {
            NSString *updatedPageNumber;
            NSMutableArray *pageNumbersArray = [[pageNumber componentsSeparatedByString:@","] mutableCopy];
            if(pageNumbersArray.count > 1) {
                for (int i=0; i<pageNumbersArray.count; i++) {
                    int pageNum = ([totalChapterPages intValue] - [pageNumbersArray[i] intValue]) + 1;
                    pageNumbersArray[i] = [NSString stringWithFormat:@"%d", pageNum];
                }
                pageNumbersArray = [NSMutableArray arrayWithArray:[pageNumbersArray sortedArrayUsingSelector: @selector(compare:)]];
                updatedPageNumber = [pageNumbersArray componentsJoinedByString:@", "];
                pageNumber = updatedPageNumber;
            }
            else {
                updatedPageNumber = [NSString stringWithFormat:@"%d", ([totalChapterPages intValue] - [pageNumber intValue]) + 1];
                pageNumber = updatedPageNumber;
            }
        }
        if (isIPAD && UIScreen.mainScreen.bounds.size.width>UIScreen.mainScreen.bounds.size.height) {
            totalPagesString = [[NSString stringWithFormat:@"%ld", (long)totalPages] stringByAppendingFormat:@"-%ld",(long)(totalPages+1)];
        }else {
            totalPagesString = [NSString stringWithFormat:@"%ld", (long)totalPages];
        }
    }else {
        totalPagesString = [NSString stringWithFormat:@"%ld", (long)totalPages];
    }
    if (totalPagesString.integerValue > totalBookPages.integerValue) {
        totalPagesString = totalBookPages;
    }
    
    //Below code is for number localization
    NSMutableArray *pageNumbersInArray = [[pageNumber componentsSeparatedByString:@","] mutableCopy];
    for (int i=0; i<pageNumbersInArray.count; i++)
    {
        pageNumbersInArray[i] = [NumberLocalizationHandler localizeNumberWithNumber:[pageNumbersInArray[i] hsNumberValue]];
    }
    pageNumber = [pageNumbersInArray componentsJoinedByString: @", "];
    NSMutableArray *totalPagesArray = [[totalPagesString componentsSeparatedByString:@"-"] mutableCopy];
    for (int i=0; i<totalPagesArray.count; i++)
    {
        totalPagesArray[i] = [NumberLocalizationHandler localizeNumberWithNumber:[totalPagesArray[i] hsNumberValue]];
    }
    totalPagesString = [totalPagesArray componentsJoinedByString: @"-"];
    totalBookPages = [NumberLocalizationHandler localizeNumberWithNumber:[totalBookPages hsNumberValue]];
    totalChapterPages = [NumberLocalizationHandler localizeNumberWithNumber:[totalChapterPages hsNumberValue]];
    totalBookPages = [[totalPagesString stringByAppendingString:@" / "] stringByAppendingString:totalBookPages];
    
    NSInteger currentPageNumber=[[totalPagesString componentsSeparatedByString:@"-"] lastObject].integerValue;
    float percentageRead = ((float)currentPageNumber/totalBookPages.floatValue)*100;
    if([_delegate respondsToSelector:@selector(didUpdatedReadPercentageTo:ForBookID:)])
    {
        if(isVerticalsliderEnable)
        {
            [_delegate didUpdatedReadPercentageTo:[viewForSliderBar.percentageLabel.text stringByReplacingOccurrencesOfString:@"%" withString:@""].integerValue ForBookID:_bookID.stringValue];
        }
        else
        {
            [_delegate didUpdatedReadPercentageTo:[NSNumber numberWithDouble:(percentageRead)].integerValue ForBookID:_bookID.stringValue];
        }
    }
    
    NSString *bookCountString  = [NSString stringWithFormat:@" | %@ ", totalBookPages];
    if (!coverPage) {
        pageText = [[[[[LocalizationHelper localizedStringWithKey:@"PAGE"] stringByAppendingFormat:@" %@ ",pageNumber ] stringByAppendingString:[LocalizationHelper localizedStringWithKey:@"OF_KEY"]] stringByAppendingFormat:@" %@", totalChapterPages] stringByAppendingString:bookCountString];
    }
    [_reflowableSliderPageCountView setPageData:pageText];
    [self hideReflowablePageCountView];
}

- (void)bookCFIsLoadingCompleted:(NSInteger)TotalNumberOfCFIs {
    NSNumber *number = [NSNumber numberWithInteger:TotalNumberOfCFIs];
    [self performSelector:@selector(handleSliderWhenCFIsAreLoaded:) withObject:number afterDelay:1];
    [self handleSliderWhenCFIsAreLoaded:number];
}

-(void)handleSliderWhenCFIsAreLoaded:(NSNumber *)TotalNumberOfCFIs {
    viewForSliderBar.hidden = NO;
    bottomConstraintForVerticalSliderView.constant = (self.view.frame.size.height - bottomConstantsForVerticalSliderView);
    viewForSliderBar.sliderContainerVewHeight.constant = (bottomConstraintForVerticalSliderView.constant - 40);
    [self handleSliderWhenDataLoaded:TotalNumberOfCFIs.integerValue];
}

-(void)bookLoadingCompletedWithContentSize:(NSInteger)contentSize
{
    [self handleSliderWhenDataLoaded:contentSize];
}

-(void)handleSliderWhenDataLoaded:(NSInteger)contentSize{
    sliderCompletedValue = YES;
    viewForSliderBar.pageSlider.maximumValue = contentSize;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [viewForSliderBar enableSliderThumbImage:YES];
        viewForSliderBar.percentageLabel.hidden = NO;
        [viewForSliderBar setSliderThumbColour:hdThemeVO.thumbnail_slider_slider_color maxTintColor:UIColor.lightGrayColor minTintColor:hdThemeVO.thumbnail_slider_slider_color];
        viewForSliderBar.percentageLabel.textColor = hdThemeVO.thumbnail_slider_slider_color;
        [viewForSliderBar setImageForSlider:[UIImage imageNamed:@"SliderThumbImage" inBundle:[NSBundle bundleForClass:[ReaderViewController class]] compatibleWithTraitCollection:nil] withColour:hdThemeVO.thumbnail_slider_slider_color];
    });
}

-(void)didBookChaptersProcessSuccessfully:(NSInteger)chaptersIndex withChapterContentSize:(NSInteger)contentSize isCoverPage:(BOOL)coverPage
{
    viewForSliderBar.hidden = NO;
    if([currentBook isKindOfClass:[EPUBBookVO class]])
    {
        if (chaptersIndex == 0) {
            sliderTottalPages = 0;
        }
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        NSInteger totalChapters = epubBook.chapters.count;
        if (totalChapters == 1) {
            bottomConstraintForVerticalSliderView.constant = (self.view.frame.size.height - bottomConstantsForVerticalSliderView);
            viewForSliderBar.sliderContainerVewHeight.constant = (bottomConstraintForVerticalSliderView.constant - 40);
        }else
        {
            if (chaptersIndex <= (totalChapters-1)) {
                sliderCompletedValue = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    sliderTottalPages = sliderTottalPages + ((self.view.frame.size.height - bottomConstantsForVerticalSliderView)/totalChapters);
                    bottomConstraintForVerticalSliderView.constant = sliderTottalPages;
                    if (bottomConstraintForVerticalSliderView.constant>40) {
                        viewForSliderBar.sliderContainerVewHeight.constant = (bottomConstraintForVerticalSliderView.constant - 40);
                    }
                });
            }
        }
    }
}

-(void)enableDisableVerticalSlider:(BOOL)enable
{
    isVerticalsliderEnable = enable;
    [self addSliderBarForReflowableBook];
    
    /*Uncomment this code when horizontal slider is enable.And Comment above except "isVerticalsliderEnable = enable;"*/
    /*[viewForSliderBar enableVerticalSlider:isVerticalsliderEnable];
     if (viewForSliderBar) {
     [self updateVerticalSliderViewConstraints];
     }*/
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didUpdateFurthestPage:(NSString *)furthestPageData
{
    NSData *data = [furthestPageData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *furthestPageDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSString *newFurthestPageData = [self getUpdatedFurthestPageData:furthestPageDictionary];
    if (_delegate && [_delegate respondsToSelector:@selector(didUpdateFurthestPageData:ForBookID:ForUserID:)]) {
        [_delegate didUpdateFurthestPageData:newFurthestPageData ForBookID:[_bookID stringValue] ForUserID:[NSNumber numberWithInt:_user.userID.intValue]];
    }
}

-(NSString *)getUpdatedFurthestPageData : (NSDictionary *)furthestPageDictionary
{
    NSMutableDictionary *newFurthestPageDictionary = [[NSMutableDictionary alloc] init];
    [newFurthestPageDictionary addEntriesFromDictionary:furthestPageDictionary];
    [newFurthestPageDictionary setObject:[_bookID stringValue] forKey:@"bookId"];
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:newFurthestPageDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *furthestPageData = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    return furthestPageData;
}

- (void)didChangePageIdentifier:(NSString *)pageOrCFI
{
    if (!readingTimeManager) {
        if([currentBook isKindOfClass:[EPUBBookVO class]])
        {
            EPUBBookVO *book = (EPUBBookVO*)currentBook;
            readingTimeManager = [[ReadingTimeManager alloc] initWithBookPath:book.absolutePath];
        }
    }
    if([readingTimeManager isCFIDataAvailable])
    {
        NSInteger avgTime = DefaultAverageTime;// [_avgTimePerPage integerValue];
        [readingTimeManager setDefaultAverageTimePerPage:DefaultAverageTime];
        NSInteger TimeLeftForBook = [readingTimeManager getTimeLeftForpage:pageOrCFI withAverageTimePerPage:avgTime];
        if (TimeLeftForBook > 60) {
            TimeLeftForBook = TimeLeftForBook/60;
        }
        else if(TimeLeftForBook > 0)
        {
            TimeLeftForBook = 1;
        }
        else
        {
            TimeLeftForBook = 0;
        }
        [_reflowableSliderPageCountView setTimeLeftData:[NSString stringWithFormat:@"%@ %@",[NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:TimeLeftForBook]],NSLocalizedStringFromTableInBundle(@"MIN_LEFT",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",[NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:TimeLeftForBook]],NSLocalizedStringFromTableInBundle(@"MIN_LEFT",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)]);
        [self hideReflowablePageCountView];
        if (_reflowableSliderPopUpView) {
            _reflowableSliderPopUpView.readingTimeLeftLabel.alpha=1;
            _reflowableSliderPopUpView.readingTimeLeftLabel.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@ %@",[NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:TimeLeftForBook]],NSLocalizedStringFromTableInBundle(@"MIN_LEFT",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)],NSLocalizedStringFromTableInBundle(@"MIN_LEFT",READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, nil)];
        }
    }
}

-(NSInteger)getAvgTimePerPageFromAnalyticsEvents
{
    NSInteger totalReadingTime = 0;
    NSMutableSet *set = [NSMutableSet set];
    NSDictionary *analyticsData = [_dbManager getReaderAnalyticsForUser:[NSNumber numberWithInteger:_user.userID.integerValue] WithBookID:[NSNumber numberWithInteger:_bookID.integerValue]];
    for (NSString *trackingJson in [analyticsData allValues])
    {
        NSData *data = [trackingJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        for (NSDictionary *eventDic in [jsonDic valueForKey:@"PageTracking"])
        {
            if([[eventDic valueForKey:@"EventInfo"] valueForKey:@"cfID"])
            {
                NSInteger timeSpendInt = [[[eventDic valueForKey:@"EventInfo"] valueForKey:@"TimeSpend"] integerValue];
                [set addObject:[[eventDic valueForKey:@"EventInfo"] valueForKey:@"cfID"]];
                totalReadingTime += timeSpendInt;
            }
        }
    }
    return totalReadingTime/set.count;
}

-(void)analyticsScheduledTimerTriggered
{
    [self createAndSaveReaderAnalyticsSessionWithCalledUsingTimer:true];
}

-(void)appMovedToBackground:(NSNotification *)notification
{
    [self stopAnalyticsScheduledTimer];
    [self createAndSaveReaderAnalyticsSessionWithCalledUsingTimer:true];
}

-(void)appMovedToForeground:(NSNotification *)notification
{
    for (NSString *key in pagesLoadStartTimeDictionary.allKeys) {
        [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:key];
    }
    for (NSString *key in CFIsLoadStartTimeDictionary.allKeys) {
        [CFIsLoadStartTimeDictionary setObject:[NSDate date] forKey:key];
    }
    [self startAnalyticsScheduledTimer];
}

- (void)startAnalyticsScheduledTimer {
    analyticsScheduledTimer = [NSTimer scheduledTimerWithTimeInterval:AnalyticsScheduledTimerInterval target:self selector:@selector(analyticsScheduledTimerTriggered) userInfo:nil repeats:true];
}

-(void)stopAnalyticsScheduledTimer
{
    if (analyticsScheduledTimer) {
        [analyticsScheduledTimer invalidate];
        analyticsScheduledTimer = nil;
    }
}

-(void)didOpenEpubElementModal
{
    [self moveTopAndBottomOffScreenWithIsAnimate:true WithCompletionHandler:nil];
    disableReflowablePageCountView = YES;
    [self hideReflowablePageCountView];
    if (isVerticalsliderEnable){
        if (@available(iOS 11.0, *)) {
            if (rightConstraintForVerticalSliderView.constant == -(sliderRightAndBottom+self.view.safeAreaInsets.right+15)) {
                    rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom)+self.view.safeAreaInsets.right;
            }
        } else {
            if (rightConstraintForVerticalSliderView.constant == -sliderRightAndBottom+15) {
                rightConstraintForVerticalSliderView.constant = (3*sliderRightAndBottom);
            }
        }
    }
}

-(void)didCloseEpubElementModal
{
    disableReflowablePageCountView = NO;
    [self hideReflowablePageCountView];
}

-(void)didSelectActionToJumpToBookWithBookID:(NSString *)bookID
{
    __block NSString *bookId = bookID;
    NSString *pageId;
    dispatch_async(dispatch_get_main_queue(), ^{
            if([_delegate isBookDownloadedForBookID:bookId])
            {
                [self didTapOnBackButton:nil ];
                [_delegate jumpToBookReaderForBookID:bookId withBookId:pageId];
            }else
            {
                [self showAlertWithTitle:@"" WithMessage:@"The selected book is not downloaded yet.\n Please download it from Bookshelf."];
            }
    });
        
    }

-(NSString *)getFontName
{
    return font_name;
}

-(void)didTapOnClearAllFIBs
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:[LocalizationHelper localizedStringWithKey:@"ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"DO_YOU_WISH_TO_DELETE_ALL_DOODLES" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:[[LocalizationHelper localizedStringWithKey:@"NO_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] uppercaseString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
    }];
    [noAction setValue:UIColor.blackColor forKey:@"titleTextColor"];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:[[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] uppercaseString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        [self clearAllFIBs];
    }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)clearAllFIBs
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if(activeMode!= kPlayerActiveModeTeacherReview)
        {
            NSArray *activePages=[_rendererView getActivePages];
            if([self->currentBook isKindOfClass:[KFBookVO class]]){
                for (KFPageVO *page in activePages){
                    [_dbManager clearAllFIBsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] withDisplayNumber:page.displayNum bookID:_bookID andUserID:[NSNumber numberWithInteger:_user.userID.integerValue] withSubmitted:!_hasClassAssociation];
                    [self drawMarkupsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:_user.userID];
                }
            }
        }
        else{
            NSArray *activePages=[_rendererView getActivePages];
            for (KFPageVO *page in activePages){
                [_teacherAnnotationController clearAllFIBsForPageID:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
                [self drawTeacherReviewFIBOnPageNumber:[NSNumber numberWithInteger:page.pageID]];
                [self drawTeacherReviewDropDownOnPageNumber:[NSNumber numberWithInteger:page.pageID]];
            }
        }
        [self updateClearAllFIBsButtonStatus];
    }
}
-(void)clearAllPageFIBs
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if(activeMode == kPlayerActiveModeTeacherReview)
        {
            [_teacherAnnotationController clearAllFIBs];
            NSArray *activePages=[_rendererView getActivePages];
            for (KFPageVO *page in activePages){
                [self drawTeacherReviewFIBOnPageNumber:[NSNumber numberWithInteger:page.pageID]];
                [self drawTeacherReviewDropDownOnPageNumber:[NSNumber numberWithInteger:page.pageID]];
            }
        }
        [self updateClearAllFIBsButtonStatus];
    }
}
-(void)clearAllPenDrawings
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if(activeMode == kPlayerActiveModeTeacherReview)
        {
            NSArray *activePages=[_rendererView getActivePages];
            for (KFPageVO *page in activePages){
                [_teacherAnnotationController clearAllPenDrawingsForPageID:[NSString stringWithFormat:@"%ld",(long)page.pageID]];
                if (_teacherAnnotationController.isAnnotationEnabled) {
                    [self drawTeacherReviewPenDrawingsOnPageNumber:[NSNumber numberWithInteger:page.pageID]];
                }
            }
        }
        [self updateClearAllFIBsButtonStatus];
    }
}
-(void)clearAllPagePenDrawings
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if(activeMode == kPlayerActiveModeTeacherReview)
        {
            [_teacherAnnotationController clearAllPenDrawings];
            NSArray *activePages=[_rendererView getActivePages];
            for (KFPageVO *page in activePages){
                [self drawTeacherReviewPenDrawingsOnPageNumber:[NSNumber numberWithInteger:page.pageID]];
            }
        }
        [self updateClearAllFIBsButtonStatus];
    }
}
-(void)updateClearAllFIBsButtonStatus
{
    if([currentBook isKindOfClass:[KFBookVO class]])
    {
        if(activeMode != kPlayerActiveModeTeacherReview)
        {
            NSArray *activePages = [_rendererView getActivePages];
            BOOL unSubmittedFIBsAvailable = false;
            for (KFPageVO *pageVO in activePages) {
                unSubmittedFIBsAvailable = [_dbManager isFIBsAvailableOnPageID:[NSString stringWithFormat:@"%ld",(long)pageVO.pageID] withDisplayNumber:pageVO.displayNum bookID:_bookID andUserID:[NSNumber numberWithInteger:_user.userID.integerValue] withSubmitted:!_hasClassAssociation];
                if(unSubmittedFIBsAvailable){
                    break;
                }
            }
            PlayerActionBarItem *clearButtonOfVerticalBar = [self getClearAllFIBsButtonForPlayer:playerActionVerticalBar];
            PlayerActionBarItem *clearButtonOfBottomBar = [self getClearAllFIBsButtonForPlayer:_playerBottomActionBarView];
            if(unSubmittedFIBsAvailable)
            {
                clearButtonOfVerticalBar.enabled = clearButtonOfBottomBar.enabled = true;
                clearButtonOfVerticalBar.alpha = clearButtonOfBottomBar.alpha = 1.0;
            }
            else{
                clearButtonOfVerticalBar.enabled = clearButtonOfBottomBar.enabled = false;
                clearButtonOfVerticalBar.alpha = clearButtonOfBottomBar.alpha = 0.5;
            }
        }
        else
        {
            PlayerActionBarItem *clearAllItem = [self getPenToolItemWithTag:kPenToolBarItemTypeDelete];
            BOOL isFIBsAvailable = false;
            for (KFPageVO *page in [_rendererView getActivePages])
            {
                isFIBsAvailable = [_teacherAnnotationController isFIBsAndPentoolAvailable];
                if(isFIBsAvailable){
                    break;
                }
            }
            if(isFIBsAvailable){
                clearAllItem.enabled = true;
                clearAllItem.alpha = 1.0;
            }
            else{
                clearAllItem.enabled = false;
                clearAllItem.alpha = 0.5;
            }
        }
    }
}
-(PlayerActionBarItem*)getClearAllFIBsButtonForPlayer:(PlayerActionBar*)playerBar
{
    for (PlayerActionBarItem *item in [playerBar getTappableItems])
    {
        if(item.tag == kPlayerActionBarItemTypeClearAllFIBs)
        {
            return item;
        }
    }
    return nil;
}

-(void)changeAudioButtonStatus
{
    if([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        PlayerActionBarItem *soundButtonForAudioSync = [self getAudioButtonForPlayer:_playerBottomActionBarView];
        soundButtonForAudioSync.enabled = false;
        soundButtonForAudioSync.alpha =  0.5;
        NSArray *activePages=[_rendererView getActivePages];
        for (EPUBPage *page in activePages) {
            EPUBChapter *chapter = epubBook.chapters[page.fileIndex];
            if (chapter.isAudioSyncSupported) {
                soundButtonForAudioSync.enabled = true;
                soundButtonForAudioSync.alpha =  1.0;
                break;
            }
        }
    }
}

-(PlayerActionBarItem*)getAudioButtonForPlayer:(PlayerActionBar*)playerBar
{
    for (PlayerActionBarItem *item in [playerBar getTappableItems])
    {
        if(item.tag == kPlayerActionBarItemTypeSound)
        {
            return item;
        }
    }
    return nil;
}

-(PlayerActionBarItem*)getPrintButtonForPlayer:(PlayerActionBar*)playerBar
{
    for (PlayerActionBarItem *item in [playerBar getTappableItems])
    {
        if(item.tag == kPlayerActionBarItemTypePrint)
        {
            return item;
        }
    }
    return nil;
}

#pragma Update Teacher Review UI.

-(NSArray *)getSortedFolioPagesArrayOfStudentSubmitedUgc{
    NSArray *totalPagesArray = [_studentFolioPagesUGCData allKeys];
    if(totalPagesArray.count)
    {
        totalPagesArray = [totalPagesArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSString *firstObject = [obj1 componentsSeparatedByString:@","].firstObject;
            NSString *secondObject = [obj2 componentsSeparatedByString:@","].firstObject;
            return [firstObject compare:secondObject options:NSNumericSearch];
        }];
    }
    NSMutableArray *sortedFolioPages = [[NSMutableArray alloc] init];
    for (NSString *key in totalPagesArray) {
        if ([key containsString:@","]) {
           [sortedFolioPages addObject:[key componentsSeparatedByString:@","].lastObject];
        }else{
            [sortedFolioPages addObject:key];
        }
    }
    return sortedFolioPages;
}

-(void)updateTeacherReviewUI{
    NSArray *displayedPages = [_rendererView getActivePages];
    KFPageVO *firstPage = displayedPages.firstObject;
    KFPageVO *lastPage = displayedPages.lastObject;
    NSString *displayedPagesText;
    if (displayedPages.count > 1) {
        displayedPagesText = [[LocalizationHelper localizedStringWithKey:@"PAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] stringByAppendingFormat:@" %@, %@",firstPage.displayNum, lastPage.displayNum];
    }else{
        displayedPagesText = [[LocalizationHelper localizedStringWithKey:@"PAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] stringByAppendingFormat:@" %@",firstPage.displayNum];
    }
    [self getTeacherViewPlayerActionBarItemLabelWithTag:kPenToolBarItemTypePageNumber].text = displayedPagesText;
    [self enableDisableTeacherReviewControls];
}

-(void)enableDisableTeacherReviewControls{
    NSArray *displayedPages = [_rendererView getActivePages];
    UILabel *label = [self getTeacherViewPlayerActionBarItemLabelWithTag:kPenToolBarItemTypePageNumber];
    NSArray *totalPagesArray = [self getSortedFolioPagesArrayOfStudentSubmitedUgc];
    NSArray *displayedPagesArray = [[label.text stringByReplacingOccurrencesOfString:[LocalizationHelper localizedStringWithKey:@"PAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withString:@""] componentsSeparatedByString:@","];
    NSMutableArray *pagesArray = [[NSMutableArray alloc] init];
    for (NSString *page in displayedPagesArray) {
        for (NSString *newPage in totalPagesArray) {
            if ([[page stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:newPage]) {
                [pagesArray addObject:page];
            }
        }
    }
    NSString *displayNumber = [[NSString stringWithFormat:@"%@",pagesArray.firstObject] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger lastPageIndex = totalPagesArray.count-1;
    NSString *secondLastPage;
    if (lastPageIndex>0) {
        secondLastPage = [totalPagesArray objectAtIndex:(lastPageIndex-1)];
    }
    [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=1.0;
    [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = YES;
    [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].alpha=1.0;
    [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].userInteractionEnabled = YES;
    
    if (totalPagesArray.count == 1 || totalPagesArray.count == pagesArray.count) {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].userInteractionEnabled = NO;
    }else if([displayNumber isEqualToString:totalPagesArray.firstObject])
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypePrevPage].userInteractionEnabled = NO;
    }if([displayNumber isEqualToString:totalPagesArray.lastObject] || (displayedPages.count > 1 && [displayNumber isEqualToString:secondLastPage]))
    {
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].alpha=0.5;
        [self getPenToolItemWithTag:kPenToolBarItemTypeNextPage].userInteractionEnabled = NO;
    }
}

-(BOOL)isLoadedPageContainsUGC {
    NSArray *totalPagesArray = [self getSortedFolioPagesArrayOfStudentSubmitedUgc];
    NSArray *activePages = [self getActivePageIDs];
    if(activePages.count == 1) {
        if(![totalPagesArray containsObject:[activePages firstObject]]) {
            return NO;
        }
    }
    return YES;
}

-(NSString *)getNextPageNumberToNavigateWithUGC{
    NSArray *totalFolioPages = [self getSortedFolioPagesArrayOfStudentSubmitedUgc];
    NSArray *displayedFolioPagesArray = [[[self getTeacherViewPlayerActionBarItemLabelWithTag:kPenToolBarItemTypePageNumber].text stringByReplacingOccurrencesOfString:[LocalizationHelper localizedStringWithKey:@"PAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] withString:@""] componentsSeparatedByString:@","];
    NSMutableArray *folioPagesArray = [[NSMutableArray alloc] init];
    for (NSString *page in displayedFolioPagesArray) {
        for (NSString *newPage in totalFolioPages) {
            if ([[page stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:newPage]) {
                [folioPagesArray addObject:page];
            }
        }
    }
    NSString *displayFolioNumber = [[NSString stringWithFormat:@"%@",folioPagesArray.firstObject] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *totalPagesArray = [self getSortedPageArrayOfStudentSubmitedUgc];
    return [totalPagesArray objectAtIndex:[totalFolioPages indexOfObject:displayFolioNumber]];
}

-(void)updateUGCForBook:(NSString *)bookID {
    NSArray *activePages=[_rendererView getActivePages];
    if([currentBook isKindOfClass:[KFBookVO class]]) {
        KFBookVO *book = (KFBookVO*)currentBook;
        if (bookID.integerValue == book.bookID) {
            for (KFPageVO *page in activePages) {
                [self updateUGCsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.pageID] OnDisplayNumber:page.displayNum];
            }
        }
    }else {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        if (bookID.integerValue == epubBook.bookID) {
            for (EPUBPage *page in activePages) {
                [self updateUGCsOnPageNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex] OnDisplayNumber:[NSString stringWithFormat:@"%ld",(long)page.fileIndex]];
            }
        }
    }
}

-(void)updateUGCsOnPageNumber:(NSString*)number OnDisplayNumber:(NSString*)displayNum {
    NSMutableArray *UGCs=[[NSMutableArray alloc] init];
    if([currentBook isKindOfClass:[KFBookVO class]]) {
        NSArray* protractorDrawings=[_dbManager protractorDrawingForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        NSArray* pentoolDrawings = [_dbManager pentoolDrawingForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        NSArray* textAnnotations = [_dbManager textAnnotationVOForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        [UGCs addObjectsFromArray:protractorDrawings];
        [UGCs addObjectsFromArray:pentoolDrawings];
        [UGCs addObjectsFromArray:textAnnotations];
    }else {
       EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
       if (epubBook.meta.layout != ePUBReflowable) {
           NSArray* pentoolDrawings = [_dbManager pentoolDrawingForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
           [UGCs addObjectsFromArray:pentoolDrawings];
       }
    }
    
    NSArray* highlights=[_dbManager highlightForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    NSArray* bookmarks = [_dbManager bookmarkForPageID:number ForDisplayNumber:displayNum bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    [UGCs addObjectsFromArray:highlights];
    [UGCs addObjectsFromArray:bookmarks];
    [_rendererView updateUGC:UGCs OnPageNo:[number integerValue]];
}

-(void)initializeReaderSeatingID
{
    readerSeatingID = [[NSUUID UUID] UUIDString];
}

- (void)navigateToPageNumber:(NSString *)pageNo
{
    if ([currentBook isKindOfClass:[KFBookVO class]]){
        NSInteger pageID = [self getPageIDForDisplayNumber:pageNo];
        [_rendererView navigateToPageNumber:[NSString stringWithFormat:@"%ld",(long)pageID]];
    }
    else{
        NSData * data = [pageNo dataUsingEncoding:NSUTF8StringEncoding];
        if(data)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                EPUBBookVO *epubBookVO = (EPUBBookVO *)currentBook;
                if ([json objectForKey:@"chapterid"]) {
                    NSInteger index = [[json valueForKey:@"chapterid"] integerValue];
                    EPUBChapter *chapterVO = epubBookVO.chapters[index];
                    [_rendererView navigateToPageNumber:chapterVO.href];
                    if ([json objectForKey:@"positionIdentifier"])
                    {
                        NSString *lastPageCFIString = [json valueForKey:@"positionIdentifier"];
                        [_rendererView jumpToCFIString:lastPageCFIString];
                        _lastPageFolio = nil;
                    }
                }
            });
        }
    }
}
-(void)initializeLocalizationBundle
{
    if(LocalizationHelper.readerLanguageBundle == nil)
    {
        LocalizationHelper.readerLanguageBundle = [NSBundle bundleForClass:[ReaderViewController self]];
    }
}

-(void)uninitializeReader{
    [self clearObjects];
}

-(void)didClickOnNextButtonForReaderSearch {
    [self enablePreviousButtonForElasticSearch:YES];
    TextSearchResult *nextSearchResult = [searchTextViewForIpad getNextSearchResult:_searchResult];
    if ([_rendererView isNextSearchResultAvailableForSearchResult:_searchResult]) {
        [_rendererView moveToNextSelectedSearchForSearchResult:_searchResult];
        if (_searchResult.pageIndex == nextSearchResult.pageIndex) {
            _searchResult = nextSearchResult;
        }
    }else{
        if (nextSearchResult) {
            _searchResult = nextSearchResult;
            if([currentBook isKindOfClass:[KFBookVO class]]) {
                [_rendererView navigateToPageNumber:_searchResult.pageIndex];
            }else{
                [_rendererView navigateToPageNumber:_searchResult.href];
            }
        }else{
            [self enableNextButtonForElasticSearch:NO];
        }
    }
}

- (void)didClickOnPreviousButtonForReaderSearch {
    [self enableNextButtonForElasticSearch:YES];
    TextSearchResult *previousSearchResult = [searchTextViewForIpad getPreviousSearchResult:_searchResult];
    if ([_rendererView isPreviousSearchResultAvailableForSearchResult:_searchResult]) {
        [_rendererView moveToPreviousSelectedSearchForSearchResult:_searchResult];
        if (_searchResult.pageIndex == previousSearchResult.pageIndex) {
            _searchResult = previousSearchResult;
        }
    }else{
        if (previousSearchResult) {
            _searchResult = previousSearchResult;
            if([currentBook isKindOfClass:[KFBookVO class]]) {
                [_rendererView navigateToPageNumber:_searchResult.pageIndex];
            }else{
                [_rendererView navigateToPageNumber:_searchResult.href];
            }
        }else{
            [self enablePreviousButtonForElasticSearch:NO];
        }
    }
}

-(NSMutableArray *)getAllNextSearchedResults{
    NSArray *array = [_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)];
    NSMutableArray *nextArray = [[NSMutableArray alloc] init];
    for (TextSearchResult *newResult in array) {
        if([currentBook isKindOfClass:[KFBookVO class]]) {
            if (newResult.pageIndex.integerValue > _searchResult.pageIndex.integerValue) {
                [nextArray addObject:newResult];
                break;
            }
        }else{
            if ([self getFileIndexForHREF:newResult.href].integerValue > [self getFileIndexForHREF:_searchResult.href].integerValue) {
                [nextArray addObject:newResult];
                break;
            }
        }
    }
    return nextArray;
}

-(NSMutableArray *)getAllPreviousSearchedResults{
    NSArray *array = [_searchController getSearchResultForText:_searchResult.searchedWord withPageNo:_searchResult.pageIndex withFont:getCustomFont(isIpad()?18:14)];
    NSMutableArray *preArray = [[NSMutableArray alloc] init];
    for (int i = ((int)(array.count-1)); i>=0; i--) {
        TextSearchResult *newResult = array[i];
        if([currentBook isKindOfClass:[KFBookVO class]]) {
            if (newResult.pageIndex.integerValue < _searchResult.pageIndex.integerValue) {
                [preArray addObject:newResult];
                break;
            }
        }else{
            if ([[self getFileIndexForHREF:newResult.href] integerValue] < [[self getFileIndexForHREF:_searchResult.href] integerValue]) {
                [preArray addObject:newResult];
                break;
            }
        }
    }
    return preArray;
}

-(void)enableFurthestPage:(BOOL)isEnable
{
    [_rendererView enableFurthestPage:isEnable];
}

-(void)setFurthestPageData:(NSString *)furthestPageData
{
    [_rendererView setFurthestPageData:furthestPageData];
}

- (void)disableShareSettings:(BOOL)disable
{
    isShareSettingsDisabled = disable;
}

- (void)disableNoteNotification:(BOOL)disable
{
    isNoteNotificationDisabled = disable;
}

- (void)disableTwoPageSeperationLine:(BOOL)disable
{
    isTwoPageSeperationDisabled = disable;
}

#pragma mark KBFixedEpubThumbnailViewController Methods
- (void)didClickHistoryNextForFixedEpub
{
    if(currentHistoryPageIndex < [_navigationHistoryPagesArray count])
    {
        int navigateIndex = [self getNextPageNavigateIndex];
        isPageNavigateByScroll = NO;
        NSString *page = [NSString stringWithFormat:@"%@",_navigationHistoryPagesArray[navigateIndex]];
        [_rendererView navigateToPageNumber:page];
        [self removeFixedEpubThumbnail];
    }
}

- (void)didClickHistoryPreviousForFixedEpub
{
    if(currentHistoryPageIndex>0)
    {
        isPageNavigateByScroll = NO;
        int navigateIndex = [self getPrevPageNavigateIndex];
        NSString *page = [NSString stringWithFormat:@"%@",_navigationHistoryPagesArray[navigateIndex]];
        [_rendererView navigateToPageNumber:page];
        [self resetHistoryPageIndex];
        [self removeFixedEpubThumbnail];
    }
}

- (void)didPerformActionToCloseThumbnail
{
    [self removeFixedEpubThumbnail];
}

-(void)navigateToPageNo:(NSString *)pageNo
{
    [self addPageIntoPageHistoryArray:pageNo];
    isPageNavigateByScroll = NO;
    
    [self removeFixedEpubThumbnail];
    [_rendererView navigateToPageNumber:pageNo];
}

- (void)actionForFixedEpubThumbnail
{
    activeMode=kPlayerActiveModeThumbnail;
    fixedEpubThumbnailVC = [[KBFixedEpubThumbnailViewController alloc] initWithData:[currentBook getThumbnailData] withTheme:hdThemeVO];
    fixedEpubThumbnailVC.delegate = self;
    
    NSArray *activePages=[_rendererView getActivePages];
    EPUBPage *page1 = [activePages objectAtIndex:0];
    EPUBChapter *chapter1 = [self getEpubChapterForIndex:page1.fileIndex];
    EPUBTOCPage *tocPage = [self getEpubTOCPageFromHref:chapter1.href];
    if(activePages.count)
    {
        [fixedEpubThumbnailVC setActivePageNumber:(int)chapter1.fileIndex];
        [fixedEpubThumbnailVC setActiveDisplayNumber:tocPage.displayNumber];
    }
    [fixedEpubThumbnailVC setTotalNumberOfPages:(int)[self getTotalPagesArray].count];
    [self moveTopAndBottomOffScreenWithIsAnimate:YES WithCompletionHandler:nil];
    [self enableHistoryButtonsForFixedEpubThumbnail];
    
    if (isIpad())
    {
        fixedEpubThumbnailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:fixedEpubThumbnailVC animated:YES completion:nil];
        
    }
    else
    {
        fixedEpubThumbnailVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:fixedEpubThumbnailVC animated:YES completion:nil];
    }
    
}

-(void)removeFixedEpubThumbnail
{
    activeMode=kPlayerActiveModeNone;
    [fixedEpubThumbnailVC dismissViewControllerAnimated:YES completion:nil];
    [self resetAllPlayerActionBar];
    fixedEpubThumbnailVC = nil;
}

-(void)enableHistoryButtonsForFixedEpubThumbnail
{
    int totalPagesInArray = (int)[_navigationHistoryPagesArray count];
    if(totalPagesInArray == 1)
    {
        [fixedEpubThumbnailVC enablePreviousPageHistory:NO];
        [fixedEpubThumbnailVC enableNextPageHistory:NO];
    }
    else if (totalPagesInArray == currentHistoryPageIndex+1)
    {
        [fixedEpubThumbnailVC enablePreviousPageHistory:YES];
        [fixedEpubThumbnailVC enableNextPageHistory:NO];
    }
    else if (currentHistoryPageIndex == 0 && totalPagesInArray>1)
    {
        [fixedEpubThumbnailVC enablePreviousPageHistory:NO];
        [fixedEpubThumbnailVC enableNextPageHistory:YES];
    }
    else
    {
        [fixedEpubThumbnailVC enablePreviousPageHistory:YES];
        [fixedEpubThumbnailVC enableNextPageHistory:YES];
    }
}

- (EPUBTOCPage *)getEpubTOCPageFromHref:(NSString *)href
{
    EPUBBookVO *bookVO = (EPUBBookVO *)currentBook;
    for (EPUBTOCPage *tocPage in bookVO.tocPageList)
    {
        if ([tocPage.src isEqualToString:href])
        {
            return tocPage;
        }
    }
    return nil;
}


#pragma mark Generate Report Methods
- (void)didTapOnGenerateReportButton
{
    if([[KitabooNetworkManager getInstance] isInternetAvailable])
    {
        [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeGenerateReport].userInteractionEnabled = NO;
        [_teacherAnnotationController startActivityIndicator];
        KitabooServiceInterface *kitabooServiveInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:MICRO_SERVICE_BASE_URL clientID:_clientID];
        [kitabooServiveInterface fetchBookTOC:_user.userToken bookId:[NSString stringWithFormat:@"%@",_bookID] successHandler:^(NSDictionary *respDict)
         {
            [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeGenerateReport].userInteractionEnabled = YES;
            GenerateReportParser *parser = [[GenerateReportParser alloc] init];
            KFBookVO *bookVO = (KFBookVO *)currentBook;
            NSArray *generateReportTOC = [parser parseGenerateReportTOC:respDict :bookVO];
            [self addGenerateReportViewController:generateReportTOC];
            [_teacherAnnotationController stopActivityIndicator];
        } failureHandler:^(NSError *error)
         {
            [self getActionBarItemItemWithTag:kPlayerActionBarItemTypeGenerateReport].userInteractionEnabled = YES;
            [_teacherAnnotationController stopActivityIndicator];
            if ([error code] == 401)
            {
                if ([_userSettingsModel isAutoLoginEnabled])
                {
                    if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                        [_delegate refreshUserTokenForUser:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                            _user = renewedUser;
                            [self didTapOnGenerateReportButton];
                        }];
                    }
                    
                }
                else{
                    [self showSessionExpireForGenerateReport];
                }
            }else{
                [self serviceFailureMessageForGenerateReportWithError:error];
            }
        }];
    }
    else{
        [self showNoInternetMessageForGenerateReport];
    }
}

- (void)addGenerateReportViewController:(NSArray *)tocArray
{
    generateReportVC = [[GenerateReportViewController alloc] initWithThemeColor:hdThemeVO.top_toolbar_icons_color];
    generateReportVC.delegate = self;
    [generateReportVC setData:tocArray];
    if (isIpad())
    {
        generateReportVC.modalPresentationStyle = UIModalPresentationPopover;
        generateReportPopoverpresentationController = [generateReportVC popoverPresentationController];
        generateReportPopoverpresentationController.permittedArrowDirections = 0;
        generateReportPopoverpresentationController.delegate = self;
        generateReportPopoverpresentationController.sourceView = self.view;
        generateReportPopoverpresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
        generateReportPopoverpresentationController.presentedViewController.preferredContentSize = CGSizeMake(550, 650);
        [self presentViewController:generateReportVC animated:YES completion:nil];
    }
    else
    {
        generateReportVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:generateReportVC animated:YES completion:nil];
    }
}

- (NSDictionary *)getStatusDictionaryForClasses:(NSArray *)classes withStudents:(NSArray *)learners
{
    NSMutableDictionary *status = [[NSMutableDictionary alloc] init];
    for(NSString *title in classes)
    {
        for (NSDictionary *learnerDict in learners)
        {
            NSString *studentID = [NSString stringWithFormat:@"%@",[[learnerDict valueForKey:@"user"] valueForKey:@"id"]];
            //[_teacherAnnotationController.classSubmittedData[title] valueForKey:studentID];
            if ([_teacherAnnotationController.studentDataDict valueForKey:studentID]) {
                NSString *statusType = @"1";// [NSString stringWithFormat:@"%@",[[_teacherAnnotationController.studentDataDict valueForKey:studentID] valueForKey:@"status"]];
                if ([[_teacherAnnotationController.studentDataDict valueForKey:studentID] valueForKey:@"pageUgc"]) {
                    NSDictionary *pageUGC = [[_teacherAnnotationController.studentDataDict valueForKey:studentID] valueForKey:@"pageUgc"];
                    if ([pageUGC count] > 0)
                    {
                        [status setObject:statusType forKey:studentID];
                    }
                }
            }
            
        }
    }
    return status;
}


- (void)didTapOnCancelForGenerateReport
{
    [self removeGenerateReportVC];
}

- (void)didTapOnBackForGenerateReport
{
    [self removeGenerateReportVC];
}

- (void)didTapOnNextToSendMailWithReportData:(NSDictionary<NSString *,id> *)reportData
{
    generateReportData = reportData;
    [self removeGenerateReportVC];
    if([[KitabooNetworkManager getInstance] isInternetAvailable])
    {
        mailVC = [[GenerateReportMailViewController alloc] init:_user.email];
        mailVC.delegate = self;
        [self presentViewController:mailVC animated:NO completion:nil];
    }
    else{
        [self showNoInternetMessageForGenerateReport];
    }
}

- (void)didSelectChapterSegmentForGenerateReport
{
    
}

- (void)didSelectStudentSegmentForGenerateReport
{
    NSArray *classesInfoArray = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    NSMutableArray *learners = [[NSMutableArray alloc] init];
    NSMutableArray *teacherTitles = [[NSMutableArray alloc] init];
    for(SDKBookClassInfoVO *classInfoVO in classesInfoArray)
    {
        [teacherTitles addObject:classInfoVO.classTitle];
        if ([classInfoVO.classTitle isEqualToString:_teacherAnnotationController.selectedClassName]) {
            for (NSDictionary *dictionary in classInfoVO.learners) {
                [learners addObject:dictionary];
            }
        }
    }
    
    NSMutableSet *keys = [NSMutableSet new];
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *data in learners) {
        NSString *key = [[data valueForKey:@"user"] valueForKey:@"id"];
        if ([keys containsObject:key]){
            continue;
        }
        [keys addObject:key];
        [result addObject:data];
    }
    NSDictionary *statusDict = [self getStatusDictionaryForClasses:teacherTitles withStudents:result];
    
    [generateReportVC setData:result];
    [generateReportVC setStatusData:statusDict];
}

- (void)removeGenerateReportVC
{
    [generateReportVC dismissViewControllerAnimated:NO completion:nil];
    generateReportVC = nil;
}

- (void)didTapOnDoneForGenerateReportMail:(NSString *)alternateEmail
{
    [mailVC dismissViewControllerAnimated:NO completion:nil];
    mailVC = nil;
    if([[KitabooNetworkManager getInstance] isInternetAvailable])
    {
        KitabooServiceInterface *kitabooServiveInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:MICRO_SERVICE_BASE_URL clientID:_clientID];
        [kitabooServiveInterface fetchStudentMarkupReport:_user.userToken bookId:[NSString stringWithFormat:@"%@",_bookID] classId:[self getClassIDFromCurrentClass:_teacherAnnotationController.selectedClassName] chapters:[generateReportData valueForKey:@"chapterID"] emailID:alternateEmail userIds:[generateReportData valueForKey:@"studentID"] successHandler:^(NSDictionary *respDict) {
            [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"GENERATE_REPORT_MAIL_SUCCESS_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"GENERATE_REPORT_MAIL_SUCCESS_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
            }];
            
        } failureHandler:^(NSError *error) {
            
            if ([error code] == 401)
            {
                if ([_userSettingsModel isAutoLoginEnabled])
                {
                    if ([_delegate respondsToSelector:@selector(refreshUserTokenForUser:withExpiredToken:completed:)]) {
                        [_delegate refreshUserTokenForUser:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                            _user = renewedUser;
                            [self didTapOnDoneForGenerateReportMail:alternateEmail];
                        }];
                    }
                    
                }
                else{
                    [self showSessionExpireForGenerateReport];
                }
            }
            else{
                [self serviceFailureMessageForGenerateReportWithError:error];
            }
        }];
    }
    else{
        [self showNoInternetMessageForGenerateReport];
    }
}

- (void)didTapOnCancelForGenerateReportMail
{
    [mailVC dismissViewControllerAnimated:NO completion:nil];
    mailVC = nil;
}

- (void)showSessionExpireForGenerateReport
{
    [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"YOUR_SESSION_HAS_EXPIRED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"PLEASE_SIGN_IN_AGAIN" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        [self closeReaderForSessionExpiry];
        _teacherAnnotationController = nil;
    }];
}

- (void)showNoInternetMessageForGenerateReport
{
    [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"FAILED_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
    }];
}

- (void)serviceFailureMessageForGenerateReportWithError:(NSError *)error
{
    NSString *responseMsg = [error.userInfo valueForKey:@"responseMsg"];
    if ([responseMsg containsString:@"The specified key does not exist."]) {
        [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"GENERATE_REPORT_NO_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];

    }else{
        [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] message:[LocalizationHelper localizedStringWithKey:@"SOMETHING_WENT_WRONG" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForReaderViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
}

- (NSString *)getClassIDFromCurrentClass:(NSString *)className
{
    NSArray *classesInfoArray = [_dbManager bookClassInfoArrayForBookID:_bookID forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    for(SDKBookClassInfoVO *classInfoVO in classesInfoArray)
    {
        if ([classInfoVO.classTitle isEqualToString:className])
        {
            return [NSString stringWithFormat:@"%@",classInfoVO.classId];
        }
    }
    return @"";
}

-(BOOL)isDefaultKeyboardDisabled:(HDFIB *)_fib {
    if (_isFIBLevelKeyboardEnabled && ([_userSettingsModel isMathEditorEnabled]) && (_fib.linkVo.isMathKeyboardEnabled)) {
        return YES;
    }
    return NO;
}

-(BOOL)isMathKeyboardEnabled:(HDFIB *)_fib {
    if (_isFIBLevelKeyboardEnabled) {
        if (([_userSettingsModel isMathEditorEnabled]) && (_fib.linkVo.isMathKeyboardEnabled)) {
            return YES;
        }
    }else {
        if ([_userSettingsModel isMathEditorEnabled]) {
            return YES;
        }
    }
    return NO;
}

-(void)setColorToMathKeyboard:(FIBMathEquationView *)fibMathEquationView withFIBVO:(SDKFIBVO*)fibVO withFIB:(HDFIB *)_fib {
    if(fibVO.isSubmitted && _fib.linkVo.isInstantFeedback) {
        if (![self isAnswerCorrect:_fib.linkVo andUserEnteredText:fibVO.text]) {
            [fibMathEquationView setThemeColor:UIColor.redColor];
        }else{
            [fibMathEquationView setThemeColor:UIColor.greenColor];
        }
    }else if(fibVO.isSubmitted && !_fib.linkVo.isInstantFeedback) {
        [fibMathEquationView setThemeColor:UIColor.grayColor];
    }else {
        [fibMathEquationView setThemeColor:hdThemeVO.share_icon_color];
    }
}

-(void)showMathKeyboardForFIB:(HDFIB *)hdFIBVO {
    if (hdFIBVO.isDefaultKeyboardDisabled && [self isMathKeyboardEnabled:hdFIBVO]) {
        KFLinkVO *link = hdFIBVO.linkVo;
        if(activeMode==kPlayerActiveModeTeacherReview) {
            [self showEquationEditorKeyboardForLink:link withFIBVO:[_teacherAnnotationController getSDKFIBVOForLinkID:link.linkID]];
        }else{
            [self showEquationEditorKeyboardForLink:link withFIBVO:[_dbManager getEquationFIBObjectForText:@"" WithLink:link forUserId:[NSNumber numberWithInteger:_user.userID.integerValue]]];
        }
    }
}

-(NSInteger)getSliderCFIValueForChapter:(EPUBChapter *)chapter {
    if([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"href = %@", chapter.href];
        NSArray *filteredArray = [epubBook.bookCFIs filteredArrayUsingPredicate:bPredicate];
        if (filteredArray.count > 0 ) {
            EPUBChapterCFI *cfi = filteredArray[0];
            if (cfi.chapterCFIArray.count > 0) {
                NSInteger sliderValue = [epubBook.bookCFIArray indexOfObject:cfi.chapterCFIArray[0]];
                return  sliderValue;
            }
        }
    }
    return 0;
}

-(EPUBChapter *)getChapterForSliderCFIValue:(float)sliderValue {
    if([currentBook isKindOfClass:[EPUBBookVO class]]) {
        EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
        EPUBChapterCFI *cfi;
        NSInteger cfiCount = 0;
        NSString *href;
        for (cfi in epubBook.bookCFIs) {
            cfiCount += cfi.chapterCFIArray.count;
            if (cfiCount >= (int)sliderValue) {
                href = cfi.href;
                break;
            }
        }
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"href = %@", href];
        NSArray *filteredArray = [epubBook.chapters filteredArrayUsingPredicate:bPredicate];
        EPUBChapter *chapter = filteredArray[0];
        return chapter;
    }
    return nil;
}

- (void)rendererViewController:(RendererViewController *)rendererViewController didChangeBookCFI:(NSString *)bookCFI WithPositionIdentifier:(NSString *)positionIdentifier WithPageNumber:(NSNumber *)pageNumber {
    if (sliderCompletedValue) {
        if([currentBook isKindOfClass:[EPUBBookVO class]]) {
            EPUBBookVO *epubBook=(EPUBBookVO*)currentBook;
            if (!epubBook.isBookContentLoaded) {
                NSInteger currentSliderValue = [epubBook.bookCFIArray indexOfObject:bookCFI];
                [viewForSliderBar.pageSlider setValue:currentSliderValue+1 animated:NO];
                [viewForSliderBar updatePercentage];
            }
        }
    }
}

#pragma KBMyDataPrintOptionsControllerDelegate Implementation

- (void)configPrintOptionController:(KBMyDataPrintOptionsController *)controller {
    NSArray *myDataArray = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    
    NSArray *notesArray = [myDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText != nil AND self.noteText != '')", DELETE]];
    notesArray = [notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReceived = 0 OR (isReceived = 1 AND isAnswered = 1)"]];
    if (notesArray && notesArray.count == 0) {
        controller.hiddenPrintType = PrintTypeNotes;
    }
    NSArray *highlightsArray = [myDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText = nil OR self.noteText.length = 0)", DELETE]];
    highlightsArray = [highlightsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAnswered = 1"]];
    if (highlightsArray && highlightsArray.count == 0) {
        controller.hiddenPrintType = PrintTypeHighlights;
    }
    
}

- (void)didTapOnPrintTypeWithPrintType:(PrintType)printType {
    NSArray *myDataArray = [_dbManager highlightBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    NSString *printTitle = @"";
    
    switch (printType) {
        case PrintTypeNotes: {
            NSArray *notesArray = [myDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText != nil AND self.noteText != '')", DELETE]];
            myDataArray = [notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReceived = 0 OR (isReceived = 1 AND isAnswered = 1)"]];
            printTitle = NSLocalizedStringFromTableInBundle(@"NOTES_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, "");
        }
            break;
        case PrintTypeHighlights: {
            NSArray *highlightsArray = [myDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText = nil OR self.noteText.length = 0)", DELETE]];
            myDataArray = [highlightsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAnswered = 1"]];
            printTitle = NSLocalizedStringFromTableInBundle(@"HIGHLIGHTS_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, "");
        }
            break;
        case PrintTypeBoth: {
            NSArray *highlightsArray = [myDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText = nil OR self.noteText.length = 0)", DELETE]];
            highlightsArray = [highlightsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAnswered = 1"]];
            NSArray *notesArray = [myDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText != nil AND self.noteText != '')", DELETE]];
            notesArray = [notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReceived = 0 OR (isReceived = 1 AND isAnswered = 1)"]];
            myDataArray = [highlightsArray arrayByAddingObjectsFromArray:notesArray];
            printTitle = NSLocalizedStringFromTableInBundle(@"BOTH_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForReaderViewController, "");
        }
            break;
        default:
            break;
    }
    
    HDPDFCreator *pdf = [[HDPDFCreator alloc] initWithHighlights:myDataArray];
    __weak typeof(self) weakSelf = self;
    [pdf createPDFWithCompletion:^(NSData *data){
        [weakSelf showPrintWith:data andTitle:printTitle];
    }];
}

- (void)showPrintWith:(NSData *)data andTitle:(NSString *)title {
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName = title;
    
    pc.printInfo = printInfo;
    pc.printingItem = data;

    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Print failed - domain: %@ error code %ld", error.domain, (long)error.code);
        }
    };

    [pc presentAnimated:YES completionHandler:completionHandler];
}

-(void)didUGCDataSuccessfullyParsed
{
    [self relaodPageUGCForActivePages];
}

@end

