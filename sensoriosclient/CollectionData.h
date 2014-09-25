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
@property(nonatomic) float lightIntensity;
@property(nonatomic) float soundIntensity;
@property(nonatomic) int createdTime;//seconds after 1970
@property(nonatomic) int chargeState;
@property(nonatomic) int batteryState;
@property(nonatomic) int netState;
@property(nonatomic) float longitude;
@property(nonatomic) float latitude;
@property(nonatomic) float altitude;


@end
