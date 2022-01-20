//
//  PlayerTopBar.h
//  PlayerTopBarController
//
//  Created by Gaurav Bhatia on 02/02/18.
//  Copyright © 2018 Hurix System All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerActionBarItem.h"


@class PlayerActionBar;

/*!
 * Player action bar item Alignment.
 */
typedef enum
{
    PlayerActionBarAlignmentLeft,
    PlayerActionBarAlignmentRight,
    PlayerActionBarAlignmentCenter,
    PlayerActionBarAlignmentTop,
    PlayerActionBarAlignmentBottom
    
    
}PlayerActionBarAlignment;

/*!
 * Player action bar item Mode.
*/
typedef enum
{
    PlayerActionBarHorizontalMode,
    PlayerActionBarVerticalMode
}PlayerActionBarAlignmentMode;

/*!
 * @protocol PlayerActionDelegate
 * @brief The delegate of a PlayerActionBar object must adopt the PlayerActionDelegate protocol.
 * @discussion The PlayerActionDelegate Protocol handles all the callbacks of PlayerActionBar class. The PlayerActionDelegate protocol defines methods that allow user to perform action when any item from player action bar is selected. All methods of this protocol are optional.
 */
@protocol PlayerActionDelegate<NSObject>
@optional

/*!
 * Will be called when user select any item from the Action bar.
 * @discussion This is a delegate method called when user select any item from the Action bar.
 * @param1 playerActionBar Object of type PlayerActionBar from which item was tapped.
 * @param2 item Object of type PlayerActionBarItem which was tapped.
 */
-(void)didSelectedPlayerActionBar:(PlayerActionBar*)playerActionBar withItem:(PlayerActionBarItem *)item;

/**
 * Will be called when user wants to reset Player Action bar.
 * @discussion This method set state of every item to unselected.
 * @param1 playerActionBar Oject of type PlayerActionBar for which reset is required.
 */
-(void)willResetPlayerActionBar:(PlayerActionBar*)playerActionBar;
@end

/**
 * An Object that will be responsible for Creation of Player Action Bar, This is a container which contain object of PlayerActionBarItem
 * @superclass SuperClass : UIView
 */
@interface PlayerActionBar : UIView <PlayerItemDelegate>

/**
 * To Add Items on Action Bar.
 * @discussion This method is used to add a new item on Player Action Bar where parameter `item` contains all the information about the item. Item will be added with given width and alignment.
 
 - If `tapable`, user can tap on the item and perform required action else, the item won't be tapable.
 * @param1 item Object of type PlayerActionBarItem to be added on Action Bar.
 * @param2 width Width of item.
 * @param3 alignment Alignment of item on Action Bar.
 * @param4 tapable Bool value to check whether Item is Tappable or not.
 * @code
 * [playerActionBar addActionBarItem:item withItemsWidth:50 withItemAlignments:alignment isTappable:YES];
 * @endcode
 */
-(void)addActionBarItem:(PlayerActionBarItem *)item withItemsWidth:(double)width withItemAlignments:(PlayerActionBarAlignment)alignment isTappable:(BOOL)tapable;

/**
 * This method enable and disable Items on Action Bar.
 * @param1 tag Item's Registered tag.
 * @param2 enabled Item enabled or disable.
 * @code
 * [playerActionBar enableItemWithTag:tag WithIsEnabled:YES];
 * @endcode
 */
-(void)enableItemWithTag:(int)tag WithIsEnabled:(BOOL)enabled;

/**
 * This method Hide and Unhide Items on Action Bar.
 * @param1 tag Item's Registered tag.
 * @param2 hidden Item that hide or unhide.
 * @code
 * [playerActionBar hideItemWithTag:tag WithIsHidden:YES];
 * @endcode
 */
-(void)hideItemWithTag:(int)tag WithIsHidden:(BOOL)hidden;

/*!
 * The object that acts as the delegate of the PlayerActionBar.
 * @code
 * [playerActionBar setDelegate:self];
 * @endcode
 * @discussion The delegate must adopt the PlayerActionDelegate protocol.
 */
@property (weak, nonatomic) id<PlayerActionDelegate> delegate;

/**
 * To get selected item.
 * @return Returns selected item.
 * @code
 * [playerActionBar getSelectedItem];
 * @endcode
 */
-(PlayerActionBarItem*)getSelectedItem;

/**
 * To get all tappable items.
 * @return Returns All tappable items.
 * @code
 * [playerActionBar getTappableItems];
 * @endcode
 */
-(NSArray*)getTappableItems;

/*!
 * To reset the selected items.
 * @discussion It will set the state of all the items to UnSelected.
 * @code
 * [playerActionBar resetPlayerActionBarSelection];
 * @endcode
 */
-(void)resetPlayerActionBarSelection;


/**
 * This method should be called when user want to set the PlayerActionBarHorizontalMode/PlayerActionBarVerticalMode of the PlayerActionBar.Default Value will be "layerActionBarHorizontalMode"
 * @param1 alignmentMode AlignmentMode PlayerActionBarAlignmentMode
 * @code
 * [playerActionBar setPlayerActionBarAlignmentMode:PlayerActionBarVerticalMode];
 * @endcode
 */
- (void)setPlayerActionBarAlignmentMode:(PlayerActionBarAlignmentMode)alignmentMode;

@end
