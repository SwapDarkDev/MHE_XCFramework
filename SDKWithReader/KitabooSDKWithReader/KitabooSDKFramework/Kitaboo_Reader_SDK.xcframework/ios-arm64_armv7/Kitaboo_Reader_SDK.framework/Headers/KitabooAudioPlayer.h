//
//  KitabooAudioPlayer.h
//  Kitaboo 2.1
//
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KFBookVO.h"

/*!
 * @protocol AudioPlayerDelegate
 * @brief A protocol that allows a delegate to respond when an audio sound stopped playing, started playing or when a sound has finished playing.
 * @discussion The delegate of a KitabooAudioPlayer object must adopt the AudioPlayerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol AudioPlayerDelegate <NSObject>
@optional

/*!
 * Will be call when Audio Player Finished Playing.
 **/
- (void)audioPlayerFinishPlaying;

/*!
 * Will be call when Audio Player Stoped Playing.
 **/
-(void)audioPlayerDidStopped;

/*!
 * Will be call when Audio Player Started Playing.
 **/
-(void)audioPlayerDidStart;
/*!
 * Will be called when External Audio is failed to load.
 * @param error type of NSError
 **/
- (void)remoteAudioLoadingDidFailed:(NSError *)error;
/*!
 * Will be called when External Audio is loaded.
 **/
- (void)remoteAudioDidLoad;
@end

/** An Object that manage an Audio Player.
 @discussion The KitabooAudioPlayer class defines a Player to play an Audio sound. The KitabooAudioPlayer class lets you play sound in any audio format. You implement a delegate to handle, when a sound stopped playing or to update the user interface, when a sound has finished playing. To start and stop an audio player, call one of its methods.
 @superclass SuperClass : UIViewController
 */
@interface KitabooAudioPlayer : UIViewController

/*!
 * Setter/Getter for delegate (callback listener)
 * @code
 * [kitabooAudioPlayer setDelegate:self];
 * @endcode
 */
@property (nonatomic, weak) id<AudioPlayerDelegate> delegate;

/*!
 * Setter/Getter for play audio resource in background
 * @code
 * kitabooAudioPlayer.isAudioResourcePlaybackground = YES;
 * @endcode
 */
@property (nonatomic) BOOL isAudioResourcePlaybackground;

/*!
 * To set whether the resource is external
 * @code
 * [KitabooAudioPlayer setIsExternalResource:YES];
 * @endcode
 */
+(void) setIsExternalResource:(BOOL)isExternalResource;

/*!
 * Will be called when user retries to load the Audio.
 **/
- (void)retryAudioLoading;

/*!
 * Initiate Audio Player.
 * @param1 targetURL Audio URL.
 * @param2 bookPath Book path.
 * @param3 isbn Book ISBN Number.
 * @param4 playerUIEnabled Enable or disable Audio player UI.
 * @param5 encrypted Audio URL is encrypted or decrypted.
 * @discussion Initializes and returns a newly allocated KitabooAudioPlayer object with specified audio URL, book path and Book ISBN Number.
 * @code
 * [[KitabooAudioPlayer alloc] initWithURL:targetURL withBookPath:bookPath withISBN:isbn WithPlayerUIEnable:YES withIsEncrypted:YES];
 * @endcode
 **/
-(id)initWithURL:(NSString *)targetURL withBookPath:(NSString*)bookPath withISBN:(NSString*)isbn WithPlayerUIEnable:(BOOL)playerUIEnabled withIsEncrypted:(BOOL)encrypted;

/*!
 * Returns Audio Player View.
 * @code
 * [kitabooAudioPlayer getPlayerView];
 * @endcode
 **/
-(UIView*)getPlayerView;

/*!
 * To Start Audio.
 * @code
 * [kitabooAudioPlayer start];
 * @endcode
 */
-(void)start;

/*!
 * To Stop Audio.
 * @code
 * [kitabooAudioPlayer stop];
 * @endcode
 */
-(void)stop;
@end
