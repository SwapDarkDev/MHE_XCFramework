//
//  HDReflowableReaderConfiguration.h
//  KItabooSDK
//
//  Created by Jyoti Suthar on 10/12/19.
//  Copyright © 2019 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HSRendrerConstant.h"
#import "EPUBBookVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDReflowableReaderConfiguration : NSObject

+ (instancetype)sharedInstance;
-(void)setReflowableReaderMode:(READER_MODE)readerMode;
-(void)setReflowableFontSize:(FONT_SIZE)fontSize;
-(void)setReflowableTextAlignment:(TEXT_ALIGNMENT)textAlignment;
-(void)setReflowableLineSpacing:(TEXT_LINESPACING)lineSpacing;
-(void)setReflowableMargin:(READER_MARGIN)margin;
-(void)setReflowableFontFamily:(NSString *)fontFamily;
-(void)setReflowablePagination:(BOOL)pagination;

-(READER_MODE)getReflowableReaderMode;
-(TEXT_ALIGNMENT)getReflowableTextAlignment;
-(FONT_SIZE)getReflowableFontSize;
-(TEXT_LINESPACING)getReflowableLineSpacing;
-(READER_MARGIN)getReflowableMargin;
-(NSString *)getReflowableFontFamily;
-(BOOL)getReflowablePagination;
-(void)reflowableReaderDefaultConfiguration;
-(CGFloat)getReflowableBrightnessValue;
-(void)setReflowableBrightnessValue:(CGFloat)brightnessValue;
-(void)setReaderFontSetting:(ReaderFontSetting *)defaultFontSetting;
@end

NS_ASSUME_NONNULL_END
