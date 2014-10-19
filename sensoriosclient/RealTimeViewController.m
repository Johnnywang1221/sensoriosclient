//
//  RealTimeViewController.m
//  sensor
//
//  Created by jack on 14-9-1.
//  Written by Vivian on 14-9-2
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "RealTimeViewController.h"
#import "PhotoAlbumViewController.h"
#import "PhotoWallViewControllerCollectionViewController.h"

@interface RealTimeViewController ()
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,strong) PhotoWallViewControllerCollectionViewController *photoWallViewController;
@property (nonatomic,strong) PhotoAlbumViewController *photoAlbumViewController;
@property (nonatomic,strong) UIView *photoWallView;
@property (nonatomic,strong) UIView *photoAlbumView;

@end

@implementation RealTimeViewController

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
    NSLog(@"realtimeview %f\n%f\n%f\n%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    NSArray *items = [NSArray arrayWithObjects:@"实景", @"专题", nil];
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    if (!self.photoAlbumViewController) {
        
        // 1.创建流水布局
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        // 2.设置每个格子的尺寸
        layout.itemSize = CGSizeMake(250, 250);
        
        // 3.设置整个collectionView的内边距
        CGFloat paddingY = 20;
        CGFloat paddingX = 40;
        layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
        
        // 4.设置每一行之间的间距
        layout.minimumLineSpacing = paddingY;
        self.photoWallViewController = [[PhotoWallViewControllerCollectionViewController alloc]initWithCollectionViewLayout:layout];
        self.photoWallView = self.photoWallViewController.view;
        
        [self addChildViewController:self.photoWallViewController];
        [self.view addSubview:self.photoWallView];
        [self.photoWallViewController didMoveToParentViewController:self];
        
    }
    

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
    
        [motionManager startDeviceMotionUpdates];
        motionManager.deviceMotionUpdateInterval = 1/60.0;
        
//        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
//            NSLog(@"Yaw values is: %f", motion.attitude.yaw);
//        }];
       
        [locationManager startUpdatingHeading];
        
        NSLog(@"Take Picture");
        
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
    NSLog(@"Get picture!");
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    [library saveImage:image toAlbum:@"Sensor" withCompletionBlock:^(NSError *error) {
//        
//        if (error!=nil) {
//            
//            NSLog(@"Big error: %@", [error description]);
//            
//        }
//    }];
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    yaw = currentAttitude.yaw*(180/M_PI);
    roll = currentAttitude.roll*(180/M_PI);//顺时针 -180~180
    pitch = currentAttitude.pitch*(180/M_PI);//水平面以上为正 -90~90
    //NSLog(@"Device Motion:\nx==%f\ny==%f\nz==%f", pitch, yaw, roll);
    [motionManager stopDeviceMotionUpdates];
    
    self.xDirect = locationManager.heading.trueHeading;
    //NSLog(@"Heading==%f", self.xDirect);
    [locationManager stopUpdatingHeading];
    
    //元数据
    NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSMutableDictionary *metadata=[NSMutableDictionary dictionaryWithDictionary:dict];
    //NSLog(@"metadata==%@",metadata);
    
    //EXIF数据
    NSMutableDictionary *EXIFDictionary =[[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
    
    //NSLog(@"EXIFDictionary==%@",EXIFDictionary);
    //NSLog(@"DateTimeDigitized==%@",[EXIFDictionary objectForKey:@"DateTimeDigitized"]);
    
    NSString *tempTime = [EXIFDictionary objectForKey:@"DateTimeDigitized"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSDate *time = [formatter dateFromString:tempTime];
    
    PicInfo *thisPicInfo = [[PicInfo alloc]init];
    thisPicInfo.picID = [time timeIntervalSince1970];
    NSLog(@"\npicID==%d", thisPicInfo.picID);
    thisPicInfo.picTopic = @"topic 1";//modify in the future
    
    thisPicInfo.xDirect = self.xDirect;//android 0~360
    thisPicInfo.yDirect = pitch * (-1);//android -180~180, 顺时针
    thisPicInfo.zDirect = roll;//android -90~90，顺时针
    
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
    [sqlite insertPicList:thisPicInfo];
    
    Collect *collection = [[Collect alloc]init];
    CollectionData *collectData = [[CollectionData alloc]init];
    collectData = [collection startCollect];
    
    collectData.createdTime = thisPicInfo.picID;
    collectData.longitude = self.longitude;
    collectData.latitude = self.latitude;
    collectData.altitude = self.altitude;
    NSLog(@"COLLECT\nlongitude==%f\nlatitude==%f\naltitude==%f", collectData.longitude, collectData.latitude, collectData.altitude);
    
    [sqlite insertDataList:collectData];
    
    //Write new tiff infomation to metadata
    NSString *json = [self getInfo:thisPicInfo];
    NSMutableDictionary *TIFFDictionary =[metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    [TIFFDictionary setValue:json forKey:(NSString*)kCGImagePropertyTIFFMake];
    [metadata setValue:TIFFDictionary forKey:(NSString*)kCGImagePropertyTIFFDictionary];
//    if (metadata && json) {
//        [metadata setValue:json forKey:(NSString*)kCGImagePropertyTIFFMake];
//    }
    NSLog(@"metadata==%@",metadata);
    
   
    [library saveWriteImage:image toAlbum:@"Sensor" withMetadata:metadata withID:thisPicInfo.picID withCompletionBlock:^(NSError *error){
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library");
        }
    }];
    
    [self dismissModalViewControllerAnimated:YES];
    
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

#pragma --segmentControl

-(void)segmentChanged:(UISegmentedControl *)sender{
    NSInteger selectedSegmentIndex = [sender selectedSegmentIndex];
    switch (selectedSegmentIndex) {
        case 0://添加PhotoWallViewController
            if (!self.photoWallViewController) {
                self.photoWallViewController = [[PhotoWallViewControllerCollectionViewController alloc]init];
                self.photoWallView = self.photoWallViewController.view;
                
                [self addChildViewController:self.photoWallViewController];
                [self.view addSubview:self.photoWallView];
                [self.photoWallViewController didMoveToParentViewController:self];
                
            }
            [self.view bringSubviewToFront:self.photoWallView];
            
            
            break;
        case 1://添加PhotoAlbumViewController
            if (!self.photoAlbumViewController) {
                self.photoAlbumViewController = [[PhotoAlbumViewController alloc]init];
            }
            [self.photoWallViewController willMoveToParentViewController:nil];
            [self.photoWallViewController removeFromParentViewController];
            [self.photoWallView removeFromSuperview];
            [self addChildViewController:self.photoAlbumViewController];
            self.photoAlbumView = self.photoAlbumViewController.view;
            //self.photoAlbumView.frame = self.photoWallView.frame;
            
            [self.view addSubview:self.photoAlbumView];
            [self.photoAlbumViewController didMoveToParentViewController:self];
            [self.view bringSubviewToFront:self.photoAlbumView];
            
            break;
            
            
        default:
            break;
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
