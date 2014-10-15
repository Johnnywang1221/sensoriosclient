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
