//
//  RendererViewController
//  KItabooSDK
//
//  Copyright © 2017 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RendererProtocol.h"
#import "UGCLabel.h"
#import "MarkupHitAreaLabel.h"
#import "EPUBBookVO.h"
#import "HDFIB.h"
#import "EPUBBookVO.h"
@class RendererViewController;
/*!
 The type of Book.
 @discussion With the help of Asset Type user can get the type of any book, whether PDF, FixedEpub or ReflowableEpub.
 
 @field - PDF Book
 
 A book which is a type of PDF.
 
 @field - Fixed Epub Book
 
 Fixed Epub Book presentation is a type of EPUB content.
 
 @field - Reflowable Epub Book
 
 A reflowable Book is a type of EPUB that can adapt its presentation according to the output device. It is not like PDF, because pages are resizable in reflowable books.
 
 @field - Undefined Type Book
 
 A book which type is not idenfified. The book with Undefined type, won't be rendered and will through a exception.
*/
typedef enum
{
    /** A book which type is not idenfified. The book with Undefined type, won't be rendered and will through a exception.*/
    KAssetTypeUndefined = 0,
    /** A book which is a type of PDF.*/
    kAssetTypePDF,
    /** Fixed Epub Book presentation is a type of EPUB content*/
    kAssetTypeFixedEpub,
    /** A reflowable Book is a type of EPUB that can adapt its presentation according to the output device. It is not like PDF, because pages are resizable in reflowable books.*/
    kAssetTypeReflowableEpub
}AssetType;

typedef enum
{
    /** Renderer is about to load (ie. When user navigate the pages/ or When user launch the book) and not completly Available for Action.*/
    RendererAvailabilityForActionStateBegin = 0,
    
    /** Renderer is loaded completely and Available for Action.*/
    RendererAvailabilityForActionStateComplete=1
}RendererAvailabilityForActionState;
/*!
 * @protocol RendererViewControllerDelegate
 * @brief The delegate of a RendererViewController object must adopt the RendererViewControllerDelegate protocol.
 * @discussion RendererViewControllerDelegate Protocol used to handle all the callbacks of RendererViewController Class.The RendererViewControllerDelegate protocol defines methods that allow user to manage the selection,highlighting,page loading, zoom IN/OUT and all action/events that are directly related to rendering of book(KitabooFixed, Epub). All the methods of this protocol are optional.
 
 *  When configuring the renderer view object, assign your delegate object to its delegate property.
 */
@protocol RendererViewControllerDelegate<NSObject>
@optional
/*!
 *  Will be called every time when page is about to load (ie. When user navigate the pages/ or When user launch the book)
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 number The Page number which will be loaded.
 * @param3 displayNum The number which will be displayed, Eg I,II,III.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController willLoadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum;

/*!
 *  Will be called every time when page is about to unloaded.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 number The loaded Page Number which will be unloaded.
 * @param3 displayNum The number, Eg I,II,III.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController willUnloadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum;

/*!
 *  Will be called every time when page is loaded (ie. When user navigate the pages/ or When user launch the book)
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 number The loaded Page Number.
 * @param3 displayNum The number, Eg I,II,III.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didLoadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum;
/*!
 *  Will be called when page loading is failed
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 number The Page number for which Page loading failed.
 * @param3 error The NSError object when Page loading failed.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didPageLoadingFailedForPageNumber:(NSNumber*)number WithError:(NSError*)error;

/*!
 *  Will be called when book loading is failed.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 error The NSError object when Book loading failed.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didBookLoadingFailedWithError:(NSError*)error;

/*!
 *  Will be called when book is loaded successfully.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 bookVO book Object of KitabooBookVO class.
 * @discussion Here User gets loaded book instance which is bookVO. The method permits user to perform all the actions which can be done after loading of the book such as, save the book instance in database or implementation of all reflowable customization if bookVO is type of Epub reflowable books. If this method is not implemented user can not get the book instance.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didBookLoadedSuccessfullyWithBook:(KitabooBookVO*)bookVO;

/*!
 *  Will be called when page/chapter is scrolled.
 * @param1 pageNumber The Page number which will be loaded.
 * @discussion If book is type of Epub reflowable books, Only then this method will be called.
 */
