//
//  ThumbnailViewController.m
//  ThumnailCollections
//
//  Created by Gaurav on 30/01/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import "KBThumbnailViewController.h"
#import "KitabooThumbnailCollectionViewCell.h"
#import "ReaderHeader.h"
#define windowWidth             [UIScreen mainScreen].bounds.size.width
#define windowHeight            [UIScreen mainScreen].bounds.size.height
#define cell_width  125
#define cell_height 194
#define IpadThumbnail_Height 290
#define bottomOfThumbnailIpad @{@"bottom":@0}
#define LocalizationBundleForKBThumbnailViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]
//#define color [UIColor greenColor]
//#define titleColor [UIColor whiteColor]
//#define bgColor [UIColor grayColor]

@interface KBThumbnailViewController ()<UICollectionViewDelegateFlowLayout>
{
    UICollectionView *iPadCollectionView,*iPhoneCollectionView;
    UIButton *prevPageIpadButton,*nextPageIpadButton,*searchButton ;
    UINavigationBar *navigationBar;
    UISlider *slider;
    UIView *bottomView,*thumbnailView;
    NSArray *chapIdArray,*chapNameArray,*pageIdArray;
    UILabel *pageLabel;
    UITextField *searchTextFieldIpad;
    int pageIndex,section;
    NSArray *topConstraints;
    float keyBoardHeight;
    //iPhone controls
    UIView *mainView,*searchPageBottomView,*gotoPageView,*topView;
    UIButton *prevPageButton,*nextPageButton,*gotoPageButton;
    UITextField *gotoPageTextField;
    NSMutableArray *totalPageArray,*pageImageArray,*totalFolioNumberArray;
    BOOL pageHistoryEnabled,prevEnable,nextEnable;
    NSLayoutConstraint *bottomConstraintForIphoneThumbnail;
    NSLayoutConstraint *sliderXPostionConstraint,*iphoneCollectionViewConst;
    UIColor *color,*titleColor,*bgColor,*chapterNameColor;
    NSString *displayNumberOfLastPage;
    UIInterfaceOrientation deviceOrientation;
}
@end
@implementation KBThumbnailViewController
-(id)init
{
    color = [UIColor greenColor];
    titleColor = [UIColor whiteColor];
    bgColor = [UIColor darkGrayColor];
    _pageIndexArray =[[NSMutableArray alloc]init];
    chapterNameColor = [UIColor colorWithHexString:@"#6E6E6E"];
    return self;
}
- (void)viewDidLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsPortrait(deviceOrientation)) || (UIInterfaceOrientationIsLandscape(deviceOrientation) && UIInterfaceOrientationIsPortrait(interfaceOrientation)) || deviceOrientation == UIInterfaceOrientationUnknown) {
        deviceOrientation = interfaceOrientation;
        [self scrollToSelectedPage];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setLastPageDisplayNum];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self showThumbnailViewForIpad];
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delegate=self;
        [self.view addGestureRecognizer:singleTap];
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self thumbnailForIphone];
        });
        
    }
}

