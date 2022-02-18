//
//  MainViewController.h
//  KitabooSDKWithReader
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "HDReaderSettingModel.h"
#import "Constant.h"
#import "ReaderHeader.h"
NS_ASSUME_NONNULL_BEGIN

/** An Object that will be responsible to initialise the book launch.
* @superclass SuperClass : UIViewController
*/
@interface KitabooServiceConfiguration : NSObject
/*!
*The NSString object that refers the service baseURL
*/
@property(strong,nonatomic) NSString *baseURL;
/*!
*The NSString object that refers the client id
*/
@property(strong,nonatomic) NSString *clientID;
/*!
*The NSString object that refers the micro service baseURL
*/
@property(strong,nonatomic) NSString *microServicesBaseURL;
/*!
* To Initialte the KitabooServiceConfiguration object
* @param1 baseURL is an NSString Object
* @param2 clientID is an NSString Object
*/
- (instancetype)initWithBaseURL:(NSString *)baseURL WithClientID:(NSString *)clientID;
@end


/** An Object that will contain the necessary details about the book and package
* @superclass SuperClass : NSObject
*/
@interface KitabooBookPackage : NSObject

/*!
*The NSString object that refers the physical path of the book package
*/
@property(strong,nonatomic) NSString *bookPath;

/*!
*The NSString object that refers the isbn of the book
*/
@property(strong,nonatomic) NSString *isbn;

/*!
*The NSString object that refers the bookID of the book
*/
@property(strong,nonatomic) NSString *bookID;

/*!
*The NSString object that refers the encryptionType of the book
*/
@property(strong,nonatomic) NSString *encryptionType;

/*!
* To Initialte the KitabooBookPackage object
* @param1 bookPath Device Physical path of book
* @param2 bookID is an NSString Object
* @param3 isbn is an NSString Object
*/
- (instancetype)initWithBookAtPath:(NSString *)bookPath WithBookID:(NSString *)bookID WithISBN:(NSString *)isbn;

/*!
* To Initialte the KitabooBookPackage object
* @param1 bookPath Device Physical path of book
* @param2 bookID is an NSString Object
* @param3 isbn is an NSString Object
* @param4 encryptionType is an NSString Object.
*/
- (instancetype)initWithBookAtPath:(NSString *)bookPath WithBookID:(NSString *)bookID WithISBN:(NSString *)isbn withEncryptionType:(NSString *)encryptionType;
@end

@interface KitabooAudioBookPackage : KitabooBookPackage


/*!
*The NSString object that refers the thumbnailURL of the book package
*/
@property(strong,nonatomic) NSString *thumbnailURL;

/*!
* To Initialte the KitabooBookPackage object
* @param1 bookPath Device Physical path of book
* @param2 bookID is an NSString Object
* @param3 isbn is an NSString Object
*/
- (instancetype)initWithAudioBookAtPath:(NSString *)bookPath WithBookID:(NSString *)bookID WithISBN:(NSString *)isbn withThumbnailURL:(NSString *)thumbnailURL;
@end


@protocol KitabooReaderViewControllerDelegate <NSObject>
@optional
/*!
 * This method will be called when the user close the reader.
 * @param1 reader is an UIViewController Object.
 * @param1 bookId is an NSString Object.
 * @param2 user is an KitabooUser Object.
 * @param3 lastPageFolio is an NSString for the last position of the book, visited by the user.
*/
- (void)didClosedReaderWithReader:(UIViewController*)reader WithBookId:(NSString*)bookId WithUser:(KitabooUser*)user WithLastPageFolio:(NSString*)lastPageFolio;

/*!
 * This method will be called when the ugc syncing is completed successfully.
 * @param1 userID is an NSString Object.
 * @param2 bookID is an NSString Object.
*/
- (void)didUGCSaveCompletedSuccessfullyWithUserID:(NSString *)userID withBookID:(NSString *)bookID;

/*!
 * This method will be called when the ugc syncing is failed.
 * @param1 error is an NSError Object.
 * @param2 userID is an NSString Object.
 * @param3 bookID is an NSString Object.
*/
- (void)didUGCSaveFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID;

/*!
 * This method will be called when the save ugc data is completed successfully.
*/
- (void)didUGCSaveCompletedSuccessfully;

/*!
 * This method will be called when the ugc syncing is failed.
 * @param1 error is an NSError Object.
*/
- (void)didUGCSaveFailedWithError:(NSError *)error;

/*!
 * This method will be called when the save analytics data is completed successfully.
*/
- (void)didSaveAnalyticsDataSuccessfully;

/*!
 * This method will be called when the save analytics data is failed.
 * @param1 error is an NSError Object.
 * @param2 userID is an NSString Object.
 * @param3 bookID is an NSString Object.
*/
- (void)didSaveAnalyticsDataFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID;

