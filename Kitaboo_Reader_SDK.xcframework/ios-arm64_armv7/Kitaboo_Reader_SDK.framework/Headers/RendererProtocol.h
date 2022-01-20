//
//  RendrerProtocol.h
//  KItabooSDK
//
//  Copyright © 2017 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HighlightActionView.h"
#import "BookMarkView.h"
#import "KitabooBookVO.h"
#import "HSRendrerConstant.h"
#import "TextSearchResult.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

/*!
 Orientation mode of a book, Whether it is Portrait or Landscape.
 */
typedef enum
{
    /** With this Mode, Book will support both orientations.*/
    kBookOrientationModeDynamic = 0,
    /** Book will launch in Landscape mode, with one page, this should be set for Landscape Lock book.*/
    kBookOrientationModeLandscapeOnePageOnly,
    /** Book will launch in Landscape mode, with two page, this should be set for Landscape Lock book.*/
    kBookOrientationModeLandscapeTwoPageOnly,
    /** Book will launch in Portrait mode, with single page, this should be set for Portait Lock book.*/
    kBookOrientationModePortrait
} BookOrientationMode;

/*!
 * @protocol RendererProtocol
 * @brief The Renderer Protocol provide methods to perform task/Actions in Renderer, The mothods in the Protocols are been implemented by Each Renderer (Epub and Kitaboo Fixed). Irrespectivly to the Book Type, the action will be perform. (However some menthod will only be support for either type)
 */
@protocol RendererProtocol
@optional

/*!
 To Open Highlight Popup on given page number.
 * @discussion This method is used to open Highlight Popup on given page number at the particular coordinates. And returns Boolen value, to know if highlight is shown or not. Highlight is shown for YES value and not shown for NO value.
 * @param1 highlightView Object of type HighlightActionView.
 * @param2 pageNo Page number of page.
 * @param3 coordinates Coordinates on the page where highlight view needs to be shown.
 * @code
 * [rendererViewController openHighlightView:highlightView OnPageNo:pageNo AtCoordinates:CGPointMake(x,y)];
 * @endcode
 * @return BOOL value
 */
-(BOOL)openHighlightView:(HighlightActionView*)highlightView OnPageNo:(NSInteger)pageNo AtCoordinates:(CGPoint)coordinates;

/*!
  To add Bookmark view on given page number.
 * @discussion This method is responsible for managing bookmark on the respective Page, Bookmark Detail is available in SDKBookmarkVO, which is link with each BookmarkView object, Object of SDKBookmarkVO behave as the data source of BookmarkView.
 * @param1 bookmarkView Object of type BookMarkView.
 * @param2 pageNo Page Number where bookmark view should be added.
 * @code
 * [rendererViewController addBookmarkView:bookMarkView onPageNO:pageNo];
 * @endcode
 */
- (void)addBookmarkView:(BookMarkView *)bookmarkView onPageNO:(NSInteger)pageNo;

/*!
 To Highlight Text with given text and background color.
 * @discussion This method is used to create highlight for particular HighlightActionView data source (ie Object of SDKHighlightVO)  with given text color and background color.  Object of SDKHighlightVO is an object for which text color and background color needs to updated. Parameter `isImportant` is a BOOL type which is used for important/normal highlight/note.
 
  - If this has YES value, Important highlight/note will be created with the background color which is provide in `backgroundColor` parameter . Else, with NO value normal highlight/note will be created with the same background color.
 * @param1 highlightView Object of HighlightActionView.
 * @param2 textColor Text color to be applied on highlight.
 * @param3 backgroundColor Background color to be applied on highlight.
 * @param4 isImportant A Type of BOOL.
 * @code
 * [rendererViewController highlight:highlightView WithTextColor:textColor WithBackgroundColor:backgroundColor WithIsImportant:NO];
 * @endcode
 */
-(void)highlight:(HighlightActionView*)highlightView WithTextColor:(NSString*)textColor WithBackgroundColor:(NSString*)backgroundColor WithIsImportant:(BOOL)isImportant;

/*!
 To get Highlight Object of type SDKHighlightVO.
 * @discussion Returns an Object of type SDKHighlightVO for selected text with given text color and background color.
 * @param1 textColor Text color to be applied on selected text.
 * @param2 backgroundColor Background color to be applied selected text.
 * @return Object of type SDKHighlightVO.
 * @code
 * [rendererViewController getHighlightForSelectedTextWithTextColor:textColor WithBackgroundColor:backgroundColor];
 * @endcode
 */
