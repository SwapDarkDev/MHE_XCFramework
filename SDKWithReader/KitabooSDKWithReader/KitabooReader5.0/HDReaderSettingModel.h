//
//  HDReaderSettingModel.h
//  Kitaboo
//
//  Created by Sumanth Myrala on 05/06/20.
//  Copyright © 2020 Hurix System. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** An Object that manage all the reader settings/configurations to enable/disable the various components of the Kitaboo Reader
@superclass SuperClass : NSObject
*/
@interface HDReaderSettingModel : NSObject

/*!
* An Array property used to set the colors of pentool used in Reader.If this property is not being set then default colors will be used.
*/
@property (nonatomic, strong) NSArray *pentoolPenColors;

/*!
* Boolean property used to enable/disable Bookmark component/feature from Reader.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isBookmarkEnabled;

/*!
* Boolean property used to enable/disable Sharing of Notes/Highlights from Reader.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isSharingEnabled;

/*!
* Boolean property used to enable/disable AutoLogin from Reader.If this property is not being set then by default the value will be NO.
*/
@property (nonatomic) BOOL isAutoLoginEnabled;

/*!
* Boolean property used to enable/disable Highlighting of text from Reader.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isHighLightEnabled;

/*!
* Boolean property used to enable/disable Search component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isSearchEnabled;

/*!
* Boolean property used to enable/disable StickyNote component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isStickyNotesEnabled;

/*!
* Boolean property used to enable/disable AutoReadAloud component/feature.If this property is not being set then by default the value will be NO.
*/
@property (nonatomic) BOOL isAutoReadAloudEnabled;

/*!
* Boolean property used to enable/disable Analytics.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isAnalyicsButtonEnabled;

/*!
* Boolean property used to enable/disable Math Editor component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isMathEditorEnabled;

/*!
* Boolean property used to enable/disable Protractor component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isProtractorEnabled;

/*!
* Boolean property used to enable/disable Teacher Review component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isReviewEnabled;

/*!
* Boolean property used to enable/disable PenTool component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isPenToolEnabled;

/*!
* Boolean property used to enable/disable Contextual Note component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isContextualNoteEnabled;

/*!
* Boolean property used to enable/disable Clear All FIB.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isClearAllFIBsEnabled;

/*!
* Boolean property used to enable/disable MyData component/feature.If this property is not being set then by default the value will be YES.
*/
@property (nonatomic) BOOL isMydataEnabled;

/*!
* Boolean property used to enable/disable Text Annotation component/feature.If this property is not being set then by default the value will be NO.
*/
@property (nonatomic) BOOL isTextAnnotationEnabled;

/*!
* Boolean property used to enable/disable Bookmark component/feature from AudioBook.If this property is not being set then by default the value will be NO.
*/
@property (nonatomic) BOOL isAudioBookBookmarkEnabled;

/*!
* Boolean property used to enable/disable AudioSync feature from epub book.
*/
@property (nonatomic) BOOL isAudioSyncEnabled;

/*!
* Boolean property used to enable/disable Print feature from epub reflowable book.
*/
@property (nonatomic) BOOL isPrintEnabled;

/*!
* Boolean property used to enable/disable Print feature for my Data.
*/
@property (nonatomic) BOOL isMyDataPrintEnabled;

@end

NS_ASSUME_NONNULL_END
