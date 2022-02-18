//
//  ePUBBook.h
//  ePUBSDK
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "KitabooBookVO.h"
#import "HSRendrerConstant.h"

typedef enum : short{
    
    ePubFileTypeXhtml = 0,
    ePubFileTypeJpeg = 1,
    ePubFileTypeCss = 2,
    ePubFileTypeOthers = 3,
    ePubFileTypeSmil = 4
    
}  EPUB_FILE_TYPE;

typedef enum : short{
    
    ePubPageDirectionLtr = 0,
    ePubPageDirectionRtl = 1
    
} EPUB_PAGE_DIRECTION;

typedef enum : short {
    
    ePUBImageMarkup = 0
} EPUBMarkupType;

typedef enum : short{

    ePUBReflowable = 0,
    ePUBFixedLayout = 1
    
} EPUB_LAYOUT;

typedef enum : short {
    
    ePUBAuto = 0,
    ePUBLandscape = 1,
    ePUBPortrait = 2
    
} EPUB_ORIENTATION;

typedef enum : short {
    
    ePUBNoneSpread = 0,
    ePUBLandscapeSpread = 1,
    ePUBPortraitSpread = 2,
    ePUBBothSpread = 3,
    ePUBAutoSpread = 4
    
} EPUB_SPREAD;

typedef enum
{
    kEPUBLinkTypeNone = 0,
    kEPUBLinkTypeAudio,
    kEPUBLinkTypeVideo,
    kEPUBLinkTypeImage,
    kEPUBLinkTypeDocument,
    kEPUBLinkTypePageLink,
    kEPUBLinkTypeWebLink,
    kEPUBLinkTypeOther
} EPUBMarkupLinkType;

@class EPUBMeta;

@class EPUBChapterCFI;

@class ReaderFontSetting;
/**
 EPUBBookVO refers to complete data of the book.This is considered only for Epub type books
 */
@interface EPUBBookVO : KitabooBookVO

@property (nonatomic, strong) NSString* version;
@property (nonatomic, strong) NSString* bookTitle;
@property (nonatomic, strong) NSString* absolutePath;
@property (nonatomic, strong) NSString* rootPath;
@property (nonatomic, strong) NSString* coverImageName;
@property (nonatomic, strong) NSArray* guides;
@property (nonatomic, strong) EPUBMeta* meta;
@property (nonatomic, strong) NSArray* files;
@property (nonatomic, strong) NSArray* chapters;
@property (nonatomic, strong) NSArray* toc;
@property (nonatomic, strong) NSArray* resources;
@property (nonatomic, strong) NSArray* glossary;
@property (nonatomic, strong) NSArray* bookCFIArray;
@property (nonatomic, strong) NSArray* tocPageList;
@property (nonatomic, strong) NSArray<EPUBChapterCFI *>* bookCFIs;
@property (nonatomic, assign) BOOL isBookContentLoaded;
@property (nonatomic, assign) BOOL isAudioSyncSupported;
@property (nonatomic, assign) NSInteger totalNumberOfPages;
@property (nonatomic, assign) BOOL isEpubTypeAuthorReflow;
@property (nonatomic, strong) ReaderFontSetting* defaultReaderFontSettings;
@property (nonatomic, strong) ReaderFontSetting* userReaderFontSettings;
-(BOOL)isKitabooEpubThumbnailSupported;
@end


@interface ReaderFontSetting : NSObject
@property (nonatomic, strong) NSString* fontFamily;
@property (nonatomic, assign) FONT_SIZE fontSize;
@property (nonatomic, assign) TEXT_ALIGNMENT textAlignment;
@property (nonatomic, assign) TEXT_LINESPACING lineSpacing;
@property (nonatomic, assign) READER_MARGIN margin;
@property (nonatomic, assign) READER_MODE readerMode;
@property (nonatomic, assign) BOOL scrollEnabled;
@end

@interface EPUBChapterCFI : NSObject
@property (nonatomic, strong) NSString* idref;
@property (nonatomic, strong) NSString* href;
@property (nonatomic, strong) NSArray* chapterCFIArray;
@end

/**
 EPUBMeta refers to meta data of the book.This is considered only for Epub type books
 */
@interface EPUBMeta : NSObject

@property (nonatomic, strong) NSMutableArray* titles;
@property (nonatomic, strong) NSString* language;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* idname;
@property (nonatomic, strong) NSString* date;
@property (nonatomic, strong) NSMutableArray* creators;
@property (nonatomic, strong) NSString* publisher;
@property (nonatomic, strong) NSString* modified;
@property (nonatomic) EPUB_LAYOUT layout;
@property (nonatomic) EPUB_ORIENTATION orientation;
@property (nonatomic) EPUB_SPREAD spread;

-(BOOL)isValid;

@end

