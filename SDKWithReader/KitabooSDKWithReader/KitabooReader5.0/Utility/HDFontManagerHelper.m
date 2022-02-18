//
//  HDFontManagerHelper.m
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 29/06/20.
//  Copyright © 2020 Gaurav Bhatia. All rights reserved.
//

#import "HDFontManagerHelper.h"
#import "HDFontManager.h"

@implementation HDFontManagerHelper{
    HDFontManager* fontManager;
    NSBundle *fontBundle;
}

-(void)setFontBundle:(NSBundle *)bundle
{
    fontBundle = bundle;
}

-(NSBundle *) getFontBundle
{
    if(fontBundle)
    {
        return fontBundle;
    }
    else
    {
        return [NSBundle bundleForClass:[self class]];
    }
}

+ (HDFontManagerHelper *)getInstance
{
    static HDFontManagerHelper *fontManagerHelp=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      fontManagerHelp = [[self alloc] init];
                  });
    return fontManagerHelp;
}

-(void)setFontManager:(HDFontManager*)manager
{
    if (fontBundle)
    {
        [self setFontManager:manager withBundle:fontBundle];
        return;
    }
    if (!fontManager)
    {
        fontManager = manager;
        [fontManager registerFont];
    }
    fontManager = manager;
}

-(void)setFontManager:(HDFontManager*)manager withBundle:(NSBundle*)bundle
{
    fontManager = manager;
    [fontManager registerFontWith:bundle];
}

-(HDFontManager*)getFontManager
{
    if (fontBundle)
    {
        return [self getFontManagerFor:fontBundle];
    }
    if (!fontManager) {
        fontManager = [[HDFontManager alloc] init];
        [fontManager registerFont];
    }
    return fontManager;
}

-(HDFontManager*)getFontManagerFor:(NSBundle*)bundle
{
    if (!fontManager) {
        fontManager = [[HDFontManager alloc] init];
        [fontManager registerFontWith:bundle];
    }
    return fontManager;
}

@end
