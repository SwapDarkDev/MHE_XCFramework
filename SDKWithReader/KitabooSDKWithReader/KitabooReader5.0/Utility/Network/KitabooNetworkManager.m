//
//  NetworkManager.m
//  Kitaboo
//
//  Created by Hariprasad on 30/04/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import "KitabooNetworkManager.h"

@implementation KitabooNetworkManager

+ (instancetype)getInstance
{
    static KitabooNetworkManager *networkManager=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      networkManager = [[self alloc] init];
                  });
    
    return networkManager;
}

- (id)init
{
    self = [super init];
    if(self) {
        _internetReachability = [Reachability reachabilityForInternetConnection];
        [_internetReachability startNotifier];
    }
    return self;
}

-(NetworkStatus)getNetworkStatus
{
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    return netStatus;
}

- (BOOL)isInternetAvailable
{
    switch ([self getNetworkStatus])
    {
        case NotReachable:
            return NO;
            
        case ReachableViaWWAN:
            return ![self.internetReachability connectionRequired];
            
        case ReachableViaWiFi:
            return YES;
    }
}





- (void)dealloc
{
    [_internetReachability stopNotifier];
    _internetReachability = nil;
}
@end
