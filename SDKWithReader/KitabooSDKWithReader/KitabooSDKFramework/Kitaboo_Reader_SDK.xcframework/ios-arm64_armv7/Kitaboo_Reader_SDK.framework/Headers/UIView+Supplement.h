//
//  UIView+Expanded.h
//  Kitaboo
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expanded)

CGRect CGRectInflateRect(CGRect rect, CGFloat px);

- (void)addBoarderToRightWithColor:(UIColor *)color;
- (UIView *)addBoarderToLeftWithColor:(UIColor *)color;
- (void)addBorderWithColor:(UIColor *)color;
- (UIView *)addTopBorderWithColor:(UIColor *)color;
- (UIView *)addBottomBorderWithColor:(UIColor *)colour;
- (void)addDottedBottomBorderWithColor:(UIColor *)colour;
- (void)addVerticalDottedLineWithColor:(UIColor *)color;
- (void)addDashedLineAtBottomOfViewWithColour:(UIColor *)colour;
- (void)addBottomBorderWithColor:(UIColor *)colour atYPostion:(CGFloat)yPos;
- (void)addShadowToView;

@end
