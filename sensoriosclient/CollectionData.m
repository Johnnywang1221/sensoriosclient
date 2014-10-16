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

-(NSDictionary *)toDictionaryWithStringValue{
    NSMutableDictionary *collectionDataDictionary = [[NSMutableDictionary alloc]init];
    [collectionDataDictionary setObject:[NSNumber numberWithInt:self.createdTime].description forKey:@"Time"];
    [collectionDataDictionary setObject:[NSNumber numberWithFloat:self.lightIntensity].description forKey:@"Light"];
    [collectionDataDictionary setObject:[NSNumber numberWithFloat:self.soundIntensity].description forKey:@"Noise"];
    [collectionDataDictionary setObject:[NSNumber numberWithInt:self.batteryState].description forKey:@"BatteryState"];
    [collectionDataDictionary setObject:[NSNumber numberWithInt:self.chargeState].description forKey:@"ChargeState"];
    [collectionDataDictionary setObject:[NSNumber numberWithInt:self.netState].description forKey:@"NetState"];
    [collectionDataDictionary setObject:[NSNumber numberWithFloat:self.latitude].description forKey:@"Latitude"];
    [collectionDataDictionary setObject:[NSNumber numberWithFloat:self.longitude].description forKey:@"Longitude"];
    //[collectionDataDictionary setObject:@"testValue" forKey:@"testKey"];
    return collectionDataDictionary;
}

@end
