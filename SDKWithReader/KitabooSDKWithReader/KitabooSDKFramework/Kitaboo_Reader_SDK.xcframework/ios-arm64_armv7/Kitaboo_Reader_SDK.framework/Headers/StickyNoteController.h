//
//  StickyNoteController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StickyNoteController;

/*!
 @protocol StickyNoteControllerDelegate.
 @brief The delegate of a StickyNoteController object must adopt the StickyNoteControllerDelegate protocol.
 @discussion StickyNoteControllerDelegate Protocol used to handle all the callbacks of StickyNoteController Class. All the Delegate methods are optional. The StickyNoteControllerDelegate protocol defines method that allow user to perform action when sticky note icon is tapped. 
 
 When configuring the StickyNoteController object, assign your delegate object to its delegate property.
 */
@protocol StickyNoteControllerDelegate <NSObject>
@optional
/*!
 This method is called when user tap on any point on screen.
 @param1 stickyNoteController is object of class StickyNoteController.
 @param2 tapPoint is of type CGPoint.
 @discussion tapPoint returns points where user tap on screen.User can use this touchpoint and do operation like creating note at touch point.
 */
-(void)didTapOnStickNoteController:(StickyNoteController*)stickyNoteController AtPoint:(CGPoint)tapPoint;
@end

/**
 @discussion The StickyNoteController class is used to detect users touch point on screen to create note at detected touch point.
 @superclass SuperClass : UIView
 */
@interface StickyNoteController : UIView

/*!
 To instialise StickyNoteController
 @param1 frame Initial frame for StickyNoteController
 @param2 delegate callback listener
 @discussion User can use this method to initialise StickyNoteController and can do additional initialization in this method, this is entry point function.
 @code
 [stickyNoteController initWithFrame:self.view.bounds WithDelegate:self]
 @endcode
 */
-(id)initWithFrame:(CGRect)frame WithDelegate:(id<StickyNoteControllerDelegate>)delegate;


/*!
 The object that acts as the delegate of the stickyNoteController.
 @discussion The delegate must adopt the StickyNoteControllerDelegate protocol. The delegate is not retained.
 @code
  [stickyNoteController setDelegate:self]
 @endcode
 */
@property (weak, nonatomic) id<StickyNoteControllerDelegate> delegate;

@end
