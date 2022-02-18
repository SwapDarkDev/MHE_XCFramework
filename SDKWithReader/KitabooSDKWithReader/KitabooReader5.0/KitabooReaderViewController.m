//
//  MainViewController.m
//  SDKWithReader



#import "KitabooReaderViewController.h"
#import "ReaderViewController.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import "AlertView.h"
#import "HDReaderSettingModel.h"
#import "HDKitabooMediaBookController.h"
#import "HDKitabooHLSDownloaderManager.h"

#define LocalizationBundleForKitabooReaderViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

@implementation KitabooServiceConfiguration
-(instancetype)initWithBaseURL:(NSString *)baseURL WithClientID:(NSString *)clientID
{
    if ((self = [super init]))
    {
        _baseURL = baseURL;
        _clientID = clientID;
    }
    return self;
}

-(instancetype)initWithBaseURL:(NSString *)baseURL WithClientID:(NSString *)clientID withMicroServicesBaseURL:(NSString *)microServicesBaseURL
{
    if ((self = [super init]))
    {
        _baseURL = baseURL;
        _clientID = clientID;
        _microServicesBaseURL = microServicesBaseURL;
    }
    return self;
}
@end

@implementation KitabooBookPackage
- (instancetype)initWithBookAtPath:(NSString *)bookPath WithBookID:(NSString *)bookID WithISBN:(NSString *)isbn
{
    if ((self = [super init]))
    {
        _bookPath = bookPath;
        _bookID = bookID;
        _isbn = isbn;
        _encryptionType = @"V2";
    }
    return self;
}

- (instancetype)initWithBookAtPath:(NSString *)bookPath WithBookID:(NSString *)bookID WithISBN:(NSString *)isbn withEncryptionType:(NSString *)encryptionType
{
    if ((self = [super init]))
    {
        _bookPath = bookPath;
        _bookID = bookID;
        _isbn = isbn;
        _encryptionType = encryptionType;
    }
    return self;
}
@end

@implementation KitabooAudioBookPackage

- (instancetype)initWithAudioBookAtPath:(NSString *)bookPath WithBookID:(NSString *)bookID WithISBN:(NSString *)isbn withThumbnailURL:(NSString *)thumbnailURL{
    self = [super initWithBookAtPath:bookPath WithBookID:bookID WithISBN:isbn];
    if (self != nil)
    {
        _thumbnailURL = thumbnailURL;
    }
    return self;
}

@end


@interface KitabooReaderViewController ()<ReaderViewControllerDelegate,KitabooDataSyncingManagerDelegate,HDKitabooMediaBookControllerDelegate>
{
    HDScreenCaptureResistController *_screenCaptureResistController;
    ReaderViewController *_playerView;
    MHEReaderViewController *mheReaderViewController;
}

@end

@implementation KitabooReaderViewController

#pragma mark ViewLifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setReaderFontBundle];
    [self initializeFontManager];
    [self initializeMHEDelegateManager];
    //[self initialiseScreenRecordResistController];
    self.view.backgroundColor= UIColor.clearColor;
}

#pragma mark Initiate ReaderViewController Methods
-(ReaderViewController *)initiateReader:(KitabooBookPackage*)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration
{
    ReaderViewController *playerView;
    if ([book.encryptionType isEqualToString:@"V1"]) {
        playerView = [[ReaderViewController alloc] initWithBookPath:book.bookPath WithBookID:[NSNumber numberWithLongLong:book.bookID.longLongValue] WithUser:user withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID withUserSettingsModel:_userSettingsModel];
    }
    else if ([book.encryptionType isEqualToString:@"V2"]){
        playerView = [[ReaderViewController alloc] initWithBookPath:book.bookPath WithBookID:[NSNumber numberWithLongLong:book.bookID.longLongValue] WithUser:user withISBN:book.isbn withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID withUserSettingsModel:_userSettingsModel];
    }
    else{
        playerView = [[ReaderViewController alloc] initWithBookPath:book.bookPath WithBookID:[NSNumber numberWithLongLong:book.bookID.longLongValue] WithUser:user withISBN:book.isbn withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID withUserSettingsModel:_userSettingsModel];
    }
    return playerView;
}

-(ReaderViewController *)initiateReader:(KitabooBookPackage*)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration
    WithUserSettings:userSettingsModel
{    
    ReaderViewController *playerView;
    if ([book.encryptionType isEqualToString:@"V1"]) {
        playerView = [[ReaderViewController alloc] initWithBookPath:book.bookPath WithBookID:[NSNumber numberWithLongLong:book.bookID.longLongValue] WithUser:user withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID withUserSettingsModel:userSettingsModel];
    }
    else if ([book.encryptionType isEqualToString:@"V2"]){
        playerView = [[ReaderViewController alloc] initWithBookPath:book.bookPath WithBookID:[NSNumber numberWithLongLong:book.bookID.longLongValue] WithUser:user withISBN:book.isbn withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID withUserSettingsModel:userSettingsModel];
    }
    else{
        playerView = [[ReaderViewController alloc] initWithBookPath:book.bookPath WithBookID:[NSNumber numberWithLongLong:book.bookID.longLongValue] WithUser:user withISBN:book.isbn withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID withUserSettingsModel:userSettingsModel];
    }
    return playerView;
}

