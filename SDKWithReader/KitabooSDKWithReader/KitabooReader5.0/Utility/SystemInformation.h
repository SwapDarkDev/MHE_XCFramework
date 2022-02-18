//
//  SystemInformation.h
//  KitabooPlayerPdfBooks
//
//  Created by Pushan Puri on 06/05/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

@interface SystemInformation : NSObject
{
}

+ (SystemInformation *) getInstance;

- (NSString *)getDocumentsDirectory;
- (NSString *)getStorageDirectory;
- (NSString *)getUsersFolderPath;
- (NSString *)getPathForBookThumbnailWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookPreviewDownloadWithBookId:(NSString *)bookId;
- (NSString *)getPathForBookPreviewWithBookId:(NSNumber *)bookId;
- (NSString *)getPreviewPagesXMLPathWithBookId:(NSNumber *)bookId;
- (NSString *)getPreviewPagesPathWithBookId:(NSNumber *)bookId;
- (NSString *)getPreviewThumbnailsPathWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookDownloadWithBookId:(NSNumber *)bookId;
- (NSString *)getLaunchPathForBookWithBookId:(NSNumber *)bookId;
- (NSString *)getExtractPathForBookWithBookId:(NSNumber *)bookId;
- (NSString *)getPDFPathWithBookId:(NSNumber *)bookId;
- (NSString *)getDBPathWithBookId:(NSNumber *)bookId;
- (NSString *)getPageThumbnailsPath:(NSNumber *)bookId;
- (NSString *)getPathForBookLaunchThumbnailWithBookId:(NSNumber *)bookId;
- (NSString *)getEBookXMLPathWithBookId:(NSNumber *)bookId;
- (NSString *)getWebXMLPathWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookDownloadZipWithBookId:(NSNumber *)bookId; 
- (NSString *)getPathForVideoWithBookId:(NSNumber *)bookId;

- (NSString *)getPathForBookLaunchPotraitThumbnailWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookLandscapeLaunchThumbnailOddPageWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookLandscapeLaunchThumbnailEvenPageWithBookId:(NSNumber *)bookId;
- (NSString *)getPathForBookLandscapeOnlyLaunchThumbnailWithBookId:(NSNumber *)bookId;
- (NSString *)getAppInfoDictionaryPath;
- (NSString *)getNotesAudiosDirectory;
- (NSString *)getNotesImagesDirectory;
- (NSString *)getNotesVideosDirectory;
- (NSString *)getBasePathForBookWithBookId:(NSNumber *)bookId;
- (NSString *)getActualDataTemproraryPath;
- (NSString *)getPathForBookDownloadDirectory;
- (NSArray *)getAllFilesOfExtension:(NSString *)extension atDirectoryPath:(NSString *)path;
-(uint64_t)getFreeDiskspace;
-(BOOL)getIfDeviceHasSpaceToDownloadTheBook:(NSString *)bookSize;
- (NSString *) getPathForCollectionThumbnailWithCollectionId:(NSNumber *)collectionId AndCollectionTimeStamp:(NSString *)timeStamp;
- (void)deleteBookLaunchThumbnailsWithBookId:(NSNumber *)bookid;


@end
