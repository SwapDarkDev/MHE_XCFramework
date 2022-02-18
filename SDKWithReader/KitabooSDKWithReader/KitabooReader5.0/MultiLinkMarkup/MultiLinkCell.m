//
//  MultiLinkCell.m
//  KItabooSDK
//
//  Created by amol shelke on 12/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import "MultiLinkCell.h"

@implementation MultiLinkCell
{
    CGFloat _width;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier linkIconWidth:(CGFloat)width
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _width=width;
        _linkIcon = [[UILabel alloc]init];
        [_linkIcon setTextAlignment:NSTextAlignmentCenter];
        _linkIcon.layer.masksToBounds=YES;
        _linkIcon.layer.cornerRadius= width/2;
        [self addSubview:_linkIcon];
        _linkIcon.translatesAutoresizingMaskIntoConstraints = NO;
        
        _linkName = [[UILabel alloc]init];
        [self addSubview:_linkName];
        _linkName.translatesAutoresizingMaskIntoConstraints=NO;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkIcon attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkName attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual toItem:_linkIcon attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkName attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_linkName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
