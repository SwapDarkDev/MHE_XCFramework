//
//  MyDataViewController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGC.h"
#import "KitabooBookVO.h"
/*!
 @protocol MyDataControllerDelegate
 @brief The delegate of a MyDataController object must adopt the MyDataControllerDelegate protocol.
 @discussion MyDataControllerDelegate Protocol used to handle all the callbacks of MyDataController Class. The MyDataControllerDelegate protocol defines methods that allow user to perform action when any segment is tapped i.e. Highlights and notes or any data row from the segment is tapped by the user. All Delegate methods are optional. When configuring the MyDataController object, assign your delegate object to its delegate property.
 */
@protocol MyDataControllerDelegate <NSObject>
@optional
/*!
 *  Will be called when the user tap on any row, in MyDataController, It also provide the pageID for which the row was selected, Use this PageID for Nagivate to the respective PageID, Navigation to Specific can be done using Renderer Method
 * @discussion When user select any data from notes or highlights and to navigate to specific page number on which selectd data is present this method gets called. User can write code to show some message while navigating to page.
 * @param1 pageID is the PageNumber where user navigates.
 */
- (void)navigateTopage:(NSString *)pageID;

/*!
 * Will be called when user taps on My highlights tab and user is on highlights segment.
 * @discussion Will be called when user is on Highlights segment and tap on My highlights. User can update tableview array to show highlights created by user.
 */
- (void)didTapOnHighlightsSegmentWithMyHighlights;

/*!
 * Will be called when user taps on Shared with me tab and user is on highlights segment.
 * @discussion Will be called when user is on Highlights segmant and tap on Shared with me. User can update tableview array to show highlights shared with user.
 */
- (void)didTapOnHighlightsSegmentWithSharedWithMe;

/*!
 * Will be called when user tap on Important button and user is on highlights segment.
 * @discussion Will be called when user is on Highlights segmant and tap on Important button to show important highlights only. User can update tableview array to show important highlights craeted by user.
 */
- (void)didTapOnImportantHighlights;


/*!
 * Will be called when user taps on My notes tab and user is on notes segment.
 * @discussion Will be called when user is on Notes segmant and tap on Shared with me. User can update tableview array to show notes created by user.
 */
- (void)didTapOnNotesSegmentWithMyNotes;

/*!
 * Will be called when user taps on Shared with me tab and user is on notes segment.
 * @discussion Will be called when user is on Notes segmant and tap on Shared with me. User can update tableview array to show notes shared with user.
 */
- (void)didTapOnNotesSegmentWithSharedWithMe;

/*!
 * Will be called when user taps on Important button and user is on notes segment.
 * @discussion Will be called when user is on Notes segmant and tap on Important button to show important notes only. User can update tableview array to show important notes craeted by user.
 */
- (void)didTapOnImportantNotes;


/*!
 * Will be called when user tap on Share Settings.
 * @discussion when user is on myData and selects settings buttton then this method gets called. User can show/add new view that contains list of users to whom user can share data.
 */
- (void)didTapOnShareSettings;


/*!
 * Will be called when user tap on Share button available in notes segment.
 * @discussion when user is on notes segment and selects share buttton available in list of note then this method gets called. User can show/add new view that contains list of users to whom user can share data.
 */
- (void)didTapOnNoteShareSettings:(SDKHighlightVO *)highlightVO;


/*!
 * Will be called when user perform action to close the My Data
 * @discussion When MyData is opened on mobile and user tap on back button present on my data view then this method gets called. User can write code to remove my data view when tapped on back button.
 */
-(void)didSelectActionToCloseMyData;

/*!
 Will be called when user tap on accept/reject in note/highlight tab
 @discussion when other user share highlights/notes with user then user receive notification in myData view that someUser wants to share data with you, when user accepts or reject request then this method gets called. User can update data when user accepts request so that shared data can be shown or remove requset entry when user rejects request.
 @param1 highlightVO is object of SDKHighlightVO
 @param2 accepted is boolean value
 */
- (void)didAnsweredHighlight:(SDKHighlightVO *)highlightVO accepted:(BOOL) accepted;

@end

/** An Object that manage a MyData view.
 @discussion The MyDataViewController class is responsible for displaying and handling action on MyData view(notes/highlights).
 @superclass SuperClass : UIViewController
 */