-(void)didPageBeginScroll:(NSNumber *)pageNumber;

/*!
 *  Will be called when page/chapter is scrolled.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 pageNumber The Page number which will be loaded.
 * @discussion If book is type of Epub reflowable books, Only then this method will be called.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didPageBeginScroll:(NSNumber *)pageNumber;

/*!
 *  Will be called when the page is Zoom In.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 pageNumbers Array of Loaded Page.
 * @discussion - If Zooming is performed in portrait mode pageNumbers Array will have one page.
 
 - In landscape mode pageNumbers Array will have two pages.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didZoomInPage:(NSArray*)pageNumbers;

/*!
 *  Will be called when the page is Zoom Out.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 pageNumbers Array of Loaded Pages.
 * @discussion - If Zooming is performed in portrait mode pageNumbers Array will have one page.
 
 - In landscape mode pageNumbers Array will have two pages.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didZoomOutPage:(NSArray*)pageNumbers;

/*!
 *  Will be called when single tap is performed on page.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 pageNumber The Tapped Page Number.
 * @discussion The method permits user to perform all the actions which can be done on single tap. If this method is not implemented user can not perform action on signle tap.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didSingleTapOnPage:(NSNumber*)pageNumber;


/*!
 * Will be called before the Pages are displayed.
 * @return the Display number that need to be shown.
 * @param1 rendererViewController Object of RendererViewController class.
 * @discussion  If this method is not implemented, Book will be launched with First Page.
 */
-(NSString*)initialDisplayNumber:(RendererViewController*)rendererViewController;

/*!
 *  Will be called when the user highlight text on the Page.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 highlightSelectionRect Type of CGRect for Highlighted text.
 * @param3 pageNo  Is the page number where user highlighted the text.
 * @discussion This method can be used to open HighlightActionView and user can change highlight color etc.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didHighlightTextWithHighlightSelectionRect:(CGRect)highlightSelectionRect OnPageNo:(NSInteger)pageNo;

/*!
 *  Will be called when user completed the highlight on the particular Page.
 * @param1 highlightVO Object of SDKHighlightVO class.
 * @discussion Use this method to save the highlight after completion. Highlight can be updated or Deleted based on the state of SDKHighlightVO object.
 */
-(void)didHighlighCompleteWithHighlight:(SDKHighlightVO*)highlightVO;

/*!
 *  Will be called when the user tap on note.
 * @param1 highlightVO Object of SDKHighlightVO class.
 * @discussion All the Actions after tapping on any note icon take place here.(eg. After tapping on note icon user can show note controller for particular note and save or share the note controller's data.)
 */
-(void)didTapOnNoteHighligh:(SDKHighlightVO*)highlightVO;

/*!
 *  Will be called when the user tap on teacher review comment note.
 * @param1 fibArray Object of NSArray class contains selected fib array.
 * @discussion All the Actions after tapping on any teacher review comment note icon take place here.(eg. After tapping on note icon user can show note controller for particular note and save the note controller's data.)
 */
-(void)didTapOnTeacherComment:(NSArray*)fibArray;

/*!
 *  Will be called when the user tap on teacher review instant Feedback button.
 * @param1 fibView Object of HDFIB class contains selected fib view.
 * @discussion All the Actions after tapping on any teacher review instant feedback icon take place here.(eg. After tapping on icon user can show the correct answer for the submitted fib.)
 */
-(void)didTapOnInstantFeedBack:(UIView*)fibView;

/*!
 * Returns the Note icon view associated to SDKHighlightVO instance.
 * @param1 highlightVO Object of SDKHighlightVO class to create Note icon view.
 * @return The Note icon view associated with the highlight.
 * @discussion All the customization related to note highlight icon can be performed here.(eg. If SDKHighlightVO instance is a type of Sticky note, sticky note will be added else Contextual note will be added.)
 */
