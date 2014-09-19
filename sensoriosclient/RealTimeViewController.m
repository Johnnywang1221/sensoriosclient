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
@synthesize longitude;
@synthesize latitude;
@synthesize altitude;

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
        
        if([CLLocationManager locationServicesEnabled]) {
            locationManager = [[CLLocationManager alloc] init];
            
            locationManager.delegate = self;
            [locationManager setDistanceFilter:kCLDistanceFilterNone];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            
        }else {
            NSLog(@"Unable to locate!");
            //提示用户无法进行定位操作
        }
        // 开始定位
        [locationManager startUpdatingLocation];

        
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
    
    //元数据
    NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSMutableDictionary *metadata=[NSMutableDictionary dictionaryWithDictionary:dict];
    NSLog(@"metadata==%@",metadata);
    
    //EXIF数据
    NSMutableDictionary *EXIFDictionary =[[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    
    //NSLog(@"EXIFDictionary==%@",EXIFDictionary);
    //NSLog(@"DateTimeDigitized==%@",[EXIFDictionary objectForKey:@"DateTimeDigitized"]);
    
    NSString *tempTimeChuo = [EXIFDictionary objectForKey:@"DateTimeDigitized"];
    
    PicInfo *thisPicInfo = [[PicInfo alloc]init];
    thisPicInfo.picID = tempTimeChuo;
    NSLog(@"\npicID==%@", thisPicInfo.picID);
    thisPicInfo.picTopic = @"topic 1";//modify in the future
    thisPicInfo.xDirect = 0;
    thisPicInfo.yDirect = 0;
    thisPicInfo.zDirect = 0;
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
