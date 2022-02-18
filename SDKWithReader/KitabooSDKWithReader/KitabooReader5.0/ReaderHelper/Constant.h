//
//  Constant.h
//  kitaboo
//
//  Created by Priyanka Singh on 01/06/18.
//  Copyright © 2018 Priyanka Singh. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define DefualtFont(x) [UIFont fontWithName:[HDKitabooFontManager getFontName] size:x]
#define playerBar_itemWidthIphone(items) isIpad()?98:(windowWidth/items)
#define playerBar_itemWidthIphoneColor(items) isIpad()?98:90
#define PenToolBar_itemWidthIphone(items) isIpad()?66:(windowWidth/items)  //
#define HighlightItemWidthForIphone (windowWidth == 320)?40:46
#define HighlightItemWidthForIpad 56
#define HighlightItemHeightForIphone 44
#define HighlightItemHeightForIpad 54
//
#define item_fontForIphone ((windowWidth == 320)?16:20.8)
#define colorItem_fontForIphone ((windowWidth == 320)?16:12)
#define item_fontSize (isIpad()?23:item_fontForIphone)
#define colorItem_fontSize (isIpad()?23:colorItem_fontForIphone)
#define ArrayOfDefaultColors [NSArray arrayWithObjects:@"#FFC000",@"#FC816C",@"#D68FFF",@"#A5D94C",@"#38D1DB", nil]
#define SharedColor  @"#8fd5e1"
#define isIphoneX (windowHeight == 812)
#define isLandScape (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
#define LocalisedString(locatisedString) [LocalizationHelper localizedStringWithKey:locatisedString]
#define GreyColorText @"#6E6E6E"
#define textAnnotationBar_Height 64
#define defaultNumberOfItemsForPlayerActionBar (isIpad()?8:6)
#define BOOK_RECEIVED_VIA_AIRDROP  @"BookReceivedViaAirDrop"
#define AudioSyncSpeedRateOption1 0.5
#define AudioSyncSpeedRateOption2 1
#define AudioSyncSpeedRateOption3 1.5
#define AudioSyncSpeedRateOption4 2

#undef NSLocalizedString//(key, comment)
#define NSLocalizedString(key, comment) \
[[LocalizeHelper shared] localizedStringForKey:(key)]

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HDFontManagerHelper.h"

static NSString *CustomFontNameForWeight=@"OpenSans";
static const inline BOOL isIpad()
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

static UIFont* getCustomFont(CGFloat size)
{
    return [[[HDFontManagerHelper getInstance] getFontManager] getCustomFont:size];
}

static UIFont* getCustomItalicFont(CGFloat size)
{
    return [[[HDFontManagerHelper getInstance] getFontManager] getCustomItalicFont:size];
}


static UIFont* getCustomFontForWeight(CGFloat size,UIFontWeight weight)
{
    return [[[HDFontManagerHelper getInstance] getFontManager] getCustomFontWith:size with:weight];
}

static const inline BOOL isRTL() {
    return [[UIApplication sharedApplication]userInterfaceLayoutDirection] == UIUserInterfaceLayoutDirectionRightToLeft;
 }
typedef enum : NSUInteger {
    kPlayerActiveModeNone = 0,
    kPlayerActiveModeHighlight = 1,
    kPlayerActiveModeNote = 2,
    kPlayerActiveModeBookmark = 3,
    kPlayerActiveModeThumbnail = 4,
    kPlayerActiveModePentool = 5,
    kPlayerActiveModeTeacherReview = 6,
    kPlayerActiveModeSearchText = 7,
    kPlayerActiveModeMyData = 8,
    kPlayerActiveModeTOC = 9,
    kPlayerActiveModeMarkupPlayer = 10,
    kPlayerActiveModeMarkupPlayerAudio =11,
    kPlayerActiveModeMarkupPlayerInLineVideo = 12,
    kPlayerActiveModeMarkupMutilink= 13,
    kPlayerActiveModeReflowableLayout = 14,
    kplayerActiveModeTextAnnotation = 15,
    kplayerActiveModeElasticSearch = 16,
    kplayerActiveModeMPO = 17,
    kPlayerActiveModeFIB = 18,
    kPlayerActiveModeProtractor = 19,
    kPlayerActiveModeGlossary = 20,
    kPlayerActiveModeAudioSync = 21,
    kPlayerActiveModeReadAloud = 22,
    kPlayerActiveModeInstruction = 23
} PlayerActiveMode;


typedef enum
{
    kPenToolBarItemTypePen = 0,
    kPenToolBarItemTypeThickness = 1,
    kPenToolBarItemTypeEraser = 2,
    kPenToolBarItemTypeDelete = 3,
    kPenToolBarItemTypeStudentName = 4,
    kPenToolBarItemTypeUndo = 5,
    kPenToolBarItemTypeRedo = 6,
    kPenToolBarItemTypeOverFlow = 7,
    kPenToolBarItemTypeNextPage = 8,
    kPenToolBarItemTypePrevPage = 9,
    kPenToolBarItemTypeTextAnnotation = 10,
    kPenToolBarItemTypeDone = 11,
    kPenToolBarItemTypePageNumber = 12
}PenToolBarItemType;

typedef enum

