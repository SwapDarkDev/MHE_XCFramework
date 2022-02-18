//
//  ReaderHeader.h
//  Kitaboo
//
//  Created by Sumanth Myrala on 10/06/20.
//  Copyright © 2020 Hurix System. All rights reserved.
//

#ifndef ReaderHeader_h
#define ReaderHeader_h

#define UIControl_Font_familySimple(X) [UIFont fontWithName:@"Helvetica Neue" size:X]
#define RGBCOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define NSUSERDEFAULT           [NSUserDefaults standardUserDefaults]
#define windowWidth             [UIScreen mainScreen].bounds.size.width
#define windowHeight            [UIScreen mainScreen].bounds.size.height
#define StatusBarHeight         [[UIApplication sharedApplication] statusBarFrame]..size.height

#import "AlertView.h"
#import "IconFontConstants.h"
#import "KBHDThemeVO.h"
#import "HSUIColor-Expanded.h"
#import "UITextView+PH.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import "KBMyDataViewController.h"
#import "HSUIColor-Expanded.h"
#import "NSString-Supplement.h"
#import "KitabooPenToolColorPalleteViewController.h"
#import "KitabooPenToolThicknessPalleteViewController.h"
#import "UIButton-Expanded.h"
#import "UIViewController-Expanded.h"
#import "SystemInformation.h"
#import "MultiLinkController.h"
#import "StickyNotesViewController.h"
#import "TeacherAnnotationViewController.h"
#import "KBThumbnailViewController.h"
#import "PlayerActionTopBar.h"
#import "PlayerActionBottomBar.h"
#import "Constant.h"
#import "KBShareSettingsController.h"
#import "KitabooNetworkManager.h"
#import "HDKitabooMediaBookController.h"
#import "KBFixedEpubThumbnailViewController.h"
#import "HDKitabooHLSDownloaderManager.h"
#import "UGCXMLClass.h"

#endif /* ReaderHeader_h */