-(void)formStudentDataArray {
    NSMutableArray *mutableDataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *chapterDict in _dataArray) {
        if ([chapterDict valueForKey:@"Pages"]) {
            NSArray *pageArray = [chapterDict valueForKey:@"Pages"];
            NSMutableArray *filteredPageArray = [[NSMutableArray alloc] init];
            for (NSDictionary *pageDict in pageArray) {
                if ([pageDict valueForKey:@"PageNo"] && [_studentSubmittedPageArray containsObject:[[pageDict valueForKey:@"PageNo"] stringValue]]) {
                    [filteredPageArray addObject:pageDict];
                }
            }
            if (filteredPageArray.count > 0) {
                NSMutableDictionary *filteredChapterDict = [chapterDict mutableCopy];
                [filteredChapterDict setValue:filteredPageArray forKey:@"Pages"];
                [mutableDataArray addObject:filteredChapterDict];
            }
        }
    }
    _dataArray = mutableDataArray;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [_delegate didSelectActionToCloseThumbnail];
    [searchTextFieldIpad resignFirstResponder];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:thumbnailView] || [touch.view isDescendantOfView:mainView] )
    {
        return NO;
    }
    return YES;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)setLastPageDisplayNum
{
       NSDictionary *dict = _dataArray.lastObject;
       NSArray *pageArray = [dict valueForKey:@"Pages"];
       NSDictionary *dict1 = pageArray.lastObject;
       displayNumberOfLastPage = [dict1 valueForKey:@"DisplayNumber"];
}
-(void)showThumbnailViewForIpad
{
    thumbnailView = [[UIView alloc]init];
    thumbnailView.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    thumbnailView.translatesAutoresizingMaskIntoConstraints =NO;
    [self.view addSubview:thumbnailView];
    NSDictionary *dict =@{@"thumbnail":thumbnailView};
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view.layoutMarginsGuide attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view.layoutMarginsGuide attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    topConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[thumbnail]-bottom-|" options:0 metrics:bottomOfThumbnailIpad views:dict];//bottom
    [self.view addConstraints:topConstraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:IpadThumbnail_Height]];
    UICollectionViewFlowLayout *flowLayout = [[RTLorLTRFlowLayoutForReader alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    iPadCollectionView =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    iPadCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [iPadCollectionView registerClass:[KitabooThumbnailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    iPadCollectionView.showsHorizontalScrollIndicator = NO;
    iPadCollectionView.delegate =self;
    iPadCollectionView.dataSource =self;
    iPadCollectionView.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    bottomView = [self bottomViewBarForIpad];
    bottomView.translatesAutoresizingMaskIntoConstraints =NO;
    bottomView.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    [thumbnailView addSubview:iPadCollectionView];
    [thumbnailView addSubview:bottomView];

    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:thumbnailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:thumbnailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:thumbnailView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:80]];
    
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:iPadCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:thumbnailView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:iPadCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:thumbnailView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:iPadCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [thumbnailView addConstraint:[NSLayoutConstraint constraintWithItem:iPadCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:thumbnailView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self setAccessibilityForThumbnailView];
    [self scrollToSelectedPage];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView == iPhoneCollectionView)
    {
        return 1;
    }
    return _dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *pagesDict;
    NSArray *pagesArray;
    if(collectionView == iPadCollectionView)
    {
        pagesDict = _dataArray [section];
        pagesArray = [pagesDict valueForKey:@"Pages"];
        return pagesArray.count;
    }
//    for(int i=0;i<_dataArray.count;i++)
//    {
//        pagesDict = _dataArray [i];
//        pagesArray=[pagesDict valueForKey:@"Pages"];
//        count+=pagesArray.count;
//    }
    return pageImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KitabooThumbnailCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=_themeVo.thumbnail_slider_popup_background;
    cell.accessibilityIdentifier = [NSString stringWithFormat:@"thumbnailCell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    cell.chapterTitleLabel.accessibilityIdentifier = [NSString stringWithFormat:@"thumbnailCellChapterTitleLbl%ld%ld",(long)indexPath.section,(long)indexPath.row];
    cell.pageNumLabelForHighlightedSection.accessibilityIdentifier = [NSString stringWithFormat:@"thumbnailCellPageNumLblForHighlightedSection%ld%ld",(long)indexPath.section,(long)indexPath.row];
    cell.pageNumLabel.accessibilityIdentifier = [NSString stringWithFormat:@"thumbnailCellPageNumLbl%ld%ld",(long)indexPath.section,(long)indexPath.row];
    cell.pageImageview.accessibilityIdentifier = [NSString stringWithFormat:@"thumbnailCellPageImageView%ld%ld",(long)indexPath.section,(long)indexPath.row];
    cell.pageNumLabelForHighlightedSection.textColor =  cell.pageNumLabel.textColor= self.themeVo.thumbnail_pageNo_text_color;
    cell.pageNumLabelForHighlightedSection.backgroundColor = _themeVo.thumbnail_selected_thumbnail_color;
    cell.pageNumLabel.backgroundColor = _themeVo.thumbnail_chapter_icon_color;
    cell.chapterTitleLabel.textColor = _themeVo.thumbnail_title_color;
    cell.pageImageview.layer.borderColor = _themeVo.thumbnail_default_thumbnail_color.CGColor;
    if(collectionView == iPadCollectionView)
    {
        NSDictionary *dict = _dataArray [indexPath.section];
        NSArray *pageArray = [dict valueForKey:@"Pages"];
        NSDictionary *dict1 = pageArray [indexPath.row];
    
        cell.pageNumLabelForHighlightedSection.text = cell.pageNumLabel.text = [dict1 valueForKey:@"DisplayNumber"];
        [cell.pageImageview setImage: [UIImage imageWithContentsOfFile:[dict1 valueForKey:@"PageThumbnailPath"]]];
        cell.chapterTitleLabel.text = [dict valueForKey:@"ChapterTitle"];
        NSString *row = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        NSString *currentSection = [NSString stringWithFormat:@"%d",(int)indexPath.section];
        if(indexPath.row == 0){
            cell.chapterTitleLabel.hidden = NO;
        }
        else{
            cell.chapterTitleLabel.text = @"";
        }
        
        [cell layoutSubviews];
        
        for(int i =0;i<_pageIndexArray.count;i++)
        {
            NSDictionary *dict = _pageIndexArray [i];
            if([[dict valueForKey:@"section"] isEqualToString:currentSection]){
                cell.chapterTitleLabel.textColor = _themeVo.thumbnail_selected_title_color;

            }
            else{
                cell.chapterTitleLabel.textColor = _themeVo.thumbnail_title_color;
            }
            if([[dict valueForKey:@"index"] isEqualToString:row] && [[dict valueForKey:@"section"] isEqualToString:currentSection])
            {
                cell.pageSuperView.layer.borderColor = _themeVo.thumbnail_selected_thumbnail_color.CGColor;
                cell.pageSuperView.layer.borderWidth = 2.0;
                cell.pageNumLabelForHighlightedSection.hidden = NO;
                break;
            }
            else
            {
                cell.pageNumLabelForHighlightedSection.hidden = YES;
                cell.pageSuperView.layer.borderWidth = 0.0;

            }
        }
        return cell;
    }
    NSDictionary *dict = pageImageArray[indexPath.row];
    cell.pageNumLabelForHighlightedSection.text = cell.pageNumLabel.text = [dict valueForKey:@"DisplayNumber"];
    [cell.pageImageview setImage: [UIImage imageWithContentsOfFile:[dict valueForKey:@"PageThumbnailPath"]]];
    cell.chapterTitleLabel.text = [dict valueForKey:@"ChapterTitle"];
    NSDictionary *currentPage = pageImageArray[pageIndex];
    if([[dict valueForKey:@"ChapterID"] isEqualToString:[currentPage valueForKey:@"ChapterID"]]){
        cell.chapterTitleLabel.textColor = _themeVo.thumbnail_selected_title_color;
    }
    else{
        cell.chapterTitleLabel.textColor = _themeVo.thumbnail_title_color;
    }

    if(pageIndex == indexPath.row)
    {
        cell.pageSuperView.layer.borderColor = _themeVo.thumbnail_selected_thumbnail_color.CGColor;
        cell.pageSuperView.layer.borderWidth = 2.0;
        cell.pageNumLabelForHighlightedSection.hidden = NO;
    }
    else
    {
        cell.pageNumLabelForHighlightedSection.hidden = YES;
        cell.pageSuperView.layer.borderWidth = 0.0;
    }
    
    [cell layoutSubviews];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if(collectionView == iPhoneCollectionView)
        return 1;
    return  55;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIDeviceOrientation ori = [[UIDevice currentDevice]orientation];
    if(collectionView == iPhoneCollectionView && (ori == UIDeviceOrientationPortraitUpsideDown))
    {
        return CGSizeMake(cell_width, cell_height);
    }
    else if(collectionView == iPhoneCollectionView && (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)))
        return CGSizeMake(cell_width, cell_height);
    else if(collectionView == iPhoneCollectionView)
        return CGSizeMake(collectionView.frame.size.width/3 - 2, (collectionView.frame.size.width/3 - 2) * 1.6);
    else
        return CGSizeMake(cell_width, cell_height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(collectionView == iPhoneCollectionView)
        return UIEdgeInsetsMake(0, 0, 0,0);
    else
        return UIEdgeInsetsMake(4, 15, 0, 20);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[AnalyticsManager getInstance] notifyEvent:KitabooReaderEventConstant.thumbnailEventName WithEventInfo:nil];
    pageIndex = (int)indexPath.row;
    section = (int)indexPath.section;
    [self didSelectPageNumber];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    if(collectionView == iPadCollectionView)
//        return CGSizeMake(cell_width, cell_height);
//    else
        return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    return reusableview;
}
-(UIView *)bottomViewBarForIpad
{
    UIView *view = [[UIView alloc]init];
    slider = [[UISlider alloc]init];
    slider.thumbTintColor = _themeVo.thumbnail_slider_filled_color;
    slider.tintColor = _themeVo.thumbnail_slider_filled_color;
    slider.maximumTrackTintColor = _themeVo.thumbnail_slider_slider_color;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderMove:) forControlEvents:UIControlEventValueChanged];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:slider];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30]];
    UIView *bottomButtonsView = [[UIView alloc]init];
    bottomButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:bottomButtonsView];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:bottomButtonsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:bottomButtonsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: view attribute:NSLayoutAttributeTop multiplier:1.0 constant:35]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:bottomButtonsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
