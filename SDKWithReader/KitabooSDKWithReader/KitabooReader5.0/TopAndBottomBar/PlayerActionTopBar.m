//
//  PlayerActionTopBar.m
//  Kitaboo
//
//  Created by Priyanka Singh on 15/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "PlayerActionTopBar.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define penToolItemSizeForIphone (windowWidth == 320)?16:20.8
#define penTool_itemFontSize isIpad()?22:penToolItemSizeForIphone
#define PenToolBar_ItemWidth isIPAD ? 62:36
#define DefaultPenColorThickness 4.0
#define DefaultPenColor "#000000"
#define LocalizationBundleForPlayerActionTopBar  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]
@interface PlayerActionTopBar (){
    UIView *selectedColorView;
    NSLayoutConstraint *viewThicknessConstraint;
}

@end

@implementation PlayerActionTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

-(void)updatedPlayerForPenTool:(KBHDThemeVO*)themeVO withPenToolColors:(NSArray *)pencolors
{
    self.backgroundColor = themeVO.pen_tool_toolbar_background;
    CGFloat iconSize = penTool_itemFontSize;
//    if(!isIpad()){
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLOSE withActionTag:kPenToolBarItemTypeDone withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
//    }
    [self addActionBarItem:[self pentoolPallerItemWithIcon:ICON_COLORPALLET withActionTag:kPenToolBarItemTypePen withThemeVO:themeVO withItemSize:iconSize] withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    if(isIpad())
    for (NSString* color in pencolors) {
        [self addActionBarItem:[self getPenToolColorPalleteItemForColor:color WithTheme:themeVO withSelectedPenColor:[self getLastUpdatedPenColor]]withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        
    }
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PENTThIKNESS withActionTag:kPenToolBarItemTypeThickness withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_ERASER withActionTag:kPenToolBarItemTypeEraser withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_UNDO withActionTag:kPenToolBarItemTypeUndo withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLEAR withActionTag:kPenToolBarItemTypeDelete withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
//    if(isIpad()){
//        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLOSE withActionTag:kPenToolBarItemTypeDone withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:isIpad()? 76 : PenToolBar_itemWidthIphone(6) withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
//      
//    }
}

-(void)addPlayerTopBarForTeacherAnnotationForIPhone:(KBHDThemeVO*)themeVO studentName:(NSString*)studentName andImageUrl:(NSString *)imageUrl withAllTeacherAnnotationPages:(NSArray *)totalNumberOfPages
{
    [self addActionBarItem:[self getTopBarPlayerButtonForStudentProfilewithThemeVO:themeVO studentImageUrl:imageUrl] withItemsWidth:50 withItemAlignments:PlayerActionBarAlignmentRight isTappable:NO];
    [self addActionBarItem:[self getPlayerItemForStudentNameWithTheme:themeVO studentName:studentName] withItemsWidth:100 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
    
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PREV_PAGE_ICON withActionTag:kPenToolBarItemTypePrevPage withThemeVO:themeVO withItemSize:16 numberOfItems:9] withItemsWidth:50 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    if (totalNumberOfPages)
    {
        [self addActionBarItem:[self getPlayerItemForPageNumberWithTheme:themeVO pageNumber:[@"Page " stringByAppendingString:[totalNumberOfPages firstObject]]] withItemsWidth:70 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    }else
    {
        [self addActionBarItem:[self getPlayerItemForPageNumberWithTheme:themeVO pageNumber:@"Page"] withItemsWidth:70 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    }
     [self addActionBarItem:[self getPlayerItemWithIcon:ICON_NEXT withActionTag:kPenToolBarItemTypeNextPage withThemeVO:themeVO withItemSize:16 numberOfItems:9] withItemsWidth:50 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
}

-(void)addPlayerBottomBarForTeacherAnnotationForIPhone:(KBHDThemeVO*)themeVO withPenColors:(NSArray *)colorsArray withSelectedPenColor:(NSString *)selectedPenColor
{
    [self addActionBarItem:[self getPenToolColorPalleteItemForColor:[@"#" stringByAppendingString:[colorsArray lastObject]] WithTheme:themeVO withSelectedPenColor:selectedPenColor]withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPenToolColorPalleteItemForColor:[@"#" stringByAppendingString:[colorsArray firstObject]] WithTheme:themeVO withSelectedPenColor:selectedPenColor]withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_ERASER withActionTag:kPenToolBarItemTypeEraser withThemeVO:themeVO withItemSize:18 numberOfItems:6] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_UNDO withActionTag:kPenToolBarItemTypeUndo withThemeVO:themeVO withItemSize:18 numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLEAR withActionTag:kPenToolBarItemTypeDelete withThemeVO:themeVO withItemSize:18 numberOfItems:6] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemForDoneWithTheme:themeVO] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
//    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_REDO withActionTag:kPenToolBarItemTypeRedo withThemeVO:themeVO withItemSize:18 numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:NO];
//    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_OVERFLOW withActionTag:kPenToolBarItemTypeOverFlow withThemeVO:themeVO withItemSize:18 numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
}

-(void)addPlayerTopBarForTeacherAnnotationForIPad:(KBHDThemeVO*)themeVO withPenColors:(NSArray *)colorsArray studentName:(NSString*)studentName andImageUrl:(NSString *)imageUrl withSelectedPenColor:(NSString *) selectedPenColor withCurrentPageNumber:(NSString *)pageNumber
{
    self.backgroundColor = themeVO.teacherSettings_popup_background;
    CGFloat iconSize = penTool_itemFontSize;
    //left components
    [self addActionBarItem:[self getTopBarPlayerButtonForStudentProfilewithThemeVO:themeVO studentImageUrl:imageUrl] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:NO];
    [self addActionBarItem:[self getPlayerItemForStudentNameWithTheme:themeVO studentName:studentName] withItemsWidth:80 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [self addActionBarItem:[self getPenToolColorPalleteItemForColor:[@"#" stringByAppendingString:[colorsArray lastObject]] WithTheme:themeVO withSelectedPenColor:selectedPenColor]withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPenToolColorPalleteItemForColor:[@"#" stringByAppendingString:[colorsArray firstObject]] WithTheme:themeVO withSelectedPenColor:selectedPenColor]withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PREV_PAGE_ICON withActionTag:kPenToolBarItemTypePrevPage withThemeVO:themeVO withItemSize:iconSize numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemForPageNumberWithTheme:themeVO pageNumber:pageNumber] withItemsWidth:100 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_NEXT withActionTag:kPenToolBarItemTypeNextPage withThemeVO:themeVO withItemSize:iconSize numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_ERASER withActionTag:kPenToolBarItemTypeEraser withThemeVO:themeVO withItemSize:iconSize numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_UNDO withActionTag:kPenToolBarItemTypeUndo withThemeVO:themeVO withItemSize:iconSize numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemForDoneWithTheme:themeVO] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
//    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_OVERFLOW withActionTag:kPenToolBarItemTypeOverFlow withThemeVO:themeVO withItemSize:iconSize numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
//    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_REDO withActionTag:kPenToolBarItemTypeRedo withThemeVO:themeVO withItemSize:iconSize numberOfItems:9] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentRight isTappable:NO];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLEAR withActionTag:kPenToolBarItemTypeDelete withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:65 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
 
}

-(void)addPlayerTopBarForTeacherReviewAnnotation:(KBHDThemeVO*)themeVO studentName:(NSString*)studentName imageUrl:(NSString *)imageUrl studentCount:(int)studentCount studentIndex:(int)studentIndex {
    self.backgroundColor = themeVO.teacherSettings_popup_background;
    CGFloat iconSize = penTool_itemFontSize;
    PlayerActionBarItem *prevPageItem = [self getPrevStudentItemWithIcon:ICON_PREV_PAGE_ICON withActionTag:kPlayerActionBarItemTypePrevStudent withThemeVO:themeVO withItemSize:iconSize numberOfItems:3];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (!isIpad() && UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self addActionBarItem:prevPageItem withItemsWidth:80 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    } else {
        [self addActionBarItem:prevPageItem withItemsWidth:isIpad()?50:30 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    }
    [self addActionBarItem:[self getTopBarPlayerButtonForStudentProfileViewWithThemeVO:themeVO studentImageUrl:imageUrl studentName:studentName studentCount:studentCount studentIndex:studentIndex] withItemsWidth:isIpad()?250:160 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_NEXT withActionTag:kPlayerActionBarItemTypeNextStudent withThemeVO:themeVO withItemSize:iconSize numberOfItems:3] withItemsWidth:isIpad()?50:30 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    
    PlayerActionBarItem *downloadItem = [self getPrevStudentItemWithIcon:ICON_DOWNLOAD withActionTag:kPlayerActionBarItemTypeGenerateReport withThemeVO:themeVO withItemSize:iconSize numberOfItems:3];
    if (!isIpad() && UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self addActionBarItem:downloadItem withItemsWidth:80 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
    } else {
        [self addActionBarItem:downloadItem withItemsWidth:isIpad()?50:40 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
    }
    [self addActionBarItem:[self getPlayerItemForTeacherReviewDoneWithTheme:themeVO] withItemsWidth:isIpad()?70:60 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
//    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_NEXT withActionTag:kPenToolBarItemTypeNextPage withThemeVO:themeVO withItemSize:iconSize numberOfItems:3] withItemsWidth:isIpad()?50:30 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
//    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PREV_PAGE_ICON withActionTag:kPenToolBarItemTypePrevPage withThemeVO:themeVO withItemSize:iconSize numberOfItems:3] withItemsWidth:isIpad()?50:30 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
}

-(void)addPlayerBottomBarForTeacherReviewAnnotation:(KBHDThemeVO*)themeVO {
    self.backgroundColor = themeVO.teacherSettings_popup_background;
    CGFloat iconSize = penTool_itemFontSize;
    int itemWidth = [UIScreen mainScreen].bounds.size.width / 6;
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_MULTI_SELECT withActionTag:kPlayerActionBarItemTypeDragBox withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:itemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PENTOOL withActionTag:kPenToolBarItemTypePen withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:itemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_ERASER withActionTag:kPenToolBarItemTypeEraser withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:itemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_UNDO withActionTag:kPenToolBarItemTypeUndo withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:itemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLEAR withActionTag:kPenToolBarItemTypeDelete withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:itemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVO:themeVO withItemSize:iconSize numberOfItems:6] withItemsWidth:itemWidth withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
}

-(void)updateSelectedPenColor:(NSString*)penColor withTheme:(KBHDThemeVO *)themeVO
{
    // deselect all selected item
    NSArray *penColorItems = [[self getTappableItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.tag == %d",kPlayerActionBarItemTypePenColor]];
    for (PlayerActionBarItem *penColorItem in penColorItems)
    {
        NSArray *highlightToolViewArray = [penColorItem.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@",[HighLightToolView class]]];
//        for (HighLightToolView *selectedView in highlightToolViewArray){
//            if([penColorItem.metaData valueForKey:@"penColor"] == penColor){
//                selectedView.borderView.layer.borderColor = themeVO.pen_tool_selected_icon_background.CGColor;
//            }
//            else
//            selectedView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
//
//        }
        
        //////// uncomment this if FIB is enable and comment above for loop ////////
        
        for (HighLightToolView *selectedView in highlightToolViewArray)
        {
            if([penColorItem.metaData valueForKey:@"penColor"] == penColor)
            {
                if (selectedView.borderView.layer.borderColor == themeVO.pen_tool_selected_icon_background.CGColor)
                {
                    selectedView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
                }else
                {
                    selectedView.borderView.layer.borderColor = themeVO.pen_tool_selected_icon_background.CGColor;
                }
            }
            else
            {
                selectedView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
    }
}

-(void)updateSelectedAudioSyncColor:(NSString*)penColor withTheme:(KBHDThemeVO *)themeVO
{
    // deselect all selected item
    NSArray *penColorItems = [[self getTappableItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.tag == %d",kPlayerActionBarItemTypeAudioSyncColor]];
    for (PlayerActionBarItem *penColorItem in penColorItems)
    {
        NSArray *highlightToolViewArray = [penColorItem.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@",[HighLightToolView class]]];
        
        for (HighLightToolView *selectedView in highlightToolViewArray)
        {
            if([penColorItem.metaData valueForKey:@"penColor"] == penColor)
            {
                if (selectedView.borderView.layer.borderColor == themeVO.pen_tool_selected_icon_background.CGColor)
                {
                    selectedView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
                }else
                {
                    selectedView.borderView.layer.borderColor = themeVO.pen_tool_selected_icon_background.CGColor;
                }
            }
            else
            {
                selectedView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
    }
}


-(PlayerActionBarItem *)getPlayerItemForStudentNameWithTheme:(KBHDThemeVO*)themeVo studentName:(NSString *)studentName
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag=kPenToolBarItemTypeStudentName;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:studentName];
    [textForAction setTextAlignment:NSTextAlignmentLeft];
    [textForAction setFont:getCustomFont(isIpad()?18:14)];
    textForAction.textColor = [UIColor colorWithHexString:@"#262525"];
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active=YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active=YES;
    [textForAction.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:5].active=YES;
    [textForAction.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:0].active=YES;
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForPageNumberWithTheme:(KBHDThemeVO*)themeVo pageNumber:(NSString *)pageNumber
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPenToolBarItemTypePageNumber;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:pageNumber];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(isIpad()?18:16)];
    textForAction.textColor = [UIColor colorWithHexString:@"#333333"];
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active=YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active=YES;
    [textForAction.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:0].active=YES;
    [textForAction.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:0].active=YES;
    return actionBarItem;
}


-(PlayerActionBarItem *)getTopBarPlayerButtonForStudentProfilewithThemeVO:(KBHDThemeVO*)hdThemeVO studentImageUrl:(NSString *)studentImageUrl
{
    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPlayerActionBarItemTypeProfile;
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_pic"]];
    [actionBarItem addSubview:userImage];
    userImage.image = [UIImage imageNamed:@"InsightUser_Profile_Pic"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: studentImageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                userImage.image = [UIImage imageWithData: data];
            }
        });
    });
    [userImage.widthAnchor constraintEqualToConstant:isIpad()?32.4:30].active = YES;
    [userImage.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:-10].active = YES;
    [userImage.heightAnchor constraintEqualToConstant:isIpad()?32.4:30].active = YES;
    [userImage.centerYAnchor constraintEqualToAnchor:actionBarItem.centerYAnchor constant:0].active = YES;
    userImage.translatesAutoresizingMaskIntoConstraints =NO;
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = hdThemeVO.top_toolbar_icons_color.CGColor;
    userImage.layer.cornerRadius = isIpad()?16.3:15;
    userImage.clipsToBounds = YES;
    [self setAccessibilityForPlayerActionTopBarItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getPrevStudentItemWithIcon:(NSString *)iconStr withActionTag:(int)playerActionTag withThemeVO:(KBHDThemeVO*)hdThemeVO withItemSize:(CGFloat)size numberOfItems:(int)numberOfItems
{
    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = playerActionTag;
    actionBarItem.backgroundColor = [UIColor clearColor];
    UILabel *textForAction = [[UILabel alloc] init];
    [textForAction setText:iconStr];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:DefualtFont(size)];
    textForAction.textColor = (self.tag == kPlayerActionBarTypeTopForIphone)?hdThemeVO.top_toolbar_icons_color : hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    if (iconStr == ICON_PREV_PAGE_ICON) {
        [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-3]];
    } else if (iconStr == ICON_DOWNLOAD) {
        [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeLeading multiplier:1.0 constant:5]];
    }
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self setAccessibilityForPlayerActionTopBarItem:actionBarItem];
    [self setAccessibilityForPenToolItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getTopBarPlayerButtonForStudentProfileViewWithThemeVO:(KBHDThemeVO*)hdThemeVO studentImageUrl:(NSString *)studentImageUrl studentName:(NSString *)studentName studentCount:(int)studentCount studentIndex:(int)studentIndex
{
    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPlayerActionBarItemTypeProfile;
    UIView *profileView = [[UIView alloc] init];
    [actionBarItem addSubview:profileView];
    [profileView.widthAnchor constraintEqualToConstant:isIpad()?230:150].active = YES;
    [profileView.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:isIpad()?10:5].active = YES;
    [profileView.heightAnchor constraintEqualToConstant:isIpad()?40:35].active = YES;
    [profileView.centerYAnchor constraintEqualToAnchor:actionBarItem.centerYAnchor constant:0].active = YES;
    profileView.translatesAutoresizingMaskIntoConstraints =NO;
    profileView.layer.borderWidth = 1.0;
    profileView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    profileView.layer.cornerRadius = 5;
    profileView.clipsToBounds = YES;
    
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_pic"]];
    [profileView addSubview:userImage];
    userImage.image = [UIImage imageNamed:@"InsightUser_Profile_Pic"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: studentImageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                userImage.image = [UIImage imageWithData: data];
            }
        });
    });
    [userImage.widthAnchor constraintEqualToConstant:isIpad()?32:30].active = YES;
    [userImage.leadingAnchor constraintEqualToAnchor:profileView.leadingAnchor constant:isIpad()?10:5].active = YES;
    [userImage.heightAnchor constraintEqualToConstant:isIpad()?32:30].active = YES;
    [userImage.centerYAnchor constraintEqualToAnchor:profileView.centerYAnchor constant:0].active = YES;
    userImage.translatesAutoresizingMaskIntoConstraints =NO;
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = UIColor.lightGrayColor.CGColor;
    userImage.layer.cornerRadius = isIpad()?16.3:15;
    userImage.clipsToBounds = YES;
    
    UILabel *studentListAction = [[UILabel alloc] init];
    [studentListAction setText:@"7"];
    [studentListAction setTextAlignment:NSTextAlignmentCenter];
    [studentListAction setFont:DefualtFont(isIpad() ? 20 : 18)];
    studentListAction.textColor = hdThemeVO.top_toolbar_icons_color;
    [profileView addSubview:studentListAction];
    studentListAction.translatesAutoresizingMaskIntoConstraints =NO;
    [studentListAction.widthAnchor constraintEqualToConstant:isIpad()?28:24].active = YES;
    [studentListAction.heightAnchor constraintEqualToConstant:isIpad()?28:24].active = YES;
    [studentListAction.trailingAnchor constraintEqualToAnchor:profileView.trailingAnchor constant:-5].active = YES;
    [studentListAction.centerYAnchor constraintEqualToAnchor:profileView.centerYAnchor constant:0].active = YES;
    
    UILabel *studentIndexLabel = [[UILabel alloc]init];
    NSString *learnerLabel = NSLocalizedStringFromTableInBundle(@"LEARNER",READER_LOCALIZABLE_TABLE, LocalizationBundleForPlayerActionTopBar, nil);
    [studentIndexLabel setText:[NSString stringWithFormat:@"%@ %d / %d",learnerLabel,studentIndex,studentCount]];
    [studentIndexLabel setTextAlignment:NSTextAlignmentLeft];
    [studentIndexLabel setFont:getCustomFont(isIpad()?12:8)];
    studentIndexLabel.textColor = UIColor.lightGrayColor;
    [profileView addSubview:studentIndexLabel];
    studentIndexLabel.translatesAutoresizingMaskIntoConstraints =NO;
    [studentIndexLabel.heightAnchor constraintEqualToConstant:isIpad()?20:17].active=YES;
    [studentIndexLabel.topAnchor constraintEqualToAnchor:profileView.topAnchor].active=YES;
    [studentIndexLabel.leadingAnchor constraintEqualToAnchor:userImage.trailingAnchor constant:5].active=YES;
    [studentIndexLabel.trailingAnchor constraintEqualToAnchor:studentListAction.leadingAnchor constant:0].active=YES;
    
    UILabel *studentNameLabel = [[UILabel alloc]init];
    [studentNameLabel setText:studentName];
    [studentNameLabel setTextAlignment:NSTextAlignmentLeft];
    [studentNameLabel setFont:getCustomFont(isIpad()?15:10)];
    studentNameLabel.textColor = [UIColor colorWithHexString:@"#262525"];
    [profileView addSubview:studentNameLabel];
    studentNameLabel.translatesAutoresizingMaskIntoConstraints =NO;
    [studentNameLabel.heightAnchor constraintEqualToConstant:isIpad()?20:17].active=YES;
    [studentNameLabel.bottomAnchor constraintEqualToAnchor:profileView.bottomAnchor constant:isIpad()?-5:-2].active=YES;
    [studentNameLabel.leadingAnchor constraintEqualToAnchor:userImage.trailingAnchor constant:5].active=YES;
    [studentNameLabel.trailingAnchor constraintEqualToAnchor:studentListAction.leadingAnchor constant:0].active=YES;
    
    [self setAccessibilityForPlayerActionTopBarItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)getPlayerItemForTeacherReviewDoneWithTheme:(KBHDThemeVO*)themeVo
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPenToolBarItemTypeDone;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:NSLocalizedStringFromTableInBundle(@"DONE",READER_LOCALIZABLE_TABLE, LocalizationBundleForPlayerActionTopBar, nil)];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(15)];
    textForAction.textColor = themeVo.pen_tool_toolbar_icons_color;
    textForAction.layer.borderWidth = 1.0;
    textForAction.layer.borderColor = themeVo.pen_tool_toolbar_icons_color.CGColor;
    textForAction.layer.cornerRadius = 5;
    textForAction.clipsToBounds = YES;
    [actionBarItem addSubview:textForAction];

    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:10].active=YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:-10].active=YES;
    [textForAction.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:0].active=YES;
    [textForAction.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:0].active=YES;
    return actionBarItem;
}

