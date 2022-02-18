//
//  UIViewController-Expanded.m
//  KitabooBookShlefController
//
//  Created by Rishab Bokaria on 07/05/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "UIViewController-Expanded.h"

@implementation UIViewController (UIViewController_Expanded)

- (void)addShadow
{
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.view.layer.shadowOpacity = 0.7;
    self.view.layer.shadowRadius = 4.0;
    self.view.layer.shadowOffset = CGSizeMake(5.0f, -2.5f);
}

-(void)fadeInViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         //increase!
         viewController.view.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
     }
     ];
}

-(void)fadeOutViewController:(UIViewController *)viewController withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         //decrease!
         viewController.view.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
     }
     ];
}


- (void)animateViewController:(UIViewController *)viewController
                    fromRect:(CGRect)fromRect
                      toRect:(CGRect)toRect
                withDuration:(NSTimeInterval)duration
{
    viewController.view.frame = fromRect;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         viewController.view.frame = toRect;
     }
                     completion:^(BOOL finished)
     {
         [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents)
                                                 withObject:nil
                                                 afterDelay:2.5];
         
     }];
}


- (void)dismissViewController:(UIViewController *)viewController
                     fromRect:(CGRect)fromRect
                       toRect:(CGRect)toRect
                 withDuration:(NSTimeInterval)duration
{
    viewController.view.frame = fromRect;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         viewController.view.frame = toRect;
                     }
                     completion:^(BOOL finished){
                     
                         [viewController.view removeFromSuperview];
                     }];
}

-(void)slideInViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration
{
    viewController.view.frame = CGRectMake(- CGRectGetWidth(viewController.view.frame), CGRectGetMinY(viewController.view.frame), CGRectGetWidth(viewController.view.frame), CGRectGetHeight(viewController.view.frame));
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         //slide in!
         viewController.view.frame = CGRectMake(60.0,  CGRectGetMinY(viewController.view.frame), CGRectGetWidth(viewController.view.frame), CGRectGetHeight(viewController.view.frame));
     }
                     completion:^(BOOL finished){
                     }];
}

-(void)slideUpViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration
{
    CGRect frame = viewController.view.frame;
    viewController.view.frame = CGRectMake(CGRectGetMinX(frame),
                                           CGRectGetMaxY(frame),
                                           CGRectGetWidth(frame),
                                           CGRectGetHeight(frame));
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //slide in!
                         viewController.view.frame = CGRectMake(CGRectGetMinX(frame),
                                                                CGRectGetMinY(frame),
                                                                CGRectGetWidth(frame),
                                                                CGRectGetHeight(frame));
                     }
                     completion:^(BOOL finished){
                     }];
    
}

-(void)slideDownViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration
{
    CGRect frame = viewController.view.frame;
    viewController.view.frame = CGRectMake(CGRectGetMinX(frame),
                                           CGRectGetMinY(frame),
                                           CGRectGetWidth(frame),
                                           CGRectGetHeight(frame));
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //slide down!
                         viewController.view.frame = CGRectMake(CGRectGetMinX(frame),
                                                                CGRectGetMaxY(frame),
                                                                CGRectGetWidth(frame),
                                                                CGRectGetHeight(frame));
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)slideOutViewController:(UIViewController *)viewController  withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         //slide out!
         viewController.view.frame = CGRectMake(- CGRectGetWidth(viewController.view.frame), CGRectGetMinY(viewController.view.frame), CGRectGetWidth(viewController.view.frame), CGRectGetHeight(viewController.view.frame));
     }
                     completion:^(BOOL finished)
     {
         
     }
     ];
}

+ (UIViewController*)topmostViewController
{
    UIViewController* vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while(vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)returnToRootViewController
{
    UIViewController* vc = [UIViewController topmostViewController];
    while (vc) {
        if([vc isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)vc popToRootViewControllerAnimated:NO];
        }
        if(vc.presentingViewController) {
            [vc dismissViewControllerAnimated:NO completion:^{}];
        }
        vc = vc.presentingViewController;
    }
}


@end
