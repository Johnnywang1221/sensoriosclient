//
//  CustomImagePickerController.m
//  ZBImagePickerController
//
//  Created by Kevin Zhang on 13-9-5.
//  Copyright (c) 2013年 zimbean. All rights reserved.
//

#import "CustomImagePickerController.h"

@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController

@synthesize customDelegate;
@synthesize library;
@synthesize locationManager;
@synthesize motionManager;
@synthesize longitude;
@synthesize latitude;
@synthesize altitude;
@synthesize pitch;
@synthesize yaw;
@synthesize roll;
@synthesize xDirect;
@synthesize yDirect;
@synthesize zDirect;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
	// Do any additional setup after loading the view.
    
    self.library = [[ALAssetsLibrary alloc] init];
    
    if([CLLocationManager locationServicesEnabled]) {
        if(!locationManager){
            locationManager = [[CLLocationManager alloc] init];
            
            locationManager.delegate = self;
            [locationManager setDistanceFilter:kCLDistanceFilterNone];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
//        NSLog(@"start!!!!");
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
//            NSLog(@"IOS8!!!!!");
        }
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
    }else {
        NSLog(@"Unable to locate!");
        //提示用户无法进行定位操作
    }
        
    motionManager=[[CMMotionManager alloc]init];
    [motionManager startDeviceMotionUpdates];
    
}

#pragma mark /////////////
- (UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc]) {
        return aView;
    }
    
    for (int i = 0; i < [aView subviews].count; i++) {
        UIView *subview = [aView.subviews objectAtIndex:i];
        subview = [self findView:subview withName:name];
//        NSLog(@"%@", subview.description);
        if(subview){
//            NSLog(@"find!!");
            return subview;
        }
    }
    
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.75,1.75);
        self.cameraViewTransform = cameraTransform;
//        [self setShowsCameraControls:NO];
        
        UIButton *cameraButton=[self findView:viewController.view withName:@"CAMShutterButton"];
        [cameraButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        
        //Get Bottom Bar
        UIView *bottomBar=[self findView:viewController.view  withName:@"PLCropOverlayPreviewBottomBar"];
//        NSLog(@"third");
        
        //Get Button 0
        UIButton *retakeButton=[bottomBar.subviews objectAtIndex:0];
//        [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];
        [retakeButton addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
            
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Camera" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)takePicture{
    
    NSLog(@"Take Picture");
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    yaw = currentAttitude.yaw*(180/M_PI);
    roll = currentAttitude.roll*(180/M_PI);//顺时针 -180~180
    pitch = currentAttitude.pitch*(180/M_PI);//水平面以上为正 -90~90
    //NSLog(@"Device Motion:\nx==%f\ny==%f\nz==%f", pitch, yaw, roll);
    [motionManager stopDeviceMotionUpdates];
    
    self.xDirect = locationManager.heading.trueHeading;
//    NSLog(@"Heading==%f", self.xDirect);
    [locationManager stopUpdatingHeading];
    
}

-(void)retake
{
    NSLog(@"Retake!");
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    [motionManager startDeviceMotionUpdates];
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Get Picture");
    [self dismissViewControllerAnimated:NO completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //元数据
    NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSMutableDictionary *metadata=[NSMutableDictionary dictionaryWithDictionary:dict];
    //NSLog(@"metadata==%@",metadata);
    
    //EXIF数据
    NSMutableDictionary *EXIFDictionary =[[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    
    NSString *tempTime = [EXIFDictionary objectForKey:@"DateTimeDigitized"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSDate *time = [formatter dateFromString:tempTime];
    
    PicInfo *thisPicInfo = [[PicInfo alloc]init];
    thisPicInfo.picID = [time timeIntervalSince1970];
//    NSLog(@"\npicID==%d", thisPicInfo.picID);
    thisPicInfo.picTopic = @"topic 1";//modify in the future
    
    thisPicInfo.xDirect = self.xDirect;//android 0~360
    thisPicInfo.yDirect = pitch * (-1);//android -180~180, 顺时针
    thisPicInfo.zDirect = roll;//android -90~90，顺时针
    
//    NSLog(@"xDirect==%f\nyDirect==%f\nzDirect==%f", thisPicInfo.xDirect, thisPicInfo.yDirect, thisPicInfo.zDirect);
    thisPicInfo.longitude = self.longitude;
    thisPicInfo.latitude = self.latitude;
    thisPicInfo.altitude = self.altitude;
//    NSLog(@"longitude==%f\natitude==%f\naltitude==%f", thisPicInfo.longitude, thisPicInfo.latitude, thisPicInfo.altitude);
    NSString *tempExposure = [EXIFDictionary objectForKey:@"ExposureMode"];
    thisPicInfo.exposure = [tempExposure intValue];
    NSString *tempFocal =[EXIFDictionary objectForKey:@"FocalLength"];
    thisPicInfo.focal = [tempFocal floatValue];
    NSString *tempAperture =[EXIFDictionary objectForKey:@"ApertureValue"];
    thisPicInfo.aperture = [tempAperture floatValue];
//    NSLog(@"\nexposure==%d\nfocal==%f\naperture==%f", thisPicInfo.exposure, thisPicInfo.focal, thisPicInfo.aperture);
    thisPicInfo.width = image.size.width;
    thisPicInfo.height = image.size.height;
//    NSLog(@"\nwidth==%d\nheight==%d", thisPicInfo.width, thisPicInfo.height);
    
    Sqlite *sqlite = [[Sqlite alloc]init];
    [sqlite insertPicList:thisPicInfo];
    
    Collect *collection = [[Collect alloc]init];
    CollectionData *collectData = [[CollectionData alloc]init];
    collectData = [collection startCollect];
    
    collectData.createdTime = thisPicInfo.picID;
    collectData.longitude = self.longitude;
    collectData.latitude = self.latitude;
    collectData.altitude = self.altitude;
//    NSLog(@"COLLECT\nlongitude==%f\nlatitude==%f\naltitude==%f", collectData.longitude, collectData.latitude, collectData.altitude);
    
    [sqlite insertDataList:collectData];
    
    //Write new tiff infomation to metadata
    NSString *json = [self getInfo:thisPicInfo];
    NSMutableDictionary *TIFFDictionary =[metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    [TIFFDictionary setValue:json forKey:(NSString*)kCGImagePropertyTIFFMake];
    [metadata setValue:TIFFDictionary forKey:(NSString*)kCGImagePropertyTIFFDictionary];
//    NSLog(@"metadata==%@",metadata);
    
    [library saveWriteImage:image toAlbum:@"Sensor" withMetadata:metadata withID:thisPicInfo.picID withCompletionBlock:^(NSError *error){
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library");
        }
    }];

}

-(NSString *)getInfo:(PicInfo *)pic
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *info = [NSString stringWithFormat:@"{\"username\":\"%@\",\"Model\":\"%@\",\"Longitude\":%f,\"Latitude\":%f,\"Altitude\":%f,\"Orientation_X\":%f,\"Orientation_Y\":%f,\"Orientation_Z\":%f}", @"user", [defaults objectForKey:@"MODEL"], pic.longitude, pic.latitude, pic.altitude, pic.xDirect, pic.yDirect, pic.zDirect];
    //NSLog(@"%@",info);
    
    return info;
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
//    NSLog(@"start locate!");
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.latitude =  coor.latitude;
    self.longitude = coor.longitude;
    self.altitude = currentLocation.altitude;
    [locationManager stopUpdatingLocation];
//    NSLog(@"Locate success!");
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
