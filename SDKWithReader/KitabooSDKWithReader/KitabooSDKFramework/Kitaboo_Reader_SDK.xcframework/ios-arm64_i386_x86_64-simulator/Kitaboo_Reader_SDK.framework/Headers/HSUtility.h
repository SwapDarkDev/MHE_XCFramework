//
//  ePUBUtility.h
//  ePUBSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Expanded)

+ (NSString *)ePUBStringFromUTCDate:(NSDate *)date;
+ (NSString *)ePUBStringFromDate:(NSDate *)date;

//--
+ (NSString*)hsStringFromInteger:(NSUInteger)numberToConvert;
+ (NSString*)hsStringFromDate:(NSDate*)date;
+ (NSString*)hsStringFromUTCDate:(NSDate*)date;
- (NSDate*)hsDateFromString;
- (NSDate*)hsUtcDateFromString;
- (NSString*)hsStringBetweenString:(NSString*)start andString:(NSString*)end;
- (NSString *)hsEncodeString:(NSStringEncoding)encoding;
- (BOOL)hsIsEqualToStringIgnoreCase:(NSString *)aString;
-(NSString *)hsStringByAppendingAndExcludingNullString:(NSString *) string withSeparator:(NSString *) separator;
- (NSNumber*)hsNumberValue;
@end

@interface NSDate (NSDate_Expanded)

+ (NSDate *)ePUBUTCDateFromString:(NSString *)dateString;
+ (NSDate *)ePUBDateFromString:(NSString *)dateString;

@end
