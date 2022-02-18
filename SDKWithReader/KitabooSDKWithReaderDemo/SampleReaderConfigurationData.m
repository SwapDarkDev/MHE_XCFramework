//
//  SampleReaderConfigurationData.m
//  KitabooSDKWithReaderDemo
//
//  Created by Sumanth Myrala on 15/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import "SampleReaderConfigurationData.h"

#define FileName @"SampleReaderConfiguration"
#define FileType @"plist"

@implementation SampleReaderConfigurationData

+ (SampleReaderConfigurationData *)getInstance
{
    static SampleReaderConfigurationData *readerConfig = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      readerConfig = [[self alloc] init];
                  });
    return readerConfig;
}

- (id)init
{
    self = [super init];
    if (self){
    }
    return self;
}

- (NSString *)getBaseURL
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *clientID = [dict objectForKey:@"BaseURL"];
    return clientID;
}

- (NSString *)getClientID
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *clientID = [dict objectForKey:@"ClientID"];
    return clientID;
}

- (NSString *)getMicroServicesBaseURL {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *microServicesBaseURL= [dict objectForKey:@"MicroServicesBaseURL"];
    return microServicesBaseURL;
}

- (NSString *)getLoginUserName
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *clientID = [dict objectForKey:@"LoginUserName"];
    return clientID;
}

- (NSString *)getLoginPassword
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *clientID = [dict objectForKey:@"LoginPassword"];
    return clientID;
}

- (NSDictionary *)getBookIDOneDictionary
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *clientID = [dict objectForKey:@"BookOne"];
    return clientID;
}

- (NSDictionary *)getBookIDTwoDictionary
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *clientID = [dict objectForKey:@"BookTwo"];
    return clientID;
}

- (NSDictionary *)getBookIDThreeDictionary
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *clientID = [dict objectForKey:@"BookThree"];
    return clientID;
}

- (NSDictionary *)getBookIDFourDictionary
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *clientID = [dict objectForKey:@"BookFour"];
    return clientID;
}

- (NSDictionary *)getBookIDFiveDictionary
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *clientID = [dict objectForKey:@"BookFive"];
    return clientID;
}

- (NSArray *)getArrayofBookIDs
{
    NSArray *bookIDs = [NSArray arrayWithObjects:[[SampleReaderConfigurationData getInstance] getBookIDOneDictionary],[[SampleReaderConfigurationData getInstance] getBookIDTwoDictionary],[[SampleReaderConfigurationData getInstance] getBookIDThreeDictionary],[[SampleReaderConfigurationData getInstance] getBookIDFourDictionary],[[SampleReaderConfigurationData getInstance] getBookIDFiveDictionary], nil];
    return bookIDs;
}

- (BOOL)isPrePackagedBooks
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource: FileName ofType: FileType];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    BOOL isPrePackaged = [[dict valueForKey:@"PrePackagedBooks"] boolValue];
    return isPrePackaged;
}
@end
