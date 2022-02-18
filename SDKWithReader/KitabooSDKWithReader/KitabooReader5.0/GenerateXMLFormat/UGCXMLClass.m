//
//  UGCXMLClass.m
//  KitabooSDKWithReader
//
//  Created by SwapnilChavan on 14/02/22.
//  Copyright © 2022 Hurix Systems. All rights reserved.
//

#import "UGCXMLClass.h"

@implementation UGCXMLClass

+(NSString *) generateXMLForUGCForDictionary:(NSDictionary *)ugcDictionary forPageID:(NSNumber *)pageID andUser:(KitabooUser *)user forBook:(KFBookVO *)book
{
    NSString *xmlString = [[NSMutableString alloc] initWithString:@"<links>"];
    
    if ([ugcDictionary objectForKey:@"ugcBookListWithPage"] != nil) {
        NSArray *ugcList = [ugcDictionary objectForKey:@"ugcBookListWithPage"];
        for (NSDictionary * dict in ugcList[0]) {
            switch ([[dict objectForKey:@"type"] intValue]) {
                case 2:
                {
                    NSLog(@"print");
                    NSDictionary *dictData = [[[dict objectForKey:@"metadata"] stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding];
                    id metadatDictionary = [NSJSONSerialization JSONObjectWithData:dictData options:0 error:nil];
                    NSString *penLocationString = @"";
                    NSString *notePosition = [NSString stringWithFormat:@"%@;%@;", [metadatDictionary objectForKey:@"x"],[metadatDictionary objectForKey:@"y"]];
                    //14.02.22 16:08:08
                    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd.MM.yy HH:mm:ss"];
                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
                    
                    
                    NSString *linkIDFormat = [NSString stringWithFormat:@"%@_%@_%@_%@",book.ISBN,pageID,@"pen",dateString];
                    NSString *userType = [user.role isEqualToString:@"STUDENT"] ? @"STUDENT" : @"TEACHER";
                    NSString *penXMLString = [[NSString alloc] initWithFormat:@"<link><type>note</type><name>%@</name><location>%@</location><pageIndex>%@</pageIndex><content><![CDATA[Note]]></content><user_type>%@</user_type><properties>NA</properties></link>",linkIDFormat,notePosition,pageID.stringValue,userType];
                    xmlString = [xmlString stringByAppendingString:penXMLString];
                }
                    break;
                case 3:
                {
                    NSLog(@"print");
                    NSDictionary *dictData = [[[dict objectForKey:@"metadata"] stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding];
                    id metadatDictionary = [NSJSONSerialization JSONObjectWithData:dictData options:0 error:nil];
                    NSString *penLocationString = @"";

                    for (NSDictionary *penLocationArray in [metadatDictionary objectForKey:@"PathPoints"])
                    {
                        penLocationString = [penLocationString stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@,",[penLocationArray objectForKey:@"x"]]];
                        penLocationString = [penLocationString stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@;",[penLocationArray objectForKey:@"y"]]];
                    }
                    penLocationString = [penLocationString substringToIndex:penLocationString.length - 1];
                    //14.02.22 16:08:08
                    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd.MM.yy HH:mm:ss"];
                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
                    
                    
                    NSString *linkIDFormat = [NSString stringWithFormat:@"%@_%@_%@_%@",book.ISBN,pageID,@"pen",dateString];
                    NSString *penColor = [NSString stringWithFormat:@"#%@",[metadatDictionary objectForKey:@"LineColor"]];
                    NSString *userType = [user.role isEqualToString:@"STUDENT"] ? @"STUDENT" : @"TEACHER";
                    NSString *penXMLString = [[NSString alloc] initWithFormat:@"<link><type>pen</type><thickness>NA</thickness><pageIndex>%@</pageIndex><name>%@</name><properties>NA</properties><location>%@</location><color>%@</color><user_type>%@</user_type></link>",pageID.stringValue,linkIDFormat,penLocationString,penColor,userType];
                    xmlString = [xmlString stringByAppendingString:penXMLString];
                }
                    break;
                case 4:
                {
                    NSLog(@"print");
                    NSDictionary *dictData = [[[dict objectForKey:@"metadata"] stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding];
                    id metadatDictionary = [NSJSONSerialization JSONObjectWithData:dictData options:0 error:nil];
                    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd.MM.yy HH:mm:ss"];
                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
                    NSString *linkIDFormat = [NSString stringWithFormat:@"%@_%@_%@_%@",book.ISBN,pageID,@"bookmark",dateString];
                    NSString *userType = [user.role isEqualToString:@"STUDENT"] ? @"STUDENT" : @"TEACHER";
                    NSString *penXMLString = [[NSString alloc] initWithFormat:@"<link><type>bookmark</type><name>%@</name><location>%@</location><pageIndex>%@</pageIndex><content><![CDATA[to]]></content><user_type>%@</user_type><properties>NA</properties></link>",linkIDFormat,pageID.stringValue,pageID.stringValue,userType];
                    xmlString = [xmlString stringByAppendingString:penXMLString];
                }
                break;
                case 1 :
                {
//                    NSLog(@"print");
//                    NSDictionary *dictData = [[[dict objectForKey:@"metadata"] stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding];
//                    id metadatDictionary = [NSJSONSerialization JSONObjectWithData:dictData options:0 error:nil];
//                    NSString *penLocationString = @"";
//
//                    for (NSDictionary *penLocationArray in [metadatDictionary objectForKey:@"PathPoints"])
//                    {
//                        penLocationString = [penLocationString stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@,",[penLocationArray objectForKey:@"x"]]];
//                        penLocationString = [penLocationString stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@;",[penLocationArray objectForKey:@"y"]]];
//                    }
//                    penLocationString = [penLocationString substringToIndex:penLocationString.length - 1];
//
//                    NSString *penColor = [NSString stringWithFormat:@"#%@",[metadatDictionary objectForKey:@"LineColor"]];
//                    NSString *userType = @"TEACHER";
//                    NSString *penXMLString = [[NSString alloc] initWithFormat:@"<link><type>pen</type><thickness>NA</thickness><pageIndex>3</pageIndex><name>9780079017253_3_pen_14.02.22 16:08:08</name><properties>NA</properties><location>%@</location><color>%@</color><user_type>%@</user_type></link>",penLocationString,penColor,userType];
//                    xmlString = [xmlString stringByAppendingString:penXMLString];
                }
                    break;
                default:
                    break;
            }
        }
    }
    xmlString = [xmlString stringByAppendingString:@"</links>"];
    return xmlString;
}

@end
