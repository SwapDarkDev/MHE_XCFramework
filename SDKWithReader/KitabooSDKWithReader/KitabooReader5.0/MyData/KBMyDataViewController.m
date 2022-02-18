//
//  MyDataViewController.m
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import "KBMyDataViewController.h"
#import "UIButton-Expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "HSUIColor-Expanded.h"
#import "KBMyDataNoteCell.h"
#import "KBMyDataNoteAnswerCell.h"
#import "KBMyDataHighlightCell.h"
#import "FilterViewController.h"
#define DefaultHeaderHeight 50
#define DisableGrayColor [UIColor lightGrayColor]
#define MyDataTitle [LocalizationHelper localizedStringWithKey:@"HELP_MY_DATA_BUTTON_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define HighlightTitle [LocalizationHelper localizedStringWithKey:@"HIGHLIGHTS_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define NoteTitle [LocalizationHelper localizedStringWithKey:@"NOTES_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define NotificationTitle [LocalizationHelper localizedStringWithKey:@"My_Data:_Notification" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define EmptyNoteTitle [LocalizationHelper localizedStringWithKey:@"Notes_added/shared_with_will_appear_color_coded_on_the_basis_of_recently_create/shared" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define EmptyFilterNoteTitle [LocalizationHelper localizedStringWithKey:@"NO_NOTES_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define EmptyFilterHighlightTitle [LocalizationHelper localizedStringWithKey:@"NO_HIGHLIGHTS_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define EmptyHighlighttitle [LocalizationHelper localizedStringWithKey:@"Highlight_text_to_add_a_note_or_mark them_as_important" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]
#define LocalizationBundleForKBMyDataViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

typedef enum: NSInteger{
    
    MY_DATA = 0,
    SHARED_WITH_ME = 1
    
} MyDataFilter;


@interface KBMyDataViewController () <UITableViewDelegate, UITableViewDataSource,MyDataNoteAnswerCellDelegate,MyDataNoteCellDelegate,UIGestureRecognizerDelegate> {
    __weak IBOutlet UIView *noDataContainerView;
    __weak IBOutlet UIButton *_backButtonIcon;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_noDataLabel;
    __weak IBOutlet UILabel *_filterIcon;
    __weak IBOutlet UILabel *noDataIconLbl;
    __weak IBOutlet UIView *borderViewOfBtnContainer;
    __weak IBOutlet UILabel *upIcon;
    __weak IBOutlet UIButton *acceptButton;
    __weak IBOutlet UIButton *declineButton;
    __weak IBOutlet NSLayoutConstraint *heightConstraintNotificationTopView;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfSegmentView;
    __weak IBOutlet NSLayoutConstraint *headerHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *topConstraintOfViewContainingPanGesture;
    __weak IBOutlet NSLayoutConstraint *tocLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *tocRightConstraint;
    __weak IBOutlet NSLayoutConstraint *notificationBtnLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *highlightCountLabelCenterXConstraint;
    __weak IBOutlet NSLayoutConstraint *notesCountLabelCenterXConstraint;
    
    CGFloat previousStateYPosition;
    BOOL _isSharingEnabled;
    NSInteger _selectedHighlightIndex;
    NSArray *_dataArray;
    NSArray *_myNoteArray;
    NSArray *_ugcArray;
    NSArray *highlightFilterColorsArray,*contexualFilterColorsArray,*notesFilterColorsArray;
    BOOL isSharedHighlightSelected,isSharedNotesSelected,isSharedContextualNotes,notesWithFilter,highlightWithFilter;
    MyDataFilter _myDataFilter;
    UIColor *themeColor;

    FilterViewController *filterViewController;
    NSString *backButtonTextTitle;
    
    BOOL isShareSettingsIconDisable;
    BOOL isNoteNotificationDisable;
    __weak IBOutlet NSLayoutConstraint *filterButtonWidthConstraint;
    NSLayoutConstraint *_selectedBtnLeadingConstraintForRTL;
}


@end

@implementation KBMyDataViewController

