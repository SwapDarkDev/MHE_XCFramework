//
//  UGCXMLClass.h
//  KitabooSDKWithReader
//
//  Created by SwapnilChavan on 14/02/22.
//  Copyright © 2022 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCXMLClass : NSObject

+(NSString *) generateXMLForUGCForDictionary:(NSDictionary *)ugcDictionary forPageID:(NSNumber *)pageID andUser:(KitabooUser *)user forBook:(KFBookVO *)book;
@end

NS_ASSUME_NONNULL_END
