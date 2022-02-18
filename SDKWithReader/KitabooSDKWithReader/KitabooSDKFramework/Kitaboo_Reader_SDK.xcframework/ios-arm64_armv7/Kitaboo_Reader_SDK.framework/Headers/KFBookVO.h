//
//  KFBookVO.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KitabooBookVO.h"
#import "HSRendrerConstant.h"
#import "MarkupView.h"
#import "MarkupHitAreaLabel.h"

typedef enum
{
    kLinkTypeNone = 0,
    kLinkTypeMultiLink,
    kLinkTypeAudio,
    kLinkTypeVideo,
    kLinkTypeImage,
    kLinkTypeInput,
    kLinkTypeComments,
    kLinkTypePageLink,
    kLinkTypeWebLink,
    kLinkTypeDictera,
    kLinkTypeDocument,
    kLinkTypeAudioSync,
    kLinkTypeHtmlWrap,
    kLinkTypeDropDown,
    kLinkTypeSlideShow,
    kLinkTypeWidget,
    kLinkTypeGroupNotes,
    kLinkTypeKaltura,
    kLinkTypeYoutube,
    kLinkTypeSurvey,
    kLinkTypeGlossary,
    kLinkTypeJumpToBook,
    kLinkTypeImageZoom,
    kLinkTypeInstruction,
    kLinkTypeVimeoVideo,
    kLinkTypeTracerMedia,
    kLinkTypeOther
} MarkupLinkType;

typedef enum
{
    kBookOrientationTypeLandscapeOnly = 0,
    kBookOrientationTypePortraitOnly,
    kBookOrientationTypeDynamic
} BookOrientationType;

@class KFBookVO;
@class KFChapterVO;
@class KFPageVO;
@class InputTextLink;
@class KFLinkVO;
@class KFResourceVO;
@class KFGlossaryVO;
@class KFSearchVO;
@class KFIconsVO;
@class KFTOCVO;
@class KFPDFExtractVO;
@class KFAudioSyncVO;


/**
 KFBookVO refers to data of the Kitaboo Fixed book.
 */
@interface KFBookVO : KitabooBookVO
@property (nonatomic, strong)NSString *ISBN;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *chaptersPath;
@property (nonatomic, strong)NSString *resourcePath;
@property (nonatomic, strong)NSString *glossaryPath;
@property (nonatomic, strong)NSString *tocPath;
@property (nonatomic, strong)NSString *coverPagePath;
@property (nonatomic, strong)NSString *author;
@property (nonatomic, strong)NSString *printdata;
@property (nonatomic, strong)NSMutableDictionary *chapters;
@property (nonatomic, strong)NSDictionary *pages;
@property (nonatomic, strong)NSMutableArray *resources;
@property (nonatomic, strong)NSMutableDictionary *glossary;
@property (nonatomic, strong)NSMutableArray* toc;
@property (nonatomic, strong)NSMutableDictionary* icons;
@property (nonatomic, strong)NSMutableDictionary* search;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, strong)NSString *dbPath;
@property (nonatomic) BookOrientationType bookOrientationType;
@property BOOL isReadAloudEnabled;
@property BOOL isCharacterLevelSearchEnabled;

-(KFPageVO*)pageForPagenumber:(NSNumber*)pageNumber;
-(NSArray*)getLinksForForPagenumber:(NSNumber*)pageNumber;
-(KFChapterVO*)getChapterForPageID:(NSString*)pageID;
-(KFPageVO*)getNextAudioLinkPagefromCurrentPageNumber:(NSString*)currentPageNumber;
-(KFPageVO*)getPrevAudioLinkPagefromCurrentPageNumber:(NSString*)currentPageNumber;
-(void)setPrintEnableToPages;
@end

/**
 KFChapterVO refers to data of the chapter of the book
 */
@interface KFChapterVO : NSObject
@property (nonatomic)NSInteger chapterID;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *pagesPath;
@property (nonatomic, strong)NSString *pageRange;
@property (nonatomic, strong)NSString *displayPages;
@property (nonatomic, strong)NSString *access_id;
@property (nonatomic, strong)NSDictionary *pages;
@property (nonatomic, strong)NSMutableDictionary *links;

@end

/**
 KFPageVO refers to data of the page of the book
 */
@interface KFPageVO : NSObject
@property (nonatomic)NSInteger pageID;
@property (nonatomic)int pageNum;
@property (nonatomic, strong)NSString *displayNum;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSDictionary *links;
@property (nonatomic, strong)NSDictionary *pdfExtract;
@property (nonatomic, strong) NSString *searchKeyWord;
@property (nonatomic, strong) NSArray *searchRectValues;
@property (strong, nonatomic) NSMutableArray *ugcArray;
@property (nonatomic, strong)NSString *dbPath;
@property BOOL isPrintEnable;
@property BOOL isCharacterLevelSearchEnabled;

-(void)prepareTransformedLinesForCropBoxFrame:(NSValue *)cropBoxValue withDisplayFrame:(NSValue *)displayFrameValue;
-(NSArray*)getAudioSyncLinks;
-(NSArray *)getAudioSyncTypeLinks;
@end

@interface InputTextLink : NSObject

@property (nonatomic,assign)BOOL isMultiline;
@property (nonatomic,assign)BOOL isFixedFont;
@property (nonatomic,assign)NSInteger fontSize;
@property (nonatomic,assign)NSInteger lineSpacing;
@property (nonatomic,assign)NSInteger charLimit;
@property (nonatomic,assign)BOOL isScrollable;
@property (nonatomic,retain)NSString *textColour;
@property (nonatomic,retain)NSString *fontName;

@end

/**
 KFLinkVO refers to data of the links which are present in the page
 */
