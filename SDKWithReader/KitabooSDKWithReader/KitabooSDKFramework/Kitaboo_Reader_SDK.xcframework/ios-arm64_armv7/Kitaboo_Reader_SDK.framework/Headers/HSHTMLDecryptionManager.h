//
//  HSHTMLDecryptionManager.h
//  Kitaboo
//
//  Copyright © 2016 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
@interface HSHTMLDecryptionManager : NSObject
- (NSString*)decryptedHTMLStringFromString:(NSString*)sourceHTMLString withDecryptionKey:(NSString*)key;
-(void)decryptHTMLActivityAtURL:(NSURL*)activityURL WithEncryptionKey:(NSString*)encryptionKey WithCompletionHandler:(void (^)(void))completionHandler;
-(NSMutableData *)getDecryptedDataWithItemDictionary:(NSDictionary*)itemDic WithActivityBasePath:(NSURL*)activityBasePath WithEncryptionKey:(NSString*)encryptionKeyGlobal;
-(NSMutableData *)getDecryptedDataWithItemDictionary:(NSDictionary*)itemDic withEncryptedData:(NSData *)encryptedData WithEncryptionKey:(NSString*)encryptionKeyGlobal;
-(BOOL)isEncryptionAvailableForActivityAtPath:(NSURL*)activityURL;
-(void)deleteDecryptedResourceAndRestoreOriginalForActivityAtPath:(NSURL*)activityURL;
@end
