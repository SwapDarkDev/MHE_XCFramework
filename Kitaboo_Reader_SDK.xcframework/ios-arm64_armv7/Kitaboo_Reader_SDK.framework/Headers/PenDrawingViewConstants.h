//
//  PenDrawingViewConstants.h
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#ifndef PenDrawingViewConstants_h
#define PenDrawingViewConstants_h

/*!
 DRAWING_MODE is mode of drawing view,
 Whether it is DRAWING_MODE_NORMAL is used to draw any pen drawings, DRAWING_MODE_REVIEW.
 */
typedef enum { DRAWING_MODE_NORMAL, DRAWING_MODE_REVIEW }DRAWING_MODE;

/*!
 PenMode is used to set the Type of Mode for PenToolController,
 */
typedef enum {
    ///To Enable Pen Drawing, When this mode is set, Any touch on the active canvas will result in drawing on pen based on the selected pen configuation (Color,Thickness)
    PenModeDrawing,
    //To Enabled Selection of existing Pen drawing on active canvas.
    PenModeSelection,
    // This should be set when we need to enable Teacher Review, so Teacher can review student submitions, This is same as PenModeDrawing, but adds some additional configuation needed in Teacher Review mode.
    PenModeMarkupTap
    
}PenMode;


#endif
