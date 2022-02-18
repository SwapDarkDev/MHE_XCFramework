//
//  ThumbnailViewController.h
//  ThumnailCollections
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ThumbnailDelegate <NSObject>
@optional
/*!
 * This method gives selected page number
 */
-(void)didSelectThumbnailPageNo:(NSString *)pageNo;
/*!
 * Will be called when user perform action to close the thumbnail
 */
-(void)didSelectActionToCloseThumbnail;
/*!
 * Will be called when user click on previous history page Button
 */
-(void)didClickPreviousHistoryButtonWithCurrentPageNumber;
/*!
 * Will be called when user click on next history page Button
 */
-(void)didClickNextHistoryButtonWithCurrentPageNumber;
@end

@interface ThumbnailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,weak) id <ThumbnailDelegate> delegate;
/*!
 * called this to set pages data Structure
 */
@property (nonatomic, strong)NSArray *dataArray;
/*!
 * called this method when display particular page Number
 * @param1 pageNum page Number that will be selected
 */
-(void)selectPageAt:(NSString *)pageNum;

/*!
 * This Method set Background color to ThumbnailCollection and it's cell
 * @param1 backgroundColor color that will set to ThumbnailCollection
 */
-(void)setThumbnailBackgroundColor:(UIColor *)backgroundColor;

/*!
 * This Method set color to Chapter Number and Title
 * @param1 textColor pass color that will set to text of Chapter Number and Title
 */
-(void)setChapterIdAndTitleTextColor:(UIColor *)textColor;

/*!
 * This Method set color to Page Number,Selected Page Barder,slider,Previous and Next page button.
 * @param1 textColor pass color will set to page number and button's
 */
-(void)setPageNumberTextColor:(UIColor *)textColor;
/*!
 * This Method enable/Disable Previous Page History.
 * @param1 isEnabled enable/Disable
 */
-(void)enablePreviousPageHistory:(BOOL)isEnabled;
/*!
 * This Method enable/Disable Next Page History.
 * @param1 isEnabled enable/Disable
 */
-(void)enableNextPageHistory:(BOOL)isEnabled;

/*!
 * This Method hide/unhide Page History.
 * @param1 enabled hide/unhide
 */
- (void)pageHistoryEnabled:(BOOL)enabled;

- (void)setFontForGoToButton:(NSString *)font;

-(void)setSearchPageTextFieldTintColor:(UIColor *)tintColor;
@end