-(UGCLabel*)noteIconViewForHighlight:(SDKHighlightVO*)highlightVO;

/*!
 *  Will be called when the teacher review any fib with correct incorrect button.
 * @param1 fibArray Object of NSArray class contains selected fib array.
 * @discussion All the Actions after tapping on any fib teacher review action take place here.(eg. After tapping on correct/incorrect icon user can update with answer status for particular fib and save the fib controller's data.)
 */
-(void)didUpdateFibArray:(NSArray*)fibArray;

/*!
 *  Will be called when Text Annotation is completed.
 *  @discussion This method is called when any action related to text annotation either Adding a text annotation, Editing or Deleting a text annotation  is completed. And also use this callback to save text annotation changes.
 *  @param1 textAnnotationVO Object of SDKTextAnnotationVO
 */
-(void)didTextAnnotationCompleteWithTextAnnotation:(SDKTextAnnotationVO*)textAnnotationVO WithNewSDKTextAnnotationVO:(SDKTextAnnotationVO*)newSDKTextAnnotationVO;

/*!
 * Tells the delegate that editing began in the Text Annotation.
 * @discussion This method notifies the delegate that the specified Text Annotation just became the first responder. Use this method to perform other tasks. For example, you might use this method to show overlay views that are visible only while editing.
 */
-(void)didTextAnnotationBeginEditing:(UITextView *)textView;

/*!
 * Asks the delegate if editing should begin in the specified text annotation.
 * @discussion The text annotation calls this method when the user performs an action that would normally initiate the editing of the text annotation’s text. Implement this method if you want to prevent editing from happening in some situations. For example, you could use this method to prevent the user from editing the text annotation’s contents more than once. Most of the time, you should return YES to allow editing to proceed.
 
  - If you do not implement this method, the text annotation acts as if this method had returned YES.
 * @return YES if editing should begin or NO if it should not.
 */
-(BOOL)textAnnotationShouldBeginEditing;

/*!
 * This method will be called when the text in the text annotation is updated/changed
 * @param1 textView UITextView object in which the value has been updated.
 */
-(void)didTextAnnotationValueChanged:(UITextView *)textView;

/*!
 * This will return the color of selection when user selects any text.
 * @return object of UIColor which is selected.
 */
-(UIColor*)colorForTextSelectionView;

/*!
 * Will be called when highlight selection is changed.
 */
- (void)didChangeHighlightSelection;

/*!
 * This method is used to check whether sticky note allowes two Page Panning or Not.
 * @discussion When the user performs an action on Sticky Note that would normally initiate a Panning session, the Page Controller calls this method to see if Panning should actually proceed for Two Pages.
 
  - Implementation of this method by the delegate is optional. If it is not present, Panning proceeds for Single Page.
*/
-(BOOL)didStickyNoteAllowedTwoPagePanning;
/*!
 * This method is used to set Zoom scale Percentage for current Book Pages.
 * @discussion To set zoom scale percentage for book pages. Zoom Scale Percentage Must be less than or equal to 1000.
 
 - NOTE : This method will only works for Kitaboo Fixed books(PDF).
 
 - Implementation of this method by the delegate is optional. If it is not present, Default Zoom scale percentage is 400.
 */

-(double)zoomScalePercentageForBook:(KitabooBookVO*)bookVO;

/*!
 *  Will be called when the user taken action to delete ProtractorDrawing.
 * @discussion All the Actions after user confirm to delete any protractorDrawing take place here.
 * @param1 protractorVO Object of SDKProtractorVO class.
 */
-(void)deleteProtractorWithProtractorVO:(SDKProtractorVO*)protractorVO;

/*!
 *  Will be called when the user select ProtractorDrawing.
 * @discussion All the Actions after user select protractorDrawing take place here.
 * @param1 protractorVO Object of SDKProtractorVO class.
 */
