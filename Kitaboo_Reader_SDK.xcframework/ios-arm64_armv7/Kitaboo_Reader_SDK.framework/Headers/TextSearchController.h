//
//  TextSearchController.h
//  KItabooSDK
//


#import <UIKit/UIKit.h>
#import "KitabooBookVO.h"
#import "TextSearchResult.h"

typedef enum
{
    kTextSearchResultTypePage= 0,
    kTextSearchResultTypeWord= 1
}kTextSearchResultType;

/*!
 * @protocol TextSearchControllerDelegate
 * @brief A protocol that allows a delegate to respond when any search result is selected form the TextSearchController view.
 * @discussion The delegate of a TextSearchController object must adopt the TextSearchControllerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol TextSearchControllerDelegate<NSObject>
@optional
/**
 * Will be called when user select search result text.
 * @discussion This method will be called when any search result is selected form the TextSearchController view. This method works for both iPhone and iPad.
 * @param1 searchResult User Selected search Result of type TextSearchResult.
 */
-(void)didSelectSearchText:(TextSearchResult*)searchResult;

/**
 * Will be called when user select Back button of TextSearchController.
 * @discussion This method will be called when user select back button to close TextSearchController view. This method only works for iPhone.
 */
-(void)didSelectActionForCloseSearch;

/**
 * Will be called when user change text in Search Text Field.
 * @discussion This method will be called when user change text in Search Text Field of TextSearchController view. This method only works for iPhone.
 */
-(void)didSearchTextChanged;
///Will be called when the search data decryption completed successfully.
-(void)didCompleteSearchDecryption;
@end

/** An Object that is resonsible for returning searched result data of type TextSearchResult.
 * @discussion The TextSearchController is used to return searched result, which can be displayed on TextSearchController view or users can use their customised view to display searched result.
 * @superclass SuperClass : UIViewController
 */
@interface TextSearchController : UIViewController

/*!
* Setter/Getter for delegate (callback listener)
* @code
* [textSearchController setDelegate:self];
* @endcode
*/
@property (nonatomic,weak) id <TextSearchControllerDelegate> delegate;

/*!
 * To initilize TextSearchController.
 * @param1 book Object of type KitabooBookVO.
 * @param2 searchText Given text that need to be searched.
 * @discussion Initializes and returns a newly allocated TextSearchController object with specified current book, and text, that need to be searched.
 * @code
 * [[TextSearchController alloc] initWithBookVO:book WithSearchText:searchText];
 * @endcode
 */
-(id)initWithBookVO:(KitabooBookVO*)book WithSearchText:(NSString*)searchText;

/*!
 * To initilize TextSearchController.
 * @param1 book Object of type KitabooBookVO.
 * @discussion Initializes and returns a newly allocated TextSearchController object with specified current book.
 * @code
 * [[TextSearchController alloc] initWithBookVO:book];
 * @endcode
 */
-(id)initWithBookVO:(KitabooBookVO*)book;

/*!
 * To initilize TextSearchController.
 * @param1 book Object of type KitabooBookVO.
 * @param2 searchText Given text that need to be searched.
 * @param3 searchResultType Is the type of searchResult i.e, PageWise/WordWise
 * @discussion Initializes and returns a newly allocated TextSearchController object with specified current book, and text, that need to be searched, where page will be searched either PageWise or WordWise.
 * @code
 * [[TextSearchController alloc] initWithBookVO:book WithSearchText:searchText withSearchType:searchResultType];
 * @endcode
 */
-(id)initWithBookVO:(KitabooBookVO*)book WithSearchText:(NSString*)searchText withSearchType:(kTextSearchResultType )searchResultType;

/**
 * To search text.
 * @discussion This method is used to search given text and display searhced text to TextSearchController view. This is used for all the type of books(PDF/EPUB).
 
    NOTE - This method will not be used when user only wants to get searched result.
 * @param1 searchText Given text that need to be searched.
 * @code
 * [textSearchController searchText:searchText];
 * @endcode
 */
-(void)searchText:(NSString*)searchText;

/**
 * To set background color to search text view.
 * @discussion This method is used to set given color as background color to TextSearchController view.
 * @param1 backgroundColor Pass the color to set the backgroundColor of search text view.
 * @code
 * [textSearchController setSearchTextViewBackgroundColor:backgroundColor];
 * @endcode
 */
-(void)setSearchTextViewBackgroundColor:(UIColor *)backgroundColor;

/**
 * To set border color of search text field.
 * @discussion This method is used to set given color as border color to text field of TextSearchController. And set color to back button as well.
 * @param1 borderColor Pass the color to set the border color and back button color.
 * @code
 * [textSearchController setSearchTextBorderColor:borderColor];
 * @endcode
 */
-(void)setSearchTextBorderColor:(UIColor *)borderColor;

/**
 * To set color of searched text.
 * @discussion This method is used to set given color as text color to searched text.
 * @param1 textColor Pass the color to set the text color of searched text.
 * @code
 * [textSearchController setSearchedTextColor:textColor];
 * @endcode
 */
-(void)setSearchedTextColor:(UIColor *)textColor;

/**
 * To get array of type TextSearchResult.
 * @discussion This method will return searched result which will be an array of type TextSearchResult, for provided text.
 * @code
 * [textSearchController getSearchResultForText:searchText];
 * @endcode
 * @return An array of type TextSearchResult.
 */
-(NSArray*)getSearchResultForText:(NSString*)searchText;

/**
 * To get array of type TextSearchResult.
 * @discussion This method will return searched result which will be an array of type TextSearchResult, for provided text and font type.
 * @code
 * [textSearchController getSearchResultForText:searchText forFont:font];
 * @endcode
 * @return An array of type TextSearchResult.
 */
-(NSArray*)getSearchResultForText:(NSString*)searchText forFont:(UIFont *)font;

/**
 This method will return array of TextSearchResult instance, for provided text for specific page
 */
- (NSArray *)getSearchResultForText:(NSString *)searchText withPageNo:(NSString *)pageNo withFont:(UIFont *)font;

/**
 This method will return array of next available TextSearchResult instance, for provided current page
 */
- (NSArray *)getNextSearchResultForText:(NSString *)searchText withCurrentPageNo:(NSString *)pageNo withFont:(UIFont *)font;

/**
 This method will return array of previous available TextSearchResult instance, for provided current page
 */
- (NSArray *)getPreviousSearchResultForText:(NSString *)searchText withCurrentPageNo:(NSString *)pageNo withFont:(UIFont *)font;

-(void)decryptSearchFileWithAbsolutePath:(NSString *)absolutePath WithRootPath:(NSString *)rootPath;
//pagination
-(void)searchText:(NSString*)searchText WithOffset:(int)offset WithBatchSize:(int)batchSize;
-(NSArray*)getSearchResultForText:(NSString*)searchText WithOffset:(int)offset WithBatchSize:(int)batchSize;
-(NSArray*)getSearchResultForText:(NSString*)searchText forFont:(UIFont *)font WithOffset:(int)offset WithBatchSize:(int)batchSize;
- (NSArray *)getSearchResultForText:(NSString *)searchText withPageNo:(NSString *)pageNo withFont:(UIFont *)font WithOffset:(int)offset WithBatchSize:(int)batchSize;
-(NSArray*)getPageWiseEpubSearchResultForText:(NSString*)searchText WithOffset:(int)offset WithBatchSize:(int)batchSize;
///To check if the search data available after parsing and decryption.
-(BOOL)isSearchResultAvailable;
@end
