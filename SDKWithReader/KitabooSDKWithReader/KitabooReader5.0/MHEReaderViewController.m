//
//  MHEReaderViewController.m
//  KitabooSDKWithReader
//
//  Created by SwapnilChavan on 01/02/22.
//  Copyright © 2022 Hurix Systems. All rights reserved.
//

#import "MHEReaderViewController.h"
#import "GenerateXMLFormat/XMLParser/XMLReader.h"
#import "MHEUGCData/ParseUGCData.h"
@interface MHEReaderViewController()
{
    
}
@end

@implementation MHEReaderViewController

#pragma mark ViewLifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

// Callback when we close book
-(void) onBookClose
{
    NSLog(@"On Book Close");
}

// Callback when we open book
-(void) onBookOpen
{
    NSLog(@"On Book Open");
}

//// to get all unsynced UGC data when we close the book
//-(void) saveUnsyncedUGCForBookID:(NSNumber *)bookID andUserID:(NSString *)userID withUGC:(NSDictionary *)ugcList forPageID:(NSNumber *)pageNumber
//{
//    NSLog(@"ugc %@ -- bookID %@",ugcList, bookID);
    
//}


// to get all data ugc related to book (synced and unsynced)
-(void) loadUgcPerPageForBookID:(NSInteger)bookID andUserID:(NSString *)userID withUGC:(NSString *)pageUGC forPageID:(NSNumber *)pageID
{
    NSLog(@"ugc %@ -- bookID %ld",pageUGC, (long)bookID);
}