-(void)didSelectProtractorWithProtractorVO:(SDKProtractorVO*)protractorVO;
/*!
 *  Will be called every time when page is about to load (ie. When user navigate the pages/ or When user launch the book)
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 state The RendererAvailabilityForActionState Begin or Complete.
 * @param3 number The Page number which will be loaded.
 * @param4 displayNum The number which will be displayed, Eg I,II,III.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didRendererChangedAvailabilityForActionState:(RendererAvailabilityForActionState)state forPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum;

/**
 *  Will be called every time when book loading completed with content size.
 * @param1 contentSize Total content size of book
 */
-(void)bookLoadingCompletedWithContentSize:(NSInteger)contentSize;

-(void)bookCFIsLoadingCompleted:(NSInteger)TotalNumberOfCFIs;

/**
 *  Will be called every time when every Chapter is processed.
 * @param1 chaptersIndex Current chapter index.
 * @param2 contentSize Current chapter content size.
 * @param43 coverPage Is Cover Image.
 */
-(void)didBookChaptersProcessSuccessfully:(NSInteger)chaptersIndex withChapterContentSize:(NSInteger)contentSize isCoverPage:(BOOL)coverPage;

/**
 * Will be called every time when page is scrolled for reflowable books.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 contentOffset Current chapter content Offset.
 * @param3 chapterIndex Current chapter index.
 * @param4 contentSize Current chapter content Size.
 * @param5 coverPage Is Cover Image.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didChangeContentPosition:(CGFloat)contentOffset forChapter:(NSInteger)chapterIndex withContentSize:(CGFloat)contentSize isCoverPage:(BOOL)coverPage;

/**
 * Will be called every time when page is scrolled for reflowable books.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 pageNumber Current Paget.
 * @param3 chapterIndex Current chapter index.
 * @param4 totalChapterPages total Pages in Chapter.
 * @param5 totalBookPages total Pages in Book.
 * @param6 coverPage Is Cover Image.
 */
-(void)rendererViewController:(RendererViewController*)rendererViewController didChangeReflowableBookPage:(NSString *)pageNumber forChapter:(NSInteger)chapterIndex withTotalPagesInChapter:(NSString *)totalChapterPages withTotalPagesInBook:(NSString *)totalBookPages isCoverPage:(BOOL)coverPage;

/*!
 *  Will be called every time when CFI's is about to load (ie. When user navigate the pages/ or When user launch the book)
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 cfiArray collection of CFI's.
 * @param3 number The Page number for which CFI's will be loaded.
 * @param4 displayNum The number which will be displayed, Eg I,II,III.
*/
-(void)rendererViewController:(RendererViewController*)rendererViewController willLoadCFI:(NSArray*)cfiArray withPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum;
/*!
 *  Will be called every time when CFI's is about to unloaded.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 cfiArray collection of CFI's.
 * @param3 number The Page Number for which CFI's will be unloaded.
 * @param4 displayNum The number, Eg I,II,III.
*/
-(void)rendererViewController:(RendererViewController*)rendererViewController willUnloadCFI:(NSArray*)cfiArray withPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum;

-(void)rendererViewController:(RendererViewController*)rendererViewController didChangeBookCFI:(NSString *)bookCFI WithPositionIdentifier:(NSString *)positionIdentifier WithPageNumber:(NSNumber*)pageNumber;


/// Will be called when Page/CFI position is changed.
/// @param pageOrCFI New Page/CFI.
- (void)didChangePageIdentifier:(NSString *)pageOrCFI;

/*!
 *  Will be called every time when further visited page updated.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 furthestPageData Furthser visited page.
*/
- (void)rendererViewController:(RendererViewController*)rendererViewController didUpdateFurthestPage:(NSString *)furthestPageData;

/// Will be called when EpubElementModal popup get opened
-(void)didOpenEpubElementModal;

/// Will be called when EpubElementModal popup get closed.
-(void)didCloseEpubElementModal;

/*!
 *  Will be called when bookmark is updated(create new, delete/update existing).
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 bookmarkVO Object of SDKBookmarkVO class.
 * @param3 updatedBookmarkVO Object of SDKBookmarkVO class for updated bookmark.
 * @discussion If book is type of Epub reflowable books, Only then this method will be called.
*/
- (void)rendererViewController:(RendererViewController*)rendererViewController didUpdateBookmarkVOFrom:(SDKBookmarkVO*)bookmarkVO To:(SDKBookmarkVO*)updatedBookmarkVO;

