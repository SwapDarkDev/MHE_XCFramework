//
//  TextSearchResult.h
//  Kitaboo
//


#import <Foundation/Foundation.h>

/** An Object that to be retruned as result when user search any text.
 * @superclass SuperClass : NSObject
 */
@interface TextSearchResult : NSObject


/*!
 *  Setting/Getter for attributed text of search result
 */
@property (nonatomic, strong) NSAttributedString *searchResultAttributedString;

/*!
 *  Setting/Getter for markupString
 */
@property (nonatomic, strong) NSString *markupString;

/*!
 *  Setting/Getter for displayString
 */
@property (nonatomic, strong) NSString *displayString;

/*!
*  Setting/Getter for href of the search result.This is related to epub type of books.
*/
@property (nonatomic, strong) NSString *href;

/*!
 *  Setting/Getter for page number of the search result
 */
@property (nonatomic, strong) NSString *pageIndex;

/*!
 *  Setting/Getter for display number of the search result
 */
@property (nonatomic, strong) NSString *displayNumber;

/*!
 *  Setting/Getter for searched word text.
 */
@property (nonatomic, strong) NSString *searchedWord;

/*!
 *  Setting/Getter for search result Sequence.The sequence will be according to the number of search results within the page.
 */
@property (assign,nonatomic)NSInteger searchResultSequence;

@end
