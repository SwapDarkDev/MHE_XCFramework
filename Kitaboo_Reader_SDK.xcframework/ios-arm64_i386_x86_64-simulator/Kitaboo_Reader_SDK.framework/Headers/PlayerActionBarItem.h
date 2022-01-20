//
//  PlayerActionBarItem.h
//  PlayerTopBarController
//
//  Created by Gaurav Bhatia on 02/02/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PlayerActionBarItem;

/*!
 * @protocol PlayerItemDelegate
 * @brief The delegate of a PlayerActionBarItem object must adopt the PlayerItemDelegate protocol.
 * @discussion The PlayerItemDelegate Protocol handles all the callbacks of PlayerActionBar class. The PlayerItemDelegate protocol defines methods that allow user to perform action when PlayerActionBarItem object is selected. All methods of this protocol are optional.
 
  When configuring the PlayerActionBarItem object, assign your delegate object to its delegate property.
 */
@protocol PlayerItemDelegate<NSObject>
@optional
/*!
 * Will be called when action bar item is selected.
 * @param item Object of type PlayerActionBarItem.
 */
-(void)didPlayerActionBarSelectItem:(PlayerActionBarItem *)item;
@end

/**
 * An Object that will be responsible for Creation of Player Action Bar Item.
 * @superclass SuperClass : UIView
 */
@interface PlayerActionBarItem : UIView

/*!
* Initate Item.
* @param frame Rect for item.
* @discussion Initializes and returns a newly allocated view object with specified frame.
* @code
* [playerActionBarItem initWithFrame:frame];
* @endcode
*/
-(id)initWithFrame:(CGRect)frame;

/*!
 * The object that acts as the delegate of the PlayerActionBarItem view.
 * @code
 * [playerActionBarItem setDelegate:self];
 * @endcode
 * @discussion The delegate must adopt the PlayerItemDelegate protocol.
 */
@property (weak, nonatomic) id<PlayerItemDelegate> delegate;

/*!
 * Use this to enable/disable item.
 * @code
 * [playerActionBarItem setEnabled:YES];
 * @endcode
 */
@property (nonatomic) BOOL enabled;

/*!
 * For Getter and Setter.
 * @discussion A BOOL value to know item's state(Selected/Unselected). If `selected` is YES, item state is Selected else Unselected.
 * @code
 * [playerActionBarItem setSelected:YES];
 * @endcode
 */
@property (nonatomic) BOOL selected;

/*!
 * Use this to get item width.
 * @code
 * [playerActionBarItem setWidth:50];
 * @endcode
 */
@property (nonatomic) double width;

/*!
 * Getter and Setter of metaData.
 * @discussion A Dictionary which contains/store additional information about item.
 * @code
 * [playerActionBarItem setMetaData:metaData];
 * @endcode
 */
@property (nonatomic,strong) NSMutableDictionary *metaData;


@end
