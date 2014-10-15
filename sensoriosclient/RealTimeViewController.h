//
//  RealTimeViewController.h
//  sensor
//
//  Created by jack on 14-9-1.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomImagePickerController.h"






@interface RealTimeViewController : UIViewController<UIImagePickerControllerDelegate,CustomImagePickerControllerDelegate,CLLocationManagerDelegate>
{
    
}

//@property (nonatomic, strong)UIImagePickerController *picker;

@end
