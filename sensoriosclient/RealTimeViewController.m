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
#import "PhotoWallViewController.h"

@interface RealTimeViewController ()
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,strong) PhotoWallViewController *photoWallViewController;
@property (nonatomic,strong) PhotoAlbumViewController *photoAlbumViewController;
@property (nonatomic,strong) UIView *photoWallView;
@property (nonatomic,strong) UIView *photoAlbumView;

@end

@implementation RealTimeViewController

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
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    if (!self.photoWallViewController) {
        self.photoWallViewController = [[PhotoWallViewController alloc]init];
        self.photoWallView = self.photoWallViewController.view;
        
        [self addChildViewController:self.photoWallViewController];
        [self.view addSubview:self.photoWallView];
        [self.photoAlbumViewController didMoveToParentViewController:self];
        
    }
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)openCamera
{
    
    CustomImagePickerController *imagepickerCtrl = [[CustomImagePickerController alloc] init];
    imagepickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagepickerCtrl.customDelegate = self;
    [self presentViewController:imagepickerCtrl animated:YES completion:NULL];
    
}

#pragma mark CustomImagePickerControllerDelegate
- (void)cancelCamera{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma --segmentControl

-(void)segmentChanged:(UISegmentedControl *)sender{
    NSInteger selectedSegmentIndex = [sender selectedSegmentIndex];
    switch (selectedSegmentIndex) {
        case 0://添加PhotoWallViewController
            if (!self.photoWallViewController) {
                self.photoWallViewController = [[PhotoWallViewController alloc]init];
                self.photoWallView = self.photoWallViewController.view;
                
                [self addChildViewController:self.photoWallViewController];
                [self.view addSubview:self.photoWallView];
                [self.photoAlbumViewController didMoveToParentViewController:self];
                
            }
            [self.view bringSubviewToFront:self.photoWallView];
            
            
            break;
        case 1://添加PhotoAlbumViewController
            if (!self.photoAlbumViewController) {
                self.photoAlbumViewController = [[PhotoAlbumViewController alloc]init];
                self.photoAlbumView = self.photoAlbumViewController.view;
                [self addChildViewController:self.photoAlbumViewController];
                [self.view addSubview:self.photoAlbumView];
                [self.photoAlbumViewController didMoveToParentViewController:self];
            }
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
