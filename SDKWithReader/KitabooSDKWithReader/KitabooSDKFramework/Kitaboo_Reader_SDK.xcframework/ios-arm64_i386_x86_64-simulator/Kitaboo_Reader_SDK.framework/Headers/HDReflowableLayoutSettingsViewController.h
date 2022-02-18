//
//  ReflowableLayoutSettingsViewController.h
//  Kitaboo

#import <UIKit/UIKit.h>
#import "HSRendrerConstant.h"

typedef void(^DidChangeReaderMode)(READER_MODE);
typedef void(^DidChangeTextAliginment)(TEXT_ALIGNMENT);
typedef void(^DidChangeLineSpacing)(TEXT_LINESPACING);
typedef void(^DidChangeMargin)(READER_MARGIN);
typedef void(^SliderValueDidChange)(CGFloat);
typedef void(^DidEnablePagination)(BOOL);
typedef void(^FontFamilyDidChange)(NSString*);
typedef void(^WillDismissController)(void);
typedef void(^ResetReaderSetting)(void);

/** An Object that manage a view For Reflowable Layout Settings.
 @discussion The HDReflowableLayoutSettingsViewController class defines a Layout for Reflowable Books where user can change the Background color, Theme color,Font Size, Reader Mode, Text Alignment,Brightness for the particular book.
 @superclass SuperClass : UIViewController
 */
@interface HDReflowableLayoutSettingsViewController : UIViewController

/*!
 * This method is used to  set background color to HDReflowableLayoutController view.
 @param1 color Color of type UIColor to set the background color.
 @code
 [reflowableLayoutSettingsViewController setBackgroundColorForView:[UIColor grayColor]];
 @endcode
 */
-(void)setBackgroundColorForView:(UIColor *)color;

/*!
 * This method is used to  set Theme color to HDReflowableLayoutController controls.
 @param1 color Color of type UIColor to set the Theme color.
 @code
 [reflowableLayoutSettingsViewController setThemeColorToView:[UIColor grayColor]];
 @endcode
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * This method is used to set font size to text for whole Page of reflowable epub books.
 @param1 currentFontSize is the value of changed font.
 @code
 [reflowableLayoutSettingsViewController setFontSize:25];
 @endcode
 */
- (void)setFontSize:(NSInteger)currentFontSize;

/*!
 * This method used to set current Reader mode configuration for reflowable epub books.
 @discussion  With the help of Reader mode Enable Feature user can change an appearance of Page to Day mode, Sepia mode or to night mode.
 
 - Day Mode Uses a colour scheme that displays dark text on a light background.
 
 - Sepia Mode Is a reddish brown monochrome tint. When applied to a Page, it gives the Page a warm, antique feeling.
 
 - Night Mode Uses a colour scheme that displays light text on a dark background.
 
 - Default Mode uses a colour scheme that displays as per book package details.
 
 @param1 modeType is the ReaderModeType value which represents mode configuration
 @code
 [reflowableLayoutSettingsViewController setReaderModeEnable:DAY_MODE];
 @endcode
 */
- (void)setReaderModeEnable:(READER_MODE)modeType;

/*!
 * This method used to enable/disable the pagination configuration for reflowable epub books.
 @discussion Pagination, is the process of dividing a document into discrete pages, where page navigation direction is either from left to right or vertical scrolling.
 
 -If enabled value is YES, page navigation direction will be left to right or in case of NO it will be vertical scrolling.

 @param1 enabled is the boolean value which represents the pagination configuration.
 @code
 [reflowableLayoutSettingsViewController setPaginationEnable:YES];
 @endcode
 */
- (void)setPaginationEnable:(BOOL)enabled;

/*!
 * This method used to set text alignment configuration for reflowable epub books
 @discussion With the help of Text alignment Feature user can change alignment of text on a page using different text positioning.
 
 - Left Alignment starts each new line of the document on the left-most margin.
 
 - Center Alignment positions and starts each new line/text block in the center/middle margin on the page.
 
 - Right Alignment starts each new line of the document on the right-most margin of the page.
 
 - Justify Alignment aligns text with right and left margins and tries to fill as much empty space as possible. It enables a straight margin on both of the page's horizontal edges.
 
 - Default alignment aligns text as per the book package details.
 
 @param1 alignmentType represents the current text alignment configuration
 @code
 [reflowableLayoutSettingsViewController setCurrentTextAlignment:LEFT_ALIGNMENT];
 @endcode
 */
- (void)setCurrentTextAlignment:(TEXT_ALIGNMENT)alignmentType;

/*!
* This method used to set Line Spacing configuration for reflowable epub books
@discussion With the help of Line Spacing Feature user can change The Spacing between lines on a page.

@param1 lineSpacing represents the current line spacing configuration
@code
[reflowableLayoutSettingsViewController setCurrentLineSpacing:MEDIUM_LINESPACING];
@endcode
*/
- (void)setCurrentLineSpacing:(TEXT_LINESPACING)lineSpacing;

/*!
* This method used to set Margin configuration for reflowable epub books
@discussion With the help of margin Feature user can change the margin between text and border.

@param1 margin represents the current margin configuration
@code
[reflowableLayoutSettingsViewController setCurrentLineSpacing:MEDIUM_LINESPACING];
@endcode
*/
- (void)setCurrentMargin:(READER_MARGIN)margin;

/*!
 * This method used to set current brightness configuration for reflowable epub books
 @param1 brightneesValue represents the current brightness configuration
 @code
 [reflowableLayoutSettingsViewController setCurrentBrightness:[UIScreen mainScreen].brightness];
 @endcode
 */