//    [view addConstraint:[NSLayoutConstraint constraintWithItem:bottomButtonsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:350]];
    
    UIView *pageNumberContainer = [[UIView alloc] init];
    pageNumberContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomButtonsView addSubview:pageNumberContainer];
    [pageNumberContainer.centerXAnchor constraintEqualToAnchor:bottomButtonsView.centerXAnchor].active = YES;
    [pageNumberContainer.topAnchor constraintEqualToAnchor:bottomButtonsView.topAnchor].active = YES;
    [pageNumberContainer.bottomAnchor constraintEqualToAnchor:bottomButtonsView.bottomAnchor].active = YES;

    pageLabel = [[UILabel alloc]init];
    if(isRTL()){
        [pageLabel setText:[NSString stringWithFormat:@"%@\\",displayNumberOfLastPage]];
    }else{
        [pageLabel setText:[NSString stringWithFormat:@"/%@",displayNumberOfLastPage]];
    }
    
    pageLabel.textColor = _themeVo.thumbnail_botton_bar_text_color;
    [pageLabel setFont:getCustomFont(15)];
    pageLabel.textAlignment = NSTextAlignmentNatural;
    [pageNumberContainer addSubview:pageLabel];
    pageLabel.translatesAutoresizingMaskIntoConstraints =NO;
    [pageLabel.trailingAnchor constraintEqualToAnchor:pageNumberContainer.trailingAnchor].active = YES;
    [pageLabel.topAnchor constraintEqualToAnchor:pageNumberContainer.topAnchor].active = YES;
    [pageLabel.bottomAnchor constraintEqualToAnchor:pageNumberContainer.bottomAnchor constant:-1].active = YES;
    [pageLabel.widthAnchor constraintGreaterThanOrEqualToConstant:20].active = YES;
    [pageLabel.widthAnchor constraintLessThanOrEqualToConstant:200].active = YES;
    searchTextFieldIpad = [[UITextField alloc]init];
    searchTextFieldIpad.placeholder = [LocalizationHelper localizedStringWithKey:@"GO_TO" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
    searchTextFieldIpad.textAlignment = isRTL() ? NSTextAlignmentLeft:NSTextAlignmentRight;
//    [searchTextFieldIpad setValue:_themeVo.thumbnail_botton_bar_text_color forKeyPath:@"_placeholderLabel.textColor"];
    searchTextFieldIpad.attributedPlaceholder = [self setPlaceholdertextColor:searchTextFieldIpad.attributedPlaceholder withColor:_themeVo.thumbnail_botton_bar_text_color];
    searchTextFieldIpad.backgroundColor = UIColor.clearColor;
    searchTextFieldIpad.textColor = _themeVo.thumbnail_botton_bar_text_color;
    searchTextFieldIpad.text = self.activeDisplayNumber;
    searchTextFieldIpad.delegate =self;
    [searchTextFieldIpad setFont:getCustomFont(15)];

    [pageNumberContainer addSubview:searchTextFieldIpad];
    searchTextFieldIpad.translatesAutoresizingMaskIntoConstraints =NO;
    [searchTextFieldIpad.leadingAnchor constraintEqualToAnchor:pageNumberContainer.leadingAnchor].active = YES;
    [searchTextFieldIpad.trailingAnchor constraintEqualToAnchor:pageLabel.leadingAnchor constant:0].active = YES;
    [searchTextFieldIpad.topAnchor constraintEqualToAnchor:pageNumberContainer.topAnchor].active = YES;
    [searchTextFieldIpad.bottomAnchor constraintEqualToAnchor:pageNumberContainer.bottomAnchor].active = YES;
    [searchTextFieldIpad.widthAnchor constraintEqualToConstant:30].active = YES;
    
    prevPageIpadButton = [[UIButton alloc]init];
    [prevPageIpadButton setTitle:@"I" forState:UIControlStateNormal];
    [prevPageIpadButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:24.0f]];
    [prevPageIpadButton addTarget:self action:@selector(prevPageButttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [prevPageIpadButton setTitleColor:_themeVo.thumbnail_botton_bar_text_color forState:UIControlStateNormal];
    prevPageIpadButton.translatesAutoresizingMaskIntoConstraints=NO;
    [bottomButtonsView addSubview:prevPageIpadButton];
    [self enablePreviousButton:prevEnable];
    
    
    [bottomButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:prevPageIpadButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomButtonsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [prevPageIpadButton.trailingAnchor constraintEqualToAnchor:pageNumberContainer.leadingAnchor constant:0].active = YES;
    [prevPageIpadButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [prevPageIpadButton.topAnchor constraintEqualToAnchor:bottomButtonsView.topAnchor].active = YES;

    nextPageIpadButton = [[UIButton alloc]init];
    [nextPageIpadButton setTitle:@"J" forState:UIControlStateNormal];
    [nextPageIpadButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:24.0f]];
    [nextPageIpadButton addTarget:self action:@selector(nextPageButttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [nextPageIpadButton setTitleColor:_themeVo.thumbnail_botton_bar_text_color forState:UIControlStateNormal];
    nextPageIpadButton.translatesAutoresizingMaskIntoConstraints=NO;
    [bottomButtonsView addSubview:nextPageIpadButton];
    [self enableNextButton:nextEnable];
    
    [bottomButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:nextPageIpadButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bottomButtonsView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [bottomButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:nextPageIpadButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomButtonsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [nextPageIpadButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [nextPageIpadButton.leadingAnchor constraintEqualToAnchor:pageNumberContainer.trailingAnchor constant:0].active = YES;
    [self addShadow:thumbnailView];
    return  view;
}

-(void)addShadow :(UIView *)shadowView{
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    shadowView.layer.shadowOpacity = 0.4f;
    shadowView.layer.borderWidth = .4;
    shadowView.layer.shadowRadius = 1;
    shadowView.layer.borderColor = _themeVo.thumbnail_slider_popup_background.CGColor;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateThumbnailSliderView];
}

-(void)sliderMove:(UISlider *)sender
{
    if(iPadCollectionView != nil){
    CGFloat width = CGRectGetWidth(iPadCollectionView.bounds);
    CGFloat contentWidth = iPadCollectionView.contentSize.width;
    CGFloat sliderValue = sender.value;
    CGFloat maxX = contentWidth - width;
    CGFloat x = (maxX * sliderValue);
    if (maxX > 0)
    {
            iPadCollectionView.contentOffset = CGPointMake(x, iPadCollectionView.contentOffset.y);
    }
    }
    else{
        CGFloat height = CGRectGetHeight(iPhoneCollectionView.bounds);
        CGFloat contentWidth = iPhoneCollectionView.contentSize.height;
        CGFloat sliderValue = sender.value;
        CGFloat maxX = contentWidth - height;
        CGFloat y = (maxX * sliderValue);
        if (maxX > 0)
        {
            iPhoneCollectionView.contentOffset = CGPointMake(iPhoneCollectionView.contentOffset.x, y);
        }
    }
}
- (void) updateThumbnailSliderView
{
    if(iPadCollectionView != nil){
    CGFloat x = iPadCollectionView.contentOffset.x;
    CGFloat width = CGRectGetWidth(iPadCollectionView.bounds);
    CGFloat contentWidth = iPadCollectionView.contentSize.width;
    CGFloat maxX = contentWidth - width;
    if (maxX > 0)
    {
        slider.value = x/maxX;
    }
    else
    {
        slider.value = slider.maximumValue;
    }
    }
    else{
        CGFloat y = iPhoneCollectionView.contentOffset.y;
        CGFloat height = CGRectGetHeight(iPhoneCollectionView.bounds);
        CGFloat contentHeight = iPhoneCollectionView.contentSize.height;
        CGFloat maxY = contentHeight - height;
        if (maxY > 0)
        {
            slider.value = y/maxY;
        }
        else
        {
            slider.value = slider.maximumValue;
        }
    }
}
-(void)didSelectPageNumber
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectThumbnailPageNo:)])
        {
            NSDictionary *chapterDict = _dataArray [section];
            NSArray *pageArray = [chapterDict valueForKey:@"Pages"];
            NSDictionary *d = pageArray [pageIndex];
            NSString *page = [[d valueForKey:@"PageNo"] stringValue];
            [self.delegate didSelectThumbnailPageNo:page];
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectThumbnailPageNo:)])
        {
            [self.delegate didSelectThumbnailPageNo:totalPageArray[pageIndex]];
        }
    }
}
-(void)selectPageAt:(NSString *)pageNum
{
    if (_studentSubmittedPageArray && _studentSubmittedPageArray.count > 0) {
        [self formStudentDataArray];
    }
    int pageNotPresent =1;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        for(int i=0;i<_dataArray.count;i++)
        {
            NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    
            NSDictionary *dict = _dataArray [i];
            NSArray *pageArray = [dict valueForKey:@"Pages"];
            for(NSDictionary *d in pageArray)
            {
                 [mutArray addObject:[[d valueForKey:@"PageNo"] stringValue]];
            }
            if([mutArray containsObject:pageNum])
            {
                pageIndex = (int)[mutArray indexOfObject:pageNum];
                section = i;
          
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
                [dict setValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"index"];
                [dict setValue:[NSString stringWithFormat:@"%d",section] forKey:@"section"];
                
                [_pageIndexArray addObject:dict];
                
                pageNotPresent =0;
                break;
            }
        }
        if(pageNotPresent)
        {
            pageIndex = 0;
            section = 0;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dict setValue:@"0" forKey:@"index"];
            [dict setValue:@"0" forKey:@"section"];
            [_pageIndexArray addObject:dict];
        }

        [self viewDidLayoutSubviews];
        [iPadCollectionView reloadData];
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        [self setPageNumberAndPageImage];
        if([totalPageArray containsObject:pageNum])
        {
            pageIndex = (int)[totalPageArray indexOfObject:pageNum];
        }
        else
        {
            pageIndex = 0;
        }
        [self viewDidLayoutSubviews];
        [iPhoneCollectionView reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)thumbnailForIphone
{
    self.view.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    mainView = [[UIView alloc]init];
    mainView.translatesAutoresizingMaskIntoConstraints =NO;
    [self.view addSubview:mainView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view.layoutMarginsGuide attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view.layoutMarginsGuide attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    if (@available(iOS 11.0, *))
    {
     bottomConstraintForIphoneThumbnail = [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    }
    else
    {
     bottomConstraintForIphoneThumbnail = [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    }
    [self.view addConstraint:bottomConstraintForIphoneThumbnail];
    
    if (@available(iOS 11.0, *))
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant: 0]];
    }
    else
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant: 0]];
    }
    searchPageBottomView = [[UIView alloc]init];
    searchPageBottomView.translatesAutoresizingMaskIntoConstraints =NO;
    searchPageBottomView.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    [mainView addSubview:searchPageBottomView];
    [self addShadow:searchPageBottomView];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:searchPageBottomView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:searchPageBottomView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:searchPageBottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:searchPageBottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:60]];
    UIView *pageNumberContainer = [[UIView alloc] init];
    pageNumberContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [searchPageBottomView addSubview:pageNumberContainer];
    [pageNumberContainer.centerXAnchor constraintEqualToAnchor:searchPageBottomView.centerXAnchor].active = YES;
    [pageNumberContainer.topAnchor constraintEqualToAnchor:searchPageBottomView.topAnchor].active = YES;
    [pageNumberContainer.bottomAnchor constraintEqualToAnchor:searchPageBottomView.bottomAnchor].active = YES;
    [pageNumberContainer.widthAnchor constraintEqualToConstant:74].active = YES;

