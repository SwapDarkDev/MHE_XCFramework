//
//  KitabooYoutubeViewController.h
//  Kitaboo
//
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFBookVO.h"

/*!
 * @protocol KitabooYTPlayerDelegate
 * @brief A protocol that allows a delegate to respond when an YouTube video player closed.
 * @discussion The delegate of a KitabooYTPlayer object must adopt the KitabooYTPlayerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol KitabooYTPlayerDelegate<NSObject>
@optional

/*!
 * Will be called when YouTube Player closed.
 **/
-(void)didCloseYoutubePlayer;
@end

/** An Object that manage a YouTube Player.
 * @discussion The KitabooYTPlayer class defines a Player to play a YouTube Video. You implement a delegate to handle, when YouTube player closed.
 * @superclass SuperClass : UIViewController
 */
@interface KitabooYTPlayer : UIViewController

/*!
 * Setter/Getter for delegate (callback listener)
 * @code
 * [kitabooYTPlayer setDelegate:self];
 * @endcode
 */
@property (weak, nonatomic) id<KitabooYTPlayerDelegate> delegate;

/*!
 * Initiate Youtube Player.
 * @param linkVo Is the KFLinkVO object.
 * @discussion Initializes and returns a newly allocated KitabooYTPlayer object with specified object of type KFLinkVO.
 * @code
 * [[KitabooYTPlayer alloc] initWithLinkVO:linkVo];
 * @endcode
 **/
-(id)initWithLinkVO:(KFLinkVO*)linkVo;

/*!
 * Initiate Youtube Player.
 * @param videoURL Is the Video URL.
 * @discussion Initializes and returns a newly allocated KitabooYTPlayer object with specified video URL.
 * @code
 * [[KitabooYTPlayer alloc] initWithURL:videoURL];
 * @endcode
 **/
-(id)initWithURL:(NSString *)videoURL;

/*!
 * Initiate Youtube Player.
 * @param1 videoURL URL of Video.
 * @param2 frame Rect of video with respect to parent view.
 * @discussion Initializes and returns a newly allocated KitabooYTPlayer object with specified video URL and  Rect of video player view.
 * @code
 * [[KitabooYTPlayer alloc] initWithURL:videoURL withRect:frame];
 * @endcode
 **/
-(id)initWithURL:(NSString *)videoURL withRect:(CGRect)frame;

/*!
 * Return Inline Youtube Player View.
 * @code
 * [kitabooYTPlayer getYoutubeInlinePlayer];
 * @endcode
 **/
- (UIView *)getYoutubeInlinePlayer;

/*!
 * Close Youtube Player.
 * @code
 * [kitabooYTPlayer close];
 * @endcode
 **/
- (void)close;

/*!
 * Returns a Boolean value that indicates whether the Youtube Player is Inline or not.
 * @code
 * [kitabooYTPlayer isInline];
 * @endcode
 **/
-(BOOL)isInline;
@end
