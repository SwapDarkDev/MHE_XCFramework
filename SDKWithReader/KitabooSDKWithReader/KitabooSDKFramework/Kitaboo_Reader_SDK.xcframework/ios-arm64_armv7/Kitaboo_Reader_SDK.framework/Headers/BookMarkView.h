//
//  BookMarkView.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGC.h"
@class BookMarkView;

/*!
 * @protocol BookMarkViewDelegate
 * @brief The delegate of a BookMarkView object must adopt the BookMarkViewDelegate protocol.
 * @discussion The BookMarkViewDelegate Protocol handles all the callbacks of BookMarkView class. The BookMarkViewDelegate protocol defines methods that allow user to perform action when bookmark icon is tapped. All methods of this protocol are optional.
 */
@protocol BookMarkViewDelegate <NSObject>
@optional
/*!
 *  This method will be called when the user tap on bookmark in page
 * @param1 bookmarkView BookMarkView object
 */
- (void)didTapOnBookMark:(BookMarkView *)bookmarkView;

@end

/** An Object that show a bookmark icon.
 * @discussion The BookMarkView is a view whose state varies according to the condition that if bookmark added or not added.
 * @superclass SuperClass : UIViewController
 */
@interface BookMarkView : UIButton

/*!
 * To initialize bookmarkview with customizable icon.
 * @param1 bookmarkIcon Icon to be shown on non-bookmarked page.
 * @param2 selectedBookmarkIcon Icon to be shown on bookmarked page.
 * @discussion Initializes and returns a newly allocated view object with specific bookmark Icon which needs be shown on non-bookmarked page and selected Bookmark Icon which needs to be shown on page.
 * @code
 * [[BookMarkView alloc] initWithBookmarkIcon:bookmarkIcon WithSelectedBookmarkIcon:selectedBookmarkIcon];
 * @endcode
 */
-(id)initWithBookmarkIcon:(NSString*)bookmarkIcon WithSelectedBookmarkIcon:(NSString*)selectedBookmarkIcon;

/*!
* To initialize bookmarkview with customizable icon.
* @param1 bookmarkIcon Icon to be shown on non-bookmarked page.
* @param2 selectedBookmarkIcon Icon to be shown on bookmarked page.
* @param3 size The size of the bookmark that should be displayed on the page
* @discussion Initializes and returns a newly allocated view object with specific bookmark Icon which needs be shown on non-bookmarked page and selected Bookmark Icon which needs to be shown on page.
* @code
* [[BookMarkView alloc] initWithBookmarkIcon:bookmarkIcon WithSelectedBookmarkIcon:selectedBookmarkIcon withBookmarkSize:size];
* @endcode
*/
-(id)initWithBookmarkIcon:(NSString*)bookmarkIcon WithSelectedBookmarkIcon:(NSString*)selectedBookmarkIcon withBookmarkSize:(CGSize)size;

/*!
* To initialize bookmarkview
* @param1 size The size of the bookmark that should be displayed on the page
* @discussion Initializes and returns a newly allocated view object with specific bookmark icon size
* @code
* [[BookMarkView alloc] initWithBookmarkSize:size];
* @endcode
*/
- (id)initWithBookmarkSize:(CGSize)size;


/*!
 * To set the necessary frame where bookmark needs to added on page.
 * @param1 frame CGRect object where the bookmark icon needs to be added on page
 * @code
 * [bookMarkView setPositionForParentFrame:frame];
 * @endcode
 */
- (void)setPositionForParentFrame:(CGRect)frame;

/*!
 * To get the updated SDKBookmarkVO object.
 * @return Returns updated SDKBookmarkVO object.
 * @code
 * [bookMarkView getBookmarkVO];
 * @endcode
 */
- (SDKBookmarkVO*)getBookmarkVO;

/*!
 * To set the updated SDKBookmarkVO object.
 * @discussion This method is used to set data to bookmark view, where parameter `bookmarkVO` contains all the information about the bookmark like text.
 * @param1 bookmarkVO Is the SDKBookmarkVO object to be updated.
 * @code
 * [bookMarkView setBookmarkVO:bookmarkVO];
 * @endcode
 */
- (void)setBookmarkVO:(SDKBookmarkVO *)bookmarkVO;

/*!
 * The object that acts as the delegate of the BookMarkView view.
 * @code
 * [bookMarkView setDelegate:self];
 * @endcode
 * @discussion The delegate must adopt the BookMarkViewDelegate protocol.
 */
@property (nonatomic, weak) id <BookMarkViewDelegate> delegate;

/*!
 * Setter and getter for Page Number where bookmark is being created.
 * @code
 * [bookMarkView setPageNumber:10];
 * @endcode
 */
@property (nonatomic,strong) NSNumber *pageNumber;

/*!
 * Setter and getter of bookmarkVO, which is an object of type SDKBookmarkVO.
 * @code
 * [bookMarkView setBookmarkVO];
 * @endcode
 */
@property (nonatomic,strong) SDKBookmarkVO *bookmarkVO;

/*!
 * Implement this method to set the color of bookmark for normal state
 * @param1 color Pass the UIColor to set color of bookmark for normal state
 * @code
 * [bookMarkView setBookmarkColorForNormalState:color];
 * @endcode
 */
-(void)setBookmarkColorForNormalState:(UIColor *)color;

/*!
 * Implement this method to set the color of bookmark for selected state
 * @param1 color Pass the UIColor to set color of bookmark for selected state
 * @code
 * [bookMarkView setBookmarkColorForSelectedState:color];
 * @endcode
 */
-(void)setBookmarkColorForSelectedState:(UIColor *)color;

/*!
 * Implement this method to set the background color of bookmark icon
 * @param1 color Pass the UIColor to set Bookmark background color.
 * @code
 * [bookMarkView setBackgroundColor:color];
 * @endcode
 */
-(void)setBackgroundColor:(UIColor *)color;

/*!
 * Implement this method to set the font of bookmark icon
 * @param1 font Pass the UIFont to set Bookmark font.
 * @code
 * [bookMarkView setBookmarkFont:font];
 * @endcode
 */
- (void)setBookmarkFont:(UIFont *)font;
@end
