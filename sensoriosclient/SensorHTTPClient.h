//
//  SensorHTTPClient.h
//  sensoriosclient
//
//  Created by jack on 14-10-9.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "AFHTTPSessionManager.h"
@class CollectionData;
@class PhotoWallList;


@protocol PhotoWallListProtocol <NSObject>

@optional
- (void)sucessWithPhotoWallList:(PhotoWallList *)photoWallList;
- (void)failedWithError:(NSError *)error;
@end

@interface SensorHTTPClient : AFHTTPSessionManager
@property (weak,nonatomic) id<PhotoWallListProtocol> photoWallListDelegate;

+ (SensorHTTPClient *)sharedSensorHTTPClient;
#pragma --upload
- (void)uploadImageData:(NSData *)ImageData toURL:(NSString *)urlString;
- (void)uploadCollectionData:(CollectionData *)collectionData toURL:(NSString *)urlString;
#pragma --getPhotoWallList
- (void)getPhotoWallListWithmaxNum:(int)maxNum beginTime:(NSString *)beginTimeString;

@end
