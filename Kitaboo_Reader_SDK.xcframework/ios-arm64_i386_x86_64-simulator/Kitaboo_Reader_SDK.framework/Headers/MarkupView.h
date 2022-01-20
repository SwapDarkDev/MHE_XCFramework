//
//  MarkupView.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDKFIBVO;

/**
 * MarkupView is used to manage look and feel of links available on pages, also it is reponsible for handling action when user select the specific markup. MarkupView is extended from UIButton, so to add action, UIButton standards need to followed.
 @discussion The MarkupView contains information about position, linkID and pageID that are needed to draw markup.
 @superclass SuperClass : UIButton
 */
@interface MarkupView : UIButton
/*!
 * Setter/Getter for pageID where markup is being added.
 * @code
 * [markupView setpageID:pageID];
 * @endcode
 */
@property (nonatomic) NSInteger pageID;

/*!
 * Setter/Getter for linkID.
 * @code
 * [markupView setlinkID:linkID];
 * @endcode
 */
@property (nonatomic) NSInteger linkID;

/*!
 * Setter/Getter for xCordinate i.e,X-Position of the markupView on the page.
 * @code
 * [markupView setxCordinate:xCordinate];
 * @endcode
 */

@property (nonatomic) NSString *xCordinate;


/*!
 * Setter/Getter for yCordinate i.e,Y-Position of the markupView on the page.
 * @code
 * [markupView setyCordinate:yCordinate];
 * @endcode
 */
@property (nonatomic) NSString *yCordinate;

/*!
 * sdkFIBVO of type SDKFIBVO of the markupview like dropdown.
 */
@property (nonatomic,strong) SDKFIBVO *sdkFIBVO;


/*!
 To make markup as invisible.
 @discussion This method is used to make markup as invisible, invisible markup is tappable or user can interact with it. For example,some markups on page are not visible but they are present and can receive touch events
 @code
 [multiLink.iconView setAsInvisibleMarkup];
 @endcode
 */
- (void)setAsInvisibleMarkup;

/*!
 To make markup as hidden.
 @discussion This method is used to hide and disable the user interaction of markup
 @code
 [multiLink.iconView setAsHiddenMarkup];
 @endcode
 */
- (void)setAsHiddenMarkup;
/*!
 To set DropDown markup Alignment.
 @discussion This method is used to set Alignment,Text color,DropDown markup bordercolor,borderwidth etc.
 @param1 inputText dropDown input Text
 @param2 properties properties contains FontType,FontSize,TextColor,Alignment
 @code
 [link.iconView updateForDropDownWithInputText:fibVO.text withLinkProperties:link.properties];
 @endcode
 */
- (void)updateForDropDownWithInputText:(NSString *)inputText withLinkProperties:(NSString*)properties;
@end

