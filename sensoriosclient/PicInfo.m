//
//  picInfo.m
//  sensorDemo
//
//  Created by user on 14-9-10.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "PicInfo.h"

@implementation PicInfo

@synthesize picID;
@synthesize picTopic;
@synthesize xDirect;
@synthesize yDirect;
@synthesize zDirect;
@synthesize longitude;
@synthesize latitude;
@synthesize altitude;
@synthesize exposure;
@synthesize focal;
@synthesize aperture;
@synthesize width;
@synthesize height;

-(id) init
{
    
    picID = @"";
    picTopic = @"";
    xDirect = 0;
    yDirect = 0;
    zDirect = 0;
    longitude = 0;
    latitude = 0;
    altitude = 0;
    exposure = 0;
    focal = 0;
    aperture = 0;
    width = 0;
    height = 0;
    
    return self;
}

@end
