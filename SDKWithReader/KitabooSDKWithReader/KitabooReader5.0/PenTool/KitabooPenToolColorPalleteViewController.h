//
//  PenToolColorPalleteViewController.h
//  PlayerTopBarController
//
//  Created by amol shelke on 12/02/18.
//  Copyright © 2018 amol shelke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
@class KitabooPenToolColorPalleteViewController;

@protocol PenToolItemDelegate
-(void)didSelectPenColor:(NSString *)color;
-(void)willDismissPenToolColorPalleteView;
@end

@interface KitabooPenToolColorPalleteViewController : UIViewController<PlayerActionDelegate>
@property (weak, nonatomic) id<PenToolItemDelegate> delegate;
@property (nonatomic,strong) NSArray *penColors;
@property (nonatomic,strong) NSString *selectedPenColor;
@property (nonatomic,strong) UIColor *selectionBorderColor;
@property (nonatomic,strong) UIColor *containerBorderColor;

/**
 *method to set background color to color picker view
 @param1 backgroundColor pass the color to set the backgroundcolor of color pickerView
 */
-(void)setColorPickerBackgroundColor:(UIColor *)backgroundColor;
@end
