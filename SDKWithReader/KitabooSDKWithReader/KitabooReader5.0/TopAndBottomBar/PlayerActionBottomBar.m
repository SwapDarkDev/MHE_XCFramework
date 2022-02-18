//
//  PlayerActionBottomBar.m
//  Kitaboo
//
//  Created by Priyanka Singh on 15/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "PlayerActionBottomBar.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>


@implementation PlayerActionBottomBar

-(int)getTotalNumberOfItems:(BOOL)isTeacher
{
    int itemIndex = 2;
    if ([_userSettingsModel isMydataEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isSearchEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isPenToolEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isStickyNotesEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isProtractorEnabled])
    {
        itemIndex++;
    }
    if (isTeacher && [_userSettingsModel isReviewEnabled] && _hasClassAssociation)
    {
        itemIndex++;
    }else if ((!isTeacher && [_userSettingsModel isPenToolEnabled] && _hasClassAssociation) || !_hasClassAssociation)
    {
        itemIndex++;
    }
    if ([_userSettingsModel isTextAnnotationEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isClearAllFIBsEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isAudioSyncEnabled]) {
        itemIndex++;
    }
    if(_isFurthestPageEnabled)
    {
        itemIndex++;
    }
    return itemIndex;
}

-(int)getTotalNumberOfItemsForFixedEpub
{
    int itemIndex = 1;
    if ([_userSettingsModel isMydataEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isSearchEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isPenToolEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isStickyNotesEnabled])
    {
        itemIndex++;
    }
    if ([_userSettingsModel isAudioSyncEnabled])
    {
        itemIndex++;
    }
    if(_isFurthestPageEnabled)
    {
        itemIndex++;
    }
    if ([_userSettingsModel isTextAnnotationEnabled])
    {
        itemIndex++;
    }
    return itemIndex;
}

