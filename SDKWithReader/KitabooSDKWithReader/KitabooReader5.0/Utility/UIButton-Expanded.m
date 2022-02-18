//
//  UIButton+UIButton_Expanded.m
//  KitabooBookMarkController
//
//  Created by Rishab Bokaria on 30/04/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "UIButton-Expanded.h"

@implementation UIButton (UIButton_Expanded)

-(void)setTitleForNormalState:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)setTitleForAllState:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
}


-(void)setTitleForSelectedState:(NSString *)title
{
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
}

-(void)setTitleColorForNormalState:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:[color colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
}

-(void)setTitleColorForSelectedState:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
}

-(void)setTitleColorForDisableState:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateDisabled];
}

-(void)setImageForNormalState:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

-(void)setImageForSelectedState:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
}

-(void)setRoundedCornerWithRadius:(CGFloat)radius
{
    CALayer *btnLayer = [self layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:radius];
}

-(void)setTitleLabelRoundedCornerWithRadius:(CGFloat)radius
{
    CALayer *btnLayer = [self.titleLabel layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:radius];
}

@end
