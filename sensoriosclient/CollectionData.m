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

@end
