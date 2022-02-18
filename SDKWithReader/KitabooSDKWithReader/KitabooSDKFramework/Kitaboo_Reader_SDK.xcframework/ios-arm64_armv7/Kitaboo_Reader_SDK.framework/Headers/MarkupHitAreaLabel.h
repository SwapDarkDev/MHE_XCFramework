//
//  MarkupHitAreaLabel.h
//  KItabooSDK
//
//  Created by Amol on 15/01/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkupView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MarkupHitAreaLabel : UILabel
/*!
 * Setter/Getter for pageID where markup is being added.
 * @code
 * [markupHitAreaLabel setpageID:pageID];
 * @endcode
 */
@property (nonatomic) NSInteger pageID;

/*!
 * Setter/Getter for linkID.
 * @code
 * [markupHitAreaLabel setlinkID:linkID];
 * @endcode
 */
@property (nonatomic) NSInteger linkID;
/*!
 * Setter/Getter for MarkupView.
 * @code
 * [markupHitAreaLabel seticonView:iconView];
 * @endcode
 */
@property (nonatomic, strong)MarkupView *iconView;
@end

NS_ASSUME_NONNULL_END
