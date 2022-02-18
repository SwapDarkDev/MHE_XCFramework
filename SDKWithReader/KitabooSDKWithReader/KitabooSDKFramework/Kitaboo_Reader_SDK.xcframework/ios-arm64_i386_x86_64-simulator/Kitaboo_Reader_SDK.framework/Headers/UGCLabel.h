//
//  UGCLabel.h
//  Kitaboo
//
//  Created by Gaurav Bhatia on 07/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/** An Object that manage a Label for Note icon.
 @discussion The UGCLabel class defines a label for notes(Sticky Note, Contextual Note, Multi Note).
 @superclass SuperClass : UILabel
 */
@interface UGCLabel : UILabel
/** ugcUUID is UCG Unique ID*/
@property (nonatomic, strong) NSString *ugcUUID;
@property (nonatomic, assign) BOOL isNote;
@property (nonatomic, assign) BOOL isSticky;
@property (nonatomic, assign) BOOL isMultiNote;
@property (nonatomic, assign) BOOL isTeacherReviewNote;
@property (nonatomic, assign) NSInteger startWordID;
@property (nonatomic, assign) NSInteger endWorkID;

- (id)init;
- (id)initWithFrame:(CGRect)frame;

/** Used to unhide the label.*/
- (void)showView;
@end
