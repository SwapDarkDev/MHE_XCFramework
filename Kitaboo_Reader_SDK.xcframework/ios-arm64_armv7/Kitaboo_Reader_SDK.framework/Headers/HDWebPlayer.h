//
//  HDKitabooWebViewPlayer.h
//  Kitaboo
//
//  Copyright © 2018 CEPL. All rights reserved.
//


#import <WebKit/WebKit.h>

/*!
 @protocol HDWebPlayerDelegate
 @brief The delegate of a HDWebPlayer object must adopt the HDWebPlayerDelegate protocol.
 @discussion HDWebPlayerDelegate Protocol used to handle all the callbacks of HDWebPlayer Class. The HDWebPlayerDelegate protocol defines methods that allow user to perform actions when web player will be closed or failed to load url. All the methods of HDWebPlayerDelegate protocol are optional. When configuring the HDWebPlayer object, assign your delegate object to its delegate property.
 */
@protocol HDWebPlayerDelegate <NSObject>
@optional

/*!
 *Will be called when closing the web player.
 */
- (void)webViewPlayerDidClose;

/*!
 *Will be called when web player failed to load the URL.
 @param error The NSError object when URL failed to load.
 */
- (void)webViewPlayerDidFailWithError:(NSError*)error;


@end

/** An Object that manage a player to load an URL.
 @discussion The HDWebPlayer is responsible for Loading URL, which Uses Kitaboo Defined UI for Look and feel.
 @superclass SuperClass : UIViewController
 */
@interface HDWebPlayer : UIViewController

/*!
 * Initiate HDWebPlayer view with URL to be loaded.
 * @param1  htmlPath Is the absolute html Path URL to be loaded in webview.
 @code
 [hdWebPlayer initWithHTMLPathURL:[NSURL URLWithString:@"https://www.google.com"]]
 @endcode
 */
- (id)initWithHTMLPathURL:(NSURL *)htmlPath;

/*!
 Setter/Getter for delegate (callback listener)
 @code
 [hdWebPlayer setDelegate:self]
 @endcode
 */
@property (nonatomic,weak) id<HDWebPlayerDelegate>delegate;
@end