#pragma mark View life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 20.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    themeColor = [UIColor colorWithHexString:@"#105D85"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myDataContainerView.backgroundColor = [UIColor whiteColor];
    notesWithFilter = NO;
    highlightWithFilter = NO;
    contexualFilterColorsArray = _themeVO.highlight_Color_Array;
    notesFilterColorsArray = _themeVO.highlight_Color_Array;
    highlightFilterColorsArray = _themeVO.highlight_Color_Array;
    isSharedHighlightSelected = YES;
    isSharedNotesSelected = YES;
    isSharedContextualNotes = YES;
    [_highlightButton setTitle:NSLocalizedStringFromTableInBundle(@"HIGHLIGHTS_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForKBMyDataViewController, "") forState:UIControlStateNormal];
    [_notesButton setTitle:NSLocalizedStringFromTableInBundle(@"NOTES_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForKBMyDataViewController, "") forState:UIControlStateNormal];
    [self updateView];
    [self updateSelectedSegmentView];
    [self unableNotificationSetup:NO];
    [self inilializeFilterViewController];
    [self setupUIWithThemeColor];
    [self setAccessibilityForMyData];
    if(isIpad())
      [self setupForIpad];
}

-(void)setupUIWithThemeColor{
    _myDataContainerView.backgroundColor = _themeVO.mydata_popup_background;
    _myDataContainerView.layer.borderColor = _themeVO.mydata_popup_border.CGColor;
    _segmentView.backgroundColor = _themeVO.mydata_tab_bg;
    borderViewOfBtnContainer.backgroundColor = _themeVO.mydata_tab_border;
    _selectedButonBorderView.backgroundColor = _themeVO.mydata_selected_tab_border;
    [_highlightButton setTitleColor:_themeVO.mydata_tab_text_color forState:UIControlStateNormal];
    [_highlightButton setTitleColor:_themeVO.mydata_selected_text_color forState:UIControlStateSelected];
    [_notesButton setTitleColor:_themeVO.mydata_tab_text_color forState:UIControlStateNormal];
    [_notesButton setTitleColor:_themeVO.mydata_selected_text_color forState:UIControlStateSelected];
    [_filterButton setTitleColor:[_themeVO.mydata_disabled_tabs_icon_color colorWithAlphaComponent:_themeVO.mydata_disabled_icon_opacity] forState:UIControlStateDisabled];
    [_filterButton setTitleColor:_themeVO.mydata_tabs_icon_color forState:UIControlStateNormal];
    _notificationIcon.backgroundColor = _themeVO.mydata_notification_circle_color;
    [_notificationButton setTitleColor:_themeVO.mydata_tabs_icon_color forState:UIControlStateNormal];
    [_notificationButton setTitleColor:[_themeVO.mydata_disabled_tabs_icon_color colorWithAlphaComponent:_themeVO.mydata_disabled_icon_opacity] forState:UIControlStateDisabled];
    [_printButton setTitleColor:_themeVO.mydata_tabs_icon_color forState:UIControlStateNormal];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     noDataContainerView.hidden = borderViewOfBtnContainer.hidden = _isMyDataNotificationController;
    if(_isMyDataNotificationController){
        _selectedSegment = NOTIFICATION;
        _dataArray = [self dataWithAllRequest];
        [self unableNotificationSetup:YES];
        [self reloadMyDataTableView];
    }
    else{
        if([self dataWithAllRequest].count > 0){
            _notificationIcon.hidden = NO;
        }
        else{
            _notificationIcon.hidden = YES;
            _notificationButton.enabled = NO;
        }
        [self notesSegmantWithMyNotes];
        if(_myNoteArray.count){
            _noteCountLbl.text = [NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:_myNoteArray.count]];//[NSString stringWithFormat:@"%lu",(unsigned long)_myNoteArray.count];
        }
        else{
            _noteCountLbl.hidden = YES;
        }
        [self filterData];
    }
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
    if(isRTL())
    {
        [self updateBottomLabelForSelectedButtonForRTL];
    }
    else
    {
        [self updateBottomLabelForSelectedButton];
    }
    if(!isIpad())
        topConstraintOfViewContainingPanGesture.constant = -CGRectGetHeight(upIcon.frame);
    [self updateConstraints];
}

-(void)updateConstraints
{
    if(![_userSettingsModel isHighLightEnabled])
    {
        _highlightButton.hidden = true;
        _highlightCountLbl.hidden = true;
        _notesBtnLeadingConstraint.active = false;
        [_segmentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:_notesButton
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:_segmentView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:0.0]];

        _selectedBtnLeadingConstraint.active = false;
        [_segmentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:_selectedButonBorderView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:_segmentView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:0.0]];
        _selectedSegment = NOTE;
        if(_isMyDataNotificationController)
            _selectedSegment = NOTIFICATION;

    }
    else if(![_userSettingsModel isContextualNoteEnabled] && ![_userSettingsModel isStickyNotesEnabled])
    {
        _notificationButton.hidden = true;
        _notificationIcon.hidden = true;
        _notesButton.hidden = true;
        _noteCountLbl.hidden = true;
        _filterBtnLeadingConstraint.active = false;
        [_segmentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:_highlightButton
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:_filterButton
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0
                                     constant:0.0]];
        if(isIpad())
            [_myDataContainerView addConstraint:[NSLayoutConstraint
                                                constraintWithItem:_shareSettingsButton
                                                attribute:NSLayoutAttributeTrailing
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:_myDataContainerView
                                                attribute:NSLayoutAttributeTrailing
                                                multiplier:1.0
                                                constant:0.0]];
        _selectedSegment = HIGHLIGHT;
    }
    
    if(![_userSettingsModel isSharingEnabled] || _isShareSettingsDisabled || _isShareWithMeDisabled){
        _shareSettingWidthConstraint.constant = 0;
        _notificationButton.hidden = true;
        _notificationIcon.hidden = true;
    }
    if (isShareSettingsIconDisable)
    {
        _shareSettingWidthConstraint.constant = 0;
    }
    if (isNoteNotificationDisable)
    {
        _notificationButton.hidden = true;
        _notificationIcon.hidden = true;
        if (isIpad() && !isShareSettingsIconDisable)
        {
            filterButtonWidthConstraint.constant = 0;
        }
    }
    
    if(isRTL()) {
        highlightCountLabelCenterXConstraint.active = NO;
        notesCountLabelCenterXConstraint.active = NO;
    }
    
    _printBtnTrailingConstraint.constant = _userSettingsModel.isMyDataPrintEnabled ? 10 : -50;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    topConstraintOfViewContainingPanGesture.constant = (windowHeight/2) - CGRectGetHeight(upIcon.frame);
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)updateBottomLabelForSelectedButton{
    if(_selectedSegment == NOTE || _selectedSegment == NOTIFICATION)
        _selectedBtnLeadingConstraint.constant = _notesButton.frame.origin.x;
    else
        _selectedBtnLeadingConstraint.constant = _highlightButton.frame.origin.x;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
   
}

-(void)updateBottomLabelForSelectedButtonForRTL
{
    _selectedBtnLeadingConstraint.active = NO;
    if(_selectedSegment == NOTE || _selectedSegment == NOTIFICATION)
    {
        _selectedBtnLeadingConstraintForRTL.constant = _highlightButton.frame.size.width;
    }
    else
        _selectedBtnLeadingConstraintForRTL.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
   
}

-(void)setupForIpad{
    [self addPanGestureToView:_myDataContainerView];
    self.view.backgroundColor = [_themeVO.mydata_overlay_panel_background colorWithAlphaComponent:_themeVO.mydata_overlay_panel_opacity];

}

-(void)updateSelectedSegmentView{
    //update cout lbl UI
    _highlightCountLbl.layer.cornerRadius = _noteCountLbl.layer.cornerRadius = 6;
    _highlightCountLbl.clipsToBounds = YES;
    _noteCountLbl.clipsToBounds = YES;
    _highlightCountLbl.backgroundColor = _themeVO.mydata_selected_button_background;
    _highlightCountLbl.textColor = _themeVO.mydata_selected_button_text_color;
    [self updateHeaderTitle];
    [_shareSettingsButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:22.0]];
    [_shareSettingsButton setTitleColor:_themeVO.mydata_tabs_icon_color forState:UIControlStateNormal];
    [_filterButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:22.0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

-(BOOL)shouldAutorotate{
    
    if (!isIpad()) {
        return NO;
    }
    return YES;
    
}

//-(void)setBackgroundColorForView:(UIColor *)color
//{
//    _myDataContainerView.backgroundColor = color;
//}

-(void)setThemeColorToView:(UIColor *)color
{
    themeColor = color;
    [self updateView];
    if(isIpad()){
        [self updateBorderShadowColor];
    }
}

-(void)updateBorderShadowColor{
    _myDataContainerView.layer.borderWidth = 0.6;
    _myDataContainerView.layer.masksToBounds = false;
    _myDataContainerView.layer.shadowOffset = CGSizeMake(0,-1);
    _myDataContainerView.layer.shadowRadius = 4.0;
    _myDataContainerView.layer.shadowOpacity = 0.6;
    
    upIcon.layer.masksToBounds = false;
    upIcon.layer.shadowOffset = CGSizeMake(0,-1);
    upIcon.layer.shadowRadius = 4.0;
    upIcon.layer.shadowOpacity = 0.8;

}
-(void)setNoDataLabelTextColor:(UIColor *)color{
    _noDataLabel.textColor = color;
    noDataIconLbl.textColor = color;
}

#pragma mark Set Data
- (void)setData:(NSArray *)data{
    _ugcArray = data;
    if (_selectedSegment == NOTIFICATION && isIPAD ) {
        [self updateViewForMyNotification];
    }
    else if(_isMyDataNotificationController && !isIPAD )
    {
        _dataArray = [self dataWithAllRequest];
    }
}

- (void)reloadMyDataTableView{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self->_tableView reloadData];
        [self->_tableView setContentInset:UIEdgeInsetsZero];
    });
}

