//
//  HDKitabooHLSDownloaderManager.m
//  KitabooSDKWithReader
//
//  Created by Jyoti Suthar on 12/01/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

#import "HDKitabooHLSDownloaderManager.h"
#import "SystemInformation.h"

@interface HDKitabooHLSDownloaderManager()<HDAVAssetDownloaderManagerDelegate> {
    NSString *_baseURL;
    NSString *_clientId;
    NSString *_microServicesBaseUrl;
    BOOL enableCDNCookies;
}
@end

@implementation HDKitabooHLSDownloaderManager

-(id)initWithBaseURL:(NSString *)baseURL clientID:(NSString *)clientID {
    _baseURL = baseURL;
    _clientId = clientID;
    return self;
}

-(id)initWithBaseURL:(NSString *)baseURL clientID:(NSString *)clientID enableCDNCookies:(BOOL)enable{
    _baseURL = baseURL;
    _clientId = clientID;
    enableCDNCookies = enable;
    return self;
}

-(id)initWithBaseURL:(NSString *)baseURL microServicesBaseUrl:(NSString *)microServicesBaseUrl clientID:(NSString *)clientID enableCDNCookies:(BOOL)enable {
    _baseURL = baseURL;
    _clientId = clientID;
    _microServicesBaseUrl = microServicesBaseUrl;
    enableCDNCookies = enable;
    return self;
}

+(instancetype)shared {
    static HDKitabooHLSDownloaderManager *instance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[HDKitabooHLSDownloaderManager alloc]init];
    });
    return instance;
}

-(void)downloadHLSBookWithUserToken:(NSString *)userToken forBookID:(NSString *)bookID isAudioType:(BOOL)isAudioBook withBookThumbnailURL:(NSString*)thumbanilURL{
    HDAVAssetDownloadDetails *bookDownloadDetails = [HDAVAssetDownloaderManager.shared getAVAssetDetails:bookID];
    if (bookDownloadDetails != nil) {
        if ([bookDownloadDetails.bookDownloadState isEqualToString:@"Paused"]) {
            [HDAVAssetDownloaderManager.shared resumeAVAsset:bookID delegate:self];
        }else if ([bookDownloadDetails.bookDownloadState isEqualToString:@"Started"] || [bookDownloadDetails.bookDownloadState isEqualToString:@"Downloading"]) {
            [HDAVAssetDownloaderManager.shared pauseAVAsset:bookID delegate:self];
        }else {
            if ([bookDownloadDetails.bookDownloadState isEqualToString:@"Failed"]) {
                [HDAVAssetDownloaderManager.shared cancelAVAsset:bookID delegate:self];
            }
            [self startDownloadWithUserToken:userToken forBookID:bookID withBookFormatType:isAudioBook withBookThumbnailURL:thumbanilURL];
        }
    }else{
        [self startDownloadWithUserToken:userToken forBookID:bookID withBookFormatType:isAudioBook withBookThumbnailURL:thumbanilURL];
    }
}

-(void)startDownloadWithUserToken:(NSString *)userToken forBookID:(NSString *)bookID withBookFormatType:(BOOL)isAudioBook withBookThumbnailURL:(NSString*)thumbanilURL{
    if ([self isHLSBookDownloaded:bookID]) {
        [_delegate didDownloadHLSStateUpdate:@"Finished" withBookDownloadProgress:1 forBookID:bookID];
    }else {
        [self fetchHLSMediaURLWithUserToken:userToken forBookID:bookID withBookFormatType:isAudioBook withBookThumbnailURL:thumbanilURL];
    }
}

-(BOOL)isHLSBookDownloaded:(NSString *)bookId {
    return [HDAVAssetDownloaderManager.shared isAVAssetDownloaded:bookId];
}