-(SDKHighlightVO*)getHighlightForSelectedTextWithTextColor:(NSString *)textColor WithBackgroundColor:(NSString *)backgroundColor;

/*!
To get Highlight Object of type SDKHighlightVO. This method is used only for Kitaboo epub books;
* @discussion Returns an Object of type SDKHighlightVO for selected text with given text color and background color.
* @param1 textColor Text color to be applied on selected text.
* @param2 backgroundColor Background color to be applied selected text.
* @code
* [rendererViewController getHighlightForSelectedTextWithTextColor:textColor WithBackgroundColor:backgroundColor     andCallBack:^(SDKHighlightVO *sdkHighlightVO){}];
* @endcode
*/
-(void)getHighlightForSelectedTextEpubWithTextColor:(NSString *)textColor WithBackgroundColor:(NSString *)backgroundColor andCallBack:(void (^)(SDKHighlightVO *))callback;

/*!
 TO get selected text.
 @discussion This method is used to get selected text on the Page.

 - NOTE : As of now, this method will only works for Kitaboo Fixed books(PDF).
 * @code
 * [rendererViewController getSelectedText];
 * @endcode
 */
-(NSString*)getSelectedText;

/*!
 To Show/Post Note on page.
 * @discussion Parameter `highlightVO` is an object of type SDKHighlightVO that need's to be shown/posted on page, `highlightVO` will have all the details about the note, Eg. Page Number, Text ,Text color, Background color etc.
 * @param1 highlightVO Object of type SDKHighlightVO.
 * @code
 * [rendererViewController postNoteWithHighlightVO:highlightVO];
 * @endcode
 */
-(void)postNoteWithHighlightVO:(SDKHighlightVO*)highlightVO;

/*!
 To Delete/Remove Note from page.
 * @discussion Parameter `highlightVO` is an object of type SDKHighlightVO that need's to be removed from the page, `highlightVO` will have all the details about the note, Eg. Page Number, Text ,Text color, Background color etc.
 * @param1 highlightVO Object of type SDKHighlightVO.
 * @code
 * [rendererViewController deleteNoteWithHighlightVO:highlightVO];
 * @endcode
 */
-(void)deleteNoteWithHighlightVO:(SDKHighlightVO*)highlightVO;

/*!
 To Remove Highlight Popup from renderer view.
 * @code
 * [rendererViewController removeHighlightView];
 * @endcode
 */
-(void)removeHighlightView;

/*!
 To Delete/Remove Highlight from page.
 * @discussion Parameter `highlight` is an object of type SDKHighlightVO that need's to be removed from the page, `highlight` will  have all the details about the highlight, Eg. Page No, Text ,Text color, Background color etc.
 * @param1 highlight Object of type SDKHighlightVO.
 * @code
 * [rendererViewController deleteSelectedHighlight:highlight];
 * @endcode
 */
- (void)deleteSelectedHighlight:(SDKHighlightVO *)highlight;

/*!
 To Navigate on given page.
 * @discussion This method is used for navigation on particular page. For Example in case of Table of Content, My Data etc. user can use this method.
 * @param1 pageNo Page number of page.
 * @code
 * [rendererViewController navigateToPageNumber:pageNumber];
 * @endcode
 */
-(void)navigateToPageNumber:(NSString *)pageNo;


/*!
 * This method used to enable/disable the pagination configuration for reflowable epub books.
 @discussion Pagination, is the process of dividing a document into discrete pages, where page navigation direction is either from left to right or vertical scrolling.
 
 -If parameter `enable` has YES value, page navigation direction will be left to right or in case of NO it will be vertical scrolling.
 
 @param1 enable Is the boolean value which represents the pagination configuration.
 @code
 [rendererViewController enablePagination:YES];
 @endcode
 */
-(void)enablePagination:(BOOL)enable;

/*!
 To get Pagination status.
 @return Returns Pagination status for Reflowable Epub Books.
 */
-(BOOL)isPaginationEnabled;

/*!
 To Enable Night Mode for Reflowable Epub Books.
 * @discussion Night Mode Uses a colour scheme that displays light text on a dark background.
 * @param1 enable Enable/Disable Night Mode.
 * @code
 * [rendererViewController enableNightMode:YES];
 * @endcode
 */
- (void)enableNightMode:(BOOL)enable;

/*!
 To Set Reader Mode for Reflowable Epub.
 * @discussion  With the help of Reader mode Enable Feature user can change an appearance of a Page to Day mode, Sepia mode, night mode or to Default mode.
 * @param1 mode Choose any Mode from Reader Mode.
 * @code
 * [rendererViewController setReaderMode:DAY_MODE];
 * @endcode
 */
