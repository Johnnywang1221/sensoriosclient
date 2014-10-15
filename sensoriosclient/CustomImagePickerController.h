//
//  CustomImagePickerController.h
//  ZBImagePickerController
//
//  Created by Kevin Zhang on 13-9-5.
//  Copyright (c) 2013年 zimbean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import<QuartzCore/QuartzCore.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Sqlite.h"
#import "PicInfo.h"
#import "Collect.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
typedef void(^SaveImageCompletion)(NSError* error);

@protocol CustomImagePickerControllerDelegate;

@interface CustomImagePickerController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
//    CLLocationManager* locationManager;
}

@property (nonatomic,unsafe_unretained)id<CustomImagePickerControllerDelegate>customDelegate;

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


@protocol CustomImagePickerControllerDelegate <NSObject>

- (void)cancelCamera;

@end