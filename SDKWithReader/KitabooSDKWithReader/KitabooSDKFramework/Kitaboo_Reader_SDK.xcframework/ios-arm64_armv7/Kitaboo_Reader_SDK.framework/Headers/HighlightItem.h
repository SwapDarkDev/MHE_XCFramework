//
//  HighlightItem.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HighlightItem;

/*!
 * @protocol HighlightItemDelegate
 * @brief The delegate of a HighlightItem object must adopt the HighlightItemDelegate protocol.
 * @discussion The HighlightItemDelegate Protocol handles all the callbacks of HighlightItem class. The HighlightItemDelegate protocol defines methods that allow user to perform action when HighlightItem object is selected. All methods of this protocol are optional.
 */
@protocol HighlightItemDelegate<NSObject>
@optional

/*!
 * Will be called when item is selected.
 * @param item Object of type HighlightItem.
 */
-(void)didSelectItem:(HighlightItem*)item;
@end

/**
 * An Object that will be responsible for Creation of Highlight Item.
 * @superclass SuperClass : UIView
 */
@interface HighlightItem : UIView

/*!
 * Initate Item.
 * @param1 frame Rect for item, Note, The Size of Item should be given with respect to the size given to the container ie HightlightActionView.
 * @param1 action Action (Block) that need to be performed when user select the item.
 * @discussion Initializes and returns a newly allocated view object with specified frame and an Action that need to be performed when user select the item.
 * @code
 * [highlightItem initWithFrame:frame WithAction:action];
 * @endcode
 */
- (id)initWithFrame:(CGRect)frame WithAction:(void (^)(void))action;

/*!
 * For Getter and Setter.
 * @discussion A BOOL value to know item's state(Selected/Unselected). If `selected` is YES, item state is Selected else Unselected.
 * @code
 * [highlightItem setSelected:YES];
 * @endcode
 */
@property (nonatomic) BOOL selected;

/*!
 * Getter and Setting of metaData.
 * @discussion A Dictionary which contains/store additional information about item.
 * @code
 * [highlightItem setMetaData:metaData];
 * @endcode
 */
@property (nonatomic) NSMutableDictionary *metaData;

/*!
 * The object that acts as the delegate of the HighlightItem view.
 * @code
 * [highlightItem setDelegate:self];
 * @endcode
 * @discussion The delegate must adopt the HighlightItemDelegate protocol.
 */
@property (weak, nonatomic) id<HighlightItemDelegate> delegate;

/*!
 * Use this to enable/disable item.
 * @code
 * [highlightItem setEnabled:YES];
 * @endcode
 */
@property (nonatomic) BOOL enabled;

/*!
 * Call this to perform action which was defined initially.
 * @code
 * [highlightItem performAction];
 * @endcode
 * @discussion It will set the state of item to selected and perform the action which is defined in init of HighlightItem.
 */
-(void)performAction;
@end
