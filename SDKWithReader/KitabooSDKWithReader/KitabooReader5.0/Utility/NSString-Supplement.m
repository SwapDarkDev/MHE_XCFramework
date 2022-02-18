//
//  NSString-Supplement.h
//  Kitaboo 3.0
//
//  Created by Dinakar Soma on 22/06/11.
//  Copyright 2011 MoFirst Solutions. All rights reserved.
//

#import "NSString-Supplement.h"
#import <CommonCrypto/CommonDigest.h>
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>

#define hh_mm_a_dd_MMMM_yyyy    @"hh:mm a dd MMMM yyyy"
#define YYYY_MM_dd_HH_mm_ss @"YYYY-MM-dd HH:mm:ss"
#define YYYY_MM_dd_HH_mm_ss_SSS  @"YYYY-MM-dd HH:mm:ss.SSS"
#define EEE_D_MMM_YYYY_HH_mm_ss_Z  @"EEE, d MMM yyyy HH:mm:ss Z"
#define en_US_POSIX  @"en_US_POSIX"
#define UTC  @"UTC"
#define GMT  @"GMT"
#define MMM_D_YYYY_HH_mm_a  @"MMM d, yyyy, hh:mm a"

//Last Active on May 19, 2021, 10:15 pm

@implementation NSString(Expanded)

+ (NSString*)stringFromInteger:(NSUInteger)numberToConvert
{
	if([[NSString stringWithFormat:@"%lu",(unsigned long)numberToConvert] length]==1)
    {
		return [NSString stringWithFormat:@"0%lu",(unsigned long)numberToConvert];
	}
    else
    {
		return [NSString stringWithFormat:@"%lu",(unsigned long)numberToConvert];
	}
}

//+ (NSString*)stringWithUniChar:(unichar)value
//{
//	NSString *string = [NSString stringWithFormat: @"%C", value];
//	return string;
//}

//+ (NSString*)stringFromDate:(NSDate*)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
//    NSString *stringToReturn = [formatter stringFromDate:date];
//    return stringToReturn;
//}

+ (NSString*)stringFromUTCDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:UTC]];
     [formatter setLocale:[NSLocale localeWithLocaleIdentifier:en_US_POSIX]];
    [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss_SSS];
    NSString *stringToReturn = [formatter stringFromDate:date];
    return stringToReturn;
}

//+ (NSString *)formattedStringFromDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:hh_mm_a_dd_MMMM_yyyy];
//    NSString *stringToReturn = [formatter stringFromDate:date];
//    return stringToReturn;
//}

//+(NSString *)formattedDateFromSting:(NSDate *)date withFormat:(NSString *)dateFormat
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:dateFormat];
//    NSString *stringToReturn = [formatter stringFromDate:date];
//    return stringToReturn;
//}

+ (NSString *)formattedLocalStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:hh_mm_a_dd_MMMM_yyyy];
    NSString *stringToReturn = [formatter stringFromDate:date];
    return stringToReturn;
}

+ (NSString *)formattedMonthFirstDateString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:UTC]];
    [formatter setDateFormat:MMM_D_YYYY_HH_mm_a];
    NSString *stringToReturn = [formatter stringFromDate:date];
    return stringToReturn;
}

//+ (NSString *)formattedUTCStringFromDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    [formatter setDateFormat:@"hh:mm a dd MMMM YYYY"];
//    NSString *stringToReturn = [formatter stringFromDate:date];
//    return stringToReturn;
//}

//+ (NSString *)formatStringFromDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    [formatter setDateFormat:@"hh:mm a dd-MM-YY"];
//    NSString *stringToReturn = [formatter stringFromDate:date];
//    return stringToReturn;
//}

- (NSDate*)formattedDateFromString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:en_US_POSIX]];
    if(![self containsString:@"."])
    {
        [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss];
    }
    else
    {
        [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss_SSS];
    }
    NSDate *date = [formatter dateFromString:self];
    return date;
}
- (NSDate*)formattedDateFromString:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:en_US_POSIX]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

//- (NSDate*)dateFromString
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
//    return [formatter dateFromString:self];
//}

- (NSDate*)formatedString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:UTC]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:en_US_POSIX]];
    [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss_SSS];
    NSDate *utcDate= [formatter dateFromString:self];
    if (!utcDate)
    {
        [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss];
        utcDate = [formatter dateFromString:self];
    }
    return utcDate;
}

- (NSDate*)utcDateFromString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:UTC]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:en_US_POSIX]];
    [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss_SSS];
    NSDate *utcDate= [formatter dateFromString:self];
    if (!utcDate)
    {
        [formatter setDateFormat:YYYY_MM_dd_HH_mm_ss];
        utcDate = [formatter dateFromString:self];
    }
    return utcDate;
}

