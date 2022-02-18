//
//  ViewController.m
//
//  Created by Sumanth Myrala on 10/01/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import "ViewController.h"
@import KitabooSDKWithReader;
#import "SampleReaderConfigurationData.h"
#import "SampleReaderBookInfoManager.h"
#import "SampleReaderDownloadController.h"

#define Epub_Format_Name @"FIXED_EPUB_IMAGE"
#define Format_Name @"IPAD"
#define Unzipping @"Unzipping"
#define Loading @"Loading"
#define Retrying @"Retrying"

#define HLS_User_Name @"multiaudio.l2@yopmail.com"
#define HLS_Password @"kitaboo@123"
#define HLS_Audio_Thumbanil @"https://thumbnails.kitaboo.com/distribution/thumbnails/audioUpload/1562/491286.png"
#define HLS_Audio_BookID @"14230425"
#define HLS_Audio_BookISBN @"1234567210607"
#define HLS_Video_BookID @"14230425"
#define HLS_Video_BookISBN @"1234567210607"
#define MICRO_SERVICE_BASE_URL @"https://microservices.kitaboo.com/"

@interface ViewController ()<KitabooReaderViewControllerDelegate,SampleReaderDownloadControllerDelegate>
{
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *appName;
    __weak IBOutlet UIButton *launchEpubButton;
    __weak IBOutlet UIButton *launchKitabooFixed;
    __weak IBOutlet UIButton *launchFixedEpub;
    __weak IBOutlet UIButton *launchAudioBook;
    UIView *activityIndicatorView;
    KitabooReaderViewController *mainReader;
    
    __weak IBOutlet UILabel *reflowableEpubDownloadSizeLabel;
    __weak IBOutlet UILabel *kitabooFixedDownloadSizeLabel;
    __weak IBOutlet UILabel *fixedEpubDownloadSizeLabel;
    __weak IBOutlet UILabel *audioBookDownloadSizeLabel;
    
    __weak IBOutlet UILabel *hlsAudioBookDownloadSizeLabel;
    SampleReaderDownloadController *downloadController;
    
    __weak IBOutlet UIButton *playHLSAudio;
    __weak IBOutlet UIButton *playHLSVideo;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    launchEpubButton.layer.cornerRadius = 10;
    launchEpubButton.clipsToBounds = YES;
    launchKitabooFixed.layer.cornerRadius = 10;
    launchKitabooFixed.clipsToBounds = YES;
    launchFixedEpub.layer.cornerRadius = 10;
    launchFixedEpub.clipsToBounds = YES;
    launchAudioBook.layer.cornerRadius = 10;
    launchAudioBook.clipsToBounds = YES;
    descriptionLabel.layer.cornerRadius = 10;
    descriptionLabel.clipsToBounds = YES;
    playHLSAudio.layer.cornerRadius = 10;
    playHLSAudio.clipsToBounds = YES;
    playHLSVideo.layer.cornerRadius = 10;
    playHLSVideo.clipsToBounds = YES;
    for (NSDictionary *bookDict in [[SampleReaderConfigurationData getInstance] getArrayofBookIDs])
    {
        NSString *bookID = [bookDict valueForKey:@"bookID"];
        HDBookDownloadDetails *bookDetails = [HDBookDownloaderManager.shared getDownloadDetails:bookID];
        NSLog(@"Book Download State: %@",bookDetails.bookDownloadState);
        [self updateTextForButtonAfterDownloadforBookID:bookID];
    }
    NSDictionary *audioBookDict = [[SampleReaderConfigurationData getInstance] getBookIDFourDictionary];
    NSString *bookID = [audioBookDict valueForKey:@"bookID"];
    NSString *bookType = [audioBookDict valueForKey:@"bookType"];
    if ([bookType isEqualToString:@"AudioBook"] && [bookID isEqualToString:@""])
    {
        launchAudioBook.hidden = YES;
    }
    
    downloadController = [[SampleReaderDownloadController alloc] init];
    downloadController.delegate = self;
    

}

- (void)viewDidAppear:(BOOL)animated
{
    for (NSDictionary *bookDict in [[SampleReaderConfigurationData getInstance] getArrayofBookIDs])
    {
        NSString *bookID = [bookDict valueForKey:@"bookID"];
        HDBookDownloadDetails *bookDetails = [HDBookDownloaderManager.shared getDownloadDetails:bookID];
        if ([bookDetails.bookDownloadState isEqualToString:@"Failed"])
        {
            [self updateTextForButton:@"Resume" forDownloadSizeLabel:@"" forBookID:bookID];
        }
    }
    if ([[SampleReaderConfigurationData getInstance] isPrePackagedBooks])
    {
        [self updateButtonTextForPrePackagedBooks];
        launchAudioBook.hidden = NO;
    }
    if ([downloadController isHLSBookDownloaded:HLS_Audio_BookID]) {
        [playHLSAudio setTitle:@"Launch HLS Audio" forState:UIControlStateNormal];
        [playHLSAudio setTitle:@"Launch HLS Audio" forState:UIControlStateSelected];
    }
    
    //Uncomment to show audio Button
    launchAudioBook.hidden=YES;
    playHLSAudio.hidden=YES;
    playHLSVideo.hidden=YES;
}