{
    kPlayerActionBarItemTypeTOC=1,
    kPlayerActionBarItemTypeMyData=2,
    kPlayerActionBarItemTypePenTool=3,
    kPlayerActionBarItemTypeStickyNote=4,
    kPlayerActionBarItemTypeSubmit=5,
    kPlayerActionBarItemTypeThumbnail=6,
    kPlayerActionBarItemTypeSearch=7,
    kPlayerActionBarItemTypeSlider=8,
    kPlayerActionBarItemTypeSearchTextField=9,
    kPlayerActionBarItemTypeIpadBottomBarButton=10,
    kPlayerActionBarItemTypeVerticalBar=11,
    kPlayerActionBarItemTypeTeacherReview = 12,
    kPlayerActionBarItemTypeStudentSubmit = 13,
    kPlayerActionBarItemTypeSound=14,
    kPlayerActionBarItemTypePlay=15,
    kPlayerActionBarItemTypeProfile=16,
    kPlayerActionBarItemTypeFontSetting=17,
    kPlayerActionBarItemTypePenColor =18,
    kPlayerActionBarItemTypeAddText=19,
    kPlayerActionBarItemTypeDone = 20,
    kPlayerActionBarItemTypeProtractor = 21,
    kPlayerActionBarItemTypeBookshelf=22,
    kPlayerActionBarItemTypePrev=23,
    kPlayerActionBarItemTypeNext=24,
    kPlayerActionBarItemTypeAudioSpeed=25,
    kPlayerActionBarItemTypeClose=26,
    kPlayerActionBarItemTypeSpeedText=25,
    kPlayerActionBarItemTypeOverFlow = 26,
    kPlayerActionBarItemTypeClearAllFIBs = 27,
    kPlayerActionBarItemTypeNote = 28,
    kPlayerActionBarItemTypeAudioSyncSpeedRateLabel=29,
    kPlayerActionBarItemTypePrint=30,
    kPlayerActionBarItemTypeFurthestPage=31,
    kPlayerActionBarItemTypeAudioSyncColor = 32,
    kPlayerActionBarItemTypeAudioSyncColorSelector = 33,
    kPlayerActionBarItemTypeDragBox = 34,
    kPlayerActionBarItemTypeGenerateReport = 35,
    kPlayerActionBarItemTypeNextStudent = 36,
    kPlayerActionBarItemTypePrevStudent = 37
}PlayerActionBarItemType;

typedef enum
{
    kPlayerActionBarTypeTop= 0,
    kPlayerActionBarTypeBottom = 1,
    kPlayerActionBarTypeTopForIphone= 2,
    kPlayerActionBarTypeBottomForIphone = 3,
    kPlayerActionBarTypePenToolBar = 4,
    kPlayerActionBarTypeTextAnnotation =5,
    kPlayerActionBarTypeTextAnnotationAlignment =6,
    kPlayerActionBarTypeTextAnnotationColor =7,
    kPlayerActionBarTypeForReadAloud= 8,
    kPlayerActionBarTypeForAudioSpeed= 9,
    kPlayerActionBarTypeForVertical = 10,
    kPlayerActionBarTypeAudioSync= 11

}PlayerActionBarType;

typedef enum
{
    kPdfBookType = 0,
    kEpubFixedType = 1,
    kEpubReflowableType = 2,
}BookType;

//Analytics Events
typedef enum : NSUInteger
{
    kTypePageTracking,
    kTypeNoteCreated,
    kTypeImpHighlightCreated,
    kTypeNormHighlightCreated,
    kTypeNoteShared,
    kTypeNoteReceived,
    kTypeNoteDeleted,
    kTypeImpHighlightDeleted,
    kTypeNormHighlightDeleted,
    KTypeBookClose,
    kTypeBookOpen,
    kTypeImpHighlightReceived,
    kTypeNormHighlightReceived,
    kTypeImpHighlightShared,
    kTypeNormHighlightShared,
    kTypeLinkOpen
}
AnalyticsEventType;

typedef enum
{
    kTextAnnotationBarItemTypeClose = 1,
    kTextAnnotationItemTypeAlignment = 2,
    kTextAnnotationItemTypeTextColor = 3,
    kTextAnnotationItemTypeAdd = 4,
    kTextAnnotationItemTypeSave = 5,
    kTextAnnotationItemTypeDelete = 6,
    kTextAnnotationItemTypeKeyboard = 7
}TextAnnotationBarItemType;

typedef enum
{
    kTextAnnotationAlignmentTypeLeft = 1,
    kTextAnnotationAlignmentTypeCenter = 2,
    kTextAnnotationAlignmentTypeRight = 3
}TextAnnotationAlignmentType;

typedef enum
{
    kTextAnnotationColorTypeColor1 = 1,
    kTextAnnotationColorTypeColor2 = 2,
    kTextAnnotationColorTypeColor3 = 3,
    kTextAnnotationColorTypeColor4 = 4,
    kTextAnnotationColorTypeColor5 = 5,
    kTextAnnotationColorTypeColor6 = 6,
    kTextAnnotationColorTypeColor7 = 7,
    kTextAnnotationColorTypeColor8 = 8,
    kTextAnnotationColorTypeColor9 = 9,
    kTextAnnotationColorTypeColor10 = 10
}TextAnnotationColorType;

typedef enum
{
    kAudioSyncSpeedRateOption1 = 1,
    kAudioSyncSpeedRateOption2 = 2,
    kAudioSyncSpeedRateOption3 = 3,
    kAudioSyncSpeedRateOption4 = 4
}AudioSyncSpeedRateOption;

#define YellowColor "#FFFF00"

#define SIGN_IN_LOCALIZABLE_TABLE @"SignInLocalization"
#define READER_LOCALIZABLE_TABLE @"Localizable"
#define BOOKSHELF_LOCALIZABLE_TABLE @"BookShelfLocalization"

#define SCREENSHOT_GRABALERT_TAG  7777
#endif /* Constant_h */