/*!
 *  Will be called when the epub content end scrolling.
 * @param1 rendererViewController Object of RendererViewController class.
 * @param2 offset CGPoint for current offset of page.
 * @param3 pageNumber The Page Number for which the epub chapter ended it's scrolling.
 * @discussion If book is type of Epub reflowable books, Only then this method will be called.
*/
- (void)rendererViewController:(RendererViewController*)rendererViewController didEndScrollingWithContentOffset:(CGPoint)offset WithPageNumber:(NSNumber *)pageNumber;

/*!
* Will be called when user taps on any word for epub book.
* @param1 rendererViewController Object of RendererViewController class.
* @param2 wordId Word id for the tapped word.
* @param3 wordText Word inner text for the tapped word.
*/
- (void)rendererViewController:(RendererViewController*)rendererViewController didTapOnWordWithWordId:(NSString *)wordId WithWordText:(NSString*)wordText;

/*!
* Will be called when user taps on any resource markup for epub book.
* @param1 rendererViewController Object of RendererViewController class.
* @param2 resource of EPUBResource object for the tapped resource.
*/
- (void)rendererViewController:(RendererViewController*)rendererViewController didTapOnResource:(EPUBResource *)resource;

/*!
* Will be called when first word of viewport is changed for audio sync supported reflowable epub book.
* @param1 rendererViewController Object of RendererViewController class.
* @param2 wordDictionary First Word id and text of type NSDictionary.
*/
- (void)rendererViewController:(RendererViewController*)rendererViewController didChangeFirstVisibleWordWithWord:(NSDictionary *)wordDictionary;
/*!
 *  Will be called when the user tap on markups hit area.
 * @discussion All the Actions after user tap on markup hit area  take place here.
 * @param1 markupHitAreaLabel Object of MarkupHitAreaLabel class.
 */
- (void)didTapOnMarkupHitArea:(MarkupHitAreaLabel *)markupHitAreaLabel;
- (NSString *)fontNameForBook:(KitabooBookVO*)book;
-(NSString*)fontFilePathForBook:(KitabooBookVO*)book;

/*!
* Will be called when the search data decryption completed successfully.
* @param1 rendererViewController Object of RendererViewController class.
* @param2 bookPath book path of current book.
*/
-(void)rendererViewController:(RendererViewController*)rendererViewController didCompleteSearchDecryptionForBookPath:(NSString*)bookPath;

/*!
 * Will be called before the Pages are displayed.
 * @return the ReaderFontSetting - font settings to apply on reader page.
 * @param1 rendererViewController Object of RendererViewController class.
 * @discussion  If this method is not implemented, Book will be launched with the user default settings.
 */
-(ReaderFontSetting *)getReaderFontSetting:(RendererViewController *)rendererViewController;

/*!
 * Will be called before the Chapter loading starts for first time..
 * @return the MiliSeconds - to wait per 500 CFI to be loaded.
 * @discussion  If this method is not implemented, chapter will be loaded without any delay..
 */
- (CGFloat)shouldWaitForChapterLoadForCFIPerMiliSeconds;

@end

/** An Object that will be responsible for rendering a book.
 * @superclass SuperClass : UIViewController
 */
@interface RendererViewController : UIViewController <RendererProtocol>

/*!
 *The object that acts as the delegate of the renderer view.
 *@code
 *[rendererViewController setDelegate:self];
 *@endcode
 *@discussion The delegate must adopt the RendererViewControllerDelegate protocol.
 */
@property (weak,nonatomic) id <RendererViewControllerDelegate> delegate;

/*!
 * Boolean property used to enable/disable highlighting when users long press on text. By default it is set to true.
 * @code
 * rendererViewController.isHihghlightEnabled = false;
 * @endcode
 */
@property (nonatomic) BOOL isHihghlightEnabled;