/*!
 * This method will be called when the current user token expires.
 * @param1 user is an KitabooUser Object.
 * @param2 expiredUserToken is an NSString Object with the expired user token.
*/
- (void)didSessionExpiredWithUser:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken;


/*!
 * This method will be called when there is any update in the book reading percentage for reflowable books
 * @param1 bookID is the book
 * @param2 percentageRead is the percentageRead of reflowable book
*/
-(void)didUpdatedReadPercentageTo:(NSInteger)percentageRead ForBookID:(NSString *)bookID;

/*!
 * This method will be called when furthest visited page updated.
 * @param1 reader is an UIViewController Object.
 * @param2 furthestPageData Furthest visited page of type NSString.
 * @param3 bookId of type NSString.
 * @param4 user is an KitabooUser Object.
*/
- (void)didUpdateFurthestPageDataWithReader:(UIViewController*)reader WithFurthestPageData:(NSString*)furthestPageData WithBookId:(NSString*)bookId WithUser:(KitabooUser*)user;

/*!
 * This method will be called when the HLS Media Book loading failed with Error.
 * @param1 error NSError object.
 * @param2 bookId of type NSString.
 * @param2 timeStamp Time Stamp.
*/
- (void)didHLSMediaLoadingFailWithError:(NSError *)error bookId:(NSNumber *)bookId timeStamp:(NSNumber *)timeStamp;

-(void)didUGCDataSuccessfullyParsed;


@end

@class HDKitabooMediaBookController;
@class ReaderViewController;
/** An Object that will be responsible to initialise the book launch.
* @superclass SuperClass : UIViewController
*/
@interface KitabooReaderViewController : UIViewController

/*!
*The object that acts as the delegate of the KitabooReaderViewController
*@discussion The delegate must adopt the KitabooReaderViewControllerDelegate protocol.
*/
@property (nonatomic, weak) id<KitabooReaderViewControllerDelegate>delegate;
@property (nonatomic, strong) KitabooUser* user;
@property (nonatomic, strong) KitabooServiceConfiguration *kitabooServiceConfiguration;
@property (nonatomic, strong) HDReaderSettingModel *userSettingsModel;
@property (nonatomic, strong) HDKitabooMediaBookController *audioBookController;

/*!
 lastPageFolio is an NSString object to store last page folio.
*/
@property (nonatomic, strong) NSString *lastPageFolio;

/*!
 furthestPageData is an NSString object to store furthest page data.
*/
@property (nonatomic, strong) NSString *furthestPageData;

/**
This method should be called to initialize/launch the specific book
* @param1 book Book object of type KitabooBookPackage.
* @param2 user is the KitabooUser instance which represents the current active user
* @param3 kitabooServiceConfiguration required Configurations to launch a Book.
*/
- (void)launchBook:(KitabooBookPackage*)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration;

/**
This method should be called to initialize/launch the specific book
* @param1 book Book object of type KitabooBookPackage.
* @param2 user is the KitabooUser instance which represents the current active user
* @param3 kitabooServiceConfiguration required Configurations to launch a Book.
* @param4 readerSettingModel is the HDReaderSettingModel instance to define the configuration of various components in reader
* @param5 hasClassAssociation is boolean to define whether logged user is associated with any class.By default the hasClassAssociation will be NO.
*/
- (void)launchBook:(KitabooBookPackage*)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel withClassAssociation:(BOOL)hasClassAssociation;

/**
This method should be called to initialize/launch the specific  Audio Book
* @param1 book Book object of type KitabooAudioBookPackage.
* @param2 user is the KitabooUser instance which represents the current active user
* @param3 kitabooServiceConfiguration required Configurations to launch a Book.
* @param4 readerSettingModel is the HDReaderSettingModel instance to define the configuration of various components in reader
*/
- (void)launchAudioBook:(KitabooAudioBookPackage *)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel;

/**
This method should be called to initialize/launch the specific  Audio Book
* @param1 book Book object of type KitabooAudioBookPackage.
* @param2 user is the KitabooUser instance which represents the current active user
* @param3 kitabooServiceConfiguration required Configurations to launch a Book.
*/
- (void)launchAudioBook:(KitabooAudioBookPackage *)book WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration;

/**
This method should be called to initialize/launch the specific  HLS Audio/Video Book
* @param1 book Book object of type KitabooAudioBookPackage.
* @param2 isDownloaded if the HLS book is downloaded, pass true
* @param3 isAudioBook Pass true, if book type is Audio, if false, video book will be launched
* @param4 user is the KitabooUser instance which represents the current active user
* @param5 kitabooServiceConfiguration required Configurations to launch a Book.
* @param6 readerSettingModel is the HDReaderSettingModel instance to define the configuration of various components in reader
*/
- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel;

