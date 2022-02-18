//
//  HDKitabooHLSDownloaderManager.h
//  KitabooSDKWithReader
//
//  Created by Jyoti Suthar on 12/01/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HDKitabooHLSDownloaderManagerDelegate <NSObject>

/** A delegate method called each time whenever a download task state is updated i.e Started, Downloading, Paused, Cancelled, Finished, Failed etc.
 * @param1 bookDownloadStatus The current state of a download task
 * @param2 progress  The current downloading progress of a download task
 * @param3 bookID  bookID string which is paused
 */
- (void)didDownloadHLSStateUpdate:(NSString *)bookDownloadStatus withBookDownloadProgress:(CGFloat)progress forBookID:(NSString *)bookID;

/** A delegate method called each time whenever any download task is failed due to any reason.
 * @param1 error  NSError for which the download has been failed.
 * @param2 bookDownloadStatus  The current state of a download task on failure. It will be "HLS Service Failed" when HLS URL service is failed and will be "Failed" when any error occured while downloading the task.
 * @param3 bookID  bookID string which is failed
 */
- (void)didDownloadHLSRequestFailWithError:(NSError *)error forState:(NSString *)bookDownloadStatus forBookID:(NSString *)bookID;

- (void)didDeleteHLSBookWithBookID:(NSString *)bookID;
@end

@interface HDKitabooHLSDownloaderManager : NSObject
+(instancetype)shared;

/**
 * Callback listener of type HDKitabooHLSDownloaderManagerDelegate
 */
@property (nonatomic, weak) id<HDKitabooHLSDownloaderManagerDelegate> delegate;
-(id)initWithBaseURL:(NSString *)baseURL clientID:(NSString *)clientID enableCDNCookies:(BOOL)enable;

-(id)initWithBaseURL:(NSString *)baseURL microServicesBaseUrl:(NSString *)microServicesBaseUrl clientID:(NSString *)clientID enableCDNCookies:(BOOL)enable;

/**
 * To Initialise HDKitabooHLSDownloaderManager Object.
 * @param1 baseURL Base URL.
 * @param2 clientID Client Id.
 */
-(id)initWithBaseURL:(NSString *)baseURL clientID:(NSString *)clientID;

/**
 * This method is called to download HLS Audio/Video Book.
 * @param1 userToken User Token.
 * @param2 bookID Book Id.
 * @param3 isAudioBook This parameter defines that the downloading book is an audio or video book.
 * @param3 thumbanilURL Book thumbnail URL.
 */
-(void)downloadHLSBookWithUserToken:(NSString *)userToken forBookID:(NSString *)bookID isAudioType:(BOOL)isAudioBook withBookThumbnailURL:(NSString*)thumbanilURL;

/**
 * This method is called when user wants to pause any downloading task.
 * @param1 bookId Book Id.
 */
-(void)pauseDownloadHLSBook:(NSString*)bookId;

/**
 * This method is called when user wants to cancel any downloading task.
 * @param1 bookId Book Id.
 */
-(void)cancelDownloadHLSBook:(NSString*)bookId;

/**
 * This method is called when user wants to resume any downloading task.
 * @param1 bookId Book Id.
 */
-(void)resumeDownloadHLSBook:(NSString*)bookId;

/**
 * This method is called to delete downloaded HLS Book.
 * @param1 bookID Book Id.
 */
-(void)deleteDownloadedHLSBook:(NSString *)bookID;

/**
 * This method is called to set delegate for specific Book.
 * @param1 bookId Book Id.
 */
-(void)setDelegateForBookId:(NSString *)bookId;

/**
 * This method will return true if book is downloaded and false when HLS book is not downloaded.
 */
-(BOOL)isHLSBookDownloaded:(NSString *)bookId;

/**
 * This method is called to get the downloaded path for book.
 * @param1 bookID Book Id.
 */
-(NSString *)getBookDownloadedPath:(NSString *)bookID;

/**
 * This method is called to get all the information for specific downloading HLS  book. HDAVAssetDownloadDetails is an object which contains all the details about the HLS downloding operation.
 * @param1 bookID Book Id.
 */
-(nullable HDAVAssetDownloadDetails *)getHLSBookDownloadDetails:(NSString *)bookID;

/**
 * This method is called to get all the information for all downloading HLS  books. HDAVAssetDownloadDetails is an object which contains all the details about the HLS downloding operation.
 */
-(nullable NSArray<HDAVAssetDownloadDetails *> *)getAllHLSBooksDownloadDetails;
@end

NS_ASSUME_NONNULL_END
