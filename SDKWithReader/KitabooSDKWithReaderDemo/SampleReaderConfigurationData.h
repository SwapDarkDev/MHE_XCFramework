//
//  SampleReaderConfigurationData.h
//  KitabooSDKWithReaderDemo
//
//  Created by Sumanth Myrala on 15/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
* SampleReaderConfigurationData is a singleton class.This class will be responsible to provide the basic/required data like clientID, BaseURL, username, password and bookID's. This data will be fetched from SampleReaderConfiguration.plist file.
* @superclass SuperClass : NSObject
*/
@interface SampleReaderConfigurationData : NSObject

/**
* This method should be called to get the instance of the SampleReaderConfigurationData
*/
+ (SampleReaderConfigurationData *) getInstance;

/**
* This method should be called to get the clientID
*/
- (NSString *)getClientID;

/**
* This method should be called to get the BaseURL
*/
- (NSString *)getBaseURL;

- (NSString *)getMicroServicesBaseURL;

/**
* This method should be called to get the Login UserName
*/
- (NSString *)getLoginUserName;

/**
* This method should be called to get the Login Password
*/
- (NSString *)getLoginPassword;

/**
* This method should be called to get the bookID of the Reflowable ePub book
*/
- (NSDictionary *)getBookIDOneDictionary;

/**
* This method should be called to get the bookID of the Fixed ePub book
*/
- (NSDictionary *)getBookIDTwoDictionary;

/**
* This method should be called to get the bookID of the Kitaboo Fixed Layout book
*/
- (NSDictionary *)getBookIDThreeDictionary;

/**
* This method should be called to get the bookID of the AudioBook
*/
- (NSDictionary *)getBookIDFourDictionary;

/**
* This method should be called to get the bookID of the VideoBook
*/
- (NSDictionary *)getBookIDFiveDictionary;

/**
* This method should be called to get the array of bookids
*/
- (NSArray *)getArrayofBookIDs;

/**
* This method should be called to get whether it should consider prepackaged books or should be able download book
*/
- (BOOL)isPrePackagedBooks;
@end

NS_ASSUME_NONNULL_END
