//
//  KitabooImageController.h
//  KItabooSDK

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

/*!
 * @protocol KitabooImageControllerDelegate
 * @brief A protocol that allows a delegate to respond when image loading view is closed or image loading is failed.
 * @discussion The delegate of a KitabooImageController object must adopt the KitabooImageControllerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol KitabooImageControllerDelegate<NSObject>
@optional

/*!
 * This will be called when image controller view is closed.
 */
-(void)didTapOnCloseForImageContoller;

/*!
 * This will be called when image failed to load.
 */
-(void)didFailedLoadingImage;
/*!
 * This will be called when external  image failed to load.
 *  @param error type of NSError
 */
-(void)didFailedLoadingImage:(NSError *)error;
/*!
 * Will be called when the remote image is downloaded .
 * @param position  is the collection view cell position where the image needs to be set.
 **/
-(void)didLoadRemoteImage:(NSInteger)position;
@end

/** An Object that manage a view to open an image.
 * @discussion The KitabooImageController class lets user to open an image or multiple images, in a separate view. You implement a delegate to handle, when image loading view is closed or image loading is failed.
 * @superclass SuperClass : UIViewController
 */
@interface KitabooImageController : UIViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,ImageDownloadTaskDelegate>

/*!
 * To set whether the resource is external
 * @code
 * [KitabooAudioPlayer setIsExternalResource:YES];
 * @endcode
 */
+(void) setIsExternalResource:(BOOL)isExternalResource;
/*!
 * To initialise image controller view.
 * @param1 imagesURLs Array of imagesURLs.
 * @param2 properties Array of property of image.
 * @param3 ISBN ISBN of Book.
 * @param4 encryption Encryption status of imagePath.
 * @param5 zoom Zoom feature of image.
 * @param6 delegate Delegate of type KitabooImageControllerDelegate.
 * @discussion Initializes and returns a newly allocated KitabooImageController object with specified image imagesURLs, properties and ISBN of Book.
 * @code
 * [[KitabooImageController alloc] initWithImageURLs:imagesURLs withProperties:properties withISBN:ISBN isEncrypted:YES isZoomable:YES WithDelegate:self];
 * @endcode
 */
-(id)initWithImageURLs:(NSArray *)imagesURLs withProperties:(NSArray *)properties withISBN:(NSString *)ISBN isEncrypted:(BOOL)encryption isZoomable:(BOOL)zoom WithDelegate:(id<KitabooImageControllerDelegate>)delegate;

/*!
 * Will be called when image is downloaded .
 * @param position  is the collection view cell position where the image needs to be set.
 **/
-(void)setDownloadedImageAtPosition:(NSInteger)position;

/*!
 * Will be called when user retries to load the Image.
 **/
-(void)retryImageLoading;
@end
