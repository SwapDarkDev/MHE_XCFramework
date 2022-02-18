//
//  SampleReaderDownloadController.m
//  KitabooSDKWithReaderDemo
//
//  Created by Sumanth Myrala on 15/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import "SampleReaderDownloadController.h"
#import "SampleReaderConfigurationData.h"
#import "SampleReaderBookInfoManager.h"
#import "HDKitabooHLSDownloaderManager.h"

#define HLS_Auth_URL  @"https://read.kitaboo.com/"
@interface SampleReaderDownloadController ()<HDBookDownloaderManagerDelegate,HDBookUnZipManagerDelegate, HDKitabooHLSDownloaderManagerDelegate> {
    HDKitabooHLSDownloaderManager *hlsDownloaderManager;
}
@end

@implementation SampleReaderDownloadController

- (instancetype)init
{
    self = [super init];
    if (self) {
        hlsDownloaderManager = [[HDKitabooHLSDownloaderManager alloc] initWithBaseURL:[[SampleReaderConfigurationData getInstance] getBaseURL] microServicesBaseUrl:[[SampleReaderConfigurationData getInstance] getMicroServicesBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID] enableCDNCookies:NO];
        hlsDownloaderManager.delegate = self;
    }
    return self;
}

#pragma mark View Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Book Download Methods

//This method should be called to download any specific book
//Note: We haven't called the Consume and Release API for book download in this SampleReader. Consume API should be called after the book is downloaded and Release service should be called after the book is deleted from device.
- (void)downloadBookForBookID:(NSString *)bookID forUserToken:(NSString *)userToken forFormat:(NSString *)formatName isHLSBook:(BOOL)isHLSBook isAudioBook:(BOOL)isAudioBook kitabooUser:(KitabooUser*)user withAudioBookThumbnailURL:(NSString*)thumbanilURL{
    if (isHLSBook) {
        [hlsDownloaderManager downloadHLSBookWithUserToken:user.userToken forBookID:bookID isAudioType:isAudioBook withBookThumbnailURL:thumbanilURL];
    }else {
        [self downloadEBook:bookID forUserToken:userToken forFormat:formatName];
    }
}

-(void)downloadEBook:(NSString *)bookID forUserToken:(NSString *)userToken forFormat:(NSString *)formatName {
    HDBookDownloadDetails *model = [HDBookDownloaderManager.shared getDownloadDetails:bookID];
    NSString *progress = [NSString stringWithFormat:@"%.1f%@ / %.1f%@",model.downloadedBookSize,model.downloadedBookUnit,model.bookDownloadSize,model.bookDownloadUnit];
    if ([model.bookDownloadState isEqualToString:@"Paused"]) {
        if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
            [_delegate didUpdateDownloadStatus:@"Resume" withDownloadProgress:progress forBookID:model.bookUniqueID];
        }
        [HDBookDownloaderManager.shared resumeBookDownload:bookID delegate:self];
    }else if ([model.bookDownloadState isEqualToString:@"Downloading"]) {
        if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
            [_delegate didUpdateDownloadStatus:@"Pause" withDownloadProgress:progress forBookID:model.bookUniqueID];
        }
        [HDBookDownloaderManager.shared pauseBookDownload:bookID delegate:self];
    }else if ([model.bookDownloadState isEqualToString:@"Failed"]) {
        if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)])
        {
            [_delegate didUpdateDownloadStatus:@"Retrying" withDownloadProgress:@"" forBookID:model.bookUniqueID];
        }
        [HDBookDownloaderManager.shared retryBookDownload:bookID delegate:self];
    }else {
        KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:[[SampleReaderConfigurationData getInstance] getBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID]];
        [kitabooServiceInterface downloadBookURLWith:userToken bookId:[bookID integerValue] formatType:formatName successHandler:^(NSDictionary *dic){
            
            BOOL isFreeSpaceAvailable = [self getIfDeviceHasSpaceToDownloadTheBook:[NSString stringWithFormat:@"%@",[dic valueForKey:@"fileSize"]]];
            if (isFreeSpaceAvailable) {
                [HDBookDownloaderManager.shared downloadBook:bookID bookDownloadURL:[dic valueForKey:@"responseMsg"] delegate:self downloadPath:[self getBookDownloadPathForBook:bookID]];
            }
        }failureHandler:^(NSError *error) {
            if ([self->_delegate respondsToSelector:@selector(didBookDownloadFailedWithError:forBookID:)]) {
                [self->_delegate didBookDownloadFailedWithError:error forBookID:bookID];
            }
        }];
    }
}

