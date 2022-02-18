//
//  ThumbnailCollectionViewCell.h
//  ThumnailCollections
//
//  Created by Gaurav on 30/01/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KitabooThumbnailCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *pageNumLabel;
@property (nonatomic,strong) UILabel *pageNumLabelForHighlightedSection;

@property (nonatomic,strong) UIImageView *pageImageview;
@property (nonatomic,strong) UILabel *chapterTitleLabel;

@property UIView *pageSuperView;
@end