//    [pageNumberContainer setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    pageLabel = [[UILabel alloc]init];
    if(isRTL()){
        [pageLabel setText:[NSString stringWithFormat:@"%@\\",displayNumberOfLastPage]];
    }else{
        [pageLabel setText:[NSString stringWithFormat:@"/%@",displayNumberOfLastPage]];
    }
    pageLabel.textColor = _themeVo.thumbnail_botton_bar_text_color;
    [pageLabel setFont:getCustomFont(15)];
    pageLabel.textAlignment = NSTextAlignmentNatural;
    [pageNumberContainer addSubview:pageLabel];
    pageLabel.translatesAutoresizingMaskIntoConstraints =NO;
    [pageLabel.trailingAnchor constraintEqualToAnchor:pageNumberContainer.trailingAnchor].active = YES;
    [pageLabel.topAnchor constraintEqualToAnchor:pageNumberContainer.topAnchor].active = YES;
    [pageLabel.bottomAnchor constraintEqualToAnchor:pageNumberContainer.bottomAnchor].active = YES;
    searchTextFieldIpad = [[UITextField alloc]init];
//    searchTextFieldIpad.placeholder = [LocalizationHelper localizedStringWithKey:@"GO_TO"];
    searchTextFieldIpad.textAlignment = isRTL() ? NSTextAlignmentLeft : NSTextAlignmentRight;
