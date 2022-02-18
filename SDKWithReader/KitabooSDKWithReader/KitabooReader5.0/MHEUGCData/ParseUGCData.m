//
//  ParseUGCData.m
//  KitabooSDKWithReader
//
//  Created by SwapnilChavan on 14/02/22.
//  Copyright © 2022 Hurix Systems. All rights reserved.
//

#import "ParseUGCData.h"


@implementation ParseUGCData

-(NSMutableArray *) parseBookDataToStoreInDB:(NSDictionary *)ugcDictionary forBookID:(NSNumber *)bookID forPageNumber:(NSNumber *)pageNumber andDisplayNumber:(NSNumber *)displayNumber forUserID:(KitabooUser *)user
{
    NSMutableArray *ugcKitabooArray = [[NSMutableArray alloc] init];
    NSArray *ugcArray = [[ugcDictionary objectForKey:@"links"] objectForKey:@"link"];
    if (ugcArray && [ugcDictionary objectForKey:@"links"] == 1) {
        NSDictionary *dict = [[ugcDictionary objectForKey:@"links"] objectForKey:@"link"];
            if ([[[dict objectForKey:@"type"] objectForKey:@"text"] isEqualToString:@"pen"]) {
              [ugcKitabooArray addObject:[self parsePenData:dict forUser:user andPageID:pageNumber andDisplayNumber:displayNumber andBookID:bookID]];
        }
    }else if (ugcArray && ugcArray.count > 0) {
        
        for (NSDictionary *dict in ugcArray) {
            if ([[[dict objectForKey:@"type"] objectForKey:@"text"] isEqualToString:@"pen"]) {
              [ugcKitabooArray addObject:[self parsePenData:dict forUser:user andPageID:pageNumber andDisplayNumber:displayNumber andBookID:bookID]];
            }
            if ([[[dict objectForKey:@"type"] objectForKey:@"text"] isEqualToString:@"bookmark"]) {
              [ugcKitabooArray addObject:[self parseBookMarkData:dict forUser:user andPageID:pageNumber andDisplayNumber:displayNumber andBookID:bookID]];
            }
            if ([[[dict objectForKey:@"type"] objectForKey:@"text"] isEqualToString:@"note"]) {
              [ugcKitabooArray addObject:[self parseNoteData:dict forUser:user andPageID:pageNumber andDisplayNumber:displayNumber andBookID:bookID]];
            }
            if ([[[dict objectForKey:@"type"] objectForKey:@"text"] isEqualToString:@"highlight"]) {
              [ugcKitabooArray addObject:[self parseNoteData:dict forUser:user andPageID:pageNumber andDisplayNumber:displayNumber andBookID:bookID]];
            }
        }
    }
    return ugcKitabooArray;
}

-(NSDictionary *)parsePenData:(NSDictionary *)dict forUser:(KitabooUser *)user andPageID:(NSNumber *)pageID andDisplayNumber:(NSNumber *)displayNumber andBookID:(NSNumber *)bookID
{
    NSMutableDictionary *ugcDataDict = [[NSMutableDictionary alloc] init];
    [ugcDataDict setValue:bookID forKey:@"bookID"];
    [ugcDataDict setValue:@"" forKey:@"createdOn"];
    [ugcDataDict setValue:user.userID forKey:@"creatorId"];
    [ugcDataDict setValue:user.userName forKey:@"creatorName"];
    [ugcDataDict setValue:[displayNumber stringValue] forKey:@"folioID"];
    [ugcDataDict setValue:0 forKey:@"isAnswered"];
    [ugcDataDict setValue:0 forKey:@"isCollabSubmitted"];
    [ugcDataDict setValue:0 forKey:@"important"];
    [ugcDataDict setValue:0 forKey:@"isReceived"];
    [ugcDataDict setValue:0 forKey:@"isShare"];
    [ugcDataDict setValue:0 forKey:@"isSubmitted"];
    [ugcDataDict setValue:0 forKey:@"isSynced"];
    [ugcDataDict setValue:[[dict objectForKey:@"name"] objectForKey:@"text"] forKey:@"linkID"];
    [ugcDataDict setValue:@"NA" forKey:@"localId"];
    NSString *metadataString = [[NSMutableString alloc] init];
    metadataString = [self generateMetaData:dict];
    [ugcDataDict setValue:metadataString forKey:@"metadata"];
    [ugcDataDict setValue:@"NA" forKey:@"modifiedDate"];
    [ugcDataDict setValue:[pageID stringValue] forKey:@"pageId"];
    [ugcDataDict setValue:@"NA" forKey:@"serverID"];
    [ugcDataDict setValue:@"NEW" forKey:@"status"];
    [ugcDataDict setValue:@"" forKey:@"ugcData"];
    [ugcDataDict setValue:@3 forKey:@"type"];
    [ugcDataDict setValue:user.userID forKey:@"userID"];
    return ugcDataDict;
}

