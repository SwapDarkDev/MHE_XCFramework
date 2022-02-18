//
//  TOCController.h
//
//  Created by Sumanth Myrala on 11/01/18 .
//
//

#import <UIKit/UIKit.h>
#import "KFBookVO.h"


typedef enum{
    
    TOC = 0,
    RESOURCE = 1,
    BOOKMARK = 2,
    STANDARDS = 3
    
} Filter;

/*!
 @protocol TOCControllerDelegate
 @brief The delegate of a TOCController object must adopt the TOCControllerDelegate protocol.
 @discussion TOCControllerDelegate Protocol used to handle all the callbacks of TOCController Class. The TOCControllerDelegate protocol defines methods that allow user to perform action when any segment is tapped i.e. content, resource and bookmark or any data row from the segment is tapped by the user. All Delegate methods are optional.
 
 When configuring the TOCController object, assign your delegate object to its delegate property.
 */
@protocol TOCControllerDelegate <NSObject>
@optional
/*!
 *  Will be called when the user tap on any row, in TOCController, It also provide the pageID for which the row was selected, Use this PageID for Nagivate to the respective PageID, Navigation to Specific can be done using Renderer Method
 * @param1 pageID is the PageNumber where user navigates
 */
- (void)navigateTopage:(NSString *)pageID;


/*!
 * Will be called when user tap on Content segment
 * @discussion There are three segment present Contents, Resources and Bookmarks when user selects content segment this method gets called. User can update tableview data to show content related data.
 */
- (void)didSelectContentSegment;

/*!
 Will be called when user tap on specific resource in resource segment
 * @discussion When user select specific resource present in Resource segment this method gets called. User can write action that need to be performed when user tap on link.
 * @param1 linkVO is the KFLinkVO object of selected resource
 */
-(void)actionForLink:(KFLinkVO*)linkVO;


/*!
 * Will be called when user tap on Resource segment
 * @discussion There are three segment present Contents, Resources and Bookmarks when user selects resource segment this method gets called. User can update tableview data to show resource related data.
 */
- (void)didSelectResourceSegment;

/*!
 * Will be called when user tap on Bookmark segment
 * @discussion There are three segment present Contents, Resources and Bookmarks when user selects bookmark segment this method gets called. User can update tableview data to show bookmark related data.
 */
- (void)didSelectBookmarkSegment;

/*!
 * Will be called when user perform action to close the TOC
 * @discussion When TOC is opened on mobile and user tap on back button present on toc view then this method gets called. User can write code to remove toc view when tapped on back button.
 */
-(void)didSelectActionToCloseTOC;

/*!
 * Will be called while setting icon for resources present in resorce segment.
 * @discussion While setting icon to resources present in resource segment this method gets called. User can return icon name which need to be set.
 * @return NSString
 */
- (NSString *)labelTextForLink:(KFLinkVO *)linkVO;

@end

/** An Object that manage a Toc view.
 @discussion The TOCController class is responsible for displaying data on Toc data and hadling actions for TOC.
 @superclass SuperClass : UIViewController
 */
@interface TOCController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;

/*!
 The object that acts as the delegate of the TOCController.
 @discussion The delegate must adopt the TOCControllerDelegate protocol. The delegate is not retained.
 @code
 _tOCController.delegate = self
 @endcode
 */
@property (nonatomic, weak) id <TOCControllerDelegate> delegate;

/*!To set data for TOCController.
 @discussion User should set the necessary data for displaying the data/content for resources , bookmarks or content segment.
 @param1 data is the array object where user need to set for specific segment tap
 @code
 [_tocController setData:bookmarks];
 @endcode
 */
- (void)setData:(NSArray *)data;

/*!
 * This method used to  set background color to TOCPopover
 @discussion To set background color to toc popover shown for IPad.User can set background color of popover.
 @param1 color pass the color to set the background color
 @code
 [_tocController setBackgroundColorForView:hdThemeVO.reader_default_panel_backgroundColor];
 @endcode
 */
-(void)setBackgroundColorForView:(UIColor *)color;

/*!
 * This method used to  set Theme color to TOCPopOver controls
 @discussion User can use this method to set tint color to segmentController and to set  color to TOC title label.
 @param1 color pass the color to set the Theme color
 @code
 [_tocController setThemeColorToView:hdThemeVO.reader_tab_color];
 @endcode
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * This method used to  set color to data inside tableView
 @discussion User can use this method to set color to data inside table of TOCController.
 @param1 color pass the color to set the data color
 @code
 [_tocController setThemeColorToView:hdThemeVO.reader_tab_color];
 @endcode
 */
-(void)setColorToDataInsideTable:(UIColor *)color ;

/*!
 * This method used to  set color to back button
 @discussion User can set color to back button present for mobile device(iPhone).
 @param1 backButtonColor pass the color to set the back button color
 @code
 [_tocController setColorToDataInsideTable:hdThemeVO.reader_default_panel_color];
 @endcode
 */
-(void)setBackButtonColor:(UIColor *)backButtonColor;

/*!
 * This method used to  enable/disable Title
 @discussion User can enable or disable title shown on mobile device(iPhone). User can write code to hide/show title .
 @param1 enable A Boolean value that determines whether the Title is enable.
 * The default value is YES.
 @code
 [_tocController enableTitle:YES];
 @endcode
 */
-(void)enableTitle:(BOOL)enable;
@end

@interface UISegmentedControl (Common)
- (void)ensureiOS12Style: (UIColor *)tintColor;
@end