/*!
 TO Initialte/Launch book
 * @param1 bookPath Device Physical path of book
 * @param2 assetType Type of book kAssetTypePDF/kAssetTypeFixedEpub/kAssetTypeReflowableEpub
 * @param3 delegate Callback listener of type RendererViewControllerDelegate
 * @discussion Initializes and returns a newly allocated view object with specified book path, Asset Type and delegate of type RendererViewControllerDelegate.
 * @code
 * [[RendererViewController aloc] initWithBookPath:bookPath WithBookType:assetType WithDelegate:self];
 * @endcode
 */
- (id)initWithBookPath:(NSString*)bookPath WithBookType:(AssetType)assetType WithDelegate:(id<RendererViewControllerDelegate>)delegate;

/*!
 * To Initialte/Launch book
 * @param1 bookPath Device Physical path of book
 * @param2 delegate Callback listener of type RendererViewControllerDelegate.
 * @discussion Initializes and returns a newly allocated view object with specified book path and delegate of type RendererViewControllerDelegate.
 * @code
 * [[RendererViewController aloc] initWithBookPath:bookPath WithDelegate:self];
 * @endcode
 */
- (id)initWithBookPath:(NSString*)bookPath WithDelegate:(id<RendererViewControllerDelegate>)delegate;

/*!
 * To Initialte/Launch book
 * @param1 bookPath Device Physical path of book
 * @param2 delegate Callback listener of type RendererViewControllerDelegate.
 * @param3 isbn ISBN value of the book
 * @discussion Initializes and returns a newly allocated view object with specified book path and delegate of type RendererViewControllerDelegate.
 * @code
 * [[RendererViewController aloc] initWithBookPath:bookPath WithDelegate:self withISBN:isbn];
 * @endcode
 */
- (id)initWithBookPath:(NSString*)bookPath WithDelegate:(id<RendererViewControllerDelegate>)delegate withISBN:(NSString *)isbn;

/*!
* To Initialte/Launch book
* @param1 bookPath Device Physical path of book
* @param2 delegate Callback listener of type RendererViewControllerDelegate.
* @param3 isbn ISBN value of the book
* @param4 additionalInfo Additional information if any.
* @discussion Initializes and returns a newly allocated view object with specified book path and delegate of type RendererViewControllerDelegate.
* @code
 * [[RendererViewController aloc] initWithBookPath:bookPath WithDelegate:self withISBN:isbn withAdditionalInfo:additionalInfo];
* @endcode
*/
- (id)initWithBookPath:(NSString *)bookPath withDelegate:(id<RendererViewControllerDelegate>)delegate withISBN:(NSString *)isbn withAdditionalInfo:(NSDictionary *)additionalInfo;

/*!
 *To Enable/Disable Logs.
 *@param1 logEnabled Enable/Disable Logs.
 *@discussion - If logEnabled has YES value, all the debug log will be displayed on the console. If user does not want to print anything on console he/she has to set logEnabled to NO.
 * @code
 * [rendererViewController setLogsEnabled:YES];
 * @endcode
 */
- (void)setLogsEnabled:(BOOL)logEnabled;

/*!
 * To Enable/Disable Informartion/verbose.
 * @param1 verboseEnabled Enable/Disable Informartion/verbose.
 * @code
 * [rendererViewController setVerboseEnabled:YES];
 * @endcode
 */
- (void)setVerboseEnabled:(BOOL)verboseEnabled;

/*!
 * To Get currently shown/displayed Highlight Popup.
 * @return object of HighlightActionView.
 * @code
 * [rendererViewController getHighlightView];
 * @endcode
 */
-(HighlightActionView*)getHighlightView;

/*!
 * To set Highlight Popup.
 * @param1 highlightView Object of HighlightActionView.
 * @code
 * [rendererViewController setHighlightView:highlightView];
 * @endcode
 */
-(void)setHighlightView:(HighlightActionView*)highlightView;

/*!
 * To get an array that consist of Book TOC Content Data.
 * @return object of type NSArray.
 * @discussion This method returns toc Data where every toc element has the same level. There is no Parent Child Relationship between elements.
 * @code
 * [rendererViewController getTOCContentData];
 * @endcode
 */