-(PlayerActionBarItem *)getPenToolColorPalleteItemForColor:(NSString*)color WithTheme:(KBHDThemeVO*)themeVo withSelectedPenColor:(NSString *)selectedPenColor
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    [actionBarItem.metaData setValue:color forKey:@"penColor"];
    actionBarItem.tag = kPlayerActionBarItemTypePenColor;
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
    [highlightToolV.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:0].active = YES;
    [highlightToolV.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:0].active = YES;;
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

-(PlayerActionBarItem *)getPlayerItemForDoneWithTheme:(KBHDThemeVO*)themeVo
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPenToolBarItemTypeDone;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:NSLocalizedStringFromTableInBundle(@"DONE",READER_LOCALIZABLE_TABLE, LocalizationBundleForPlayerActionTopBar, nil)];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(14)];
    textForAction.textColor = themeVo.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];

    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active=YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active=YES;
    [textForAction.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:0].active=YES;
    [textForAction.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:0].active=YES;
    return actionBarItem;
}
-(PlayerActionBarItem *)getTopBarPlayerButtonForProfilewithThemeVO:(KBHDThemeVO*)hdThemeVO
{
    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPlayerActionBarItemTypeProfile;
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_Profile_Pic"]];
    [actionBarItem addSubview:userImage];
    //    userImage.frame = CGRectMake(10,10, 30, 30);
    userImage.image = [UIImage imageNamed:@"User_Profile_Pic"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self->_user.profilePicURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                userImage.image = [UIImage imageWithData: data];
            }
        });
    });
    [userImage.widthAnchor constraintEqualToConstant:isIpad()?32.4:29.4].active = YES;
    [userImage.centerXAnchor constraintEqualToAnchor:actionBarItem.centerXAnchor constant:isIPAD? -6 : 0].active = YES;
    [userImage.heightAnchor constraintEqualToConstant:isIpad()?32.4:29.4].active = YES;
    [userImage.centerYAnchor constraintEqualToAnchor:actionBarItem.centerYAnchor constant:0].active = YES;
    userImage.translatesAutoresizingMaskIntoConstraints =NO;
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor =  hdThemeVO.top_toolbar_icons_color.CGColor;
    userImage.layer.cornerRadius = isIpad()?16.3:14.7;
    userImage.clipsToBounds = YES;
    [self setAccessibilityForPlayerActionTopBarItem:actionBarItem];
    return actionBarItem;
}
-(void)addPlayerTopBarForScormPackage:(KBHDThemeVO*)themeVO
{
    int numberOfItems = 2;

    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_BOOKSHELF withActionTag:kPlayerActionBarItemTypeBookshelf withThemeVO:themeVO withItemSize:item_fontSize numberOfItems:numberOfItems] withItemsWidth:70 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [self addActionBarItem:[self initialiseChapterNameItemwithThemeVO:themeVO] withItemsWidth:windowWidth - 60 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:NO];
}

