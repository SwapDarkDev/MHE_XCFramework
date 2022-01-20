//
//  HVRendrerConstant.h
//  ePUBSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//


#define kRefreshData            @"RefreshData"

#define kFontSizeChangeKey      @"fontSize"
#define kReaderModeChangeKey    @"readerMode"
#define kPaginationChangeKey    @"pagination"
#define kTextAlignmentChangeKey @"textAlignment"
#define kFontFamilyChangeKey    @"fontFamily"
#define kLineSpacingChangeKey   @"lineSpacing"
#define kMarginChangeKey        @"margin"

#define kDayModeBGColor         @"#FFFFFF"
#define kSepiaModeBGColor       @"#FAF3E8"
#define kNightModeBGColor       @"#1A1A1A"

#define kDayModeLoaderColor     @"#131313"
#define kNightModeLoaderColor   @"#eaeaea"
#define kSepiaModeLoaderColor   @"#603E22"

#define kReaderThemeHeaderColor @"#F2F2F2"

#define kReaderThemeColor       @"#52AE78"

#define kGlossary               @"glossary"
#define kLoadPopup              @"loadpopup"
#define kHighlightTapped        @"highlight"
#define knoteTapped             @"note"
#define kSelectionStart         @"onselectionstart"
#define kSelectionChange        @"onselectionchange"
#define kMathLoad               @"mathload"
#define kClearSelection         @"onclearselection"
#define kWordClicked            @"wordclicked"

#define kDayModeYellowColor         @"#F4D631"
#define kDayModeRedColor            @"#f06666"
#define kDayModeIconSelectionColor  @"#000000"
#define kDayModeIconColor           @"#ffffff"
#define kDayModeBackgroundColor     @"#484848"

#define kNightModeYellowColor         @"#8fd5e1"
#define kNightModeRedColor            @"#a40509"
#define kNightModeIconSelectionColor  @"#6f6f6f"
#define kNightModeIconColor           @"#6f6f6f"
#define kNightModeBackgroundColor     @"#ebebeb"

#define kEndOfChapter       @"end of chapter"
#define kPreviousChapter    @"Previous Chapter"
#define kNextChapter        @"Next Chapter"

#define kHeaderFooterBackground                 @"#DFDFDF"
#define kHeaderFooterTextColorDayMode           @"#3163D1"
#define kHeaderFooterLabelBackgroundNightMode   @"#212121"

// MIME CONSTANT
#define kHTML                   @"html"
#define kHTM                    @"htm"
#define kXHTML                  @"xhtml"
#define kHTML_HTM_MIME_TYPE     @"text/html"
#define kXHTML_MIME_TYPE        @"application/xhtml+xml"
#define kUTF_8                  @"utf-8"


#define isIPAD                          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

typedef enum : short {
    DEFAULT_FONT    = 0,
    SMALL_FONT      = 1,
    MEDIUM_FONT     = 2,
    LARGE_FONT      = 3,
    X_LARGE_FONT    = 4,
    XX_LARGE_FONT   = 5

} FONT_SIZE;

/*!
 @brief  To Customize the appearance of a Page, such as text color and background color.
 
 @discussion
 With the help of Reader mode Feature user can change an appearance of Page to Day mode, Sepia mode or to night mode.
  
 @field - Day Mode
 
 Uses a colour scheme that displays dark text on a light background.
 
 @field - Sepia Mode
 
 Is a reddish brown monochrome tint. When applied to a Page, it gives the Page a warm, antique feeling.
 
 @field - Night Mode

 Uses a colour scheme that displays light text on a dark background.
 
 @field - Default Mode

 Uses a colour scheme that displays text and it's background defined in book package.
 */
typedef enum : short {
    /**Day mode uses a colour scheme that displays dark text on a light background.*/
    DAY_MODE    = 0,
    /**A sepia Mode is a reddish brown monochrome tint. When applied to a Page, it gives the Page a warm, antique feeling.*/
    SEPIA_MODE  = 1,
    /**Night Mode uses a colour scheme that displays light text on a dark background.*/
    NIGHT_MODE  = 2,
    /**Default Mode uses a colour scheme that displays text and it's background defined in book package.*/
    DEFAULT_MODE= 3

} READER_MODE;

/*!
 @brief  Text alignment is feature that allows users to  align text on a page.
 
 @discussion
 It enables the composition of a text document using different text positioning on the whole page.
 
 @field - Left Alignment
 
 This starts each new line of the document on the left-most margin.
 
 @field - Center Alignment
 
 This positions and starts each new line/text block in the center/middle margin on the page.
 
 @field - Right Alignment
 
 This starts each new line of the document on the right-most margin of the page.
 
 @field - Justify Alignment
 
 This aligns text with right and left margins and tries to fill as much empty space as possible. It enables a straight margin on both of the page's horizontal edges.
 
 @field - Default Alignment
 
 This aligns text as per the alignment used in book package.
 */
typedef enum : short
{
    /**This starts each new line of the document on the left-most margin.*/
    LEFT_ALIGNMENT      = 0,
    /**This positions and starts each new line/text block in the center/middle margin on the page.*/
    CENTER_ALIGNMENT    = 1,
    /**This starts each new line of the document on the right-most margin of the page.*/
    RIGHT_ALIGNMENT     = 2,
    /**This aligns text with right and left margins and tries to fill as much empty space as possible. It enables a straight margin on both of the page's horizontal edges.*/
    JUSTIFY_ALIGNMENT   = 3,
    /**This aligns text as per the alignment used in book package.*/
    DEFAULT_ALIGNMENT   = 4
    
} TEXT_ALIGNMENT;

/*!
@brief  Text linespacing is feature that allows users to maintain space between lines on a page.

@discussion
It enables the composition of a text document using different line spacing on the whole page.

@field - Default Linespacing

This maintains a space between lines as per book package details.
 
@field - Small Linespacing

This maintains a small space between lines.

@field - Medium Linespacing

This maintains a medium space between lines.

@field - Large Linespacing

This maintains a large space between lines.
*/
typedef enum : short
{
    DEFAULT_LINESPACING      = 0,
    SMALL_LINESPACING        = 1,
    MEDIUM_LINESPACING       = 2,
    LARGE_LINESPACING        = 3
} TEXT_LINESPACING;

/*!
@brief  Text margin is feature that allows users to maintain margin on a page.

@discussion
It enables the composition of a reader view document using different margin on the whole page.

@field - Default Margin

This maintains a default Margin on page.
 
@field - Small Margin

This maintains a small Margin on page.

@field - Medium Margin

This maintains a medium Margin on page.

@field - Large Margin

This maintains a large Margin on page.
*/
typedef enum : short
{
    DEFAULT_MARGIN      = 0,
    SMALL_MARGIN        = 1,
    MEDIUM_MARGIN       = 2,
    LARGE_MARGIN        = 3
} READER_MARGIN;


typedef enum : short {
    CURRENT_PAGE = 0,
    PREVIOUS_PAGE = 1,
    NEXT_PAGE = 2
} PageSequence;

typedef enum : short {

    SCROLL_NONE = 0,
    SCROLL_DOWN = 1,
    SCROLL_UP   = 2
    
} ScrollDirection;

typedef enum : short {
    
    YEllOW_COLOR = 0,
    RED_COLOR   = 1
    
} HighlightColor;