-(void)setReaderMode:(READER_MODE)mode;

/*!
 To Set Text Alignment for Reflowable Epub books.
 * @discussion With the help of Text alignment Feature user can change alignment of text on a page using different text positioning.
 * @param1 textAlignment Choose any alignment from Left, Right, Center, Justify and Default.
 * @code
 * [rendererViewController setTextAlignment:LEFT_ALIGNMENT];
 * @endcode
 */
-(void)setTextAlignment:(TEXT_ALIGNMENT)textAlignment;

/*!
To Set Line Spacing for Reflowable Epub books.
* @discussion With the help of Line Spacing Feature user can change space between lines on a page using different line spacing.
* @param1 lineSpacing Choose any line spacing from Default, Small, Medium and Large.
* @code
* [rendererViewController setLineSpacing:MEDIUM_LINESPACING];
* @endcode
*/
-(void)setLineSpacing:(TEXT_LINESPACING)lineSpacing;

/*!
To Set Margin for Reflowable Epub books.
* @discussion With the help of Margin Feature user can change space between data and border on a page using different margin options.
* @param1 margin Choose any margin from Default, Small, Medium and Large.
* @code
* [rendererViewController setMargin:MEDIUM_MARGIN];
* @endcode
*/
-(void)setMargin:(READER_MARGIN)margin;

/*!
 To Reset Reader Settings for Reflowable Epub.
 * @discussion resetReaderSetting is a method, that would be called when user wants to reset all the customization of Epub reflowable books. It sets all the Modes to their default value.
 * @code
 * [rendererViewController resetReaderSetting];
 * @endcode
 */
-(void)resetReaderSetting;

/*!
 To Reset Reader Settings for Reflowable Epub.
 * @discussion resetReaderSetting is a method, that would be called when user wants to reset all the customization of Epub reflowable books. It sets all the Modes to their default value.
 * @code
 * [rendererViewController resetReaderFontSetting];
 * @endcode
 */
-(void)resetReaderFontSetting;

/*!
 *Set an array of font family for reflowable epub books.
 @discussion Array of String values.
 @code
 [rendererViewController setFontFamilyArray:[NSArray arrayWithObjects:@"Default",@"Open Sans",@"Georgia",@"Noto Serif",nil]];
 @endcode
 */
-(void)setFontFamily:(NSString *)fontFamily;

/*!
 * This method is used to set font size to text for whole Page of reflowable epub books.
 @param1 fontSize Is the value of changed font.
 @code
 [rendererViewController setFontSizeForReflowable:25];
 @endcode
 */
- (void)didFontSizeChanged:(NSUInteger)fontSize;

/*!
 * This method used to set brightness configuration for reflowable epub books
 @param1 brightnessValue Represents the  brightness configuration.
 @code
 [rendererViewController setCurrentBrightness:[UIScreen mainScreen].brightness];
 @endcode
 */
-(void)setBrightnessForReflowable:(CGFloat)brightnessValue;

/*!
 To get SDKBookmarkVO Object.
 * @discussion This method returns object of SDKBookmarkVO for given page number.
 * @param1 pageNo page number of page.
 * @return Object of Type SDKBookmarkVO.
 * @code
 * [rendererViewController getBookmarkVOForPageNo:pageNo];
 * @endcode
 */
-(SDKBookmarkVO*)getBookmarkVOForPageNo:(NSInteger)pageNo;

/*!
 TO set Bookmark.
 @discussion This method is used to set data/model to bookmark view. SDKBookmarkVO contains all the details about the bookmark. Eg. Text, Start Offset, End Offset etc.
 @param bookmarkVO Object of type SDKBookmarkVO.
 * @code
 * [rendererViewController setBookmarkVO:bookmarkVO];
 * @endcode
 */
-(void)setBookmarkVO:(SDKBookmarkVO*)bookmarkVO;

/*!
 To draw highlights on given Page number.
 * @discussion The method is used to draw highlights on given page number. Parameter `highlights` contains all the highlights of type SDKHighlightVO, which to be drawn on page.
 * @param1 highlights Array of type SDKHighlightVO Objects
 * @param2 pageNo page number of page.
 * @code
 * [rendererViewController drawHighlights:highlights OnPageNo:pageNo];
 * @endcode
 */
-(void)drawHighlights:(NSArray*)highlights OnPageNo:(NSInteger)pageNo;

