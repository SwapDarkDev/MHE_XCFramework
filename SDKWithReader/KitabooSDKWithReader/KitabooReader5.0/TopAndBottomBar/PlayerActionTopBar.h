//
//  PlayerActionTopBar.h
//  Kitaboo
//
//  Created by Priyanka Singh on 15/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "ReaderHeader.h"
#import "Constant.h"

@interface PlayerActionTopBar : PlayerActionBar
@property (nonatomic, strong)HDReaderSettingModel *userSettingsModel;
@property (nonatomic,strong) PlayerActionBarItem *chapterNameItem;
@property (nonatomic,strong) NSString *selectedPenColor;
@property (strong,nonatomic) KitabooBookVO *bookVO;
@property (nonatomic,strong) KitabooUser *user;
@property BOOL hideProfileSettingsButton;
-(void)updateColorSelectedView:(UIColor *)selectedColor withColorThickness:(CGFloat)colorThickness;
-(void)addPlayerTopBarForIPhoneWithTheme:(KBHDThemeVO*)themeVO isEpub:(BookType)bookType;
-(void)updatedPlayerForPenTool:(KBHDThemeVO*)themeVO withPenToolColors:(NSArray *)pencolors;
-(void)addPlayerTopBarForTeacherAnnotationForIPad:(KBHDThemeVO*)themeVO withPenColors:(NSArray *)colorsArray studentName:(NSString*)studentName andImageUrl:(NSString *)imageUrl withSelectedPenColor:(NSString *) selectedPenColor withCurrentPageNumber:(NSString *)pageNumber;
-(void)updatePlayerSelectedItem:(KBHDThemeVO *)themeColor;
-(void)updateSelectedPenColor:(NSString*)penColor withTheme:(KBHDThemeVO *)themeVO;
-(void)updateSelectedAudioSyncColor:(NSString*)penColor withTheme:(KBHDThemeVO *)themeVO;
-(void)addPlayerTopBarForScormPackage:(KBHDThemeVO*)themeVO;

-(void)addPlayerTopBarForTeacherAnnotationForIPhone:(KBHDThemeVO*)themeVO studentName:(NSString*)studentName andImageUrl:(NSString *)imageUrl withAllTeacherAnnotationPages:(NSArray *)totalNumberOfPages;
-(void)addPlayerBottomBarForTeacherAnnotationForIPhone:(KBHDThemeVO*)themeVO withPenColors:(NSArray *)colorsArray withSelectedPenColor:(NSString *)selectedPenColor;
-(PlayerActionBarItem *)getPlayerItemWithIcon:(NSString *)iconStr withActionTag:(int)playerActionTag withThemeVO:(KBHDThemeVO*)hdThemeVO withItemSize:(CGFloat)size numberOfItems:(int)numberOfItems;
-(PlayerActionBarItem *)initialiseChapterNameItemwithThemeVO:(KBHDThemeVO*)hdThemeVO;
-(void)setAccessibilityForPlayerActionTopBarItem:(PlayerActionBarItem *)actionBarItem;
-(PlayerActionBarItem *)getTopBarPlayerButtonForProfilewithThemeVO:(KBHDThemeVO*)hdThemeVO;
-(void)changeIcon:(NSString *)iconText forItemType:(int)itemType;
-(void)addPlayerTopBarForTeacherReviewAnnotation:(KBHDThemeVO*)themeVO studentName:(NSString*)studentName imageUrl:(NSString *)imageUrl studentCount:(int)count studentIndex:(int)index;
-(void)addPlayerBottomBarForTeacherReviewAnnotation:(KBHDThemeVO*)themeVO;
-(void)addPlayerTopBarWithoutGenerateReportForTeacherReviewAnnotation:(KBHDThemeVO*)themeVO studentName:(NSString*)studentName imageUrl:(NSString *)imageUrl studentCount:(int)studentCount studentIndex:(int)studentIndex;
@end
