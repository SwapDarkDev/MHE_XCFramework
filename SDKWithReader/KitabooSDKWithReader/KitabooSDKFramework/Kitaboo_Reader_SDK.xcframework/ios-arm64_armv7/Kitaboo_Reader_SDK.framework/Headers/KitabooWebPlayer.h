//
//  KitabooWebPlayer.h
//  KItabooSDK
//
//  Created by Sumanth Myrala on 30/04/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFBookVO.h"
#import <WebKit/WebKit.h>

/*!
 * @protocol KitabooWebPlayerDelegate
 * @brief The delegate of a KitabooWebPlayer object must adopt the KitabooWebPlayerDelegate protocol.
 * @discussion The KitabooWebPlayerDelegate protocol defines methods that allow user to perform actions when web player will be closed or failed to load url. All the methods of KitabooWebPlayerDelegate protocol are optional. When configuring the KitabooWebPlayer object, assign your delegate object to its delegate property.
 */
@protocol KitabooWebPlayerDelegate <NSObject>
@optional

/*!
 * Will be called when web player is closed.
 */
- (void)webPLayerDidClosed;

/*!
 * Will be called when URL failed to load.
 */
- (void)webPlayerDidFailedWithError:(NSError*)error;

/*!
 * Will be called when web player is closed with scorm data.
 * @param1 ScormData Scorm Data.
 * @param2 activityName Activity Name.
 * @param3 scormID Scorm ID.
 * @param4 pageID Page ID.
 */
-(void)webPlayerWillCloseWithScormData:(NSString *)ScormData activityName:(NSString *)activityName withScormID:(NSString *)scormID withPageID:(NSString *)pageID;
/*!
 * Will be called when kitabooWebPlayer allow to creates a new web view.
 * @Discussion
 * The web view returned must be created with the specified configuration. WebKit loads the request in the returned web view.
 * @param webView
 * The web view invoking the delegate method.
 * @param2 configuration
 * The configuration to use when creating the new web view.
 * @param3 navigationAction
 * The navigation action causing the new web view to be created.
 */
- (WKWebView *)webView:(WKWebView *)webView createKitabooPlayerWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction;

@end

/** An Object that manage a player to load an URL.
 * @discussion The KitabooWebPlayer is responsible for Loading URL.
 * @superclass SuperClass : UIViewController
 */
@interface KitabooWebPlayer : UIViewController
/*!
 * Initiate Web Player view.
 * @param1  urlRequest Is the NSURLRequest to be loaded in webview.
 * @param2  configuration Is the WKWebViewConfiguration object.
 * @discussion Initializes and returns a newly allocated KitabooWebPlayer object with specified URLRequest
 * @code
 * [[KitabooWebPlayer alloc]initWithURL:navigationAction.request configuration:configuration];
 * @endcode
 */
-(id)initWithURL:(NSURLRequest*)urlRequest configuration:(WKWebViewConfiguration *)configuration;
/*!
 * Initiate Web Player view.
 * @param1  targetURL Is the NSURL to be loaded in webview.
 * @param2  linkVO Is the KFLinkVO object.
 * @param3  bookVO Is the KFBookVO object.
 * @discussion Initializes and returns a newly allocated KitabooWebPlayer object with specified URL, object of type KFLinkVO and object of type KFBookVO.
 * @code
 * [[KitabooWebPlayer alloc] initWithURL:targetURL withLinkVO:linkVO WithBook:bookVO];
 * @endcode
 */
- (id)initWithURL:(NSURL*)targetURL withLinkVO:(KFLinkVO *)linkVO WithBook:(KFBookVO *)bookVO;

/*!
 * Initiate Web Player view.
 * @param1  targetURL Is the NSURL to be loaded in webview.
 * @discussion Initializes and returns a newly allocated KitabooWebPlayer object with specified URL.
 * @code
 * [[KitabooWebPlayer alloc] initWithURL:targetURL];
 * @endcode
 */
- (id)initWithURL:(NSString*)targetURL;

/*!
 * Initiate Scorm Player view.This method/initializer will be longer working with SDK Version 2.2.0.Kindly use KitabooScormWebPlayer to Initiate Scorm Player.
 * @param1  targetURL Is the NSURL to be loaded in webview.
 * @param2  scormID Is unique id for a book.
 * @param3  scormData For existing scorm.
 * @param4  isDoneButtonVisible For done button visibility.
 * @discussion Initializes and returns a newly allocated KitabooWebPlayer object with specified URL, scorm ID and scorm data.
 * @code
 * [[KitabooWebPlayer alloc] initWithScormPackageURL:targetURL withScormID:scormID withScormData:scormData isDoneButtonVisible:YES];
 * @endcode
 */
-(id)initWithScormPackageURL:(NSString*)targetURL withScormID:(NSString *)scormID withScormData:(NSString  *)scormData isDoneButtonVisible:(BOOL)isDoneButtonVisible;

/*!
 * Setter/Getter for delegate (callback listener)
 * @code
 * [kitabooWebPlayer setDelegate:self];
 * @endcode
 */
@property (nonatomic,weak) id<KitabooWebPlayerDelegate>delegate;

/*!
* Setter/Getter object for WKWebView
*/
@property (nonatomic,strong) WKWebView *webView;

/*!
* Setter/Getter of the URL that should be loaded in WKWebView
*/
@property (nonatomic,strong) NSURL *targetURL;

/*!
 * This method used to  set Theme color to WebPlayer.
 * @param1 color Pass the color to set the Theme color.
 * @code
 * [kitabooWebPlayer setThemeColorToView:color];
 * @endcode
 */
-(void)setThemeColorToView:(UIColor *)color;

/*!
 * This method used to  close WebPlayer.
 * @code
 * [kitabooWebPlayer closePlayer];
 * @endcode
 */
-(void)closePlayer;

/*!
* This method used to  close WebPlayer a completion handler which will return the data from webview
* @code
* [kitabooWebPlayer closePlayerWithCompletion:^(NSString *result, NSError *error) {
     
 }];
* @endcode
*/
-(void)closePlayerWithCompletion:(void (^)(NSString *result, NSError *error))completionHandler;
/*!
 * Use this method to set the title for the button
 * @param1 title The title to use for the specified state.
 * @code
 * [kitabooWebPlayer setDoneButtonTitle:title];
 * @endcode
 */
-(void)setDoneButtonTitle:(NSString*)title;
/*!
 * Sets the color of the title to use for the specified state.
 * @param1 titleColor The color of the title to use for the specified state.
 */
-(void)setDoneButtonTitleColor:(UIColor*)titleColor;
@end