#pragma Update UI
- (void)updateView{
    [_segmentView addConstraint:[NSLayoutConstraint
    constraintWithItem:_highlightCountLbl
    attribute:NSLayoutAttributeLeading
    relatedBy:NSLayoutRelationEqual
                                 toItem:_highlightButton.titleLabel
    attribute:NSLayoutAttributeTrailing
    multiplier:1.0
    constant:isRTL()?5:0]];
    [_segmentView addConstraint:[NSLayoutConstraint
    constraintWithItem:_noteCountLbl
    attribute:NSLayoutAttributeLeading
    relatedBy:NSLayoutRelationEqual
                                 toItem:_notesButton.titleLabel
    attribute:NSLayoutAttributeTrailing
    multiplier:1.0
    constant:isRTL()?5:0]];
    [_backButtonText.titleLabel setFont:getCustomFont(isIpad() ? 22 : 20)];
    [_highlightButton.titleLabel setFont:getCustomFontForWeight(isIpad() ? 20 : 16, isIpad() ? UIFontWeightRegular : UIFontWeightLight)];
    [_notesButton.titleLabel setFont:getCustomFontForWeight(isIpad() ? 20 : 16, isIpad() ? UIFontWeightRegular : UIFontWeightLight)];
    
    [_highlightButton.titleLabel setMinimumScaleFactor:0.5];
    _highlightButton.titleLabel.adjustsFontSizeToFitWidth = true;
    
    [_notesButton.titleLabel setMinimumScaleFactor:0.5];
    _notesButton.titleLabel.adjustsFontSizeToFitWidth = true;
    
    _highlightCountLbl.font = getCustomFont(14);
    _noteCountLbl.font = getCustomFont(14);
    _notificationIcon.font = getCustomFont(17);
    _noDataLabel.font = getCustomFont(17);
    [acceptButton.titleLabel setFont:getCustomFont(isIpad() ? 19 : 15)];
    [declineButton.titleLabel setFont:getCustomFont(isIpad() ? 19 : 15)];

    [self updateSelectedSegmentView];
    
    if([_userSettingsModel isHighLightEnabled])
        _selectedSegment = HIGHLIGHT;
   
    if (_isShareSettingsDisabled == YES) {
        _shareSettingsButton.hidden = YES;
        _shareSettingWidthConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
    
    if (_isShareWithMeDisabled == YES) {
        _shareSettingsButton.hidden = YES;
        _shareSettingWidthConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
    _selectedHighlightIndex = NSNotFound;
    _tableView.backgroundColor = [UIColor clearColor];
    //
    
    _noDataLabel.text = [LocalizationHelper localizedStringWithKey:@"NO_DATA" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController];
    
    //
    
    UINib *cellNib = [UINib nibWithNibName:@"MyDataHighlightCell"
                                    bundle:[NSBundle bundleForClass:[KBMyDataViewController class]]];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"MyDataHighlightCell"];
    
    UINib *noteCellNib = [UINib nibWithNibName:@"MyDataNoteCell"
                                        bundle:[NSBundle bundleForClass:[KBMyDataViewController class]]];
    [_tableView registerNib:noteCellNib forCellReuseIdentifier:@"MyDataNoteCell"];
    
    UINib *answerCellNib = [UINib nibWithNibName:@"MyDataNoteAnswerCell"
                                          bundle:[NSBundle bundleForClass:[KBMyDataViewController class]]];
    [_tableView registerNib:answerCellNib forCellReuseIdentifier:@"MyDataNoteAnswerCell"];
    
    [_backButtonIcon setTitleColor:_themeVO.mydata_selected_text_color forState:UIControlStateNormal];
    [_backButtonText setTitleColor:_themeVO.mydata_selected_text_color forState:UIControlStateNormal];
    [_backButtonIcon.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:22.0]];
    if(!_isMyDataNotificationController){
        
        // Call Filter data for shared with me to get count of shared data
        if([_userSettingsModel isContextualNoteEnabled] || [_userSettingsModel isStickyNotesEnabled])
        {
            _selectedSegment = NOTE;
            [self filterData];
        }
    
        // Call Filter data for my data
        if([_userSettingsModel isHighLightEnabled])
        {
            _selectedSegment = HIGHLIGHT;
            [self filterData];
        }
    }
    if(isRTL()) {
        _highlightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _notesButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _backButtonText.contentHorizontalAlignment = NSTextAlignmentNatural;
        _selectedBtnLeadingConstraint.active = NO;
        _selectedBtnLeadingConstraintForRTL = [NSLayoutConstraint
                                               constraintWithItem:_selectedButonBorderView
                                               attribute:NSLayoutAttributeLeading
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:_segmentView
                                               attribute:NSLayoutAttributeLeading
                                               multiplier:1.0
                                                      constant:0.0];
        [_segmentView addConstraint:_selectedBtnLeadingConstraintForRTL];
    }
}

-(void)updateViewForMyNotification{
        _selectedSegment = NOTIFICATION;
        _dataArray = [self dataWithAllRequest];
    heightConstraintNotificationTopView.constant = isIpad()?54 : 40;
        acceptButton.hidden = declineButton.hidden = NO;
        noDataContainerView.hidden = YES;
    [_tableView setHidden:NO];
    if(isRTL())
    {
        [self updateBottomLabelForSelectedButtonForRTL];
    }
    else
    {
        [self updateBottomLabelForSelectedButton];
    }
    [self updateHeaderTitle];
    _highlightButton.selected = NO;
    _notesButton.selected = YES;
    [self reloadMyDataTableView];
}

- (void)disableShareSettings:(BOOL)disable{
    _isShareSettingsDisabled = disable;
}

- (void)disableShareWithMeTab:(BOOL)disable{
    _isShareWithMeDisabled = disable;
}