/*!
 TO add Bookmark on given page.
 *@discussion This method is used to add data/model to bookmark view, Parameter `bookmarks` contains all the elements of type SDKBookmarkVO, that contains all the details about the bookmark. Eg. Text, Start Offset, End Offset etc.
 * @param bookmarks Array of type SDKBookmarkVO Objects.
 * @code
 * [rendererViewController addBookmark:bookmarks OnPageNo:pageNo];
 * @endcode
 */
-(void)addBookmark:(NSArray *)bookmarks OnPageNo:(NSInteger)pageNo;

/*!
 TO get the object of SDKHighlightVO for Sticky Note Touch Point.
 * @discussion Validate the Sticky note touch points and returns HighlightVO Object if note can be created on the touch points.
 * @param1 touchPoint Sticky Note touch point.
 * @return Object of type SDKHighlightVO.
 * @code
 * [rendererViewController getHighlightVOForStickyNoteTouchPoint:CGPoint(x,y)];
 * @endcode
 */
-(SDKHighlightVO*)getHighlightVOForStickyNoteTouchPoint:(CGPoint)touchPoint;

/*!
 * To enable drawing mode for renderer view.
 * @discussion This method permits user to perform drawing on any page based on parameter's value. If it is YES, user will be able to draw anything on Page and in case of NO this action will not be performed.
 
 - To draw anything on the canvas, simply call @c [rendererViewController drawPenDrawings:penToolArray OnPageNo:pageNo];
 
 - NOTE : This method is not used for Epub Reflowable Books.
 * @param1 enabled Enable the mode by passing boolean value
 * @code
 * [rendererViewController setPenDrawingModeEnabled:YES];
 * @endcode
 */
-(void)setPenDrawingModeEnabled:(BOOL)enabled;

/*!
 * To enable drag box mode for renderer view for teacher review.
 * @discussion This method permits user to select multiple fibs at once on any page based on parameter's value. If it is YES, user will be able to select fibs by draging the dotted box around the fibs on Page and in case of NO this action will not be performed.

 - NOTE : This method is not used for Epub Reflowable Books.
 * @param1 enabled Enable the mode by passing boolean value
 * @code
 * [rendererViewController setTeacherReviewDragBoxModeEnabled:YES];
 * @endcode
 */
-(void)setTeacherReviewDragBoxModeEnabled:(BOOL)enabled;

/*!
 * To enable drawing mode for Teacher Review.
 * @discussion This method permits user to perform drawing on any page based on parameter's value. If it is YES, user will be able to draw anything on Page and in case of NO pen drawing will not be performed and ReviewModeEnable YES this allowed user(Teacher) to interact with Markups.
 
 - NOTE : This method is not used for Epub Reflowable Books.
 * @param1 enabled Enable the mode by passing boolean value
 * @param2 reviewModeEnabled Enable the mode by passing boolean value
 * @code
 * [rendererViewController setPenDrawingModeEnabled:YES withReviewModeEnable:YES];
 * @endcode
 */

-(void)setPenDrawingModeEnabled:(BOOL)enabled withReviewModeEnable:(BOOL)reviewModeEnabled;

/*!
 * To get Pen Drawing Canvas for rendered pages, The value returned from this is used in Pen Tool Controller.
 * @return Array of Pen Drawing Canvas. (For Portait Mode, It would return one canvas and for landscape mode it will return 2 canvas)
 * @code
 * [rendererViewController getPenDrawingCanvas];
 * @endcode
 */
-(NSArray*)getPenDrawingCanvas;

/*!
 To draw pen drawings on canvas.
 * @discussion This method is used to draw anything on canvas. All the details related to the drawing will be contained in penToolArray objects, of type SDKPentoolVO.
 * @param1 penToolArray Array of SDKPentoolVO Object to be drawn on canvas
 * @param1 pageNo page number of canvas
 * @code
 * [rendererViewController drawPenDrawings:penToolArray OnPageNo:pageNo];
 * @endcode
 */
-(void)drawPenDrawings:(NSArray *)penToolArray OnPageNo:(NSInteger)pageNo;

/*!
 * To get currently rendered pages object.
 * @return Returns currently rendered page.( Type of KFPageVO for Fixed Kitaboo and EpubPage for Epub).
 * @code
 * [rendererViewController getActivePages];
 * @endcode
 */
-(NSArray*)getActivePages;

/*!
 *To Reload Active Page.
 *@discussion Call this method to reload the pages, This menthod can be used in any case, there reloading of pages is required
 - NOTE : This will only work for Kitaboo Fixed books.
 * @code
 * [rendererViewController reloadPages];
 * @endcode
 */
