//
//  HDKitabooMediaBookController.m
//  KItabooSDK
//
//  Created by Sumanth Myrala on 16/06/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import "HDKitabooMediaBookController.h"
#import "HSUIColor-Expanded.h"
#import "KBHDThemeVO.h"
#import "AlertView.h"
#import "Constant.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#define LocalizationBundleForHDKitabooMediaBookController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

#define trackingId @"1"

@interface HDKitabooMediaBookController ()<HDKitabooMediaBookReaderDelegate,KitabooDataSyncingManagerDelegate, HDMediaBookPlayerDelegate> {
    HDKitabooMediaBookReader *mediaReader;
    NSString *_baseURL;
    NSString *_microServiceURL;
    NSString *_clientID;
    NSNumber *_bookID;
    NSNumber *_timeStamp;
    KitabooUser *_user;
    HDReaderSettingModel *_userSettingsModel;
    KitabooDataSyncingManager *dataSyncManager;
    NSString *mediaThemeFilePath;
    NSMutableDictionary *pagesLoadStartTimeDictionary;
    NSTimer *analyticsScheduledTimer;
    NSDate *bookOpenTimeStamp;
    SDKBookClassInfoVO *bookClassInfo;
    HSDBManager *_dbManager;
    HDKitabooAnalyticsHandler *analyticsHandler;
    BOOL isMediaLoaded;
    BOOL enableNextButton;
    BOOL enablePreviousButton;
    BOOL enableNextPreviousFeature;
    NSArray *mediaBookIDs;
}

@end

@implementation HDKitabooMediaBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    analyticsHandler = [[HDKitabooAnalyticsHandler alloc] init];
}

- (void)launchMediaReader:(NSString *)mediaBookPath withBookID:(NSNumber *)bookID withBookISBN:(NSString *)bookISBN withThumbnailURL:(NSString *)thumbnailURL withBaseURL:(NSString *)baseURL withClientID:(NSString *)clientID WithUser:(KitabooUser *)user withReaderSettings:(HDReaderSettingModel *)readerSettingModel isAudioBook:(BOOL)isAudioBook withAdditionalInfo:(nullable NSDictionary*)additionalInfo {
    [self initializeLocalizationBundle];
    _baseURL = baseURL;
    _clientID = clientID;
    _user = user;
    _bookID = bookID;
    _userSettingsModel = readerSettingModel;
    _dbManager = [[HSDBManager alloc] init];
    
    if (mediaReader != nil) {
        [mediaReader updateMediaReaderWithBookPath:mediaBookPath mediaThumbnailURL:thumbnailURL mediaBookType:(isAudioBook ? MediaBookTypeKMediaBookAudio : MediaBookTypeKMediaBookVideo) bookId:[bookID stringValue] bookISBN:bookISBN additionalinfo:additionalInfo];
    }else {
        mediaReader = [[HDKitabooMediaBookReader alloc] init:mediaBookPath mediaThumbnailURL:thumbnailURL mediaBookType:(isAudioBook ? MediaBookTypeKMediaBookAudio : MediaBookTypeKMediaBookVideo) bookId:[bookID stringValue] bookISBN:bookISBN additionalInfo:additionalInfo];
    }
    [self handleMediaReaderUI:false];
    pagesLoadStartTimeDictionary = nil;
    pagesLoadStartTimeDictionary = [[NSMutableDictionary alloc] init];
    [self handleBookOpenTrackingAction];
}

- (void)launchOfflineHLSMedia:(NSString *)mediaMetaDataPath withBookID:(NSNumber *)bookID withThumbnailURL:(NSString *)thumbnailURL withBaseURL:(NSString *)baseURL withClientID:(NSString *)clientID WithUser:(KitabooUser *)user isAudioBook:(BOOL)isAudioBook withBookISBN:(NSString *)bookISBN withReaderSettings:(HDReaderSettingModel *)readerSettingModel withAdditionalInfo:(nullable NSDictionary*)additionalInfo  {
    _baseURL = baseURL;
    _clientID = clientID;
    _user = user;
    _bookID = bookID;
    _userSettingsModel = readerSettingModel;
    _dbManager = [[HSDBManager alloc] init];
    
    if (mediaReader != nil) {
        [mediaReader updateMediaReaderWithMetaDataPath:mediaMetaDataPath mediaThumbnailURL:thumbnailURL mediaBookType:(isAudioBook ? MediaBookTypeKMediaBookAudio : MediaBookTypeKMediaBookVideo) bookISBN:bookISBN bookId:[bookID stringValue] additionalinfo:additionalInfo];
    }else {
        mediaReader = [[HDKitabooMediaBookReader alloc] initWithMediaMetaDataPath:mediaMetaDataPath mediaThumbnailURL:thumbnailURL mediaBookType:(isAudioBook ? MediaBookTypeKMediaBookAudio : MediaBookTypeKMediaBookVideo) bookISBN:bookISBN bookId:[bookID stringValue] additionalInfo:additionalInfo];
    }

    [self handleMediaReaderUI:false];
    pagesLoadStartTimeDictionary = nil;
    pagesLoadStartTimeDictionary = [[NSMutableDictionary alloc] init];
    [self handleBookOpenTrackingAction];
}