- (void)pauseBookWithBookID:(NSString *)bookID isHLSBook:(BOOL)isHLSBook {
    if (isHLSBook) {
        HDAVAssetDownloadDetails *model = [hlsDownloaderManager getHLSBookDownloadDetails:bookID];
        NSInteger percentage = 100 * model.progress;
        NSString *progress = [NSString stringWithFormat:@"%ld",(long)percentage];
        progress = [progress stringByAppendingString:@"%"];
        if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
            [_delegate didUpdateDownloadStatus:@"Pause" withDownloadProgress:progress forBookID:model.bookUniqueID];
        }
        [hlsDownloaderManager pauseDownloadHLSBook:bookID];
    }else {
        HDBookDownloadDetails *model = [HDBookDownloaderManager.shared getDownloadDetails:bookID];
        NSString *progress = [NSString stringWithFormat:@"%.1f%@ / %.1f%@",model.downloadedBookSize,model.downloadedBookUnit,model.bookDownloadSize,model.bookDownloadUnit];
        if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
            [_delegate didUpdateDownloadStatus:@"Pause" withDownloadProgress:progress forBookID:model.bookUniqueID];
        }
        [HDBookDownloaderManager.shared pauseBookDownload:bookID delegate:self];
    }
}

-(BOOL)isHLSBookDownloaded:(NSString *)bookID {
    return [hlsDownloaderManager isHLSBookDownloaded:bookID];
}

#pragma mark HDBookDownloaderManagerDelegate Methods
- (void)bookDownloadRequestStarted:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    [self updateViewForDownloadModel:downloadModel];
}

-(void)bookDownloadRequestDidUpdateProgress:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    [self updateViewForDownloadModel:downloadModel];
}

- (void)bookDownloadRequestDidPaused:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    [self updateViewForDownloadModel:downloadModel];
}

- (void)bookDownloadRequestDidResumed:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    [self updateViewForDownloadModel:downloadModel];
}

- (void)bookDownloadRequestDidRetry:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    [self updateViewForDownloadModel:downloadModel];
}

-(void)bookDownloadRequestFinished:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)])
    {
        [_delegate didUpdateDownloadStatus:@"Unzipping" withDownloadProgress:@"" forBookID:downloadModel.bookUniqueID];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
        HDBookUnZipManager *zipManager = [[HDBookUnZipManager alloc] init];
        [zipManager unzipFileAtPath:[downloadModel.bookDownloadDestinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.completed",bookID]] toDestination:[self getUnzippedBookPathForBook:bookID] overwrite:YES password:nil error:&error delegate:self];
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self->_delegate respondsToSelector:@selector(didBookUnzipFailedWithError:forBookID:)])
                {
                    [self->_delegate didBookUnzipFailedWithError:error forBookID:bookID];
                }
            });
        }
    });
}

- (void)bookDownloadRequestCanceled:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID
{
    
}

- (void)bookDownloadRequestDidPopulatedInterruptedTasks:(NSArray<HDBookDownloadDetails *> *)downloadModel
{
    
}

- (void)bookDownloadRequestDidFailedWithError:(NSError * _Nonnull)error bookDownloadDetail:(HDBookDownloadDetails * _Nonnull)bookDownloadDetail bookID:(NSString * _Nonnull)bookID
{
    
}

- (void)bookDownloadRequestDestinationDoestNotExists:(HDBookDownloadDetails *)downloadModel bookID:(NSString *)bookID location:(NSURL *)location
{
    
}

#pragma mark HDBookUnZipManagerDelegate Methods
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path
{
    
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path unzippedPath:(NSString *)unzippedPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SampleReaderBookInfoManager getInstance] updateBookDownloadStatus:YES forBookID:[[path stringByDeletingLastPathComponent] lastPathComponent]];
        NSString *bookDownloadedPath = [self getBookDownloadPathForBook:[[path stringByDeletingLastPathComponent] lastPathComponent]];
        NSString *zippedPath = [bookDownloadedPath stringByAppendingString:[NSString stringWithFormat:@"/%@.completed",[[path stringByDeletingLastPathComponent] lastPathComponent]]];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:zippedPath error:&error];
        if ([self->_delegate respondsToSelector:@selector(didBookUnzippedForBookID:)])
        {
            [self->_delegate didBookUnzippedForBookID:[[path stringByDeletingLastPathComponent] lastPathComponent]];
        }
    });
}

#pragma mark Utility Methods

