//
//  Collect.h
//  sensoriosclient
//
//  Created by user on 14-9-24.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <CFNetwork/CFNetwork.h>
//#import <sys/utsname.h>
//#import "IOPowerSources.h"
//#import "IOPSKeys.h"
#import "CollectionData.h"
#import "Reachability.h"
#import "Record.h"

@interface Collect : NSObject

@property(nonatomic) long dataId;
@property(nonatomic) float lightIntensity;
@property(nonatomic) float soundIntensity;
@property(nonatomic,strong) NSDate *createdTime;
@property(nonatomic) int chargeState;
@property(nonatomic) int batteryState;
@property(nonatomic) int netState;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;


-(CollectionData *)startCollect;

@end