- (void)disableShareSettingsIcon:(BOOL)disable
{
    isShareSettingsIconDisable = disable;
}

- (void)disableNoteNotification:(BOOL)disable
{
    isNoteNotificationDisable = disable;
}


#pragma Table view delegates and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDKHighlightVO *highlight;
    if (_dataArray.count > indexPath.row) {
        highlight = _dataArray[indexPath.row];
    }
     
    
    UIColor *color = [UIColor colorWithHexString:highlight.backgroundColor];
    
    if([highlight.backgroundColor isEqualToString:@"#"] || [highlight.backgroundColor isEqualToString:@"# "])
    {
        color = [UIColor colorWithHexString:@"#FFFF00"];
    }

    if (highlight.isReceived) {
        color = [UIColor colorWithHexString:SharedColor];
    }
    switch (_selectedSegment) {
        case HIGHLIGHT:{
            
            KBMyDataHighlightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDataHighlightCell"];
            
            if (!cell) {
                cell = [[KBMyDataHighlightCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"MyDataHighlightCell"];
            }
            cell.accessibilityIdentifier = [NSString stringWithFormat:@"highlightCell%ld", (long)indexPath.row];
            cell.chapterTitleLabel.textColor = _themeVO.mydata_chpater_text_color;
            cell.dateLabel.textColor = _themeVO.mydata_page_date_text_color;
            cell.noteTextLabel.textColor = _themeVO.mydata_note_text_color;
            cell.backgroundColor = cell.backgroundView.backgroundColor =
            cell.contentView.backgroundColor = [UIColor clearColor];
            NSString *pageID = [NSString stringWithFormat:@"%@: %@ %@",[LocalizationHelper localizedStringWithKey:@"PAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController],highlight.displayNum,@" "];
            NSString *dateString = [pageID stringByAppendingString:[NSString getLocalizedStringForDateString:[highlight getDisplayDate]]];
            if(![_book isKindOfClass:[KFBookVO class]])
            {
                dateString = [NSString getLocalizedStringForDateString:[highlight getDisplayDate]];
            }

            [cell updateCellWithChapterName:highlight.chapterName date:dateString text:highlight.text color:color];
            NSString *iconLabelText = ICON_HIGHLIGHTER_K12;
            if (isIpad()) {
                [cell.iconLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:30.0]];
                [cell.chapterTitleLabel setFont:getCustomFont(16)];
                [cell.dateLabel setFont:getCustomFont(13)];
            }
            else{
                [cell.iconLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:26.0]];
                [cell.chapterTitleLabel setFont:getCustomFont(15)];
                [cell.dateLabel setFont:getCustomFont(13)];
            }
            cell.iconLabel.text = iconLabelText;
            return cell;
        }
            break;
        case NOTE:{
            {
                
                KBMyDataNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDataNoteCell"];
                cell.accessibilityIdentifier = [NSString stringWithFormat:@"noteCell%ld", (long)indexPath.row];
                cell.commentButton.accessibilityIdentifier = [NSString stringWithFormat:@"noteCellCommentBtn%ld", (long)indexPath.row];
                cell.shareButton.accessibilityIdentifier = [NSString stringWithFormat:@"noteCellShareBtn%ld", (long)indexPath.row];
                cell.chapterNameLabel.textColor = _themeVO.mydata_chpater_text_color;
                cell.dateLabel.textColor = _themeVO.mydata_page_date_text_color;
                cell.noteTextLabel.textColor = _themeVO.mydata_note_text_color;
                cell.highlightLabel.textColor = _themeVO.mydata_note_text_color;
                [cell.commentButton setTitleColor:_themeVO.mydata_commentShare_button_text_icon_color forState:UIControlStateNormal];
                [cell.commentButton setTitleColor:_themeVO.mydata_commentShare_button_disabled_text_icon_color forState:UIControlStateNormal];
                [cell.shareButton setTitleColor:_themeVO.mydata_commentShare_button_text_icon_color forState:UIControlStateNormal];
                [cell.shareButton setTitleColor:_themeVO.mydata_commentShare_button_disabled_text_icon_color forState:UIControlStateNormal];
                if (!cell) {
                    cell = [[KBMyDataNoteCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"MyDataNoteCell"];
                }
                cell.backgroundColor = cell.backgroundView.backgroundColor =
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.localId = highlight.localID;
                cell.delegate = self;
                cell.index = indexPath.row;
                NSString *iconLabelText = (highlight.text.length == 0)?ICON_TAPPABLE_STICKY_NOTE : NOTE_TEXT_ICON;
                if (highlight.isTeacherReviewNote) {
                    iconLabelText = ICON_TEACHER_COMMENT;
                    color = [UIColor colorWithHexString:@"#ffc000"];
                }
                if (isIpad()) {
                    [cell.iconLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:30.0]];
                    [cell.chapterNameLabel setFont:getCustomFont(16)];
                    [cell.dateLabel setFont:getCustomFont(13)];
                    [cell.noteTextLabel setFont:getCustomFont(15)];
                    [cell.commentButton.titleLabel setFont:getCustomFont(16)];
                    [cell.shareButton.titleLabel setFont:getCustomFont(16)];
                }
                else{
                    [cell.iconLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:26.0]];
                    [cell.chapterNameLabel setFont:getCustomFont(15)];
                    [cell.dateLabel setFont:getCustomFont(12)];
                    [cell.noteTextLabel setFont:getCustomFont(14)];
                    [cell.commentButton.titleLabel setFont:getCustomFont(15)];
                    [cell.shareButton.titleLabel setFont:getCustomFont(15)];
                }
                cell.iconLabel.text = iconLabelText;
                cell.shareButton.hidden = NO;
                if (_myDataFilter == SHARED_WITH_ME) {
                    [cell showShareButton:NO];
                }
                NSString *pageID = [NSString stringWithFormat:@"%@: %@ %@",[LocalizationHelper localizedStringWithKey:@"PAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController],highlight.displayNum,@" "];
                NSString *dateString = [pageID stringByAppendingString:[NSString getLocalizedStringForDateString:[highlight getDisplayDate]]];
                if(![_book isKindOfClass:[KFBookVO class]])
                {
                    dateString = [NSString getLocalizedStringForDateString:[highlight getDisplayDate]];
                }
                [cell updateCellWithChapterName:highlight.chapterName
                                           date:dateString
                                           text:highlight.text
                                       noteText:highlight.noteText
                                          color:color
                                  commentsCount:[NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:highlight.noteComments.count]] //[NSString stringWithFormat:@"%lu",(unsigned long)highlight.noteComments.count]
                                     shareCount:[NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:highlight.sharedUsers.count]]//[NSString stringWithFormat:@"%lu",(unsigned long)highlight.sharedUsers.count]
                                     withButtonColors:_themeVO.mydata_commentShare_button_text_icon_color];
                if([_userSettingsModel isSharingEnabled] && !highlight.isTeacherReviewNote)
                {
                    if (highlight.isReceived) {
                        [cell showShareButton:NO];
                    } else {
                        if (_isShareSettingsDisabled) {
                            [cell showShareButton:NO];
                            [cell showCommentButton:NO];
                        }
                        else{
                            [cell showShareButton:YES];
                            [cell showCommentButton:YES];
                        }
                    }
                }
                else
                {
                    [cell showShareButton:NO];
                    [cell showCommentButton:NO];
                }
                
                return cell;
            }
        }
        case NOTIFICATION:{
            
                KBMyDataNoteAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDataNoteAnswerCell"];
                
                if (!cell) {
                    cell = [[KBMyDataNoteAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyDataNoteAnswerCell"];
                }
                cell.accessibilityIdentifier = [NSString stringWithFormat:@"notificationCell%ld", (long)indexPath.row];
                cell.acceptButton.accessibilityIdentifier = [NSString stringWithFormat:@"notificationCellAcceptBtn%ld", (long)indexPath.row];
                cell.rejectButton.accessibilityIdentifier = [NSString stringWithFormat:@"notificationCellRejectBtn%ld", (long)indexPath.row];
                cell.creatorNameLabel.textColor = _themeVO.mydata_chpater_text_color;
            if(highlight)
            {
                cell.creatorNameLabel.text = [NSString stringWithFormat:@"%@ %@",highlight.creatorName,[NSString stringWithFormat:@"%@",[LocalizationHelper localizedStringWithKey:@"MY_DATA_STARTED_SHARING_DATA_WITH_YOU" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]]];
                [cell.acceptButton setBackgroundColor:_themeVO.settings_done_button_background];
                [cell.acceptButton setTitleColor:_themeVO.settings_done_button_text_color forState:UIControlStateNormal];
                [cell.rejectButton setTitleColor:_themeVO.settings_cancel_button_text_color forState:UIControlStateNormal];
                cell.rejectButton.layer.borderColor = _themeVO.settings_cancel_button_border_color.CGColor;
                cell.delegate = self;
                cell.ugcId = highlight.ugcID;
                NSString *iconLabelText = highlight.isStickyNote?ICON_TAPPABLE_STICKY_NOTE : NOTE_TEXT_ICON;
                if (isIpad()) {
                    [cell.iconLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:32.0]];
                    [cell.creatorNameLabel setFont:getCustomFont(15)];
                    [cell.acceptButton.titleLabel setFont:getCustomFont(15)];
                    [cell.rejectButton.titleLabel setFont:getCustomFont(15)];
                }
                else{
                    [cell.iconLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:26.0]];
                    [cell.creatorNameLabel setFont:getCustomFont(14)];
                    [cell.acceptButton.titleLabel setFont:getCustomFont(14)];
                    [cell.rejectButton.titleLabel setFont:getCustomFont(14)];
                }
                [cell.iconLabel setTextColor:color];
                cell.iconLabel.text = iconLabelText;
                cell.contentView.backgroundColor = [UIColor clearColor];
        }
                return cell;
                
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectedSegment == NOTE || _selectedSegment == HIGHLIGHT){
    SDKHighlightVO *ugc = _dataArray[indexPath.row];
    if (!(ugc.isReceived && !ugc.isAnswered))
    {
        if (ugc.href != nil)
        {
            if(_delegate && [_delegate respondsToSelector:@selector(navigateTopage:)]){
                    [_delegate navigateTopage:ugc.href];
            }
            [self dismissMyDataController];
        }
        else
        {
            if(_delegate && [_delegate respondsToSelector:@selector(navigateTopage:)]){
//                    [_delegate navigateTopage:ugc.pageIdentifier];
                //CPI-2248 we getting displayNum as null string for medmaster
                if(![ugc.displayNum isEqualToString:@"null"] && ![ugc.displayNum isKindOfClass:[NSNull class]])
                {
                    NSString *pageNumber = [self getPageNumberForDisplayNumber:ugc.displayNum];
                    [_delegate navigateTopage:[self getStringValue:pageNumber]];
                }
            }
            [self dismissMyDataController];
        }
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
            return UITableViewAutomaticDimension;
}

#pragma mark Action methods

- (IBAction)printButtonTapped:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(didTapOnPrint)]){
        [_delegate didTapOnPrint];
    }
}

