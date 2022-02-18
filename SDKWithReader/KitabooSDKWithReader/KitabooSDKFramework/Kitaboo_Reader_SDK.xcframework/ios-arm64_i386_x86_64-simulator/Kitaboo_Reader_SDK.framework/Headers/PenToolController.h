//
//  PenToolController.m
//  Kitaboo
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "PenDrawingViewConstants.h"
#import "UGC.h"

/*!
 @protocol PenToolControllerDelegate
 @brief The delegate of a PenToolController object must adopt the PenToolControllerDelegate protocol.
 @discussion PenToolControllerDelegate Protocol used to handle all the callbacks of PenToolController Class. All delegate methods are optional.The PenToolControllerDelegate protocol defines methods that allow user to perform actions when any drawing is created, updated or deleted by the user. Also when undoable status of pentool gets updated.
 
 When configuring the PenToolController object, assign your delegate object to its delegate property.
 */
@protocol PenToolControllerDelegate <NSObject>
@optional
/*!
 This method gets called when user create any drawing.
 @discussion When user create any new pen drawing then this method gets called. User can save drawing object in database or can update view.
 @param1 drawingObject Object of SDKPentoolVO
 */
- (void)didCreatePenDrawing:(SDKPentoolVO *)drawingObject;

/*!
 This method gets called when user delete/update any drawing.
 @discussion When user delete any drawing object or redo then this method gets called. User can update drawing object in database and remove/redraw(redo) drawing and update view.
 @param1 drawingObject Object of SDKPentoolVO
 */
- (void)didUpdatePenDrawing:(SDKPentoolVO *)drawingObject;

/*!
 This method gets called when user undo status is changed.
 @discussion further undo can be done or not, And to know this Use:isUndoable method of PenToolController.
 */
-(void)didChangeUndoableStatus;
/*!
 This method gets called when user select or unselect any drawings.
 @discussion When user select, unselecct or delete pen drawings on page then this method gets called. User can update pen drawing object status when select or unselect it or can change pentool item  property like if any object is deleted then user can enable undo button if user press on undo button then can disable it.
 */
-(void)didUpdatedSelectedPenDrawing;

@end

/** An Object that manage a Pentool.
 @discussion The PenToolController class is responsible for handling customisation of a pen such as pen color, pen thickness etc. It also handles action for pentool elements.
 @superclass SuperClass : NSObject
 */
@interface PenToolController : NSObject

/*!
 To set the Drawing Mode.
 @discussion Support Mode "DRAWING_MODE_NORMAL".
 @code
  [penToolController setDrawingMode:DRAWING_MODE_NORMAL];
 @endcode
 */
@property (assign, nonatomic) DRAWING_MODE mode;

/*!
 The object that acts as the delegate of the PenToolController.
 @discussion The delegate must adopt the PenToolControllerDelegate protocol. The delegate is not retained.
 @code
  penToolController.delegate = self
 @endcode
 */
@property (weak, nonatomic) id<PenToolControllerDelegate> delegate;

@property (nonatomic) BOOL hasClassAssociation;

/*!
 This method is use to set the drawing canvas, where user will draw the pen drawings.
 @discussion User will receive canvas from RendererViewController Object by calling getPenDrawingCanvas (Will Return all active canvas). User can set canvas to drawing view.
 @param1 canvasArray Pass array of Canvas on which user will draw the pen drawings.
 @code
  [penToolController setPenDrawingCanvas:[rendererView getPenDrawingCanvas]];
 @endcode
 */
-(void)setPenDrawingCanvas:(NSArray*)canvasArray;

/*!
 To set Pen Stroke thickness.
 @discussion User can update pen thickenss of canvas.
 @param1 thickness Required thickness of PenStroke.
 @code
  [penToolController setPenStrokeThickness:1];
 @endcode
 */
-(void)setPenStrokeThickness:(float)thickness;

/*!
 To get Pen Stroke thickness.
 @discussion User can set pen thickness by getting pen thickness from pentoolcontroller.
 @return float value thickness of pen stroke.
 @code
 [penToolController setPenStrokeThickness:penToolController.getPenStrokeThickness];
 @endcode
 */
-(float)getPenStrokeThickness;

/*!
 To set Pen color.
 @discussion User can set pen color depending on his/her need like can draw two pendrawing with two diiferent color one is red another is yellow.
 @param1 color is String value, Required color of Pen;
 @code
 [penToolController setPenColor:@RedColor];
 @endcode
 */
-(void)setPenColor:(NSString*)color;

/*!
 To get Pen color.
 @discussion User can set pen color by getting pen color from pentoolcontroller.
 @return string value color of pen.
 @code
 [penToolController setPenColor:penToolController.getPenColor];
 @endcode
 */
-(NSString*)getPenColor;

/*!
 To get Pen Mode.
 @discussion User can set pen penmode by getting pen mode from pentoolcontroller.
 @return penMode.
 @code
 [penToolController getPenMode];
 @endcode
 */
-(PenMode)getPenMode;

/*!
 To set Pen Mode.
 @discussion Supported Mode Are PenModeDrawing/PenModeSelection. PenModeDrawing for drawing on canvas and PenModeSelection for deleting any drawing from canvas.
 @param1 penMode Required Mode for Pen tool.
 @code
 [penToolController setPenMode:PenModeDrawing];
 @endcode
 */
-(void)setPenMode:(PenMode)penMode;

/*!
 To set Pen drawingMode.
 @discussion Currently only supported Mode is DRAWING_MODE_NORMAL.
 @param1 drawingMode Required Mode for Pen tool.
 @code
 [penToolController setDrawingMode:DRAWING_MODE_NORMAL];
 @endcode
 */
-(void)setDrawingMode:(DRAWING_MODE)drawingMode;

/*!
 To undo last drawing.
 @discussion User can draw pendrawing which was deleted and update undo array.
 @code
 [penToolController undoDrawing];
 @endcode
 */
-(void)undoDrawing;

/*!
  To know,if undo can be done or not.
 @discussion User can update undo button status depending on isUndoable status.
 @return BOOL value true/false.
 @code
 [penToolController isUndoable];
 @endcode
*/
-(BOOL)isUndoable;

/*!
 To know if any drawing is selected in Erase mode.
 @discussion User can send true if any drawing is selected or can send false if no drawing is selected.
 @return BOOL value true/false.
 @code
 [penToolController isAnyDrawingSelected]
 @endcode
 */
-(BOOL)isAnyDrawingSelected;

/*!
 To Delete the selected drawings.
 @discussion User can delete selected drawing objcet from array and update drawings on page/canvas.
 @code
 [penToolController deleteSelectedDrawing];
 @endcode
 */
- (void)deleteSelectedDrawing;

/*!
 To enable delete on selection.
 @discussion Enabling this option will delete the pentool drawing, once it is selected/touched, and will not show any selctions.
 @param1 enabled bool value by enabling(true/YES) if any pen drawing get deleted once it is selected and by disabling(flase/NO) if any pen drawing get selected or shows selection around it and not directly deleted.
 @code
 [penToolController setDeleteOnSelectionEnabled:YES];
 @endcode
 */
-(void)setDeleteOnSelectionEnabled:(BOOL)enabled;

/*!
 To Delete All drawings available on active page.
 @discussion To Delete All drawings available on active page except submited drawings. User can remove/delete all pendrawings from array and update drawings on page/canvas.
 @code
 [penToolController deleteActivePagePenDrawings];
 @endcode
 */
-(void)deleteActivePagePenDrawings;
@end