//Action for launch reflowable epub book button.
- (IBAction)didClickOnLaunchBtn:(id)sender
{
//    [self launchEpubFilePackage];
//    return;
    
    [self launchBookWithBookID:[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookID"] withFormatName:[self getBookFormat:[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary]] withISBN:[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"ISBN"]];
}

//Action for launch kitaboo fixed book button.
- (IBAction)didTapOnLaunchKitabooFixed:(id)sender
{
    [self launchBookWithBookID:[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookID"] withFormatName:[self getBookFormat:[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary]] withISBN:[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"ISBN"]];
}

//Action for launch fixed epub book button.
- (IBAction)didTapOnFixedEpub:(id)sender
{
    [self launchBookWithBookID:[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookID"] withFormatName:[self getBookFormat:[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary]] withISBN:[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"ISBN"]];
}

//Action for launch audio book button.
- (IBAction)didTapOnLaunchAudioBook:(id)sender {
    if ([[KitabooNetworkManager getInstance] isInternetAvailable])
    {
        NSDictionary *audioBookDict = [[SampleReaderConfigurationData getInstance] getBookIDFourDictionary];
                NSString *bookFourID = [audioBookDict valueForKey:@"bookID"];
        //        NSString *bookType = [audioBookDict valueForKey:@"bookType"];
        HDBookDownloadDetails *bookDetails = [HDBookDownloaderManager.shared getDownloadDetails:bookFourID];
        if (([bookDetails.bookDownloadState isEqualToString:@"Downloading"]))
        {
            [self->downloadController pauseBookWithBookID:bookFourID isHLSBook:false];
            return;
        }
        [self addPreLoaderView];
        KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:[[SampleReaderConfigurationData getInstance] getBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID]];
        [kitabooServiceInterface authenticateWithUserName:[[SampleReaderConfigurationData getInstance] getLoginUserName] password:[[SampleReaderConfigurationData getInstance] getLoginPassword] successHandler:^(NSDictionary *json)
         {
            KitabooUser *user = [[KitabooUser alloc] initWithUserInfo:[json objectForKey:@"user"] userToken:[json objectForKey:@"userToken"]];
            if (![[SampleReaderBookInfoManager getInstance] isBookDownloadedForBookID:bookFourID] && ![[SampleReaderConfigurationData getInstance] isPrePackagedBooks]) {
                [self updateTextForButton:Loading forDownloadSizeLabel:@"" forBookID:bookFourID];
                [self isUserInteractionDisabled:YES forBookID:bookFourID];
                [self->downloadController downloadBookForBookID:bookFourID forUserToken:[json objectForKey:@"userToken"] forFormat:Format_Name isHLSBook:false isAudioBook:false kitabooUser:user withAudioBookThumbnailURL:@""];
                NSLog(@"Login Success With Data-->%@",json);
                [self removePreLoaderView];
            }
            else{
                [self removePreLoaderView];
                
                [kitabooServiceInterface fetchUserSettings:[json objectForKey:@"userToken"] successHandler:^(NSDictionary *json){
                    NSLog(@"FetchUserSettings:%@",json);
                    HDReaderSettingModel *userSettingsModel = [self getUserSettingsModelForDictionary:json];
                    
                    if (self->mainReader) {
                        self->mainReader = nil;
                    }
                    self->mainReader = [[KitabooReaderViewController alloc] init];
                    self->mainReader.delegate = self;
                    [self.view addSubview:self->mainReader.view];
                    [self addChildViewController:self->mainReader];
                    NSString *bookID;
                    NSString *bookPath;
                    if ([[SampleReaderConfigurationData getInstance] isPrePackagedBooks]) {
                        NSArray *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                        NSString *directoryPath = [[libraryPath objectAtIndex:0] stringByAppendingString:@"/31279"];
                        NSString *imagePathFromApp = [[NSBundle mainBundle] pathForResource:@"TestingBooks/31279" ofType:nil];
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSError *error;
                        if (![fileManager fileExistsAtPath:directoryPath])
                        {
                            [fileManager copyItemAtPath:imagePathFromApp toPath:directoryPath error:&error];
                        }
                        bookPath = directoryPath;
                        bookID = @"31279";
                    }
                    else{
                        bookPath = [self getBookDownloadPathForBook:bookID];
                        bookID = bookID;
                    }
                    KitabooServiceConfiguration *config = [[KitabooServiceConfiguration alloc] initWithBaseURL:[[SampleReaderConfigurationData getInstance] getBaseURL] WithClientID:[[SampleReaderConfigurationData getInstance] getClientID]];
                    config.microServicesBaseURL = MICRO_SERVICE_BASE_URL;
                    KitabooAudioBookPackage *book = [[KitabooAudioBookPackage alloc] initWithAudioBookAtPath:bookPath WithBookID:bookID WithISBN:@"14113544" withThumbnailURL:@"https://hurix-production-content.s3.amazonaws.com/distribution/thumbnails/audioUpload/836/1589873310954.jpg?225638472658245;d"];//
                    [self->mainReader launchAudioBook:book WithKitabooUser:user WithKitabooServiceConfiguration:config WithUserSettingsModel:userSettingsModel];//
                    self->mainReader.view.frame = self.view.bounds;
                } failureHandler:^(NSError *error){
                    NSLog(@"FetchUserSettings Error:%@",error.localizedDescription);
                    [self removePreLoaderView];
                }];
                
            }
        } failureHandler:^(NSError *error) {
            NSLog(@"Login Failed %@",[error localizedDescription]);
            [self removePreLoaderView];
        }];
    }
}

    - (void)launchBookWithBookID:(NSString *)bookId withFormatName:(NSString *)formatName withISBN:(NSString *)isbn{
        if ([[KitabooNetworkManager getInstance] isInternetAvailable])
        {
            HDBookDownloadDetails *bookDetails = [HDBookDownloaderManager.shared getDownloadDetails:bookId];
            if (([bookDetails.bookDownloadState isEqualToString:@"Downloading"]))
            {
                [self->downloadController pauseBookWithBookID:bookId isHLSBook:false];
                return;
            }
            [self addPreLoaderView];
            KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:[[SampleReaderConfigurationData getInstance] getBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID]];
            [kitabooServiceInterface authenticateWithUserName:[[SampleReaderConfigurationData getInstance] getLoginUserName] password:[[SampleReaderConfigurationData getInstance] getLoginPassword] successHandler:^(NSDictionary *json)
             {
                KitabooUser *user = [[KitabooUser alloc] initWithUserInfo:[json objectForKey:@"user"] userToken:[json objectForKey:@"userToken"]];
                if (![[SampleReaderBookInfoManager getInstance] isBookDownloadedForBookID:bookId] && ![[SampleReaderConfigurationData getInstance] isPrePackagedBooks]) {
                    [self updateTextForButton:Loading forDownloadSizeLabel:@"" forBookID:bookId];
                    [self isUserInteractionDisabled:YES forBookID:bookId];
                    [self->downloadController downloadBookForBookID:bookId forUserToken:[json objectForKey:@"userToken"] forFormat:formatName isHLSBook:false isAudioBook:false kitabooUser:user withAudioBookThumbnailURL:@""];
                    NSLog(@"Login Success With Data-->%@",json);
                    [self removePreLoaderView];
                }
                else{
                    
                    [kitabooServiceInterface fetchUserSettings:user.userToken successHandler:^(NSDictionary *json){
                        NSLog(@"FetchUserSettings:%@",json);
                        [self removePreLoaderView];
                        HDReaderSettingModel *userSettingsModel = [self getUserSettingsModelForDictionary:json];
                        
                        if (self->mainReader) {
                            self->mainReader = nil;
                        }
                        self->mainReader = [[KitabooReaderViewController alloc] init];
                        self->mainReader.delegate = self;
                        [self.view addSubview:self->mainReader.view];
                        [self addChildViewController:self->mainReader];
                        NSString *bookID;
                        NSString *bookPath;
                        if ([[SampleReaderConfigurationData getInstance] isPrePackagedBooks]) {
                            bookID = bookId;
                            NSArray *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                            NSString *directoryPath = [[libraryPath objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@",bookID]];
                            NSString *imagePathFromApp = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"TestingBooks/%@",bookID] ofType:nil];
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            NSError *error;
                            if (![fileManager fileExistsAtPath:directoryPath])
                            {
                                [fileManager copyItemAtPath:imagePathFromApp toPath:directoryPath error:&error];
                            }
                            bookPath = directoryPath;
                        }
                        else{
                            bookPath = [self getBookDownloadPathForBook:bookId];
                            bookID = bookId;
                        }
                        KitabooServiceConfiguration *config = [[KitabooServiceConfiguration alloc] initWithBaseURL:[[SampleReaderConfigurationData getInstance] getBaseURL] WithClientID:[[SampleReaderConfigurationData getInstance] getClientID]];
                        config.microServicesBaseURL = MICRO_SERVICE_BASE_URL;
                        KitabooBookPackage *book = [[KitabooBookPackage alloc]initWithBookAtPath:bookPath WithBookID:bookID WithISBN:@"1234567891"];
                        book.encryptionType = @"V1";
                        [self->mainReader launchBook:book WithKitabooUser:user WithKitabooServiceConfiguration:config WithUserSettingsModel:userSettingsModel withClassAssociation:YES];
                        self->mainReader.view.frame = self.view.bounds;
                        [self->mainReader enableFurthestPage:NO];
                    } failureHandler:^(NSError *error){
                        NSLog(@"FetchUserSettings Error:%@",error.localizedDescription);
                        [self removePreLoaderView];
                    }];
                }
            } failureHandler:^(NSError *error) {
                NSLog(@"Login Failed %@",[error localizedDescription]);
                [self removePreLoaderView];
            }];
        }
        else{
            [self showNoInternetAlert];
        }
    }

- (NSDictionary *)getAuthenticateUserResponseDictionary
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loginResponse" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSDictionary *)getFetchUserSettingsResponseDictionary
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fetchUserSettingsResponse" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (HDReaderSettingModel *)getUserSettingsModelForDictionary:(NSDictionary*)dictionary
{
    HDReaderSettingModel *userSettingsModel = [[HDReaderSettingModel alloc] init];
    NSDictionary *userDict;
    if (dictionary)
    {
        userDict = dictionary;
    }
    else
    {
        userDict = [self getFetchUserSettingsResponseDictionary];
    }

    NSArray *userDataListArray = [[[userDict valueForKey:@"instituteSetting"] valueForKey:@"readerSetting"] valueForKey:@"userDataList"];
    for (NSDictionary *userDataDict in userDataListArray)
    {
        if ([[userDataDict objectForKey: @"name"] isEqualToString:@"BOOKMARK"] ) {
            [userSettingsModel setIsBookmarkEnabled:[[userDataDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[userDataDict objectForKey: @"name"] isEqualToString:@"ENABLE SHARING"]){
            [userSettingsModel setIsSharingEnabled:[[userDataDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[userDataDict objectForKey: @"name"] isEqualToString:@"HIGHLIGHT"]){
            [userSettingsModel setIsHighLightEnabled:[[userDataDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[userDataDict objectForKey: @"name"] isEqualToString:@"NOTES"]){
            [userSettingsModel setIsStickyNotesEnabled:[[userDataDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[userDataDict objectForKey: @"name"] isEqualToString:@"CONTEXTUALNOTES_MULTICOLOR"]){
            [userSettingsModel setIsContextualNoteEnabled:[[userDataDict valueForKey:@"enable"] boolValue]];
        }
    }

    NSArray *miscListArray = [[[userDict valueForKey:@"instituteSetting"] valueForKey:@"readerSetting"] valueForKey:@"miscList"];
    for (NSDictionary *miscListDict in miscListArray)
    {
        if ([[miscListDict objectForKey: @"name"] isEqualToString:@"AUTO LOG OFF"]) {
            [userSettingsModel setIsAutoLoginEnabled:[[miscListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[miscListDict objectForKey: @"name"] isEqualToString:@"ANALYTICS"]) {
            [userSettingsModel setIsAnalyicsButtonEnabled:[[miscListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[miscListDict objectForKey: @"name"] isEqualToString:@"Math Editor"]) {
            [userSettingsModel setIsMathEditorEnabled:[[miscListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[miscListDict objectForKey: @"name"] isEqualToString:@"Protractor"]) {
            [userSettingsModel setIsProtractorEnabled:[[miscListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[miscListDict objectForKey: @"name"] isEqualToString:@"CLEAR ALL FIBS"]) {
            [userSettingsModel setIsClearAllFIBsEnabled:[[miscListDict valueForKey:@"enable"] boolValue]];
        }
    }

    NSArray *toolListArray = [[[userDict valueForKey:@"instituteSetting"] valueForKey:@"readerSetting"] valueForKey:@"toolList"];
    for (NSDictionary *toolListDict in toolListArray)
    {
        if ([[toolListDict objectForKey: @"name"] isEqualToString:@"SEARCH"]) {
            [userSettingsModel setIsSearchEnabled:[[toolListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[toolListDict objectForKey: @"name"] isEqualToString:@"AUTO READ ALOUD"]) {
            [userSettingsModel setIsAutoReadAloudEnabled:[[toolListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[toolListDict objectForKey: @"name"] isEqualToString:@"PEN"]) {
            [userSettingsModel setPentoolPenColors:[toolListDict objectForKey: @"colors"]];
        }
    }

    NSArray *annotationListArray = [[[userDict valueForKey:@"instituteSetting"] valueForKey:@"readerSetting"] valueForKey:@"annotationList"];
    for (NSDictionary *annotationListDict in annotationListArray)
    {
        if ([[annotationListDict objectForKey: @"name"] isEqualToString:@"ENABLE REVIEW"]) {
            [userSettingsModel setIsReviewEnabled:[[annotationListDict valueForKey:@"enable"] boolValue]];
        }
        else if ([[annotationListDict objectForKey: @"name"] isEqualToString:@"PEN TOOL"]) {
            [userSettingsModel setIsPenToolEnabled:[[annotationListDict valueForKey:@"enable"] boolValue]];
        }
    }
    return userSettingsModel;
}

-(void)didClosedReaderWithReader:(UIViewController *)reader WithBookId:(NSString *)bookId WithUser:(KitabooUser *)user WithLastPageFolio:(NSString *)lastPageFolio
{
    [mainReader.view removeFromSuperview];
    [mainReader removeFromParentViewController];
}

-(void)didSessionExpiredWithUser:(KitabooUser *)user withExpiredToken:(NSString *)expiredUserToken
{
    [mainReader.view removeFromSuperview];
    [mainReader removeFromParentViewController];
}

-(void)didUGCSaveFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    
}

-(void)didUGCSaveFailedWithError:(NSError *)error
{
    
}

-(void)didUGCSaveCompletedSuccessfullyWithUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    
}

-(void)didUGCSaveCompletedSuccessfully
{
    
}

-(void)didSaveAnalyticsDataFailedWithError:(NSError *)error withUserID:(NSString *)userID withBookID:(NSString *)bookID
{
    
}

-(void)didSaveAnalyticsDataSuccessfully
{
    
}

-(void)addPreLoaderView

{
    activityIndicatorView=nil;
    activityIndicatorView = [[UIView alloc]init];
    [activityIndicatorView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.50]];
    activityIndicatorView.tintColor=[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    [self.view addSubview:activityIndicatorView];
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    
    UIView *view = [[UIView alloc]init];
    [activityIndicatorView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:activityIndicatorView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:activityIndicatorView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:280]];
    [activityIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    
    if (@available(iOS 13.0, *)) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [activityIndicator startAnimating];
        [view addSubview:activityIndicator];
        activityIndicator.translatesAutoresizingMaskIntoConstraints =NO;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
        
        UILabel *loadingDataLabel = [[UILabel alloc]init];
        [loadingDataLabel setText : @"Authenticating User..."];
        [loadingDataLabel setTextColor:[UIColor whiteColor]];
        [loadingDataLabel setFont:getCustomFont(20)];
        [loadingDataLabel sizeToFit];
        loadingDataLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:loadingDataLabel];
        loadingDataLabel.translatesAutoresizingMaskIntoConstraints =NO;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:activityIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:loadingDataLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    } else {
        // Fallback on earlier versions
    }
    
    
}

-(void)removePreLoaderView
{
    [activityIndicatorView removeFromSuperview];
    activityIndicatorView=nil;
}


#pragma mark  Utility Methods

//This method should be called to get the update button and progress text when the book is being downloading.
- (void)updateTextForButton:(NSString *)buttonTitle forDownloadSizeLabel:(NSString *)downloadSizeText forBookID:(NSString *)bookID
{
    [self isUserInteractionDisabled:NO forBookID:bookID];
            
    if ([bookID isEqualToString:[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookID"]])
    {
        [launchEpubButton setTitle:buttonTitle forState:UIControlStateNormal];
        [launchEpubButton setTitle:buttonTitle forState:UIControlStateSelected];
        reflowableEpubDownloadSizeLabel.text = downloadSizeText;
        if ([buttonTitle isEqualToString:Unzipping] || [buttonTitle isEqualToString:Retrying]){
            launchEpubButton.userInteractionEnabled = NO;
        }
        else{
            launchEpubButton.userInteractionEnabled = YES;
        }
    }
    else if ([bookID isEqualToString:[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookID"]]){
        [launchFixedEpub setTitle:buttonTitle forState:UIControlStateNormal];
        [launchFixedEpub setTitle:buttonTitle forState:UIControlStateSelected];
        fixedEpubDownloadSizeLabel.text = downloadSizeText;
        if ([buttonTitle isEqualToString:Unzipping] || [buttonTitle isEqualToString:Retrying]){
            launchFixedEpub.userInteractionEnabled = NO;
        }
        else{
            launchFixedEpub.userInteractionEnabled = YES;
        }
    }
    else if ([bookID isEqualToString:[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookID"]]){
        [launchKitabooFixed setTitle:buttonTitle forState:UIControlStateNormal];
        [launchKitabooFixed setTitle:buttonTitle forState:UIControlStateSelected];
        kitabooFixedDownloadSizeLabel.text = downloadSizeText;
        if ([buttonTitle isEqualToString:Unzipping] || [buttonTitle isEqualToString:Retrying]){
            launchKitabooFixed.userInteractionEnabled = NO;
        }
        else{
            launchKitabooFixed.userInteractionEnabled = YES;
        }
    }else if ([bookID isEqualToString:HLS_Audio_BookID]) {
        [playHLSAudio setTitle:buttonTitle forState:UIControlStateNormal];
        [playHLSAudio setTitle:buttonTitle forState:UIControlStateSelected];
        hlsAudioBookDownloadSizeLabel.text = downloadSizeText;
        if ([buttonTitle isEqualToString:@"Downloading"] || [buttonTitle isEqualToString:@"Loading"]){
            playHLSAudio.userInteractionEnabled = NO;
        }else{
            playHLSAudio.userInteractionEnabled = YES;
        }
    }else{
        [launchAudioBook setTitle:buttonTitle forState:UIControlStateNormal];
        [launchAudioBook setTitle:buttonTitle forState:UIControlStateSelected];
        audioBookDownloadSizeLabel.text = downloadSizeText;
        if ([buttonTitle isEqualToString:Unzipping] || [buttonTitle isEqualToString:Retrying]){
            launchAudioBook.userInteractionEnabled = NO;
        }
        else{
            launchAudioBook.userInteractionEnabled = YES;
        }
    }
}

//This method should be called to update the text of the button based on the download status
- (void)updateTextForButtonAfterDownloadforBookID:(NSString *)bookID
{
    
    if ([bookID isEqualToString:[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookID"]])
    {
        launchEpubButton.userInteractionEnabled = YES;
        if ([[SampleReaderBookInfoManager getInstance] isBookDownloadedForBookID:bookID])
        {
            [launchEpubButton setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchEpubButton setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        else
        {
            [launchEpubButton setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchEpubButton setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        reflowableEpubDownloadSizeLabel.text = @"";
    }
    else if ([bookID isEqualToString:[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookID"]]){
        launchFixedEpub.userInteractionEnabled = YES;
        if ([[SampleReaderBookInfoManager getInstance] isBookDownloadedForBookID:bookID])
        {
            [launchFixedEpub setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchFixedEpub setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        else
        {
            [launchFixedEpub setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchFixedEpub setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        fixedEpubDownloadSizeLabel.text = @"";
    }
    else if ([bookID isEqualToString:[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookID"]]){
        launchKitabooFixed.userInteractionEnabled = YES;
        if ([[SampleReaderBookInfoManager getInstance] isBookDownloadedForBookID:bookID])
        {
            [launchKitabooFixed setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchKitabooFixed setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        else
        {
            [launchKitabooFixed setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchKitabooFixed setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        kitabooFixedDownloadSizeLabel.text = @"";
    }else if ([bookID isEqualToString:HLS_Audio_BookID]) {
        playHLSAudio.userInteractionEnabled = YES;
        if ([downloadController isHLSBookDownloaded:HLS_Audio_BookID]) {
            [playHLSAudio setTitle:@"Launch HLS Audio" forState:UIControlStateNormal];
            [playHLSAudio setTitle:@"Launch HLS Audio" forState:UIControlStateSelected];
        }else{
            [playHLSAudio setTitle:@"Download HLS Audio" forState:UIControlStateNormal];
            [playHLSAudio setTitle:@"Download HLS Audio" forState:UIControlStateSelected];
        }
        hlsAudioBookDownloadSizeLabel.text = @"";
    }
    else{
        launchAudioBook.userInteractionEnabled = YES;
        if ([[SampleReaderBookInfoManager getInstance] isBookDownloadedForBookID:bookID])
        {
            [launchAudioBook setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchAudioBook setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        else
        {
            [launchAudioBook setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
            [launchAudioBook setTitle:[NSString stringWithFormat:@"Download %@",[[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
        }
        audioBookDownloadSizeLabel.text = @"";
    }
}

- (void)updateButtonTextForPrePackagedBooks
{
    [launchEpubButton setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
    [launchEpubButton setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
    
    [launchFixedEpub setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
    [launchFixedEpub setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
    
    [launchKitabooFixed setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
    [launchKitabooFixed setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
    
    [launchAudioBook setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateNormal];
    [launchAudioBook setTitle:[NSString stringWithFormat:@"Launch %@",[[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary] valueForKey:@"bookTitle"]] forState:UIControlStateSelected];
}

//This method should be called to disable the user interaction of the button WRT bookid

- (void)isUserInteractionDisabled:(BOOL)disable forBookID:(NSString *)bookID
{
    if ([[[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary] valueForKey:@"bookID"] isEqualToString:bookID])
    {
        if (disable){
            launchEpubButton.userInteractionEnabled = NO;
        }
        else{
            launchEpubButton.userInteractionEnabled = YES;
        }
    }
    else if ([[[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary] valueForKey:@"bookID"] isEqualToString:bookID]){
        if (disable){
            launchFixedEpub.userInteractionEnabled = NO;
        }
        else{
            launchFixedEpub.userInteractionEnabled = YES;
        }
    }
    else if ([[[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary] valueForKey:@"bookID"] isEqualToString:bookID]){
        if (disable){
            launchKitabooFixed.userInteractionEnabled = NO;
        }
        else{
            launchKitabooFixed.userInteractionEnabled = YES;
        }
    }
    else{
        if (disable){
            launchAudioBook.userInteractionEnabled = NO;
        }
        else{
            launchAudioBook.userInteractionEnabled = YES;
        }
    }
}

//This method should be called to show an alert when the internet connection is unavailable
-(void)showNoInternetAlert
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
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

//This method should be called to Pause the downloading book
- (void)pauseDownloadingBook:(NSString *)bookID
{
    HDBookDownloadDetails *bookDetails = [HDBookDownloaderManager.shared getDownloadDetails:bookID];
    if (([bookDetails.bookDownloadState isEqualToString:@"Downloading"]))
    {
        [self->downloadController pauseBookWithBookID:bookID isHLSBook:false];
        return;
    }
}

- (NSString *)getBookFormat:(NSDictionary *)bookDictionary
{
    NSString *bookType = [bookDictionary valueForKey:@"bookType"];
    if ([bookType isEqualToString:@"FixedEpub"] || [bookType isEqualToString:@"Reflowable"])
    {
        return Epub_Format_Name;
    }
    return Format_Name;
}

#pragma mark  SampleReaderDownloadControllerDelegate Methods
- (void)didUpdateDownloadStatus:(NSString *)text withDownloadProgress:(NSString *)progress forBookID:(NSString *)bookID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTextForButton:text forDownloadSizeLabel:progress forBookID:bookID];
    });
}

- (void)didBookUnzippedForBookID:(NSString *)bookID
{
    [self updateTextForButtonAfterDownloadforBookID:bookID];
}

- (void)didBookUnzipFailedWithError:(NSError *)error forBookID:(NSString *)bookID
{
    [self updateTextForButtonAfterDownloadforBookID:bookID];
}

- (void)didBookDownloadFailedWithError:(NSError *)error forBookID:(NSString *)bookID
{
    [self isUserInteractionDisabled:NO forBookID:bookID];
    [self updateTextForButtonAfterDownloadforBookID:bookID];
}

#pragma mark EpubFile Sample
- (void)launchEpubFilePackage
{
    NSArray *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *destinationPath = [libraryPath objectAtIndex:0];
    NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:@"TestingBooks/1600956607_THEPOSSIBILITY.epub" ofType:nil];
    
    HDEpubPackageHandler *fileHandler = [[HDEpubPackageHandler alloc] init];
    [fileHandler extractEpubFromPath:sourceFilePath toDestinationPath:destinationPath completed:^(NSString * extractedFilePath, NSError *error) {
        
        [self launchExtractedEpubPackage:extractedFilePath];
    }];
}

- (void)launchExtractedEpubPackage:(NSString *)extractedFilePath
{
    if ([[KitabooNetworkManager getInstance] isInternetAvailable])
    {
        [self addPreLoaderView];
        KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:[[SampleReaderConfigurationData getInstance] getBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID]];
        [kitabooServiceInterface authenticateWithUserName:[[SampleReaderConfigurationData getInstance] getLoginUserName] password:[[SampleReaderConfigurationData getInstance] getLoginPassword] successHandler:^(NSDictionary *json)
         {
            
                KitabooUser *user = [[KitabooUser alloc] initWithUserInfo:[json objectForKey:@"user"] userToken:[json objectForKey:@"userToken"]];
                
                [kitabooServiceInterface fetchUserSettings:user.userToken successHandler:^(NSDictionary *json){
                    NSLog(@"FetchUserSettings:%@",json);
                    [self removePreLoaderView];
                    HDReaderSettingModel *userSettingsModel = [self getUserSettingsModelForDictionary:json];
                    
                    if (self->mainReader) {
                        self->mainReader = nil;
                    }
                    self->mainReader = [[KitabooReaderViewController alloc] init];
                    self->mainReader.delegate = self;
                    [self.view addSubview:self->mainReader.view];
                    [self addChildViewController:self->mainReader];
                    NSString *bookID = @"1600956607";
                    KitabooServiceConfiguration *config = [[KitabooServiceConfiguration alloc] initWithBaseURL:[[SampleReaderConfigurationData getInstance] getBaseURL] WithClientID:[[SampleReaderConfigurationData getInstance] getClientID]];
                    config.microServicesBaseURL = MICRO_SERVICE_BASE_URL;
                    KitabooBookPackage *book = [[KitabooBookPackage alloc]initWithBookAtPath:extractedFilePath WithBookID:bookID WithISBN:@"1600956607"];
                    book.encryptionType = @"V1";
                    [self->mainReader launchBook:book WithKitabooUser:user WithKitabooServiceConfiguration:config WithUserSettingsModel:userSettingsModel withClassAssociation:YES];
                    self->mainReader.view.frame = self.view.bounds;
                    [self->mainReader enableFurthestPage:NO];

                } failureHandler:^(NSError *error){
                    NSLog(@"FetchUserSettings Error:%@",error.localizedDescription);
                    [self removePreLoaderView];
                }];
        } failureHandler:^(NSError *error) {
            NSLog(@"Login Failed %@",[error localizedDescription]);
            [self removePreLoaderView];
        }];
    }
    else{
        [self showNoInternetAlert];
    }
}

-(void)didUpdatedReadPercentageTo:(NSInteger)percentageRead ForBookID:(NSString *)bookID
{
}

- (IBAction)didTapOnHLSAudioButton:(UIButton *)sender {
    if ([[KitabooNetworkManager getInstance] isInternetAvailable]){
        [self addPreLoaderView];
        KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:[[SampleReaderConfigurationData getInstance] getBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID]];
        [kitabooServiceInterface authenticateWithUserName:HLS_User_Name password:HLS_Password successHandler:^(NSDictionary *json)
        {
            KitabooUser *user = [[KitabooUser alloc] initWithUserInfo:[json objectForKey:@"user"] userToken:[json objectForKey:@"userToken"]];
            [kitabooServiceInterface fetchUserSettings:[json objectForKey:@"userToken"] successHandler:^(NSDictionary *json){
                if (![self->downloadController isHLSBookDownloaded:HLS_Audio_BookID])
                {
                    [self updateTextForButton:Loading forDownloadSizeLabel:@"" forBookID:HLS_Audio_BookID];
                    [self isUserInteractionDisabled:YES forBookID:HLS_Audio_BookID];
                    [self->downloadController downloadBookForBookID:HLS_Audio_BookID forUserToken:[json objectForKey:@"userToken"] forFormat:Format_Name isHLSBook:true isAudioBook:true kitabooUser:user withAudioBookThumbnailURL:HLS_Audio_Thumbanil];
                    [self removePreLoaderView];
                }
                else
                {
                    [self removePreLoaderView];
                    if (self->mainReader) {
                        self->mainReader = nil;
                    }
                    self->mainReader = [[KitabooReaderViewController alloc] init];
                    self->mainReader.delegate = self;
                    [self.view addSubview:self->mainReader.view];
                    [self addChildViewController:self->mainReader];

                    KitabooServiceConfiguration *config = [[KitabooServiceConfiguration alloc] initWithBaseURL:[[SampleReaderConfigurationData getInstance] getBaseURL] WithClientID:[[SampleReaderConfigurationData getInstance] getClientID]];
                    config.microServicesBaseURL = MICRO_SERVICE_BASE_URL;
                    KitabooAudioBookPackage *book = [[KitabooAudioBookPackage alloc] initWithAudioBookAtPath:@"" WithBookID:HLS_Audio_BookID WithISBN:HLS_Audio_BookISBN withThumbnailURL:HLS_Audio_Thumbanil];
                    
                    [self->mainReader launchHLSMediaBook:book IsDownloaded:YES IsAudioBook:YES WithKitabooUser:user WithKitabooServiceConfiguration:config];
                                    
                    self->mainReader.view.frame = self.view.bounds;
                }
                
            } failureHandler:^(NSError *error){
                [self removePreLoaderView];
            }];
            
        } failureHandler:^(NSError *error) {
            [self removePreLoaderView];
        }];
    }else {
        [self removePreLoaderView];
        [self showNoInternetAlert];
    }
}

- (IBAction)didTapOnHLSVideoButton:(UIButton *)sender {
    if ([[KitabooNetworkManager getInstance] isInternetAvailable]){
        [self addPreLoaderView];
        KitabooServiceInterface *kitabooServiceInterface = [[KitabooServiceInterface alloc] initWithBaseURLString:[[SampleReaderConfigurationData getInstance] getBaseURL] clientID:[[SampleReaderConfigurationData getInstance] getClientID]];
        [kitabooServiceInterface authenticateWithUserName:HLS_User_Name password:HLS_Password successHandler:^(NSDictionary *json) {
            KitabooUser *user = [[KitabooUser alloc] initWithUserInfo:[json objectForKey:@"user"] userToken:[json objectForKey:@"userToken"]];
            [kitabooServiceInterface fetchUserSettings:[json objectForKey:@"userToken"] successHandler:^(NSDictionary *json){
                HDReaderSettingModel *userSettingsModel = [self getUserSettingsModelForDictionary:json];
                [self launchHLSMediaReader:[NSString stringWithFormat:@"%@",HLS_Audio_BookID].integerValue withThumbnail:HLS_Audio_Thumbanil withUser:user withISBN:HLS_Audio_BookISBN isAudiobook:YES withuserSettingsModel:userSettingsModel];
            } failureHandler:^(NSError *error){
                [self removePreLoaderView];
            }];
            
        } failureHandler:^(NSError *error) {
            [self removePreLoaderView];
        }];
    }else {
        [self removePreLoaderView];
        [self showNoInternetAlert];
    }
}

-(void)launchHLSMediaReader:(NSInteger)bookID withThumbnail:(NSString*)thumbnail_url withUser:(KitabooUser *)user withISBN:(NSString *)isbn isAudiobook:(BOOL)isAudioBook withuserSettingsModel:(HDReaderSettingModel*)userSettingsModel
{
       [self removePreLoaderView];
       if (self->mainReader) {
           self->mainReader = nil;
       }
       self->mainReader = [[KitabooReaderViewController alloc] init];
       self->mainReader.delegate = self;
       [self.view addSubview:self->mainReader.view];
       [self addChildViewController:self->mainReader];

       KitabooServiceConfiguration *config = [[KitabooServiceConfiguration alloc] initWithBaseURL:[[SampleReaderConfigurationData getInstance] getBaseURL] WithClientID:[[SampleReaderConfigurationData getInstance] getClientID]];
        config.microServicesBaseURL = MICRO_SERVICE_BASE_URL;
       KitabooAudioBookPackage *book = [[KitabooAudioBookPackage alloc] initWithAudioBookAtPath:@"" WithBookID:[NSString stringWithFormat:@"%ld",(long)bookID] WithISBN:isbn withThumbnailURL:thumbnail_url];
        [self->mainReader launchHLSMediaBook:book IsDownloaded:false IsAudioBook:isAudioBook WithKitabooUser:user WithKitabooServiceConfiguration:config];
       self->mainReader.view.frame = self.view.bounds;
}

@end