- (void)launchOnlineHLSMedia:(NSNumber *)bookID withThumbnailURL:(NSString *)thumbnailURL withBaseURL:(NSString *)baseURL microServicesURL: microServicesURL withClientID:(NSString *)clientID WithUser:(KitabooUser *)user withBookISBN:(NSString *)bookISBN withTimeStamp:(NSNumber*)timeStamp isBookAudio:(BOOL)isAudioBook enableCDNCookies:(BOOL)enable withReaderSettings:(HDReaderSettingModel *)readerSettingModel withAdditionalInfo:(nullable NSDictionary*)additionalInfo {
    _baseURL = baseURL;
    _microServiceURL = microServicesURL;
    _clientID = clientID;
    _user = user;
    _bookID = bookID;
    _timeStamp = timeStamp;
    _userSettingsModel = readerSettingModel;
    _dbManager = [[HSDBManager alloc] init];
    
    if (mediaReader != nil) {
        [mediaReader updateMediaReaderWithKitabooUser:user baseURLString:_baseURL microServicesURL:microServicesURL clientID:_clientID bookId:_bookID timeStamp:timeStamp thumbnailURL:thumbnailURL mediaBookType:(isAudioBook ? MediaBookTypeKMediaBookAudio : MediaBookTypeKMediaBookVideo) bookISBN:bookISBN enableCDNCookies:enable additionalinfo:additionalInfo];
    }else {
        mediaReader = [[HDKitabooMediaBookReader alloc] initWithKitabooUser:user baseURLString:_baseURL microServicesURL:microServicesURL clientID:_clientID bookId:_bookID timeStamp:timeStamp thumbnailURL:thumbnailURL mediaBookType:(isAudioBook ? MediaBookTypeKMediaBookAudio : MediaBookTypeKMediaBookVideo) bookISBN:bookISBN enableCDNCookies:enable additionalInfo:additionalInfo];
    }
    
    [self handleMediaReaderUI:true];
    pagesLoadStartTimeDictionary = nil;
    pagesLoadStartTimeDictionary = [[NSMutableDictionary alloc] init];
}

-(void)setAudioThemeFilePath:(NSString *)themeFilePath {
    mediaThemeFilePath = themeFilePath;
}

-(NSString *) getAudioThemeFilePath {
    if(mediaThemeFilePath) {
        return mediaThemeFilePath;
    }else {
        return [[NSBundle mainBundle] pathForResource:@"audio-video-theme" ofType:@"json"];
    }
}

- (void)setStartTimeForMediaBook {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (_lastPageFolio && ![_lastPageFolio isEqualToString:@""]){
            NSData *data = [_lastPageFolio dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [mediaReader setStartTime:jsonDict];
        }
        isMediaLoaded = true;
    });
}

//KitabooDataSyncManager Delegate Methods
- (void)didFetchedUGCSuccessfully {
    NSArray *bookmarks = [_dbManager bookMarkBookID:[NSNumber numberWithLongLong:_bookID.longLongValue] userID:[NSNumber numberWithInt:_user.userID.intValue]];
    [mediaReader setBookmarks:[self getSortedBookmarks:bookmarks]];
}

- (void)didFailedToFetchUGCWithError:(NSError *)error {
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103]) {
        if ([_userSettingsModel isAutoLoginEnabled]) {
            if ([_delegate respondsToSelector:@selector(refreshUserToken:withExpiredToken:completed:)]) {
                [_delegate refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                    self->_user = renewedUser;
                    [self->dataSyncManager fetchUGCForBookID:self->_bookID ForUserID:[NSNumber numberWithInt:self->_user.userID.intValue] WithDelegate:self WithUserToken:self->_user.userToken];
                }];
            }
        }else {
            [self showSessionExpiredAlert];
        }
    }
}

- (void)didTapOnBack:(NSDictionary *)metaData mediaBookReader:(HDKitabooMediaBookReader *)mediaBookReader {
    [self handleBackButtonAction:metaData];
    [self stopMedia];
    if ([_delegate respondsToSelector:@selector(didTapOnBackWithBookID:withLastPageFolio:)]) {
        [_delegate didTapOnBackWithBookID:[NSString stringWithFormat:@"%@",_bookID] withLastPageFolio:_lastPageFolio];
    }
}