-(void)reloadPages;

/*!
 *To highlight Text on page.
 * @discussion This method is used to highlight particular text on given page with given color.
 * @param1 text Text to be highlighted
 * @param2 pageNo Page Number where text presents.
 * @param3 color Color of highlight.
 * @code
 * [rendererViewController highlightText:text OnPageNo:pageNo WithColor:color];
 * @endcode
 */
-(void)highlightText:(NSString*)text OnPageNo:(NSInteger)pageNo WithColor:(NSString*)color;

/*!
 *To highlight text on page
 * @param1 text Text to be highlighted
 * @param2 color Color of highlight
 * @param3 selectedWordColor Color of selected word
 * @param4 searchResultArray is the TextSearchResult array
 */
-(void)highlightText:(NSString*)text OnPageNo:(NSInteger)pageNo WithColor:(NSString*)color withSelectedWordHighlightColor:(NSString *)selectedWordColor withSearchArray:(NSArray *)searchResultArray withSelectedResult:(TextSearchResult *)searchResult;

/**
 Returns Next Search Result status for navigating
 */
-(BOOL)isNextSearchResultAvailable;

/**
 Returns Previous Search Result status for navigating
 */
- (BOOL)isPreviousSearchResultAvailable;

/**
 Returns Last Previous Search Result status of Page for navigating
 */
- (BOOL)isLastPreviousSearchResult;

/**
 Returns Last Next Search Result status of Page for navigating
 */
- (BOOL)isLastNextSearchResult;

/**
 * To move to next selected search
 */
- (void)moveToNextSelectedSearch;

/**
 * To move to previous selected search
 */
- (void)moveToPreviousSelectedSearch;

/**
 * Returns Next Search Result status for navigating
 */
- (BOOL)isNextSearchResultAvailableForSearchResult:(TextSearchResult*)searchResult;

/**
 * Returns Last Previous Search Result status of Page for navigating
 */
- (BOOL)isPreviousSearchResultAvailableForSearchResult:(TextSearchResult*)searchResult;

/**
 * To move to next selected search
 */
- (void)moveToNextSelectedSearchForSearchResult:(TextSearchResult*)searchResult;

/**
 * To move to previous selected search
 */
- (void)moveToPreviousSelectedSearchForSearchResult:(TextSearchResult*)searchResult;

/**
 *To highlight text on page
 * @param1 text Text to be highlighted
 * @param2 color Color of highlight
 * @param2 paragraph paragraph of highlight
 */
-(void)highlightText:(NSString*)text OnPageNo:(NSInteger)pageNo WithColor:(NSString*)color WithParagraph:(NSString*)paragraph;

/*!
 *To highlight text with frame on page.
 * @discussion This method is used to add highlight on given page number with highlight color adn given frame. Currently this is used for Audio Sync feature.
 * @param1 frame Frame to be highlighted on the page.
 * @param1 pageNo Page Number where text will be highlighted.
 * @param2 color Color of highlight.
 * @code
 * [rendererViewController highlightTextWithFrame:frame OnPageNo:pageNo WithColor:color];
 * @endcode
 */
-(void)highlightTextWithFrame:(CGRect)frame OnPageNo:(NSInteger)pageNo WithColor:(NSString*)color;

/*!
 *To highlight sentence with frames on page for same group id.
 * @discussion This method is used to add highlight on given page number with highlight color and given frames. Currently this is used for Audio Sync feature.
 * @param1 frames Frames to be highlighted on the page.
 * @param2 pageNo Page Number where sentence will be highlighted.
 * @param3 color Color of highlight.
 * @code
 * [rendererViewController highlightSentenceWithWordFrames:frames OnPageNo:pageNo WithColor:color];
 * @endcode
 */
-(void)highlightSentenceWithWordFrames:(NSArray*)frames OnPageNo:(NSInteger)pageNo WithColor:(NSString*)color;

/*!
 *To update the color of word & sentence highlight on page.
 * @discussion This method is used to update the highlight color for existing word & sentence. Currently this is used for Audio Sync feature.
 * @param1 color Color of highlight.
 * @code
 * [rendererViewController updateBackgroundForAudioSyncFramesWithColor:color];
 * @endcode
 */
-(void)updateBackgroundForAudioSyncFramesWithColor:(NSString*)color;
/*!
 To draw Markups on page
 * @param1 links Array of KFLinkVO Object to be drawn on page
 * @param1 pageNo page number of canvas
 */
-(void)drawMarkups:(NSArray *)links OnPageNo:(NSInteger)pageNo;

