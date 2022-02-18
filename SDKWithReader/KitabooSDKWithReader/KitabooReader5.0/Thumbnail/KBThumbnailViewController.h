//
//  ThumbnailViewController.h
//  ThumnailCollections
//
//  Created by Gaurav on 30/01/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ReaderHeader.h"
@protocol KBThumbnailDelegate <NSObject>
@optional
/**
 * This method gives selected page number
 */
-(void)didSelectThumbnailPageNo:(NSString *)pageNo;
/**
 * Will be called when user perform action to close the thumbnail
 */
-(void)didSelectActionToCloseThumbnail;
/**
 * Will be called when user click on previous history page Button
 */
-(void)didClickPreviousHistoryButtonWithCurrentPageNumber;
/**
 * Will be called when user click on next history page Button
 */
-(void)didClickNextHistoryButtonWithCurrentPageNumber;
@end

@interface KBThumbnailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,weak) id <KBThumbnailDelegate> delegate;
/**
 * called this to set pages data Structure
 */
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSArray *studentSubmittedPageArray;
@property (nonatomic, assign) int totalNumberOfPages;
@property (nonatomic, assign) int activePageNumber;
@property (nonatomic, assign) NSString *activeDisplayNumber;
@property (nonatomic, strong) KBHDThemeVO *themeVo;
@property (nonatomic) BookOrientationMode bookOrientationMode;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;

/**
 * called this method when display particular page Number
 * @param1 pageNum page Number that will be selected
 */
-(void)selectPageAt:(NSString *)pageNum;

/**
 * This Method set Background color to ThumbnailCollection and it's cell
 * @param1 backgroundColor color that will set to ThumbnailCollection
 */
-(void)setThumbnailBackgroundColor:(UIColor *)backgroundColor;

/**
 * This Method set color to Chapter Number and Title
 * @param1 textColor pass color that will set to text of Chapter Number and Title
 */
-(void)setChapterIdAndTitleTextColor:(UIColor *)textColor;

/**
 * This Method set color to Page Number,Selected Page Barder,slider,Previous and Next page button.
 * @param1 textColor pass color will set to page number and button's
 */
-(void)setPageNumberTextColor:(UIColor *)textColor;
/**
 * This Method enable/Disable Previous Page History.
 * @param1 isEnabled enable/Disable
 */
-(void)enablePreviousPageHistory:(BOOL)isEnabled;
/**
 * This Method enable/Disable Next Page History.
 * @param1 isEnabled enable/Disable
 */
-(void)enableNextPageHistory:(BOOL)isEnabled;

@end
