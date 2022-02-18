//
//  FilterCollectionCell.m
//  Kitaboo
//
//  Created by Priyanka Singh on 20/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "FilterCollectionCell.h"
#import "IconFontConstants.h"
#import "Constant.h"
#import "ReaderHeader.h"
@implementation FilterCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self constructUI];
    }
    return self;
}

-(void)constructUI{
    self.titleButton = [[UIButton alloc] init];
    [self.titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.contentView addSubview:self.titleButton];
    self.seperatorView = [[UIView alloc] init];
    self.seperatorView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.seperatorView];
    self.dropDownButton = [[UIButton alloc] init];
    [self.dropDownButton.titleLabel setFont:DefualtFont(14)];
    [self.dropDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.dropDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.dropDownButton setTitle:ICON_DROPDOWN forState:UIControlStateNormal];
    [self.dropDownButton setTitle:ICON_UPARROW forState:UIControlStateSelected];
    [self.contentView addSubview:self.dropDownButton];
    [self.contentView bringSubviewToFront:self.dropDownButton];
    _dropDownButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    self.titleButton.translatesAutoresizingMaskIntoConstraints = false;
    self.seperatorView.translatesAutoresizingMaskIntoConstraints = false;
    self.widthConstraintOfTitleBtn = [self.titleButton.widthAnchor constraintEqualToConstant:50];
    self.widthConstraintOfTitleBtn.active = YES;
    self.titleButton.titleLabel.adjustsFontSizeToFitWidth = true;
    self.titleButton.titleLabel.minimumScaleFactor = 0.2;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15].active = YES;
    [self.titleButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:0].active = YES;
//    [self.titleButton.trailingAnchor constraintEqualToAnchor:self.dropDownButton.trailingAnchor constant:-15].active = YES;
    [self.titleButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:0].active = YES;

    [self.dropDownButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:0].active = YES;
    [self.dropDownButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:0].active = YES;
    [self.dropDownButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:0].active = YES;
    [self.dropDownButton.widthAnchor constraintEqualToConstant:60].active = YES;
    
    [self.seperatorView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:0].active = YES;
    [self.seperatorView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:0].active = YES;
    [self.seperatorView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:0].active = YES;
    [self.seperatorView.heightAnchor constraintEqualToConstant:1].active = YES;
}

- (void)setDataForCell:(FilterDataObject *)filterDataObj{
    self.filterDataObj = filterDataObj;
    if(self.filterDataObj.filterType != FilterTypeNONE){
        [self.titleButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_UNCHECKEDBOX Text:self.filterDataObj.titleTextStr withFont:getCustomFont(isIpad()? 21: 15) andColor:[UIColor colorWithHexString:self.filterDataObj.titleColor] isIconOnly:NO] forState:UIControlStateNormal];
        [self.titleButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_CHECKEDBOX Text:self.filterDataObj.titleTextStr withFont:getCustomFont(isIpad()? 21: 15) andColor:[UIColor colorWithHexString:self.filterDataObj.titleColor] isIconOnly:NO] forState:UIControlStateSelected];
        [self.dropDownButton addTarget:self action:@selector(dropDownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    }

    else{
        [self.titleButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_UNCHECKEDBOX Text:self.filterDataObj.titleTextStr withFont:DefualtFont(isIpad()? 23: 20) andColor:[UIColor colorWithHexString:self.filterDataObj.titleColor] isIconOnly:YES] forState:UIControlStateNormal];
        [self.titleButton setAttributedTitle:[self getAttributtedTextWithIcon:ICON_CHECKEDBOX Text:self.filterDataObj.titleTextStr withFont:DefualtFont(isIpad()? 23:20) andColor:[UIColor colorWithHexString:self.filterDataObj.titleColor]  isIconOnly:YES] forState:UIControlStateSelected];
        [self.dropDownButton removeTarget:nil action:@selector(dropDownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    }
    self.titleButton.selected = self.filterDataObj.isSelected;
    self.dropDownButton.selected = filterDataObj.isExpanded;
    
    [self.titleButton addTarget:self action:@selector(checkBoxTapped:) forControlEvents:UIControlEventTouchUpInside];

    if(self.filterDataObj.filterType == FilterTypeALL ||  self.filterDataObj.filterType == FilterTypeNONE){
        self.dropDownButton.hidden = YES;
    }
    else{
        self.dropDownButton.hidden = NO;
    }
}

-(NSMutableAttributedString *)getAttributtedTextWithIcon:(NSString *)icon Text:(NSString*)textStr withFont:(UIFont *)font andColor:(UIColor *)fontColor isIconOnly:(BOOL)isIconOnly{
    
    UIFont *font1 = DefualtFont(isIpad()? 22:18);
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:self.checkBoxIconColor,NSBaselineOffsetAttributeName:isIconOnly ? @2.2 : @-1.5};
    NSDictionary *dict2 = @{NSForegroundColorAttributeName:fontColor,NSFontAttributeName:font};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    if(isRTL())
    {
        dict1 = @{NSForegroundColorAttributeName:self.checkBoxIconColor,NSBaselineOffsetAttributeName:isIconOnly ? @2.2 : @-1.5,NSFontAttributeName:font1};
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\u200e%@",textStr]   attributes:dict2]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", icon]  attributes:dict1]];
    }
    else
    {
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   ", icon]  attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:textStr  attributes:dict2]];
    [attString addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 1)];
    }
    return  attString;
}


-(void)dropDownButtonTapped:(UIButton*)btn{
    self.filterDataObj.isExpanded = !self.filterDataObj.isExpanded;
    if(_dropDownAction != nil){
        _dropDownAction(self.filterDataObj);
    }
}

-(void)checkBoxTapped:(UIButton*)btn{
    self.filterDataObj.isSelected = !self.filterDataObj.isSelected;
    if(_checkBoxAction != nil){
        _checkBoxAction(self.filterDataObj);
    }
}

@end
