//
//  TeacherAnnotationViewCell.m
//  Kitaboo
//
//  Created by Hurix System on 26/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "TeacherAnnotationViewCell.h"
#import "Constant.h"

@implementation TeacherAnnotationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.classButton=[[UILabel alloc]init];
    self.classButton.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:self.classButton];
    [self.classButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active=YES;
    [self.classButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0].active=YES;
    [self.classButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0].active=YES;
    [self.classButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4].active=YES;
    self.classButton.textAlignment=NSTextAlignmentCenter;
    [self.classButton setFont:getCustomFont(20)];
    self.classButton.textColor=UIColor.blackColor;
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self constructUI];
    }
    return self;
}
- (void)constructUI
{
    self.classButton=[[UILabel alloc]init];
    self.classButton.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:self.classButton];
    [self.classButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active=YES;
    [self.classButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0].active=YES;
    [self.classButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0].active=YES;
    [self.classButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4].active=YES;
    self.classButton.textAlignment=NSTextAlignmentCenter;
    [self.classButton setFont:getCustomFont(20)];
    self.classButton.textColor=UIColor.blackColor;
}


@end
