//
//  KBFixedEpubThumbnailViewController.h
//  KitabooSDKWithReader
//
//  Created by Sumanth Myrala on 10/11/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KBFixedEpubThumbnailViewControllerDelegate <NSObject>
@optional
/**
 * This method will be called when user want to navigate to desired page through text field
 */
-(void)navigateToPageNo:(NSString *)pageNo;

/**This method Will be called when user perform action to close the thumbnail
 */
-(void)didPerformActionToCloseThumbnail;

/**
 * This method will be called when user click on previous history page Button
 */
-(void)didClickHistoryPreviousForFixedEpub;

/**
 * This method will be called when user click on next history page Button
 */
-(void)didClickHistoryNextForFixedEpub;
@end


@interface KBFixedEpubThumbnailViewController : UIViewController

/*!
 * To initialize KBFixedEpubThumbnailViewController with page details array and KBHDThemeVO instance
 * @param1 dataArray Icon to be shown on non-bookmarked page.
 * @param2 themeVO Icon to be shown on bookmarked page.
 * @discussion Initializes and returns a newly allocated view object with specific page details of the book and KBHDThemeVO instance.
 * @code
 * [[KBFixedEpubThumbnailViewController alloc] initWithData:[currentBook getThumbnailData] withTheme:hdThemeVO];
 * @endcode
 */
- (id)initWithData:(NSArray *)dataArray withTheme:(KBHDThemeVO *)themeVO;

/*!
 * The object that acts as the delegate of the KBFixedEpubThumbnailViewController.
 * @discussion The delegate must adopt the KBFixedEpubThumbnailViewControllerDelegate protocol. The delegate is not retained.
 * @code
 * fixedEpubViewController.delegate = self
 * @endcode
 */
@property (nonatomic, weak) id <KBFixedEpubThumbnailViewControllerDelegate> delegate;

/*!
 * Setter and getter for total count of the pages present in the book
 * @code
 * [fixedEpubViewController setTotalNumberOfPages:10];
 * @endcode
 */
@property (nonatomic, assign) int totalNumberOfPages;

/*!
 * Setter and getter of page number for curently active or visible page in reader
 * @code
 * [fixedEpubViewController setActivePageNumber:10];
 * @endcode
 */
@property (nonatomic, assign) int activePageNumber;

/*!
 * Setter and getter of display number for curently active or page visible in reader
 * @code
 * [fixedEpubViewController setActiveDisplayNumber:@"10"];
 * @endcode
 */
@property (nonatomic, assign) NSString *activeDisplayNumber;

/*!
 * To enable/disable the previous history button of thumbnail
 * @discussion User should set the BOOL to enable/disable the previous history button of thumbnail. It will be displayed with less alpha value and user interaction of the button will be disable if the value is set to NO.
 * @param1 isEnabled is the Boolean object.
 * @code
 * [fixedEpubViewController enablePreviousPageHistory:NO];
 * @endcode
 */
-(void)enablePreviousPageHistory:(BOOL)isEnabled;

/*!
 * To enable/disable the next history button of thumbnail
 * @discussion User should set the BOOL to enable/disable the next history button of thumbnail. It will be displayed with less alpha value and user interaction of the button will be disable if the value is set to NO.
 * @param1 isEnabled is the Boolean object.
 * @code
 * [fixedEpubViewController enableNextPageHistory:NO];
 * @endcode
 */
-(void)enableNextPageHistory:(BOOL)isEnabled;



@end

NS_ASSUME_NONNULL_END