/*!
 To add Inline Video on page.
 * @discussion Inline video refers to a video that need to added on page at a specific position , Parameter `view` is used to add a view  for Inline Video Player on the page.
 * @param1 view Inline Video Player view to add on page.
 * @param2 frame Frame of Inline Video Player's view.
 * @param3 pageNo Page Number.
 * @code
 * [rendererViewController addInLineVideo:view atRect:frame onPageNO:pageNo];
 * @endcode
 */
- (void)addInLineVideo:(UIView *)view atRect:(CGRect)frame onPageNO:(NSInteger)pageNo;

/*!
 To add MultiLinkController on page.
 * @discussion This method is used to add/show MultiLinkController on given page number with respective to the position of given source view, multiLinkController is object of type UIViewController which will be added.
 * @param1 multiLinkController Object of type UIViewController.
 * @param2 sourceView To add MultiLinkController with respective Position of source View.
 * @param3 pageNo Page Number
 * @code
 * [rendererViewController addMultiLinkController:multiLinkController atSourceView:sourceView onPageNO:pageNo];
 * @endcode
 */
- (void)addMultiLinkController:(UIViewController *)multiLinkController atSourceView:(UIView*)sourceView onPageNO:(NSInteger)pageNo;

/*!
 To add Instruction mark up Popup on page.
 * @discussion This method is used to add/show Instruction Popup on given page number with respective to the position of given source view, instructionPopupController is object of type UIViewController which will be added.
 * @param1 instructionPopupController Object of type UIViewController.
 * @param2 sourceView To add Instruction mark up with respective Position of source View.
 * @param3 pageNo Page Number
 * @code
 * [rendererViewController addInstructionPopup:instructionPopupController atSourceView:sourceView onPageNO:pageNo];
 * @endcode
 */
-(void)addInstructionPopup:(UIViewController *)instructionPopupController atSourceView:(UIView*)sourceView onPageNO:(NSInteger)pageNo;

/*!
 To draw FIBs (Objects Of Type HDFIB) on page
 * @param1 fibs Array of FIB (Objects Of Type HDFIB) to be drawn on page
 * @param1 pageNo page number of canvas.
 * @code
 * [rendererViewController drawFIBs:fibs OnPageNo:pageNo];
 * @endcode
 */
-(void)drawFIBs:(NSArray *)fibs OnPageNo:(NSInteger)pageNo;

/*!
 To add review view on FIBs for teacher review on page.
 * @param1 fibVo View to be added on fib
 * @code
 * [rendererViewController addReviewViewOnFib:fibVo];
 * @endcode
 */
-(void)addReviewViewOnFib:(SDKFIBVO *)fibVo;

/*!
 To remove review view on FIBs for teacher review from page.
 * @param1 pageNo page number of canvas.
 * @code
 * [rendererViewController removeFibReviewViewOnPageNo:pageNo];
 * @endcode
 */
-(void)removeFibReviewViewOnPageNo:(NSInteger)pageNo;

/*!
 To Open Highlight Popup on given page number.
 * @discussion  This method is used to open Highlight Popup on given page number at the particular coordinates with Rect of highlighted text. And returns Boolen value, to know if highlight is shown or not. Highlight is shown for YES value and not shown for NO value.

 - Note: This will only work for Kitaboo Fixed type books.
 * @param1 pageNo Page number of page
 * @param2 coordinates Coordinates on the page where highlight view needs to be shown.
 * @param3 highlightedTextRect Coordinates of highlighted text.
 * @code
 * [rendererViewController openHighlightView:highlightView OnPageNo:pageNo AtCoordinates:CGPointMake(x,y) WithHighlightedTextRect:CGPointMake(x,y)];
 * @endcode
 */
-(BOOL)openHighlightView:(HighlightActionView*)highlightView OnPageNo:(NSInteger)pageNo AtCoordinates:(CGPoint)coordinates WithHighlightedTextRect:(CGPoint)highlightedTextRect;

/*!
 To set the color for shared Highlight/Notes.
 * @discussion This method is used to set color to that Highlight or note, which is shared to any user. If the hexColor is nil then the default color ugc will be applied.
 * @param1 hexColor is hex color for shared Highlight/Notes.
 * @code
 * [rendererViewController setColorForSharedUGC:hexColor];
 * @endcode
 */
- (void)setColorForSharedUGC:(NSString *)hexColor;

