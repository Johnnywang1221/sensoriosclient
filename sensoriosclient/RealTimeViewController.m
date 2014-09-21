//
//  RealTimeViewController.m
//  sensor
//
//  Created by jack on 14-9-1.
//  Written by Vivian on 14-9-2
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "RealTimeViewController.h"

@interface RealTimeViewController ()

@end

@implementation RealTimeViewController

@synthesize library;
@synthesize locationManager;
@synthesize motionManager;
@synthesize longitude;
@synthesize latitude;
@synthesize altitude;
@synthesize accelerometerX;
@synthesize accelerometerY;
@synthesize accelerometerZ;
@synthesize magnetometerX;
@synthesize magnetometerY;
@synthesize magnetometerZ;
@synthesize xDirect;
@synthesize yDirect;
@synthesize zDirect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"实景";
        //set navigationBarItem
        UIBarButtonItem *takePhoto = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(openCamera)];
        self.navigationItem.rightBarButtonItem = takePhoto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *items = [NSArray arrayWithObjects:@"实景", @"专题", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
    self.navigationItem.titleView = segmentedControl;
    self.library = [[ALAssetsLibrary alloc] init];
    
    if([CLLocationManager locationServicesEnabled]) {
        if(!locationManager){
            locationManager = [[CLLocationManager alloc] init];
            
            locationManager.delegate = self;
            [locationManager setDistanceFilter:kCLDistanceFilterNone];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
    }else {
        NSLog(@"Unable to locate!");
        //提示用户无法进行定位操作
    }
    
    motionManager=[[CMMotionManager alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openCamera
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"Open Camera");
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;  //是否可编辑
        //摄像头
        //CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.5,1.5);
        //picker.cameraViewTransform = cameraTransform;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
        
        // 开始定位
        [locationManager startUpdatingLocation];
        
        
        //this is push style
        /* [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
         
         accelerometerX = accelerometerData.acceleration.x;
         accelerometerY = accelerometerData.acceleration.y;
         accelerometerY = accelerometerData.acceleration.z;
         
         }];*/
        
        //this is pull style
        [motionManager startAccelerometerUpdates];
        motionManager.accelerometerUpdateInterval = 1/60.0;
        
        [motionManager startMagnetometerUpdates];
        motionManager.magnetometerUpdateInterval = 1/60.0;
        
        [motionManager startDeviceMotionUpdates];
        motionManager.deviceMotionUpdateInterval = 1/60.0;
        
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [library saveImage:image toAlbum:@"Sensor Client" withCompletionBlock:^(NSError *error) {
        
        if (error!=nil) {
            
            NSLog(@"Big error: %@", [error description]);
            
        }
        
    }];
    
    CMAccelerometerData *data1 = motionManager.accelerometerData;
    accelerometerX = data1.acceleration.x;
    accelerometerY = data1.acceleration.y;
    accelerometerZ = data1.acceleration.z;
    NSLog(@"Accelerometer:\nx==%f\ny==%f\nz==%f", accelerometerX, accelerometerY, accelerometerZ);
    [motionManager stopAccelerometerUpdates];
    
    CMMagnetometerData *data2 = motionManager.magnetometerData;
    magnetometerX = data2.magneticField.x;
    magnetometerY = data2.magneticField.y;
    magnetometerZ = data2.magneticField.z;
    NSLog(@"Magnetometer:\nx==%f\ny==%f\nz==%f", magnetometerX, magnetometerY, magnetometerZ);
    [motionManager stopMagnetometerUpdates];
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    float yaw = currentAttitude.yaw*(180/M_PI);
    float roll = currentAttitude.roll*(180/M_PI);
    float pitch = currentAttitude.pitch*(180/M_PI);
    NSLog(@"Device Motion:\nx==%f\ny==%f\nz==%f", pitch, yaw, roll);
    
    //元数据
    NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSMutableDictionary *metadata=[NSMutableDictionary dictionaryWithDictionary:dict];
    //NSLog(@"metadata==%@",metadata);
    
    //EXIF数据
    NSMutableDictionary *EXIFDictionary =[[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    
    //NSLog(@"EXIFDictionary==%@",EXIFDictionary);
    //NSLog(@"DateTimeDigitized==%@",[EXIFDictionary objectForKey:@"DateTimeDigitized"]);
    
    NSString *tempTimeChuo = [EXIFDictionary objectForKey:@"DateTimeDigitized"];
    
    PicInfo *thisPicInfo = [[PicInfo alloc]init];
    thisPicInfo.picID = tempTimeChuo;
    NSLog(@"\npicID==%@", thisPicInfo.picID);
    thisPicInfo.picTopic = @"topic 1";//modify in the future
    
    if([self getOrientation]){
        thisPicInfo.xDirect = -self.xDirect*(180/M_PI);//android 0~360 有大问题！！！
        thisPicInfo.yDirect = self.yDirect*(180/M_PI)*(-1);//android -180~180
        //thisPicInfo.zDirect = self.zDirect*(180/M_PI) -360;//android -90~90
        thisPicInfo.zDirect = roll;
    }else{
        thisPicInfo.xDirect = 0;
        thisPicInfo.yDirect = 0;
        thisPicInfo.zDirect = 0;
    }
    
    NSLog(@"xDirect==%f\nyDirect==%f\nzDirect==%f", thisPicInfo.xDirect, thisPicInfo.yDirect, thisPicInfo.zDirect);
    thisPicInfo.longitude = self.longitude;
    thisPicInfo.latitude = self.latitude;
    thisPicInfo.altitude = self.altitude;
    NSLog(@"longitude==%f\natitude==%f\naltitude==%f", thisPicInfo.longitude, thisPicInfo.latitude, thisPicInfo.altitude);
    NSString *tempExposure = [EXIFDictionary objectForKey:@"ExposureMode"];
    thisPicInfo.exposure = [tempExposure intValue];
    NSString *tempFocal =[EXIFDictionary objectForKey:@"FocalLength"];
    thisPicInfo.focal = [tempFocal floatValue];
    NSString *tempAperture =[EXIFDictionary objectForKey:@"ApertureValue"];
    thisPicInfo.aperture = [tempAperture floatValue];
    NSLog(@"\nexposure==%d\nfocal==%f\naperture==%f", thisPicInfo.exposure, thisPicInfo.focal, thisPicInfo.aperture);
    thisPicInfo.width = image.size.width;
    thisPicInfo.height = image.size.height;
    NSLog(@"\nwidth==%d\nheight==%d", thisPicInfo.width, thisPicInfo.height);
    
    Sqlite *sqlite = [[Sqlite alloc]init];
    [sqlite insertList:thisPicInfo];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.latitude =  coor.latitude;
    self.longitude = coor.longitude;
    self.altitude = currentLocation.altitude;
    
    [locationManager stopUpdatingLocation];
    
    NSLog(@"Locate success!");
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (BOOL)getOrientation
{
    accelerometerX = accelerometerX*9.81;
    accelerometerY = accelerometerY*9.81;
    accelerometerZ = accelerometerZ*9.81;
    
    float Hx = magnetometerY*accelerometerZ - magnetometerZ*accelerometerY;
    float Hy = magnetometerZ*accelerometerX - magnetometerX*accelerometerZ;
    float Hz = magnetometerX*accelerometerY - magnetometerY*accelerometerX;
    float normH = sqrtf(Hx*Hx + Hy*Hy + Hz*Hz);
    if(normH < 0.1f){
        // device is close to free fall (or in space?), or close to
        // magnetic north pole. Typical values are  > 100.
        return FALSE;
    }
    float invH = 1.0f / normH;
    Hx *= invH;
    Hy *= invH;
    Hz *= invH;
    float invA = 1.0f / sqrtf(accelerometerX*accelerometerX + accelerometerY*accelerometerY + accelerometerZ*accelerometerZ);
    accelerometerX *= invA;
    accelerometerY *= invA;
    accelerometerZ *= invA;
    float Mx = accelerometerY*Hz - accelerometerZ*Hy;
    float My = accelerometerZ*Hx - accelerometerX*Hz;;
    float Mz = accelerometerX*Hy - accelerometerY*Hx;
    float R0 = Hx, R1 = Hy, R2 = Hz;
    float R3 = Mx, R4 = My, R5 = Mz;
    float R6 = accelerometerX, R7 = accelerometerY, R8 = accelerometerZ;
    
    xDirect = atan2f(R1, R4);
    yDirect = asinf(-R7);
    zDirect = atan2f(-R6, R8);
    
    return TRUE;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
