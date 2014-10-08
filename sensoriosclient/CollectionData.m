//
//  CollectionData.m
//  sensor
//
//  Created by jack on 14-9-16.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "CollectionData.h"

@implementation CollectionData

@synthesize dataId;
@synthesize lightIntensity;
@synthesize soundIntensity;
@synthesize createdTime;
@synthesize chargeState;
@synthesize batteryState;
@synthesize netState;
@synthesize longitude;
@synthesize latitude;
@synthesize altitude;

-(id) init
{
    dataId = 0;
    lightIntensity = 0;
    soundIntensity = 0;
    createdTime = 0;
    chargeState = 0;
    batteryState = 0;
    netState = 0;
    longitude = 0;
    latitude = 0;
    altitude = 0;
    
    return self;
}

-(NSDictionary *)toDictionary{
    NSMutableDictionary *collectionDataDictionary = [[NSMutableDictionary alloc]init];
    [collectionDataDictionary setObject:[NSNumber numberWithInt:self.createdTime] forKey:@"Time"];
    [collectionDataDictionary setValue:@"0.0" forKey:@"Light"];
    [collectionDataDictionary setValue:@"1.0" forKey:@"Noise"];
    [collectionDataDictionary setValue:@"1" forKey:@"BatteryState"];
    [collectionDataDictionary setValue:@"1" forKey:@"ChargeState"];
    [collectionDataDictionary setValue:@"1" forKey:@"NetState"];
    [collectionDataDictionary setValue:@"39.961445" forKey:@"Latitude"];
    [collectionDataDictionary setValue:@"116.3498466666667" forKey:@"Longitude"];
    return collectionDataDictionary;
}

@end
