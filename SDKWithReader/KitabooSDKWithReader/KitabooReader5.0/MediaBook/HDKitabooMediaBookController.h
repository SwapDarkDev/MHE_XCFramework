//
//  HDKitabooMediaBookController.h
//  KItabooSDK
//
//  Created by Sumanth Myrala on 16/06/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import "HDReaderSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDKitabooMediaBookControllerDelegate <NSObject>

@optional
- (void)didTapOnBackWithBookID:(NSString *)bookID withLastPageFolio:(NSString *)lastPageFolio;
- (UIImageView *)imageViewForThumbnail:(NSString *)thumbnailURL;
- (void)refreshUserToken:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken completed:(void (^)(KitabooUser *))completionHandler;
- (void)didUserSessionExpired;
- (void)didFetchLastAccessedForBookID:(NSString *)bookID withLastPageFolio:(NSString *)lastPageFolio;
- (void)didHLSMediaLoadingFailWithError:(NSError *)error bookId:(NSNumber *)bookId timeStamp:(NSNumber *)timeStamp;
- (void)didTapOnNextMediaWithBookID:(NSString *)bookID withLastPageFolio:(NSString *)lastPageFolio;
- (void)didTapOnPreviousMediaWithBookID:(NSString *)bookID withLastPageFolio:(NSString *)lastPageFolio;
@end



@interface HDKitabooMediaBookController : UIViewController

- (void)launchMediaReader:(NSString *)mediaBookPath withBookID:(NSNumber *)bookID withBookISBN:(NSString *)bookISBN withThumbnailURL:(NSString *)thumbnailURL withBaseURL:(NSString *)baseURL withClientID:(NSString *)clientID WithUser:(KitabooUser *)user withReaderSettings:(HDReaderSettingModel *)readerSettingModel isAudioBook:(BOOL)isAudioBook withAdditionalInfo:(nullable NSDictionary*)additionalInfo;

- (void)launchOfflineHLSMedia:(NSString *)mediaMetaDataPath withBookID:(NSNumber *)bookID withThumbnailURL:(NSString *)thumbnailURL withBaseURL:(NSString *)baseURL withClientID:(NSString *)clientID WithUser:(KitabooUser *)user isAudioBook:(BOOL)isAudioBook withBookISBN:(NSString *)bookISBN withReaderSettings:(HDReaderSettingModel *)readerSettingModel withAdditionalInfo:(nullable NSDictionary*)additionalInfo ;

- (void)launchOnlineHLSMedia:(NSNumber *)bookID withThumbnailURL:(NSString *)thumbnailURL withBaseURL:(NSString *)baseURL microServicesURL: microServicesURL withClientID:(NSString *)clientID WithUser:(KitabooUser *)user withBookISBN:(NSString *)bookISBN withTimeStamp:(NSNumber*)timeStamp isBookAudio:(BOOL)isAudioBook enableCDNCookies:(BOOL)enable withReaderSettings:(HDReaderSettingModel *)readerSettingModel withAdditionalInfo:(nullable NSDictionary*)additionalInfo;

- (void)stopMedia;

-(void)setAudioThemeFilePath:(NSString *)themeFilePath;

-(void)enabledNextPreviousFeature:(BOOL)enable;

-(void)enableNextMediaButton:(BOOL)enable;

-(void)enablePreviousMediaButton:(BOOL)enable;

-(void)setNextPreviousMediaArray:(NSArray<NSNumber*>*)bookIDs;

@property (nonatomic, weak) id<HDKitabooMediaBookControllerDelegate> delegate;

/**
This property is used to set the last page content that should be displayed.
*/
@property (nonatomic,strong) NSString *lastPageFolio;

@end

NS_ASSUME_NONNULL_END
