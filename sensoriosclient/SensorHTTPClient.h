//
//  SensorHTTPClient.h
//  sensoriosclient
//
//  Created by jack on 14-10-9.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CollectionData.h"

@interface SensorHTTPClient : AFHTTPSessionManager

+ (SensorHTTPClient *)sharedSensorHTTPClient;
#pragma --upload
- (void)uploadImageData:(NSData *)ImageData toURL:(NSString *)urlString;
- (void)uploadCollectionData:(CollectionData *)collectionData toURL:(NSString *)urlString;

@end
