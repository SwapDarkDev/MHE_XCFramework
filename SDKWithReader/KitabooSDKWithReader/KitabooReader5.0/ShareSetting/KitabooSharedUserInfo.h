//
//  SharedUserInfo.h
//
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KitabooSharedUserInfo : NSObject

@property(nonatomic,retain)NSString *fullName;
@property(nonatomic,retain)NSNumber *userId;
@property(nonatomic,assign)BOOL isShareSelected;
@property(nonatomic,assign)BOOL isReceiveSelected;
@property(nonatomic,assign)BOOL isShared;
@property(nonatomic,assign)BOOL isNoteShared;
@property(nonatomic,assign)BOOL isReceived;

- (void)deselectShare;
- (void)deselectReceive;
- (void)setShared;
- (void)setReceived;
- (BOOL)checkWhetherUserIsPresentInList:(NSArray *)array;
@end
