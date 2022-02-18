//
//  FilterViewController.h
//  Kitaboo
//
//  Created by Priyanka Singh on 19/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderHeader.h"
#import "HDReaderSettingModel.h"

typedef void(^FilterHighlights)(NSArray*,BOOL,BOOL);
typedef void(^FilterNotes)(NSArray*,NSArray*,BOOL,BOOL,BOOL);
typedef void(^DismissFilter)(void);

@interface FilterViewController : UIViewController
@property (nonatomic) FilterHighlights filterHighlightsAction;
@property (nonatomic) FilterNotes filterNotesAction;
@property (nonatomic) DismissFilter dissmisFilterController;
@property (nonatomic,strong) KBHDThemeVO *themeVO;
@property (nonatomic) BookOrientationMode bookOrientationMode;
@property (nonatomic) BOOL isSharingEnabled;
@property (nonatomic,strong) HDReaderSettingModel *userSettingsModel;
@property (nonatomic) BOOL isStickyNotesEnabled;

-(void)setIsHighlightFilter:(BOOL)isHighlightFilter;
-(void)setColorsForFilter:(NSArray *)colorsArray;
@end