-(NSString *)generateMetaData:(NSDictionary *)metaData
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:[NSNumber numberWithInt:1] forKey:@"LineWidth"];
    [dataDict setValue:[NSNumber numberWithInt:0] forKey:@"ChapterId"];
    [dataDict setValue:[NSNumber numberWithInt:0] forKey:@"LineStyle"];
    [dataDict setValue:[[[metaData objectForKey:@"color"] objectForKey:@"text"] stringByReplacingOccurrencesOfString:@"#" withString:@""] forKey:@"LineColor"];
    NSArray *array = [[[metaData objectForKey:@"location"] objectForKey:@"text"] componentsSeparatedByString:@";"];
    NSMutableArray *pointsArray = [[NSMutableArray alloc] init];
    for (NSString *points in array)
    {
        NSArray *xyPointsArray = [points componentsSeparatedByString:@","];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[xyPointsArray objectAtIndex:0] forKey:@"x"];
        [dict setValue:[xyPointsArray objectAtIndex:1] forKey:@"y"];
        [pointsArray addObject:dict];
    }
    [dataDict setValue:pointsArray forKey:@"PathPoints"];
    NSError * err;
    [dataDict setValue:[NSNumber numberWithInt:1] forKey:@"LineWidth"];
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dataDict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    myString = [myString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return myString;
}


// Parse Bookmark Data
-(NSDictionary *)parseBookMarkData:(NSDictionary *)dict forUser:(KitabooUser *)user andPageID:(NSNumber *)pageID andDisplayNumber:(NSNumber *)displayNumber andBookID:(NSNumber *)bookID
{
    NSMutableDictionary *ugcDataDict = [[NSMutableDictionary alloc] init];
    [ugcDataDict setValue:bookID forKey:@"bookID"];
    [ugcDataDict setValue:@"" forKey:@"createdOn"];
    [ugcDataDict setValue:user.userID forKey:@"creatorId"];
    [ugcDataDict setValue:user.userName forKey:@"creatorName"];
    [ugcDataDict setValue:[displayNumber stringValue] forKey:@"folioID"];
    [ugcDataDict setValue:0 forKey:@"isAnswered"];
    [ugcDataDict setValue:0 forKey:@"isCollabSubmitted"];
    [ugcDataDict setValue:0 forKey:@"important"];
    [ugcDataDict setValue:0 forKey:@"isReceived"];
    [ugcDataDict setValue:0 forKey:@"isShare"];
    [ugcDataDict setValue:0 forKey:@"isSubmitted"];
    [ugcDataDict setValue:0 forKey:@"isSynced"];
    [ugcDataDict setValue:[[dict objectForKey:@"name"] objectForKey:@"text"] forKey:@"linkID"];
    [ugcDataDict setValue:@"NA" forKey:@"localId"];
    NSString *metadataString = [[NSMutableString alloc] init];
    metadataString = [self generateMetaDataForBookmark:dict];
    [ugcDataDict setValue:metadataString forKey:@"metadata"];
    [ugcDataDict setValue:@"NA" forKey:@"modifiedDate"];
    [ugcDataDict setValue:[pageID stringValue] forKey:@"pageId"];
    [ugcDataDict setValue:@"NA" forKey:@"serverID"];
    [ugcDataDict setValue:@"NEW" forKey:@"status"];
    [ugcDataDict setValue:@"" forKey:@"ugcData"];
    [ugcDataDict setValue:@4 forKey:@"type"];
    [ugcDataDict setValue:user.userID forKey:@"userID"];
    return ugcDataDict;
}

