//
//  HighLight.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightItem.h"
#import "UGC.h"

/*!
 * @protocol HighlightActionViewDelegate
 * @brief The delegate of a HighlightActionView object must adopt the HighlightActionViewDelegate protocol.
 * @discussion The HighlightActionViewDelegate Protocol handles all the callbacks of HighlightActionView class. The HighlightActionViewDelegate protocol defines methods that allow user to perform action when any item from highlight pop up is selected. All methods of this protocol are optional.
 */
@protocol HighlightActionViewDelegate<NSObject>
@optional

/*!
 * Will be called when any item on highlight popup is selected.
 * @discussion This is a delegate method called when user tap on any item on highlight popup.
 * @param item Oject of type HighlightItem which is selected.
 */
-(void)didSelectItem:(HighlightItem *)item;

/*!
 * Delegate method when changes is made in SDKHighlightVO object.
 * @discussion Will be called when any changes is made in SDKHighlightVO object (For which highligh popup was shown, The object is linked with HightlightActionView), here we should save the changed if needed.
 */
-(void)didUpdatedHighlight;

/*!
 * Will be called when highlight pop up is closed.
 */
-(void)didHighlightClosed;
@end

/**
 * An Object that will be responsible for Creation of Highlight pop up,HighlightActionView is a container, which can contain multiple Items of Type HighlightItem.
 * @superclass SuperClass : UIView
 */
@interface HighlightActionView : UIView <HighlightItemDelegate>

/*!
 * Initiate hightlight view.
 * @param1  itemSize Item size(Height and Width).
 * @discussion Initializes and returns a newly allocated view object with specified item size.
 * @code
 * [highlightActionView initWithItemSize:itemSize];
 * @endcode
 */
-(id)initWithItemSize:(CGSize)itemSize;

/*!
 * To add item on highlight popup.
 * @discussion This method is used to add a new item (Object of Type HighlightItem) on highlight pop up.
 * @param1  item Item of Type HighlightItem to be added on highlight popup.
 * @code
 * [highlightActionView addHighlightItem:view];
 * @endcode
 */
-(void)addHighlightItem:(HighlightItem *)item;

/*!
 * To reset the selected items.
 * @discussion It will set the state of all the items to UnSelected.
 * @code
 * [highlightActionView resetHighlightSelection];
 * @endcode
 */
-(void)resetHighlightSelection;

/*!
 * TO remove highlight pop up from renderer.
 * @code
 * [highlightActionView remove];
 * @endcode
 */
-(void)remove;

/*!
 *Setter and getter for itemSize.
 * @code
 * [highlightActionView setItemSize:itemSize];
 * @endcode
 */
@property (nonatomic) CGSize itemSize;

/*!
 * Setter and getter for page number for which the highlight popup was shown.
 * @code
 * [highlightActionView setPageNumber:pageNumber];
 * @endcode
 */
@property (nonatomic) NSInteger pageNumber;

/*!
 * Setter and getter for SDKHighlightVO object for which highlight popup is shown.
 * @code
 * [highlightActionView setHighlightVO:highlightVO];
 * @endcode
 */
@property (strong,nonatomic) SDKHighlightVO *highlightVO;

/*!
 * Setter and getter for items added on highligh popup.
 * @code
 * [highlightActionView setHighlightItems:highlightItems];
 * @endcode
 */
@property (strong, nonatomic) NSMutableArray *highlightItems;

/*!
 * The object that acts as the delegate of the HighlightActionView.
 * @code
 * [highlightActionView setDelegate:self];
 * @endcode
 * @discussion The delegate must adopt the HighlightActionViewDelegate protocol.
 */
@property (weak, nonatomic) id<HighlightActionViewDelegate> delegate;
@end