-(void)fetchHLSMediaURLWithUserToken:(NSString *)userToken forBookID:(NSString *)bookID withBookFormatType:(BOOL)isAudioBook withBookThumbnailURL:(NSString*)thumbanilURL{
    HDKitabooHLSServiceInterface *interface = [[HDKitabooHLSServiceInterface alloc] init:_baseURL microServicesBaseUrl:_microServicesBaseUrl clientID:_clientId enableCDNCookies:enableCDNCookies IsKitabooContentServer:YES];
    NSNumber *timeStamp = [NSNumber numberWithInteger:([[NSDate alloc] initWithTimeIntervalSinceNow:0].timeIntervalSince1970)];
    NSString *localDowloadPath = [self getBookDownloadedPath:bookID];
    [interface fetchHLSMediaBookDownloadURL:userToken bookId:[NSNumber numberWithInteger:bookID.integerValue] timeStamp:timeStamp isHLSOnlineStreaming:false  successHandler:^(NSString * baseURLString, NSDictionary *cookies) {
        [interface fetchHLSM3U8URLs:baseURLString isHLSAudio:isAudioBook hlsMetaDataDownloadablePath:localDowloadPath withAudioThumbnailURL:thumbanilURL successHandler:^(NSArray<NSURL *> * m3u8URLs) {
            [HDAVAssetDownloaderManager.shared downloadAVAsset:bookID bookDownloadURLs:m3u8URLs delegate:self];
        } failureHandler:^(NSError * error) {
            [_delegate didDownloadHLSRequestFailWithError:error forState:@"HLS Service Failed" forBookID:bookID];
        }];
    } failureHandler:^(NSError * error) {
        [_delegate didDownloadHLSRequestFailWithError:error forState:@"HLS Service Failed" forBookID:bookID];
    }];
}

-(NSString *)getBookDownloadedPath:(NSString *)bookID {
    NSString *localDowloadPath = [[SystemInformation getInstance] getBasePathForBookWithBookId:[NSNumber numberWithInteger:bookID.integerValue]];
    return localDowloadPath;
}

-(void)pauseDownloadHLSBook:(NSString *)bookId {
    HDAVAssetDownloadDetails *bookDownloadDetails = [HDAVAssetDownloaderManager.shared getAVAssetDetails:bookId];
    if (![bookDownloadDetails.bookDownloadState isEqual: @"Failed"]){
        [HDAVAssetDownloaderManager.shared pauseAVAsset:bookId delegate:self];
    }
}

- (void)cancelDownloadHLSBook:(NSString *)bookId {
    [HDAVAssetDownloaderManager.shared cancelAVAsset:bookId delegate:self];
}

- (void)resumeDownloadHLSBook:(NSString *)bookId {
    [HDAVAssetDownloaderManager.shared resumeAVAsset:bookId delegate:self];
}

-(nullable HDAVAssetDownloadDetails *)getHLSBookDownloadDetails:(NSString *)bookID {
    HDAVAssetDownloadDetails *details = [HDAVAssetDownloaderManager.shared getAVAssetDetails:bookID];
    if (details != nil) {
        return details;
    }
    return nil;
}

-(nullable NSArray<HDAVAssetDownloadDetails *> *)getAllHLSBooksDownloadDetails {
    NSArray<HDAVAssetDownloadDetails *> *details =  [HDAVAssetDownloaderManager.shared getAllAVAssetDetails];
    if (details.count > 0) {
        return details;
    }
    return nil;
}

-(void)deleteDownloadedHLSBook:(NSString *)bookID {
    [HDAVAssetDownloaderManager.shared deleteAVAsset:bookID delegate:self];
}

-(void)setDelegateForBookId:(NSString *)bookId {
    [HDAVAssetDownloaderManager.shared setDelegateForAVAssetWithDelegate:self bookID:bookId];
}
- (void)didDownloadRequestStateUpdateForAVAsset:(HDAVAssetDownloadDetails *)bookDownloadDetail bookID:(NSString *)bookID {
    [_delegate didDownloadHLSStateUpdate:bookDownloadDetail.bookDownloadState withBookDownloadProgress:bookDownloadDetail.progress forBookID:bookID];
}

- (void)didDownloadRequestFailForAVAsset:(NSError *)error bookDownloadDetail:(HDAVAssetDownloadDetails *)bookDownloadDetail bookID:(NSString *)bookID {
    [_delegate didDownloadHLSRequestFailWithError:error forState:bookDownloadDetail.bookDownloadState forBookID:bookID];
}

- (void)didDeleteDownloadedAVAssetWithBookID:(NSString *)bookID{
    [_delegate didDeleteHLSBookWithBookID:bookID];
}
@end
