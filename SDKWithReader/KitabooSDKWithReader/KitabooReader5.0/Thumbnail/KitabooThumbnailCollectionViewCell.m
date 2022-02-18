//
//  ThumbnailCollectionViewCell.m
//  ThumnailCollections
//
//  Created by Gaurav on 30/01/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "KitabooThumbnailCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
//static const inline BOOL isIpad()
//{
//    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//}

@implementation KitabooThumbnailCollectionViewCell

@synthesize pageNumLabel=pageNumLabel;
@synthesize pageImageview=pageImageview;
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
    _pageSuperView = [[UIView alloc]init];
    [self addSubview:_pageSuperView];
    self.contentView.backgroundColor = [UIColor clearColor];
    pageNumLabel=[[UILabel alloc] init];
    [pageNumLabel setFont: getCustomFont(isIpad()?14:12)];
    pageNumLabel.textAlignment = NSTextAlignmentCenter;
    _chapterTitleLabel = [[UILabel alloc] init];
    [_chapterTitleLabel setFont:getCustomFontForWeight(isIpad()?14:13, UIFontWeightRegular)];
    _chapterTitleLabel.textAlignment = NSTextAlignmentNatural;
    [self addSubview:_chapterTitleLabel];
    [_pageSuperView addSubview:pageNumLabel];
    pageImageview = [[UIImageView alloc]init];
    [_pageSuperView addSubview:pageImageview];
    [_pageSuperView bringSubviewToFront:pageNumLabel];
    pageImageview.layer.borderWidth = 1;
//    pageImageview.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _pageNumLabelForHighlightedSection=[[UILabel alloc] init];
    [_pageNumLabelForHighlightedSection setFont: getCustomFont(isIpad()?14:12)];
    _pageNumLabelForHighlightedSection.textAlignment = NSTextAlignmentCenter;
    [_pageSuperView addSubview:_pageNumLabelForHighlightedSection];
    
    pageImageview.translatesAutoresizingMaskIntoConstraints = NO;
    pageNumLabel.translatesAutoresizingMaskIntoConstraints =NO;
    _chapterTitleLabel.translatesAutoresizingMaskIntoConstraints =NO;
    _pageSuperView.translatesAutoresizingMaskIntoConstraints =NO;
    _pageNumLabelForHighlightedSection.translatesAutoresizingMaskIntoConstraints =NO;
    pageImageview.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    [_pageSuperView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [_pageSuperView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [_pageSuperView.topAnchor constraintEqualToAnchor:_chapterTitleLabel.bottomAnchor constant: isIpad()?5:2].active = YES;
    [_pageSuperView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [pageImageview.leadingAnchor constraintEqualToAnchor:_pageSuperView.leadingAnchor constant:4].active = YES;
    [pageImageview.trailingAnchor constraintEqualToAnchor:_pageSuperView.trailingAnchor constant:-4].active = YES;
    [pageImageview.topAnchor constraintEqualToAnchor:_pageSuperView.topAnchor constant:4].active = YES;
    [pageImageview.bottomAnchor constraintEqualToAnchor:_pageSuperView.bottomAnchor constant:-4].active = YES;
    [pageNumLabel.topAnchor constraintEqualToAnchor:pageImageview.topAnchor constant:0].active = YES;
    [pageNumLabel.leadingAnchor constraintEqualToAnchor:pageImageview.leadingAnchor constant:0].active = YES;
    [pageNumLabel.heightAnchor constraintEqualToConstant:isIpad()?26:22].active = YES;
    [pageNumLabel.widthAnchor constraintGreaterThanOrEqualToConstant:isIpad()?28:22].active = YES;
    [_pageNumLabelForHighlightedSection.topAnchor constraintEqualToAnchor:_pageSuperView.topAnchor constant:0].active = YES;
    [_pageNumLabelForHighlightedSection.leadingAnchor constraintEqualToAnchor:_pageSuperView.leadingAnchor constant:0].active = YES;
    [_pageNumLabelForHighlightedSection.trailingAnchor constraintEqualToAnchor:pageNumLabel.trailingAnchor].active = YES;
    [_pageNumLabelForHighlightedSection.bottomAnchor constraintEqualToAnchor:pageNumLabel.bottomAnchor].active = YES;
    [_chapterTitleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:isIpad()?0:5].active = YES;
    [_chapterTitleLabel.leadingAnchor constraintEqualToAnchor:self.pageImageview.leadingAnchor constant:0].active = YES;
    [_chapterTitleLabel.heightAnchor constraintEqualToConstant:isIpad()?35:20].active = YES;
    [_chapterTitleLabel.trailingAnchor constraintEqualToAnchor:_pageSuperView.trailingAnchor constant:0].active = YES;
}
@end
