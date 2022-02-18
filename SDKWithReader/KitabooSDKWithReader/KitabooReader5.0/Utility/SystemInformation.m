//
//  SystemInformation.m
//  KitabooPlayerPdfBooks
//
//  Created by Pushan Puri on 06/05/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "SystemInformation.h"

#define USERS_FOLDER                            @"USERS"
#define BOOKS_FOLDER                            @"BOOKS"
#define THUMBNAILS_FOLDER                       @"THUMBNAILS"
#define PREVIEW_FOLDER                          @"PREVIEWS"
#define LAUNCH_THUMBNAILS_FOLDER                @"LAUNCH_THUMBNAILS"
#define BOOKS_DOWNLOADS_FOLDER                  @"BOOKS_DOWNLOADS"
#define PREVIEWS_DOWNLOADS_FOLDER               @"PREVIEWS_DOWNLOADS"
#define DOWNLOAD_EXTENTION                      @"tmp"
#define COMPLETED_EXTENTION                     @"completed"

#define LAUNCH_EXTENTION                        @"launch"

#define POTRAINT_LAUNCH_EXTENTION               @"potrait.launch"
#define LANDSCAPE_ONLY_LAUNCH_EXTENTION         @"landscape.launch"
#define LANDSCAPE_ODD_PAGE_LAUNCH_EXTENTION     @"landscape.odd.launch"
#define LANDSCAPE_EVEN_PAGE_LAUNCH_EXTENTION    @"landscape.even.launch"

#define PDF_PATH                                @"/assets/pdf/chapter0/ebook.pdf"
#define DB_PATH                                 @"/assets/xml-bin/xml.sqlite"
#define EBOOK_XML_PATH                          @"/assets/xml-bin/eBook.xml"
#define WEB_XML_PATH                            @"/assets/web.xml"
#define PAGE_THUMBNAILS_PATH                    @"/assets/images/thumbnails"

#define PREVIEW_PAGES_XML_PATH                  @"/pages.xml"
#define PREVIEW_THUMNAILS_PATH                  @"/page_images/thumbnails"
#define PREVIEW_PAGES_PATH                      @"/page_images"

#define APP_INFO_PATH                           @"app_info.plist"
#define NOTE_IMAGES_FOLDER                      @"Notes/Images"
#define NOTE_AUDIOS_FOLDER                      @"Notes/Audios"
#define NOTE_VIDEOS_FOLDER                      @"Notes/Videos"

@implementation SystemInformation

+ (SystemInformation *)getInstance
{
    static SystemInformation *systemInformation=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      systemInformation = [[self alloc] init];
                  });
    return systemInformation;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self addSkipBackupAttributeToItemAtPath:[self getStorageDirectory]];
    }
    return self;
}

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString
{
    NSURL *fileURL = [NSURL fileURLWithPath:filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [fileURL path]]);
    NSError *error = nil;
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    return success;
}

- (NSString *)getStorageDirectory
{
    NSDictionary *configDic=[[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
    NSArray *paths;
    if([[configDic objectForKey:@"IMPORT_BOOKS_VIA_ITUNES_SHARING"] boolValue])
    {
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    }
    else
    {
        paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    }
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)getDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)getUsersFolderPath
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:USERS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    return str;
}

- (NSString *)getBasePathForBookWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    NSDictionary *configDic=[[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
    if(![[configDic objectForKey:@"IMPORT_BOOKS_VIA_ITUNES_SHARING"] boolValue])
    {
        str = [str stringByAppendingPathComponent:BOOKS_FOLDER];
    }
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", bookId]];
    [self checkAndCreateDirectoryWith:str];
    return str;
}

- (NSString *)getLaunchPathForBookWithBookId:(NSNumber *)bookId
{
    return [self getBasePathForBookWithBookId:bookId];
}

- (NSString *)getExtractPathForBookWithBookId:(NSNumber *)bookId
{
    return [self getBasePathForBookWithBookId:bookId];
}

- (NSString *)getPathForBookDownloadWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:BOOKS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:COMPLETED_EXTENTION];
    return str;
}

- (NSString *)getPathForBookDownloadZipWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:BOOKS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:COMPLETED_EXTENTION];
    return str;
}

- (NSString *)getPathForVideoWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:BOOKS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:@"mp4"];
    return str;
}

- (NSString *)getPathForBookDownloadDirectory
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:BOOKS_DOWNLOADS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    return str;
}

- (NSArray *)getAllFilesOfExtension:(NSString *)extension atDirectoryPath:(NSString *)path
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [self checkAndCreateDirectoryWith:path];
    NSArray *array = [fm contentsOfDirectoryAtPath:path error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject pathExtension] isEqualToString:extension];
        
    }];
    return [array filteredArrayUsingPredicate:predicate];
}

-(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        [KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:[NSString stringWithFormat:@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll)] verboseMesage:@""];
    } else {
        [KitabooDebugLog logWithType:KitabooLogTypeError className:[self class] message:[NSString stringWithFormat:@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]] verboseMesage:@""];
    }
    
    return totalFreeSpace;
}

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

- (NSString *)getActualDataTemproraryPath {
    NSString *str = [self getStorageDirectory];
    str = [[str stringByAppendingPathComponent:BOOKS_DOWNLOADS_FOLDER] stringByAppendingString:@"tmp"];
    return str;
}

- (NSString *)getPathForBookWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    NSDictionary *configDic=[[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
    if(![[configDic objectForKey:@"IMPORT_BOOKS_VIA_ITUNES_SHARING"] boolValue])
    {
        str = [str stringByAppendingPathComponent:BOOKS_FOLDER];
    }
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:DOWNLOAD_EXTENTION];
    return str;
}

- (NSString *) getPathForBookThumbnailWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:THUMBNAILS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:COMPLETED_EXTENTION];
    return str;
}

- (NSString *) getPathForCollectionThumbnailWithCollectionId:(NSNumber *)collectionId AndCollectionTimeStamp:(NSString *)timeStamp
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",THUMBNAILS_FOLDER,collectionId]];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",timeStamp]];
    str = [str stringByAppendingPathExtension:COMPLETED_EXTENTION];
    return str;
}

- (NSString *)getPathForBookPreviewDownloadWithBookId:(NSString *)bookId
{
    NSString *str = [self getPathForBookPreviewWithBookId:[NSNumber numberWithInt:([bookId stringByReplacingOccurrencesOfString:@"_preview" withString:@""]).intValue] ];
    str = [str stringByAppendingPathComponent:bookId];
    str = [str stringByAppendingPathExtension:COMPLETED_EXTENTION];
    return str;
}

- (NSString *)getPathForBookPreviewWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:PREVIEW_FOLDER];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    [self checkAndCreateDirectoryWith:str];
    return str;
}

- (NSString *)getPreviewPagesXMLPathWithBookId:(NSNumber *)bookId
{
    return [[self getPathForBookPreviewWithBookId:bookId] stringByAppendingString:PREVIEW_PAGES_XML_PATH];
}

- (NSString *)getPreviewPagesPathWithBookId:(NSNumber *)bookId
{
    return [[self getPathForBookPreviewWithBookId:bookId] stringByAppendingString:PREVIEW_PAGES_PATH];
}

- (NSString *)getPreviewThumbnailsPathWithBookId:(NSNumber *)bookId
{
    return [[self getPathForBookPreviewWithBookId:bookId] stringByAppendingString:PREVIEW_THUMNAILS_PATH];
}

- (NSString *)getPathForBookLaunchThumbnailWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:LAUNCH_THUMBNAILS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:@"png"];
    return str;
}

- (NSString *)getPathForBookLaunchPotraitThumbnailWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:LAUNCH_THUMBNAILS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:POTRAINT_LAUNCH_EXTENTION];
    return str;
}