-(KitabooUser*)updateUserIDWithNumericValueForKitabooUser:(KitabooUser*)user
{
    if([user.userID rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
    {
        return user;
    }
    else
    {
        NSString *savedUserIDNumaric = [[NSUserDefaults standardUserDefaults] valueForKey:user.userID];
        if (savedUserIDNumaric)
        {
            user.userID=savedUserIDNumaric;
            return user;
        }
        else
        {
            long userIDNumaric = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",userIDNumaric] forKey:user.userID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            user.userID=[NSString stringWithFormat:@"%ld",userIDNumaric];
            return user;
        }
    }
}


#pragma mark LaunchBook Methods
- (void)launchBook:(KitabooBookPackage*)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration
{
    [self updateUserIDWithNumericValueForKitabooUser:user];
    _user = user;
    _kitabooServiceConfiguration = kitabooServiceConfiguration;
    _userSettingsModel = [[HDReaderSettingModel alloc] init];
    _userSettingsModel.isSharingEnabled = NO;
     _playerView = [self initiateReader:book WithKitabooUser:user WithKitabooServiceConfiguration:kitabooServiceConfiguration];
    _playerView.delegate = self;
    _playerView.microServicesBaseURLString = kitabooServiceConfiguration.microServicesBaseURL;
    _playerView.hasClassAssociation = NO;
    [_playerView hideProfileSettings:YES];
    if (_lastPageFolio) {
        _playerView.lastPageFolio = _lastPageFolio;
    }
    else{
        __weak typeof(_playerView) weakPlayerView = _playerView;
        [self setLastPageFolioToPlayer:_playerView withBookID:book.bookID success:^(NSString *lastPageFolio) {
            weakPlayerView.lastPageFolio = lastPageFolio;
        } failure:^(NSError *error) {
            
        }];
    }
    if (_furthestPageData) {
        [_playerView setFurthestPageData:_furthestPageData];
    } else {
        [self setFurthestPageDataToPlayer:_playerView withBookID:book.bookID];
    }
    [self addChildViewController:_playerView];
    [self.view addSubview:_playerView.view];
    _playerView.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [_playerView.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_playerView.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
        [_playerView.view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
        [_playerView.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
    } else {
        // Fallback on earlier versions
        [_playerView.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_playerView.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
        [_playerView.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
        [_playerView.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    }
}


- (void)launchBook:(KitabooBookPackage*)book WithKitabooUser:(KitabooUser*)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration*)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel withClassAssociation:(BOOL)hasClassAssociation
{
    [self updateUserIDWithNumericValueForKitabooUser:user];
    _kitabooServiceConfiguration = kitabooServiceConfiguration;
    _user = user;
     _playerView = [self initiateReader:book WithKitabooUser:user WithKitabooServiceConfiguration:kitabooServiceConfiguration WithUserSettings:readerSettingModel];
    _playerView.delegate=self;
    _playerView.microServicesBaseURLString = kitabooServiceConfiguration.microServicesBaseURL;
    _userSettingsModel = readerSettingModel;
    _userSettingsModel.isSharingEnabled = NO;
    _playerView.hasClassAssociation = hasClassAssociation;
    [_playerView hideProfileSettings:YES];
    [self addChildViewController:_playerView];
    [self.view addSubview:_playerView.view];
    if (_lastPageFolio) {
        _playerView.lastPageFolio = _lastPageFolio;
    }
    else{
        __weak typeof(_playerView) weakPlayerView = _playerView;
        [self setLastPageFolioToPlayer:_playerView withBookID:book.bookID success:^(NSString *lastPageFolio) {
            weakPlayerView.lastPageFolio = lastPageFolio;
        } failure:^(NSError *error) {
            
        }];
    }
    if (_furthestPageData) {
        [_playerView setFurthestPageData:_furthestPageData];
    } else {
        [self setFurthestPageDataToPlayer:_playerView withBookID:book.bookID];
    }
    _playerView.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [_playerView.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_playerView.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
        [_playerView.view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
        [_playerView.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
    } else {
        // Fallback on earlier versions
        [_playerView.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_playerView.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
        [_playerView.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
        [_playerView.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    }
}

#pragma mark Utility Methods
- (void)setLastPageFolioToPlayer:(ReaderViewController *)playerView withBookID:(NSString *)bookID success:(void (^)(NSString* lastPageFolio))success failure: (void (^)(NSError* error))failure
{
    HSDBManager *dbManager = [[HSDBManager alloc] init];
    NSString *lastPage = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"LastPageFolio_%@_%@",_user.userID,bookID]];
    if (lastPage)
    {
        NSDictionary *bookMetadataDict = [[NSDictionary alloc] initWithObjectsAndKeys:lastPage,@"LastPageFolio", nil];
        [dbManager saveBookMetadata:bookMetadataDict ForBookID:[NSNumber numberWithInteger:bookID.integerValue] ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"LastPageFolio_%@_%@",_user.userID,bookID]];//Removed to handle data migration.
    }
    NSDictionary *dict = [dbManager getBookMetadataForbookID:[NSNumber numberWithInteger:bookID.integerValue] ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
    if (dict && [dict objectForKey:@"LastPageFolio"]) {
         playerView.lastPageFolio = [dict objectForKey:@"LastPageFolio"];
        _audioBookController.lastPageFolio = [[dict objectForKey:@"LastPageFolio"] stringByRemovingPercentEncoding];
    }
    __weak typeof(_audioBookController) weakAudioBookController = _audioBookController;
    KitabooServiceInterface *kitabooServiceInterface=[[KitabooServiceInterface alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
    NetworkDataTaskOperation *operation = [kitabooServiceInterface fetchLastPageAccessed:_user.userToken bookId:bookID successHandler:^(NSDictionary *dict) {
        if ([dict objectForKey:@"LastPageFolio"])
        {
            NSString *lastPage = [[dict valueForKey:@"LastPageFolio"] stringByRemovingPercentEncoding];
            success(lastPage);
            weakAudioBookController.lastPageFolio = [dict objectForKey:@"LastPageFolio"];
            //[weakPlayerView navigateToPageNumber:lastPage];
        }
    } failureHandler:^(NSError *error) {
        failure(error);
    }];
    [operation start];
}

- (void)setFurthestPageDataToPlayer:(ReaderViewController *)playerView withBookID:(NSString *)bookID
{
    HSDBManager *dbManager = [[HSDBManager alloc] init];
    NSDictionary *dict = [dbManager getBookMetadataForbookID:[NSNumber numberWithInteger:bookID.integerValue] ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
    if (dict && [dict objectForKey:@"FurthestPageData"]) {
        NSString *furthestPage = [dict objectForKey:@"FurthestPageData"];
        [playerView setFurthestPageData:furthestPage];
    }
    //Call the FurthestPage service & set it to _playerView setFurthestPageData:.
}

-(void)showSessionExpiredAlert
{
    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"YOUR_SESSION_HAS_EXPIRED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKitabooReaderViewController];
    NSString *alert_Msg  = [LocalizationHelper localizedStringWithKey:@"PLEASE_SIGN_IN_AGAIN" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKitabooReaderViewController];
    [[AlertView sharedManager] presentAlertWithTitle:alert_Title message:alert_Msg andButtonsWithTitle:@[NSLocalizedStringFromTableInBundle(@"OK",READER_LOCALIZABLE_TABLE, LocalizationBundleForKitabooReaderViewController, nil)] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
     {
        if (self->_audioBookController)
        {
            [self->_audioBookController dismissViewControllerAnimated:NO completion:nil];
        }
        if (self->_playerView)
        {
            [_playerView closeReaderForSessionExpiry];
        }
    }];
}

-(void)showAlertControllerWithMsg:(NSString *)text withTitle:(NSString *)title;
{
    [[AlertView sharedManager] presentAlertWithTitle:title message:text andButtonsWithTitle:@[NSLocalizedStringFromTableInBundle(@"OK",READER_LOCALIZABLE_TABLE, LocalizationBundleForKitabooReaderViewController, nil)] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
     {
    }];
}

- (void)setLastPageFolio:(NSString *)lastPageFolio{
    _lastPageFolio = lastPageFolio;
}

- (void)setFurthestPageData:(NSString *)furthestPageData{
    _furthestPageData = furthestPageData;
}

-(NSString*)getAudioThemePath
{
   return [[NSBundle bundleForClass:[KitabooReaderViewController class]] pathForResource:@"audio-video-theme" ofType:@"json"];
}

-(void)setReaderFontBundle
{
    [[HDFontManagerHelper getInstance] setFontBundle:[NSBundle bundleForClass:[KitabooReaderViewController class]]];
}

- (void)initializeFontManager{
    HDFontManager *fontManager = [[HDFontManager alloc] init];
    [[HDFontManagerHelper getInstance] setFontManager:fontManager];
}

- (void)initialiseScreenRecordResistController{
    _screenCaptureResistController = [[HDScreenCaptureResistController alloc] init];
    [_screenCaptureResistController resistScreenCapture];
}

#pragma mark ReaderViewControllerDelegate Methods
-(void)didClosedReader:(UIViewController *)reader ForBookID:(NSNumber *)bookID withLastPageFolio:(NSString *)lastPageFolio withAvgTimePerPage:(NSNumber *)avgTimePerPage withIsReaderForceClosed:(BOOL)isReaderForceClosed
{
    NSDictionary *bookMetadataDict = [[NSDictionary alloc] initWithObjectsAndKeys:lastPageFolio,@"LastPageFolio", nil];
    HSDBManager *dbManager = [[HSDBManager alloc] init];
    [dbManager saveBookMetadata:bookMetadataDict ForBookID:bookID ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
    
    //[dbManager getUnsynedUGCDictionaryForUserID:<#(NSNumber *)#>
    
    [self uninitializeReader];
    if (!isReaderForceClosed) {
        [self syncKitabooDataWithBookId:bookID];
    }
    if ([_delegate respondsToSelector:@selector(didClosedReaderWithReader:WithBookId:WithUser:WithLastPageFolio:)]) {
        [_delegate didClosedReaderWithReader:self WithBookId:[bookID stringValue] WithUser:_user WithLastPageFolio:lastPageFolio];
    }
    
    if ([_delegate respondsToSelector:@selector(onBookClose)]) {
       // [_delegate onBookClose];
    }
    
    if ([_delegate respondsToSelector:@selector(onBookOpen)]) {
        //[_delegate onBookOpen];
    }
    
    [mheReaderViewController onBookOpen];
    
    //[_delegate saveAllUGCForBookID:bookID andUserID:_user.userID withUGC:ugcDict];
}

-(void)didLoadPageWithPageNumber:(NSNumber*)number WithDisplayNumber:(NSString*)displayNum forBookID:(KFBookVO *)book andUser:(KitabooUser *)user andPreviousPageNumber:(NSNumber *)previousPageNumber
{
    HSDBManager *dbManager = [[HSDBManager alloc] init];
    if (previousPageNumber.intValue != -1) {
        NSDictionary *ugcDictionary = [dbManager getAllUGCDictionaryForUserID:[NSString stringWithFormat:@"%@",_user.userID] withBookID:[NSNumber numberWithInteger:book.bookID] andPageID:previousPageNumber];
        
        NSString * ugcString = [UGCXMLClass generateXMLForUGCForDictionary:ugcDictionary forPageID:number andUser:user forBook:book];
        NSLog(@"%@",ugcString);
//        if ([ugcString isEqualToString:@"<links></links>"]) {
//
//        }
       // [mheReaderViewController saveAllUGCForBookID:book.bookID andUserID:_user.userID withUGC:ugcString forPageID:previousPageNumber];
        [mheReaderViewController loadUgcPerPageForBookID:book.bookID andUserID:user.userID withUGC:ugcString forPageID:number];
    }
    
}

- (void)didUpdateFurthestPageData:(NSString *)furthestPageData ForBookID:(NSString *)bookID ForUserID:(NSNumber *)userID
{
    NSDictionary *bookMetadataDict = [[NSDictionary alloc] initWithObjectsAndKeys:furthestPageData,@"FurthestPageData", nil];
    HSDBManager *dbManager = [[HSDBManager alloc] init];
    [dbManager saveBookMetadata:bookMetadataDict ForBookID:[NSNumber numberWithInteger:bookID.integerValue] ForUserID:userID];
    if (_delegate && [_delegate respondsToSelector:@selector(didUpdateFurthestPageDataWithReader:WithFurthestPageData:WithBookId:WithUser:)]) {
        [_delegate didUpdateFurthestPageDataWithReader:self WithFurthestPageData:furthestPageData WithBookId:bookID WithUser:_user];
    }
    
    
}

-(void)enableFurthestPage:(BOOL)isEnable
{
    [_playerView enableFurthestPage:isEnable];
}

- (void)uninitializeReader
{
    if (_playerView) {
        [_playerView uninitializeReader];
        [_playerView.view removeFromSuperview];
        [_playerView removeFromParentViewController];
        _playerView = nil;
    }
}

-(void)syncKitabooDataWithBookId:(NSNumber*)bookID
{
//    KitabooDataSyncingManager *_dataSyncManager =
//    [[KitabooDataSyncingManager alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
//    [_dataSyncManager setMicroServicesBaseURLString:_kitabooServiceConfiguration.microServicesBaseURL];
//    [_dataSyncManager synchUGCForBookID:bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
//    KitabooServiceMetaData *metaData = [[KitabooServiceMetaData alloc] init];
//    metaData.initialisedValue = @"B";
//    [_dataSyncManager saveUGCOperationForBookID:bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken WithMetaData:metaData];
//    [_dataSyncManager fetchUGCOperationForBookID:bookID ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
//    [_dataSyncManager saveTrackingDataForBookID:bookID ForUserToken:_user.userToken ForUserId:[NSNumber numberWithInt:_user.userID.intValue]];
//    [_dataSyncManager saveFurthestPageDataForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
}

- (void)didSessionExpiredForReader:(UIViewController *)reader{
    
//    ReaderViewController *readerVC = (ReaderViewController *)reader;
//    NSString *alert_Title = [LocalizationHelper localizedStringWithKey:@"YOUR_SESSION_HAS_EXPIRED" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKitabooReaderViewController];
//    NSString *alert_Msg  = [LocalizationHelper localizedStringWithKey:@"PLEASE_SIGN_IN_AGAIN" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForKitabooReaderViewController];
//    [[AlertView sharedManager] presentAlertWithTitle:alert_Title message:alert_Msg andButtonsWithTitle:@[@"Ok"] onController:readerVC dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//        [readerVC closeReaderForSessionExpiry];
//    }];
}

- (void)refreshUserTokenForUser:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken completed:(void (^)(KitabooUser *))completionHandler
{
    [self refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser * renewedUser) {
        if (completionHandler) {
            completionHandler(renewedUser);
        }
    } failed:^(NSError * error) {
        [self showSessionExpiredAlert];
    }];
}

- (void)refreshUserToken:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken completed:(void (^)(KitabooUser * _Nonnull))completionHandler failed:(void (^)(NSError * _Nonnull))errorHandler
{
    KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
        [kitabooServiceInterface refreshUserTokenWithToken:expiredUserToken successHandler:^(NSDictionary<NSString *,id> * json) {
            if ([json objectForKey:@"userToken"]) {
                user.userToken = [json objectForKey:@"userToken"];
                if (completionHandler) {
                    completionHandler(user);
                }
            }
        } failureHandler:^(NSError * error) {
            if (errorHandler) {
                errorHandler(error);
            }
        }];
}

- (void)syncUGCDataWithBookId:(NSString *)bookID WithUser:(KitabooUser*)user
{
    KitabooDataSyncingManager *_dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
    KitabooServiceMetaData *metaData = [[KitabooServiceMetaData alloc] init];
    metaData.initialisedValue = @"B";
    [_dataSyncManager saveUGCOperationForBookID:[bookID hsNumberValue] ForUserID:[NSNumber numberWithInt:user.userID.intValue] WithDelegate:self WithUserToken:user.userToken WithMetaData:metaData];
}

- (void)saveKitabooAnalyticsDataWithBookId:(NSString*)bookId WithUser:(KitabooUser*)user
{
    KitabooDataSyncingManager *_dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
    [_dataSyncManager saveTrackingDataForBookID:[bookId hsNumberValue] ForUserToken:user.userToken ForUserId:[NSNumber numberWithInt:user.userID.intValue]];
}

-(void)didUpdatedReadPercentageTo:(NSInteger)percentageRead ForBookID:(NSString *)bookID
{
    if([_delegate respondsToSelector:@selector(didUpdatedReadPercentageTo:ForBookID:)])
    {
        [_delegate didUpdatedReadPercentageTo:percentageRead ForBookID:bookID];
    }
}

#pragma mark KitabooDataSyncManagerDelegate Methods
-(void)didUGCSaveFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    NSDictionary *userDict = error.userInfo;
    NSDictionary *invalidDict = userDict[@"invalidFields"];
    NSString* userToken = [invalidDict[@"usertoken"] stringValue];
    if([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if([_userSettingsModel isAutoLoginEnabled])
        {
            [self refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                self->_user = renewedUser;
                [self syncUGCDataWithBookId:bookID WithUser:_user];
            } failed:^(NSError * error) {
                if ([_delegate respondsToSelector:@selector(didUGCSaveFailedWithError:withUserID:withBookID:)]) {
                    [_delegate didUGCSaveFailedWithError:error withUserID:userID withBookID:bookID];
                }
                if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
                    [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
                }
            }];
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(didUGCSaveFailedWithError:withUserID:withBookID:)]) {
                [_delegate didUGCSaveFailedWithError:error withUserID:userID withBookID:bookID];
            }
            if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
                [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
            }
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(didUGCSaveFailedWithError:withUserID:withBookID:)]) {
            [_delegate didUGCSaveFailedWithError:error withUserID:userID withBookID:bookID];
        }
    }
    
}

- (void)didUGCSaveCompletedSuccessfullyWithUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    if ([_delegate respondsToSelector:@selector(didUGCSaveCompletedSuccessfullyWithUserID:withBookID:)]) {
        [_delegate didUGCSaveCompletedSuccessfullyWithUserID:userID withBookID:bookID];
    }
}

- (void)didSaveTrackingDataSuccessfully
{
    if ([_delegate respondsToSelector:@selector(didSaveAnalyticsDataSuccessfully)]) {
        [_delegate didSaveAnalyticsDataSuccessfully];
    }
}

- (void)didSaveTrackingDataFailedWithError:(NSError *)error ForBookID:(NSNumber *)bookID ForUserId:(NSNumber *)userID
{
    NSDictionary *userDict = error.userInfo;
    NSDictionary *invalidDict = userDict[@"invalidFields"];
    NSString* userToken = [invalidDict[@"usertoken"] stringValue];
    if([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if([_userSettingsModel isAutoLoginEnabled])
        {
            [self refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                self->_user = renewedUser;
                [self saveKitabooAnalyticsDataWithBookId:[bookID stringValue] WithUser:_user];
            } failed:^(NSError * error) {
                 if ([_delegate respondsToSelector:@selector(didSaveAnalyticsDataFailedWithError:withUserID:withBookID:)]) {
                     [_delegate didSaveAnalyticsDataFailedWithError:error withUserID:[userID stringValue] withBookID:[bookID stringValue]];
                 }
                if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
                    [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
                }
            }];
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(didSaveAnalyticsDataFailedWithError:withUserID:withBookID:)]) {
                [_delegate didSaveAnalyticsDataFailedWithError:error withUserID:[userID stringValue] withBookID:[bookID stringValue]];
            }
            if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
                [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
            }
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(didSaveAnalyticsDataFailedWithError:withUserID:withBookID:)]) {
            [_delegate didSaveAnalyticsDataFailedWithError:error withUserID:[userID stringValue] withBookID:[bookID stringValue]];
        }
    }

}

/**
 Will be called when save furthest page request is successful
 */
-(void)didSaveFurthestPageDataSuccessfully:(NSNumber*)bookID{
    NSLog(@"didSaveFurthestPageDataSuccessfully for book id = %@",bookID);
}

/**
 Will be called when save furthest page request is failed
 *@param1 error is the save furthest request page ail error
 */
-(void)didFailedToSaveFurthestPageDataWithError:(NSError *)error ForBookID:(NSNumber*)bookID
{
    NSLog(@"didFailedToSaveFurthestPageDataWithError = %@ for book id = %@",error,bookID);
    if(error.code == 401)
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            [self refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                self->_user = renewedUser;
                KitabooDataSyncingManager *_dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
                [_dataSyncManager setMicroServicesBaseURLString:_kitabooServiceConfiguration.microServicesBaseURL];
                [_dataSyncManager saveFurthestPageDataForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
            } failed:^(NSError * error) {
                [self showSessionExpiredAlert];
            }];
        }else
        {
            [self showSessionExpiredAlert];
        }
    }
}

#pragma mark AudioBook
- (void)launchAudioBook:(KitabooAudioBookPackage *)book WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel
{
    _user = user;
    NSString *thumbnailURL;
    if([book isKindOfClass:[KitabooAudioBookPackage class]])
    {
       thumbnailURL = book.thumbnailURL;
    }
    else
    {
        thumbnailURL = @"";
    }
    _kitabooServiceConfiguration = kitabooServiceConfiguration;
    _userSettingsModel = readerSettingModel;
    _audioBookController = [[HDKitabooMediaBookController alloc] init];
    _audioBookController.delegate = self;
    [self.view addSubview:_audioBookController.view];
    [self addChildViewController:_audioBookController];    
    _audioBookController.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *))
    {
        [_audioBookController.view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
        [_audioBookController.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
        [_audioBookController.view.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = YES;
        [_audioBookController.view.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = YES;
    }
    else
    {
        [_audioBookController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
        [_audioBookController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
        [_audioBookController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_audioBookController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    }
    [_audioBookController setAudioThemeFilePath:[self getAudioThemePath]];
    [_audioBookController launchMediaReader:book.bookPath withBookID:[NSNumber numberWithInt:book.bookID.intValue] withBookISBN:book.isbn withThumbnailURL:thumbnailURL withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID WithUser:user withReaderSettings:readerSettingModel isAudioBook:YES withAdditionalInfo:nil];
}

- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration
{
    _userSettingsModel = [[HDReaderSettingModel alloc] init];
    [self launchHLSMediaBook:book IsDownloaded:isDownloaded IsAudioBook:isAudioBook WithKitabooUser:user WithKitabooServiceConfiguration:kitabooServiceConfiguration WithUserSettingsModel:_userSettingsModel enableCDNCookies:false];
}

- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration enableCDNCookies:(BOOL)enable
{
    _userSettingsModel = [[HDReaderSettingModel alloc] init];
    [self launchHLSMediaBook:book IsDownloaded:isDownloaded IsAudioBook:isAudioBook WithKitabooUser:user WithKitabooServiceConfiguration:kitabooServiceConfiguration WithUserSettingsModel:_userSettingsModel enableCDNCookies:enable];

}

- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel {
    
    [self launchHLSMediaBook:book IsDownloaded:isDownloaded IsAudioBook:isAudioBook WithKitabooUser:user WithKitabooServiceConfiguration:kitabooServiceConfiguration WithUserSettingsModel:readerSettingModel enableCDNCookies:false];

}

- (void)launchHLSMediaBook:(KitabooAudioBookPackage *)book IsDownloaded:(BOOL)isDownloaded IsAudioBook:(BOOL)isAudioBook WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration WithUserSettingsModel:(HDReaderSettingModel *)readerSettingModel enableCDNCookies:(BOOL)enable
{
    _user = user;
    NSString *thumbnailURL;
    if([book isKindOfClass:[KitabooAudioBookPackage class]]) {
       thumbnailURL = book.thumbnailURL;
    }else {
        thumbnailURL = @"";
    }
    _kitabooServiceConfiguration = kitabooServiceConfiguration;
    _userSettingsModel = readerSettingModel;
    _audioBookController = [[HDKitabooMediaBookController alloc] init];
    _audioBookController.delegate = self;
    if (_lastPageFolio) {
        _audioBookController.lastPageFolio = _lastPageFolio;
    }else{
        __weak typeof(_playerView) weakPlayerView = _playerView;
        [self setLastPageFolioToPlayer:_playerView withBookID:book.bookID success:^(NSString *lastPageFolio) {
            weakPlayerView.lastPageFolio = lastPageFolio;
        } failure:^(NSError *error) {
            
        }];
    }
    [self.view addSubview:_audioBookController.view];
    [self addChildViewController:_audioBookController];
    _audioBookController.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [_audioBookController.view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
        [_audioBookController.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
        [_audioBookController.view.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = YES;
        [_audioBookController.view.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = YES;
    }else {
        [_audioBookController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
        [_audioBookController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
        [_audioBookController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_audioBookController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    }
    [_audioBookController setAudioThemeFilePath:[self getAudioThemePath]];
    NSString *bookDownloadDestinationPath = [HDKitabooHLSDownloaderManager.shared getBookDownloadedPath:book.bookID];
//    NSString *prefix = @"wook";
//    NSMutableDictionary *otherInfo = [[NSMutableDictionary alloc] init];
//    [otherInfo setValue:prefix forKey:@"prefix"];
    NSMutableDictionary *otherInfo = nil;
    if(isDownloaded) {
        [_audioBookController launchOfflineHLSMedia:bookDownloadDestinationPath withBookID:[NSNumber numberWithInt:book.bookID.intValue] withThumbnailURL:thumbnailURL withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID WithUser:user isAudioBook:isAudioBook withBookISBN:book.isbn withReaderSettings:readerSettingModel withAdditionalInfo:otherInfo];
    }else {
        [_audioBookController launchOnlineHLSMedia:[NSNumber numberWithInt:book.bookID.intValue] withThumbnailURL:thumbnailURL withBaseURL:kitabooServiceConfiguration.baseURL microServicesURL:kitabooServiceConfiguration.microServicesBaseURL withClientID:kitabooServiceConfiguration.clientID WithUser:user withBookISBN:book.isbn withTimeStamp:[NSNumber numberWithInteger:([[NSDate alloc] initWithTimeIntervalSinceNow:0].timeIntervalSince1970)] isBookAudio:isAudioBook enableCDNCookies:enable withReaderSettings:readerSettingModel withAdditionalInfo:otherInfo];
    }
}


- (void)launchAudioBook:(KitabooAudioBookPackage *)book WithKitabooUser:(KitabooUser *)user WithKitabooServiceConfiguration:(KitabooServiceConfiguration *)kitabooServiceConfiguration
{
    _user = user;
    [self updateUserIDWithNumericValueForKitabooUser:user];
    NSString *thumbnailURL;
    if([book isKindOfClass:[KitabooAudioBookPackage class]])
    {
       thumbnailURL = book.thumbnailURL;
    }
    else
    {
        thumbnailURL = @"";
    }
    _kitabooServiceConfiguration = kitabooServiceConfiguration;
    _userSettingsModel = [[HDReaderSettingModel alloc] init];
    _audioBookController = [[HDKitabooMediaBookController alloc] init];
    _audioBookController.delegate = self;
    [self.view addSubview:_audioBookController.view];
    [self addChildViewController:_audioBookController];
    _audioBookController.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *))
    {
        [_audioBookController.view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
        [_audioBookController.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
        [_audioBookController.view.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = YES;
        [_audioBookController.view.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = YES;
    }
    else
    {
        [_audioBookController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
        [_audioBookController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
        [_audioBookController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
        [_audioBookController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    }
    [_audioBookController setAudioThemeFilePath:[self getAudioThemePath]];
    [_audioBookController launchMediaReader:book.bookPath withBookID:[NSNumber numberWithInt:book.bookID.intValue] withBookISBN:book.isbn withThumbnailURL:thumbnailURL withBaseURL:kitabooServiceConfiguration.baseURL withClientID:kitabooServiceConfiguration.clientID WithUser:user withReaderSettings:_userSettingsModel isAudioBook:YES withAdditionalInfo:nil];
}

- (void)didTapOnBackWithBookID:(NSString *)bookID withLastPageFolio:(NSString *)lastPageFolio
{
    [_audioBookController.view removeFromSuperview];
    [_audioBookController removeFromParentViewController];
    _audioBookController = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    NSDictionary *bookMetadataDict = [[NSDictionary alloc] initWithObjectsAndKeys:lastPageFolio,@"LastPageFolio", nil];
    HSDBManager *dbManager = [[HSDBManager alloc] init];
    [dbManager saveBookMetadata:bookMetadataDict ForBookID:[NSNumber numberWithInt:bookID.intValue] ForUserID:[NSNumber numberWithInteger:_user.userID.integerValue]];
    if ([_userSettingsModel isAudioBookBookmarkEnabled]) {
        KitabooDataSyncingManager *_dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:_kitabooServiceConfiguration.baseURL clientID:_kitabooServiceConfiguration.clientID];
        [_dataSyncManager saveUGCForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
       // [_dataSyncManager fetchUGCOperationForBookID:[NSNumber numberWithInt:bookID.intValue] ForUserID:[NSNumber numberWithInt:_user.userID.intValue] WithDelegate:self WithUserToken:_user.userToken];
        [_dataSyncManager saveTrackingDataForBookID:[NSNumber numberWithInt:bookID.intValue] ForUserToken:_user.userToken ForUserId:[NSNumber numberWithInt:_user.userID.intValue] WithMinimumTimeSpend:5000];
    }
    if ([_delegate respondsToSelector:@selector(didClosedReaderWithReader:WithBookId:WithUser:WithLastPageFolio:)]) {
        [_delegate didClosedReaderWithReader:self WithBookId:bookID WithUser:_user WithLastPageFolio:lastPageFolio];
    }
}
- (void) didUserSessionExpired {
    [self didLoginSessionExpired];
    if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
        [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
    }
}
- (void)didLoginSessionExpired
{
    [_audioBookController.view removeFromSuperview];
    [_audioBookController removeFromParentViewController];
    _audioBookController = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)refreshUserToken:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken completed:(void (^)(KitabooUser * _Nonnull))completionHandler
{
    [self refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser * renewedUser) {
        if (completionHandler) {
            completionHandler(renewedUser);
        }
    } failed:^(NSError * error) {
        
    }];
}

- (void)didHLSMediaLoadingFailWithError:(NSError *)error bookId:(NSNumber *)bookId timeStamp:(NSNumber *)timeStamp{
    if ([_delegate respondsToSelector:@selector(didHLSMediaLoadingFailWithError:bookId:timeStamp:)]) {
        [_delegate didHLSMediaLoadingFailWithError:error bookId:bookId timeStamp:timeStamp];
    }
}

- (UIImageView *)imageViewForThumbnail:(NSString *)thumbnailURL{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:thumbnailURL]];
    imageView.image = [UIImage imageWithData: imageData];
    return imageView;
}

- (void)didSavedUGCSuccessfully{
    if ([_delegate respondsToSelector:@selector(didUGCSaveCompletedSuccessfully)]) {
        [_delegate didUGCSaveCompletedSuccessfully];
    }
}

- (void)didFailedToSaveUGCWithError:(NSError *)error
{
    NSDictionary *userDictionary = error.userInfo;
    NSDictionary *invalidDic = userDictionary[@"invalidFields"];
    NSString *userToken = [NSString stringWithFormat:@"%@",[invalidDic valueForKey:@"usertoken"]];
    if ([userToken isEqualToString:HDReaderServiceConstants.responseStatusCode103])
    {
        if ([_userSettingsModel isAutoLoginEnabled])
        {
            [self refreshUserToken:_user withExpiredToken:_user.userToken completed:^(KitabooUser *renewedUser) {
                self->_user = renewedUser;
                KitabooDataSyncingManager *_dataSyncManager = [[KitabooDataSyncingManager alloc] initWithBaseURLString:self->_kitabooServiceConfiguration.baseURL clientID:self->_kitabooServiceConfiguration.clientID];
                [_dataSyncManager saveUGCForUserID:[NSNumber numberWithInt:self->_user.userID.intValue] WithDelegate:self WithUserToken:self->_user.userToken];
            } failed:^(NSError * error) {
                if ([_delegate respondsToSelector:@selector(didUGCSaveFailedWithError:)]) {
                    [_delegate didUGCSaveFailedWithError:error];
                }
                if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
                    [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
                }
            }];
        }else
        {
            if ([_delegate respondsToSelector:@selector(didUGCSaveFailedWithError:)]) {
                [_delegate didUGCSaveFailedWithError:error];
            }
            if ([_delegate respondsToSelector:@selector(didSessionExpiredWithUser:withExpiredToken:)]) {
                [_delegate didSessionExpiredWithUser:_user withExpiredToken:_user.userToken];
            }
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(didUGCSaveFailedWithError:)]) {
            [_delegate didUGCSaveFailedWithError:error];
        }
    }
}

-(void)setDelegate:(id<KitabooReaderViewControllerDelegate>)delegate
{
    _delegate = delegate;
}

-(void)updateUserWithUser:(KitabooUser*)user
{
    _user = user;
}

-(void)enableAutologin:(BOOL)isEnable
{
    if (_userSettingsModel) {
        _userSettingsModel.isAutoLoginEnabled = isEnable;
    }
}

#pragma mark AudioBook
- (void)dealloc{
    _screenCaptureResistController = nil;
    _userSettingsModel = nil;
    _kitabooServiceConfiguration = nil;
    _user = nil;
    _userSettingsModel = nil;
    _audioBookController = nil;
    _lastPageFolio = nil;
    _screenCaptureResistController = nil;
    _playerView = nil;
}

-(void)initializeMHEDelegateManager
{
    mheReaderViewController = [[MHEReaderViewController alloc] init];
}



@end

