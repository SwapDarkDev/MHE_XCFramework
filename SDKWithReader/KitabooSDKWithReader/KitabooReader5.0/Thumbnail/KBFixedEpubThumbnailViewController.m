//
//  KBFixedEpubThumbnailViewController.m
//  KitabooSDKWithReader
//
//  Created by Sumanth Myrala on 10/11/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import "KBFixedEpubThumbnailViewController.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>

#define ThumbnailViewHeight isIpad() ? 100:90
#define LocalizationBundleForKBThumbnailViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]
#define SliderLabelWidth 90
#define SliderLabelHeight 33
#define TextFieldWidthConstant 41

@interface KBFixedEpubThumbnailViewController ()<UITextFieldDelegate>
{
    KBHDThemeVO *_themeVO;
    UIView *thumbnailMainView;
    UISlider *slider;
    UITextField *gotoTextField;
    UIButton *nextButton;
    UIButton *prevButton;
    UILabel *totalPageNumberLabel;
    NSArray *_dataArray;
    NSString *displayNumberOfLastPage;
    NSLayoutConstraint *thumbnailViewBottomConstraint;
    BOOL prevEnable,nextEnable;
    UILabel *sliderLabel;
    BOOL isKeyboardOpen;
    CGFloat keyboardHeight;
}

@end

@implementation KBFixedEpubThumbnailViewController

#pragma mark Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat thumbnailHeight = isIpad() ? 100.0 : 90.0;
    self.view.frame = CGRectMake(0, screenRect.size.height-thumbnailHeight, screenRect.size.width, ThumbnailViewHeight);
    
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapOnView)];
    [self.view addGestureRecognizer:tapOnView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLastPageDisplayNum];
    [self addThumbnailMainView];
    [self addSliderToThumbnailView];
    [self addNavigationView];
    slider.value = (float)_activePageNumber/(float)(_totalNumberOfPages-1);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addSliderLabel];
}
#pragma mark Initializer
- (id)initWithData:(NSArray *)dataArray withTheme:(KBHDThemeVO *)themeVO
{
    _themeVO = themeVO;
    _dataArray = dataArray;
    return self;
}

