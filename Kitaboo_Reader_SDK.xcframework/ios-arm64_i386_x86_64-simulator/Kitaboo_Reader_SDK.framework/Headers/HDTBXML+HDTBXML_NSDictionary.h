//
//  HDTBXML+HDTBXML_NSDictionary.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import "HDTBXML.h"

@interface HDTBXML (HDTBXML_NSDictionary)

+ (NSDictionary*)dictionaryWithXMLNode:(TBXMLElement*)element;
+ (NSDictionary*)dictionaryWithXMLData:(NSData*)data error:(NSError**)error;

@end
