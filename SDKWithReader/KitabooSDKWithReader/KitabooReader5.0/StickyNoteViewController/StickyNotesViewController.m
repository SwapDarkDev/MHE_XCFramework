//
//  StickyNotesViewController.m
//  Kitaboo
//
//  Created by Priyanka Singh on 24/04/18.
//  Copyright © 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import "StickyNotesViewController.h"
#import "TextHighlightColorBtnCollectionViewCell.h"
#import "StickyNoteCommentCell.h"
#import "ReaderHeader.h"

#define DISPLAY_NAME          @"DisplayName"
#define TEXT                  @"Text"
#define DATE                  @"Date"
#define USER_ID               @"UserID"
#define SAVEBTNTAG            400
#define SelectedTexViewDefaultHt 21
#define HorizontalSpaceBetweenImageAndCellContainerView 45
#define ViewHeightForIpad 536
#define ViewWidthForIpad 400
#import "NSString-Supplement.h"
#define CollectionViewHeight  (isIpad()?32.0f:30.0f)

//cancelPostButtonConataining view plus margin of notetextView
#define CancelPostButtonHeight 95
#define Is_Instructor [[currentUser role] isEqualToString:@"INSTRUCTOR"]
#define TAP_TO_MAKE_IMPORTANT  NSLocalizedStringFromTableInBundle(@"MAKE_IMPORTANT_NOTE_TEXT_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForStickyNotesViewController, nil);
#define TAP_TO_MAKE_NORMAL NSLocalizedStringFromTableInBundle(@"UNDO_IMPORTANT_NOTE_TEXT_KEY", READER_LOCALIZABLE_TABLE, LocalizationBundleForStickyNotesViewController, nil);
#define ShareSavePopUpheight 156
#define LocalizationBundleForStickyNotesViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

@interface StickyNotesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIButton *titleButton;
    //top view outlets
    __weak IBOutlet UIButton *deleteButton;
    
    //view seperation labels outlets
    __weak IBOutlet UILabel *selectedTextViewSeperationLineLbl;
    __weak IBOutlet UILabel *timeLabel;

    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *postButton;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet UIButton *commentPostButton;
    __weak IBOutlet UIButton *moreButton;

    __weak IBOutlet UIView *cancelPostButtonContainingView;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIView *backgroundView;
    __weak IBOutlet UIView *commentTextFieldContainingView;

    // textview
    __weak IBOutlet UITextView *selectedTextTextView;
    __weak IBOutlet UITextView *noteTextView;
    
    //height constraint outlet of views
    __weak IBOutlet NSLayoutConstraint *noteTextContainingViewHtConstraint;
    __weak IBOutlet NSLayoutConstraint *selectedTextContainingViewHtConstraint;
    __weak IBOutlet NSLayoutConstraint *commentViewHtConstraint;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfSelectedNoteSeperator;
    __weak IBOutlet NSLayoutConstraint *sharedButtonWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *hightConstraintOfCollectionView;
    __weak IBOutlet NSLayoutConstraint *topConstraintOfNoteTextView;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfSaveBtnContainerView;
    __weak IBOutlet NSLayoutConstraint *widthConstraintOFCollectionView;
    __weak IBOutlet NSLayoutConstraint *heightConstaraintOfContainerView;
    __weak IBOutlet NSLayoutConstraint *moreButtonWidthConstraint;
    __weak          NSLayoutConstraint *heightConstaraintShareSavePopUp;
    
    __weak IBOutlet UITextField *enterYourCommentTextField;
    __weak IBOutlet UITableView *tableview;
    __weak IBOutlet UICollectionView *highlightColorsCollectionView;
    
    BOOL isKeyboardOpen;
    SDKHighlightVO *_currentHighlightVO;
    BOOL isColorChanged;
    NSMutableArray *commentsArray;
    NSArray *colorsArray;
    KBHDThemeVO *_themeVO;
    NSDictionary *_languageDictionary;
    UITableView *dropDownTableview;
    NSArray *_sharingRelatedInfo;
    int selectedrow;
    KitabooUser *currentUser;
    UIView *popupView;
}

@end

@implementation StickyNotesViewController
@synthesize stickyNoteContainerView;
#pragma mark : view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerKeyboardNotification];
    [self registerCellsAndSetColorsDate];
    [self setupThemeColor];
    [self addTapGestureToView];
    [self setAccessibilityForStickyNotesElements];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateView];
    [self setUpDataForhighlight];
    [self addShareSavePop];
}

-(void)registerCellsAndSetColorsDate{
    [highlightColorsCollectionView registerNib:[UINib nibWithNibName:@"TextHighlightColorBtnCollectionViewCell" bundle:[NSBundle bundleForClass:[StickyNotesViewController class]]] forCellWithReuseIdentifier:@"TextHighlightColorBtnCollectionViewCell"];
    
    //register cell for tableview
    UINib *commentsCell = [UINib nibWithNibName:@"StickyNoteCommentCell" bundle:[NSBundle bundleForClass:[StickyNotesViewController class]]];
    [tableview registerNib:commentsCell forCellReuseIdentifier:@"StickyNoteCommentCell"];
    [tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 0.1)]];
    tableview.rowHeight = UITableViewAutomaticDimension;
    tableview.estimatedRowHeight = 90; // se

    colorsArray = _themeVO.highlight_Color_Array;
    widthConstraintOFCollectionView.constant = colorsArray.count * CollectionViewHeight + colorsArray.count * 10;
    [highlightColorsCollectionView reloadData];
    selectedrow = 0;
}