#pragma mark UI Methods
- (void)addThumbnailMainView
{
    thumbnailMainView = [[UIView alloc] init];
    thumbnailMainView.backgroundColor = _themeVO.thumbnail_slider_popup_background;
    [self.view addSubview:thumbnailMainView];
    thumbnailMainView.translatesAutoresizingMaskIntoConstraints =NO;
    
    
    if (@available(iOS 11.0, *)){
    thumbnailViewBottomConstraint = [thumbnailMainView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0];
        [thumbnailMainView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = YES;
        [thumbnailMainView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = YES;
    }
    else{
        thumbnailViewBottomConstraint = [thumbnailMainView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0];
        [thumbnailMainView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [thumbnailMainView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    }
    thumbnailViewBottomConstraint.active = YES;
    [thumbnailMainView.heightAnchor constraintEqualToConstant:ThumbnailViewHeight].active = YES;
}

- (void)addSliderToThumbnailView
{
    slider = [[UISlider alloc] init];
    [thumbnailMainView addSubview:slider];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    
    slider.thumbTintColor = _themeVO.thumbnail_slider_filled_color;
    slider.tintColor = _themeVO.thumbnail_slider_filled_color;
    slider.maximumTrackTintColor = _themeVO.thumbnail_slider_slider_color;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderEventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderDragExit:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    
    [slider.leadingAnchor constraintEqualToAnchor:thumbnailMainView.leadingAnchor constant:10.0].active = YES;
    [slider.trailingAnchor constraintEqualToAnchor:thumbnailMainView.trailingAnchor constant:-10.0].active = YES;
    [slider.topAnchor constraintEqualToAnchor:thumbnailMainView.topAnchor constant:10.0].active = YES;
}

- (void)addNavigationView
{
    UIView *bottomButtonsView = [[UIView alloc] init];
    bottomButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomButtonsView.backgroundColor = [UIColor clearColor];
    [thumbnailMainView addSubview:bottomButtonsView];
    
    [bottomButtonsView.centerXAnchor constraintEqualToAnchor:thumbnailMainView.centerXAnchor constant:0].active = YES;
    [bottomButtonsView.topAnchor constraintEqualToAnchor:slider.bottomAnchor constant:0].active = YES;
    [bottomButtonsView.bottomAnchor constraintEqualToAnchor:thumbnailMainView.bottomAnchor constant:-5.0].active = YES;
    
    prevButton = [[UIButton alloc]init];
    [prevButton setTitle:@"I" forState:UIControlStateNormal];
    [prevButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad() ? 24.0f : 19.0f]];
    [prevButton addTarget:self action:@selector(prevPageButttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setTitleColor:_themeVO.thumbnail_botton_bar_text_color forState:UIControlStateNormal];
    prevButton.translatesAutoresizingMaskIntoConstraints=NO;
    [bottomButtonsView addSubview:prevButton];
    [self enablePreviousButton:prevEnable];
    [prevButton.leadingAnchor constraintEqualToAnchor:bottomButtonsView.leadingAnchor constant:0].active = YES;
    [prevButton.topAnchor constraintEqualToAnchor:bottomButtonsView.topAnchor constant:0].active = YES;
    [prevButton.bottomAnchor constraintEqualToAnchor:bottomButtonsView.bottomAnchor constant:0].active = YES;
    [prevButton.widthAnchor constraintEqualToConstant: 40.0].active = YES;
    
    nextButton = [[UIButton alloc]init];
    [nextButton setTitle:@"J" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:isIpad() ? 24.0f : 19.0f]];
    [nextButton addTarget:self action:@selector(nextPageButttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:_themeVO.thumbnail_botton_bar_text_color forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints=NO;
    [bottomButtonsView addSubview:nextButton];
    [self enableNextButton:nextEnable];
    [nextButton.trailingAnchor constraintEqualToAnchor:bottomButtonsView.trailingAnchor constant:0].active = YES;
    [nextButton.topAnchor constraintEqualToAnchor:bottomButtonsView.topAnchor constant:0].active = YES;
    [nextButton.bottomAnchor constraintEqualToAnchor:bottomButtonsView.bottomAnchor constant:0].active = YES;
    [nextButton.widthAnchor constraintEqualToConstant:40.0].active = YES;
    
    UIView *pageNumberContainer = [[UIView alloc] init];
    pageNumberContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomButtonsView addSubview:pageNumberContainer];
    [pageNumberContainer.centerXAnchor constraintEqualToAnchor:bottomButtonsView.centerXAnchor constant:0].active = YES;
    [pageNumberContainer.topAnchor constraintEqualToAnchor:bottomButtonsView.topAnchor].active = YES;
    [pageNumberContainer.bottomAnchor constraintEqualToAnchor:bottomButtonsView.bottomAnchor].active = YES;
    [pageNumberContainer.leadingAnchor constraintEqualToAnchor:prevButton.trailingAnchor constant:1].active = YES;
    [pageNumberContainer.trailingAnchor constraintEqualToAnchor:nextButton.leadingAnchor constant:1].active = YES;
    
    totalPageNumberLabel = [[UILabel alloc] init];
    [totalPageNumberLabel setText:[NSString stringWithFormat:@"/%@",displayNumberOfLastPage]];
    totalPageNumberLabel.textColor = _themeVO.thumbnail_botton_bar_text_color;
    [totalPageNumberLabel setFont:getCustomFont(isIpad() ? 15:12)];
    totalPageNumberLabel.textAlignment = NSTextAlignmentLeft;
    [pageNumberContainer addSubview:totalPageNumberLabel];
    totalPageNumberLabel.translatesAutoresizingMaskIntoConstraints =NO;
    [totalPageNumberLabel.rightAnchor constraintEqualToAnchor:pageNumberContainer.rightAnchor].active = YES;
    [totalPageNumberLabel.topAnchor constraintEqualToAnchor:pageNumberContainer.topAnchor].active = YES;
    [totalPageNumberLabel.bottomAnchor constraintEqualToAnchor:pageNumberContainer.bottomAnchor constant:-1].active = YES;
    [totalPageNumberLabel.widthAnchor constraintGreaterThanOrEqualToConstant:40].active = YES;
    
    gotoTextField = [[UITextField alloc] init];
    gotoTextField.placeholder = [LocalizationHelper localizedStringWithKey:@"GO_TO" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
    gotoTextField.textAlignment = NSTextAlignmentRight;
    gotoTextField.attributedPlaceholder = [self setPlaceholdertextColor:gotoTextField.attributedPlaceholder withColor:_themeVO.thumbnail_botton_bar_text_color];
    gotoTextField.backgroundColor = UIColor.clearColor;
    gotoTextField.textColor = _themeVO.thumbnail_botton_bar_text_color;
    gotoTextField.text = _activeDisplayNumber;
    gotoTextField.delegate =self;
    [gotoTextField setFont:getCustomFont(isIpad() ? 15:12)];

    [pageNumberContainer addSubview:gotoTextField];
    gotoTextField.translatesAutoresizingMaskIntoConstraints =NO;
    [gotoTextField.leftAnchor constraintEqualToAnchor:pageNumberContainer.leftAnchor].active = YES;
    [gotoTextField.rightAnchor constraintEqualToAnchor:totalPageNumberLabel.leftAnchor constant:0].active = YES;
    [gotoTextField.topAnchor constraintEqualToAnchor:pageNumberContainer.topAnchor].active = YES;
    [gotoTextField.bottomAnchor constraintEqualToAnchor:pageNumberContainer.bottomAnchor].active = YES;
    CGSize textFieldSize = [gotoTextField intrinsicContentSize];
    if (textFieldSize.width >= (CGFloat)TextFieldWidthConstant) {
        textFieldSize = CGSizeMake(TextFieldWidthConstant, textFieldSize.height);
    }
    [gotoTextField.widthAnchor constraintEqualToConstant:textFieldSize.width].active = YES;
    CGFloat totalWidth = textFieldSize.width+120;
    [bottomButtonsView.widthAnchor constraintEqualToConstant: totalWidth].active = YES;
}

- (void)addSliderLabel
{
    CGFloat thumbnailHeight = isIpad() ? 100.0 : 90.0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (@available(iOS 11.0, *)){
    sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenRect.size.height-thumbnailHeight-40-self.view.safeAreaInsets.bottom, SliderLabelWidth, SliderLabelHeight)];
    }
    else{
        sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenRect.size.height-thumbnailHeight-50, SliderLabelWidth, SliderLabelHeight)];
    }
    [sliderLabel setFont:[UIFont systemFontOfSize:15.0]];
    sliderLabel.layer.cornerRadius = 6.0;
    sliderLabel.layer.borderWidth = 1.0;
    sliderLabel.textAlignment = NSTextAlignmentCenter;
    sliderLabel.layer.borderColor = _themeVO.thumbnail_botton_bar_text_color.CGColor;
    [sliderLabel setBackgroundColor:_themeVO.thumbnail_slider_popup_background];
    [sliderLabel setTextColor:_themeVO.thumbnail_botton_bar_text_color];
    sliderLabel.layer.masksToBounds = YES;
    sliderLabel.hidden = YES;
    [self.view addSubview:sliderLabel];
}

#pragma mark Action Methods
- (void)sliderDragExit:(UISlider *)sender
{
    CGFloat sliderValue = sender.value;
    CGFloat pageNoFloat = sliderValue * (_totalNumberOfPages-1);
    NSInteger pageNo = lroundf(pageNoFloat);
    NSString *displayNum = [self getDisplayNumfromPageNo:[NSString stringWithFormat:@"%ld",(long)pageNo]];
    [self isPageNumberAvailble:displayNum];
}

- (void)sliderEventValueChanged:(UISlider *)sender
{
    sliderLabel.hidden = NO;
    CGRect trackRect = [sender trackRectForBounds:sender.bounds];
    CGRect thumbRect = [sender thumbRectForBounds:sender.bounds
                                                 trackRect:trackRect
                                                     value:sender.value];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect labelFrame = [sliderLabel frame];
    if (@available(iOS 11.0, *)){
        labelFrame.origin.x = thumbRect.origin.x-22+self.view.safeAreaInsets.left;
    }
    else{
        labelFrame.origin.x = thumbRect.origin.x-22;
    }
    if (labelFrame.origin.x < 0)
    {
        labelFrame.origin.x = 3;
    }
    else if (labelFrame.origin.x+SliderLabelWidth > screenRect.size.width)
    {
        labelFrame.origin.x = screenRect.size.width-SliderLabelWidth-3;
    }
    
    CGFloat thumbnailHeight = isIpad() ? 100.0 : 90.0;
    if (isKeyboardOpen)
    {
        labelFrame.origin.y = screenRect.size.height-thumbnailHeight-40-keyboardHeight;
    }
    
    [sliderLabel setFrame:labelFrame];
    CGFloat sliderValue = sender.value;
    CGFloat pageNoFloat = sliderValue * (_totalNumberOfPages-1);
    NSInteger pageNo = lroundf(pageNoFloat);
    NSString *displayNum = [self getDisplayNumfromPageNo:[NSString stringWithFormat:@"%ld",(long)pageNo]];
    [sliderLabel setText:[NSString stringWithFormat:@"Page %@",displayNum]];
}

- (void)prevPageButttonClicked
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickHistoryPreviousForFixedEpub)])
    {
        [self.delegate didClickHistoryPreviousForFixedEpub];
    }
}
-(void)nextPageButttonClicked
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickHistoryNextForFixedEpub)])
    {
        [self.delegate didClickHistoryNextForFixedEpub];
    }
}