-(void)saveUGCPerPageForBookID:(NSInteger)bookID forPageID:(NSInteger)pageNumber forUser:(KitabooUser *)user completion:(void(^)(void))callback
{
    NSString *xmlData = @"";
    if (pageNumber == 1) {
        xmlData = [NSString stringWithFormat:@"<links><link><type>pen</type><thickness>NA</thickness><pageIndex>%@</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>297.5361328125,418.130859375;297.5361328125,419.8359375;297.5361328125,428.9296875;297.5361328125,453.369140625;297.5361328125,466.7255859375;297.5361328125,478.0927734375;297.5361328125,485.4814453125;297.5361328125,490.880859375;297.5361328125,495.99609375;297.5361328125,499.974609375;297.5361328125,503.384765625;297.5361328125,505.658203125;297.8203125,507.6474609375;297.8203125,508.2158203125;298.1044921875,508.2158203125</location><color>#000000</color><user_type>TEACHER</user_type></link><link><type>pen</type><thickness>NA</thickness><pageIndex>3</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>294.41015625,298.775390625;294.41015625,302.4697265625;294.41015625,312.7001953125;294.41015625,324.3515625;294.41015625,336.0029296875;294.41015625,347.0859375;294.41015625,354.7587890625;294.41015625,359.3056640625;294.41015625,363.8525390625;294.41015625,368.3994140625;294.41015625,372.662109375;294.41015625,376.640625;294.41015625,379.1982421875;294.41015625,380.05078125;294.41015625,380.3349609375;294.41015625,380.05078125</location><color>#000000</color><user_type>TEACHER</user_type></link><link><type>pen</type><thickness>NA</thickness><pageIndex>3</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>117.9345703125,75.6943359375;118.21875,75.6943359375;119.923828125,75.6943359375;125.3232421875,75.6943359375;132.7119140625,75.6943359375;139.5322265625,75.6943359375;146.9208984375,75.6943359375;154.3095703125,75.6943359375;161.1298828125,75.6943359375;168.802734375,75.6943359375;174.7705078125,75.6943359375;179.3173828125,75.6943359375;183.01171875,75.6943359375;185.28515625,75.6943359375;186.421875,75.6943359375;186.7060546875,75.6943359375;187.2744140625,75.6943359375</location><color>#000000</color><user_type>TEACHER</user_type></link></links>",[NSNumber numberWithInt:pageNumber]];
    }else if(pageNumber == 2)
    {
        xmlData = [NSString stringWithFormat:@"<links><link><type>pen</type><thickness>NA</thickness><pageIndex>%@</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>297.5361328125,418.130859375;297.5361328125,419.8359375;297.5361328125,428.9296875;297.5361328125,453.369140625;297.5361328125,466.7255859375;297.5361328125,478.0927734375;297.5361328125,485.4814453125;297.5361328125,490.880859375;297.5361328125,495.99609375;297.5361328125,499.974609375;297.5361328125,503.384765625;297.5361328125,505.658203125;297.8203125,507.6474609375;297.8203125,508.2158203125;298.1044921875,508.2158203125</location><color>#000000</color><user_type>TEACHER</user_type></link><link><type>pen</type><thickness>NA</thickness><pageIndex>3</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>117.9345703125,75.6943359375;118.21875,75.6943359375;119.923828125,75.6943359375;125.3232421875,75.6943359375;132.7119140625,75.6943359375;139.5322265625,75.6943359375;146.9208984375,75.6943359375;154.3095703125,75.6943359375;161.1298828125,75.6943359375;168.802734375,75.6943359375;174.7705078125,75.6943359375;179.3173828125,75.6943359375;183.01171875,75.6943359375;185.28515625,75.6943359375;186.421875,75.6943359375;186.7060546875,75.6943359375;187.2744140625,75.6943359375</location><color>#000000</color><user_type>TEACHER</user_type></link><link><type>note</type><name>5677566443_2_note_15.02.22 08:57:41</name><location>176.203125;305.789062</location><pageIndex>2</pageIndex><content>NA</content><user_type>TEACHER</user_type><properties>NA</properties></link><link><type>bookmark</type><name>5677566443_2_bookmark_15.02.22 10:20:13</name><location>2</location><pageIndex>%@</pageIndex><content><![CDATA[to]]></content><user_type>TEACHER</user_type><properties>NA</properties></link></links>",[NSNumber numberWithInt:pageNumber],[NSNumber numberWithInt:pageNumber]];
    }else if(pageNumber == 3)
    {
        xmlData = [NSString stringWithFormat:@"<links><link><type>pen</type><thickness>NA</thickness><pageIndex>%@</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>297.5361328125,418.130859375;297.5361328125,419.8359375;297.5361328125,428.9296875;297.5361328125,453.369140625;297.5361328125,466.7255859375;297.5361328125,478.0927734375;297.5361328125,485.4814453125;297.5361328125,490.880859375;297.5361328125,495.99609375;297.5361328125,499.974609375;297.5361328125,503.384765625;297.5361328125,505.658203125;297.8203125,507.6474609375;297.8203125,508.2158203125;298.1044921875,508.2158203125</location><color>#000000</color><user_type>TEACHER</user_type></link><link><type>pen</type><thickness>NA</thickness><pageIndex>%@</pageIndex><name>5677566443_15_pen_15.02.22 06:37:39</name><properties>NA</properties><location>294.41015625,298.775390625;294.41015625,302.4697265625;294.41015625,312.7001953125;294.41015625,324.3515625;294.41015625,336.0029296875;294.41015625,347.0859375;294.41015625,354.7587890625;294.41015625,359.3056640625;294.41015625,363.8525390625;294.41015625,368.3994140625;294.41015625,372.662109375;294.41015625,376.640625;294.41015625,379.1982421875;294.41015625,380.05078125;294.41015625,380.3349609375;294.41015625,380.05078125</location><color>#000000</color><user_type>TEACHER</user_type></link><link><type>bookmark</type><name>5677566443_2_bookmark_15.02.22 10:20:13</name><location>3</location><pageIndex>%@</pageIndex><content><![CDATA[to]]></content><user_type>TEACHER</user_type><properties>NA</properties></link><link><type>highlight</type><name>9780079017253_3_highlight_15.02.22 13:17:58</name><color>#ffffff28</color><location>300019;30020;30001;3000</location><pageIndex>3</pageIndex><content>NA</content><user_type>TEACHER</user_type><properties>NA</properties><thickness>NA</thickness></link></links>",[NSNumber numberWithInt:pageNumber],[NSNumber numberWithInt:pageNumber],[NSNumber numberWithInt:pageNumber]];
    }
     //
    NSData *data = [xmlData dataUsingEncoding:NSUTF8StringEncoding];
    //some data that can be received from remote service
    NSError *error = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    NSLog(@"%@",dict);
    
    NSArray *ugcData = [[[ParseUGCData alloc] init] parseBookDataToStoreInDB:dict forBookID:[NSNumber numberWithInt:bookID] forPageNumber:[NSNumber numberWithInt:pageNumber] andDisplayNumber:[NSNumber numberWithInt:pageNumber] forUserID:user];
    
    HSDBManager *_dbManager = [[HSDBManager alloc] init];
    [_dbManager deleteAllUGCForBookID:[NSNumber numberWithLong:bookID] UserID:user.userID andPageID:[NSNumber numberWithInt:pageNumber]];

    for (NSDictionary *dict in ugcData) {
        if (@available(iOS 13.0, *)) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *myNumber = [f numberFromString:user.userID];
            [self getDictionaryFromJSONFormatedString:[dict objectForKey:@"metadata"]];
            [_dbManager saveKitabooUGCWithDictionary:dict withBookID:[NSNumber numberWithInt:bookID] userID:myNumber withIsSynced:true WithModifiedDate:[NSDate now]];
        } else {
            // Fallback on earlier versions
        }
    }
    callback();
}

-(NSDictionary*)getDictionaryFromJSONFormatedString:(NSString*)jsonFormatedString
{
    if(jsonFormatedString)
    {
        NSString *removePercentFromjsonFormatedString =[jsonFormatedString stringByRemovingPercentEncoding];
        NSData *data = [removePercentFromjsonFormatedString dataUsingEncoding:NSUTF8StringEncoding];
        if(data)
        {
            NSDictionary* metaDataJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            return metaDataJson;
        }
        return nil;
    }
    else
    {
        return nil;
    }
}
@end
