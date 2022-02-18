//
//  MHEReaderViewController.h
//  KitabooSDKWithReader
//
//  Created by SwapnilChavan on 01/02/22.
//  Copyright © 2022 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import "HDReaderSettingModel.h"
#import "KitabooReaderViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHEReaderViewController : UIViewController
{
    HSDBManager *_dbManager;
}

/*!
*The object that acts as the delegate of the KitabooReaderViewController
*@discussion The delegate must adopt the KitabooReaderViewControllerDelegate protocol.
*/
// Callback when we close book
-(void) onBookClose;

// Callback when we open book
-(void) onBookOpen;

// to get all unsynced UGC data when we close the book
-(void) saveUnsycnedUGCForBookID:(NSNumber *)bookID andUserID:(NSNumber *)userID withUGC:(NSDictionary *)ugcList;

// to get all data ugc related to book (synced and unsynced)
-(void) loadUgcPerPageForBookID:(NSInteger)bookID andUserID:(NSString *)userID withUGC:(NSString *)pageUGC forPageID:(NSNumber *)pageID;

-(void)saveUGCPerPageForBookID:(NSInteger)bookID forPageID:(NSInteger)pageNumber forUser:(KitabooUser *)user completion:(void(^)(void))callback;
@end

NS_ASSUME_NONNULL_END