-(void)setCurrentUser:(KitabooUser*)kitabooUser{
    currentUser = kitabooUser;
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(!([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UITextField class]] || (touch.view == noteTextView)))
            [self.view endEditing:YES];
        if (touch.view == self.view && isIpad()) {
            return YES;
        }
        return NO;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}


-(void)dismissController {
    bool isNoteColorSame = [[NSString stringWithFormat:@"%@", _currentHighlightVO.backgroundColor] isEqualToString:[NSString stringWithFormat:@"%@", [colorsArray objectAtIndex:selectedrow]]];
    //check if anything is edited or not
    if(((!([_currentHighlightVO.noteText isEqualToString:[noteTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) && noteTextView.editable && noteTextView.text.length) ||  !isNoteColorSame) && noteTextView.text.length && !_currentHighlightVO.isReceived){
        [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"Save_Changes" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController] message:[LocalizationHelper localizedStringWithKey:@"Do_you_wish_to_save_changes" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"CANCEL" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController],[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if([buttonTitle isEqualToString:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController]]){
                [self saveButtonAction];
            }
            else{
                [self dismissViewControllerAnimated:NO completion:^{
                    if(self.noteCancelAction != nil){
                        self.noteCancelAction(self.currentHighlightVO);
                    }
                }];
            }
        }];
    }
    else{
        if(self.noteCancelAction != nil){
            self.noteCancelAction(self.currentHighlightVO);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)setupThemeColor{
    selectedTextTextView.textColor = _themeVO.note_contextualtext_color;
    noteTextView.textColor = _themeVO.note_description_color;
    timeLabel.textColor = _themeVO.note_note_text_color;
    noteTextView.placeholderColor = _themeVO.note_hint_text_color;
    containerView.backgroundColor = [[headerView subviews] objectAtIndex:0].backgroundColor = _themeVO.note_popup_background;
    [backButton setTitleColor:_themeVO.note_back_icon_color forState:UIControlStateNormal];
    [commentPostButton setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [shareButton setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [shareButton setTitleColor:[_themeVO.share_icon_color colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [postButton setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [postButton setTitleColor:[_themeVO.share_icon_color colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [deleteButton setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [deleteButton setTitleColor:[_themeVO.share_icon_color colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [titleButton setTitleColor:_themeVO.note_title_color forState:UIControlStateNormal];
    commentTextFieldContainingView.backgroundColor = _themeVO.comments_bottom_panel_background;
    popupView.backgroundColor = _themeVO.share_share_popup_background;
}

- (void)updateView
{
    [titleButton.titleLabel setFont:getCustomFontForWeight(20, UIFontWeightLight)];
    titleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [timeLabel setFont:getCustomFont(13)];
    [selectedTextTextView setFont:getCustomFont(17)];
    [enterYourCommentTextField setFont:getCustomFont(14)];
    [enterYourCommentTextField setTextColor:_themeVO.comments_bottom_panel_text_color];
    [noteTextView setFont:getCustomFontForWeight(17, UIFontWeightLight)];
    if(![_userSettingsModel isSharingEnabled])
        sharedButtonWidthConstraint.constant = 0;
    isColorChanged = NO;
    if(isIpad())
        [self updateNoteContainerViewForIpad];
    
    [titleButton setTitle:[LocalizationHelper localizedStringWithKey:@"NOTE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController] forState:UIControlStateNormal];
    NSMutableAttributedString *attributedStringForEnterYourCommentPlaceholder = [[NSMutableAttributedString alloc] initWithString:[LocalizationHelper localizedStringWithKey:@"WRITE_YOUR_COMMENT_HERE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController]
                                                                                            attributes:@{  NSForegroundColorAttributeName : _themeVO.comments_bottom_panel_hint_text_color}];
    enterYourCommentTextField.attributedPlaceholder = attributedStringForEnterYourCommentPlaceholder;
    commentPostButton.enabled = NO;
    commentPostButton.alpha = 0.5;
    [commentPostButton setTitle:SEND_ARROW_ICON forState:UIControlStateNormal];
    [commentPostButton setTitle:SEND_ARROW_ICON forState:UIControlStateSelected];
    commentTextFieldContainingView.layer.borderWidth = 0.6;
    commentTextFieldContainingView.layer.cornerRadius = 4;
    commentTextFieldContainingView.layer.borderColor = [UIColor colorWithHexString: @"#DFDFDF"].CGColor;
    commentPostButton.hidden = NO;
    
    selectedTextTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    noteTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [noteTextView setContentOffset:CGPointZero animated:YES];
    [selectedTextTextView setContentOffset:CGPointZero animated:YES];
    noteTextView.placeholder = [LocalizationHelper localizedStringWithKey:@"Enter_Note" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController];
    if(isRTL()){
        noteTextView.textAlignment = NSTextAlignmentRight;
    }
    postButton.enabled = false;
    noteTextView.editable = deleteButton.enabled = shareButton.enabled  = YES;
    [self.view layoutIfNeeded];
}

-(void)addTapGestureToView{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)updateNoteContainerViewForIpad
{
    // Set shadow to contaienr view
    stickyNoteContainerView.backgroundColor = [UIColor clearColor];
    headerView.layer.masksToBounds = stickyNoteContainerView.layer.masksToBounds = NO;
    stickyNoteContainerView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
    stickyNoteContainerView.layer.shadowRadius = 4.0f;
    stickyNoteContainerView.layer.shadowOpacity = 0.5f;
    headerView.layer.shadowColor = stickyNoteContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowOffset = CGSizeMake(0,4);
    headerView.layer.shadowOpacity = 0.1;
    headerView.layer.shadowRadius = 1;
    [backButton setTitle:@"" forState:UIControlStateNormal];
}

# pragma mark Display sticky note
- (void)setUpDataForhighlight
{
    [colorsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:[_currentHighlightVO backgroundColor]]){
            selectedrow = (int)idx;
        }
    }];
    [highlightColorsCollectionView reloadData];
    if(selectedrow == 0 && !_currentHighlightVO.isReceived){
        [_currentHighlightVO setBackgroundColor:[colorsArray firstObject]];
    }
    
    if(_currentHighlightVO.noteText.length)
        timeLabel.text = [NSString getLocalizedStringForDateString:[NSString getLocalizedStringForDateString:[_currentHighlightVO getDisplayDate]]];
    else
        timeLabel.text = [LocalizationHelper localizedStringWithKey:@"JUST_NOW" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController];
    
    //initialisation of variables
    commentsArray = [NSMutableArray new];
    [commentsArray addObjectsFromArray:[_currentHighlightVO noteComments]];
    [self reloadTable];
    heightConstraintOfSelectedNoteSeperator.constant = [_currentHighlightVO text].length?1:0;
    [self setTextViewData];

    if ([_currentHighlightVO noteText].length)
    {
        if(commentsArray.count > 0){

            tableview.hidden = NO;
            noteTextView.editable = NO;
            //update constraint constant based on their content height
            [self heightOfViewsForNoteWithComments];
        }
        else if([_currentHighlightVO isReceived] || [_currentHighlightVO isShare]){
            noteTextView.editable = NO;
            if(Is_Instructor){
                //if user is teacher then show comment box
                [self hideTableViewAndCommentsBoxHeight:58];
                [postButton.superview setHidden:YES];
            }
            else {
                [self hideTableViewAndCommentsBoxHeight:0.0];
                [postButton.superview setHidden:[_currentHighlightVO isReceived]];
            }
        } else if ([_currentHighlightVO isTeacherReviewNote] && !Is_Instructor) {
            [self hideTableViewAndCommentsBoxHeight:0.0];
            noteTextView.editable = NO;
            [postButton.superview setHidden:YES];
        } else {
            [self hideTableViewAndCommentsBoxHeight:0.0];
        }
        [self.view updateConstraintsIfNeeded];
        [self updateStickyNoteIfItIsRecieved];
    }
    else
    {
            //if note is new (i.e it is just created) or not shared with anyone then no comment view will be there.
        if ([_currentHighlightVO isTeacherReviewNote]) {
            [highlightColorsCollectionView setHidden:YES];
        }
            shareButton.enabled = postButton.enabled = NO;
            noteTextView.editable = YES;
            [self hideTableViewAndCommentsBoxHeight:0.0];
            [noteTextView becomeFirstResponder];
            if(colorsArray.count > selectedrow && !_currentHighlightVO.isReceived)
            headerView.backgroundColor = backgroundView.backgroundColor = [UIColor colorWithHexString:[colorsArray objectAtIndex:selectedrow]];
            else{
                headerView.backgroundColor = backgroundView.backgroundColor = [UIColor colorWithHexString:_currentHighlightVO.backgroundColor];
            }
    }
}

-(void)showShareButton:(BOOL)showShare{
    if(showShare)
        sharedButtonWidthConstraint.constant = 50;
    else
        sharedButtonWidthConstraint.constant = 0;
}

-(void)heightOfViewsForNoteWithComments{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->heightConstraintOfSaveBtnContainerView.constant = 0;
    [self->postButton.superview setHidden:YES];
    if(self->_currentHighlightVO.text.length){
        self->selectedTextContainingViewHtConstraint.constant = (selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt > 140)?140:selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt;
        noteTextContainingViewHtConstraint.constant = (noteTextView.contentSize.height > (180-CancelPostButtonHeight))?180:noteTextView.contentSize.height + 24;
    }
    else{
        selectedTextContainingViewHtConstraint.constant = 0;
        noteTextContainingViewHtConstraint.constant = (noteTextView.contentSize.height > (260 - CancelPostButtonHeight))?260:noteTextView.contentSize.height + 24;
    }
    });
}

-(void)hideTableViewAndCommentsBoxHeight:(CGFloat)commentBoxHeight{
    //if there is no comment the commentview height will be 54(if user is teacher else height will be 0) and height of other views in container view will be calculated depending on available space and presence of selected text
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view layoutSubviews];
        [containerView layoutIfNeeded];
    if(_currentHighlightVO.text.length){
        if(commentBoxHeight == 0)
        selectedTextContainingViewHtConstraint.constant = ((self->selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt) > containerView.frame.size.height/2) ? containerView.frame.size.height/2 : (self->selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt);
        else
        selectedTextContainingViewHtConstraint.constant = (self->selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt > 140)?140:self->selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt;
    }
    else{
        selectedTextContainingViewHtConstraint.constant = 0;
        topConstraintOfNoteTextView.constant = 0;
    }
    commentViewHtConstraint.constant = commentBoxHeight;
    noteTextContainingViewHtConstraint.constant = (self->containerView.frame.size.height - commentBoxHeight - 24 - selectedTextContainingViewHtConstraint.constant);
    tableview.hidden = YES;
    commentPostButton.hidden = (commentBoxHeight > 0)?NO:YES;
    commentTextFieldContainingView.superview.hidden = (commentBoxHeight == 0)?YES:NO;
        [self.view layoutIfNeeded];
    });

}

- (void) setTextViewData
{
    //setup heighted and note text data
    if([_currentHighlightVO text].length){
    selectedTextTextView.text = [_currentHighlightVO text];
    [selectedTextTextView sizeToFit];
    [selectedTextTextView scrollsToTop];
    }
    noteTextView.text = [_currentHighlightVO noteText];
//    [noteTextView sizeToFit];
    deleteButton.enabled = noteTextView.text.length?YES:NO;
    selectedTextTextView.scrollEnabled = YES;
}

- (void) updateStickyNoteIfItIsRecieved
{
     // Disable all sticky note buttons except Cancel button for shared note
    if([_currentHighlightVO isReceived] || ([_currentHighlightVO isTeacherReviewNote] && !Is_Instructor)){
        noteTextView.editable = deleteButton.enabled = shareButton.enabled = postButton.enabled = NO;
        [postButton.superview setHidden:YES];
        [heightConstraintOfSaveBtnContainerView setConstant:0];
        [highlightColorsCollectionView setHidden:YES];
        moreButtonWidthConstraint.constant = 2;
        moreButton.hidden = YES;
        headerView.backgroundColor = backgroundView.backgroundColor = [UIColor colorWithHexString:_currentHighlightVO.backgroundColor];
    }
    else{
        if(colorsArray.count > selectedrow)
        headerView.backgroundColor =  backgroundView.backgroundColor = [UIColor colorWithHexString:[colorsArray objectAtIndex:selectedrow]];
        deleteButton.enabled = shareButton.enabled = YES;
        if ([_currentHighlightVO isTeacherReviewNote]) {
            [highlightColorsCollectionView setHidden:YES];
        } else {
            [highlightColorsCollectionView setHidden:NO];
        }
        moreButtonWidthConstraint.constant = 56;
    }
}

-(void)setTheme:(KBHDThemeVO *)themeVO{
    _themeVO = themeVO;
}

#pragma mark : Memory warning methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma -mark tableview controller
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentsArray.count;
}

-(StickyNoteCommentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"StickyNoteCommentCell";
    StickyNoteCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell = [[StickyNoteCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *commentsDictionary = [commentsArray objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = _themeVO.note_popup_background;
    cell.containerView.layer.borderWidth = cell.containerViewForMyComment.layer.borderWidth = 0.6;
    cell.containerView.layer.cornerRadius = cell.containerViewForMyComment.layer.cornerRadius = 8;
    cell.containerView.layer.borderColor = cell.containerViewForMyComment.layer.borderColor = [UIColor colorWithHexString: @"#DFDFDF"].CGColor;
    
    [cell.stickyCommentCreatedBy setFont:getCustomFont(15)];
    [cell.stickyCommentLbl setFont:getCustomFontForWeight(18, UIFontWeightLight)];
    [cell.stickyCommentDateTimeLbl setFont:getCustomFont(10)];
    [cell.nameLablForMyComment setFont:getCustomFont(15)];
    [cell.myCommentLbl setFont:getCustomFontForWeight(18, UIFontWeightLight)];
    cell.myCommentLbl.textColor = _themeVO.comments_my_message_description_color;
    [cell.timeLblOfMyComments setFont:getCustomFont(10)];
    cell.timeLblOfMyComments.textColor = _themeVO.comments_my_message_time_text_color;
    if([commentsDictionary valueForKey:TEXT])
    cell.stickyCommentLbl.text = cell.myCommentLbl.text = [commentsDictionary valueForKey:TEXT];
    NSString *createdDate = [commentsDictionary valueForKey:DATE];
    if(createdDate)
        cell.stickyCommentDateTimeLbl.text = cell.timeLblOfMyComments.text = [NSString getLocalizedStringForDateString:[NSString stringWithFormat:@"%@",[NSString formattedLocalStringFromDate:[[commentsDictionary valueForKey:DATE] utcDateFromString]]]];
    else
        cell.stickyCommentDateTimeLbl.text = cell.timeLblOfMyComments.text = [LocalizationHelper localizedStringWithKey:@"JUST_NOW" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController];
    
    if([[currentUser userID] doubleValue] == [[commentsDictionary valueForKey:USER_ID] doubleValue])
    {
        cell.containerViewForMyComment.hidden = NO;
        cell.containerView.hidden = YES;
        cell.nameLablForMyComment.text =  [LocalizationHelper localizedStringWithKey:@"Me" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController];
        cell.containerViewForMyComment.backgroundColor = _themeVO.comments_my_message_background;
        cell.nameLablForMyComment.textColor = _themeVO.comments_my_message_name_color;
    }
    else
    {
        cell.containerViewForMyComment.hidden = YES;
        cell.containerView.hidden = NO;
        cell.stickyCommentCreatedBy.textColor = [UIColor blackColor];
        cell.stickyCommentCreatedBy.text = [NSString stringWithFormat:@"%@",[commentsDictionary valueForKey:DISPLAY_NAME]];
        cell.containerView.backgroundColor = _themeVO.comments_other_message_background;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma -mark uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark : Button actions

- (IBAction)backbuttonAciton:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonAction:(id)sender {
    [[AlertView sharedManager] presentAlertWithTitle:[LocalizationHelper localizedStringWithKey:@"Delete_note" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController] message:[LocalizationHelper localizedStringWithKey:@"DO_YOU_WISH_TO_DELETE_THIS_NOTE_ALERT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"NO_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController],[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if([buttonTitle isEqualToString:[LocalizationHelper localizedStringWithKey:@"YES_ALERT_BUTTON" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForStickyNotesViewController]]){
            if(self.noteDeleteAction != nil){
                self.noteDeleteAction(self.currentHighlightVO);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
   
}

- (IBAction)commentPostButton:(id)sender {
    [self.view endEditing:YES];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [enterYourCommentTextField.text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length]> 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
            [commentArr addObjectsFromArray:[self->_currentHighlightVO noteComments]];
        NSMutableDictionary *commentsTempDict = [[NSMutableDictionary alloc]init];
            [commentsTempDict setValue:self->enterYourCommentTextField.text forKey:TEXT];
        [commentsTempDict setValue:[currentUser userID] forKey:USER_ID];
        [commentsTempDict setValue:[NSString stringWithFormat:@"%@ %@",[currentUser firstName],[currentUser lastName]] forKey:DISPLAY_NAME];

        NSString *dateTimeStr = [NSString stringFromUTCDate:[NSDate date]];
        [commentsTempDict setValue:dateTimeStr forKey:DATE];
        NSDictionary *commentsDict = [[NSDictionary alloc]initWithDictionary:commentsTempDict];
        [commentArr addObject:commentsDict];
        _currentHighlightVO.noteComments = [NSArray arrayWithArray:commentArr];
        if(_postCommentAction != nil){
            _postCommentAction(_currentHighlightVO);
        }
        [commentsArray removeAllObjects];
        [commentsArray addObjectsFromArray:commentArr];
        tableview.hidden = NO;
        [self reloadTable];
        enterYourCommentTextField.text = @"";
        commentPostButton.enabled = NO;
        commentPostButton.alpha = 0.5;
        tableview.hidden = NO;
        
        //if selected text is present then height of all three view in containerView will be 1/3 of container view
        containerViewBottomConstraint.constant = 0;
            [self heightOfViewsForNoteWithComments];
            [tableview setContentOffset:CGPointMake(0, 0)];
            [tableview setContentInset:UIEdgeInsetsZero];
            [self.view layoutSubviews];
        });
    }
    
}

-(void)reloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [tableview reloadData];

        } completion:^(BOOL finished) {
            if(commentsArray.count > 0){
            [tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[commentsArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }];

    });
}

- (IBAction)noteCancelButtonAction:(id)sender {
    if(self.noteCancelAction != nil){
        self.noteCancelAction(self.currentHighlightVO);
    }
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveButtonAction{
    [self hideSharePopUp:nil];
    NSString *noteText = [noteTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _currentHighlightVO.backgroundColor =  [colorsArray objectAtIndex:selectedrow];
    if(noteText.length > 0)
    {
        self.currentHighlightVO.noteText = noteText;
//        self.currentHighlightVO.modifiedDate = [NSDate date];
        if(self.notePostAction != nil){
            self.notePostAction(self.currentHighlightVO);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        //show alert
    }
}

-(void)shareAction{
    [self hideSharePopUp:nil];
    NSString *noteText = [noteTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(noteText.length > 0)
    {
        if(self.noteShareAction != nil){
            self.noteShareAction(self.currentHighlightVO,[colorsArray objectAtIndex:selectedrow],noteText);
        }
    }
    else{
        //show alert
    }
}
- (IBAction)postButtonAction:(id)sender {
    [self saveButtonAction];
  
}
- (IBAction)moreButtonAction:(UIButton*)sender {
    sender.hidden = YES;
    [self showShareSavePop];
}

- (IBAction)shareButtonAction:(UIButton*)sender {
    [self.view endEditing:YES];
    [self shareAction];
}

# pragma mark TextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //TEXT INPUT LIMITATIONS
    NSString  *noteText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSUInteger oldLength = [textView.text length];
    NSUInteger replacementLength = [text length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    deleteButton.enabled = (newLength > 0)?YES:NO;
    shareButton.enabled = (newLength > 0)?YES:NO;
    bool isNoteColorSame = [[NSString stringWithFormat:@"%@", _currentHighlightVO.backgroundColor] isEqualToString:[NSString stringWithFormat:@"%@", [colorsArray objectAtIndex:selectedrow]]];
    postButton.enabled = ((!([_currentHighlightVO.noteText isEqualToString:noteText]) && noteText.length) ||  !isNoteColorSame) && noteText.length;
    return newLength <= 820;
}

# pragma mark TEXTFIELD DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TEXT INPUT LIMITATIONS
    NSUInteger oldLength = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
        if (newLength == 0) {
            commentPostButton.enabled = NO;
            commentPostButton.alpha = 0.5;
        }else
        {
            commentPostButton.enabled = YES;
            commentPostButton.alpha = 1.0;
        }
    return newLength <= 250;
    
}

# pragma mark REGISTER OBSERVER
- (void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

# pragma mark OBSERVER METHODS
- (void)keyboardWillShow:(NSNotification *) notification
{
    if (!isKeyboardOpen) {
    isKeyboardOpen = YES;
    CGRect keyboardRect = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardRect.size.height;
    keyboardRect = [self.view convertRect:keyboardRect toView:nil];
    if(isIpad()){
        if(_currentHighlightVO.noteComments.count)
        {
            [self.view setFrame:aRect];
            [self.view layoutIfNeeded];
            if(commentsArray.count){
                if([_currentHighlightVO text].length)
                    selectedTextContainingViewHtConstraint.constant = (selectedTextTextView.contentSize.height+ SelectedTexViewDefaultHt > 90)?90:selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt;
                    noteTextContainingViewHtConstraint.constant = (noteTextView.contentSize.height > (120 - 24))?120:noteTextView.contentSize.height + 24;
                [self reloadTable];
            }
        }
        else{
        if([noteTextView isFirstResponder]){
            [self.view setFrame:aRect];
            heightConstaraintOfContainerView.constant = 400;
            [self.view layoutSubviews];
            [containerView layoutSubviews];
            [UIView animateWithDuration:0.4 animations:^{
                if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                {
                    if(selectedTextTextView.text.length)
                    selectedTextContainingViewHtConstraint.constant =  (selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt > 36)?36:(selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt);
                }
                else{
                    if(selectedTextTextView.text.length)
                    selectedTextContainingViewHtConstraint.constant = (selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt > 70)?70:(selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt);
                    
                    noteTextContainingViewHtConstraint.constant = containerView.frame.size.height - selectedTextContainingViewHtConstraint.constant;
                }
                [self.view layoutIfNeeded];
            }];
        }
        else{
            [self.view setFrame:aRect];
            [UIView animateWithDuration:0.4 animations:^{
                [self.view layoutIfNeeded];
                
            }];
        }
        }
    }else{
        if([noteTextView isFirstResponder])
            [UIView animateWithDuration:0.4 animations:^{
                dispatch_async(dispatch_get_main_queue(), ^{

                if(isIphoneX)
                    containerViewBottomConstraint.constant = keyboardRect.size.height - 34;
                else
                    containerViewBottomConstraint.constant = keyboardRect.size.height ;
                [self.view layoutIfNeeded];
                CGFloat selectedContentHeight;
                if((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)))
                    selectedContentHeight = 0;
                else
                    selectedContentHeight  = ((selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt) > containerView.frame.size.height/2)? containerView.frame.size.height/2: (selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt);
                selectedTextContainingViewHtConstraint.constant = [_currentHighlightVO text].length?selectedContentHeight:0;
                noteTextContainingViewHtConstraint.constant = containerView.frame.size.height - 24 - selectedTextContainingViewHtConstraint.constant;
                [selectedTextTextView.superview layoutIfNeeded];
                [containerView layoutIfNeeded];
                [self.view layoutIfNeeded];
                });

             }];
        else{

            [UIView animateWithDuration:0.4 animations:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                if(isIphoneX && !(isLandScape))
                    containerViewBottomConstraint.constant = keyboardRect.size.height - 34;
                else
                    containerViewBottomConstraint.constant = keyboardRect.size.height ;
                if(commentsArray.count){
                    CGFloat selectedContentHeight;
                    selectedTextViewSeperationLineLbl.hidden = YES;
                    if(isLandScape)
                        selectedContentHeight = 0;
                    else
                        selectedContentHeight = (selectedTextTextView.contentSize.height+ SelectedTexViewDefaultHt > 90)?90:selectedTextTextView.contentSize.height + SelectedTexViewDefaultHt;
                    if([_currentHighlightVO text].length)
                        selectedTextContainingViewHtConstraint.constant = selectedContentHeight;
                    noteTextContainingViewHtConstraint.constant = (isLandScape)?0:(noteTextView.contentSize.height > (120 - 24))?120:noteTextView.contentSize.height + 24;
                    [self reloadTable];
                }
                else{
                    CGFloat selectedContentHeight;
                    if(isLandScape)
                        selectedContentHeight = 0;
                    else
                        selectedContentHeight = [_currentHighlightVO text].length?70:0;
                    selectedTextContainingViewHtConstraint.constant = (isLandScape)?0:[_currentHighlightVO text].length?70:0;
                    noteTextContainingViewHtConstraint.constant = containerView.frame.size.height - selectedTextContainingViewHtConstraint.constant - 54 ;
                }
                [self.view layoutIfNeeded];
                });
            }];
        }
    }
    }
}


- (void)KeyboardWillHide:(NSNotification *) notification
{
    isKeyboardOpen = NO;
    if(isIpad()){
        [self.view setFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
        [self.view layoutSubviews];
        heightConstaraintOfContainerView.constant = ViewHeightForIpad;
        containerViewBottomConstraint.constant = 0;
        [UIView animateWithDuration:0.4 animations:^{
        if(commentsArray.count > 0){
            [self heightOfViewsForNoteWithComments];
            [self reloadTable];
        }
        else if([_currentHighlightVO isReceived] || [_currentHighlightVO isShare]){
            if(Is_Instructor)
                //if user is teacher then show comment box
                [self hideTableViewAndCommentsBoxHeight:58];
            else{
                [self hideTableViewAndCommentsBoxHeight:0.0];
                [postButton.superview setHidden:[_currentHighlightVO isReceived]];
            }
        }
        else
            [self hideTableViewAndCommentsBoxHeight:0.0];
    }];
    }
    else
        [UIView animateWithDuration:0.4 animations:^{
            containerViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
            if(commentsArray.count > 0){
                selectedTextViewSeperationLineLbl.hidden = NO;
                [self heightOfViewsForNoteWithComments];
                [self reloadTable];
            }
            else if([_currentHighlightVO isReceived] || [_currentHighlightVO isShare]){
                if(Is_Instructor)
                    //if user is teacher then show comment box
                    [self hideTableViewAndCommentsBoxHeight:58];
                else{
                    [self hideTableViewAndCommentsBoxHeight:0.0];
                    [postButton.superview setHidden:[_currentHighlightVO isReceived]];
                }
            }
            else
                [self hideTableViewAndCommentsBoxHeight:0.0];
        }];

}
#pragma Stickynote share delegate
- (void)didTapOnShareNote:(SDKHighlightVO *)highlight{
 
        // Dismiss sticky note controller
        [self dismissViewControllerAnimated:YES completion:^{
        }];
}

#pragma mark : collection view delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [colorsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TextHighlightColorBtnCollectionViewCell *ccell =(TextHighlightColorBtnCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"TextHighlightColorBtnCollectionViewCell" forIndexPath:indexPath];
    UIColor *color = [UIColor colorWithHexString:[colorsArray objectAtIndex:indexPath.row]];
    // # color Button
    ccell.heighLightButton.clipsToBounds = YES;
    ccell.buttonLeadingConstraint.constant = ccell.buttonBottomConstraint.constant = 5.0;
    [ccell.contentView layoutIfNeeded];

    [ccell.heighLightButton setBackgroundColor:color];
    NSString *identifier = [NSString stringWithFormat:@"#%@",[color hexStringFromColor]];
       ccell.heighLightButton.accessibilityIdentifier = [NSString stringWithFormat:@"stickyNote_%@", identifier];
    [ccell.heighLightButton addTarget:self action:@selector(didSelectColorButton:) forControlEvents:UIControlEventTouchUpInside];
    ccell.heighLightButton.tag = indexPath.row + 1;
    ccell.buttonContainerView.layer.borderWidth = 1;
    if(selectedrow == (int)indexPath.row){
        ccell.buttonContainerView.layer.borderColor = _themeVO.note_selected_icon_border.CGColor;
    }
    else{
       ccell.buttonContainerView.layer.borderColor = [UIColor clearColor].CGColor;

    }
    ccell.heighLightButton.layer.cornerRadius = (CollectionViewHeight - 10) * 0.5;
    ccell.buttonContainerView.layer.cornerRadius = (CollectionViewHeight) * 0.5;
    ccell.buttonContainerView.clipsToBounds = YES;
    ccell.heighLightButton.clipsToBounds = YES;
    ccell.backgroundColor = UIColor.clearColor;
    return ccell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat buttonSize = CollectionViewHeight;
    return CGSizeMake(buttonSize, buttonSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;  // top, left, bottom, right
}


-(void)didSelectColorButton:(UIButton *)sender{
    selectedrow = (int)sender.tag - 1;
    isColorChanged = YES;
    
    bool isNoteColorSame = [[NSString stringWithFormat:@"%@",_currentHighlightVO.backgroundColor] isEqualToString:[NSString stringWithFormat:@"%@", [colorsArray objectAtIndex:selectedrow]]];
    postButton.enabled = ((!([_currentHighlightVO.noteText isEqualToString:[noteTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) && noteTextView.editable) ||  (!isNoteColorSame)) && noteTextView.text.length;
    ((UIButton *)([self.view viewWithTag:SAVEBTNTAG])).enabled = !isNoteColorSame;
    headerView.backgroundColor = backgroundView.backgroundColor = [UIColor colorWithHexString:[colorsArray objectAtIndex:selectedrow]];
    [highlightColorsCollectionView reloadData];
}

- (BOOL)shouldAutorotate
{
//    if(isIpad())
        return YES;
//    else
//        return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    if(!isIpad())
//    {
//            return UIInterfaceOrientationMaskPortrait;
//    }
    return UIInterfaceOrientationMaskAll;
}

-(void)addShareSavePop{
    popupView = [[UIView alloc] initWithFrame:CGRectZero];
    popupView.backgroundColor = _themeVO.share_share_popup_background;
    popupView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    popupView.layer.borderWidth = 0.6;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(-1.0f, 0.0f);
    popupView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    popupView.layer.shadowRadius = 20.0f;
    popupView.layer.shadowOpacity = 0.2f;
    popupView.layer.cornerRadius = 20;
    
    [self.view addSubview:popupView];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    [popupView.bottomAnchor constraintEqualToAnchor:commentTextFieldContainingView.bottomAnchor constant:2].active = YES;
    [popupView.trailingAnchor constraintEqualToAnchor:moreButton.superview.trailingAnchor constant:-12].active = YES;
    [popupView.widthAnchor constraintEqualToConstant:45].active = YES;
    heightConstaraintShareSavePopUp = [popupView.heightAnchor constraintEqualToConstant:0];
    heightConstaraintShareSavePopUp.active = YES;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = false;
    [popupView addSubview:cancelBtn];
    [cancelBtn setTitle:ICON_CLOSE forState:UIControlStateNormal];
    [cancelBtn setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [cancelBtn.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor constant:0].active = YES;;
    [cancelBtn.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor constant:0].active = YES;
    [cancelBtn.bottomAnchor constraintEqualToAnchor:popupView.bottomAnchor constant:0].active = YES;;
    [cancelBtn addTarget:self action:@selector(hideSharePopUp:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn.titleLabel setFont:DefualtFont(18)];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    saveBtn.translatesAutoresizingMaskIntoConstraints = false;
    [popupView addSubview:saveBtn];
    saveBtn.tag = SAVEBTNTAG;
    saveBtn.enabled = false;
    [saveBtn setTitle:ICON_SAVE forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [saveBtn setTitleColor:[_themeVO.share_icon_color colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [saveBtn.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor constant:0].active = YES;;
    [saveBtn.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor constant:0].active = YES;
    [saveBtn.bottomAnchor constraintEqualToAnchor:cancelBtn.topAnchor constant:6.0].active = YES;;
    [saveBtn.heightAnchor constraintEqualToAnchor:cancelBtn.heightAnchor].active = YES;
    [saveBtn.titleLabel setFont:DefualtFont(18)];
    if(!_userSettingsModel.isSharingEnabled){
        [saveBtn.topAnchor constraintEqualToAnchor:popupView.topAnchor constant:0].active = YES;
    }
    else{
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    shareBtn.translatesAutoresizingMaskIntoConstraints = false;
    [popupView addSubview:shareBtn];
    [shareBtn setTitle:ICON_SHARE_NOTE forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:_themeVO.share_icon_color forState:UIControlStateNormal];
    [shareBtn.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor constant:0].active = YES;
    [shareBtn.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor constant:0].active = YES;
    [shareBtn.bottomAnchor constraintEqualToAnchor:saveBtn.topAnchor constant:6.0].active = YES;
    [shareBtn.topAnchor constraintEqualToAnchor:popupView.topAnchor constant:0].active = YES;
    [shareBtn.heightAnchor constraintEqualToAnchor:saveBtn.heightAnchor].active = YES;
    [shareBtn.titleLabel setFont:DefualtFont(18)];
   }
    popupView.hidden = YES;
    [self.view layoutIfNeeded];
}

-(void)showShareSavePop{
    if(_userSettingsModel.isSharingEnabled)
        heightConstaraintShareSavePopUp.constant = ShareSavePopUpheight;
    else
        heightConstaraintShareSavePopUp.constant = ShareSavePopUpheight - 52;
    [UIView animateWithDuration:0.4 animations:^{
        popupView.hidden = NO;
        popupView.alpha = 1;
        [self.view layoutIfNeeded];
    }];
}

-(void)hideSharePopUp:(UIButton *)sender{
    [UIView animateWithDuration:0.4 animations:^{
        heightConstaraintShareSavePopUp.constant = 60;
        [self.view layoutIfNeeded];
        popupView.alpha = 0.3;
    } completion:^(BOOL finished) {
        moreButton.hidden = NO;
        popupView.hidden = YES;
    }];
}

-(void)setAccessibilityForStickyNotesElements
{
    backButton.accessibilityIdentifier = STICKY_NOTE_BACK_BUTTON;
    titleButton.accessibilityIdentifier = STICKY_NOTE_TITLE_BUTTON;
    deleteButton.accessibilityIdentifier = STICKY_NOTE_DELETE_BUTTON;
    selectedTextTextView.accessibilityIdentifier = STICKY_NOTE_SELECTED_TEXT_TEXT_VIEW;
    noteTextView.accessibilityIdentifier = STICKY_NOTE_NOTE_TEXT_VIEW;
    postButton.accessibilityIdentifier = STICKY_NOTE_POST_BUTTON;
    shareButton.accessibilityIdentifier = STICKY_NOTE_SHARE_BUTTON;
    enterYourCommentTextField.accessibilityIdentifier = STICKY_NOTE_COMMENT_TEXT_FIELD;
    commentPostButton.accessibilityIdentifier = STICKY_NOTE_COMMENT_POST_BUTTON;
    moreButton.accessibilityIdentifier = STICKY_NOTE_MORE_BUTTON;
}
@end
