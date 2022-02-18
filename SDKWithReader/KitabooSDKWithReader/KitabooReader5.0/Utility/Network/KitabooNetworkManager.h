//
//  NetworkManager.h
//  Kitaboo
//
//  Created by Hariprasad on 30/04/14.
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface KitabooNetworkManager : NSObject
@property (nonatomic,strong) Reachability *internetReachability;
+(instancetype)getInstance;
-(BOOL)isInternetAvailable;
-(NetworkStatus)getNetworkStatus;

@end