/**
 EPUBMeta refers to file data of the page.This is considered only for Epub type books
 */
@interface EPUBFile : NSObject

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* properties;
@property (nonatomic, strong) NSString* href;
@property (nonatomic, strong) NSString* mediaType;
@property (nonatomic, strong) NSString* mediaOverlay;
@property (nonatomic, assign) EPUB_FILE_TYPE fileType;

@end

/**
 EPUBChapter refers to current chapter data of the book.This is considered only for Epub type books
 */
@interface EPUBChapter : NSObject

@property (nonatomic, strong) NSString* idref;
@property (nonatomic, strong) NSString* chapterName;
@property (nonatomic, assign) BOOL linear;
@property (nonatomic, assign) NSInteger fileIndex;
@property (nonatomic, strong) NSString* href;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger contentSize;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger bookContentSizeTillChapter;
@property (nonatomic, assign) NSInteger totalNumOfPagesTillChapter;
@property (nonatomic, assign) BOOL isAudioSyncSupported;
@property (nonatomic, strong) NSString* smilPath;
@property (strong, nonatomic) NSArray *audioSyncArray;
@property (strong, nonatomic) NSArray *chapterResources;
@end

@interface EPUBGuide : NSObject

@property (nonatomic, strong) NSString* type;
@property (nonatomic, assign) NSString* title;
@property (nonatomic, assign) NSString* href;

@end
/**
 EPUBPage refers to current page data of the book.This is considered only for Epub type books
 */
@interface EPUBPage : NSObject <NSCopying>

@property (strong, nonatomic) NSString *idref;
@property (strong, nonatomic) NSString *href;
@property (nonatomic) NSInteger pageNumber;
@property (nonatomic) NSInteger fileIndex;
@property (nonatomic) BOOL isFirstPage;
@property (nonatomic) BOOL isLastPage;
@property (nonatomic) BOOL isBookmarked;
@property (strong, nonatomic) NSMutableArray *bookmark;
@property (strong, nonatomic) NSMutableArray *ugcArray;


- (instancetype)initWithIDRF:(NSString *)idref
                   fileIndex:(NSInteger)fileIndex
                        href:(NSString *)href
                  pageNumber:(NSInteger)pageNumber
                    ugcArray:(NSMutableArray *)array;
@end

/**
 EPUBResource refers to resources data of the page.This is considered only for Epub type books
 */
@interface EPUBResource : NSObject

@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *typeId;
@property (strong, nonatomic) NSString *href;
@property (strong, nonatomic) NSString *assetPath;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *resourceName;
@property (strong, nonatomic) NSString *resourceId;
@property (strong, nonatomic) NSString *roletype;
@property (strong, nonatomic) NSString *subtype;
@property (strong, nonatomic) NSDictionary *chapter;
@property (assign, nonatomic) BOOL displayUnderTOR;
@property (assign, nonatomic) EPUBMarkupLinkType epubLinkType;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

/**
 EPUBToc refers to TOC data of the book.This is considered only for Epub type books
 */
@interface EPUBToc : NSObject

@property (strong, nonatomic) NSString *tocId;
@property (strong, nonatomic) NSString *playOrder;
@property (strong, nonatomic) NSString *tocLabel;
@property (strong, nonatomic) NSString *src;
@property (assign, nonatomic) NSInteger nodeLevel;
@property (assign, nonatomic) BOOL tocExpanded;
@property (weak, nonatomic) EPUBToc *parentNode;
@property (strong, nonatomic) NSMutableArray *subNodes;
- (NSArray *)getBookContentForTOCSubnodes;

@end

@interface EPUBTOCPage : NSObject

@property (strong, nonatomic) NSString *displayNumber;
@property (strong, nonatomic) NSString *src;

@end

/**
 EPUBGlossary refers to glossary data of the page.This is considered only for Epub type books
 */
@interface EPUBGlossary : NSObject

@property (strong, nonatomic) NSString *glossaryId;
@property (strong, nonatomic) NSString *term;
@property (strong, nonatomic) NSString *definition;
@property (strong, nonatomic) NSString *translation;
@property (strong, nonatomic) NSString *pronunciation;
@property (strong, nonatomic) NSString *audio;
@property (strong, nonatomic) NSString *video;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *url;

@end

/**
 EPUBGlossary refers to glossary data of the page.This is considered only for Epub type books
 */
@interface EPUBMarkup : NSObject

@property (strong, nonatomic) NSString *markupId;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) EPUBMarkupType markupType;

@end

@interface EpubAudioSyncVO : NSObject

@property (strong, nonatomic) NSString *parId;
@property (strong, nonatomic) NSString *wordSrc;
@property (strong, nonatomic) NSString *audioSrc;
@property (assign, nonatomic) float clipBegin;
@property (assign, nonatomic) float clipEnd;

@end
