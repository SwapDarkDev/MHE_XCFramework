//
//  TeacherReviewController.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import "UGC.h"
#import "PlayerActionBarItem.h"
#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

@protocol TeacherReviewDelegate <NSObject>
@optional
/*!
 * Will be called When Select Learner Name
 * @param1 learnerName Selected Learner name
 * @param2 learnerID Selected Learner's ID
 */
-(void)didSelectLearner:(NSString*)learnerName WithLearnerID:(NSString*)learnerID;
/*!
 * Will be called When Select Pentool
 */
-(void)didSelectPenTypeForTeacherReview;
/*!
 * Will be called When Select PenTool Color
 * @param1 color Selected Pen Color
 */
-(void)didSelectPenColorForTeacherReview:(NSString *)color;
/*!
 * Will be called When Select Eraser Mode
 */
-(void)didSelectEraserForTeacherReview;
/*!
 * Will be called When Select Delete
 */
-(void)didSelectDeleteForTeacherReview;
/*!
 * Will be called When Select Done
 * @param1 anotations Anotations of recently Updated UGC's
 * @param2 learnerID Selected Learner ID
 */
-(void)didSelectDoneForTeacherReviewWithUpdatedAnotations:(NSArray*)anotations ForLearnerID:(NSString*)learnerID;
/*!
 * Will be called When Select Navigate Page Buttons
 * @param1 pageNumber Page Number
 */
-(void)didSelectNavigatePageButtonForTeacherReview:(NSString *)pageNumber;
/*!
 * Will be called When Select Student Popup Open/Close
 * @param1 isStudentPopUpOpen open/close
 */
-(void)didStudentPopUpOpen:(BOOL)isStudentPopUpOpen;

/*!
 * Will be called When Select ClearAll
 */
-(void)didSelectClearAllForTeacherReview;

/*!
 * Will be called When tapped on Generate Report Button
 */
- (void)didSelectGenerateReport;
@end

@interface TeacherReviewController : UIViewController
/*!
 * Setting/Getter for delegate (callback listener)
 */
@property (nonatomic,weak) id <TeacherReviewDelegate> delegate;
/*!
 * This method set Classes Details
 * @param1 classesInfoArray array of classes Information
 * @code
 * [_teacherReviewController setClasses:[class1,class2]];
 * @endcode
 */
-(void)setClasses:(NSArray *)classesInfoArray;
/*!
 * This method set Theme Color
 * @param1 themeColor color that will be set to items of TecherReview
 * @code
 * [_teacherReviewController setThemeColorForTeacherReview:[UIColor redColor]];
 * @endcode
 */
-(void)setThemeColorForTeacherReview:(UIColor *)themeColor;
/*!
 * This method set Theme Color
 * @param1 backgroundColor color that will be set to backgroundColor of topBar and dropDownbar
 * @code
 * [_teacherReviewController setBackgroundColorForTopBarAndDropDown:[UIColor redColor]];
 * @endcode
 */
-(void)setBackgroundColorForTopBarAndDropDown:(UIColor *)backgroundColor;
/*!
 * This method set Pen Color
 * @param1 penColorArray colors Array that will be set to Pen of TecherReview
 * @code
 * [_teacherReviewController setPenColorForTeacherReview:[NSArray arrayWithObjects:@"#FF0000",@"#0DE506", nil]];
 * @endcode
 */
-(void)setPenColorForTeacherReview:(NSArray*)penColorArray;
/*!
 * This method set Learners Page UGC
 * @param1 pageUGC Learners All Page UGC
 * @param2 learnerID selected Learners ID
 * @code
 * [_teacherReviewController setPageUGC:studentPageUGCDictionary ForLearnerID:learningID];
 * @endcode
 */
-(void)setPageUGC:(NSDictionary*)pageUGC ForLearnerID:(NSString*)learnerID;
/*!
 * This method returns particular page numbers UGC
 * @param1 pageIdentifier Page ID
 * @code
 * NSArray *ugc = [_teacherReviewController getUGCForPageIdentifier:pageIdentifier];
 * @endcode
 */