/*!
 * To set Book Orientation Mode, whether it is Portrait or Landscape.
 * @param bookOrientation Orientation Mode.
 * @code
 * [rendererViewController setBookOrientationMode:bookOrientation];
 * @endcode
 */
- (void)setBookOrientationMode:(BookOrientationMode)bookOrientation;

/*!
 * To get Book Orientation Mode.
 * @return Book Orientation Mode.
 * @code
 * [rendererViewController getBookOrientationMode];
 * @endcode
 */
- (BookOrientationMode)getBookOrientationMode;

/*!
 * To get SDKHighlightVO Object for StickyNote with Default Position (Center of Page in case of Landscape Left Page/or Portait Mode, and Center Left Position in case of Landscape mode right mode).
 * @return Returns Object of type SDKHighlightVO.
 * @code
 * [rendererViewController getHighlightVOForStickyNoteWithDefaultPosition];
 * @endcode
 */
-(SDKHighlightVO*)getHighlightVOForStickyNoteWithDefaultPosition;

/*!
* To get SDKHighlightVO Object for StickyNote with Default Position (Center of Page in case of Landscape Left Page/or Portait Mode, and Center Left Position in case of Landscape mode right mode). This method is used only for Kitaboo epub fixed books.
* @code
* [rendererViewController getHighlightVOForStickyNoteWithDefaultPositionWithCallBack^(SDKHighlightVO * result, NSError *    error){}];
* @endcode
*/
- (void)getHighlightVOForStickyNoteWithDefaultPositionWithCallBack:(void (^)(SDKHighlightVO *, NSError *error))callback;

/*!
 * To get TextAnnotationVO Object with Default Position.
 * @return Returns Object of type SDKTextAnnotationVO.
 * @code
 * [rendererViewController getTextAnnotationVOWithDefaultPosition];
 * @endcode
 */
-(SDKTextAnnotationVO*)getTextAnnotationVOWithDefaultPosition;

/*!
 * To draw TextAnnotations on page.
 * @discussion The method is used to draw TextAnnotations on given page number. First Parameter contains all the text annotation of type SDKTextAnnotationVO, which to be drawn on page.
 * @param1 textAnnotation Array of SDKTextAnnotationVO Objects.
 * @param2 pageNo page number of canvas.
 * @code
 * [rendererViewController drawTextAnnotation:textAnnotations OnPageNo:pageNo];
 * @endcode
 */
-(void)drawTextAnnotation:(NSArray*)textAnnotation OnPageNo:(NSInteger)pageNo;

/*!
 * To add new created TextAnnotation.
 * @discussion This method is used to add newly created text annotation. SDKTextAnnotationVO object has all the details about the text annotation eg. Text, Font Name, Font Size, Meta Data etc.
 * @param1 sdkTextAnnotationVO object of newly created SDKTextAnnotationVO
 * @code
 * [rendererViewController addTextAnnotation:sdkTextAnnotationVO];
 * @endcode
 */
-(void)addTextAnnotation:(SDKTextAnnotationVO*)sdkTextAnnotationVO;

/*!
 * To exit textAnnotation mode.
 * @code
 * [rendererViewController exitTextAnnotationMode];
 * @endcode
 */
-(void)exitTextAnnotationMode;

/*!
 * To delete text annotation.
 * @code
 * [rendererViewController deleteTextAnnotation];
 * @endcode
 */
- (void)deleteTextAnnotation;

/*!
 * To remove the text annotation without saving.
 * @code
 * [rendererViewController removeTextAnnotationModeWithoutSave];
 * @endcode
*/
- (void)removeTextAnnotationModeWithoutSave;

/*!
 * To update the alignment of the text in the text annotation.
 * @param1 alignment object to set alignment of the text in the text annotation
 * @code
 * [rendererViewController updateTextAnnotationAlignment:NSTextAlignmentLeft];
 * @endcode
*/
- (void)updateTextAnnotationAlignment:(NSTextAlignment)alignment;

/*!
 * To update the text color of the text and the background color of the text annotation.
 * @param1 background object to update the background color of the text annotation.
 * @param2 textColor object to update the text color of the text annotation
 * @code
 * [rendererViewController updateTextAnnotationWithBackground:[UIColor blackColor] withTextColor:[UIColor whiteColor]];
 * @endcode
*/
- (void)updateTextAnnotationWithBackground:(UIColor *)background withTextColor:(UIColor *)textColor;

/*!
 * To set the Vertical margin For Reflowable Epub Books
 * @discussion This method is used to set Vertical margin For Reflowable Epub Books i.e,top and bottom.
 * @param1 marginValue Object is the integer value to be set.
 * @code
 * [rendererViewController setVerticalMarginForReflowableEpubBook:0];
 * @endcode
 */
