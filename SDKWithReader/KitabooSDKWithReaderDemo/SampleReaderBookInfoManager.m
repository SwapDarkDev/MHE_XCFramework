//
//  SampleReaderBookInfoManager.m
//  KitabooSDKWithReaderDemo
//
//  Created by Sumanth Myrala on 15/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import "SampleReaderBookInfoManager.h"

@implementation SampleReaderBookInfoManager

+ (SampleReaderBookInfoManager *)getInstance
{
    static SampleReaderBookInfoManager *bookInfoManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      bookInfoManager = [[self alloc] init];
                  });
    return bookInfoManager;
}

- (id)init
{
    self = [super init];
    if (self){
    }
    return self;
}

- (BOOL)isBookDownloadedForBookID:(NSString *)bookID
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:bookID] isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] objectForKey:bookID])
    {
        return YES;
    }
    return NO;
}

- (void)updateBookDownloadStatus:(BOOL)isDownloaded forBookID:(NSString *)bookID
{
    if (isDownloaded)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"bookDownloaded" forKey:bookID];
    }
}

@end