-(void)addPlayerTopBarForIPhoneWithTheme:(KBHDThemeVO*)themeVO isEpub:(BookType)bookType
{
    int numberOfItems;
    switch (bookType) {
        case kPdfBookType:
            numberOfItems = 6;
            break;
        case kEpubFixedType:
            numberOfItems = 3;
            break;
        case kEpubReflowableType:
            numberOfItems = 5;
            break;
        default:
            break;
    }
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_BOOKSHELF withActionTag:kPlayerActionBarItemTypeBookshelf withThemeVO:themeVO withItemSize:item_fontSize numberOfItems:numberOfItems] withItemsWidth:playerBar_itemWidthIphone(numberOfItems) withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [self addActionBarItem:[self initialiseChapterNameItemwithThemeVO:themeVO] withItemsWidth:windowWidth - ((playerBar_itemWidthIphone(numberOfItems))*2) - (isIPAD ? 0 : 40) withItemAlignments:PlayerActionBarAlignmentLeft isTappable:NO];
    if(!_hideProfileSettingsButton)
    {
        [self addActionBarItem:[self getTopBarPlayerButtonForProfilewithThemeVO:themeVO] withItemsWidth:playerBar_itemWidthIphone(numberOfItems) + (isIPAD ? 0 : 8) withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
    }
    if([_bookVO isKindOfClass:[KFBookVO class]])
    {
        KFBookVO *kfBookVO  = (KFBookVO*)_bookVO;
        if([kfBookVO isReadAloudEnabled])
        {
            if(isIpad())
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:ICON_AUDIO withActionTag:kPlayerActionBarItemTypeSound withThemeVO:themeVO withItemSize:item_fontSize numberOfItems:numberOfItems] withItemsWidth:80 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
            }
            else
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:ICON_AUDIO withActionTag:kPlayerActionBarItemTypeSound withThemeVO:themeVO withItemSize:18 numberOfItems:numberOfItems] withItemsWidth:23 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
            }
        }
    }
    if ([_bookVO isKindOfClass:[EPUBBookVO class]] && _userSettingsModel.isPrintEnabled) {
        EPUBBookVO *epubBook = (EPUBBookVO*)_bookVO;
        if (epubBook && (epubBook.meta.layout==ePUBReflowable) && _userSettingsModel.isPrintEnabled) {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PRINT withActionTag:kPlayerActionBarItemTypePrint withThemeVO:themeVO withItemSize:item_fontSize numberOfItems:numberOfItems] withItemsWidth:isIpad()?80:30 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];
        }
    }
}

