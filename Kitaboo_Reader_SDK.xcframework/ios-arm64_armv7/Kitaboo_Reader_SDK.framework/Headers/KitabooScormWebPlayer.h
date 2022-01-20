//
//  KitabooScormWebPlayer.h
//  KItabooSDK
//
//  Created by Sumanth Myrala on 28/09/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface KitabooScormWebPlayer : KitabooWebPlayer

/*!
* This method should be called to initialize Scorm player
* @param1  targetURL is the NSString i.e, path of the Scorm to be loaded in webview.
* @param2  scormID is unique id for a Scorm activity.
* @param3  scormData is the NSString i.e, activity data that should be loaded in the webview.
* @discussion Initializes and returns a newly allocated KitabooScormWebPlayer object with specified URL, scorm ID and scorm data.
* @code
* [[KitabooScormWebPlayer alloc] initWithURL:targetURL withScormID:scormID withScormData:scormData];
* @endcode
*/
-(id)initWithURL:(NSString *)targetURL withScormID:(NSString *)scormID withScormData:(NSString *)scormData;

/*!
* This method should be called to initialize Scorm player
* @param1  targetURL is the NSString i.e, path of the Scorm to be loaded in webview.
* @param2  scormID is unique id for a Scorm activity.
* @param3  scormData is the NSString i.e, activity data that should be loaded in the webview.
* @param3  isDoneButtonVisible is the value to show or hide done button.
* @discussion Initializes and returns a newly allocated KitabooScormWebPlayer object with specified URL, scorm ID and scorm data.
* @code
* [[KitabooScormWebPlayer alloc] initWithURL:targetURL withScormID:scormID withScormData:scormData];
* @endcode
*/
-(id)initWithURL:(NSString *)targetURL withScormID:(NSString *)scormID withScormData:(NSString *)scormData isDoneButtonVisible:(BOOL)isDoneButtonVisible;

/*!
* This method should be called to get the Scorm Activity data
* @code
* [kitabooWebPlayer getScormActivityData:^(NSString *scormData, NSError *error) {
     
 }];
* @endcode
*/
-(void)getScormActivityData:(void (^)(NSString *scormData, NSDictionary *scormDetails))completionHandler;



@end

NS_ASSUME_NONNULL_END