- (NSDate*)utcDateFromStringForGMTTimeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:GMT]];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:en_US_POSIX]];
    [formatter setDateFormat:EEE_D_MMM_YYYY_HH_mm_ss_Z];
    NSDate *utcDate= [formatter dateFromString:self];
    return utcDate;
}
//-(NSString *)getUTCFormateDate
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *dateFormatted = [dateFormatter dateFromString:self];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
//    return dateString;
//}

//- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end
//{
//    NSRange startRange = [self rangeOfString:start];
//    if (startRange.location != NSNotFound)
//    {
//        NSRange targetRange;
//        targetRange.location = startRange.location + startRange.length;
//        targetRange.length = [self length] - targetRange.location;
//        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
//        if (endRange.location != NSNotFound)
//        {
//            targetRange.length = endRange.location - targetRange.location;
//            return [self substringWithRange:targetRange];
//        }
//    }
//    return nil;
//}

//- (NSString *)encodeString:(NSStringEncoding)encoding
//{
//    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
//                                                                                           NULL, (CFStringRef)@";/?:@&=$+{}<>,",
//                                                                                           CFStringConvertNSStringEncodingToEncoding(encoding)) ;
//    return encodedString;
//}

//+ (NSString*)encodeString:(NSString*)string
//{
//    NSString *str01=[string stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
//    NSString *str1=[str01 stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
//    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
//    NSString *str123=[str2 stringByReplacingOccurrencesOfString:@"é" withString:@"%E9"];//%BB
//    NSString *str1234=[str123 stringByReplacingOccurrencesOfString:@"«" withString:@"%AB"];
//    NSString *str12345=[str1234 stringByReplacingOccurrencesOfString:@"»" withString:@"%BB"];
//    NSString *str4=[str12345 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//    NSString *str12=[str4 stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
//    NSString *str14=[str12 stringByReplacingOccurrencesOfString:@"¥" withString:@"%A5"];
//    NSString *str41=[str14 stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
//    NSString *str3=[str41 stringByReplacingOccurrencesOfString:@"€" withString:@"%u20AC"];
//    
//    return str3;
//}

//+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
//{
//    NSInteger ti = (NSInteger)interval;
//    NSInteger seconds = ti % 60;
//    NSInteger minutes = (ti / 60) % 60;
//    NSInteger hours = (ti / 3600);
//    return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
//}

//+ (NSString *)stringFromFloatTime:(double)interval
//{
//    int ti = (int)interval;
//    int seconds = ti % 60;
//    int minutes = (ti / 60) % 60;
//    int hours = (ti / 3600);
//    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
//}

- (BOOL)containsString:(NSString *)subString
{
    NSString *selfLowerCaseString = [self lowercaseString];
    BOOL containsString = NO;
    NSRange range = [selfLowerCaseString rangeOfString:[subString lowercaseString]];
    if (range.location != NSNotFound)
    {
        containsString = YES;
    }
    return containsString;
}

- (BOOL)isEqualToStringIgnoreCase:(NSString *)aString
{
    return [[self lowercaseString] isEqualToString:[aString lowercaseString]];
}

//- (BOOL)hasPrefixIgnoreCase:(NSString *)aString
//{
//    return [[self lowercaseString] hasPrefix:[aString lowercaseString]];
//}

//- (BOOL)hasSuffixIgnoreCase:(NSString *)aString
//{
//    return [[self lowercaseString] hasSuffix:[aString lowercaseString]];
//}

//- (NSComparisonResult)dateCompare:(NSString *)s2
//{
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone systemTimeZone];
//    [formatter setDateStyle:NSDateFormatterLongStyle];
//    [formatter setDateFormat:@"dd MMM, yyyy"];
//
//    NSDate *d1 = [formatter dateFromString:self];
//    NSDate *d2 = [formatter dateFromString:s2];
//    return [d2 compare:d1];
//}
//- (BOOL) isAllDigits
//{
//    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
//    return r.location == NSNotFound;
//}

- (NSNumber*)numberValue
{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * number = [numberFormatter numberFromString:self];
    return number;
}

//+ (NSString *)capitilizeEachWord:(NSString *)sentence
//{
//    NSArray *words = [sentence componentsSeparatedByString:@" "];
//    NSMutableArray *newWords = [NSMutableArray array];
//    for (NSString *word in words)
//    {
//        if (word.length > 0)
//        {
//            NSString *capitilizedWord = [[[word substringToIndex:1] uppercaseString] stringByAppendingString:[word substringFromIndex:1]];
//            [newWords addObject:capitilizedWord];
//        }
//    }
//    return [newWords componentsJoinedByString:@" "];
//}

//+ (NSString *)makeProperCase:(NSString *)string
//{
//    NSString *tempString = [string lowercaseString];
//    NSString *firstChar = [NSString stringWithUniChar:[tempString characterAtIndex:0]];
//    firstChar = [firstChar uppercaseString];
//    tempString = [tempString stringByReplacingCharactersInRange:NSMakeRange(0, 1)
//                                                     withString:firstChar];
//    return tempString;
//}

