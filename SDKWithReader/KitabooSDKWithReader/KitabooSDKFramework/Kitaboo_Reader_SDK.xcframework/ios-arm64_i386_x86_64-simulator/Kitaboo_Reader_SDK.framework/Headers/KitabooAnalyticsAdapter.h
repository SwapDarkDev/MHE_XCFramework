//
//  KitabooAnalyticsController.h
//  KItabooSDK
//
//  Created by Sumanth Myrala on 25/04/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

/** An object that manage analytics.
 @discussion The KitabooAnalyticsAdapter class is responsible to convert the data of AnalyticsManager to specific json format which is required for Kitaboo.
 @superclass SuperClass : NSObject
 */
@interface KitabooAnalyticsAdapter : NSObject

/*!
 *Implement this method to get the data of AnalyticsManager to specific json format which is required for Kitaboo.
 *@discussion To get analytics data such as how many pages has been swiped, how many time spend on each page, notes created, deleted, updtaed, shared or recieved and normal or important highlight created or deleted or any link opened.
 * @return Returns Kitaboo Reader Analytics JSON String
 * @param1 analyticsData JSON String of Events, Use Analytics Manager to get analytics JSON
 *@code
 [analyticsAdapter getAnalyticsData:[[AnalyticsManager getInstance] getTrackingJSON]];
 *@endcode
 */
- (NSString *)getAnalyticsData:(NSString *)analyticsData;

- (NSString *)getLastPageFolioFromAnalyticsData;

@property (nonatomic, assign) int minTimeSpendLimit;
@end

