//
//  KitabooVideoPlayer.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFBookVO.h"
#import "EPUBBookVO.h"

typedef enum
{
    kVideoTypeLocal=0,
    kVideoTypeVimeo=1,
    kVideoTypeKaltura
}VIDEOTYPE;

/*!
 * @protocol KitabooVideoPlayerDelegate
 * @brief A protocol that allows a delegate to respond when an video stopped playing, paused playing or when a video has finished playing.
 * @discussion The delegate of a KitabooVideoPlayer object must adopt the KitabooVideoPlayerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol KitabooVideoPlayerDelegate <NSObject>
@optional

/*!
 * Will be called when video player is stopped explicitly.
 */
- (void)videoPlayerDidStopPlaying;

/*!
 * Will be called when video player is finished playing.
 */
- (void)videoPlayerDidFinishPlaying;

/*!
 * Will be called when video is paused.
 */
- (void)videoPlayerDidPausePlaying;

/*!
 * Will be called when video player entered in full screen.
 */
- (void)videoPlayerDidEnterFullScreen;

/*!
 * Will be called when video player exit full screen.
 */
- (void)videoPlayerDidExitFullScreen;
@end

/** An Object that manage a Video Player.
 * @discussion The KitabooVideoPlayer class defines a Player to play an Video. You implement a delegate to handle, when a video stopped playing or to update the user interface, when a video has finished playing.
 * @superclass SuperClass : UIViewController
 */
@interface KitabooVideoPlayer : UIViewController

/*!
 * Setter/Getter for delegate (callback listener)
 * @code
 * [kitabooVideoPlayer setDelegate:self];
 * @endcode
 */
@property (nonatomic, weak) id<KitabooVideoPlayerDelegate> delegate;

/*!
 * To set whether the resource is external
 * @code
 * [KitabooAudioPlayer setIsExternalResource:YES];
 * @endcode
 */
+(void) setIsExternalResource:(BOOL)isExternalResource;

/*!
 * Should be called to initiate the video player.
 * @param1 videoPath Is the location of video in library.
 * @param2 bookVO Is the EPUBBookVO object.
 * @param3 resource Is the EPUBResource object.
 * @discussion Initializes and returns a newly allocated KitabooVideoPlayer object with specified video path, object of type EPUBBookVO and object of type EPUBResource.
 * @code
 * [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withBookVO:bookVO withLinkVO:linkVO];
 * @endcode
 */
- (id)initWithVideoPath:(NSString *)videoPath withBookVO:(EPUBBookVO *)bookVO withResource:(EPUBResource *)resource;

/*!
 * Should be called to initiate the video player.
 * @param1 videoPath Is the location of video in library.
 * @param2 bookVO Is the KFBookVO object.
 * @param3 linkVO Is the KFLinkVO object.
 * @discussion Initializes and returns a newly allocated KitabooVideoPlayer object with specified video path, object of type KFBookVO and object of type KFLinkVO.
 * @code
 * [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withBookVO:bookVO withLinkVO:linkVO];
 * @endcode
 */
- (id)initWithVideoPath:(NSString *)videoPath withBookVO:(KFBookVO *)bookVO withLinkVO:(KFLinkVO *)linkVO;

/*!
 * Should be called to initiate the video player.
 * @param1 videoPath Is the location of video in library.
 * @param2 videoType Set the video type which needs to played.
 * @param3 frame Rect of video with respect to parent view.
 * @discussion Initializes and returns a newly allocated KitabooVideoPlayer object with specified video path, type of video and Rect of video.
 * @code
 * [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withType:videoType withRect:frame];
 * @endcode
 */
- (id)initWithVideoPath:(NSString *)videoPath withType:(VIDEOTYPE)videoType withRect:(CGRect)frame;

/*!
 * Should be called to initiate the video player.
 * @param1 videoPath Is the location of video in library.
 * @param2 videoType Set the video type which needs to played.
 * @discussion Initializes and returns a newly allocated KitabooVideoPlayer object with specified video path, type of video and decrytion key.
 * @code
 * [[KitabooVideoPlayer alloc] initWithVideoPath:videoPath withType:videoType withDecrytionKey:key];
 * @endcode
 */
- (id)initWithVideoPath:(NSString *)videoPath withType:(VIDEOTYPE)videoType withDecrytionKey:(NSString *)key;

/*!
 * Should be called to play the video.
 * @code
 * [kitabooVideoPlayer playVideo];
 * @endcode
 */
- (void)playVideo;


/*!
 * Should be called to get the Video Player view.
 * @code
 * [kitabooVideoPlayer getInlineVideoPlayer];
 * @endcode
 */
- (UIView *)getInlineVideoPlayer;

@end
