//
//  SensorHTTPClient.m
//  sensoriosclient
//
//  Created by jack on 14-10-9.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "SensorHTTPClient.h"
#import "CommonDefinition.h"
#import "RandomString.h"

@implementation SensorHTTPClient
+ (SensorHTTPClient *)sharedSensorHTTPClient{
    static SensorHTTPClient *_sharedSensorHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSensorHTTPClient = [[self alloc]initWithBaseURL:[NSURL URLWithString:UploadBaseURL]];
    });
    return _sharedSensorHTTPClient;
}
#pragma --upload
- (void)uploadImageData:(NSData *)ImageData toURL:(NSString *)urlString{
    
    SensorHTTPClient *client = [SensorHTTPClient sharedSensorHTTPClient];
    
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",[RandomString randomStringFromTime]];
    
    [client POST:UploadImageAppendURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:ImageData name:@"uploadImage" filename:filename];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success!%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error%@",error);
    }];
}

@end