- (BOOL)isValideMailId
{
//    NSRange atRange = [self rangeOfString:@"@"];
//    
//    BOOL b = NO;
//    
//    if ((atRange.location != NSNotFound) //is `@` present
//        && (atRange.location != 0) // and is `@` not at the beginning -> left substring exist
//        && (atRange.location != [self length]-1) // and not at the end -> right substring exists
//        && ([[self componentsSeparatedByString:@"@"] count] == 2)) // and is there only one `@`?
//    {
//        // is there a `.` right of the `@`?
//        NSRange dotRange = [[self substringFromIndex:atRange.length +atRange.location] rangeOfString:@"."];
//        
//        if((dotRange.location != NSNotFound) // is there a `.` right of `@`
//           && (dotRange.location !=0) // and is it not the very next char after `@`
//           && ([[self substringFromIndex:[self length]-2] rangeOfString:@"."].location == NSNotFound)) // and the `.` is not the last or second last char
//        {
//            b = YES;
//        }
//    }
//    return b;
    
    
    if([self length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})$";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
    
}


//- (BOOL) validEmail{
//
//    if([self length]==0){
//        return NO;
//    }
//
//    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//
//    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSUInteger regExMatches = [regEx numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
//
//    if (regExMatches == 0) {
//        return NO;
//    } else {
//        return YES;
//    }
//}


//+ (NSString *)stringByRemovingAllSpaces:(NSString *) string
//{
//    NSRange range = [string rangeOfString:@" "];
//    if (range.location != NSNotFound)
//    {
//        NSString *tempString = [string stringByReplacingOccurrencesOfString:@" "
//                                                                 withString:@""];
//        
//        string = tempString;
//    }
//    return string;
//}

//+ (NSString *)stringByRemovingInvalidCharactersInString:(NSString *) string
//{
//    string = [NSString stringByRemovingAllSpaces:string];
//    
//    NSMutableCharacterSet *charSet = [NSMutableCharacterSet alphanumericCharacterSet];
//    [charSet addCharactersInString:@"@._-+"];
//    
//    NSRange inValidCharRange = [string rangeOfCharacterFromSet:[charSet invertedSet]];
//    
//    if(inValidCharRange.location != NSNotFound)
//    {
//        NSString *tempString = [string stringByReplacingCharactersInRange:NSMakeRange(inValidCharRange.location,
//                                                                                      inValidCharRange.length)
//                                                               withString:@""];
//        string = tempString;
//    }
//    
//    return string;
//}

//+ (BOOL) invalidCharExistsInString:(NSString *) string
//{
//    NSMutableCharacterSet *charSet = [NSMutableCharacterSet alphanumericCharacterSet];
//    [charSet addCharactersInString:@"@._-+"];
//    
//    NSRange inValidCharRange = [string rangeOfCharacterFromSet:[charSet invertedSet]];
//    NSRange range = [string rangeOfString:@" "];
//    
//    if ((range.location != NSNotFound) || (inValidCharRange.location != NSNotFound))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

//+ (NSString *)stringByAddingEscapeCharaters:(NSString *)string
//{
//    NSString *tempString = string;
//    
//    if ([string containsString:@"\""])
//    {
//        tempString = [string stringByReplacingOccurrencesOfString:@"\""
//                                                       withString:@"\\\""];
//    }
//    
//    if ([string containsString:@"'"])
//    {
//        tempString = [string stringByReplacingOccurrencesOfString:@"'"
//                                                       withString:@"\'"];
//    }
//    return tempString;
//}

//-(NSString *) stringByAppendingAndExcludingNullString:(NSString *) string withSeparator:(NSString *) separator
//{
//    NSString *tempString = self;
//    
////    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([string length] > 0) {
//        tempString = [tempString stringByAppendingFormat:@"%@%@",separator, string];
//    }
//
//    return tempString;
//}


//+ (NSString *) stringFromSQLiteStatement:(sqlite3_stmt *)statement forColoum:(const int)num
//{
//    if (sqlite3_column_text(statement, num) != nil) {
//        return [NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, num)];
//    }
//    
//    return @"";
//}

+ (NSString *) getLocalizedStringForDateString:(NSString*)date
{

    NSString *localizedTimeDate = [NumberLocalizationHandler localizeTimeWithTime:date format:@"hh:mm a dd MMMM yyyy"];
    NSMutableString *dateString = [[NSMutableString alloc]initWithString:localizedTimeDate];
    NSArray *monthsArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    NSString *returnString;
    for (NSString* month in monthsArray){
        if ([dateString containsString:month]){
            returnString = [dateString stringByReplacingOccurrencesOfString:month withString:[LocalizationHelper localizedStringWithKey:month]];
            return returnString;
        }
    }
    return dateString;
}

@end