//    [searchTextFieldIpad setValue:_themeVo.thumbnail_botton_bar_text_color forKeyPath:@"_placeholderLabel.textColor"];
    searchTextFieldIpad.attributedPlaceholder = [self setPlaceholdertextColor:searchTextFieldIpad.attributedPlaceholder withColor:_themeVo.thumbnail_botton_bar_text_color];
    searchTextFieldIpad.backgroundColor = UIColor.clearColor;
    searchTextFieldIpad.textColor = _themeVo.thumbnail_botton_bar_text_color;
    searchTextFieldIpad.text = self.activeDisplayNumber;
    searchTextFieldIpad.delegate =self;
    [searchTextFieldIpad invalidateIntrinsicContentSize];
    [searchTextFieldIpad setFont:getCustomFont(15)];
    
    [pageNumberContainer addSubview:searchTextFieldIpad];
    searchTextFieldIpad.translatesAutoresizingMaskIntoConstraints =NO;
    [searchTextFieldIpad.leadingAnchor constraintEqualToAnchor:pageNumberContainer.leadingAnchor].active = YES;
    [searchTextFieldIpad.trailingAnchor constraintEqualToAnchor:pageLabel.leadingAnchor].active = YES;
    [searchTextFieldIpad.topAnchor constraintEqualToAnchor:pageNumberContainer.topAnchor].active = YES;
    [searchTextFieldIpad.bottomAnchor constraintEqualToAnchor:pageNumberContainer.bottomAnchor].active = YES;
    [searchTextFieldIpad.widthAnchor constraintEqualToAnchor:pageLabel.widthAnchor].active = YES;

    prevPageButton = [[UIButton alloc]init];
    [prevPageButton setTitle:@"I" forState:UIControlStateNormal];
    [prevPageButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:30.0f]];
    [prevPageButton setTitleColor:_themeVo.thumbnail_icon_color forState:UIControlStateNormal];
    [prevPageButton addTarget:self action:@selector(prevPageButttonClicked) forControlEvents:UIControlEventTouchUpInside];
    prevPageButton.translatesAutoresizingMaskIntoConstraints=NO;
    [searchPageBottomView addSubview:prevPageButton];
    [prevPageButton.trailingAnchor constraintEqualToAnchor:pageNumberContainer.leadingAnchor constant:0].active = YES;
    [prevPageButton.topAnchor constraintEqualToAnchor:searchPageBottomView.topAnchor constant:0].active = YES;
    [prevPageButton.bottomAnchor constraintEqualToAnchor:searchPageBottomView.bottomAnchor constant:0].active = YES;
    [prevPageButton.widthAnchor constraintEqualToConstant:50].active = YES;
    prevPageButton.accessibilityIdentifier = @"prevbtn";
    [self enablePreviousButton:prevEnable];
    nextPageButton = [[UIButton alloc]init];
    [nextPageButton setTitle:@"J" forState:UIControlStateNormal];
    [nextPageButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:30.0f]];
    [nextPageButton setTitleColor:_themeVo.thumbnail_icon_color forState:UIControlStateNormal];
    [nextPageButton addTarget:self action:@selector(nextPageButttonClicked) forControlEvents:UIControlEventTouchUpInside];
    nextPageButton.translatesAutoresizingMaskIntoConstraints=NO;
    //NSInteger indexCount = [iPhoneCollectionView numberOfItemsInSection:section];
    [searchPageBottomView addSubview:nextPageButton];
    [self enableNextButton:nextEnable];
    [nextPageButton.leadingAnchor constraintEqualToAnchor:pageNumberContainer.trailingAnchor constant:0].active = YES;
    [nextPageButton.topAnchor constraintEqualToAnchor:searchPageBottomView.topAnchor constant:0].active = YES;
    [nextPageButton.bottomAnchor constraintEqualToAnchor:searchPageBottomView.bottomAnchor constant:0].active = YES;
    [nextPageButton.widthAnchor constraintEqualToConstant:50].active = YES;
