//
//  SharedUserInfo.m
//  Kitaboo
//
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "SharedUserInfo.h"

@implementation SharedUserInfo

- (void)deselectShare
{
    _isShareSelected = NO;
}

- (void)deselectReceive
{
    _isReceiveSelected = NO;
}

- (void)setShared
{
    self.isShared = self.isShareSelected;
}

- (void)setReceived
{
    self.isReceived = self.isReceiveSelected;
}

- (BOOL)checkWhetherUserIsPresentInList:(NSArray *)array
{
    BOOL check = NO;
    
    for (NSNumber *num in array)
    {
        if([_userId isEqualToNumber:num])
        {
            check = YES;
            break;
        }
    }
    return check;
}

@end