- (void)didBookmarkCompleteWithBookmarkVO:(SDKBookmarkVO *)bookmarkVO {
    if (bookmarkVO.status == DELETE) {
        [_dbManager deleteBookmark:bookmarkVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    }else {
        [_dbManager saveBookmark:bookmarkVO bookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    }
    NSArray *bookmarks = [_dbManager bookMarkBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
    [mediaReader setBookmarks:[self getSortedBookmarks:bookmarks]];
}

- (UIImageView *)imageViewForThumbnail:(NSString *)thumbnailURL {
    if ([_delegate respondsToSelector:@selector(imageViewForThumbnail:)]) {
        return [_delegate imageViewForThumbnail:thumbnailURL];
    }
    return nil;
}

-(void)showSessionExpiredAlert {
    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"YOUR_SESSION_HAS_EXPIRED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForHDKitabooMediaBookController];
    NSString *alert_Msg  = [LocalizationHelper localizedStringWithKey:@"PLEASE_SIGN_IN_AGAIN" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForHDKitabooMediaBookController];
    __weak typeof(self) weakSelf = self;
    [[AlertView sharedManager] presentAlertWithTitle:alert_Title message:alert_Msg andButtonsWithTitle:@[@"OK"] onController:mediaReader dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        [weakSelf stopMedia];
        if ([self->_delegate respondsToSelector:@selector(didUserSessionExpired)]) {
            [self->_delegate didUserSessionExpired];
        }
    }];
}

- (void)didSchedulerCalledWithInfo:(NSDictionary *)additionalInfo {

}
       
- (void)stopMedia {
    if (mediaReader) {
        [mediaReader closePlayer];
        [mediaReader.view removeFromSuperview];
        [mediaReader removeFromParentViewController];
        mediaReader = nil;
    }
}

-(void)initializeLocalizationBundle {
    if(LocalizationHelper.readerLanguageBundle == nil) {
        LocalizationHelper.readerLanguageBundle = [NSBundle bundleForClass:[HDKitabooMediaBookController self]];
    }
}

- (NSArray *)getSortedBookmarks:(NSArray *)bookmarks {
    NSArray *sortedBookmarks = [bookmarks sortedArrayUsingComparator:^NSComparisonResult(SDKBookmarkVO *obj1, SDKBookmarkVO *obj2){
        NSNumber *currentTimeForFirst = obj1.metaData[@"CurrentTime"];
        NSNumber *currentTimeForSecond = obj2.metaData[@"CurrentTime"];
        return currentTimeForFirst.doubleValue > currentTimeForSecond.doubleValue;
    }];
    return sortedBookmarks;
}

- (void)didHLSMediaServiceCallSuccessfullyWithMediaPath:(NSString *)mediaPath withBookID:(NSNumber *)bookId{
    [self handleActionWhenMediaPathLoaded];
}

- (void)didHLSMediaServiceFailWithError:(NSError *)error bookId:(NSNumber *)bookId timeStamp:(NSNumber *)timeStamp {
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103] || [error code] == 401) {
        if ([_userSettingsModel isAutoLoginEnabled]) {
            if ([_delegate respondsToSelector:@selector(refreshUserToken:withExpiredToken:completed:)]) {
                [_delegate refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                    self->_user = renewedUser;
                    [mediaReader loadHLSMediaBookPathForUser:_user baseURLString:_baseURL clientID:_clientID microServicesURL:_microServiceURL bookId:bookId timeStamp:timeStamp shouldLaunchMedia:YES];
                }];
            }
        }else {
            [self showSessionExpiredAlert];
        }
    }
    if ([_delegate respondsToSelector:@selector(didHLSMediaLoadingFailWithError:bookId:timeStamp:)]) {
        [_delegate didHLSMediaLoadingFailWithError:error bookId:bookId timeStamp:timeStamp];
    }
}