- (void)didSingleTapOnView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didPerformActionToCloseThumbnail)])
    {
        [self.delegate didPerformActionToCloseThumbnail];
    }
}


#pragma mark TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchPageButtonClicked];
    return true;
}

#pragma mark Utility Methods
-(NSAttributedString *)setPlaceholdertextColor:(NSAttributedString *)placeholderText withColor:(UIColor *)color
{
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:placeholderText];
    [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [placeholderAttributedString length])];
    return placeholderAttributedString;
}

-(void)enablePreviousPageHistory:(BOOL)isEnabled
{
    prevEnable = isEnabled;
}
-(void)enableNextPageHistory:(BOOL)isEnabled
{
    nextEnable = isEnabled;
}

-(void)setLastPageDisplayNum
{
    NSDictionary *dict = _dataArray.lastObject;
    NSArray *pageArray = [dict valueForKey:@"Pages"];
    NSDictionary *dict1 = pageArray.lastObject;
    displayNumberOfLastPage = [dict1 valueForKey:@"DisplayNumber"];
}

-(void)searchPage:(NSString*)pageNumber
{
    NSString *gotoText = pageNumber;
    if([gotoText isEqualToString:@""])
    {
        NSString *err_Title  = [LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
        NSString *err_Msg = [LocalizationHelper localizedStringWithKey:@"PLEASE_ENTER_PAGE_NUMBER_ALERT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:err_Title message: err_Msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController] style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAlertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        if(![self isPageNumberAvailble:gotoText])
        {
            NSString *err_Title  = [LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
            NSString *err_Msg =  [LocalizationHelper localizedStringWithKey:@"PLEASE_ENTER_VALID_PAGE_NUMBER_ALERT" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:err_Title message:err_Msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okAlertAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(BOOL)isPageNumberAvailble:(NSString*)pageNumber
{
    for (NSDictionary *chapterDict in _dataArray)
    {
        NSArray *pageArray = [chapterDict valueForKey:@"Pages"];
        for (NSDictionary *dict in pageArray)
        {
            pageNumber = [[pageNumber stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
            NSString *displayNum = [[dict valueForKey:@"DisplayNumber"] lowercaseString];
            
            if([pageNumber isEqualToString:displayNum])
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(navigateToPageNo:)])
                {
                    NSString *page = [dict valueForKey:@"SRC"];
                    [self.delegate navigateToPageNo:page];
                }
                return YES;
            }
        }
    }
    return NO;
}

-(void)searchPageButtonClicked
{
    [self searchPage:gotoTextField.text];
    [gotoTextField resignFirstResponder];
    gotoTextField.text=@"";
}

-(void)enableNextButton:(BOOL)isEnabled
{
    if(isEnabled)
    {
        nextButton.alpha=1.0;
        nextButton.userInteractionEnabled = YES;
        nextButton.alpha=1.0;
        nextButton.userInteractionEnabled = YES;
    }
    else
    {
        nextButton.alpha=0.5;
        nextButton.userInteractionEnabled = NO;
        nextButton.alpha=0.5;
        nextButton.userInteractionEnabled = NO;
    }
}

-(void)enablePreviousButton:(BOOL)isEnabled
{
    if(isEnabled)
    {
        prevButton.alpha=1.0;
        prevButton.userInteractionEnabled = YES;
        prevButton.alpha=1.0;
        prevButton.userInteractionEnabled = YES;
    }
    else
    {
        prevButton.alpha=0.5;
        prevButton.userInteractionEnabled = NO;
        prevButton.alpha=0.5;
        prevButton.userInteractionEnabled = NO;
    }
}

- (NSString *)getDisplayNumfromPageNo:(NSString *)pageNo
{
    NSDictionary *dict = _dataArray.lastObject;
    NSArray *pageArray = [dict valueForKey:@"Pages"];
    for (NSDictionary *dict in pageArray)
    {
        NSString *page = [[dict valueForKey:@"PageNo"] stringValue];
        if ([page isEqualToString:pageNo])
        {
            return [dict valueForKey:@"DisplayNumber"];
            break;
        }
    }
    return @"";
}

#pragma mark Orientation Delagate methods
-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
    isKeyboardOpen = YES;
    CGRect keyboardRect = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    keyboardHeight = keyboardRect.size.height;
    if (@available(iOS 11.0, *)){
    thumbnailViewBottomConstraint.constant = -keyboardRect.size.height+self.view.safeAreaInsets.bottom;
    }
    else{
        thumbnailViewBottomConstraint.constant = -keyboardRect.size.height;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isKeyboardOpen = NO;
    thumbnailViewBottomConstraint.constant = 0;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGFloat thumbnailHeight = isIpad() ? 100.0 : 90.0;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (@available(iOS 11.0, *)){
            [sliderLabel setFrame:CGRectMake(100, screenRect.size.height-thumbnailHeight-40-self.view.safeAreaInsets.bottom, SliderLabelWidth, SliderLabelHeight)];
        }
        else{
            [sliderLabel setFrame:CGRectMake(100, screenRect.size.height-thumbnailHeight-50, SliderLabelWidth, SliderLabelHeight)];
        }
    }];
}

#pragma mark Dealloc
- (void)dealloc
{
    
}



@end
