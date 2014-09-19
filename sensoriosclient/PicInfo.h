//
//  picInfo.h
//  sensorDemo
//
//  Created by user on 14-9-10.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//
//define the local picture's information

#import <Foundation/Foundation.h>

@interface PicInfo : NSObject
{
    NSString *picID;
    NSString *picTopic;
    float xDirect;
    float yDirect;
    float zDirect;
    float longitude;
    float latitude;
    float altitude;
    int exposure;
    float focal;
    float aperture;
    int width;
    int height;
    
}

@property (nonatomic, retain) NSString *picID;
@property (nonatomic, retain) NSString *picTopic;
@property (nonatomic) float xDirect;
@property (nonatomic) float yDirect;
@property (nonatomic) float zDirect;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic) float altitude;
@property (nonatomic) int exposure;
@property (nonatomic) float focal;
@property (nonatomic) float aperture;
@property (nonatomic) int width;
@property (nonatomic) int height;

@end