//    [searchPageBottomView addConstraint:[NSLayoutConstraint constraintWithItem:nextPageButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:searchPageBottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
//    [searchPageBottomView addConstraint:[NSLayoutConstraint constraintWithItem:nextPageButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:prevPageButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
//    [searchPageBottomView addConstraint:[NSLayoutConstraint constraintWithItem:nextPageButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:searchPageBottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
//    [searchPageBottomView addConstraint:[NSLayoutConstraint constraintWithItem:nextPageButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:50]];
    topView = [[UIView alloc]init];
    topView.translatesAutoresizingMaskIntoConstraints =NO;
    topView.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    [mainView addSubview:topView];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:44]];
    UIButton *backButton = [[UIButton alloc]init];
    backButton.accessibilityIdentifier = THUMBNAIL_IPHONE_BACK_BTN;
    [backButton setTitle:@"G" forState:UIControlStateNormal];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [backButton.titleLabel setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:20.0f]];
    [backButton setTitleColor:_themeVo.thumbnail_botton_bar_text_color forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.translatesAutoresizingMaskIntoConstraints=NO;
    [topView addSubview:backButton];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:44]];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [backButton.heightAnchor constraintEqualToConstant:44].active = YES;
    UILabel *thumbnailLabel = [[UILabel alloc]init];
    thumbnailLabel.text = [LocalizationHelper localizedStringWithKey:@"THUMBNAILS" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKBThumbnailViewController];
    [thumbnailLabel setFont:getCustomFont(20)];
    [thumbnailLabel setTextColor:_themeVo.thumbnail_botton_bar_text_color];
    thumbnailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [topView addSubview:thumbnailLabel];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:backButton attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5]];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:200]];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:thumbnailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 6;
    iPhoneCollectionView =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    iPhoneCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [iPhoneCollectionView registerClass:[KitabooThumbnailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    iPhoneCollectionView.delegate = self;
    iPhoneCollectionView.dataSource = self;
    iPhoneCollectionView.showsVerticalScrollIndicator = NO;
    iPhoneCollectionView.showsHorizontalScrollIndicator = NO;

    iPhoneCollectionView.backgroundColor = _themeVo.thumbnail_slider_popup_background;
    [mainView addSubview:iPhoneCollectionView];
    [iPhoneCollectionView reloadData];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:iPhoneCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    iphoneCollectionViewConst =[NSLayoutConstraint constraintWithItem:iPhoneCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40];
    [mainView addConstraint:iphoneCollectionViewConst];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:iPhoneCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:searchPageBottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-8]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:iPhoneCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    slider = [[UISlider alloc]init];
    slider.thumbTintColor = _themeVo.thumbnail_slider_filled_color;
    slider.tintColor = _themeVo.thumbnail_slider_filled_color;
    slider.maximumTrackTintColor = _themeVo.thumbnail_slider_slider_color;
//    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderMove:) forControlEvents:UIControlEventValueChanged];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [mainView addSubview:slider];
//    [iPhoneCollectionView.trailingAnchor constraintEqualToAnchor:slider.leadingAnchor].active = YES;
    sliderXPostionConstraint = [slider.centerXAnchor constraintEqualToAnchor:mainView.layoutMarginsGuide.centerXAnchor constant:isRTL() ? -(windowWidth/2 - 20) : windowWidth/2 - 20];
    sliderXPostionConstraint.active = YES;
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        if(windowWidth == 812){
            sliderXPostionConstraint.constant = isRTL() ? -(windowWidth/2 - 52) : windowWidth/2 - 52;
        }
        else
            sliderXPostionConstraint.constant = isRTL() ? -(windowWidth/2 - 24) : windowWidth/2 - 24;
    }
    [slider.centerYAnchor constraintEqualToAnchor:mainView.centerYAnchor constant:-12].active = YES;
    [slider.widthAnchor constraintEqualToAnchor:iPhoneCollectionView.heightAnchor constant:-24].active = YES;
    UIImage* thumnailSliderThumbImage = [UIImage imageNamed:@"ThumnailSliderThumbImage" inBundle:[NSBundle bundleForClass:[ReaderViewController class]] compatibleWithTraitCollection:nil];
    [slider setThumbImage:[self offsetThumbImage:thumnailSliderThumbImage withColor:_themeVo.thumbnail_slider_filled_color] forState:UIControlStateNormal];
    [slider setThumbImage:[self offsetThumbImage:thumnailSliderThumbImage withColor:_themeVo.thumbnail_slider_filled_color] forState:UIControlStateHighlighted];
    
    if(isRTL())
    {
        slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else
    {
        slider.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    [mainView bringSubviewToFront:searchPageBottomView];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    [self setPageNumberAndPageImage];
    [self setAccessibilityForThumbnailView];
    [self scrollToSelectedPage];
}

-(void)scrollToSelectedPage {
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [iPadCollectionView layoutIfNeeded];
        NSIndexPath *nextItem;
        nextItem = [NSIndexPath indexPathForItem:pageIndex inSection:section];
        [iPadCollectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    else
    {
        [iPhoneCollectionView layoutIfNeeded];
        NSIndexPath *nextItem;
        nextItem = [NSIndexPath indexPathForItem:pageIndex inSection:0];
        [iPhoneCollectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

- (UIImage*)offsetThumbImage:(UIImage*)image withColor:(UIColor*)color {
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGRect imageRect = CGRectMake(0, 0, 31, 31);
    UIGraphicsBeginImageContextWithOptions(imageRect.size, FALSE, 0.0);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0.5, 31, 31)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark
#pragma Text Field placeholder color
-(NSAttributedString *)setPlaceholdertextColor:(NSAttributedString *)placeholderText withColor:(UIColor *)color
{
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:placeholderText];
    [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [placeholderAttributedString length])];
    return placeholderAttributedString;
}

-(void)setPageNumberAndPageImage
{
    totalPageArray =[[NSMutableArray alloc]init];
    pageImageArray =[[NSMutableArray alloc]init];
    totalFolioNumberArray =[[NSMutableArray alloc]init];
    for(int i=0;i<_dataArray.count;i++)
    {
        NSDictionary *dict = _dataArray [i];
        NSArray *pageArray = [dict valueForKey:@"Pages"];

        for(NSMutableDictionary *d in pageArray)
        {
            NSString *pageNO = [[d valueForKey:@"PageNo"] stringValue];
            [totalPageArray addObject:pageNO];
            NSString *folioNumber = [d valueForKey:@"DisplayNumber"];
            [totalFolioNumberArray addObject:folioNumber];
            if([pageArray indexOfObject:d] == 0)
                [d setValue:[dict valueForKey:@"ChapterTitle"] forKey:@"ChapterTitle"];
            else
                [d setValue:@YES forKey:@"isCurrentChapter"];
            [d setValue:[dict valueForKey:@"ChapterID"] forKey:@"ChapterID"];
            [pageImageArray addObject:d];
        }
        
    }
}
-(void)prevPageButttonClicked
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickPreviousHistoryButtonWithCurrentPageNumber)])
    {
        [self.delegate didClickPreviousHistoryButtonWithCurrentPageNumber];
    }
}
-(void)nextPageButttonClicked
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickNextHistoryButtonWithCurrentPageNumber)])
    {
        [self.delegate didClickNextHistoryButtonWithCurrentPageNumber];
    }
}
-(void)backButtonClicked:(UIButton *)sender
{
    if(gotoPageTextField.isFirstResponder)
        [gotoPageTextField resignFirstResponder];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectActionToCloseThumbnail)])
    {
        [_delegate didSelectActionToCloseThumbnail];
    }
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
            if([pageNumber isEqualToStringIgnoreCase:[dict valueForKey:@"DisplayNumber"]])
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectThumbnailPageNo:)])
                {
                    NSString *page = [[dict valueForKey:@"PageNo"] stringValue];
                    [self.delegate didSelectThumbnailPageNo:page];
                }
                return YES;
            }
        }
    }
    return NO;
}
-(void)searchPageButtonClicked //iPad
{
    [self searchPage:searchTextFieldIpad.text];
    [searchTextFieldIpad resignFirstResponder];
    searchTextFieldIpad.text=@"";
}
-(void)goToPageButtonClicked //iPhone
{
    [self searchPage:gotoPageTextField.text];
    [gotoPageTextField resignFirstResponder];
    [gotoPageTextField setText:@""];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:gotoPageTextField])//iPhone
    {
        [self goToPageButtonClicked];
    }
    else
    {
        [self searchPageButtonClicked];
    }
    return true;
}

