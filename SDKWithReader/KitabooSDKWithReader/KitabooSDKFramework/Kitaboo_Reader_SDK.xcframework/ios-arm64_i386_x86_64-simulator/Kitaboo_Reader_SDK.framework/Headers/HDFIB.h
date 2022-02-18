//
//  HDFIB.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFBookVO.h"
#import "UGC.h"
@class HDFIB;
@protocol HDFIBDelegate<NSObject>
/*!
 * Will be call when FIB Completed Editing.
 * @param1 sdkFIBVO SDKFIBVO Object
 **/
-(void)didUpdateSDKFIBVO:(SDKFIBVO*)sdkFIBVO;

/*!
 * Will be call when select submitted FIB
 * @param1 sdkFIBVO SDKFIBVO object
 * @param2 linkAnswer FIB Link Answer.
 * @param3 sourceView selected View
 **/
-(void)didSelectSubmittedFIB:(SDKFIBVO*)sdkFIBVO withLinkAnswer:(NSString*)linkAnswer withSourceView:(UIView*)sourceView;
@optional
/*!
 Asks the delegate if editing should begin in the specified FIBView for linkVO.
 @Discussion
 When the user performs an action that would normally initiate an editing session, the FIBView calls this method for linkVO first to see if editing should actually proceed. In most circumstances, you would simply return YES from this method to allow editing to proceed.
 Implementation of this method by the delegate is optional. If it is not present, editing proceeds as if this method had returned YES.
 @param1 linkVO KFLinkVO object for which editing is about to begin.
 **/
-(BOOL)shouldAllowEditingForLinkVO:(KFLinkVO*)linkVO;
@optional
/*!
@Discussion
This method notifies the delegate that the specified FIB just became the first responder. Use this method to update state information or perform other tasks.
Implementation of this method by the delegate is optional.
 @param1 hdFIBVO The FIB in which an editing session began.
 **/
-(void)fibDidBeginEditing:(HDFIB*)hdFIBVO;
/*!
 @Discussion
 This method notifies the delegate that Keyboard is Display for specified FIB.
 Use this method to update state information or perform other tasks.
 Implementation of this method by the delegate is optional.
 @param1 hdFIBView The FIB for which Keyboard is display.
 @param2 keyboardRect KeyBoard Display Frame.
 **/
-(void)keyboardDidShowForFIB:(HDFIB*)hdFIBView withKeyboardFrame:(CGRect)keyboardRect;
/*!
 @Discussion
 This method is called after the FIB resigns its first responder status.
 Use this method to update state information or perform other tasks.
 Implementation of this method by the delegate is optional.
 @param1 hdFIBVO The FIB in which an editing session began.
 **/
-(void)fibDidEndEditing:(HDFIB*)hdFIBVO;
/*!
 @Discussion
 This method notifies the delegate that Keyboard is Hide for specified FIB.
 Use this method to update state information or perform other tasks.
 Implementation of this method by the delegate is optional.
 @param1 hdFIBView The FIB for which Keyboard is hide.
 @param2 keyboardRect KeyBoard Frame.
 **/
-(void)keyboardDidHideForFIB:(HDFIB*)hdFIBView withKeyboardFrame:(CGRect)keyboardRect;
@end

@interface HDFIB : UIView
/*!
 * Initialise FIB
 * @param1 linkVO Object of KFLinkVO
 * @param2 sdkFIBVO Object of SDKFIBVO
 **/
-(instancetype)initWithLinkVO:(KFLinkVO*)linkVO withFIBVO:(SDKFIBVO*)sdkFIBVO isTeacher:(BOOL)isTeacher;
/*!
 * Setting/Getter for delegate (callback listener)
 */
@property(nonatomic,weak)id<HDFIBDelegate>delegate;
/*!
 Setter and getter for SDKFIBVO object
 */
@property (nonatomic,strong) SDKFIBVO *sdkFIBVO;
/*!
 Returns a Boolean value indicating whether this object is the begin editing.
 */
@property (readonly)BOOL isEditing;
/*!
 Setter and getter for KFLinkVO object
 */
@property (nonatomic,strong) KFLinkVO *linkVo;
/*!
 Removes matching entries from the notification center's dispatch table for KeyboardNotification.
 **/
-(void)removeObserverForKeyboardNotification;

/*!
 Use this parameter to disable default keyboard. The Default value is `false`.
 */
@property (nonatomic) BOOL isDefaultKeyboardDisabled;

/*!
 Focus to fib text field.
 */
-(void)focusToTextField;
@end
