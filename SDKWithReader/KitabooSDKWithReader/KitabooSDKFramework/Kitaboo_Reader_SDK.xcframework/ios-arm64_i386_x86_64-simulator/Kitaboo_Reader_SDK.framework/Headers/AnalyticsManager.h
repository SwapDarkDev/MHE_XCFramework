//
//  AnalyticsManager.h
//  KItabooSDK
//
//  Created by Hurixadmin on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *Name of the notification which needs to used while adding the observer.
 */
#define KITABOO_ANALYTICS_EVENT @"KitabooAnalyticsEvent"

/** An object that manage analytics.
 @discussion The AnalyticsManager class is responsible for keep track of analytics data for page, note, highlight and link.
 @superclass SuperClass : NSObject
 */
@interface AnalyticsManager : NSObject


/*!
 * Returns Singleton instnace of AnalyticsManager
 */
+ (AnalyticsManager*)getInstance;
/*!
 * Implement this method to track event, its a one stop method to track any event, Tracking is done based on the parameters
 * @param1 eventName Name of event that needs to be tracked, if Same event is tracked multiple times, name would be unique in the end result, however info will be appended with same event name.
 * @param2 eventInfo Event info with all the information that needs to be tracked.
 * @param3 uniqueID uniqueID of event, No duplicate (Event name and Unique ID) can be added.
 */
-(void)trackEvent:(NSString *)eventName WithEventInfo:(NSDictionary *)eventInfo WihUniqueID:(NSString*)uniqueID;

/*!
* Implement this method to notify application events, its a one stop method to notify any event i.e,login, action on button etc
* @param1 eventName Name of event that needs to be notified
* @param2 eventInfo Event info with all the information that needs to be notified.
 @discussion The event will be notified when user add NSNotification Observer with notification name "KitabooAnalyticsEvent".The output of the notification user info will be { EventName = Login;Parameters = { }; }
*/
-(void)notifyEvent:(NSString *)eventName WithEventInfo:(NSDictionary *)eventInfo;
/*!
 * Returns event tracking JSON. All the data will be cleared when this method is called.
 */
-(NSString*)getTrackingJSON;
/*!
 * Implement this method to set the event tracking data
 * @param1 jsonData JSON formated string of event, the stucture should be same as returned by getTrackingJSON method.
 */
-(void)setTrackingDataFromJSONString:(NSString*)jsonData;

/*!
* Returns AnalyticsEvents as type NSDictionary.
*/
-(NSDictionary*)getAnalyticsEvents;
/*!
 * Remove all AnalyticsEvents tracking.
 */
-(void)deleteAllReaderAnalytics;
@end