- (NSString *)getPathForBookLandscapeLaunchThumbnailEvenPageWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:LAUNCH_THUMBNAILS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:LANDSCAPE_EVEN_PAGE_LAUNCH_EXTENTION];
    return str;
}

- (NSString *)getPathForBookLandscapeLaunchThumbnailOddPageWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:LAUNCH_THUMBNAILS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:LANDSCAPE_ODD_PAGE_LAUNCH_EXTENTION];
    return str;
}

- (NSString *)getPathForBookLandscapeOnlyLaunchThumbnailWithBookId:(NSNumber *)bookId
{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:LAUNCH_THUMBNAILS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    str = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bookId]];
    str = [str stringByAppendingPathExtension:LANDSCAPE_ONLY_LAUNCH_EXTENTION];
    return str;
}

-(void)deleteBookLaunchThumbnailsWithBookId:(NSNumber *)bookId{
    NSString *str = [self getStorageDirectory];
    str = [str stringByAppendingPathComponent:LAUNCH_THUMBNAILS_FOLDER];
    
    NSArray * thumbnailArray = [NSArray arrayWithObjects:
                                [self getPathForBookLaunchThumbnailWithBookId:bookId],
                                [self getPathForBookLandscapeOnlyLaunchThumbnailWithBookId:bookId],
                                [self getPathForBookLandscapeLaunchThumbnailOddPageWithBookId:bookId],
                                [self getPathForBookLandscapeLaunchThumbnailEvenPageWithBookId:bookId],
                                [self getPathForBookLaunchPotraitThumbnailWithBookId:bookId],nil];
    
    for (NSString *thumbnailFilePath in thumbnailArray)
    {
        //[KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:[NSString stringWithFormat:@"The launch thumbnail path is : %@",[str stringByAppendingPathComponent:thumbnailFilePath]] verboseMesage:@""];
        if([[NSFileManager defaultManager] fileExistsAtPath:thumbnailFilePath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:thumbnailFilePath error:nil];
        }
    }
}


- (NSString *)getPDFPathWithBookId:(NSNumber *)bookId
{
    return [[self getLaunchPathForBookWithBookId:bookId] stringByAppendingString:PDF_PATH];
}

- (NSString *)getDBPathWithBookId:(NSNumber *)bookId
{
    return [[self getLaunchPathForBookWithBookId:bookId] stringByAppendingString:DB_PATH];
}

- (NSString *)getEBookXMLPathWithBookId:(NSNumber *)bookId
{
    return [[self getLaunchPathForBookWithBookId:bookId] stringByAppendingString:EBOOK_XML_PATH];
}

- (NSString *)getWebXMLPathWithBookId:(NSNumber *)bookId
{
    return [[self getLaunchPathForBookWithBookId:bookId] stringByAppendingString:WEB_XML_PATH];
}


- (NSString *)getPageThumbnailsPath:(NSNumber *)bookId
{
    return [[self getLaunchPathForBookWithBookId:bookId] stringByAppendingString:PAGE_THUMBNAILS_PATH];
}

- (NSString *)getAppInfoDictionaryPath
{
    return [[self getDocumentsDirectory] stringByAppendingPathComponent:APP_INFO_PATH];
}

- (NSString *)getNotesAudiosDirectory
{
    NSString *str = [self getDocumentsDirectory];
    str = [str stringByAppendingPathComponent:NOTE_AUDIOS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    
    return str;
}

- (NSString *)getNotesImagesDirectory
{
    NSString *str = [self getDocumentsDirectory];
    str = [str stringByAppendingPathComponent:NOTE_IMAGES_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    
    return str;
}

- (NSString *)getNotesVideosDirectory
{
    NSString *str = [self getDocumentsDirectory];
    str = [str stringByAppendingPathComponent:NOTE_VIDEOS_FOLDER];
    [self checkAndCreateDirectoryWith:str];
    
    return str;
}

- (void)checkAndCreateDirectoryWith:(NSString *)path
{
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(error)
        {
        }
    }
}

@end