- (void)setVerticalMarginForReflowableEpubBook:(NSNumber *)marginValue;

/*!
 * This method is used to set Zoom Scale to Default.
 * @code
 * [rendererViewController resetZoomScaleToDefault];
 * @endcode
 */
-(void)resetZoomScaleToDefault;

/*!
 * To draw protractor drawings on canvas.
 * @discussion This method is used to draw protractor on canvas. All the details related to the drawing will be contained in protractorArray objects, of type SDKProtractorVO.
 * @param1 protractorArray Array of SDKProtractorVO Object to be drawn on canvas
 * @param2 pageNo page number of canvas
 * @code
 * [rendererViewController drawProtractorDrawings:protractorArray OnPageNo:pageNo];
 * @endcode
 */

-(void)drawProtractorDrawings:(NSArray *)protractorArray OnPageNo:(NSInteger)pageNo;
/*!
 * To get the FIBView for linkID.
 * @param1 linkID linkID of FIBView.
 * @return FIBView.
 * @code
 * [rendererViewController getFIBViewForLinkId:linkID];
 * @endcode
 */
-(UIView*)getFIBViewForLinkId:(NSInteger)linkID;

/*!
 * To add Print page view on given page number.
 * @discussion This method is responsible for managing PrintView on the respective Page.
 * @param1 printPageView Object of type PrintPageView.
 * @param2 pageNo Page Number where PrintPage view should be added.
 * @code
 * [rendererView addPrintPageView:printPageView onPageNO:pageNo];
 * @endcode
 */
- (void)addPrintPageView:(PrintPageButton*)printPageView onPageNO:(NSInteger)pageNo;

/*!
 * To get the Page Image for Page Number.
 * @param1 pageNo Page Number of page.
 * @return Image of Page.
 * @code
 * [rendererView getPageImageToPrintForPageNumber:pageNo];
 * @endcode
 */
-(UIImage*)getPageImageToPrintForPageNumber:(NSInteger)pageNo;

/*!
 * To get the print Pages for Page Numbers with a watermark text on it.
 * @param1 watermarkText text to be added on page to print.
 * @param2 textColor Watermark text color.
 * @param3 pageNumbers Page Number of page.
 * @code
 * [rendererView printPagesWithWatermark:WithTextColor:ForPageNumbers:WithCallback:(id *printPage){}];
 * @endcode
 */
-(void)printPagesWithWatermark:(NSString*)watermarkText WithTextColor:(NSString*)textColor ForPageNumbers:(NSArray*)pageNumbers WithCallback:(void (^)(id))callback;

/*!
 * To configure the view with current settings by exiting the print mode.
 * @code
 * [rendererView exitPrintMode];
 * @endcode
 */
-(void)exitPrintMode;
/*!
 * To add WaterMark  on  page.
 * @discussion This method is responsible for adding  WaterMark on the respective Page.
 * @param1 watermarkHolderView Object of type WatermarkHolderView.
 * @param2 pageNo Page Number where  WaterMark  should be added.
 * @code
 * [rendererView addWaterMark:waterMark onPageNumber:pageNo];
 * @endcode
*/
-(void)addWatermark:(WatermarkHolderView*)watermarkHolderView onPageNumber:(NSInteger)pageNo;
-(void)updateUGC:(NSArray*)UGCs OnPageNo:(NSInteger)pageNo;
- (void)disableTwoPageSeperation:(BOOL)disableSeperation;
/*!
 TO get selected text for Epub books.
 @discussion This method is used to get selected text on the Page.

 - NOTE : This method will only works for Epub Books.
 * @code
 *[epubRenderer getSelectedTextForEpub:^(NSString *text)];
 * @endcode
 */
-(void)getSelectedTextForEpub:(void (^)(NSString *))callback;

/*!
 To enable teacher review mode.
 @discussion This method is used to enable the teacher review mode with student submitted page array.

 - NOTE : This method will only works for PDF Books.
 * @code
 *[epubRenderer enableTeacherReviewModeWithPageArray:pageArray];
 * @endcode
 */
- (void)enableTeacherReviewModeWithPageArray:(NSArray *)pageArray;

/*!
 To disable teacher review mode.
 @discussion This method is used to disable the teacher review mode.

 - NOTE : This method will only works for PDF Books.
 * @code
 *[epubRenderer disableTeacherReviewMode];
 * @endcode
 */
- (void)disableTeacherReviewMode;
@end