@interface MyDataViewController : UIViewController{
}

/*!To set data for myData controller.
 *@discussion User should set the necessary data for displaying the data/content for notes, highlight segment.
 @param1 data is the array object where user need to set for specific segment tap.
 @code
 [_myDataViewController setData:myDataArray];
 @endcode
 */
- (void)setData:(NSArray *)data;


/*!To disable share settings button.
 *@discussion User should set the BOOL for disabling the Share Settings. User can hide/remove share settings button.
 @param1 disable is the Boolean object.
 @code
 [_myDataViewController disableShareSettings:YES];
 @endcode
 */
- (void)disableShareSettings:(BOOL)disable;


/*!To disable Shared with me tab.
 *@discussion User should set the BOOL for disabling the Share with me. User can remove shared with me tab.
 @param1 disable is the Boolean object.
 @code
 [_myDataViewController disableShareWithMeTab:YES];
 @endcode
 */
- (void)disableShareWithMeTab:(BOOL)disable;

/*!
 The object that acts as the delegate of the MyDataController.
 @discussion The delegate must adopt the MyDataControllerDelegate protocol. The delegate is not retained.
 @code
 _myDataController.delegate = self
 @endcode
 */
@property (nonatomic,weak)id<MyDataControllerDelegate>delegate;

/*!
 * This method used to  set background color to MydataPopOver.
 @discussion To set background color to myData popover shown for IPad.User can set background color of popover.
 @param1 color pass the color to set the background color.
 @code
[_tocController setBackgroundColorForView:@"#8fd5e1"];
 @endcode
 */
-(void)setBackgroundColorForView:(UIColor *)color;

/*!
 * This method used to  set Theme color to Mydata controls.
 @discussion User can use this method to set tint color to segmentController and to set  color to MyData title label, important button color , MyHighlighth/MyNotes , shared with me label.
 @param1 color pass the color to set the Theme color.
 @code
 [_myDataViewController setThemeColorToView:@"#8fd5e1"];
 @endcode
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * This method used to  set text color to no data label
 @param1 color pass the color to set the no data label text color
 @discussion User can set text color to noData label which is shown when there no data to display.
 @code
 [_myDataViewController setNoDataLabelTextColor:@"#8fd5e1"];
 @endcode
 */
-(void)setNoDataLabelTextColor:(UIColor *)color;

/*!To disable comments view for note.
 *@discussion User should set the BOOL for disabling the Comment in Note Segment. User can hide/remove comments view.
 @param1 disable is the Boolean object.
 @code
 [_myDataViewController disableCommentsForNote:YES];
 @endcode
 */
- (void)disableCommentsForNote:(BOOL)disable;

/*!To disbale share button for note.
 *@discussion User should set the BOOL for disabling the Share in Note Segment. User can  hide share button.
 @param1 disable is the Boolean object.
 @code
 [_myDataViewController disableShareForNote:YES];
 @endcode
 */
- (void)disableShareForNote:(BOOL)disable;

/*!
 * This method used to reload the MyData tableview to update the data
 @discussion User can use this method to reload data of myData view. User can update view , can set new data and reload table.
 @code
 [_myDataViewController reloadMyDataTableView];
 @endcode
 */
- (void)reloadMyDataTableView;

/*!
 To set the color for shared Highlight/Notes
 @discussion User can set color to the shared ugc if the hexColor is nil then the default color ugc will be applied.
 * @param1 hexColor is hexa color for shared Highlight/Notes
 @code
 [_myDataViewController setColorForSharedUGC:@"#8fd5e1"];
 @endcode
 */
- (void)setColorForSharedUGC:(NSString *)hexColor;

/*!
 * This method used to  enable/disable Title
 @discussion User can enable or disable title shown on mobile device(iPhone). User can write code to hide/show title .
 @param1 enable A Boolean value that determines whether the Title is enable.
 * The default value is YES.
 @code
 [_myDataController enableTitle:YES];
 @endcode
 */
-(void)enableTitle:(BOOL)enable;

/*!
 * Object of KitabooBookVO.
 */
@property (strong, nonatomic) KitabooBookVO * book;
@end

@interface UISegmentedControl (Common)
- (void)ensureiOS12Style: (UIColor *)tintColor;
@end
