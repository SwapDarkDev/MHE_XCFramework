//
//  ShareSettingsController.m

//
//  Created by Sumanth Myrala on 12/02/18.
//  Copyright © 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "KBShareSettingsController.h"
#import "HSUIColor-Expanded.h"
#import "NSString-Supplement.h"
#import "KitabooSharedUserInfo.h"
#import "KBShareSettingsCell.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>

#define SelectedTexViewDefaultHt 21

#define CheckBoxDefaultColor [UIColor colorWithHexString:@"#C6C6C6"]
#define ClassListViewTag 5000
#define SelectedClassBtnTag 6000
#define dropDownClassBtnTag SelectedClassBtnTag+1
#define LocalizationBundleForKBShareSettingsController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]
typedef enum : short {
    
    ClassListTableTag = 1,
    SharedUserListTableTag = 2
} TableTag;

@interface KBShareSettingsController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, KBShareSettingsCellDelegate,HDDropDownDelegate>
{
    
    SDKBookClassInfoVO *_bookClassInfo;
    SDKBookClassInfoVO *_selectedClass;
    HDDropDownController *dropdowncontroller;

    NSMutableDictionary *_userDictionary;
    NSArray *_classList,*sharedUserArray;
    NSMutableArray *_userArray;
    NSMutableArray *noteSharedArray;
    NSMutableArray *sharedArray;
    NSMutableArray *classArray;
    NSMutableArray *highlightSharedArray;
    NSMutableArray *highlightReceivedArray;
    BOOL _shareAllSelected;
    BOOL _isNoteSharing;
    
    BOOL _isAllTeachersSelected;
    BOOL _isAllStudentsSelected;
    BOOL _isCurrentStudentAllCollabratedUsers;
    BOOL _isCurrentTeacherAllCollabratedUsers;
    BOOL _isStudentAllCollabratedUsers;
    BOOL _isTeacherAllCollabratedUsers;
    
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UILabel *_noDataLabel;
    __weak IBOutlet UIView *_allSelectionHolderView;
    __weak IBOutlet UILabel *_settingsLabel;
    __weak IBOutlet UIView *_topbarSeparator;
    __weak IBOutlet UIButton *_cancelButton;
    __weak IBOutlet UIButton *_doneButton;
    __weak IBOutlet UITableView *_shareUserListTable;
    __weak IBOutlet UIButton *_classNameButton;
    __weak IBOutlet UIButton *_dropDownButton;
    __weak IBOutlet UIView *_classListHolderView;
    __weak IBOutlet UIView *_classContainerView;

    __weak IBOutlet NSLayoutConstraint *bottomConstraintOfHeaderView;
    __weak IBOutlet UIButton *_receiveAllButton;
    __weak IBOutlet UIButton *_shareAllButton;
    __weak IBOutlet NSLayoutConstraint *_classListHolderViewHeightConstraint;
    __weak IBOutlet UIView *_topRecieveIconView;
    __weak IBOutlet UIView *_topShareIconView;
    __weak IBOutlet UILabel *_topShareLabel;
    __weak IBOutlet UILabel *_receiveLabel;
    __weak IBOutlet NSLayoutConstraint *_classListViewLeadingConstraint;
    __weak IBOutlet UIView *_bottomBarView;
    __weak IBOutlet NSLayoutConstraint *headerViewLeadingConstraint;
    __weak IBOutlet UIButton *headerTitleBtn;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet NSLayoutConstraint *widthConstraintOfContainer;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfContainer;
    __weak IBOutlet NSLayoutConstraint *backBtnWidthConstraint;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UITextView *noteTextView;
    __weak IBOutlet UITextView *selectedTextTextView;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfSelectedTextView;
    __weak IBOutlet UIView *seletedTextContainerView;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfNoteText;
    __weak IBOutlet NSLayoutConstraint *widthConstraintOfDropDownButton;
}
@end

@implementation KBShareSettingsController

#pragma mark UIView Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateFont];
    [self updateViewForNoteShare];
    _userArray = [[NSMutableArray alloc] init];
    _shareUserListTable.tag = SharedUserListTableTag;
    
    _shareUserListTable.delegate = self;
    _shareUserListTable.dataSource = self;
    
    [self registerCellForTable];
    [self updateView];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    [self setAccessibilityForShareSettingsElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
    [self getDataForIndex:0];
    [self updateButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
   [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

            } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
               
                  if (_settingsType == kHighlightShareSettings)
                         {
                             headerViewLeadingConstraint.constant = 0;
                         }
                
              }];
}
#pragma mark Update UI