-(PlayerActionBarItem *)initialiseChapterNameItemwithThemeVO:(KBHDThemeVO*)hdThemeVO
{
    if(self.chapterNameItem == nil){
        self.chapterNameItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
        UILabel *textForAction = [[UILabel alloc]init];
        [textForAction setText:@""];
        [textForAction setTextAlignment:NSTextAlignmentLeft];
        if (windowWidth == 320) {
            [textForAction setFont:getCustomFont(16)];
        }
        else
        [textForAction setFont:getCustomFont(isIpad()?21:20)];
        
        textForAction.textColor = hdThemeVO.top_toolbar_icons_color;
        textForAction.textAlignment = NSTextAlignmentCenter;
        [self.chapterNameItem addSubview:textForAction];
        textForAction.numberOfLines = 1;
        textForAction.translatesAutoresizingMaskIntoConstraints =NO;
        [textForAction.leadingAnchor constraintEqualToAnchor:self.chapterNameItem.leadingAnchor constant:isIpad() ? -6 : 2].active = YES;
        [textForAction.trailingAnchor constraintEqualToAnchor:self.chapterNameItem.trailingAnchor constant:0].active = YES;
        [textForAction.centerYAnchor constraintEqualToAnchor:self.chapterNameItem.centerYAnchor constant:1].active = YES;
        textForAction.accessibilityIdentifier = PLAYER_CHAPTER_NAME_LABEL;
    }
    
    return self.chapterNameItem;
}