-(NSString *)generateMetaDataForBookmark:(NSDictionary *)metaData
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:@"NA" forKey:@"createdOn"];
    [dataDict setValue:@"NA" forKey:@"ChapterName"];
    [dataDict setValue:@"NA" forKey:@"ChapterId"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dataDict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    myString = [myString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return myString;
}


// Parse Note Data
// Parse Bookmark Data
-(NSDictionary *)parseNoteData:(NSDictionary *)dict forUser:(KitabooUser *)user andPageID:(NSNumber *)pageID andDisplayNumber:(NSNumber *)displayNumber andBookID:(NSNumber *)bookID
{
    NSMutableDictionary *ugcDataDict = [[NSMutableDictionary alloc] init];
    [ugcDataDict setValue:bookID forKey:@"bookID"];
    [ugcDataDict setValue:@"" forKey:@"createdOn"];
    [ugcDataDict setValue:user.userID forKey:@"creatorId"];
    [ugcDataDict setValue:user.userName forKey:@"creatorName"];
    [ugcDataDict setValue:[displayNumber stringValue] forKey:@"folioID"];
    [ugcDataDict setValue:0 forKey:@"isAnswered"];
    [ugcDataDict setValue:0 forKey:@"isCollabSubmitted"];
    [ugcDataDict setValue:0 forKey:@"important"];
    [ugcDataDict setValue:0 forKey:@"isReceived"];
    [ugcDataDict setValue:0 forKey:@"isShare"];
    [ugcDataDict setValue:0 forKey:@"isSubmitted"];
    [ugcDataDict setValue:0 forKey:@"isSynced"];
    [ugcDataDict setValue:[[dict objectForKey:@"name"] objectForKey:@"text"] forKey:@"linkID"];
    [ugcDataDict setValue:@"NA" forKey:@"localId"];
    [ugcDataDict setValue:@"NA" forKey:@"modifiedDate"];
    [ugcDataDict setValue:[pageID stringValue] forKey:@"pageId"];
    [ugcDataDict setValue:@"NA" forKey:@"serverID"];
    [ugcDataDict setValue:@"NEW" forKey:@"status"];
    if ([[dict objectForKey:@"ugcData"] objectForKey:@"text"] != nil && ![[[dict objectForKey:@"ugcData"] objectForKey:@"text"] isEqualToString:@""] && ![[[dict objectForKey:@"ugcData"] objectForKey:@"text"] isEqualToString:@"NA"]) {
        NSString *ugcString = [[NSMutableString alloc] init];
        ugcString = [self generateUGCDataForNote:dict];
        [ugcDataDict setValue:ugcString forKey:@"ugcData"];
        
        NSString *metadataString = [[NSMutableString alloc] init];
        metadataString = [self generateMetaDataForNote:dict];
        [ugcDataDict setValue:metadataString forKey:@"metadata"];
    }else{
        [ugcDataDict setValue:@"NA" forKey:@"ugcData"];
        
        NSString *metadataString = [[NSMutableString alloc] init];
        metadataString = [self generateMetaDataForHighlight:dict];
        [ugcDataDict setValue:metadataString forKey:@"metadata"];
    }
    
    [ugcDataDict setValue:@2 forKey:@"type"];
    [ugcDataDict setValue:user.userID forKey:@"userID"];
    return ugcDataDict;
}

-(NSString *)generateMetaDataForNote:(NSDictionary *)metaData
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue:@"-1" forKey:@"EndWordIndex"];
    [dataDict setValue:@"-1" forKey:@"StartWordIndex"];
    [dataDict setValue:@"NA" forKey:@"ChapterName"];
    [dataDict setValue:@"NA" forKey:@"createdOn"];
    [dataDict setValue:@"D17D00" forKey:@"backgroundColor"];
    [dataDict setValue:0 forKey:@"IsImportant"];

    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dataDict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    myString = [myString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return myString;
}

-(NSString *)generateMetaDataForHighlight:(NSDictionary *)metaData
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    NSArray *xyPointsArray = [[[metaData objectForKey:@"location"] objectForKey:@"text"] componentsSeparatedByString:@";"];
    
    [dataDict setValue:[xyPointsArray objectAtIndex:0] forKey:@"EndWordIndex"];
    [dataDict setValue:[xyPointsArray objectAtIndex:1] forKey:@"StartWordIndex"];
    [dataDict setValue:@"NA" forKey:@"ChapterName"];
    [dataDict setValue:@"NA" forKey:@"createdOn"];
    [dataDict setValue:@"D17D00" forKey:@"backgroundColor"];
    [dataDict setValue:0 forKey:@"IsImportant"];
    [dataDict setValue:@"Highligted Text" forKey:@"HighlightedText"];

    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dataDict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    myString = [myString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return myString;
}

-(NSString *)generateUGCDataForNote:(NSDictionary *)metaData
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    NSArray *xyPointsArray = [[[metaData objectForKey:@"location"] objectForKey:@"text"] componentsSeparatedByString:@";"];

    [dataDict setValue:[xyPointsArray objectAtIndex:1] forKey:@"y"];
    [dataDict setValue:[xyPointsArray objectAtIndex:0] forKey:@"x"];
    [dataDict setValue:[NSMutableArray new] forKey:@"Comments"];
    [dataDict setValue:[NSMutableArray new] forKey:@"sharedWithUsers"];
    [dataDict setValue:@"NA" forKey:@"Text"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dataDict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    myString = [myString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return myString;
}

@end
