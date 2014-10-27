//
//  PhotoWallViewControllerCollectionViewController.m
//  sensoriosclient
//
//  Created by jack on 14-10-17.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "PhotoWallViewControllerCollectionViewController.h"
#import "SensorHTTPClient.h"
#import "NSDate+interval.h"
#import "PhotoWallList.h"
#import "WebPhoto.h"

@interface PhotoWallViewControllerCollectionViewController ()
{
    CGFloat _itemWidth;
    CGFloat _minSpaceBetweenItems;
}
@property (strong,nonatomic)NSMutableArray *photos;


@end

@implementation PhotoWallViewControllerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    if(self){
        _minSpaceBetweenItems = 10;
        _itemWidth = ([UIScreen mainScreen].bounds.size.width-2*_minSpaceBetweenItems)/3;
        NSLog(@"%f%f",_minSpaceBetweenItems,_itemWidth);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    if (!self.photos) {
        self.photos = [[NSMutableArray alloc]init];
    }
    else{
        [self.photos removeAllObjects];
    }
    SensorHTTPClient *client = [SensorHTTPClient sharedSensorHTTPClient];
    client.photoWallListDelegate = self;
    NSDate *now = [[NSDate alloc]init];
    [client getPhotoWallListWithmaxNum:20 beginTime:[now intervalSince1970AdjustedByDay:-6 Hour:0 Minute:0 Second:0]];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    //cell.backgroundColor = [UIColor blueColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.frame];
    WebPhoto *photo = self.photos[indexPath.row];

    imageView.image = photo.packImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    WebPhoto *photo = self.photos[indexPath.row];
    float widthHeightRatio = photo.packImage.size.height/photo.packImage.size.width;//图像的宽高比
    return CGSizeMake(_itemWidth, _itemWidth*widthHeightRatio);//cell宽度固定，长度可变

}

- (void)sucessWithPhotoWallList:(PhotoWallList *)photoWallList{
    NSLog(@"%@",photoWallList.photosArray);
    for (NSDictionary *dic in photoWallList.photosArray) {
        WebPhoto *photo = [[WebPhoto alloc]init];
        photo.packURL = [dic objectForKey:@"pack_url"];
        photo.srcURL = [dic objectForKey:@"src_url"];
        [[SensorHTTPClient sharedSensorHTTPClient]GET:photo.packURL  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            photo.packImage = [UIImage imageWithData:responseObject];
            [self.photos addObject:photo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
    
    
}


@end
