//
//  RealTimeViewController.h
//  sensor
//
//  Created by jack on 14-9-1.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Sqlite.h"
#import "PicInfo.h"
#import "Collect.h"

@interface RealTimeViewController : UIViewController<CLLocationManagerDelegate>
{
    float longitude;
    float latitude;
    float altitude;
    
    float pitch;
    float yaw;
    float roll;
    
    float xDirect;
    float yDirect;
    float zDirect;
    
}

@property (strong, atomic) ALAssetsLibrary * library;
@property (nonatomic,strong)CLLocationManager* locationManager;
@property (nonatomic, strong)CMMotionManager *motionManager;
@property (nonatomic)float longitude;
@property (nonatomic)float latitude;
@property (nonatomic)float altitude;
@property (nonatomic)float pitch;
@property (nonatomic)float yaw;
@property (nonatomic)float roll;
@property (nonatomic)float xDirect;
@property (nonatomic)float yDirect;
@property (nonatomic)float zDirect;


@end
