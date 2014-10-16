//
//  PhotoWallViewController.m
//  sensoriosclient
//
//  Created by jack on 14-10-13.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "PhotoWallViewController.h"

@implementation PhotoWallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect buttonRect = CGRectMake(100, 100, 120, 100);
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = buttonRect;
    self.button.backgroundColor = [UIColor grayColor];
    self.button.titleLabel.text = @"test";
    [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.button];
    
    
}

- (void)buttonClicked{
    self.button.titleLabel.text = @"success";
    NSLog(@"method in the child viewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