//This method should be called to check whether the memory space is available to download the book.
-(BOOL)getIfDeviceHasSpaceToDownloadTheBook:(NSString *)bookSize
{
    if(bookSize == nil)
    {
        return YES;
    }
    NSFileManager* filemgr = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    
    NSDictionary* fsAttr = [filemgr attributesOfFileSystemForPath:docDirectory error:NULL];
    
    unsigned long long freeSize = [(NSNumber*)[fsAttr objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    if (freeSize < [bookSize longLongValue]*2)
    {
        return NO;
    }
    return YES;
}

//This method should be called to get the download path of the book that will be downloaded.
- (NSString *)getBookDownloadPathForBook:(NSString *)bookID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *bookDownloadPath = [[libraryPath objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/BOOKS/%@",bookID]];
    if ((![fileManager fileExistsAtPath:bookDownloadPath]))
    {
        [fileManager createDirectoryAtPath:bookDownloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return bookDownloadPath;
}

//This method should be called to get the unzipped path of the book after download.
- (NSString *)getUnzippedBookPathForBook:(NSString *)bookID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *unzippedPath = [[libraryPath objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/BOOKS/%@",bookID]];
    if (![fileManager fileExistsAtPath:unzippedPath])
    {
        [fileManager createDirectoryAtPath:unzippedPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return unzippedPath;
}

//This method should be called to update the delegates with current download status of the book
- (void)updateViewForDownloadModel:(HDBookDownloadDetails *)downloadModel
{
    if (downloadModel)
    {
        if (downloadModel.task.taskDescription.pathComponents.count >= 4)
        {
            downloadModel.bookDownloadDestinationPath = [self getBookDownloadPathForBook:downloadModel.bookUniqueID];
            [[HDBookDownloaderManager shared] setDelegateForBookWithDelegate:self bookID:downloadModel.bookUniqueID];
        }
    }
    if (downloadModel.downloadedBookSize > 0)
    {
        NSString *progress = [NSString stringWithFormat:@"%.1f%@/%.1f%@",downloadModel.downloadedBookSize,downloadModel.downloadedBookUnit,downloadModel.bookDownloadSize,downloadModel.bookDownloadUnit];
        NSLog(@"Print the progress %@",progress);
        if (downloadModel)
        {
            if ([downloadModel.bookDownloadState isEqualToString:@"Paused"])
            {
                if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)])
                {
                    [_delegate didUpdateDownloadStatus:@"Resume" withDownloadProgress:progress forBookID:downloadModel.bookUniqueID];
                }
            }
            else if ([downloadModel.bookDownloadState isEqualToString:@"Downloading"])
            {
                if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)])
                {
                    [_delegate didUpdateDownloadStatus:@"Pause" withDownloadProgress:progress forBookID:downloadModel.bookUniqueID];
                }
            }
            else if ([downloadModel.bookDownloadState isEqualToString:@"Failed"])
            {
                if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)])
                {
                    [_delegate didUpdateDownloadStatus:@"Retry" withDownloadProgress:progress forBookID:downloadModel.bookUniqueID];
                }
            }
        }
    }
}

#pragma mark HDKitabooHLSDownloaderManagerDelegate Methods
- (void)didDownloadHLSStateUpdate:(NSString *)bookDownloadStatus withBookDownloadProgress:(CGFloat)progress forBookID:(NSString *)bookID {
    if ([bookDownloadStatus isEqualToString:@"Finished"]) {
        if ([self->_delegate respondsToSelector:@selector(didBookUnzippedForBookID:)]) {
            [self->_delegate didBookUnzippedForBookID:bookID];
        }
    }else if([bookDownloadStatus isEqualToString:@"Failed"]) {
        
    }else {
        [self updateViewForDownloadHLSWithBookID:bookID];
    }
}

- (void)didDownloadHLSRequestFailWithError:(NSError *)error forState:(NSString *)bookDownloadStatus forBookID:(NSString *)bookID {
    
}

- (void)updateViewForDownloadHLSWithBookID:(NSString *)bookID {
    HDAVAssetDownloadDetails *downloadModel = [hlsDownloaderManager getHLSBookDownloadDetails:bookID];
    NSInteger percentage = 100 * downloadModel.progress;
    NSString *progress = [NSString stringWithFormat:@"%ld",(long)percentage];
    progress = [progress stringByAppendingString:@"%"];
    NSLog(@"Print the progress %@",progress);
    if (downloadModel) {
        if ([downloadModel.bookDownloadState isEqualToString:@"Paused"]) {
            if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
                [_delegate didUpdateDownloadStatus:@"Downloading" withDownloadProgress:progress forBookID:downloadModel.bookUniqueID];
            }
        }else if ([downloadModel.bookDownloadState isEqualToString:@"Started"] || [downloadModel.bookDownloadState isEqualToString:@"Downloading"]) {
            if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
                [_delegate didUpdateDownloadStatus:@"Downloading" withDownloadProgress:progress forBookID:downloadModel.bookUniqueID];
            }
        }else if ([downloadModel.bookDownloadState isEqualToString:@"Failed"]) {
            if ([_delegate respondsToSelector:@selector(didUpdateDownloadStatus:withDownloadProgress:forBookID:)]) {
                [_delegate didUpdateDownloadStatus:@"Download" withDownloadProgress:progress forBookID:downloadModel.bookUniqueID];
            }
        }
    }
}

@end