-(void)setThumbnailBackgroundColor:(UIColor *)backgroundColor
{
    bgColor=backgroundColor;
}
-(void)setChapterIdAndTitleTextColor:(UIColor *)textColor
{
    titleColor=textColor;
}

-(void)setPageNumberTextColor:(UIColor *)textColor
{
    color=textColor;
}
-(void)setTotalPageNumber:(NSString *)textTotalPage{
    pageLabel.text = textTotalPage;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* d = [notification userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    r = [self.view convertRect:r fromView:nil];
    NSString *height = [NSString stringWithFormat:@"%lf",r.size.height];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        NSDictionary *dict =@{@"thumbnail":thumbnailView};
        [self.view removeConstraints:topConstraints];
        topConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[thumbnail]-(padding)-|" options:0 metrics:@{@"padding":height} views:dict];
        [self.view addConstraints:topConstraints];
    }
    else
    {
        if(isIphoneX)
            bottomConstraintForIphoneThumbnail.constant = -r.size.height + 34;
        else
        bottomConstraintForIphoneThumbnail.constant = -r.size.height;
    }

}
-(void)keyboardWillHide:(NSNotification*)notification
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.view removeConstraints:topConstraints];
        NSDictionary *dict =@{@"thumbnail":thumbnailView};
        topConstraints= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[thumbnail]-bottom-|" options:0 metrics:bottomOfThumbnailIpad views:dict];
        [self.view addConstraints:topConstraints];
    }
    else
    {
        bottomConstraintForIphoneThumbnail.constant =0;
    }
}