-(void)handleActionWhenMediaPathLoaded {
    [self performSelector:@selector(setStartTimeForMediaBook) withObject:nil afterDelay:0.5];
    if ([_userSettingsModel isAudioBookBookmarkEnabled]) {
        dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_baseURL clientID:_clientID];
        [dataSyncManager fetchUGCForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
        NSArray *bookmarks = [_dbManager bookMarkBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        if (bookmarks.count > 0) {
            [mediaReader setBookmarks:[self getSortedBookmarks:bookmarks]];
        }
    }
    [self handleBookOpenTrackingAction];
}

-(void)enabledNextPreviousFeature:(BOOL)enable {
    enableNextPreviousFeature = enable;
}

- (void)didTapOnNextMediaButton:(HDKitabooMediaBookReader *)mediaPlayer {
    [self handleBackButtonAction:[mediaReader getMetaData]];
    if ([_delegate respondsToSelector:@selector(didTapOnNextMediaWithBookID:withLastPageFolio:)]) {
        [_delegate didTapOnNextMediaWithBookID:[NSString stringWithFormat:@"%@",_bookID] withLastPageFolio:_lastPageFolio];
    }
}

- (void)didTapOnPreviousMediaButton:(HDKitabooMediaBookReader *)mediaPlayer {
    [self handleBackButtonAction:[mediaReader getMetaData]];
    if ([_delegate respondsToSelector:@selector(didTapOnPreviousMediaWithBookID:withLastPageFolio:)]) {
        [_delegate didTapOnPreviousMediaWithBookID:[NSString stringWithFormat:@"%@",_bookID] withLastPageFolio:_lastPageFolio];
    }
}

-(void)handleBackButtonAction:(NSDictionary *)metaData {
    if (metaData != nil) {
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:metaData options:0 error:nil];
        NSString *lastPageFolio = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        _lastPageFolio = lastPageFolio;
        [self stopAnalyticsScheduledTimer];
        [self trackBookPageEvent];
        [self trackBookCloseEvent];
        NSString *eventTrackingJSON = [analyticsHandler getTrackingJSON];
        if(eventTrackingJSON) {
            [_dbManager createReaderAnalyticsSessionForUserID:_user.userID WithBookID:[NSString stringWithFormat:@"%ld",(long)_bookID.integerValue] withAnalyticsData:eventTrackingJSON];
        }
    }
}

-(void)setNextPreviousMediaArray:(NSArray<NSNumber*>*)bookIDs {
    mediaBookIDs = bookIDs;
}

- (void)didMediaPlaybackStateChange:(NSString *)mediaState {
    if ([mediaState isEqualToString:@"Playing"]) {
        if (pagesLoadStartTimeDictionary.count != 1 && isMediaLoaded) {
            [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:trackingId];
            [self startAnalyticsScheduledTimer];
        }
    }else {
        if (pagesLoadStartTimeDictionary.count == 1) {
            [self stopAnalyticsScheduledTimer];
            [self trackBookPageEvent];
            [pagesLoadStartTimeDictionary removeObjectForKey:trackingId];
        }
    }
}

-(void)handleBookOpenTrackingAction {
    [dataSyncManager fetchUGCOperationForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];

    bookOpenTimeStamp = [NSDate date];
    NSArray *array = [_dbManager bookClassInfoArrayForBookID:[NSNumber numberWithLongLong:_bookID.longLongValue] forUser:[NSNumber numberWithInt:_user.userID.intValue]];
    if (array != nil && array.count>0) {
        bookClassInfo = [array objectAtIndex:0];
    }
    [self trackBookOpenEvent];
}

- (void)trackBookOpenEvent {
    HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithBookOpen:[NSString stringWithFormat:@"%@",_bookID] openTimeStamp:[NSString hsStringFromUTCDate:bookOpenTimeStamp] classId:[NSString stringWithFormat:@"%@",bookClassInfo.classId] suspendData:nil uniqueId:[NSString stringWithFormat:@"%@",_bookID]];
    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeBookOpen metadata:metadata];
}

- (void)trackBookCloseEvent {
    HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithBookClose:[NSString hsStringFromUTCDate:[NSDate date]] lastPageFolio:_lastPageFolio uniqueId:[NSString stringWithFormat:@"%@",_bookID]];
    [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypeBookClose metadata:metadata];
}

-(void)trackBookPageEvent {
    NSDate *startPageTime = [pagesLoadStartTimeDictionary objectForKey:trackingId];
    NSDate *endPageTime = [NSDate date];
    NSTimeInterval secondsBetween = [endPageTime timeIntervalSinceDate:startPageTime];
    if (secondsBetween > 1) {
        HDKitabooAnalyticsMetaData *metadata = [[HDKitabooAnalyticsMetaData alloc] initWithPageTracking:nil pageId:trackingId timeSpent:[NSString stringWithFormat:@"%f",secondsBetween] chapterId:trackingId chapterName:@"Media Book" uniqueId:[[NSUUID UUID] UUIDString]];
        [analyticsHandler trackEvent:HDAnalyticsEventTypeKTypePageTracking metadata:metadata];
    }
}

