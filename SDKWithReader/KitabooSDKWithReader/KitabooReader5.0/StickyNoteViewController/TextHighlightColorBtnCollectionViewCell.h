//
//  TextHighlightColorBtnCollectionViewCell.h
//  Kitaboo
//
//  Created by Priyanka Singh on 05/05/18.
//  Copyright © 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextHighlightColorBtnCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeadingConstraint;
@property (strong, nonatomic) IBOutlet UIButton *heighLightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;

@end
