//
//  MultiLinkController.h
//  KItabooSDK
//
//  Created by amol shelke on 12/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
@protocol MultiLinkControllerDelegate<NSObject>
/**
 * Will be called when select Link
**/
-(void)didSelectLinkVo:(KFLinkVO*)linkVo;
@end

@interface MultiLinkController : UITableViewController
/**
 * Setting/Getter for delegate (callback listener)
 */
@property (nonatomic,weak)id<MultiLinkControllerDelegate>delegate;
/**
 * Initiate MultiLinkController
 * @param rect Frame for MultiLinkController
 * @param multiLinkArray linksArray for MultiLink
 **/
-(id)initWithFrame:(CGRect)rect WithMultiLinkArray:(NSArray*)multiLinkArray;
@end