@interface KFLinkVO : NSObject
@property (nonatomic)NSInteger linkID;
@property (nonatomic,strong)NSString *folioNumber;
@property (nonatomic,strong)NSString *pageID;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *xCoordinate;
@property (nonatomic,strong)NSString *yCoordinate;
@property (nonatomic,strong)NSString *box;
@property (nonatomic)NSInteger alpha;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *groupName;
@property (nonatomic,strong)NSString *properties;
@property (nonatomic,strong)NSString *layer;
@property (nonatomic,strong)NSString *iconURL;
@property (nonatomic,strong)NSString *toolTip;
@property (nonatomic,strong)NSString *sequence;
@property (nonatomic)NSInteger audioLength;
@property (nonatomic,strong)NSString *altText;
@property (nonatomic, strong)NSArray* audioSync;
@property (nonatomic) MarkupLinkType linkType;
@property (nonatomic) CGRect transformedRect;
@property (nonatomic) CGRect boxTansformedRect;
@property (nonatomic) BOOL isExternal;
@property (nonatomic) BOOL isInstantFeedback;
@property (nonatomic) BOOL isMultipleAnswer;
@property (nonatomic) BOOL isMathKeyboardEnabled;
@property (nonatomic) NSString *answer;
@property (nonatomic) BOOL isCaseSenstive;
@property (nonatomic,retain)InputTextLink *inputTextlink;
@property (nonatomic,strong)NSString *iconText;
@property (nonatomic, strong)MarkupView *iconView;
@property (nonatomic, strong)MarkupHitAreaLabel *iconHitAreaLabel;

-(NSString*)getIconForLinkType:(MarkupLinkType)linkType;
- (BOOL)isFlexible;
- (BOOL)isInLine;
- (void)setIsInline:(BOOL)isInline;
- (BOOL)isPlaylist;
- (BOOL)isVisible;
- (BOOL)isDisplayUnderTOR;
- (BOOL)isPlaybackground;
@property (nonatomic,assign)BOOL isMultiLinkMember;
@end



/**
 KFResourceVO refers to data of the resources which are present in the page
 */
@interface KFResourceVO : NSObject
@property (strong, nonatomic) NSString *resourceTitle;
@property (strong, nonatomic) NSString *resourceName;
@property (strong, nonatomic) NSString *resourceType;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *accessRole;
@property (nonatomic)NSUInteger parentid;
@property (nonatomic)NSUInteger resourceID;
@property (strong, nonatomic) NSMutableArray *subNodes;
@property (nonatomic,assign)int tocLevel;
- (NSArray *)getBookResourcesForTORSubnodes;
- (NSArray *)getBookResourcesForTORSubnodesForRole:(NSString *)role ofStandardType:(NSString *)standardType;
- (void)addItem:(KFResourceVO *)resource;

@end

/**
 KFResourceVO refers to data of the glossary which are present in the page
 */
@interface KFGlossaryVO : NSObject
@property (nonatomic) NSInteger glossaryId;
@property (nonatomic,strong) NSString *alphabet;
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong) NSString *glossaryDescription;
@property (nonatomic,strong) NSString *audioPath;
@property (nonatomic,strong) NSString *videoPath;
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) NSString *pronunciation;
@property (nonatomic,strong) NSString *URL;
@end

/**
 KFSearchVO refers to search data of the book
 */
@interface KFSearchVO : NSObject
@property (nonatomic) NSInteger searchId;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic,strong) NSString *displayNum;
@property (nonatomic,strong) NSString *pageText;
@property (nonatomic, assign)BOOL isEncrypted;

@end

/**
 KFIconsVO refers to data of the icons which are present in the page
 */
@interface KFIconsVO : NSObject
@property (nonatomic) NSInteger iconID;
@property (nonatomic,strong) NSString *iconName;
@property (nonatomic,strong) NSString *iconPath;
@property (nonatomic, assign)BOOL isFlexible;
@property (nonatomic,strong) NSString *iconType;

@end

/**
 KFTOCVO refers to TOC data of the book
 */
@interface KFTOCVO : NSObject
@property (nonatomic) NSInteger tocID;
@property (nonatomic) NSInteger pageID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *folioNumber;
@property (nonatomic,strong) NSString *nodeTocID;
@property (nonatomic) NSInteger parentId;
@property(nonatomic,assign)int tocLevel;
@property (strong, nonatomic) NSMutableArray *subNodes;
- (NSArray *)getBookContentForTOCSubnodes;
- (void)addItem:(KFTOCVO *)toc;

@end

/**
 KFPDFExtractVO refers to the data of each and every word of the book
 */
@interface KFPDFExtractVO : NSObject
@property (nonatomic) NSInteger paraID;
@property (nonatomic) NSInteger pageID;
@property (nonatomic) NSInteger lineID;
@property (nonatomic) NSInteger wordID;
@property (assign, nonatomic) float lineY;
@property (assign, nonatomic) float lineH;
@property (assign, nonatomic) float wordX;
@property (assign, nonatomic) float wordW;
@property (nonatomic,strong) NSString *wordText;

@end

/**
 KFAudioSyncVO refers to the data of each and every word of the book that needs to be synced for audio
 */
@interface KFAudioSyncVO : NSObject
@property (nonatomic) NSInteger linkID;
@property (nonatomic) NSInteger wordID;
@property (assign, nonatomic) float cueStartPoint;
@property (assign, nonatomic) float cueEndPoint;
@property (assign, nonatomic) float imgX;
@property (assign, nonatomic) float imgY;
@property (assign, nonatomic) float imgW;
@property (assign, nonatomic) float imgH;
@property (nonatomic,strong) NSString *groupStatus;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic) CGRect transformedRect;

@end





