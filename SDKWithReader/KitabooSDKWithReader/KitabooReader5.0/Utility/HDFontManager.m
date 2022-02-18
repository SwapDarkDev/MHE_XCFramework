//
//  HDFontManager.m
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 29/06/20.
//  Copyright © 2020 Gaurav Bhatia. All rights reserved.
//

#import "HDFontManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>

//#define CustomFontNameForWeight @"OpenSans"

@implementation HDFontManager

//NSString *CustomFontNameForWeight = @"OpenSans";


-(UIFont*)getCustomFont:(CGFloat)size
{
    NSString *fontName = [NSString stringWithFormat:@"%@-Regular",CustomFontNameForWeight];
    UIFont *font = [UIFont fontWithName:fontName size:size];
    return font;
}

-(UIFont*)getCustomItalicFont:(CGFloat)size
{
    NSString *fontName = [NSString stringWithFormat:@"%@-Italic",CustomFontNameForWeight];
    UIFont *font = [UIFont fontWithName:fontName size:size];
    return font;
}

-(UIFont*)getCustomFontWith:(CGFloat)size with:(UIFontWeight)weight
{
    
        NSString *fontName;
        if (weight == UIFontWeightUltraLight||weight==UIFontWeightThin||weight==UIFontWeightLight)
        {
            fontName = [NSString stringWithFormat:@"%@-Light",CustomFontNameForWeight];
        }
        else if (weight==UIFontWeightRegular)
        {
            fontName = [NSString stringWithFormat:@"%@-Regular",CustomFontNameForWeight];
        }
        else if (weight==UIFontWeightMedium||weight==UIFontWeightSemibold)
        {
            fontName = [NSString stringWithFormat:@"%@-SemiBold",CustomFontNameForWeight];
        }
        else if (weight==UIFontWeightBold)
        {
            fontName = [NSString stringWithFormat:@"%@-Bold",CustomFontNameForWeight];
        }
        else if (weight==UIFontWeightHeavy||weight==UIFontWeightBlack)
        {
            fontName = [NSString stringWithFormat:@"%@-ExtraBold",CustomFontNameForWeight];
        }
        else if (weight==UIFontWeightHeavy||weight==UIFontWeightBlack)
        {
            fontName = [NSString stringWithFormat:@"%@-ExtraBold",CustomFontNameForWeight];
        }
        else
        {
            fontName = [NSString stringWithFormat:@"%@-Regular",CustomFontNameForWeight];
        }
        UIFont *font = [UIFont fontWithName:fontName size:size];
        return font;
}
-(UIFont*)getCustomItalicFontWith:(CGFloat)size{
    
        NSString *fontName = [NSString stringWithFormat:@"%@-Italic",CustomFontNameForWeight];
        UIFont *font = [UIFont fontWithName:fontName size:size];
        return font;
}
- (void)registerFont{
    [UIFont jbs_registerFontWithFilenameString:[HDKitabooFontManager getFontName] bundle:[NSBundle bundleForClass:[self class]]];
    [self registerOpenSansFontWith:[NSBundle bundleForClass:[self class]]];
}

- (void)registerFontWith:(NSBundle*)bundle{
    
    [UIFont jbs_registerFontWithFilenameString:[HDKitabooFontManager getFontName] bundle:bundle];
    
    [self registerOpenSansFontWith:bundle];
}

-(void)registerOpenSansFontWith : (NSBundle*)bundle
{
    if ([bundle pathForResource:@"OpenSans-SemiBold" ofType:@"ttf"])
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-SemiBold" bundle:bundle];
    }
    else
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-SemiBold" bundle:[NSBundle bundleForClass:[self class]]];
    }
    if ([bundle pathForResource:@"OpenSans-Light" ofType:@"ttf"])
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Light" bundle:bundle];
    }
    else
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Light" bundle:[NSBundle bundleForClass:[self class]]];
    }
    if ([bundle pathForResource:@"OpenSans-ExtraBold" ofType:@"ttf"])
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-ExtraBold" bundle:bundle];
    }
    else
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-ExtraBold" bundle:[NSBundle bundleForClass:[self class]]];
    }
    if ([bundle pathForResource:@"OpenSans-Bold" ofType:@"ttf"])
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Bold" bundle:bundle];
    }
    else
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Bold" bundle:[NSBundle bundleForClass:[self class]]];
    }
    if ([bundle pathForResource:@"OpenSans-Regular" ofType:@"ttf"])
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Regular" bundle:bundle];
    }
    else
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Regular" bundle:[NSBundle bundleForClass:[self class]]];
    }
    if ([bundle pathForResource:@"OpenSans-Italic" ofType:@"ttf"])
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Italic" bundle:bundle];
    }
    else
    {
        [UIFont jbs_registerFontWithFilenameString:@"OpenSans-Italic" bundle:[NSBundle bundleForClass:[self class]]];
    }
}
@end