- (IBAction)backButtonTapped:(UIButton *)sender
{
    if(_isMyDataNotificationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissMyDataController];
    }
}

- (IBAction)shareSettingsButtonTapped:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(didTapOnShareSettings)]){
        [_delegate didTapOnShareSettings];
    }
}

- (IBAction)segmentbuttonAction:(UIButton *)sender {
    _selectedSegment = (int)sender.tag;
    if(isRTL())
    {
        [self updateBottomLabelForSelectedButtonForRTL];
    }
    else
    {
        [self updateBottomLabelForSelectedButton];
    }
    [self updateHeaderTitle];
    [self filterData];
}

- (IBAction)filterButtonAction:(id)sender {
    if(_selectedSegment == HIGHLIGHT){
        [filterViewController setIsHighlightFilter:YES];
    }else{
        [filterViewController setIsHighlightFilter:NO];
    }
    [self.navigationController presentViewController:filterViewController animated:YES completion:^{
    }];
}
- (IBAction)notificationButtonAction:(id)sender {
    if([self dataWithAllRequest].count){
        if(isIpad()){
            [self updateViewForMyNotification];
        }
        else
        [self presentMyDataForNotification];
    }
}

#pragma mark :- FilterViewController setup
-(void)inilializeFilterViewController{
    filterViewController = [[FilterViewController alloc] initWithNibName:@"FilterViewController"
                                                                  bundle:[NSBundle bundleForClass:[FilterViewController class]]];
    filterViewController.isSharingEnabled = true;
    if([_book isKindOfClass:[KFBookVO class]]) {
        filterViewController.isStickyNotesEnabled = YES;
    }else {
        EPUBBookVO *book=(EPUBBookVO*)_book;
        if(book.meta.layout == ePUBFixedLayout) {
            filterViewController.isStickyNotesEnabled = YES;
        }
    }
    if (isIpad()) {
        filterViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else
    {
        filterViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    filterViewController.bookOrientationMode = self.bookOrientationMode;
    if(isIpad())
    filterViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    filterViewController.themeVO = _themeVO;
    filterViewController.userSettingsModel = _userSettingsModel;
    __weak typeof(self) weakSelf = self;
    [filterViewController setDissmisFilterController:^{
        [weakSelf.view setAlpha:1];
        [weakSelf reloadMyDataTableView];
    }];
    [filterViewController setFilterNotesAction:^(NSArray *arrayOFNotes, NSArray *arrayOFContextualNotes,BOOL isAllSelected,BOOL isSharedNoteFilter,BOOL isSharedContextualNoteFilter) {
        [weakSelf.view setAlpha:1];
        if(isAllSelected){
            self->notesWithFilter = NO;
        }
        else{
            notesWithFilter = YES;
        self->contexualFilterColorsArray = [arrayOFContextualNotes valueForKey:@"localizedLowercaseString"];
        notesFilterColorsArray = [arrayOFNotes valueForKey:@"localizedLowercaseString"];
        isSharedContextualNotes = isSharedContextualNoteFilter;
        isSharedNotesSelected = isSharedNoteFilter;
        }
        [weakSelf filterData];
    }];
    [filterViewController setFilterHighlightsAction:^(NSArray *arrayOfHighlights,BOOL isAllSelected,BOOL isSharedHighlighFilter) {
        [weakSelf.view setAlpha:1];
        if(isAllSelected)
            highlightWithFilter = NO;
        else{
            highlightWithFilter = YES;
            highlightFilterColorsArray = [arrayOfHighlights valueForKey:@"localizedLowercaseString"];
            isSharedHighlightSelected = isSharedHighlighFilter;
        }
        [weakSelf filterData];
    }];
    if(![_userSettingsModel isSharingEnabled] || _isShareSettingsDisabled || _isShareWithMeDisabled){
        filterViewController.isSharingEnabled = false;
    }
    [filterViewController setColorsForFilter:_themeVO.highlight_Color_Array];
}

#pragma mark Note Answer delegate

- (void)didTapOnAcceptButton:(NSString *)ugcId{
    if ([[KitabooNetworkManager getInstance] isInternetAvailable]) {
        [self didHighlight:ugcId accepted:YES];
    }else
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]] onController:[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            
        }];
    }
}

