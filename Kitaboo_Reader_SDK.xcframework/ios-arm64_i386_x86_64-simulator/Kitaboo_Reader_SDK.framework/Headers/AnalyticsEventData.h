//
//  AnalyticsEventData.h
//  KItabooSDK
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kEventTypeTrack=0,
    kEventTypeNotify=1
}EventType;

@interface AnalyticsEventData : NSObject
@property (nonatomic,strong)NSString *uniqueID;
@property (nonatomic,strong)NSString *pageID;
@property (nonatomic) EventType eventType;
@property (nonatomic,strong)NSDictionary *eventInfo;
-(NSDictionary*)getDictionary;
-(id)initWithDictionary:(NSDictionary*)eventDic;
@end
