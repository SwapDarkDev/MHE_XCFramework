//
//  AudioSyncController.h
//  KItabooSDK
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KFBookVO.h"

/*!
 * @protocol AudioSyncControllerDelegate
 * @brief A protocol that allows a delegate to respond when an audio sync stopped, started or when an audio sync has finished .
 * @discussion The delegate of a AudioSyncController object must adopt the AudioSyncControllerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol AudioSyncControllerDelegate<NSObject>
@optional

/*!
 * Will be called when audio sync text is detected, use this callback to hightlight the text on Renderer.
 * @param1 frame Rect of text to be hightlighted
 * @param2 pageIdentifier Page ID of page on which text needs to be highlighted.
 */
-(void)didJumpToTextWithFrame:(CGRect)frame WithPageIdentifier:(NSString*)pageIdentifier;

/*!
 * Will be called when audio sync text is detected, use this callback to hightlight the sentence with frames for same group id on Renderer.
 * @param1 frames Rects of text to be hightlighted as sentence.
 * @param2 pageIdentifier Page ID of page on which sentence needs to be highlighted.
 */
-(void)didJumpToSentenceWithWordFrames:(NSArray*)frames WithPageIdentifier:(NSString*)pageIdentifier;

/*!
 * Will be called when audio sync loading failed.
 */
-(void)didFailedAudioSync:(NSError*)error;

/*!
* Will be called when audio sync text is detected, use this callback to hightlight the text on epub Renderer.
* @param1 wordId word id for text to be hightlighted
* @param2 pageIdentifier page identifier for text to be hightlighted
*/
-(void)didJumpToTextWithWordId:(NSString*)wordId WithPageIdentifier:(NSString*)pageIdentifier;

/*!
 * Will be called when audio sync is completed.
 */
-(void)audioSyncdidComplete;

/*!
 * Will be called when audio sync is Stopped.
 */
-(void)audioSyncDidStopped;

/*!
 * Will be called when audio sync is Paused.
 */
-(void)audioSyncDidPaused;
/*!
 * Will be called when audio sync is completed.
 * @param1 pageIdentifier Page ID of page on which audio sync is completed.
 */
-(void)audioSyncdidCompleteForPageIdentifier:(NSString*)pageIdentifier;
@end

/** An Object that manage Audio Sync.
 @discussion Audio synchronization is Responsible for Handling Links of Type AudioSync, AudioSync is a feature which enable user to read(Play Audio) each page content,Currenly this is only supported for Kitaboo Fixed Book.
 @superclass SuperClass : NSObject
 */
@interface AudioSyncController : NSObject

/*!
 * Setter/Getter for delegate (callback listener)
 * @code
 * [audioSyncController setDelegate:self];
 * @endcode
 */
@property (nonatomic,weak) id<AudioSyncControllerDelegate> delegate;

/*!
 * To initilize Audio Sync.
 * @param1 links Array of Object of KFLinkVO for which Audio Sync is available. (Currently works with Only One Link in Links Array)
 * @param2 delegate Delegate of type AudioSyncControllerDelegate.
 * @param3 book Book object for links
 * @param4 playerUIEnabled If YES then dafault UI will be available, else Developer can use customized UI and use the available methods to control the behaviour.
 * @discussion Initializes and returns a newly allocated AudioSyncController object with specified links Array, and Book object for links.
 * @code
 * [[AudioSyncController alloc] initWithLinks:links WithDelegate:delegate WithBook:book WithPlayerUIEnable:YES];
 * @endcode
 */
-(id)initWithLinks:(NSArray*)links WithDelegate:(id<AudioSyncControllerDelegate>)delegate WithBook:(KFBookVO*)book WithPlayerUIEnable:(BOOL)playerUIEnabled;

/*!
 * To initilize Audio Sync.
 * @param1 links Array of Object of KFLinkVO for which Audio Sync is available. (Currently works with Only One Link in Links Array)
 * @param2 delegate Delegate of type AudioSyncControllerDelegate.
 * @param3 book Book object for links
 * @param4 playerUIEnabled If YES then dafault UI will be available, else Developer can use customized UI and use the available methods to control the behaviour.
 * @discussion Initializes and returns a newly allocated AudioSyncController object with specified links Array, and Book object for links.
 * @code
 * [[AudioSyncController alloc] initWithLinks:links WithDelegate:delegate WithBook:book WithPlayerUIEnable:YES];
 * @endcode
 */
-(id)initWithLinks:(NSArray*)links WithDelegate:(id<AudioSyncControllerDelegate>)delegate WithKitabooBook:(KitabooBookVO*)book WithPlayerUIEnable:(BOOL)playerUIEnabled;
/*!
 * To Start Audio Sync.
 * @code
 * [audioSyncController start];
 * @endcode
 */
-(void)start;

/*!
 * To resume Audio Sync.
 * @code
 * [audioSyncController resume];
 * @endcode
 */
-(void)resume;

/*!
 * To pause Audio Sync.
 * @code
 * [audioSyncController pause];
 * @endcode
 */
-(void)pause;

/*!
 * To stop Audio Sync.
 * @code
 * [audioSyncController pause];
 * @endcode
 */
-(void)stop;

/*!
 * Returns the status of Audio Sync for page.
 * @param1 pageIdentifier Page ID of page to check status of Audio Sync.
 * @code
 * [audioSyncController isPlayingForPageIdentifier:pageIdentifier];
 * @endcode
 */
-(BOOL)isPlayingForPageIdentifier:(NSString*)pageIdentifier;

/*!
 * Returns the status of Audio Sync.
 * @code
 * [audioSyncController isPlaying];
 * @endcode
 */
-(BOOL)isPlaying;

/*!
 * Returns the default Player View.
 * @code
 * [audioSyncController getPlayerView];
 * @endcode
 */
-(UIView*)getPlayerView;
/*!
 * To play/pause Audio Sync.
 * @code
 * [audioSyncController playPauseAction];
 * @endcode
 */
-(void)playPauseAction;
/*!
 * Returns the Page ID on which audio is playing.
 * @code
 * [audioSyncController audioPlayingForPageIdentifier];
 * @endcode
 */
-(NSString*)audioPlayingForPageIdentifier;
/*!
 * To change Audio Sync speed.
 *@discussion  default speed of 1.0 provides normal playback rate. The available range is from 0.5 for half-speed playback through 2.0 for double-speed playback.
 * @code
 * [audioSyncController changeAudioPlayingSpeed:speed];
 * @endcode
 */
-(void)changeAudioPlayingSpeed:(float)speed;
/*!
* To play audio sync from given word id for epub book.
* @param1 wordId Word id from which audio will start playing.
*/
-(void)playAudioFromWordId:(NSString *)wordId;
@end