-(PlayerActionBarItem *)getPlayerItemWithIcon:(NSString *)iconStr withActionTag:(int)playerActionTag withThemeVO:(KBHDThemeVO*)hdThemeVO withItemSize:(CGFloat)size numberOfItems:(int)numberOfItems
{

    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = playerActionTag;
    actionBarItem.backgroundColor = [UIColor clearColor];
    UILabel *textForAction = [[UILabel alloc] init];
    [textForAction setText:iconStr];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:DefualtFont(size)];
    textForAction.textColor = (self.tag == kPlayerActionBarTypeTopForIphone)?hdThemeVO.top_toolbar_icons_color : hdThemeVO.pen_tool_toolbar_icons_color;
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    if (iconStr == ICON_TEXTANNOTATION)
    {
        [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    }else
    {
        [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }
    
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self setAccessibilityForPlayerActionTopBarItem:actionBarItem];
    [self setAccessibilityForPenToolItem:actionBarItem];
    return actionBarItem;
}

-(PlayerActionBarItem *)pentoolPallerItemWithIcon:(NSString *)iconStr withActionTag:(int)playerActionTag withThemeVO:(KBHDThemeVO*)hdThemeVO withItemSize:(CGFloat)size
{
    PlayerActionBarItem *colorPalletItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    colorPalletItem.tag = playerActionTag;
    colorPalletItem.backgroundColor = [UIColor clearColor];

    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:iconStr];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:DefualtFont(size)];
    textForAction.textColor = hdThemeVO.pen_tool_toolbar_icons_color;