- (void)setCurrentBrightness:(CGFloat)brightneesValue;

/*!
 * This method used to set current font family configuration for reflowable epub books
 @param1 fontName represents current font family configuration
 @code
 [reflowableLayoutSettingsViewController setCurrentFontFamily:@"Times New Roman"];
 @endcode
 */
- (void)setCurrentFontFamily:(NSString *)fontName;

/*!
 * didChangeReaderMode is a block, that would be called when user tap any mode on reflowable setting view controller, Provide action that need to be perform on tap of that mode.
 @discussion Returing The mode type of Type READER_MODE.
 @code
 [reflowableLayoutSettingsViewController setDidChangeReaderMode:^(READER_MODE readerModeType)
 { 
 }];
 @endcode
 */
@property (nonatomic) DidChangeReaderMode didChangeReaderMode;

/*!
 * didChangeTextAliginment is a block, that would be called when user tap any text alignment on reflowable setting view controller, Provide action that need to be perform on tap of that text alignment.
 
 @discussion Returing The text alignment of Type TEXT_ALIGNMENT.
 @code
 [reflowableLayoutSettingsViewController setDidChangeTextAliginment:^(TEXT_ALIGNMENT textAlignmentType)
 {
 }];
 @endcode
 */
@property (nonatomic) DidChangeTextAliginment didChangeTextAliginment;

/*!
 * fontSizeDidChange is a block, that would be called when user tap any button on slider on reflowable setting view controller, Provide action that need to be perform on tap of that button on slider.
 
 @discussion Returing The font size of type CGFloat.
 @code
 [reflowableLayoutSettingsViewController setFontSizeDidChange:^(CGFloat fontSize)
 {
 }];
 @endcode
 */
@property (nonatomic) SliderValueDidChange fontSizeDidChange;

/*!
 * brightnessDidChange is a block, that would be called when user change the brightness slider value on reflowable setting view controller, Provide action that need to be perform on change the brightness slider value.
 
 @discussion Returing The brightness value of type CGFloat.
 @code
 [reflowableLayoutSettingsViewController setBrightnessDidChange:^(CGFloat brightnesValue)
 {
 }];
 @endcode
 */
@property (nonatomic) SliderValueDidChange brightnessDidChange;

/*!
 * didEnablePagination is a block, that would be called when user tap on "Scroll Enabled ON/OFF" button on reflowable setting view controller, Provide action that need to be perform on tap of "Scroll Enabled ON/OFF" button.
 
 @discussion Returing A BOOL value.
 @code
 [reflowableLayoutSettingsViewController setDidEnablePagination:^(BOOL isEnabled)
 {
 }];
 @endcode
 */
@property (nonatomic) DidEnablePagination didEnablePagination;

/*!
 * fontFamilyDidChange is a block, that would be called when user tap on any font family from given drop down box on reflowable setting view controller, Provide action that need to be perform on tap of that font family.
 
 @discussion Returing The Selected Font of type NSString.
 @code
 [reflowableLayoutSettingsViewController setFontFamilyDidChange:^(NSString *selectedFont)
 {
 }];
 @endcode
 */
@property (nonatomic) FontFamilyDidChange fontFamilyDidChange;

/*!
* didChangeLineSpacing is a block, that would be called when user tap any line spacing on reflowable setting view controller, Provide action that need to be perform on tap of that line spacing.

@discussion Returing The line spacing of Type TEXT_LINESPACING.
@code
[reflowableLayoutSettingsViewController setDidChangeLineSpacing:^(TEXT_LINESPACING lineSpacing)
{
}];
@endcode
*/
@property (nonatomic) DidChangeLineSpacing didChangeLineSpacing;

/*!
* didChangeMargin is a block, that would be called when user tap any margin on reflowable setting view controller, Provide action that need to be perform on tap of that margin.

@discussion Returing The line spacing of Type READER_MARGIN.
@code
[reflowableLayoutSettingsViewController setDidChangeMargin:^(READER_MARGIN margin)
{
}];
@endcode
*/
@property (nonatomic) DidChangeMargin didChangeMargin;

/*!
 * willDismissController is a block, that would be called when user tap on reader view controller to remove reflowable setting view controller.
 @code
 [reflowableLayoutSettingsViewController setWillDismissController:^
 {
 }];
 @endcode
 */
@property (nonatomic) WillDismissController willDismissController;

/*!
 * resetReaderSetting is a block, that would be called when user tap "Reset Setting" button on reflowable setting view controller, Provide action that need to be perform on tap of "Reset Setting" button.
 @code
 [reflowableLayoutSettingsViewController setResetReaderSetting:^
 {
 }];
 @endcode
 */
@property (nonatomic) ResetReaderSetting resetReaderSetting;

/*!
 *Set an array of font family for reflowable epub books.
 @discussion Array of String values.
 @code
 [reflowableLayoutSettingsViewController setFontFamilyArray:[NSArray arrayWithObjects:@"Times New Roman",@"Athelas",@"Charter",@"Georgia",nil]];
 @endcode
 */
@property (nonatomic) NSArray *fontFamilyArray;

/*!
 *To enable brightness Slider in Reflowable Layout Settings;
 @discussion This Slider is used to change brightness for Current Application
 
 -YES value enable the Slider to the user.
 
 -NO value Disable the Slider to the user.
 @code
 [reflowableLayoutSettingsViewController setEnableBrightnessSlider:YES]
 @endcode
 */
@property (nonatomic) BOOL enableBrightnessSlider;
@end