- (void)didTapOnRejectButton:(NSString *)ugcId{
    if ([[KitabooNetworkManager getInstance] isInternetAvailable]) {
        [self didHighlight:ugcId accepted:NO];
    }else
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBMyDataViewController]] onController:[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            
        }];
    }
}

- (void)didHighlight:(NSString *)ugcId accepted:(BOOL)accepted{

    NSInteger index = [_dataArray indexOfObjectPassingTest:^BOOL(SDKHighlightVO *highlight, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([highlight.ugcID isEqualToString:ugcId]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];

    if (index != NSNotFound) {
        SDKHighlightVO *highlight = [_dataArray objectAtIndex:index];
        highlight.isCollabSubmitted = NO;
        if(_delegate && [_delegate respondsToSelector:@selector(didAnsweredHighlight:accepted:)]){
            [_delegate didAnsweredHighlight:highlight accepted:accepted];
        }
        //@@@@ Reload tableview
//        [self segmentValueChanged:_segmentController];
    }
    if([self dataWithAllRequest].count > 0){
    _dataArray = [self dataWithAllRequest];
    if(accepted)
        _noteCountLbl.text = [NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:_noteCountLbl.text.intValue + 1]];//[NSString stringWithFormat:@"%d",_noteCountLbl.text.intValue + 1];
    [self reloadMyDataTableView];
    }
    else{
        if(isIpad()){
            _selectedSegment = NOTE;
            [self unableNotificationSetup:NO];
            _notificationIcon.hidden = YES;
            _notificationButton.enabled = NO;
            [self filterData];
        }
        else
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark Filter Methods

- (void)filterData
{
    switch (_selectedSegment) {
        case NOTE:{
            _highlightButton.selected = NO;
            _notesButton.selected = YES;
            noDataIconLbl.text = ICON_TAPPABLE_STICKY_NOTE;
             _dataArray = [self notesSegmantWithMyNotes];
            if(!notesWithFilter){
                _noDataLabel.text = EmptyNoteTitle;
            }
            else{
                _noDataLabel.text = EmptyFilterNoteTitle;
            }
            if(_dataArray.count){
                if (_noteCountLbl.isHidden){
                    _noteCountLbl.hidden = false;
                }
                _noteCountLbl.text = [NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:_dataArray.count]];//[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count];
            }
            else{
                _noteCountLbl.hidden = YES;
            }
        }
            break;
        case HIGHLIGHT:{
            _highlightButton.selected = YES;
            _notesButton.selected = NO;
            _noDataLabel.text = EmptyHighlighttitle;
            noDataIconLbl.text = ICON_HighlightNew;
            [self highlightsSegmantWithMyHighlights];
            if(!highlightWithFilter){
                _noDataLabel.text = EmptyHighlighttitle;
            }
            else{
                _noDataLabel.text = EmptyFilterHighlightTitle;
            }
            if(_dataArray.count){
                _highlightCountLbl.text =  [NumberLocalizationHandler localizeNumberWithNumber:[NSNumber numberWithInteger:_dataArray.count]];//[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count];
                _highlightCountLbl.hidden = NO;
            }
            else{
                _highlightCountLbl.hidden = YES;
            }

        }
            break;
        default:
            break;
    }
    
    //@@@@ SORT DATA
    if(_isMyDataNotificationController){
        noDataContainerView.hidden = YES;
    }
    else{
        [self sortData];
        if (_dataArray.count > 0)
        {
            _tableView.hidden = NO;
            _printButton.alpha = 1;
            [_printButton setUserInteractionEnabled:YES];
        }
        else
        {
            _dataArray = @[];
            _tableView.hidden = YES;
            _printButton.alpha = 0.5;
            [_printButton setUserInteractionEnabled:NO];
        }
        noDataContainerView.hidden = !_tableView.hidden;
    }
    [self reloadMyDataTableView];
}

- (void)sortData{
    if (_selectedSegment == NOTE)
    {
        //Commented for Ordering Note issue in Mydata.
//        NSSortDescriptor *isAnswered = [[NSSortDescriptor alloc] initWithKey:@"isAnswered"
//                                                                   ascending:YES];
//
//        NSSortDescriptor *isReceived = [[NSSortDescriptor alloc] initWithKey:@"isReceived"
//                                                                   ascending:NO];
//
//        _dataArray = [_dataArray sortedArrayUsingDescriptors:@[isReceived, isAnswered]];
    }
}

- (void)highlightsSegmantWithMyHighlights{
    if(highlightWithFilter){
        [self highlightsSegmantWithFilter];
        _filterIcon.hidden = NO;
    }
    else{
    _dataArray = [_ugcArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText = nil OR self.noteText.length = 0)", DELETE,isSharedHighlightSelected]];
    _dataArray = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAnswered = 1"]];
        if(_dataArray.count == 0 && _selectedSegment == HIGHLIGHT){
            _filterButton.enabled = NO;
        }
        else
            _filterButton.enabled = YES;
        _filterIcon.hidden = YES;
    }
}

- (void)highlightsSegmantWithFilter
{
    for ( SDKHighlightVO *sdk in _ugcArray)
    {
       sdk.backgroundColor = [sdk.backgroundColor localizedLowercaseString];
    }
    _dataArray = [_ugcArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText = nil OR self.noteText.length = 0) AND ((isAnswered = %d AND isReceived = %d) || self.backgroundColor IN %@.lowercaseString)", DELETE,isSharedHighlightSelected,isSharedHighlightSelected,highlightFilterColorsArray]];
    _dataArray = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAnswered = 1"]];
}

- (NSArray *)notesSegmantWithFilterNotes
{
    NSArray *tempArr = [NSArray arrayWithArray:_ugcArray];
    for ( SDKHighlightVO *sdk in tempArr)
    {
        sdk.backgroundColor = [sdk.backgroundColor localizedLowercaseString];
        if (sdk.isReceived) {
             sdk.backgroundColor = SharedColor;
        }
    }
    
    NSArray *notesArray;
    notesArray = [tempArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"((self.status != %d) AND (self.noteText != nil AND self.noteText != '' AND (self.text == '' ||  self.text == nil) AND (((isAnswered = %d AND isReceived = %d) || self.backgroundColor IN %@.lowercaseString)))) || ((self.status != %d) AND (self.noteText != nil AND self.noteText != '') AND (self.text != nil AND self.text != '' AND ((isAnswered = %d AND isReceived = %d) || self.backgroundColor IN %@.lowercaseString)))", DELETE,isSharedNotesSelected,isSharedNotesSelected,notesFilterColorsArray,DELETE,isSharedContextualNotes,isSharedContextualNotes,contexualFilterColorsArray]];
    notesArray = [notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAnswered = 1"]];
    return notesArray;
}

- (NSArray *)notesSegmantWithMyNotes{
    NSArray *notesArray;

    if(notesWithFilter){
        _filterIcon.hidden = NO;
        notesArray = [self notesSegmantWithFilterNotes];
    }
    else{
        notesArray = [_ugcArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText != nil AND self.noteText != '')", DELETE]];
        notesArray = [notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReceived = 0 OR (isReceived = 1 AND isAnswered = 1)"]];
        _myNoteArray = [notesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReceived = 0 OR (isReceived = 1 AND isAnswered = 1)"]];
        if(notesArray.count == 0 && _selectedSegment == NOTE){
            _filterButton.enabled = NO;
        }
        else
            _filterButton.enabled = YES;
        _filterIcon.hidden = YES;
    }
    return notesArray;
}

- (NSArray *)dataWithAllRequest{
    NSArray *dataRequestArray;
    dataRequestArray = [_ugcArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.status != %d) AND (self.noteText != nil)", DELETE]];
    dataRequestArray = [dataRequestArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReceived = 1 AND isAnswered = 0"]];
    return dataRequestArray;
}

-(void)showCommentsViewForIndex:(NSInteger)index{
    SDKHighlightVO *ugc = _dataArray[index];
    if(_delegate && [_delegate respondsToSelector:@selector(didTapOnNotesComment:)]){
        [_delegate didTapOnNotesComment:ugc];
    }
}

-(void)showShareViewForIndex:(NSInteger)index{
    SDKHighlightVO *ugc = _dataArray[index];
    if(_delegate && [_delegate respondsToSelector:@selector(didTapOnNoteShareSettings:)]){
        [_delegate didTapOnNoteShareSettings:ugc];
    }
}

-(void)unableNotificationSetup:(BOOL)enable{
    if(enable){
        heightConstraintOfSegmentView.constant = 0;
        heightConstraintNotificationTopView.constant = 40;
        acceptButton.hidden = declineButton.hidden = NO;
        _segmentView.hidden = YES;
    }
    else{
        heightConstraintOfSegmentView.constant = 60;
        heightConstraintNotificationTopView.constant = 0;
        acceptButton.hidden = declineButton.hidden = YES;
        _segmentView.hidden = NO;
    }
}

-(void)setBackButtonTitle : (NSString*)title
{
    [_backButtonText setTitle:title forState: UIControlStateNormal];
}

-(void)updateHeaderTitle{
  
    if(_selectedSegment == HIGHLIGHT){
        backButtonTextTitle  = [NSString stringWithFormat:@"%@: %@",MyDataTitle,HighlightTitle];
        if(headerHeightConstraint.constant == DefaultHeaderHeight)
        [self setBackButtonTitle:backButtonTextTitle];
        _highlightCountLbl.backgroundColor = _themeVO.mydata_selected_button_background;
        _highlightCountLbl.textColor = _themeVO.mydata_selected_button_text_color;
        _noteCountLbl.backgroundColor = _themeVO.mydata_deselected_button_background;
        _noteCountLbl.textColor = _themeVO.mydata_deselected_button_text_color;
        ((UIButton *)[_segmentView viewWithTag:100]).selected = NO;
        
    }else{
        backButtonTextTitle  = [NSString stringWithFormat:@"%@: %@",MyDataTitle,NoteTitle];
        if(headerHeightConstraint.constant == DefaultHeaderHeight)
        [self setBackButtonTitle:backButtonTextTitle];
        _highlightCountLbl.backgroundColor = DisableGrayColor;
        _noteCountLbl.backgroundColor = _themeVO.mydata_selected_button_background;
        _noteCountLbl.textColor = _themeVO.mydata_selected_button_text_color;
        _highlightCountLbl.backgroundColor = _themeVO.mydata_deselected_button_background;
        _highlightCountLbl.textColor = _themeVO.mydata_deselected_button_text_color;
        ((UIButton *)[_segmentView viewWithTag:101]).selected = NO;
    }
}

-(void)presentMyDataForNotification{
    //using same controller for Notification by changing data and UI
    KBMyDataViewController *myDataViewController = [[KBMyDataViewController alloc] initWithNibName:@"MyDataViewController"
                                                                     bundle:[NSBundle bundleForClass:[KBMyDataViewController class]]];
    myDataViewController.delegate = self.delegate;
    myDataViewController.isMyDataNotificationController = YES;
    [myDataViewController setData:_ugcArray];
    [myDataViewController setThemeVO:self.themeVO];
    [myDataViewController setBookOrientationMode:_bookOrientationMode];
//    [myDataViewController setBackgroundColorForView:_myDataContainerView.backgroundColor];
//    [myDataViewController setThemeColorToView:themeColor];
    [self.navigationController pushViewController:myDataViewController animated:YES];
}

-(void)updateHeaderHeight:(CGFloat)headerHeight{
    headerHeightConstraint.constant = headerHeight;
    if(headerHeight == DefaultHeaderHeight){
        _myDataContainerView.layer.borderWidth = 0;
        upIcon.hidden = YES;
        [self updateHeaderTitle];
        [_backButtonIcon setTitle:ICON_DOWNARROW forState:UIControlStateNormal];
    }
    else{
        _myDataContainerView.layer.borderWidth = 0.6;
        upIcon.hidden = NO;
        [_backButtonIcon setTitle:@"" forState:UIControlStateNormal];
        [_backButtonText setTitle:@"" forState:UIControlStateNormal];
    }
}

-(void)addPanGestureToView:(UIView *)view{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    pan.cancelsTouchesInView = NO;
    [upIcon.superview addGestureRecognizer:pan];
    topConstraintOfViewContainingPanGesture.constant =  isIpad()? windowHeight + CGRectGetHeight(upIcon.frame): - CGRectGetHeight(upIcon.frame);
    tocLeftConstraint.constant = isIPAD? 15:0;
    tocRightConstraint.constant = isIPAD?15:0;
    [self updateHeaderHeight:0];
    [self updateBorderShadowColor];
    [self.view layoutIfNeeded];
}

#pragma mark - Pan Gesture Action
-(void) handlePan:(UIPanGestureRecognizer*)panGes{
    
    CGPoint t = [panGes translationInView:self.view];
    CGPoint velocity = [panGes velocityInView:self.view];
   
    if (panGes.state == UIGestureRecognizerStateBegan) {
        previousStateYPosition = topConstraintOfViewContainingPanGesture.constant;
        topConstraintOfViewContainingPanGesture.constant = MAX(-CGRectGetHeight(upIcon.frame),(previousStateYPosition+t.y));
        [self.view layoutIfNeeded];
        
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        
        topConstraintOfViewContainingPanGesture.constant = MAX(-CGRectGetHeight(upIcon.frame),previousStateYPosition+t.y);
        if(topConstraintOfViewContainingPanGesture.constant <= 0){
            tocRightConstraint.constant = 0;
            tocLeftConstraint.constant = 0;
            [self updateHeaderHeight:DefaultHeaderHeight];
        }
        else{
            tocRightConstraint.constant = 15;
            tocLeftConstraint.constant = 15;
            [self updateHeaderHeight:0];
        }
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }else if (panGes.state == UIGestureRecognizerStateEnded) {
        panGes.view.alpha = 1.0;
        if(topConstraintOfViewContainingPanGesture.constant < windowHeight/2 && velocity.y < 0){
            topConstraintOfViewContainingPanGesture.constant = -CGRectGetHeight(upIcon.frame);
            tocRightConstraint.constant = 0;
            tocLeftConstraint.constant = 0;
            [self updateHeaderHeight:50];
        }
        else if (topConstraintOfViewContainingPanGesture.constant < (windowHeight/2) - CGRectGetHeight(upIcon.frame) && velocity.y > 0){
            topConstraintOfViewContainingPanGesture.constant = (windowHeight/2) - CGRectGetHeight(upIcon.frame);
            tocRightConstraint.constant = 15;
            tocLeftConstraint.constant = 15;
            [self updateHeaderHeight:0];
        }
        else if (topConstraintOfViewContainingPanGesture.constant > (windowHeight/3) - CGRectGetHeight(upIcon.frame) && velocity.y > 0){
            [self dismissMyDataController];
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }
}

-(void)dismissMyDataController{
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectActionToCloseMyData)]){
        [_delegate didSelectActionToCloseMyData];
    }
    if(isIpad()){
    topConstraintOfViewContainingPanGesture.constant = windowHeight;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }];
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if(gestureRecognizer.view == self.view)
            return YES;
        else
            return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if (touch.view == self.view) {
            // Don't let selections of auto-complete entries fire the
            // gesture recognizer
            return YES;
        }
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if(_bookOrientationMode == kBookOrientationModeLandscapeOnePageOnly || _bookOrientationMode == kBookOrientationModeLandscapeTwoPageOnly)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else if(_bookOrientationMode == kBookOrientationModePortrait)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)tapGestureAction:(id)sender {
    [self dismissMyDataController];
}
-(NSString*)getPageNumberForDisplayNumber:(NSString*)displayNumber
{
    if([_book isKindOfClass:[KFBookVO class]])
    {
        NSArray *dataArray=  [_book getThumbnailData];
        for(int i=0;i<dataArray.count;i++)
        {
            NSDictionary *dict = dataArray [i];
            NSArray *pageArray = [dict valueForKey:@"Pages"];
            for( NSDictionary *d in pageArray)
            {
                NSString *folioNumber = [d valueForKey:@"DisplayNumber"];
                if([displayNumber isEqualToString:folioNumber])
                {
                    return [d valueForKey:@"PageNo"];
                }
            }
        }
    }
    return displayNumber;
}
-(NSString *)getStringValue:(id)object
{
    if([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    return [object stringValue];
}

#pragma mark Accessibility method

-(void)setAccessibilityForMyData
{
    _backButtonIcon.accessibilityIdentifier = MYDATA_BACK_BUTTON;
    _backButtonText.accessibilityIdentifier = MYDATA_BACK_BUTTON_TEXT;
    _highlightButton.accessibilityIdentifier = MYDATA_HIGHLIGHT_BUTTON;
    _highlightCountLbl.accessibilityIdentifier = MYDATA_HIGHLIGHT_COUNT_LABEL;
    _notesButton.accessibilityIdentifier = MYDATA_NOTES_BUTTON;
    _noteCountLbl.accessibilityIdentifier = MYDATA_NOTES_COUNT_LABEL;
    _filterButton.accessibilityIdentifier = MYDATA_FILTER_BUTTON;
    _shareSettingsButton.accessibilityIdentifier = MYDATA_SHARE_SETTINGS_BUTTON;
    _notificationButton.accessibilityIdentifier = MYDATA_NOTIFICATION_BUTTON;
}
@end
