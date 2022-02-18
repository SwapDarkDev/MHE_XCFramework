//
//  DownloadDecryptionHandler.h
//  KItabooSDK
//
//  Created by Sumanth Myrala on 23/08/19.
//  Copyright © 2019 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadDecryptionHandler : NSObject

- (NSString *)encryptStringWithKitabooBlowFish:(NSString *)encryptedString withKey:(NSString *)key;
- (NSString *)getMD5HashWith:(NSString *)key;
- (int)epochTimeFromDate:(NSDate *)date;
- (BOOL)isAPIResponseValidated:(NSString *)response andResponseHeaders:(NSDictionary *)responseDictionary andUserToken:(NSString *)userToken withDate:(nullable NSDate *)date;
@end

NS_ASSUME_NONNULL_END
