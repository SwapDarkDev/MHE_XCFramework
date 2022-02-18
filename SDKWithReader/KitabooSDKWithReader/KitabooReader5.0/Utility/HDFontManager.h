//
//  HDFontManager.h
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 29/06/20.
//  Copyright © 2020 Gaurav Bhatia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDFontManager : NSObject
-(UIFont*)getCustomFont:(CGFloat)size;
-(UIFont*)getCustomItalicFont:(CGFloat)size;
-(UIFont*)getCustomFontWith:(CGFloat)size with:(UIFontWeight)weight;
-(UIFont*)getCustomItalicFontWith:(CGFloat)size;
- (void)registerFont;
- (void)registerFontWith:(NSBundle*)bundle;
@end

NS_ASSUME_NONNULL_END
