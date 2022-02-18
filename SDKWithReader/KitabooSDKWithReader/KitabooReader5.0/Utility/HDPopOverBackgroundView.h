//
//  HDPopOverBackgroundView.h
//  Kitaboo 5.0
//
//  Created by Rajat.Babhulgaonkar on 19/08/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSUIColor-Expanded.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDPopOverBackgroundView : UIPopoverBackgroundView
{
}
@property (nonatomic, readwrite)            CGFloat arrowOffset;
@property (nonatomic, readwrite)            UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite, strong)    UIImageView *arrowImageView;

+ (void)setArrowColor:(UIColor *)arrowColor;
@end

NS_ASSUME_NONNULL_END
