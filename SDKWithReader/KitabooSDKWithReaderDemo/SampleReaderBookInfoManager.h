//
//  SampleReaderBookInfoManager.h
//  KitabooSDKWithReaderDemo
//
//  Created by Sumanth Myrala on 15/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
* SampleReaderBookInfoManager will be responsible to save the BookInfo i.e,to save that the book has been downloaded
* @superclass SuperClass : NSObject
*/
@interface SampleReaderBookInfoManager : NSObject

/**
* This method should be called to get the instance of the SampleReaderBookInfoManager
*/
+ (SampleReaderBookInfoManager *) getInstance;

/**
* This method will be called to check whether specific book has been downloaded or not.
* @param1 bookID The specific book that needs to be checked whether it has been downloaded
*/
- (BOOL)isBookDownloadedForBookID:(NSString *)bookID;

/**
* This method will be called to save the download status of the specific book
* @param1 isDownloaded A boolean that specifies whether the book is downloaded or not.
* @param2 bookID The specific book that needs to be updated.
*/
- (void)updateBookDownloadStatus:(BOOL)isDownloaded forBookID:(NSString *)bookID;

@end

NS_ASSUME_NONNULL_END
