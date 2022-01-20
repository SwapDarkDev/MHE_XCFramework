//
//  HDVideoTOCPlayerController.h
//  KItabooSDK
//
//  Created by Sumanth on 05/11/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDAVTOCPlayerControllerDelegate <NSObject>

@optional
/*!
 Will be called when video player is stopped explicitly
 */
- (void)videoTOCPlayerDidStopPlaying;

/*!
 Will be called when video player is finished playing
 */
- (void)videoTOCPlayerDidFinishPlaying;

/*!
 Will be called when video player is in pause state
 */
- (void)videoTOCPlayerDidPausePlaying;

/*!
 Will be called when video player enters full screen
 */
- (void)videoTOCPlayerDidEnterFullScreen;

@end

@interface HDAVTOCPlayerController : UIViewController

@property (nonatomic, weak) id<HDAVTOCPlayerControllerDelegate> delegate;
/*!
 To Initialise HDAVTOCPlayerController
 * @param1 avPath Device Physical path of audio/video
 * @code
 * HDAVTOCPlayerController *videoTOCPlayerController = [[HDAVTOCPlayerController alloc] initWithTOCPlayerVideoPath:videoPath];
 * @endcode
 */
- (id)initWithTOCPlayerVideoPath:(NSString *)avPath;
/*!
 To set the TOC data with title
 * @param1 data collection of HDVideoTOCVO objects for TOC Data
 * @param2 title tiltle of audio/video
 * @code
 * [videoTOCPlayerController setTOCData:[NSArray arrayWithObjects:@"Data1", nil] withTitle:@"title"];
 * @endcode
 */
- (void)setTOCData:(nullable NSArray *)data withTitle:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
