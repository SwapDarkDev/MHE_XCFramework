//
//  SampleReaderDownloadController.h
//  KitabooSDKWithReaderDemo
//
//  Created by Sumanth Myrala on 15/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SampleReaderDownloadControllerDelegate <NSObject>

/**
* This method will be called when the book is successfully unzipped
* @param1 bookID This is the be specific book that has been unzipped
*/
- (void)didBookUnzippedForBookID:(NSString *)bookID;

/**
* This method will be called when the unzipping of the book has failed
* @param1 bookID The specific book that has been failed to unzip
*/
- (void)didBookUnzipFailedWithError:(NSError *)error forBookID:(NSString *)bookID;


/**
* This method will be called to update status of the specific book that has been downloading
* @param1 text The text represents that the download status of the book that needs to be updated on UI accordingly
* @param2 progress The progress text represents the current and total download size of the book
* @param3 bookID The specific book that has been downloading
*/
- (void)didUpdateDownloadStatus:(NSString *)text withDownloadProgress:(NSString *)progress forBookID:(NSString *)bookID;

/**
 * This method will be called when the book download has been failed.
 * @param1 error NSError object with which book download has been failed.
 */
- (void)didBookDownloadFailedWithError:(NSError *)error forBookID:(NSString *)bookID;


@end

/**
 * SampleReaderDownloadController will be responsible to handle the delegates & implementation of HDBookDownloaderManager & HDBookUnZipManager.
 * @superclass SuperClass : UIViewController
 */
@interface SampleReaderDownloadController : UIViewController

/**
* This method should be called to download any specific book
* @param1 bookID This should be specific bookID that needs to be downloaded
* @param2 userToken This should be userToken of current loggedin user.
* @param3 formatName This should be specific format name of book that needs to be downloaded
* @param4 isHLSBook To check the book type whether it is a HLS media(Audio/Video) book or eBook.
* @param5 isAudioBook To check the book type whether it is an Audio book or Video book.
* @param6 user KitabooUser Object.
* @param7 thumbanilURL Audio Book Thumbnail URL.
*/
- (void)downloadBookForBookID:(NSString *)bookID forUserToken:(NSString *)userToken forFormat:(NSString *)formatName isHLSBook:(BOOL)isHLSBook isAudioBook:(BOOL)isAudioBook kitabooUser:(KitabooUser*)user withAudioBookThumbnailURL:(NSString*)thumbanilURL;

/**
* This method should be called to Pause any specific book
* @param1 bookID This should be specific bookID that needs to be Paused
* @param2 isHLSBook To check the book type whether it is a HLS media(Audio/Video) book or eBook.
*/
- (void)pauseBookWithBookID:(NSString *)bookID isHLSBook:(BOOL)isHLSBook;


/**
* This method will return true if book is downloaded and false when HLS book is not downloaded.
*/
-(BOOL)isHLSBookDownloaded:(NSString *)bookID;

/**
 * Callback listener of type SampleReaderDownloadControllerDelegate
 */
@property (nonatomic, weak) id<SampleReaderDownloadControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
