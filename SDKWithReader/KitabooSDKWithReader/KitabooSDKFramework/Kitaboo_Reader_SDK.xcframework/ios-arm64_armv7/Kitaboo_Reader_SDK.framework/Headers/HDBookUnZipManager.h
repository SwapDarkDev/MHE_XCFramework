//
//  HDBookUnZipManager.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDBookUnZipManagerDelegate <NSObject>

@optional
/**
 This method is called when file is about to unzip
 * @param1 path Path from where the file needs to be unzipped
 */
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path;

/**
 This method is called when file is about to unzip
 * @param1 fileIndex Index of the file from group of files
 * @param2 totalFiles count of the total files to be unzipped
 * @param3 archivePath Path from where the file needs to be unzipped
 */
- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath;

/**
 This method is called when file unzipped successfully
 * @param1 path Path from where the file needs to be unzipped
 * @param2 unzippedPath Path where the file exists after unzipping
 */
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path unzippedPath:(NSString *)unzippedPath;

/**
 This method is called when file is about to unzip
 * @param1 fileIndex Index of the file from group of files
 * @param2 totalFiles count of the total files to be unzipped
 * @param3 archivePath Path from where the file needs to be unzipped
 */
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath;

@end

@interface HDBookUnZipManager : NSObject

/**
 This method should be called to unzip a file at specific path
 * @param1 path Path from where the file needs to be unzipped
 * @param2 destination Path where the unzipped is available
 * @code
 * [zipManager unzipFileAtPath:filePath toDestination:destinationPath];
 * @endcode
 */
- (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;

/**
 This method should be called to unzip a file at specific path
 * @param1 path Path from where the file needs to be unzipped
 * @param2 destination Path where the unzipped is available
 * @param3 overwrite Boolean to overwrite the file
 * @param4 password NSString to unzip the locked file
 * @param5 error NSError when the unzip of the file is unsuccessful
 * @code
 * [zipManager unzipFileAtPath:filePath toDestination:destinationPath overwrite:YES password:nil error:&error];
 * @endcode
 */
- (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error;

/**
 This method should be called to unzip a file at specific path
 * @param1 path Path from where the file needs to be unzipped
 * @param2 destination Path where the unzipped is available
 * @param2 delegate Callback listener of type HDBookUnZipManagerDelegate.
 * @code
 * [zipManager unzipFileAtPath:filePath toDestination:destinationPath delegate:self];
 * @endcode
 */
- (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination delegate:(id<HDBookUnZipManagerDelegate>)delegate;

/**
 This method should be called to unzip a file at specific path
 * @param1 path Path from where the file needs to be unzipped
 * @param2 destination Path where the unzipped is available
 * @param3 overwrite Boolean to overwrite the file
 * @param4 password NSString to unzip the locked file
 * @param5 error NSError when the unzip of the file is unsuccessful
 * @param6 delegate Callback listener of type HDBookUnZipManagerDelegate.
 * @code
 * [zipManager unzipFileAtPath:filePath toDestination:destinationPath overwrite:YES password:nil error:&error delegate:self];
 * @endcode
 */
- (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error delegate:(id<HDBookUnZipManagerDelegate>)delegate;

@end
