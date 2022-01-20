//
//  KitabooDocumentPlayer.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @protocol KitabooDocumentPlayerDelegate
 * @brief A protocol that allows a delegate to respond when document player closed.
 * @discussion The delegate of a KitabooDocumentPlayer object must adopt the KitabooDocumentPlayerDelegate protocol. All the methods of this protocol are optional.
 */
@protocol KitabooDocumentPlayerDelegate <NSObject>
@optional

/*!
 * Will be called when Document Player Closed.
 */
- (void)documentPLayerDidClosed;
@end

/** An Object that manage a Player to open a document.
 * @discussion The KitabooDocumentPlayer class lets you open a document on a web player, With Added features Like Print Document, You implement a delegate to handle, when document player closed.
 * @superclass SuperClass : UIViewController
 */
@interface KitabooDocumentPlayer : UIViewController

/*!
 * To set whether the resource is external
 * @code
 * [KitabooAudioPlayer setIsExternalResource:YES];
 * @endcode
 */
+(void) setIsExternalResource:(BOOL)isExternalResource;

/*!
 * Initiate Document Player view.
 * @param1  targetURL Is the NSURL to be loaded in webview.
 * @discussion Initializes and returns a newly allocated KitabooDocumentPlayer object with specified URL.
 * @code
 * [[KitabooDocumentPlayer alloc] initWithURL:targetURL];
 * @endcode
 */
- (id)initWithURL:(NSURL*)targetURL;

/*!
 * Should be called to disable the Print Button.
 * @param1 disable Is a Bool type to set print button enable/disable.
 * @code
 * [kitabooDocumentPlayer disablePrint:YES];
 * @endcode
 */
- (void)disablePrint:(BOOL)disable;

/*!
 * This method used to  set Theme color to Document Player.
 * @param1 color Pass the color to set the Theme color.
 * @code
 * [kitabooDocumentPlayer setThemeColorToView:color];
 * @endcode
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * Setting/Getter for delegate (callback listener).
 * @code
 * [kitabooDocumentPlayer setDelegate:self];
 * @endcode
 */
@property (nonatomic,weak) id<KitabooDocumentPlayerDelegate>delegate;

@end
