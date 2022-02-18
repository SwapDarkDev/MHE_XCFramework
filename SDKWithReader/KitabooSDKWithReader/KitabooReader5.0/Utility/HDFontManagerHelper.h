//
//  HDFontManagerHelper.h
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 29/06/20.
//  Copyright © 2020 Gaurav Bhatia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDFontManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDFontManagerHelper : NSObject
+ (HDFontManagerHelper *)getInstance;
-(void)setFontManager:(HDFontManager*)manager;
-(HDFontManager*)getFontManager;
-(void)setFontBundle:(NSBundle *)bundle;
-(NSBundle *) getFontBundle;
@end

NS_ASSUME_NONNULL_END
