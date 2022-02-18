//
//  PlayerActionBottomBar.h
//  Kitaboo
//
//  Created by Priyanka Singh on 15/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "ReaderHeader.h"
#import "ReaderViewController.h"
#import "IconFontConstants.h"
#import "Constant.h"
#import "AccessibilityIdentifierConstants.h"
#import "HDReaderSettingModel.h"
@interface PlayerActionBottomBar : PlayerActionBar
@property BOOL hasClassAssociation;
@property BOOL isFurthestPageEnabled;
@property (nonatomic, strong)HDReaderSettingModel *userSettingsModel;
-(void)addPlayerBottomBarForPortraitMode:(KBHDThemeVO*)themeVO  isEpub:(BookType)bookType isTeacherAnnotationEnable:(BOOL)isTeacher;
-(void)addPlayerBottomBarForLandscapeMode:(KBHDThemeVO*)themeVO isEpub:(BookType)bookType isTeacherAnnotationEnable:(BOOL)isTeacher;
-(void)setAccessibilityForPlayerActionBottomBarItem:(PlayerActionBarItem *)actionBarItem;
-(PlayerActionBarItem *)getPlayerItemWithIcon:(NSString *)iconStr withActionTag:(PlayerActionBarItemType)playerActionTag withThemeVo:(KBHDThemeVO*)themeVO numberOfitems:(int)numberOfItems;
-(int)getTotalNumberOfItems:(BOOL)isTeacher;
@end
