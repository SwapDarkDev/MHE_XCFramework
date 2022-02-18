//
//  PenToolThicknessPalleteViewController
//  PlayerTopBarController
//
//  Created by amol shelke on 14/02/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "AccessibilityIdentifierConstants.h"
@class KitabooPenToolThicknessPalleteViewController;

@protocol PointToolItemDelegate
-(void)didSelectPenThickness:(float)font;
-(void)willDismissPenToolThicknessPalleteView;
@end

@interface KitabooPenToolThicknessPalleteViewController : UIViewController<PlayerActionDelegate>
@property (weak, nonatomic) id<PointToolItemDelegate> delegate;
@property (nonatomic) float selectedThicknessValue;
@property (nonatomic,weak)NSString *thicknessColor;
@property (nonatomic,weak)UIColor *thickenessSliderTintColor;
@property (nonatomic,weak)UIColor *sliderFilledColor;

/**
 *method to set background color to thickness picker view
 @param1 backgroundColor pass the color to set the backgroundColor of thickness pickerView
 */
-(void)setThicknessPickerViewBackgroundColor:(UIColor *)backgroundColor;
/**
 *method to set background color to  vertical separator view background color
 @param1 seperatorColor pass the color to set the backgroundColor of vertical separtor
 */
-(void)setVerticalSeperatorColor:(UIColor *)seperatorColor;
@end
