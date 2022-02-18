//
//  UIButton+UIButton_Expanded.h
//  KitabooBookMarkController
//
//  Created by Rishab Bokaria on 30/04/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIButton (UIButton_Expanded)

-(void)setTitleForNormalState:(NSString *)title;
-(void)setTitleForSelectedState:(NSString *)title;

-(void)setTitleColorForNormalState:(UIColor *)color;
-(void)setTitleColorForSelectedState:(UIColor *)color;

-(void)setRoundedCornerWithRadius:(CGFloat)radius;
-(void)setTitleLabelRoundedCornerWithRadius:(CGFloat)radius;
-(void)setTitleForAllState:(NSString *)title;
-(void)setImageForNormalState:(UIImage *)image;
-(void)setImageForSelectedState:(UIImage *)image;
@end