-(NSArray*)getUGCForPageIdentifier:(NSString*)pageIdentifier;
/*!
 * This method returns particular page numbers PenToolUGC
 * @param1 pageIdentifier Page ID
 * @code
 * NSArray *ugc = [_teacherReviewController getPenToolUGCForPageIdentifier:pageIdentifier];
 * @endcode
 */
-(NSArray*)getPenToolUGCForPageIdentifier:(NSString*)pageIdentifier;
/*!
 * This method returns particular page numbers FIBUGC
 * @param1 pageIdentifier Page ID
 * @code
 * NSArray *ugc = [_teacherReviewController getFIBUGCForPageIdentifier:pageIdentifier]
 * @endcode
 */
-(NSArray*)getFIBUGCForPageIdentifier:(NSString*)pageIdentifier;
/*!
 * This method call to Update FIB data
 * @param1 fibVO fib UGC
 * @code
 * [_teacherReviewController updateFIBData:fibVO];
 * @endcode
 */
-(void)updateFIBData:(SDKFIBVO*)fibVO;
/*!
 * This method call to Update PenDrawing
 * @param1 penDrawing PenTool UGC
 * @code
 * [_teacherReviewController updatePenDrawing:drawingObject];
 * @endcode
 */
-(void)updatePenDrawing:(SDKPentoolVO*)penDrawing;
/*!
 * This method call to add new PenDrawing
 * @param1 penDrawing PenTool UGC
 * @code
 * [_teacherReviewController addPenDrawing:drawingObject]
 * @endcode
 */
-(void)addPenDrawing:(SDKPentoolVO*)penDrawing;
/*!
 * This method set Active Pages IDs
 * @param1 pages active pages
 * @code
 * [_teacherReviewController setActivePages:[NSArray arrayWithObjects:page1,page2, nil]];
 * @endcode
 */
-(void)setActivePages:(NSArray*)pages;
/*!
 * This method checks is Loaded Page Contains UGC or not
 * @code
 * [_teacherReviewController isLoadedPageContainsUGC]
 * @endcode
 */
-(BOOL)isLoadedPageContainsUGC;
/*!
 * This method call to navigate next UGC Page
 * @code
 * BOOL isLoaded = [_teacherReviewController navigateToNextPageWithUGC];
 * @endcode
 */
-(void)navigateToNextPageWithUGC;
/*!
 * This method Remove Teacher Review Controller and SubViews
 * @code
 * [_teacherReviewController remove];
 * @endcode
 */
-(void)remove;
/*!
 * This method Return Delete Item
 * @code
 *  PlayerActionBarItem *playerActionBarItem = [_teacherReviewController getDeleteItem];
 * @endcode
 */
-(PlayerActionBarItem *)getDeleteItem;
/*!
 This method call to know editing is Allowed to FIB for linkID.
 @Discussion
 When the user performs an action that would normally initiate an editing session for FIB, calls this method for linkID first to see if editing should actually proceed.
 @param1 linkID linkID to check FIB is Allowed Editing.
 **/
-(BOOL)isEditingAllowedForLinkID:(NSInteger)linkID;
/*!
 * This method returns particular FIBVO for linkID.
 * @param1 linkID linkID
 * @code
 * [_teacherReviewController getSDKFIBVOForLinkID:link.linkID]
 * @endcode
 */
-(SDKFIBVO*)getSDKFIBVOForLinkID:(NSInteger)linkID;
/*!
 * A Boolean value that determines whether user events are ignored and removed from the event queue.
 * @discussion
 * When set to NO, touch, press, and focus events intended for the teacher review views are ignored and removed from the event queue. When set to YES, events are delivered to the view normally. The default value of this property is YES.
 */
-(void)setTeacherReviewUserInteractionEnabled:(BOOL)enable;
/*!
* To Clear All FIBs.
* @discussion This method is used to clear/delete  all  FIBs,Dropdowns and EquationEditors.
* @code
* [_teacherReviewController clearAllFIBs];
* @endcode
*/
-(void)clearAllFIBs;
@end
