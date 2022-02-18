//
//  HDReaderSliderActionBar.h
//  Kitaboo
//
//  Copyright © 2018 CEPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KitabooBookVO.h"
#import "KFBookVO.h"
#import "EPUBBookVO.h"

@protocol HDReaderSliderActionBarDelegate<NSObject>

/*!
 * Will be called when user tap on slider or on any button
 * @param1 pageNumber Page number loaded
 */
-(void)didSelectPageNumber:(NSString *)pageNumber;

@end

@interface HDReaderSliderActionBar : UIView

@property (weak, nonatomic) id<HDReaderSliderActionBarDelegate> delegate;

/*!
 TO Initialte/Launch slider
 * @param1 book Object of KitabooBookVO
 * @param2 width Width for Slider View
 * @param3 pageNumber Page number loaded
 * @param4 color Color for Slider thumb and selected buttons
 */
-(id)initWithBook:(KitabooBookVO *)book withWidth:(float)width withCurrentPageNumber:(int)pageNumber andWithSliderThumbAndSelectedButtonsColor:(UIColor*)color;

/*!
 TO Enable/Disable Slider page details View
 * @param1 enabled to enable slider view
 */
-(void)setSliderPageDetailsViewEnabled:(BOOL)enabled;

/*!
 TO Enable/Disable SliderPageDetailsView TextColor
 * @param1 color Color for text on SliderPageDetailsView
 */
-(void)setSliderPageDetailsViewTextColor:(UIColor *)color;

/*!
 TO Enable/Disable Unselected Buttons And Slider Color
 * @param1 color Color for unselected buttons and slider
 */
-(void)setUnselectedButtonsAndSliderColor:(UIColor *)color;

/*!
 TO Update Items on Slider Action bar
 * @param1 width Width for Slider View
 */
-(void)updateItemsOnSliderActionBarWithWidth:(float)width;

/*!
 TO Load Slider on selected Page Number
 * @param1 pageNumber Page number loaded
 */
-(void)setSliderOnSelectedPageNumber:(int)pageNumber;

@end
