//
//  UIViewController-Expanded.h
//  KitabooBookShlefController
//
//  Created by Rishab Bokaria on 07/05/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIViewController (UIViewController_Expanded)

- (void)addShadow;

-(void)fadeInViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration;
-(void)fadeOutViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration;

- (void)animateViewController:(UIViewController *)viewController
                    fromRect:(CGRect)fromRect
                      toRect:(CGRect)toRect
                withDuration:(NSTimeInterval)duration;

- (void)dismissViewController:(UIViewController *)viewController
                     fromRect:(CGRect)fromRect
                       toRect:(CGRect)toRect
                 withDuration:(NSTimeInterval)duration;

-(void)slideInViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration;
-(void)slideOutViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration;
-(void)slideUpViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration;

-(void)slideDownViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration;
+ (void)returnToRootViewController;
@end