/**
This method should be called to initialize/launch the specific  HLS Audio/Video Book
* @param1 book Book object of type KitabooAudioBookPackage.
* @param2 isDownloaded if the HLS book is downloaded, pass true
* @param3 isAudioBook Pass true, if book type is Audio, if false, video book will be launched
* @param4 user is the KitabooUser instance which represents the current active user
* @param5 kitabooServiceConfiguration required Configurations to launch a Book.
* @param6 readerSettingModel is the HDReaderSettingModel instance to define the configuration of various components in reader
* @param7 enable Is CDN Cookies enabled
*/
- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel enableCDNCookies:(BOOL)enable;

/**
This method should be called to initialize/launch the specific  HLS Audio/Video Book
* @param1 book Book object of type KitabooAudioBookPackage.
* @param2 isDownloaded if the HLS book is downloaded, pass true
* @param3 isAudioBook Pass true, if book type is Audio, if false, video book will be launched
* @param4 user is the KitabooUser instance which represents the current active user
* @param5 kitabooServiceConfiguration required Configurations to launch a Book.
*/
- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration;

/**
This method should be called to initialize/launch the specific  HLS Audio/Video Book
* @param1 book Book object of type KitabooAudioBookPackage.
* @param2 isDownloaded if the HLS book is downloaded, pass true
* @param3 isAudioBook Pass true, if book type is Audio, if false, video book will be launched
* @param4 user is the KitabooUser instance which represents the current active user
* @param5 kitabooServiceConfiguration required Configurations to launch a Book.
* @param6 enable Is CDN Cookies enabled
*/
- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration enableCDNCookies:(BOOL)enable;

/**
This method should be called to set the deligate.
* @param1 delegate of type id<KitabooReaderViewControllerDelegate>.
*/
- (void)setDelegate:(id<KitabooReaderViewControllerDelegate>)delegate;

/**
This method should be called to update the current user with new user object.
* @param1 user of type KitabooUser.
*/
- (void)updateUserWithUser:(KitabooUser*)user;

/**
This method should be called to set the last visited page content for any type of book i.e, for Kitaboo fixed/epub books desired start content/page should be set and for AudioBooks, the desired start time of the audio should be set in seconds.
* @param1 lastPageFolio is the NSString object.The value that represents the start content.
*/
- (void)setLastPageFolio:(NSString *)lastPageFolio;

/**
This method should be called to enable or disable the auto login feature.
* @param1 isEnable of type BOOL.
*/
- (void)enableAutologin:(BOOL)isEnable;

/**
This method should be called to save the unsynced ugc data to server.
* @param1 bookID of type NSString.
* @param2 user of type KitabooUser.
*/
- (void)syncUGCDataWithBookId:(NSString *)bookID WithUser:(KitabooUser*)user;

/**
This method should be called to save the unsynced analytics data to server.
* @param1 bookId of type NSString.
* @param2 user of type KitabooUser.
*/
- (void)saveKitabooAnalyticsDataWithBookId:(NSString*)bookId WithUser:(KitabooUser*)user;

/**
This method should be called to uninitialize reader and clear it's objects.
*/
- (void)uninitializeReader;

/**
This method should be called to set the further visited page detail for Kitaboo fixed/epub books .
* @param1 furthestPageData is the NSString object.The value that represents the further visited page.
*/
- (void)setFurthestPageData:(NSString *)furthestPageData;

/*!
 * To enable/Disable furthest page implementation.
 * @param1 isEnable of type BOOL.
 */
- (void)enableFurthestPage:(BOOL)isEnable;

/*!
 * This method is called to update the user id with numeric value.
 * @param1 user is KitabooUser object.
 */
-(KitabooUser*)updateUserIDWithNumericValueForKitabooUser:(KitabooUser*)user;

/**
This method should be called to set the last page folio to Book .
 * @param1 playerView is the ReaderViewController object.on which the last page folio is to be set.
 * @param2 bookID is the NSString object.The value that represents the book id for which the last page folio is to be set.
 * @param3  success handler  which gets executed when we get the last page folio.
 * @param4  failure handler  which gets executed when  the last page folio service gets failed.
*/
- (void)setLastPageFolioToPlayer:(ReaderViewController *)playerView withBookID:(NSString *)bookID success:(void (^)(NSString* lastPageFolio))success failure: (void (^)(NSError* error))failure;

/**
This method should be called to set the further visited page detail to player view .
 * @param1 playerView is the ReaderViewController object on which the furthest page data is to be set.
 * @param2 bookID is the NSString object.The value that represents the book id for which the furthest page is to be set.
*/
- (void)setFurthestPageDataToPlayer:(ReaderViewController *)playerView withBookID:(NSString *)bookID;
@end

NS_ASSUME_NONNULL_END
