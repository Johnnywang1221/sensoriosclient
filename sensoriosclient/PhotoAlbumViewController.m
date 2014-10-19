//
//  PhotoAlbumViewController.m
//  sensoriosclient
//
//  Created by jack on 14-10-13.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "PhotoAlbumViewController.h"

@implementation PhotoAlbumViewController
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
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:[self.view bounds]];
    CGSize bigSize = CGSizeMake(scrollView.frame.size.width*2, scrollView.frame.size.height*2);
    scrollView.contentSize = bigSize;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bigSize.width, bigSize.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [scrollView addSubview:tableView];
    [self.view addSubview:scrollView];
    self.view.backgroundColor = [UIColor redColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"call datasouce method");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

@end