-(void)updateFont
{
    [_cancelButton.titleLabel setFont:getCustomFontForWeight(16, UIFontWeightLight)];
    [_doneButton.titleLabel setFont:getCustomFontForWeight(16, UIFontWeightLight)];
    [headerTitleBtn.titleLabel setFont:getCustomFontForWeight(20, UIFontWeightLight)];
    [_classNameButton.titleLabel setFont:getCustomFontForWeight(16, UIFontWeightLight)];
    [_noDataLabel setFont:getCustomFontForWeight(16, UIFontWeightLight)];
    [_receiveLabel setFont:getCustomFontForWeight(16, UIFontWeightLight)];
    [_topShareLabel setFont:getCustomFontForWeight(16, UIFontWeightLight)];
    [noteTextView setFont:getCustomFontForWeight(17, UIFontWeightLight)];
    [backBtn.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:26.0]];
}
- (void)updateView
{
    _doneButton.userInteractionEnabled = NO;
    _doneButton.alpha = 0.5f;
    _shareUserListTable.superview.backgroundColor = _themeVO.settings_background;
    _shareUserListTable.backgroundColor = _themeVO.settings_background;
    _classContainerView.layer.borderWidth = 1.0f;
    [_shareAllButton setTitle:ICON_UNCHECKEDBOX forState:UIControlStateNormal];
    [_shareAllButton setTitle:ICON_CHECKEDBOX forState:UIControlStateSelected];
    [_receiveAllButton setTitle:ICON_CHECKEDBOX forState:UIControlStateSelected];
    [_receiveAllButton setTitle:ICON_UNCHECKEDBOX forState:UIControlStateNormal];

    UIButton *selectedClassBTn = (UIButton *)[self.view viewWithTag:SelectedClassBtnTag];
    UIButton *dropDownClassBTn = (UIButton *)[self.view viewWithTag:dropDownClassBtnTag];
    [dropDownClassBTn setTitleColor:_themeVO.settings_icon_color forState:UIControlStateNormal];
    [selectedClassBTn setTitleColor:_themeVO.settings_text_color forState:UIControlStateNormal];
    [selectedClassBTn setTitleColor:_themeVO.settings_text_color forState:UIControlStateSelected];
    _classNameButton.backgroundColor = _themeVO.settings_background;
    [_classNameButton setTitleColor:_themeVO.settings_text_color forState:UIControlStateNormal];
    _classNameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    UIView *classHolderView = [self getButtonWithTag:ClassListViewTag];
    if(isRTL()){
        _classNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    if (_classList && _classList.count > 1)
    {
       classHolderView.layer.borderWidth = _classNameButton.layer.borderWidth = _dropDownButton.layer.borderWidth = 1.0;
        _noDataLabel.hidden = YES;
        _shareUserListTable.hidden = YES;
    }
    else if(_classList && _classList.count == 1)
    {
        _classNameButton.userInteractionEnabled = _dropDownButton.userInteractionEnabled = NO;
        _dropDownButton.hidden = YES;
        widthConstraintOfDropDownButton.constant = 0;
    }
    else
    {
        _noDataLabel.hidden = NO;
        _allSelectionHolderView.hidden = YES;
        _shareUserListTable.hidden = YES;
    }
  
    _doneButton.layer.cornerRadius = _cancelButton.layer.cornerRadius = 4;
    _cancelButton.layer.borderWidth = 1;
    _bottomBarView.layer.masksToBounds = NO;
    _bottomBarView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _bottomBarView.layer.borderColor = [UIColor lightTextColor].CGColor;
    _bottomBarView.layer.shadowOffset = CGSizeMake(0,-2);
    _bottomBarView.layer.shadowOpacity = 0.4;
    _bottomBarView.layer.borderWidth = 0.4;
    _bottomBarView.layer.shadowRadius = 1;
}

-(UIView *)getButtonWithTag:(NSInteger)tag{
    return [self.view viewWithTag:tag];
}

- (void)updateButton
{
    NSArray *filterdArray = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isShared = 0"]];
    if (filterdArray.count == 0)
    {
        _shareAllButton.selected = YES;
      
    }
    else
    {
        _shareAllButton.selected = NO;
    }
    filterdArray = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isReceived = 0"]];
    if (filterdArray.count == 0)
    {
        _receiveAllButton.selected = YES;
     
    }
    else
    {
        _receiveAllButton.selected = NO;

    }
    filterdArray = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isShared = 1 OR SELF.isReceived = 1"]];
    filterdArray = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isShared = 1 OR SELF.isReceived = 1"]];
    if (_settingsType == NoteShareSettings)
    {
        filterdArray = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isNoteShared = 1"]];
    }
}

- (void)getDataForIndex:(NSInteger) index
{
    if (_classList)
    {
        if (_userArray)
        {
            [_userArray removeAllObjects];
        }
        
        _selectedClass = _classList[index];
        _userDictionary = [NSMutableDictionary dictionaryWithDictionary:[_bookClassInfo getUserListArray:_classList forUser:_bookClassInfo.userId andWithIndex:index]];
        UIButton *btn = (UIButton*)[self.view viewWithTag:SelectedClassBtnTag];
        [btn setTitle:_selectedClass.classTitle forState:UIControlStateNormal];
        if (_settingsType ==  NoteShareSettings)
        {
            if (!noteSharedArray)
            {
                noteSharedArray = [[NSMutableArray alloc] init];
            }
            if (!sharedArray)
            {
                sharedArray = [[NSMutableArray alloc]init];
            }
            
            if (_highlightVO.sharedUsers || [_highlightVO.sharedUsers count] > 0)
            {
                NSArray *studentsArray = [_userDictionary valueForKey:@"students"];
                NSArray *teachersArray = [_userDictionary valueForKey:@"teachers"];
                NSMutableArray *studentIDS = [[NSMutableArray alloc] init];
                NSMutableArray *teacherIDS = [[NSMutableArray alloc] init];
                for (KitabooSharedUserInfo *student in studentsArray)
                {
                    [studentIDS addObject:student.userId];
                }
                for (KitabooSharedUserInfo *teacher in teachersArray)
                {
                    [teacherIDS addObject:teacher.userId];
                }
                for (NSNumber *userID in _highlightVO.sharedUsers)
                {
                    if([studentIDS containsObject:userID] || [teacherIDS containsObject:userID])
                    {
                        if (![noteSharedArray containsObject:userID])
                        {
                            [noteSharedArray addObject:userID];
                        }
                        if ( ![sharedArray containsObject:userID])
                        {
                            [sharedArray addObject:userID];
                        }
                        
                    }
                }
            }
        }
        if (![_selectedClass.shareHighlightConfiguration isSharingEnable])
        {
            _noDataLabel.hidden = NO;
            _shareUserListTable.hidden = YES;
            _noDataLabel.text = [LocalizationHelper localizedStringWithKey:@"ANNOTATIONS_SHARING_NOT_ALLOWED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
            _shareAllButton.userInteractionEnabled = NO;
            _receiveAllButton.userInteractionEnabled = NO;
        }
        //To handle when there are no users available to share
        else if (!_userDictionary || _userDictionary.allKeys.count==0)
        {
            _noDataLabel.hidden = NO;
            _shareUserListTable.hidden = YES;
            _noDataLabel.text = [LocalizationHelper localizedStringWithKey:@"ANNOTATIONS_SHARING_NOT_ALLOWED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
            _shareAllButton.userInteractionEnabled = NO;
            _receiveAllButton.userInteractionEnabled = NO;
        }
        else
        {
            if(_userArray.count!=0)
            {
                [_userArray removeAllObjects];
            }
            _noDataLabel.hidden = YES;
            _shareUserListTable.hidden = NO;
            if ([_selectedClass.shareHighlightConfiguration isTeacherSharingEnable])
            {
                NSArray *teachers = [_userDictionary valueForKey:@"teachers"];
                for (KitabooSharedUserInfo *teacher in teachers)
                {
                    [_userArray addObject:teacher];
                    if (![highlightSharedArray containsObject:teacher.userId]) {
                        [highlightSharedArray addObject:teacher.userId];
                    }
                    if (![highlightReceivedArray containsObject:teacher.userId]) {
                        [highlightReceivedArray addObject:teacher.userId];
                    }
                }
            }
            else
            {
                [_userDictionary removeObjectForKey:@"teachers"];
            }
            if([_selectedClass.shareHighlightConfiguration isStudentSharingEnable])
            {
                NSArray *students = [_userDictionary valueForKey:@"students"];
                for (KitabooSharedUserInfo *student in students)
                {
                    [_userArray addObject:student];
                }
            }
            else
            {
                [_userDictionary removeObjectForKey:@"students"];
            }
        }
        
        if (_settingsType == HighlightShareSettings)
        {
            for (KitabooSharedUserInfo *userInfo in _userArray)
            {
                if ([highlightSharedArray containsObject:userInfo.userId])
                {
                    userInfo.isShared = YES;
                }
                else
                {
                    userInfo.isShared = NO;
                }
                if ([highlightReceivedArray containsObject:userInfo.userId])
                {
                    userInfo.isReceived = YES;
                }
                else
                {
                    userInfo.isReceived = NO;
                }
            }
        }
        NSArray *teachersArray = [_userDictionary valueForKey:@"teachers"];
        NSArray *teacherIds = [teachersArray valueForKey:@"userId"];
        
        NSSet *allTeacherSelectedSet = [NSSet setWithArray:sharedArray];
        NSSet *teacherSet = [NSSet setWithArray:teacherIds];
        
        NSArray *studentsArray = [_userDictionary valueForKey:@"students"];
        NSArray *studentIds = [studentsArray valueForKey:@"userId"];
        
        NSSet *allstudentSelectedSet = [NSSet setWithArray:sharedArray];
        NSSet *studentsSet = [NSSet setWithArray:studentIds];
        
        _isStudentAllCollabratedUsers = [studentsSet isSubsetOfSet:allstudentSelectedSet];
        _isTeacherAllCollabratedUsers = [teacherSet isSubsetOfSet:allTeacherSelectedSet];
        
        //Multiple Classes
        NSSet *allTeacherSelectedSett = [NSSet setWithArray:noteSharedArray];
        NSSet *teacherSett = [NSSet setWithArray:teacherIds];
        
        NSSet *allstudentSelectedSett = [NSSet setWithArray:noteSharedArray];
        NSSet *studentsSett = [NSSet setWithArray:studentIds];
        
        _isCurrentStudentAllCollabratedUsers = [studentsSett isSubsetOfSet:allstudentSelectedSett];
        _isCurrentTeacherAllCollabratedUsers = [teacherSett isSubsetOfSet:allTeacherSelectedSett];
        
        if (_isStudentAllCollabratedUsers || _isCurrentStudentAllCollabratedUsers)
        {
            _isAllStudentsSelected = YES;
        }
        else
        {
            _isAllStudentsSelected = NO;
        }
        if (_isTeacherAllCollabratedUsers || _isCurrentTeacherAllCollabratedUsers)
        {
            _isAllTeachersSelected = YES;
        }
        else
        {
            _isAllTeachersSelected = NO;
        }
    }
}

- (void)updateViewForNoteShare
{
    if(isRTL()){
        headerTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    [[headerView.subviews objectAtIndex:0] setBackgroundColor:_themeVO.settings_background];
    _allSelectionHolderView.backgroundColor = containerView.backgroundColor = _shareUserListTable.backgroundColor = _themeVO.settings_background;
    [headerTitleBtn setTitleColor:_themeVO.settings_header_title_color forState:UIControlStateNormal];
    [backBtn setTitleColor:_themeVO.settings_header_title_color forState:UIControlStateNormal];
    [headerTitleBtn setTitle:[LocalizationHelper localizedStringWithKey:@"SHARE_NOTE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController] forState:UIControlStateNormal];
    _bottomBarView.backgroundColor = _themeVO.share_shareSettings_bottom_background;
    [_cancelButton setTitleColor:_themeVO.settings_cancel_button_text_color forState:UIControlStateNormal];
    _cancelButton.layer.borderColor = _themeVO.settings_cancel_button_border_color.CGColor;
    [_cancelButton setTitle:[LocalizationHelper localizedStringWithKey:@"CANCEL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController] forState:UIControlStateNormal];
    [_doneButton setTitleColor:_themeVO.settings_done_button_text_color forState:UIControlStateNormal];
    _doneButton.backgroundColor = _themeVO.settings_done_button_background;
    [_doneButton setTitle:[LocalizationHelper localizedStringWithKey:@"DONE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController] forState:UIControlStateNormal];
    selectedTextTextView.textColor = _themeVO.note_contextualtext_color;
    noteTextView.textColor = _themeVO.note_description_color;
    if (_settingsType == kHighlightShareSettings)
    {
        _settingsLabel.text = [LocalizationHelper localizedStringWithKey:@"SETTINGS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
        _topRecieveIconView.hidden = NO;
        _topShareIconView.hidden = NO;
        noteTextView.hidden = NO;
        heightConstraintOfSelectedTextView.constant = 0;
        heightConstraintOfNoteText.constant = 0;
        seletedTextContainerView.hidden = YES;
        _topShareLabel.text = [LocalizationHelper localizedStringWithKey:@"SHARE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
        _receiveLabel.text = [LocalizationHelper localizedStringWithKey:@"MY_DATA_RECEIVE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
        _receiveLabel.textColor = _topShareLabel.textColor = _themeVO.settings_text_color;
        _classListViewLeadingConstraint.constant = 8.0f;
        _classListHolderViewHeightConstraint.constant = 40;
        headerViewLeadingConstraint.constant = 0;
        [headerTitleBtn setTitle: NSLocalizedStringFromTableInBundle(@"SETTINGS", READER_LOCALIZABLE_TABLE, LocalizationBundleForKBShareSettingsController, nil) forState:UIControlStateNormal];
        _receiveAllButton.titleLabel.font = _shareAllButton.titleLabel.font = DefualtFont(isIpad()?22:18);
        [_receiveAllButton setTitleColor:_themeVO.settings_check_color forState:UIControlStateNormal];
        [_shareAllButton setTitleColor:_themeVO.settings_check_color forState:UIControlStateNormal];
        [_receiveAllButton setTitleColor:_themeVO.share_shareSettings_all_box_border_color forState:UIControlStateSelected];
        [_shareAllButton setTitleColor:_themeVO.share_shareSettings_all_box_border_color forState:UIControlStateSelected];
        _classContainerView.layer.borderColor = _themeVO.settings_box_border_color.CGColor;
        //headerView.backgroundColor = _themeVO.settings_header_title_color;
        bottomConstraintOfHeaderView.constant = 0.4;
        if(isIpad())
        [self setupForIpad];
    }
    else if (_settingsType == kNoteShareSettings)
    {
        [[headerView.subviews objectAtIndex:0] setBackgroundColor:_themeVO.settings_background];
        _allSelectionHolderView.backgroundColor = containerView.backgroundColor = _shareUserListTable.backgroundColor = _themeVO.settings_background;
        _settingsLabel.text = [LocalizationHelper localizedStringWithKey:@"SHARE_NOTE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
        _topRecieveIconView.hidden = YES;
        _topShareIconView.hidden = YES;
        noteTextView.hidden = NO;
        
        noteTextView.text = self.noteText.length > 0 ? self.noteText : self.highlightVO.noteText;
        noteTextView.contentInset =  UIEdgeInsetsZero;
        [noteTextView scrollsToTop];
        heightConstraintOfNoteText.constant = noteTextView.contentSize.height > 50.0 ? 50.0: noteTextView.contentSize.height;
        selectedTextTextView.contentOffset = CGPointZero;
        selectedTextTextView.contentInset =  UIEdgeInsetsZero;
        if (self.highlightVO.text.length > 0){
            [seletedTextContainerView setHidden:NO];
            selectedTextTextView.text = self.highlightVO.text;
            heightConstraintOfSelectedTextView.constant = selectedTextTextView.contentSize.height > 68 ? 68 : selectedTextTextView.contentSize.height < 45 ? 45 :selectedTextTextView.contentSize.height;
            [selectedTextTextView setScrollsToTop:YES];
        }
        else{
            [seletedTextContainerView setHidden:NO];
            selectedTextTextView.text = @"";
            heightConstraintOfSelectedTextView.constant = 0;
        }
        _topShareLabel.text = @"";
        _receiveLabel.textColor = _topShareLabel.textColor = _themeVO.share_shareSettings_text_color;
        _receiveAllButton.titleLabel.font = _shareAllButton.titleLabel.font = DefualtFont(isIpad()?22:18);
        [_receiveAllButton setTitleColor:_themeVO.share_shareSettings_all_box_border_color forState:UIControlStateSelected];
        [_shareAllButton setTitleColor:_themeVO.share_shareSettings_all_box_border_color forState:UIControlStateSelected];
        headerView.backgroundColor = [UIColor colorWithHexString:(self.selectedColor == nil)?_highlightVO.backgroundColor:self.selectedColor];
        _classContainerView.layer.borderColor = _themeVO.share_shareSettings_box_border_color.CGColor;
        _classListHolderViewHeightConstraint.constant = 0;
        _allSelectionHolderView.hidden = YES;
        if(self.isFromMydataController && isIpad()){
             headerViewLeadingConstraint.constant = 0;
            [self setupForIpad];
        }
        else if(isIpad()){
            heightConstraintOfContainer.active = NO;
            widthConstraintOfContainer.active = NO;
            [containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
            [containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        }
    }
    [self.view layoutIfNeeded];
}

- (void)registerCellForTable
{
    
    UINib *sharingCell = [UINib  nibWithNibName:@"KBShareSettingsCell"
                                         bundle:[NSBundle bundleForClass:[self class]]];
    [_shareUserListTable registerNib:sharingCell
              forCellReuseIdentifier:@"KBShareSettingsCell"];
}

/**
 To Show Alert with Title and Message
 */
-(void)showAlertWithTitle:(NSString*)title WithMessage:(NSString*)message
{
    [[AlertView sharedManager] presentAlertWithTitle:title message:message andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
    }];
}

#pragma mark Set data
- (void)setData:(NSArray *)data
{
    if(data && data.count)
    {
        _bookClassInfo = [data objectAtIndex:0];
        _classList = data;
    }
    if (_settingsType == HighlightShareSettings)
    {
        highlightSharedArray = [[NSMutableArray alloc] init];
        highlightReceivedArray = [[NSMutableArray alloc] init];
        for (SDKBookClassInfoVO *bookClass in _classList)
        {
            for (NSNumber *userID in bookClass.shareList)
            {
                if (![highlightSharedArray containsObject:userID])
                {
                    [highlightSharedArray addObject:userID];
                }
            }
            for (NSNumber *userID in bookClass.receiveList)
            {
                if (![highlightReceivedArray containsObject:userID])
                {
                    [highlightReceivedArray addObject:userID];
                }
            }
        }
    }
}

#pragma mark Action Methods
- (IBAction)doneButtonTapped:(UIButton *)sender
{
    if (_settingsType == HighlightShareSettings){
        if ([[KitabooNetworkManager getInstance] isInternetAvailable])
        {
            [self saveShareSettings];
            if(_settingsType == kHighlightShareSettings && isIpad())
                [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self showAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController] WithMessage:[LocalizationHelper localizedStringWithKey:@"INTERNET_UNAVAILABLE_MESSAGE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController]];
        }
    }
    else
    {
//    [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"SHARE_NOTE"] message:[LocalizationHelper localizedStringWithKey:@"ARE_YOU_SURE_YOU_WANT_TO_SHARE_THIS_NOTE_ALERT"] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"CANCEL"],[LocalizationHelper     localizedStringWithKey:@"OK"]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//        if([buttonTitle isEqualToString:[LocalizationHelper localizedStringWithKey:@"OK"]]){
//            [self saveShareSettings];
//            if(isIpad())
//                [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
    [self saveShareSettings];
    if(isIpad())
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}


- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickOnShareSettingsCancelButton)])
    {
        [_delegate didClickOnShareSettingsCancelButton];
    }
    if(self.isFromMydataController && isIpad()){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(_settingsType == kHighlightShareSettings && isIpad())
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)classListButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
   ((UIButton *)[self.view viewWithTag:dropDownClassBtnTag]).selected =((UIButton *)[self.view viewWithTag:SelectedClassBtnTag]).selected = _classNameButton.selected = _dropDownButton.selected = sender.selected;
    
    classArray = [[NSMutableArray alloc]init];
    for(int i =0; i<_classList.count; i++)
    {
        SDKBookClassInfoVO *classInfo = _classList[i];
        [classArray insertObject:classInfo.classTitle atIndex:i];
    }
    if (sender.selected)
    {
        [_dropDownButton setTitle:ICON_UPARROW forState:UIControlStateNormal];
        [_dropDownButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:16.0f]];
        CGRect frameForDropDown = [self.view convertRect:_classContainerView.frame fromView:_classContainerView.superview] ;
        dropdowncontroller = [[HDDropDownController alloc] initWithDataArray:classArray dropDownFrame:CGRectMake(frameForDropDown.origin.x, frameForDropDown.origin.y + _classContainerView.frame.size.height, frameForDropDown.size.width, 150)];
        dropdowncontroller.delegate = self;
        dropdowncontroller.view.layer.borderWidth = 1;
        dropdowncontroller.view.layer.borderColor = _themeVO.settings_box_border_color.CGColor;
        
        [self.view addSubview:dropdowncontroller.view];
        [self addChildViewController:dropdowncontroller];
    }
    else
    {
        [_dropDownButton setTitle:ICON_DOWNARROW forState:UIControlStateNormal];
        [_dropDownButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:16.0f]];
        [dropdowncontroller.view removeFromSuperview];
        [dropdowncontroller removeFromParentViewController];
    }
}

- (IBAction)shareAllButtonTapped:(UIButton *)sender
{
    _doneButton.userInteractionEnabled = YES;
    _doneButton.alpha = 1.0f;
    sender.selected = !sender.selected;
//    [_shareAllButton setTitleColor:themeColor forState:UIControlStateSelected];
    [self shareAll:sender.selected];
    [_shareUserListTable reloadData];
    [self updateButton];
}

- (IBAction)receiveAllButtonTapped:(UIButton *)sender
{
    _doneButton.userInteractionEnabled = YES;
    _doneButton.alpha = 1.0f;
    sender.selected = !sender.selected;
//    [_receiveAllButton setTitleColor:themeColor forState:UIControlStateSelected];
    [self receiveAll:sender.selected];
    [_shareUserListTable reloadData];
    [self updateButton];
}


#pragma mark Tableview delegate and datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == SharedUserListTableTag && [_selectedClass.shareHighlightConfiguration isSharingEnable])
    {
        
        if ([_selectedClass.shareHighlightConfiguration isTeacherSharingEnable] && [_selectedClass.shareHighlightConfiguration isStudentSharingEnable] && _userDictionary.count > 1)
        {
            return 2;
        }
        else if(([_selectedClass.shareHighlightConfiguration isTeacherSharingEnable] || [_selectedClass.shareHighlightConfiguration isStudentSharingEnable]))
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == SharedUserListTableTag)
    {
        NSArray *allKeys = [_userDictionary allKeys];
        if (allKeys.count > 0)
        {
            if ([allKeys[section]  isEqualToStringIgnoreCase: @"teachers"] && _userDictionary.count > 0 && [_selectedClass.shareHighlightConfiguration isTeacherSharingEnable])
            {
                NSArray *teachers = [_userDictionary valueForKey:@"teachers"];
                return teachers.count;
            }
            else if( [allKeys[section]  isEqualToStringIgnoreCase: @"students"] && _userDictionary.count > 0 && [_selectedClass.shareHighlightConfiguration isStudentSharingEnable])
            {
                NSArray *students = [_userDictionary valueForKey:@"students"];
                return students.count;
            }
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == SharedUserListTableTag)
    {
        return [self tableView:tableView shareUserCellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)didSelectItemWithName:(NSString *)name
{
    NSInteger index = [classArray indexOfObjectIdenticalTo:name];
    _bookClassInfo = [_classList objectAtIndex:index];
    [self getDataForIndex:index];
    [_shareUserListTable reloadData];
    [self updateButton];
    [dropdowncontroller.view removeFromSuperview];
    [dropdowncontroller removeFromParentViewController];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KBShareSettingsCell *shareSettingsCell = [tableView dequeueReusableCellWithIdentifier:@"KBShareSettingsCell"];
    if (!shareSettingsCell)
    {
        shareSettingsCell = [[KBShareSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KBShareSettingsCell"];
    }
    shareSettingsCell.backgroundColor = _themeVO.settings_background;
    [shareSettingsCell.shareUserNameLabel setFont:getCustomFont(18.0f)];
    shareSettingsCell.shareUserNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    shareSettingsCell.delegate = self;
    shareSettingsCell.usernameLblLeadingConstraint.constant = isIpad()? 18 : 14;
    shareSettingsCell.shareButton.titleLabel.font = DefualtFont(isIpad()? 22:18);
    shareSettingsCell.receiveButton.titleLabel.font = DefualtFont(isIpad()? 22:18);

    UIColor *titleTextColor,*boxBorderColor,*checkBoxColor;
    if (_settingsType == kHighlightShareSettings)
    {
        shareSettingsCell.accessibilityIdentifier = [NSString stringWithFormat:@"highlightShareSettingsCellHeader%ld", (long)section];
        shareSettingsCell.shareButton.accessibilityIdentifier = [NSString stringWithFormat:@"highlightShareSettingsCellHeaderShareBtn%ld", (long)section];
        shareSettingsCell.receiveButton.accessibilityIdentifier = [NSString stringWithFormat:@"highlightShareSettingsCellHeaderReceiveBtn%ld", (long)section];
        shareSettingsCell.sharingButtonLeadingConstraint.constant = 78.0f;
        shareSettingsCell.shareButton.hidden = NO;
        shareSettingsCell.receiveButton.hidden = NO;
        titleTextColor = _themeVO.settings_section_title_color;
        boxBorderColor = _themeVO.share_shareSettings_all_box_border_color;
        checkBoxColor = _themeVO.settings_check_color;
    }
    else if (_settingsType == kNoteShareSettings)
    {
        shareSettingsCell.accessibilityIdentifier = [NSString stringWithFormat:@"noteShareSettingsCellHeader%ld", (long)section];
        shareSettingsCell.shareButton.accessibilityIdentifier = [NSString stringWithFormat:@"noteShareSettingsCellHeaderShareBtn%ld", (long)section];
        shareSettingsCell.sharingButtonLeadingConstraint.constant = -24.0f;
        shareSettingsCell.shareButton.hidden = NO;
        shareSettingsCell.receiveButton.hidden = YES;
        titleTextColor = _themeVO.share_shareSettings_section_title_color;
        boxBorderColor = _themeVO.share_shareSettings_all_box_border_color;
        checkBoxColor = _themeVO.share_shareSettings_check_color;
    }
    [shareSettingsCell.shareButton setTitleColor:boxBorderColor forState:UIControlStateNormal];
    [shareSettingsCell.shareButton setTitleColor:boxBorderColor forState:UIControlStateHighlighted];
    [shareSettingsCell.shareButton setTitleColor:boxBorderColor forState:UIControlStateSelected];
    [shareSettingsCell.shareButton setTitle:ICON_CHECKEDBOX forState:UIControlStateSelected];
    [shareSettingsCell.shareButton setTitle:ICON_UNCHECKEDBOX forState:UIControlStateNormal];

    [shareSettingsCell.receiveButton setTitleColor:boxBorderColor forState:UIControlStateNormal];
    [shareSettingsCell.receiveButton setTitleColor:boxBorderColor forState:UIControlStateHighlighted];
    [shareSettingsCell.receiveButton setTitleColor:boxBorderColor forState:UIControlStateSelected];
    [shareSettingsCell.receiveButton setTitle:ICON_CHECKEDBOX forState:UIControlStateSelected];
    [shareSettingsCell.receiveButton setTitle:ICON_UNCHECKEDBOX forState:UIControlStateNormal];

    shareSettingsCell.shareUserNameLabel.textColor = titleTextColor;
//    shareSettingsCell.shareButton.layer.borderColor = shareSettingsCell.receiveButton.layer.borderColor = boxBorderColor.CGColor;

    NSArray *allKeys = [_userDictionary allKeys];
    if (allKeys.count > 0)
    {
        if ([allKeys[section] isEqualToStringIgnoreCase: @"Teachers"])
        {
            shareSettingsCell.shareUserNameLabel.text = [LocalizationHelper localizedStringWithKey:@"ALL TEACHERS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
            if (_settingsType == HighlightShareSettings)
            {
                shareSettingsCell.shareButton.selected = YES;
                shareSettingsCell.receiveButton.selected = YES;
                shareSettingsCell.shareButton.userInteractionEnabled = shareSettingsCell.receiveButton.userInteractionEnabled = NO;
                shareSettingsCell.shareButton.layer.opacity = 0.5;
                shareSettingsCell.shareButton.layer.opacity = shareSettingsCell.receiveButton.layer.opacity = 0.5;
            }
            else if (_settingsType == NoteShareSettings)
            {
                if (_isTeacherAllCollabratedUsers)
                {
                    shareSettingsCell.shareButton.selected = YES;
                    shareSettingsCell.shareButton.userInteractionEnabled = NO;
                    shareSettingsCell.shareButton.alpha = 0.5f;
                    shareSettingsCell.shareButton.layer.opacity = 0.5f;
                }
                else
                {
                    shareSettingsCell.shareButton.selected = _isAllTeachersSelected;
                    shareSettingsCell.shareButton.userInteractionEnabled = YES;
                    shareSettingsCell.shareButton.alpha = 1.0f;
                    shareSettingsCell.shareButton.layer.opacity = 1.0f;
                }
                shareSettingsCell.shareButton.tag = kCellTypeTeacherHeader;
                shareSettingsCell.receiveButton.selected = NO;
                _isNoteSharing = YES;
            }
        }
        
        else if ([allKeys[section] isEqualToStringIgnoreCase: @"Students"])
        {
            shareSettingsCell.shareUserNameLabel.text = [LocalizationHelper localizedStringWithKey:@"ALL_STUDENTS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBShareSettingsController];
            
            if (_settingsType == HighlightShareSettings)
            {
                shareSettingsCell.shareButton.layer.hidden = YES;
            }
            else if (_settingsType == NoteShareSettings)
            {
                
                if (_isStudentAllCollabratedUsers)
                {
                    shareSettingsCell.shareButton.selected = YES;
                    shareSettingsCell.shareButton.userInteractionEnabled = NO;
                    shareSettingsCell.shareButton.alpha = 0.5f;
                    shareSettingsCell.shareButton.layer.opacity = 0.5f;
                }
                else if (_isCurrentStudentAllCollabratedUsers)
                {
                    shareSettingsCell.shareButton.selected = _isAllStudentsSelected;
                    shareSettingsCell.shareButton.userInteractionEnabled = _isAllStudentsSelected;
                    shareSettingsCell.shareButton.alpha = 1.0f;
                    shareSettingsCell.shareButton.layer.opacity = 1.0f;
                }
                else
                {
                    shareSettingsCell.shareButton.selected = _isAllStudentsSelected;
                    shareSettingsCell.shareButton.userInteractionEnabled = YES;
                    shareSettingsCell.shareButton.alpha = 1.0f;
                    shareSettingsCell.shareButton.layer.opacity = 1.0f;
                }
                shareSettingsCell.shareButton.tag = kCellTypeStudentHeader;
                shareSettingsCell.receiveButton.selected = NO;
                shareSettingsCell.shareButton.layer.hidden = NO;
                _isNoteSharing = YES;
            }
            
            shareSettingsCell.receiveButton.layer.hidden = YES;
        }
    }
    
    
    return shareSettingsCell;
}

- (void)didShareNoteWillAllStudents:(UIButton *)sender
{
    //    if(sender.selected)
    //    {
    //        _doneButton.userInteractionEnabled = YES;
    //        _doneButton.alpha = 1.0f;
    //    }
    //    else
    //    {
    //        _doneButton.userInteractionEnabled = NO;
    //        _doneButton.alpha = 0.5f;
    //    }
    NSArray *userIds = nil;
    sender.selected = !sender.selected;
    if (sender.selected == NO)
    {
        _isAllStudentsSelected = YES;
    }
    else
    {
        _isAllStudentsSelected = NO;
    }
    NSArray *userArray = [_userDictionary valueForKey:@"students"];
    userIds = [userArray valueForKey:@"userId"];
    for (NSNumber *userId in userIds)
    {
        NSInteger index = [_userArray indexOfObjectPassingTest:^BOOL(KitabooSharedUserInfo *sharedUser, NSUInteger idx, BOOL * _Nonnull stop)
                           {
                               if ([sharedUser.userId integerValue] == [userId integerValue])
                               {
                                   *stop = YES;
                                   return YES;
                               }
                               return NO;
                           }];
        KitabooSharedUserInfo *sharedUser = _userArray[index];
        if (noteSharedArray == nil)
        {
            noteSharedArray = [[NSMutableArray alloc] init];
        }
        if (_isAllStudentsSelected)
        {
            if (![noteSharedArray containsObject:sharedUser.userId])
            {
                sharedUser.isNoteShared = YES;
                [noteSharedArray addObject:sharedUser.userId];
            }
        }
        else
        {
            if ([noteSharedArray containsObject:sharedUser.userId]&&![_highlightVO.sharedUsers containsObject:sharedUser.userId])
            {
                sharedUser.isNoteShared = NO;
                [noteSharedArray removeObject:sharedUser.userId];
                _doneButton.userInteractionEnabled = NO;
                _doneButton.alpha = 0.5f;
            }
            if(_isAllTeachersSelected)
            {
                _doneButton.userInteractionEnabled = YES;
                _doneButton.alpha = 1.0f;
            }
        }
        [self updateButton];
    }
    if(noteSharedArray.count > _highlightVO.sharedUsers.count)
    {
        _doneButton.userInteractionEnabled = YES;
        _doneButton.alpha = 1.0f;
    }
    else if(noteSharedArray.count < _highlightVO.sharedUsers.count)
    {
        _doneButton.userInteractionEnabled = NO;
        _doneButton.alpha = 0.5f;
    }
    else
    {
        _doneButton.userInteractionEnabled = NO;
        _doneButton.alpha = 0.5f;
    }
    [_shareUserListTable reloadData];
}

- (void)didShareNoteWillAllTeachers:(UIButton *)sender
{
    _doneButton.userInteractionEnabled = YES;
    _doneButton.alpha = 1.0f;
    NSArray *userIds = nil;
    sender.selected = !sender.selected;
    if (sender.selected == NO)
    {
        _isAllTeachersSelected = YES;
    }
    else
    {
        _isAllTeachersSelected = NO;
    }
    NSArray *userArray = [_userDictionary valueForKey:@"teachers"];
    userIds = [userArray valueForKey:@"userId"];
    for (NSNumber *userId in userIds)
    {
        NSInteger index = [_userArray indexOfObjectPassingTest:^BOOL(KitabooSharedUserInfo *sharedUser, NSUInteger idx, BOOL * _Nonnull stop)
                           {
                               if ([sharedUser.userId integerValue] == [userId integerValue])
                               {
                                   *stop = YES;
                                   return YES;
                               }
                               return NO;
                           }];
        if(noteSharedArray == nil)
        {
            noteSharedArray = [[NSMutableArray alloc]init];
        }
        if (_isAllTeachersSelected)
        {
            KitabooSharedUserInfo *sharedUser = _userArray[index];
            if (noteSharedArray == nil)
            {
                noteSharedArray = [[NSMutableArray alloc] init];
            }
            if (![noteSharedArray containsObject:sharedUser.userId])
            {
                sharedUser.isNoteShared = YES;
                [noteSharedArray addObject:sharedUser.userId];
            }
            [self updateButton];
        }
        else{
            KitabooSharedUserInfo *sharedUser = _userArray[index];
            if ([noteSharedArray containsObject:sharedUser.userId])
            {
                sharedUser.isNoteShared = NO;
                [noteSharedArray removeObject:sharedUser.userId];
                if(noteSharedArray.count == 0){
                    _doneButton.userInteractionEnabled = NO;
                    _doneButton.alpha = 0.5f;
                }
            }
        }
    }
    [_shareUserListTable reloadData];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.0;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView shareUserCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBShareSettingsCell *shareSettingsCell = [tableView dequeueReusableCellWithIdentifier:@"KBShareSettingsCell"];
    if (!shareSettingsCell)
    {
        shareSettingsCell = [[KBShareSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShareSettingsCell"];
    }
    [shareSettingsCell.shareUserNameLabel setFont:getCustomFont(18.0f)];
    shareSettingsCell.shareButton.titleLabel.font = DefualtFont(isIpad()? 22:18);
    shareSettingsCell.receiveButton.titleLabel.font = DefualtFont(isIpad()? 22:18);
    shareSettingsCell.delegate = self;
    KitabooSharedUserInfo *sharedUser = nil;
    shareSettingsCell.backgroundColor = _themeVO.settings_background;
    NSArray *allKeys = [_userDictionary allKeys];
    shareSettingsCell.usernameLblLeadingConstraint.constant = 30;
    UIColor *settingsBorderColor,*titleTextColor,*checkBoxColor;
    if (_settingsType == kHighlightShareSettings)
    {
        shareSettingsCell.accessibilityIdentifier = [NSString stringWithFormat:@"highlightShareSettingsCell%ld%ld", (long)indexPath.section,(long)indexPath.row];
        shareSettingsCell.shareButton.accessibilityIdentifier = [NSString stringWithFormat:@"highlightShareSettingsCellShareBtn%ld%ld",(long)indexPath.section, (long)indexPath.row];
        shareSettingsCell.receiveButton.accessibilityIdentifier = [NSString stringWithFormat:@"highlightShareSettingsCellReceiveBtn%ld%ld", (long)indexPath.section,(long)indexPath.row];
        shareSettingsCell.sharingButtonLeadingConstraint.constant = 78;
        shareSettingsCell.receiveButton.hidden = NO;
        settingsBorderColor = _themeVO.settings_box_border_color;
        titleTextColor = _themeVO.settings_text_color;
        checkBoxColor = _themeVO.settings_check_color;
    }
    else if (_settingsType == kNoteShareSettings)
    {
        shareSettingsCell.accessibilityIdentifier = [NSString stringWithFormat:@"noteShareSettingsCell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        shareSettingsCell.shareButton.accessibilityIdentifier = [NSString stringWithFormat:@"noteShareSettingsCellShareBtn%ld%ld", (long)indexPath.section, (long)indexPath.row];
        shareSettingsCell.sharingButtonLeadingConstraint.constant = - 24.0f;
        shareSettingsCell.receiveButton.hidden = YES;
        settingsBorderColor = _themeVO.share_shareSettings_box_border_color;
        titleTextColor = _themeVO.share_shareSettings_text_color;
        checkBoxColor = _themeVO.share_shareSettings_check_color;
    }
    [self updateViewForNoteShare];
    
    [shareSettingsCell.shareButton setTitleColor:checkBoxColor forState:UIControlStateNormal];
    [shareSettingsCell.shareButton setTitleColor:checkBoxColor forState:UIControlStateHighlighted];
    [shareSettingsCell.shareButton setTitleColor:checkBoxColor forState:UIControlStateSelected];
    [shareSettingsCell.shareButton setTitle:ICON_CHECKEDBOX forState:UIControlStateSelected];
    [shareSettingsCell.shareButton setTitle:ICON_UNCHECKEDBOX forState:UIControlStateNormal];
    [shareSettingsCell.receiveButton setTitleColor:checkBoxColor forState:UIControlStateNormal];
    [shareSettingsCell.receiveButton setTitleColor:checkBoxColor forState:UIControlStateHighlighted];
    [shareSettingsCell.receiveButton setTitleColor:checkBoxColor forState:UIControlStateSelected];
    [shareSettingsCell.receiveButton setTitle:ICON_CHECKEDBOX forState:UIControlStateSelected];
    [shareSettingsCell.receiveButton setTitle:ICON_UNCHECKEDBOX forState:UIControlStateNormal];
//    shareSettingsCell.shareButton.layer.borderColor = shareSettingsCell.receiveButton.layer.borderColor = settingsBorderColor.CGColor;
    shareSettingsCell.shareButton.tag = kCellTypeNormal;
    shareSettingsCell.shareUserNameLabel.textColor = titleTextColor;

    if ([allKeys[indexPath.section] isEqualToStringIgnoreCase: @"teachers"] && (([_selectedClass.shareHighlightConfiguration isTeacherSharingEnable] && [_selectedClass.shareHighlightConfiguration isStudentSharingEnable] && _userDictionary.count > 1) || (_userDictionary.count == 1 && ([_selectedClass.shareHighlightConfiguration isTeacherSharingEnable] || [_selectedClass.shareHighlightConfiguration isStudentSharingEnable]))))
    {
        
        NSArray *teachers = [_userDictionary valueForKey:@"teachers"];
        sharedUser = teachers[indexPath.row];
        shareSettingsCell.shareUserId = sharedUser.userId;
        shareSettingsCell.shareUserNameLabel.text = sharedUser.fullName;
        shareSettingsCell.shareButton.hidden = YES;
        shareSettingsCell.receiveButton.hidden = YES;
    }
    else if ([allKeys[indexPath.section] isEqualToStringIgnoreCase: @"students"])
    {
        shareSettingsCell.shareButton.hidden = NO;
        shareSettingsCell.receiveButton.hidden = NO;
        NSArray *students = [_userDictionary valueForKey:@"students"];
        sharedUser = students[indexPath.row];
        shareSettingsCell.shareUserId = sharedUser.userId;
        shareSettingsCell.shareUserNameLabel.text = sharedUser.fullName;
        
        if(_settingsType == NoteShareSettings)
        {
            _isNoteSharing = YES;
            shareSettingsCell.receiveButton.hidden = YES;
            if([sharedArray containsObject:sharedUser.userId])
            {
                shareSettingsCell.receiveButton.hidden = YES;
                shareSettingsCell.shareButton.selected = YES;
                shareSettingsCell.userInteractionEnabled = NO;
                shareSettingsCell.shareButton.alpha = 0.5f;
            }
            else if([noteSharedArray containsObject:sharedUser.userId])
            {
                shareSettingsCell.receiveButton.hidden = YES;
                shareSettingsCell.shareButton.selected = YES;
                shareSettingsCell.userInteractionEnabled = YES;
                shareSettingsCell.shareButton.alpha = 1.0f;
            }
            else
            {
                shareSettingsCell.receiveButton.hidden = YES;
                shareSettingsCell.shareButton.selected = sharedUser.isNoteShared;
                shareSettingsCell.userInteractionEnabled = YES;
                shareSettingsCell.shareButton.alpha = 1.0f;
            }
        }
        else
        {
            if ([highlightSharedArray containsObject:sharedUser.userId])
            {
                shareSettingsCell.shareButton.selected = YES;
            }
            else
            {
                shareSettingsCell.shareButton.selected = NO;
            }
            if ([highlightReceivedArray containsObject:sharedUser.userId])
            {
                shareSettingsCell.receiveButton.selected = YES;
            }
            else
            {
                shareSettingsCell.receiveButton.selected = NO;
            }
            shareSettingsCell.shareButton.userInteractionEnabled =YES;
            shareSettingsCell.receiveButton.userInteractionEnabled =YES;
        }
    }
    return shareSettingsCell;
}

#pragma mark Share Settings cell delegate

- (void)didShareSettingEnabled:(BOOL)enabled forUser:(NSNumber *)shareUserId
{
    _doneButton.userInteractionEnabled = YES;
    _doneButton.alpha = 1.0f;
    
    
    NSInteger index = [_userArray indexOfObjectPassingTest:^BOOL(KitabooSharedUserInfo *sharedUser, NSUInteger idx, BOOL * _Nonnull stop)
                       {
                           
                           if ([sharedUser.userId integerValue] == [shareUserId integerValue])
                           {
                               *stop = YES;
                               return YES;
                           }
                           return NO;
                       }];
    
    NSArray *allStudents = [_userDictionary valueForKey:@"students"];
    NSMutableArray *studentIDs = [[NSMutableArray alloc]init];
    
    for (KitabooSharedUserInfo *info in allStudents)
    {
        [studentIDs addObject:info.userId];
    }
    
    NSArray *allTeachers = [_userDictionary valueForKey:@"teachers"];
    NSMutableArray *teachersID = [[NSMutableArray alloc]init];
    
    for (KitabooSharedUserInfo *info in allTeachers)
    {
        [teachersID addObject:info.userId];
    }
    KitabooSharedUserInfo *sharedUser = _userArray[index];
    if (_settingsType == NoteShareSettings)
    {
        if (noteSharedArray == nil)
        {
            noteSharedArray = [[NSMutableArray alloc] init];
        }
        sharedUser.isNoteShared = enabled;
        if (enabled)
        {
            [noteSharedArray addObject:sharedUser.userId];
        }
        else
        {
            if ([noteSharedArray containsObject:sharedUser.userId])
            {
                [noteSharedArray removeObject:sharedUser.userId];
            }
        }
        
        NSMutableArray *currentUserSelectedArray = [[NSMutableArray alloc] init];
        for (KitabooSharedUserInfo *sharedUser in allStudents)
        {
            if ([noteSharedArray containsObject:sharedUser.userId])
            {
                [currentUserSelectedArray addObject:sharedUser];
            }
        }
        
        if(allStudents.count == currentUserSelectedArray.count)
        {
            _isAllStudentsSelected=YES;
        }
        else
        {
            _isAllStudentsSelected=NO;
        }
    }
    else
    {
        sharedUser.isShared = enabled;
        if (enabled)
        {
            if (![highlightSharedArray containsObject:sharedUser.userId])
            {
                [highlightSharedArray addObject:sharedUser.userId];
            }
            
        }
        else
        {
            if ([highlightSharedArray containsObject:sharedUser.userId])
            {
                [highlightSharedArray removeObject:sharedUser.userId];
            }
        }
    }
    NSMutableArray *student = [[NSMutableArray alloc]init];
    NSMutableArray *teacher = [[NSMutableArray alloc]init];
    for (KitabooSharedUserInfo* info in _userArray)
    {
        if([studentIDs containsObject:info.userId])
        {
            [student addObject:info];
        }
        else if([teachersID containsObject:info.userId])
        {
            [teacher addObject:info];
        }
    }
    if(student.count)
        [_userDictionary setObject:student forKey:@"students"];
    if(teacher.count)
        [_userDictionary setObject:teacher forKey:@"teachers"];
    [self updateButton];
    _doneButton.alpha = 1.0f;
    [_shareUserListTable reloadData];
    
    NSArray *shareList = [[NSArray alloc] init];
    if (_settingsType == HighlightShareSettings)
    {
        shareList = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isShared = 1"]];
    }
    else
    {
        [shareList arrayByAddingObjectsFromArray:noteSharedArray];
    }
    NSArray *receiveList = [_userArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isReceived = 1"]];
    
    if (_settingsType == NoteShareSettings) {
        if(noteSharedArray.count <= _highlightVO.sharedUsers.count)
        {
            _doneButton.userInteractionEnabled = NO;
            _doneButton.alpha = 0.5f;
        }
        else
        {
            _doneButton.userInteractionEnabled = YES;
            _doneButton.alpha = 1.0f;
        }
    }
    else
    {
        if (shareList.count || receiveList.count)
        {
            _doneButton.userInteractionEnabled = YES;
            _doneButton.alpha = 1.0f;
        }
        else
        {
            _doneButton.userInteractionEnabled = YES;
        }
    }
}

- (void)didReceiveSettingEnabled:(BOOL)enabled forUser:(NSNumber *)shareUserId
{
    _doneButton.userInteractionEnabled = YES;
    _doneButton.alpha = 1.0f;
    NSInteger index = [_userArray indexOfObjectPassingTest:^BOOL(KitabooSharedUserInfo *sharedUser, NSUInteger idx, BOOL * _Nonnull stop)
                       {
                           if ([sharedUser.userId integerValue] == [shareUserId integerValue])
                           {
                               *stop = YES;
                               return YES;
                           }
                           return NO;
                       }];
    KitabooSharedUserInfo *sharedUser = _userArray[index];
    sharedUser.isReceived = enabled;
    if (enabled)
    {
        [highlightReceivedArray addObject:sharedUser.userId];
    }
    else
    {
        if ([highlightReceivedArray containsObject:sharedUser.userId])
        {
            [highlightReceivedArray removeObject:sharedUser.userId];
        }
    }
    [self updateButton];
}

- (void)shareAll:(BOOL)share
{
    for (KitabooSharedUserInfo *user in [_userDictionary valueForKey:@"students"])
    {
        user.isShared = share;
        if (share)
        {
            if(![highlightSharedArray containsObject:user.userId])
            {
                [highlightSharedArray addObject:user.userId];
            }
        }
        else
        {
            if ([highlightSharedArray containsObject:user.userId])
            {
                [highlightSharedArray removeObject:user.userId];
            }
        }
    }
}

- (void)receiveAll:(BOOL)receive
{
    for (KitabooSharedUserInfo *user in [_userDictionary valueForKey:@"students"])
    {
        user.isReceived = receive;
        if (receive)
        {
            if(![highlightReceivedArray containsObject:user.userId])
            {
                [highlightReceivedArray addObject:user.userId];
            }
        }
        else
        {
            if ([highlightReceivedArray containsObject:user.userId])
            {
                [highlightReceivedArray removeObject:user.userId];
            }
        }
    }
}

- (void)saveShareSettings
{
    _bookClassInfo.shareList = highlightSharedArray;
    _bookClassInfo.receiveList = highlightReceivedArray;
    if (_settingsType == HighlightShareSettings)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(didClickOnShareSettingsSaveButton:)])
        {
            [_delegate didClickOnShareSettingsSaveButton:_bookClassInfo];
        }
    }
    else
    {
        _highlightVO.sharedUsers = [NSArray arrayWithArray:noteSharedArray];
        _highlightVO.isShare = YES;
        _highlightVO.isSynced = NO;
        _highlightVO.isCollabSubmitted = NO;
        if(self.selectedColor != nil && self.noteText.length > 0){
        _highlightVO.backgroundColor =  self.selectedColor;
        _highlightVO.noteText = self.noteText;
        }
//        _highlightVO.modifiedDate = [NSDate date];
        if(_delegate && [_delegate respondsToSelector:@selector(didClickOnNoteShareSettingsSaveButton:)])
        {
            [_delegate didClickOnNoteShareSettingsSaveButton:_highlightVO];
        }
    }
}

-(void)setupForIpad{
    containerView.layer.cornerRadius = 18;
    containerView.clipsToBounds = YES;
    containerView.layer.borderWidth = 0.6;
    containerView.layer.borderColor = _themeVO.settings_header_title_color.CGColor;
    backBtnWidthConstraint.constant = 16;
    backBtn.hidden = YES;
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.view && isIpad() && (self.settingsType == kHighlightShareSettings || self.isFromMydataController)) {
        return YES;
    }
    return NO;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
-(void)dismissController {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickOnShareSettingsCancelButton)])
    {
        [_delegate didClickOnShareSettingsCancelButton];
    }
    if(self.isFromMydataController && isIpad()){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Dealloc
- (void)dealloc
{
    
}

#pragma mark Accessibility
-(void)setAccessibilityForShareSettingsElements
{
    backBtn.accessibilityIdentifier = SHARE_SETTINGS_BACK_BUTTON;
    headerTitleBtn.accessibilityIdentifier = SHARE_SETTINGS_TITLE_BUTTON;
    _classNameButton.accessibilityIdentifier = SHARE_SETTINGS_CLASS_NAME_BUTTON;
    _dropDownButton.accessibilityIdentifier = SHARE_SETTINGS_DROP_DOWN_BUTTON;
    _topShareLabel.accessibilityIdentifier = SHARE_SETTINGS_SHARE_LABEL;
    _shareAllButton.accessibilityIdentifier = SHARE_SETTINGS_SHARE_ALL_BUTTON;
    _receiveLabel.accessibilityIdentifier = SHARE_SETTINGS_RECEIVE_LABEL;
    _receiveAllButton.accessibilityIdentifier = SHARE_SETTINGS_RECEIVE_ALL_BUTTON;
    _cancelButton.accessibilityIdentifier = SHARE_SETTINGS_CANCEL_BUTTON;
    _doneButton.accessibilityIdentifier = SHARE_SETTINGS_DONE_BUTTON;
}
@end
