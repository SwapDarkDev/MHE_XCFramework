//
//  FilterCollectionCell.h
//  Kitaboo
//
//  Created by Priyanka Singh on 20/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDataObject.h"
typedef void(^DropDownAction)(FilterDataObject *filterObj);

@interface FilterCollectionCell : UICollectionViewCell
@property (nonatomic,strong)  UILabel *checkBoxLbl;
@property (nonatomic,strong)  UIButton *titleButton;
@property (nonatomic,strong)  UIButton *dropDownButton;
@property (nonatomic,strong)  UIView *seperatorView;
@property (nonatomic,strong)  UIColor *checkBoxIconColor;
@property (nonatomic,strong)  NSLayoutConstraint *widthConstraintOfTitleBtn;

@property (nonatomic,strong)  FilterDataObject *filterDataObj;
@property (nonatomic) DropDownAction dropDownAction;
@property (nonatomic) DropDownAction checkBoxAction;

- (void)setDataForCell:(FilterDataObject *)filterDataObj;

@end
