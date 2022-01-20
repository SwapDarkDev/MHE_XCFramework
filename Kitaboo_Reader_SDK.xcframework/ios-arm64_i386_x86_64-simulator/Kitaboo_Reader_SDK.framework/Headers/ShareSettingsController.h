//
//  ShareSettingsController.h
//
//  Created by Sumanth Myrala on 12/02/18.
//  Copyright © 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGC.h"
#import "SDKBookClassInfoVO.h"

typedef enum : short {
    
    NoteShareSettings = 1,
    HighlightShareSettings = 2
    
} SettingsType;

/*!
 @protocol ShareSettingsControllerDelegate
 @brief The delegate of a ShareSettingsController object must adopt the ShareSettingsControllerDelegate protocol.
 @discussion All delegate methods are optional. ShareSettingsControllerDelegate methods get called when user selects any one of buttons (Cancel, Save) available on the share settings controller. While configuring the ShareSettingsController object, assign delegate object to its delegate property.
 */
@protocol ShareSettingsControllerDelegate <NSObject>
@optional

/*!
 * This method will be called when cancel button is tapped.
 */
- (void)didClickOnShareSettingsCancelButton;

/*!
 * This method will be called when done button is tapped in share settings.
 * @param1 bookClassInfoVO SDKBookClassInfoVO is the datasource object.
 */
- (void)didClickOnShareSettingsSaveButton:(SDKBookClassInfoVO *)bookClassInfoVO;

/*!
 * This method will be called when done button of share settings in sticky/contexual note is tapped.
 * @param1 highlightVO SDKHighlightVO is the datasource object.
 */
- (void)didClickOnNoteShareSettingsSaveButton:(SDKHighlightVO *)highlightVO;

@end

/** An object that manage a view for sharing a note/highlights.
 @discussion ShareSettingsController defines a view which appears, when user tap on settings button in MyDataController or share button of note controller. The share settings view is presented which contains information such as, to which teacher or student user wants to share his/her note/highlights.
 @superclass SuperClass : UIViewController
 */
@interface ShareSettingsController : UIViewController

/*!
 * The object that acts as the delegate of the ShareSettingsController.
 * @discussion The delegate must adopt the ShareSettingsControllerDelegate protocol.
 * @code
 * shareSettingsController.delegate = self (Object that confirms to ShareSettingsControllerDelegate)
 * @endcode
 */
@property (nonatomic, weak) id<ShareSettingsControllerDelegate> delegate;

/*!
 * User should define the preffered setting type to NoteShareSettings/HighlightShareSettings.
 * @code
 * [shareSettingsController setSettingsType:NoteShareSettings];
 * @endcode
 */
@property (nonatomic, assign) SettingsType settingsType;


/*!
 * Setter/Getter for highlightVO, SDKHighlightVO is the datasource of UGC i.e,Note/Highlight.
 * @code
 * [shareSettingsController setHighlightVO:highlightVO];
 * @endcode
 */
@property (strong, nonatomic) SDKHighlightVO *highlightVO;


/*!
 * Implement this method to set the background color of share settings view.
 * @param1 color UIColor object for background color.
 * @code
 * [shareSettingsController setBackgroundColorForView:color];
 * @endcode
 */
-(void)setBackgroundColorForView:(UIColor *)color;


/*!
 * Implement this method to set the theme color to components of share settings view.
 * @param1 color UIColor object for theme color.
 * @code
 * [shareSettingsController setThemeColorToView:color];
 * @endcode
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * Implement this method to set the textColor of data in tableView
 * @param1 color UIColor object for textColor.
 * @code
 * [shareSettingsController setColorToDataInsideTable:color];
 * @endcode
 */
-(void)setColorToDataInsideTable:(UIColor *)color ;

/*!
 * Implement this method to set the data for rendering content in tableView.
 * @param1 data NSArray object which user needs to set content in tableView.
 * @code
 * [shareSettingsController setData:data];
 * @endcode
 */
- (void)setData:(NSArray *)data;
@end
