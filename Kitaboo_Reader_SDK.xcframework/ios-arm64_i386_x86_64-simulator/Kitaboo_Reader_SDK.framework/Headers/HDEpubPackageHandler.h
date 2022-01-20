//
//  HDEpubPackageHandler.h
//  KItabooSDK
//
//  Created by Sumanth Myrala on 22/10/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDEpubPackageHandlerDelegate <NSObject>

@optional
/*!
 This method will be called when the extraction of the epub file is successfull
 * @param1 extractedFilePath Path in which the extracted epub package exists
 */
- (void)didEpubExtractedAtPath:(NSString *)extractedFilePath;

@end

/** An Object that manages the extraction of epub file
 *  @superclass SuperClass : NSObject
 */
@interface HDEpubPackageHandler : NSObject

/*!
  This method should be called to extract the epub file at specific path
 * @param1 sourceFilePath Path from where the file needs to be extracted
 * @param2 destinationPath root path where the extracted package should be available
 * @param3 delegate Setter/Getter for delegate (callback listener)
 * @code
 * [packageHandler extractEpubFromPath:sourcePath toDestination:destinationPath withDelegate:self];
 * @endcode
 */
- (void)extractEpubFromPath:(NSString *)sourceFilePath toDestinationPath:(NSString *)destinationPath withDelegate:(id<HDEpubPackageHandlerDelegate>)delegate;

/*!
 This method should be called to extract the epub file at specific path
 * @param1 sourceFilePath Path from where the file needs to be extracted
 * @param2 destinationPath root path where the extracted package should be available
 * @param3 completionHandler Block which will be called when the extraction of the epub file is completed.
 * @code
 * [packageHandler extractEpubFromPath:sourceFilePath toDestination:destinationPath completed:^(NSString *extractedFilePath, NSError *error) {
 
    }];
 * @endcode
 */
- (void)extractEpubFromPath:(NSString *)sourceFilePath toDestinationPath:(NSString *)destinationPath completed:(void (^)(NSString *extractedFilePath, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
