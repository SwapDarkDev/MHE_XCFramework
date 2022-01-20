//
//  HDReflowableLayoutController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSRendrerConstant.h"

@protocol HDReflowableLayoutControllerDelegate <NSObject>

@optional
/*!
 * Will be called when user enable/disable the pagination configuration for reflowable epub books
 @param1 enabled is the boolean value which represents the pagination configuration
 */
- (void)didEnablePagination:(BOOL)enabled;

/*!
 * Will be called when user enable/disable the night mode configuration for reflowable epub books
 @param1 enabled is the boolean value which represents the night mode configuration
 */
- (void)didEnableNightMode:(BOOL)enabled;

/*!
 * Will be called when user change/drap the slider to vary the font size for reflowable epub books
 @param1 fontValue is the integer value which represents the current/updated font size
 */
- (void)didChangeFontValue:(NSInteger)fontValue;

/*!
 * Will be called when user taps on the outer view in iPhones for reflowable epub books
 */
- (void)didTapOnView;

/*!
 * Will be called when user change the Reader mode for reflowable epub books
 @param1 mode represents the selected Reader Mode
 */
-(void)didTapOnReaderMode:(READER_MODE)mode;

@end


@interface HDReflowableLayoutController : UIViewController

/*!
 * This method used to  set background color to HDReflowableLayoutController view
 @param1 color pass the color to set the background color
 */
-(void)setBackgroundColorForView:(UIColor *)color;

/*!
 * This method used to  set Theme color to HDReflowableLayoutController controls
 @param1 color pass the color to set the Theme color
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * This method used to  set font size of text for reflowable epub books
 @param1 fontSize is the value of fontSize to be displayed
 */
- (void)setFontSize:(NSInteger)fontSize;

/*!
 * This method used to enable/disable the night mode configuration for reflowable epub books
 @param1 enabled is the boolean value which represents the night mode configuration
 */
- (void)setNightModeEnable:(BOOL)enabled;

/*!
 * This method used to enable/disable the pagination configuration for reflowable epub books
 @param1 enabled is the boolean value which represents the pagination configuration
 */
- (void)setPaginationEnable:(BOOL)enabled;

/*!
 * This method used to select the Reader mode configuration for reflowable epub books
 @param1 mode represents the selected Reader Mode
 */
-(void)setReaderMode:(READER_MODE)mode;
/*!
 *Set delegate (Callback listener)
 */
@property (nonatomic, weak) id <HDReflowableLayoutControllerDelegate> delegate;

@end