//    [textForAction.widthAnchor constraintEqualToConstant:playerBar_itemWidthIphone(6)];
    [colorPalletItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [colorPalletItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:colorPalletItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [colorPalletItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:colorPalletItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [colorPalletItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:colorPalletItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    selectedColorView = [[UIView alloc]init];
    [colorPalletItem addSubview:selectedColorView];
    selectedColorView.backgroundColor = [UIColor colorWithHexString:[self getLastUpdatedPenColor]];
    selectedColorView.translatesAutoresizingMaskIntoConstraints =NO;
    [selectedColorView.leadingAnchor constraintEqualToAnchor:textForAction.leadingAnchor].active =YES;
    [selectedColorView.trailingAnchor constraintEqualToAnchor:textForAction.trailingAnchor].active =YES;
    [selectedColorView.trailingAnchor constraintEqualToAnchor:textForAction.trailingAnchor].active =YES;
   viewThicknessConstraint = [selectedColorView.heightAnchor constraintEqualToConstant:[self getLastUpdatedPenThickness]];
    viewThicknessConstraint.active =YES;
    [selectedColorView.bottomAnchor constraintEqualToAnchor:colorPalletItem.bottomAnchor constant:isIpad() ? - 6 : -4].active =YES;
    [self setAccessibilityForPenToolItem:colorPalletItem];
    return colorPalletItem;
}

-(void)updateColorSelectedView:(UIColor *)selectedColor withColorThickness:(CGFloat)colorThickness{
    viewThicknessConstraint.constant = colorThickness;
    if(selectedColor != nil)
    selectedColorView.backgroundColor = selectedColor;
    [self layoutIfNeeded];
}

-(void)updatePlayerSelectedItem:(KBHDThemeVO *)themeColor {
   
    for (UIView *subItems in [self getTappableItems]) {
        if([subItems isKindOfClass:[PlayerActionBarItem class]]){
            subItems.backgroundColor = [UIColor clearColor];
            for (UILabel *subView in [subItems subviews]) {
                if([subView isKindOfClass:[UILabel class]]){
                subView.textColor = themeColor.pen_tool_toolbar_icons_color;
                }
            }
        }
    }

    PlayerActionBarItem *selectedItemView = [self getSelectedItem];
    NSPredicate *predicateToFindClass = [NSPredicate predicateWithFormat:
                                         @"self isMemberOfClass: %@", [UILabel class]];
    NSArray *araayOfBurrEffectView = [[selectedItemView subviews] filteredArrayUsingPredicate:predicateToFindClass];

    switch (selectedItemView.tag) {
        case kPenToolBarItemTypePen: case kPenToolBarItemTypeThickness: case kPenToolBarItemTypeEraser: case kPenToolBarItemTypeDelete:{
            if(araayOfBurrEffectView.count){
                for (UILabel *label in araayOfBurrEffectView) {
                    selectedItemView.backgroundColor = themeColor.pen_tool_selected_icon_background;
                    label.textColor = themeColor.pen_tool_selected_icon_color;
                    break;
                }
                
            }
        }
        default:
            break;
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

-(void)setAccessibilityForPlayerActionTopBarItem:(PlayerActionBarItem *)actionBarItem
{
    switch (actionBarItem.tag)
    {
        case kPlayerActionBarItemTypeProfile:
        {
            actionBarItem.accessibilityIdentifier = PLAYER_PROFILE;
        }
            break;
            
        case kPlayerActionBarItemTypeBookshelf:
        {
            actionBarItem.accessibilityIdentifier = PLAYER_BOOKSHELF;
        }
            break;
            
            
        default:
            break;
    }
}

-(void)setAccessibilityForPenToolItem:(PlayerActionBarItem *)actionBarItem
{
    for (UIView* subView in actionBarItem.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            switch (actionBarItem.tag)
            {
                case kPenToolBarItemTypeDone:
                {
                    subView.accessibilityIdentifier = PENTOOL_CLOSE;
                }
                    break;
                case kPenToolBarItemTypePen:
                {
                    subView.accessibilityIdentifier = PENTOOL_COLOR_PALLET;
                }
                    break;
                
                case kPenToolBarItemTypeThickness:
                {
                    subView.accessibilityIdentifier = PENTOOL_THICKNESS;
                }
                    break;
                
                case kPenToolBarItemTypeEraser:
                {
                    subView.accessibilityIdentifier = PENTOOL_ERASER;
                }
                    break;
                case kPenToolBarItemTypeUndo:
                {
                    subView.accessibilityIdentifier = PENTOOL_UNDO;
                }
                    break;
                case kPenToolBarItemTypeDelete:
                {
                    subView.accessibilityIdentifier = PENTOOL_DELETE;
                }
                    break;
                default:
                    break;
            }
            
        }
    }
}

-(void)changeIcon:(NSString *)iconText forItemType:(int)itemType
{
   NSArray *itemArray = [self getTappableItems];
   
   itemArray = [itemArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %ld", itemType]];
   if(itemArray.count)
   {
       PlayerActionBarItem *item = [itemArray objectAtIndex:0];
       for (UIView *view in item.subviews) {
           if([view isKindOfClass:[UILabel class]]) {
               UILabel *label = (UILabel*)view;
               [label setText:iconText];
               break;
           }
       }
   }
   
}
-(void)addPlayerTopBarWithoutGenerateReportForTeacherReviewAnnotation:(KBHDThemeVO*)themeVO studentName:(NSString*)studentName imageUrl:(NSString *)imageUrl studentCount:(int)studentCount studentIndex:(int)studentIndex
{
    self.backgroundColor = themeVO.teacherSettings_popup_background;
    CGFloat iconSize = penTool_itemFontSize;
    PlayerActionBarItem *prevPageItem = [self getPrevStudentItemWithIcon:ICON_PREV_PAGE_ICON withActionTag:kPlayerActionBarItemTypePrevStudent withThemeVO:themeVO withItemSize:iconSize numberOfItems:3];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (!isIpad() && UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self addActionBarItem:prevPageItem withItemsWidth:80 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    } else {
        [self addActionBarItem:prevPageItem withItemsWidth:isIpad()?50:30 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    }
    [self addActionBarItem:[self getTopBarPlayerButtonForStudentProfileViewWithThemeVO:themeVO studentImageUrl:imageUrl studentName:studentName studentCount:studentCount studentIndex:studentIndex] withItemsWidth:isIpad()?250:160 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_NEXT withActionTag:kPlayerActionBarItemTypeNextStudent withThemeVO:themeVO withItemSize:iconSize numberOfItems:3] withItemsWidth:isIpad()?50:30 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    
    [self addActionBarItem:[self getTeacherReviewDoneWithTheme:themeVO] withItemsWidth:isIpad()?80:60 withItemAlignments:PlayerActionBarAlignmentRight isTappable:YES];

}
-(PlayerActionBarItem *)getTeacherReviewDoneWithTheme:(KBHDThemeVO*)themeVo
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = kPenToolBarItemTypeDone;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:NSLocalizedStringFromTableInBundle(@"DONE",READER_LOCALIZABLE_TABLE, LocalizationBundleForPlayerActionTopBar, nil)];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:getCustomFont(15)];
    textForAction.textColor = themeVo.pen_tool_toolbar_icons_color;
    textForAction.layer.borderWidth = 1.0;
    textForAction.layer.borderColor = themeVo.pen_tool_toolbar_icons_color.CGColor;
    textForAction.layer.cornerRadius = 5;
    textForAction.clipsToBounds = YES;
    [actionBarItem addSubview:textForAction];

    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [textForAction.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:10].active=YES;
    [textForAction.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:-10].active=YES;
    [textForAction.leadingAnchor constraintEqualToAnchor:actionBarItem.leadingAnchor constant:5].active=YES;
    [textForAction.trailingAnchor constraintEqualToAnchor:actionBarItem.trailingAnchor constant:-5].active=YES;
    return actionBarItem;
}
@end
