//
//  ePUBNoteController.h
//  ePUBSDK
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//
//

#import <UIKit/UIKit.h>
#import "UGC.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

/*!
 @protocol HSNoteControllerDelegate
 @brief The delegate of a HSNoteController object must adopt the HSNoteControllerDelegate protocol.
 @discussion HSNoteControllerDelegate Protocol used to handle all the callbacks of HSNoteController Class. All delegate methods are optional. Delegate method gets called when user selects any one of buttons (Cancel, Post, Share, Delete, Comment) available on note controller. When configuring the HSNoteController object, assign your delegate object to its delegate property.
 */
@protocol HSNoteControllerDelegate <NSObject>
@optional
/*!
 This Method gets called when user tap on cancel button on note.
 @param1 highlight is object of SDKHighlightVO.
 @discussion highlight is used to identify selected note for which NoteController is initiated. User can dismiss note controller in this method.
 */
- (void)didTapOnCancelNote:(SDKHighlightVO *)highlight;

/*!
 This Method gets called when user tap on Post button on note.
 @param1 highlight is object of SDKHighlightVO.
 @discussion highlight is used to identify selected note for which NoteController is initiated. User can save or update note and dismiss note controller in this method.
 */
- (void)didTapOnPostNote:(SDKHighlightVO *)highlight;

/*!
 This Method gets called when user tap on Delete button on note.
 @param1 highlight is object of SDKHighlightVO.
 @discussion highlight is used to identify selected note for which NoteController is initiated. User can delete note object from array or database and remove that note from screen.
 */
- (void)didTapOnDeleteNote:(SDKHighlightVO *)highlight;

/*!
 This Method gets called when user tap on Share button on note.
 @param1 highlight is object of SDKHighlightVO.
 @discussion highlight is used to identify selected note for which NoteController is initiated. User can update note object or can open new view to show list of members to which he/she can share note.
 */
- (void)didTapOnShareNote:(SDKHighlightVO *)highlight;

/*!
 This Method gets called when user tap on Post Comment button on note.
 @param1 highlight is object of SDKHighlightVO.
 @discussion highlight is used to identify selected note for which NoteController is initiated. User can update note object or can update view to add comments on note view.
 */
-(void)didTapOnPostNoteComment:(SDKHighlightVO *)highlight;
@end

/**
 An Object that manage operations on note.
 @discussion The HSNoteController class is used to show note where user can create note by using post button , delete note by using delete button, update note by editing existing note, can make note as important by tapping on topbar of note.
 @superclass SuperClass : UIViewController
 */
@interface HSNoteController : UIViewController

/*!
 Setter/Getter for Highlight
 @discussion To open note controller, highlight object is mendatory.
 @code
 _noteController.highlight = highlight
 @endcode
 */
@property (strong, nonatomic) SDKHighlightVO *highlight;

/*!
 The object that acts as the delegate of the hsnotecontroller.
 @discussion The delegate must adopt the HSNoteControllerDelegate protocol.
 @code
  _noteController.delegate = self (Object that confirms to HSNoteControllerDelegate)
 @endcode
 */
@property (weak, nonatomic) id<HSNoteControllerDelegate> delegate;

/*!
 To Show/Hide Post Button.
 @discussion To show or hide Post button present on note, where user can pass YES/true to show Post button or NO/false to hide Post button.
 @param1 shouldShow is a boolean value where user can pass true/false depending on his/her need.
 @code
 [_noteController showPostButton:YES]
 @endcode
 */
-(void)showPostButton:(BOOL)shouldShow;

/*!
 To Show/Hide Share Button.
 @discussion To show or hide share button present on note, where user can pass YES/true to show share button or NO/false to hide share button.
 @param1 shouldShow is a boolean value where user can true/false depending on his/her need.
 @code
 [_noteController showShareButton:YES]
 @endcode
 */
-(void)showShareButton:(BOOL)shouldShow;

/*!
 To set the color for shared UGC.
 @discussion To set the color for shared Highlight/Notes, if the hexColor is nil/or we have not called this menthod, then the default color(Blue) will be applied.
 @param1 hexColor is hexa color for shared Highlight/Notes.
 @code
 [_noteController setColorForSharedUGC:@"ffffff"]
 @endcode
 */
- (void)setColorForSharedUGC:(NSString *)hexColor;

/*!
 To set the color of cursor.
 @discussion To set the color of cursor of note controller textview, if the tintColor is nil then the default color (Black) will be applied.
 @param1 tintColor is UIColor which to be set to cursor.
 @code
 [_noteController setTextViewTintColor:@"ffffff"]
 @endcode
 */
-(void)setTextViewTintColor:(UIColor *)tintColor;

/*!
 Setter/Getter for User (Object of Type KitabooUser).
 @discussion user object of Type KtabooUser is used to access user data.
 @code
 _noteController.user=_user;
 @endcode
 */
@property KitabooUser *user;

@end