-(void)dealloc
{
    iPadCollectionView =nil;
    iPhoneCollectionView =nil;
    totalPageArray=nil;
    pageImageArray=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark Orientation Delagate methods
-(BOOL)shouldAutorotate{
    return YES;
}

-(void)enablePreviousButton:(BOOL)isEnabled
{
    if(isEnabled)
    {
        prevPageButton.alpha=1.0;
        prevPageButton.userInteractionEnabled = YES;
        prevPageIpadButton.alpha=1.0;
        prevPageIpadButton.userInteractionEnabled = YES;
    }
    else
    {
        prevPageButton.alpha=0.5;
        prevPageButton.userInteractionEnabled = NO;
        prevPageIpadButton.alpha=0.5;
        prevPageIpadButton.userInteractionEnabled = NO;
    }
}

-(void)enableNextButton:(BOOL)isEnabled
{
    if(isEnabled)
    {
        nextPageButton.alpha=1.0;
        nextPageButton.userInteractionEnabled = YES;
        nextPageIpadButton.alpha=1.0;
        nextPageIpadButton.userInteractionEnabled = YES;
    }
    else
    {
        nextPageButton.alpha=0.5;
        nextPageButton.userInteractionEnabled = NO;
        nextPageIpadButton.alpha=0.5;
        nextPageIpadButton.userInteractionEnabled = NO;
    }
}
-(void)enablePreviousPageHistory:(BOOL)isEnabled
{
    prevEnable = isEnabled;
    [self enablePreviousButton:isEnabled];
}
-(void)enableNextPageHistory:(BOOL)isEnabled
{
    nextEnable = isEnabled;
    [self enableNextButton:isEnabled];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        UIDeviceOrientation ori = [[UIDevice currentDevice]orientation];
        switch(ori)
        {
            case UIDeviceOrientationPortrait: case UIDeviceOrientationPortraitUpsideDown:{
                sliderXPostionConstraint.constant = isRTL() ? -(windowWidth/2 - 20):windowWidth/2 - 20;
            }
            break;
            case UIDeviceOrientationLandscapeLeft: case UIDeviceOrientationLandscapeRight:{
                if(windowWidth == 812){
                    sliderXPostionConstraint.constant = isRTL() ? -(windowWidth/2 - 52) :windowWidth/2 - 52;
                }
                else
                    sliderXPostionConstraint.constant = isRTL() ? -(windowWidth/2 - 24) : windowWidth/2 - 24;
            }
            break;
            default:
                break;
        };

        if (iPhoneCollectionView)
        [iPhoneCollectionView reloadData];
    }];
}
#pragma mark : - orientation change method
- (void)orientationChanged:(NSNotification *)note
{
//    UIDevice * device = note.object;
//    switch(device.orientation)
//    {
//        case UIDeviceOrientationPortrait: case UIDeviceOrientationPortraitUpsideDown:{
//            sliderXPostionConstraint.constant = windowWidth/2 - 20;
//
//        }
//            break;
//
//        case UIDeviceOrientationLandscapeLeft: case UIDeviceOrientationLandscapeRight:{
//            if(windowWidth == 812){
//                sliderXPostionConstraint.constant = windowWidth/2 - 52;
//            }
//            else
//            sliderXPostionConstraint.constant = windowWidth/2 - 24;
//
//        }
//            break;
//
//        default:
//            break;
//    };
//    [iPhoneCollectionView reloadData];
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

- (void)setAccessibilityForThumbnailView
{
    prevPageIpadButton.accessibilityIdentifier = THUMBNAIL_IPAD_PREV_BTN;
    nextPageIpadButton.accessibilityIdentifier = THUMBNAIL_IPAD_NEXT_BTN;
    searchTextFieldIpad.accessibilityIdentifier = THUMBNAIL_SEARCH_TEXT_FIELD;
    slider.accessibilityIdentifier = THUMBNAIL_SLIDER;
    prevPageButton.accessibilityIdentifier = THUMBNAIL_IPHONE_PREV_BTN;
    nextPageButton.accessibilityIdentifier = THUMBNAIL_IPHONE_NEXT_BTN;
    slider.currentThumbImage .accessibilityIdentifier = @"thumb";
}

@end