- (NSArray *)getTOCContentData;

/*!
 * To get an array that consist of Book TOC Resource Data.
 * @return object of type NSArray.
 * @discussion This method returns Resources Data where every Resource element has the same level. There is no Parent Child Relationship between elements.
 * @code
 * [rendererViewController getTOCResourceData];
 * @endcode
 */
- (NSArray *)getTOCResourceData;

/*!
 * To get a dictionary with page identifier and Actual Touch Point
 * @param1 touchPoint Sticky Note Controller Touch Point
 * @return object of type NSDictionary.
 * @code
 * [rendererViewController validateAndGetRequiredDataForStickyNoteControllerTouchPoint:touchPoint];
 * @endcode
 */
-(NSDictionary*)validateAndGetRequiredDataForStickyNoteControllerTouchPoint:(CGPoint)touchPoint;

/*!
 * To get book path.
 * @return book path of type NSString.
 * @code
 * [rendererViewController getBookPath];
 * @endcode
 */
-(NSString*)getBookPath;

/*!
 * To get current CFI position.
 * @return CFI position of type NSString.
 * @code
 * [rendererViewController getCurrentCFI];
 * @endcode
 */
-(NSString*)getCurrentCFI;

/*!
 * To jump to CFI position.
 * @param1 href as CFI position string.
 * @code
 * [rendererViewController jumpToCFIString:href];
 * @endcode
 */
-(void)jumpToCFIString:(NSString*)href;

/*!
 * To get current range position.
 * @return range position of type NSString.
 * @code
 * [rendererViewController getLastVisitedRangeInfo];
 * @endcode
 */
-(NSString*)getLastVisitedRangeInfo;

/*!
 * To get current book data-cfi from html page.
 * @return data-cfi from html page of type NSString.
 * @code
 * [rendererViewController getCurrentBookDataCFI];
 * @endcode
*/
-(NSString*)getCurrentBookDataCFI;

/*!
* To highlight any word/element by id.
* @param1 wordId Word id to highlight the word/element.
* @code
* [rendererViewController highlightWordByWordId];
* @endcode
*/
-(void)highlightWordByWordId:(NSString*)wordId WithColor:(NSString*)color;

/*!
* To get first visible word after viewport for audio sync supported reflowable epub book.
* @code
* [rendererViewController getFirstVisibleWordForScreenWithCallBack:];
* @endcode
*/
-(void)getFirstVisibleWordForScreenWithCallBack:(void (^)(NSDictionary *))callback;

/*!
 * To set the furthest visited page data.
 * @param1 furthestPage of type NSString.
 * @code
 * [rendererViewController setFurthestPageData:furthestPage];
 * @endcode
 */
- (void)setFurthestPageData:(NSString *)furthestPage;

/*!
 * To get furthest visited page data.
 * @return furthest visited page of type NSString.
 * @code
 * [rendererViewController getFurthestPageData];
 * @endcode
*/
- (NSString *)getFurthestPageData;

/*!
 * To navigate to the furthest visited page.
 * @code
 * [rendererViewController navigateToFurthestPage];
 * @endcode
 */
- (void)navigateToFurthestPageWithSuccessHandler:(void(^)(void))successHandler withFailureHandler:(void(^)(void))failureHandler;

/*!
 * To navigate to the furthest visited page.
 * @param1 furthestPageData of type NSString.
 * @code
 * [rendererViewController navigateToFurthestPage:furthestPageData];
 * @endcode
 */
- (void)navigateToFurthestPage:(NSString *)furthestPageData withSuccessHandler:(void(^)(void))successHandler withFailureHandler:(void(^)(void))failureHandler;

/*!
 * To enable/Disable furthest page implementation.
 * @param1 isEnable of type BOOL.
 * @code
 * [rendererViewController enableFurthestPage:isEnable];
 * @endcode
 */
-(void)enableFurthestPage:(BOOL)isEnable;
-(BOOL)isFurthestPageEnabled;
@property (nonatomic,strong) NSString *bookThumbnailImage;
@end
