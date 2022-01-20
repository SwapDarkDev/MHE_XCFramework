//
//  PdfLineExtractVO.h
//  Kitaboo
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PdfWordExtractVO.h"
#import <UIKit/UIKit.h>
#import "UGCLabel.h"

@interface PdfLineExtractVO : NSObject

@property (nonatomic) NSInteger lineID;
@property (assign, nonatomic) float lineY;
@property (assign, nonatomic) float lineX;
@property (nonatomic) NSInteger paraID;
@property (nonatomic, retain) NSMutableArray *extractWords;
@property (nonatomic, retain) NSMutableString *lineText;
@property (nonatomic) CGRect transformedFrame;
@property (nonatomic) CGRect highlightedRect;
@property (nonatomic) CGRect savedHighlightedRect;

- (void)addExtractedWord:(PdfWordExtractVO *)word;
- (CGRect)getFrameOnCropBox;
- (NSInteger)getStartWordId;
- (NSInteger)getEndWordId;
- (PdfWordExtractVO *)getClosestWordToPosition:(float) xPosition;
- (PdfWordExtractVO *)getClosestWordToRect:(CGRect)frame;
- (PdfWordExtractVO *)getWordByWordID:(NSInteger) wordId;
- (CGRect)getSelectionRectForMinX:(CGPoint)min andMax:(CGPoint)max withStartLineID:(NSInteger) startlineID andEndLineID:(NSInteger) endLineID;
- (NSString *)getSelectionTextForMinX:(CGPoint)min andMax:(CGPoint)max withStartLineID:(NSInteger) startlineID andEndLineID:(NSInteger) endLineID;
- (UIView *)getHighlightForRect:(CGRect)selectedRect withBGColor:(UIColor *)color;
- (UGCLabel *)getSelectedHighlightedViewForRect:(CGRect)selectedRect withBGColor:(UIColor *)color;
- (BOOL)checkPointWithinSelectionLine:(CGPoint) point;
- (PdfWordExtractVO*) getWordThatContainsPoint:(CGPoint)point;
@end
