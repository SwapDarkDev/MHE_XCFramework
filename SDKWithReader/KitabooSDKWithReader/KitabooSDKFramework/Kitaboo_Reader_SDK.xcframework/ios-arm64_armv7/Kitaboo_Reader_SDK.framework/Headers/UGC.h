//
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*!
 UGC_STATUS is status or state of UGC, Whether it is unsaved,new,updated or deleted.
 */
typedef enum : short{

    UNSAVED        = 0,
    NEW            = 1,
    UPDATE         = 2,
    DELETE         = 3
    
}UGC_STATUS;

typedef enum : short{
    LEFT = 0,
    RIGHT = 1,
    CENTER = 2
    
}TEXT_ANNOTATION_ALIGNMENT;

/** UGC(User Generated Code) is responsible for creating and managing higlight, note, fib, pentool, bookmark, text annotation.
 @discussion UGC defines all the parameters/atrributes which are required to create and manage UGC.
 @superclass SuperClass : NSObject
 */
@interface UGC : NSObject

@property (strong, nonatomic) NSString *ugcID;
@property (strong, nonatomic) NSString *localID;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *modifiedDate;
@property (strong, nonatomic) NSString *chapterName;
@property (strong, nonatomic) NSString *href;
@property (strong, nonatomic) NSString *idref;
@property (nonatomic) BOOL isSynced;
@property (nonatomic) NSInteger chapterID;
@property (nonatomic) UGC_STATUS status;
@property (strong,nonatomic) NSString *pageIdentifier;
@property (strong,nonatomic) NSString *displayNum;
@property (strong, nonatomic) NSString *positionIdentifier;

/*!
 * This method used to  get display Date.
 @discussion To set display date in myDataController for notes and highlights we get that date from this method.
 @return String value, date in string form.
 @code
 [highlightVO getDisplayDate];
 @endcode
 */
- (NSString *)getDisplayDate;

/*!
 * This method used to  get created Date.
 @discussion To get created date of UGC according to Coordinated Universal Time (UTC) standard.
 @return String value, date in string form.
 @code
 [highlightVO getUTCCreatedDate];
 @endcode
 */
- (NSString *)getUTCCreatedDate;

/*!
 * This method used to  get modified Date.
 @discussion To get modified date of UGC according to Coordinated Universal Time (UTC) standard.
 @return String value, date in string form.
 @code
 [highlightVO getUTCModifiedDate];
 @endcode
 */
- (NSString *)getUTCModifiedDate;

@end

/** SDKHighlightVO is responsible for Highlights and Notes.
 @discussion SDKHighlightVO defines all the parameters/atrributes which are required to create any hightlight or to create any note either Sticky Note or Contextual Note.
 
 - Contextual Note
 
 This note is related to any Selected Text.
 
 - Sticky Note
 
 This note is not coupled with any Text. User can write her/his data on it. And Sticky note can be dragged anywhere on the page.
 @superclass SuperClass : UGC
 */
@interface SDKHighlightVO : UGC
-(BOOL)isStickyNote;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *startOffset;
@property (strong, nonatomic) NSNumber *endOffset;
@property (strong, nonatomic) NSString *noteText;
@property (strong, nonatomic) NSArray *noteComments;
@property (strong, nonatomic) NSArray *sharedUsers;
@property (strong, nonatomic) NSString *creatorName;
@property (nonatomic) NSInteger creatorID;
@property (nonatomic) BOOL isImportant;
@property (nonatomic) BOOL isShare;
@property (nonatomic) BOOL isReceived;
@property (nonatomic) BOOL isAnswered;
@property (nonatomic) BOOL isCollabSubmitted;
@property (nonatomic) BOOL isTeacherReviewNote;
@property (strong, nonatomic) NSString *textColor;
@property (strong, nonatomic) NSString *backgroundColor;
@property (strong, nonatomic) NSDictionary *metaData;
@property (nonatomic) BOOL isMultiNoteMember;
@property (nonatomic) CGRect multiNoteFrame;

@end

/** SDKBookmarkVO is responsible for Bookmarks.
 @discussion SDKBookmarkVO defines all the parameters/atrributes which are required to create any Bookmark. Eg. Text, Start Offset, End Offset etc.
 @superclass SuperClass : UGC
 */
@interface SDKBookmarkVO : UGC

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *startOffset;
@property (strong, nonatomic) NSNumber *endOffset;
@property (strong, nonatomic) NSString *creatorName;
@property (nonatomic) NSInteger creatorID;
@property (strong, nonatomic) NSDictionary *metaData;

@end


/** SDKPentoolVO is responsible for pentool data.
 @discussion SDKPentoolVO defines all the parameters/atrributes which are required to create any pen drawing.Eg. colorCode, penThickness, penToolPoints etc.
 @superclass SuperClass : UGC
 */
@interface SDKPentoolVO : UGC

@property (strong, nonatomic) NSString *colorCode;
@property (strong, nonatomic) NSNumber *penThickness;
@property (strong, nonatomic) NSArray *penToolPoints;
@property (strong, nonatomic) NSNumber *penType;
@property (strong, nonatomic) NSDictionary *penToolData;
@property (nonatomic) BOOL isSubmitted;

@end

/** SDKFIBVO is responsible for FIB.
 @discussion SDKFIBVO defines all the parameters/atrributes which are required for FIB. Eg. metaData, linkID, review etc.
 @superclass SuperClass : UGC
 */
@interface SDKFIBVO : UGC

@property (strong, nonatomic) NSDictionary *metaData;
@property (strong, nonatomic) NSNumber *linkID;
@property (strong, nonatomic) NSNumber *review;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *answerStatus;
@property (strong, nonatomic) NSString *teacherComment;
@property (strong, nonatomic) NSDate *commentCreatedDate;
@property (strong, nonatomic) NSDate *commentModifiedDate;
@property (nonatomic) BOOL isSubmitted;
@property (nonatomic) BOOL isEquation;
@property (strong, nonatomic) NSNumber *inputType;
@end

/** SDKTextAnnotationVO is responsible for Text Annotation.
 @discussion SDKTextAnnotationVO defines all the parameters/atrributes which are required to create text annotation.
 @superclass SuperClass : UGC
 */
@interface SDKTextAnnotationVO : UGC
/** Frame for the Text Annotation. */
@property (strong, nonatomic) NSDictionary *metaData;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *fontName;
@property (nonatomic) float fontSize;
@property (strong,nonatomic) NSString *backgroundColor;
@property (strong,nonatomic) NSString *textColor;
@property (nonatomic) TEXT_ANNOTATION_ALIGNMENT textAlignment;
@end

@interface SDKProtractorVO : SDKPentoolVO
@property (assign, nonatomic) float protractorLineThickness;
@end
