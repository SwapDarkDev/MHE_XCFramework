//
//  KitabooAudioPlayer.h
//
//  Copyright (c) 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol HDFixedAudioPlayerDelegate <NSObject>
@optional
/*!
 * Will be call when Audio Player Finish Playing.
 **/
- (void)fixedAudioPlayerFinishPlaying;
/*!
 * Will be call when Audio Player Stop Playing.
 **/
-(void)fixedAudioPlayerDidStopped;
/*!
 * Will be call when Audio Player Start Playing.
 **/
-(void)fixedAudioPlayerDidStart;
@end

@interface HDFixedAudioPlayer : UIViewController

@property (nonatomic, weak) id<HDFixedAudioPlayerDelegate> delegate;
/*!
 * Initiate Audio Player
 * @param1 targetURL Audio URL
 * @param2 playerUIEnabled Enable or disable Audio player UI
 **/
-(id)initWithURL:(NSString *)targetURL WithPlayerUIEnable:(BOOL)playerUIEnabled;
/*!
 * Start Audio Player
 */
-(void)start;
/*!
 * Stop Audio Player
 */
-(void)stop;
/*!
 * This Method set color to Play and Pause button.
 * @param1 titleColor pass color will set to Play and Pause button's
 */
-(void)setPlayPauseButtonTitleColor:(UIColor *)titleColor;
/*!
 * This Method set color to timer label.
 * @param1 color pass color will set to timer label
 */
-(void)setTimeLabelColor:(UIColor *)color;
/*!
 * This Method set color to close button.
 * @param1 titleColor pass color will set to close button
 */
-(void)setCloseButtonTitleColor:(UIColor *)titleColor;
@end
