//
//  HDKitabooCryptographyManager.h
//  KItabooSDK
//
//  Created by Jyoti Suthar on 05/02/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDKitabooCryptographyManager : NSObject
+(instancetype)sharedInstance;
-(NSString *)getEncryptedString:(NSString *)decryptedString;
-(NSString *)getDecryptedString:(NSString *)encryptedString;
-(NSData *)getEncryptedData:(NSData *)decryptedData;
-(NSData *)getDecryptedData:(NSData *)encryptedData;
@end

NS_ASSUME_NONNULL_END
