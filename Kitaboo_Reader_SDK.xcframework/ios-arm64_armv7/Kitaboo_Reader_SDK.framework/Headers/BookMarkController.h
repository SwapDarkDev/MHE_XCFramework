//
//  BookMarkController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGC.h"

/*!
 * @protocol BookmarkControllerDelegate
 * @brief The delegate of a BookMarkController object must adopt the BookmarkControllerDelegate protocol.
 * @discussion The BookmarkControllerDelegate Protocol handles all the callbacks of BookMarkController class. The BookmarkControllerDelegate protocol defines method that allow user to perform action when bookmark is created/updated.
 */
@protocol BookmarkControllerDelegate <NSObject>
@optional
/*!
 * This method is called when the bookmark is created/updated on page.
 * @param1 bookmarkVO Is the SDKBookmarkVO object
 */
- (void)didBookmarkCompleteWithBookmarkVO:(SDKBookmarkVO *)bookmarkVO;

@end

/** An object that manage a BookMark view.
 * @discussion The BookMarkController is a container view where user can insert his/her bookmark data. SDKBookmarkVO Object is the data source for BookMarkController.
 * @superclass SuperClass : UIViewController
 */
@interface BookMarkController : UIViewController{
}

/*!
 * To get the updated SDKBookmarkVO object.
 * @return Returns updated SDKBookmarkVO object.
 * @code
 * [bookMarkController getBookmarkVO];
 * @endcode
 */
- (SDKBookmarkVO *)getBookmarkVO;

/*!
 * To set the updated SDKBookmarkVO object.
 * @discussion This method is used to set the data to bookmark view, where parameter `bookmarkVO` is the datasource of bookmark.
 * @param1 bookmarkVO SDKBookmarkVO object to be updated.
 * @code
 * [bookMarkController setBookmarkVO:bookmarkVO];
 * @endcode
 */
- (void)setBookmarkVO:(SDKBookmarkVO *)bookmarkVO;

/*!
 * Setter and getter for Page Number where bookmark is being created.
 * @code
 * [bookMarkController setPageNumber:10];
 * @endcode
 */
@property (nonatomic,strong) NSNumber *pageNumber;

/*!
 * The object that acts as the delegate of the BookMarkController view.
 * @code
 * [bookMarkController setDelegate:self];
 * @endcode
 * @discussion The delegate must adopt the BookmarkControllerDelegate protocol.
 */
@property (nonatomic, weak) id <BookmarkControllerDelegate> delegate;

/*!
 * Implement this method to set background color to Bookmark's Popover background.
 * @param1 color Pass the UIColor to set Bookmark's Popover background
 */
-(void)setBackgroundColorForView:(NSString *)color;

/*!
 * Implement this method to set the tint color of the input field.
 * @param1 tintColor UIColor which will be applied to input field.
 */
-(void)setTextFieldTintColor:(UIColor *)tintColor;
@end
