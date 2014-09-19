//
//  CollectionData.h
//  sensor
//
//  Created by jack on 14-9-16.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionData : NSObject
@property(nonatomic) long dataId;
@property(nonatomic) double lightIntensity;
@property(nonatomic) double soundIntensity;
@property(nonatomic,strong) NSDate *createdTime;
@property(nonatomic) int chargeState;
@property(nonatomic) int batteryState;
@property(nonatomic) int netState;
@property(nonatomic) double longitude;
@property(nonatomic) double latitude;
@property(nonatomic) double altitude;


@end
