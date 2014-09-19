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
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Sqlite.h"
#import "PicInfo.h"

@interface RealTimeViewController : UIViewController<CLLocationManagerDelegate>
{
    float longitude;
    float latitude;
    float altitude;
}

@property (strong, atomic) ALAssetsLibrary * library;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property (nonatomic)float longitude;
@property (nonatomic)float latitude;
@property (nonatomic)float altitude;


@end