-(void)analyticsScheduledTimerTriggered {
    if ([_delegate respondsToSelector:@selector(didFetchLastAccessedForBookID:withLastPageFolio:)]) {
        NSDictionary *additionalInfo = [mediaReader getMetaData];
        if (additionalInfo != nil) {
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:additionalInfo options:0 error:nil];
            NSString *lastPageFolio = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            _lastPageFolio = lastPageFolio;
            [_delegate didFetchLastAccessedForBookID:[NSString stringWithFormat:@"%@",_bookID] withLastPageFolio:lastPageFolio];
        }
    }
    [self trackBookCloseEvent];
    [self trackBookPageEvent];
    [pagesLoadStartTimeDictionary setObject:[NSDate date] forKey:trackingId];
    NSString *eventTrackingJSON = [analyticsHandler getTrackingJSON];
    if(eventTrackingJSON) {
        [_dbManager createReaderAnalyticsSessionForUserID:_user.userID WithBookID:[NSString stringWithFormat:@"%ld",(long)_bookID.integerValue] withAnalyticsData:eventTrackingJSON];
    }
    [self trackBookOpenEvent];
}

- (void)startAnalyticsScheduledTimer {
     analyticsScheduledTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(analyticsScheduledTimerTriggered) userInfo:nil repeats:true];
}

-(void)stopAnalyticsScheduledTimer {
    if (analyticsScheduledTimer) {
        [analyticsScheduledTimer invalidate];
        analyticsScheduledTimer = nil;
    }
}

- (void)enableNextMediaButton:(BOOL)enable {
    enableNextButton = !enable;
}

- (void)enablePreviousMediaButton:(BOOL)enable {
    enablePreviousButton = !enable;
}

-(void)handleMediaReaderUI:(BOOL)isOnlineHLS {
    [mediaReader enableBookmark:[_userSettingsModel isAudioBookBookmarkEnabled]];
    HDKitabooMediaBookThemeVO *themeVO = [[HDKitabooMediaBookThemeVO alloc] init];
    NSString *themeFilePath = [self getAudioThemeFilePath];
    if (!themeFilePath || [themeFilePath isEqualToString:@""]) {
        themeFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"audio-video-theme" ofType:@"json"];
    }
    if (themeFilePath && ![themeFilePath isEqualToString:@""]) {
        [themeVO updateThemeFromJsonPath:themeFilePath];
    }
    [mediaReader setTheme:themeVO];
    
    if ([_userSettingsModel isAudioBookBookmarkEnabled]) {
        dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_baseURL clientID:_clientID];
        [dataSyncManager fetchUGCForBookID:_bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
        NSArray *bookmarks = [_dbManager bookMarkBookID:_bookID userID:[NSNumber numberWithInt:_user.userID.intValue]];
        if (bookmarks.count > 0) {
            [mediaReader setBookmarks:[self getSortedBookmarks:bookmarks]];
        }
    }
    mediaReader.delegate = self;
    [self.view addSubview:mediaReader.view];
    [self addChildViewController:mediaReader];
    mediaReader.view.frame = self.view.bounds;
    
    [self setStartTimeForMediaBook];
    [mediaReader enableNextPreviousFeature:enableNextPreviousFeature];
    if (enableNextPreviousFeature) {
        [mediaReader setNextPreviousBookIds:mediaBookIDs];
        [mediaReader disableNextMediaButton:enableNextButton];
        [mediaReader disablePreviousMediaButton:enablePreviousButton];
    }

    mediaReader.mediaPlayerDelegate = self;
}

- (void)playerDidFinishPlaying {
    [self handleBackButtonAction:[mediaReader getMetaData]];
    if ([_delegate respondsToSelector:@selector(didTapOnNextMediaWithBookID:withLastPageFolio:)]) {
        [_delegate didTapOnNextMediaWithBookID:[NSString stringWithFormat:@"%@",_bookID] withLastPageFolio:_lastPageFolio];
    }
}

- (void)playerFailedToPlayWithError:(NSError *)error {
    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"ERROR_ALERT_TITLE" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForHDKitabooMediaBookController];
    [[AlertView sharedManager] presentAlertWithTitle:alert_Title message:error.localizedDescription andButtonsWithTitle:@[@"OK"] onController:mediaReader dismissedWith:^(NSInteger index, NSString *buttonTitle) {
    }];
}

- (void)dealloc {
    [mediaReader closePlayer];
    dataSyncManager = nil;
    _baseURL = nil;
    _clientID = nil;
    _bookID = nil;
    _user = nil;
    _userSettingsModel = nil;
    mediaReader = nil;
    _dbManager = nil;
    bookClassInfo = nil;
    bookOpenTimeStamp = nil;
    analyticsHandler = nil;
}

@end