-(void)addPlayerBottomBarForPortraitMode:(KBHDThemeVO*)themeVO isEpub:(BookType)bookType isTeacherAnnotationEnable:(BOOL)isTeacher
{
    int numberOfItems;
    switch (bookType)
    {
        case kPdfBookType:
            numberOfItems = 7;
            break;
        case kEpubFixedType:
            numberOfItems = 6;
            break;
        case kEpubReflowableType:
            numberOfItems = 5;
            break;
        default:
            break;
    }
    
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TOC withActionTag:kPlayerActionBarItemTypeTOC withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    if ([_userSettingsModel isMydataEnabled])
    {
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_MYDATA withActionTag:kPlayerActionBarItemTypeMyData withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    }
    if ([_userSettingsModel isSearchEnabled])
    {
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_SEARCH withActionTag:kPlayerActionBarItemTypeSearch withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    }
    
    if(bookType == kPdfBookType)
    {
        if ([_userSettingsModel isPenToolEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PENTOOL withActionTag:kPlayerActionBarItemTypePenTool withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }

        if ([_userSettingsModel isStickyNotesEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TAPPABLE_STICKY_NOTE withActionTag:kPlayerActionBarItemTypeStickyNote withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        
        if (isIpad())
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            
            if ([self getTotalNumberOfItems:isTeacher]>=defaultNumberOfItemsForPlayerActionBar)
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:@"ľ" withActionTag:kPlayerActionBarItemTypeVerticalBar withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }else
            {
                if (_isFurthestPageEnabled)
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
                    if(isTeacher && isIpad() && _hasClassAssociation)
                    {
                        if([_userSettingsModel isReviewEnabled])
                        {
                            [self addActionBarItem:[self getPlayerItemWithIcon:TEACHER_ANNOTATION_ICON withActionTag:kPlayerActionBarItemTypeTeacherReview withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                        }
                    }
                    //when pentool is not there so user will not have any thing to submit so we have added user-submission only when pentool is enabled
                    else if((!isTeacher && isIpad() && _userSettingsModel.isPenToolEnabled && _hasClassAssociation) || !_hasClassAssociation)
                    {
                        [self addActionBarItem:[self getPlayerItemWithIcon:@":" withActionTag:kPlayerActionBarItemTypeStudentSubmit withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                    }

                if (isIpad() && [_userSettingsModel isProtractorEnabled])
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PROTRACTOR withActionTag:kPlayerActionBarItemTypeProtractor withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
                if ([_userSettingsModel isTextAnnotationEnabled])
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TEXTANNOTATION withActionTag:kPlayerActionBarItemTypeAddText withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
                if ([_userSettingsModel isClearAllFIBsEnabled])
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLEAR withActionTag:kPlayerActionBarItemTypeClearAllFIBs withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
            }
        }else
        {
            if ([self getTotalNumberOfItems:isTeacher]>=defaultNumberOfItemsForPlayerActionBar)
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:@"Ḡ" withActionTag:kPlayerActionBarItemTypeVerticalBar withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }else
            {
                if ([_userSettingsModel isProtractorEnabled])
                {
                     [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PROTRACTOR withActionTag:kPlayerActionBarItemTypeProtractor withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
                    if (isTeacher && [_userSettingsModel isReviewEnabled] && _hasClassAssociation)
                    {
                        [self addActionBarItem:[self getPlayerItemWithIcon:TEACHER_ANNOTATION_ICON withActionTag:kPlayerActionBarItemTypeTeacherReview withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                    }else if ((!isTeacher && _userSettingsModel.isPenToolEnabled && _hasClassAssociation) || !_hasClassAssociation)
                    {
                        [self addActionBarItem:[self getPlayerItemWithIcon:@":" withActionTag:kPlayerActionBarItemTypeStudentSubmit withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                    }
                [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                if (_isFurthestPageEnabled)
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
                if ([_userSettingsModel isTextAnnotationEnabled])
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TEXTANNOTATION withActionTag:kPlayerActionBarItemTypeAddText withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
            }
        }
    }
    else if (bookType == kEpubReflowableType)
    {
        if ([_userSettingsModel isAudioSyncEnabled]) {
            PlayerActionBarItem *audioSyncIcon = [self getPlayerItemWithIcon:ICON_AUDIO_SYNC withActionTag:kPlayerActionBarItemTypeSound withThemeVo:themeVO numberOfitems:numberOfItems];
            audioSyncIcon.enabled = NO;
            audioSyncIcon.alpha =  0.5;
            [self addActionBarItem:audioSyncIcon withItemsWidth:playerBar_itemWidthIphone(numberOfItems) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_FONTSETTING withActionTag:kPlayerActionBarItemTypeFontSetting withThemeVo:themeVO numberOfitems:numberOfItems] withItemsWidth:playerBar_itemWidthIphone(numberOfItems) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        if (_isFurthestPageEnabled)
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }

    }
    else if(bookType == kEpubFixedType)
    {
        if ([_userSettingsModel isPenToolEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PENTOOL withActionTag:kPlayerActionBarItemTypePenTool withThemeVo:themeVO numberOfitems:numberOfItems] withItemsWidth:playerBar_itemWidthIphone(numberOfItems) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        if ([_userSettingsModel isStickyNotesEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TAPPABLE_STICKY_NOTE withActionTag:kPlayerActionBarItemTypeStickyNote withThemeVo:themeVO numberOfitems:numberOfItems] withItemsWidth:playerBar_itemWidthIphone(numberOfItems) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        if (isIpad()){
            if ([_userSettingsModel isAudioSyncEnabled]) {
                PlayerActionBarItem *audioSyncIcon = [self getPlayerItemWithIcon:ICON_AUDIO_SYNC withActionTag:kPlayerActionBarItemTypeSound withThemeVo:themeVO numberOfitems:numberOfItems];
                audioSyncIcon.enabled = NO;
                audioSyncIcon.alpha =  0.5;
                [self addActionBarItem:audioSyncIcon withItemsWidth:playerBar_itemWidthIphone(numberOfItems) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            
            if (_isFurthestPageEnabled)
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }
            if ([_userSettingsModel isTextAnnotationEnabled])
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TEXTANNOTATION withActionTag:kPlayerActionBarItemTypeAddText withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }

        }
        else{
            if ([self getTotalNumberOfItemsForFixedEpub]>=defaultNumberOfItemsForPlayerActionBar){
                [self addActionBarItem:[self getPlayerItemWithIcon:@"Ḡ" withActionTag:kPlayerActionBarItemTypeVerticalBar withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }
            else{
                [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                if (_isFurthestPageEnabled)
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }

            }
        }
    }
    
}

-(void)addPlayerBottomBarForLandscapeMode:(KBHDThemeVO*)themeVO isEpub:(BookType)bookType isTeacherAnnotationEnable:(BOOL)isTeacher
{
    [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TOC withActionTag:kPlayerActionBarItemTypeTOC withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]]  withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    if ([_userSettingsModel isMydataEnabled])
    {
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_MYDATA withActionTag:kPlayerActionBarItemTypeMyData withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]]  withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    }
    if ([_userSettingsModel isSearchEnabled])
    {
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_SEARCH withActionTag:kPlayerActionBarItemTypeSearch withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
    }
    
    if(bookType == kPdfBookType)
    {
        if ([_userSettingsModel isPenToolEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PENTOOL withActionTag:kPlayerActionBarItemTypePenTool withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        
        if ([_userSettingsModel isStickyNotesEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TAPPABLE_STICKY_NOTE withActionTag:kPlayerActionBarItemTypeStickyNote withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        
        if (_isFurthestPageEnabled)
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }

            if(isTeacher && _hasClassAssociation)
            {
                if([_userSettingsModel isReviewEnabled])
                {
                    [self addActionBarItem:[self getPlayerItemWithIcon:TEACHER_ANNOTATION_ICON withActionTag:kPlayerActionBarItemTypeTeacherReview withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
                }
            }
            //when pentool is not there so user will not have any thing to submit so we have added user-submission only when pentool is enabled
            else if((!isTeacher && _userSettingsModel.isPenToolEnabled && _hasClassAssociation) || !_hasClassAssociation)
            {
                [self addActionBarItem:[self getPlayerItemWithIcon:@":" withActionTag:kPlayerActionBarItemTypeStudentSubmit withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
            }
        if ([_userSettingsModel isProtractorEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PROTRACTOR withActionTag:kPlayerActionBarItemTypeProtractor withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]]  withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        if ([_userSettingsModel isTextAnnotationEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TEXTANNOTATION withActionTag:kPlayerActionBarItemTypeAddText withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]]  withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        
        if ([_userSettingsModel isClearAllFIBsEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_CLEAR withActionTag:kPlayerActionBarItemTypeClearAllFIBs withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];

        }
    } else if (bookType == kEpubFixedType) {
        if ([_userSettingsModel isPenToolEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_PENTOOL withActionTag:kPlayerActionBarItemTypePenTool withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        
        if ([_userSettingsModel isStickyNotesEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TAPPABLE_STICKY_NOTE withActionTag:kPlayerActionBarItemTypeStickyNote withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        [self addActionBarItem:[self getPlayerItemWithIcon:ICON_THUMBNAIL withActionTag:kPlayerActionBarItemTypeThumbnail withThemeVo:themeVO numberOfitems:[self getTotalNumberOfItems:isTeacher]] withItemsWidth:playerBar_itemWidthIphone([self getTotalNumberOfItems:isTeacher]) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        
        if (_isFurthestPageEnabled)
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:STUDENT_TEACHER_ICON withActionTag:kPlayerActionBarItemTypeFurthestPage withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar] withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
        if ([_userSettingsModel isTextAnnotationEnabled])
        {
            [self addActionBarItem:[self getPlayerItemWithIcon:ICON_TEXTANNOTATION withActionTag:kPlayerActionBarItemTypeAddText withThemeVo:themeVO numberOfitems:defaultNumberOfItemsForPlayerActionBar]  withItemsWidth:playerBar_itemWidthIphone(defaultNumberOfItemsForPlayerActionBar) withItemAlignments:PlayerActionBarAlignmentCenter isTappable:YES];
        }
    }
}

-(PlayerActionBarItem *)getPlayerItemWithIcon:(NSString *)iconStr withActionTag:(PlayerActionBarItemType)playerActionTag withThemeVo:(KBHDThemeVO*)themeVO numberOfitems:(int)numberOfItems
{
    PlayerActionBarItem *actionBarItem = [[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag = playerActionTag;
    UILabel *textForAction = [[UILabel alloc]init];
    [textForAction setText:iconStr];
    [textForAction setTextAlignment:NSTextAlignmentCenter];
    [textForAction setFont:DefualtFont(item_fontSize)];
    textForAction.textColor = themeVO.side_bottom_icons_color;
//    [textForAction.widthAnchor constraintEqualToConstant:playerBar_itemWidthIphone(numberOfItems)];
    [actionBarItem addSubview:textForAction];
    textForAction.translatesAutoresizingMaskIntoConstraints =NO;
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:textForAction attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: textForAction attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self setAccessibilityForPlayerActionBottomBarItem:actionBarItem];
    return actionBarItem;
}

- (NSDictionary *)getClientConfigDictionary
{
    NSString *clientConfigFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ClientConfig" ofType:@"plist"];
    NSDictionary *clientDictionary = [NSDictionary dictionaryWithContentsOfFile:clientConfigFilePath];
    return clientDictionary;
}

-(void)setAccessibilityForPlayerActionBottomBarItem:(PlayerActionBarItem *)actionBarItem
{
    for (UIView* subView in actionBarItem.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            switch (actionBarItem.tag)
            {
                case kPlayerActionBarItemTypeTOC:
                {
                    subView.accessibilityIdentifier = PLAYER_TOC;
                }
                    break;
                
                case kPlayerActionBarItemTypeMyData:
                {
                    subView.accessibilityIdentifier = PLAYER_MY_DATA;
                }
                    break;
                    
                case kPlayerActionBarItemTypeSearch:
                {
                    subView.accessibilityIdentifier = PLAYER_SEARCH;
                }
                    break;
                
                case kPlayerActionBarItemTypePenTool:
                {
                    subView.accessibilityIdentifier = PLAYER_PEN_TOOL;
                }
                    break;
                
                case kPlayerActionBarItemTypeStickyNote:
                {
                    subView.accessibilityIdentifier = PLAYER_STICKY_NOTE;
                }
                    break;
               
                case kPlayerActionBarItemTypeVerticalBar:
                {
                    subView.accessibilityIdentifier = PLAYER_VERTICAL_BAR;
                }
                    break;
            
                case kPlayerActionBarItemTypeThumbnail:
                {
                    subView.accessibilityIdentifier = PLAYER_THUMBNAIL;
                }
                    break;
                
                case kPlayerActionBarItemTypeProtractor:
                {
                    subView.accessibilityIdentifier = PLAYER_PROTRACTOR;
                }
                    break;
               
                case kPlayerActionBarItemTypeTeacherReview:
                {
                    subView.accessibilityIdentifier = PLAYER_TEACHER_REVIEW;
                }
                    break;
               
                case kPlayerActionBarItemTypeStudentSubmit:
                {
                    subView.accessibilityIdentifier = PLAYER_SUBMIT_ANNOTATION;
                }
                    break;
                
                case kPlayerActionBarItemTypeAddText:
                {
                    subView.accessibilityIdentifier = PLAYER_ADD_TEXT;
                }
                    break;
                
                case kPlayerActionBarItemTypeFurthestPage:
                {
                    subView.accessibilityIdentifier = PLAYER_FURTHEST_PAGE;
                }
                    break;
                default:
                    break;
            }
            
        }
    }
}

@end
