//
//  PdfExtractVO.h
//  Kitaboo
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PdfWordExtractVO : NSObject

@property (assign, nonatomic) NSInteger paraID;
@property (assign, nonatomic) NSInteger lineID;
@property (assign, nonatomic) float lineY;
@property (assign, nonatomic) float lineH;
@property (assign, nonatomic) NSInteger wordID;
@property (assign, nonatomic) float wordX;
@property (assign, nonatomic) float wordW;
@property (strong, nonatomic) NSArray *charWidths;
@property (strong, nonatomic) NSString *wordText;
@property (assign, nonatomic) CGRect frameOnCropBox;
@property (assign, nonatomic) CGRect transformedFrame;
@property (nonatomic, strong) UIView *highlightedView;
@property (nonatomic, strong) UIView *savedHighlightedView;
@end
