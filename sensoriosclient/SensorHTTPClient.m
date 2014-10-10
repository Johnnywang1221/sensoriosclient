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
#import "CollectionData.h"


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
    
    
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",[RandomString randomStringFromTime]];
    
    [self POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:ImageData name:@"uploadImage" filename:filename];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success!%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error%@",error);
    }];
}

- (void)uploadCollectionData:(CollectionData *)collectionData toURL:(NSString *)urlString{
    NSString *uploadFormatString = [self formatJSONDicToJSONStringForUpload:collectionData];
    NSDictionary *params = @{@"upload":uploadFormatString};
    [self POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);

    }];
    
    
}

#pragma --utility
- (NSString *)formatJSONDicToJSONStringForUpload:(CollectionData *)collectionData{
    NSMutableDictionary *uploadFormatDic = [[NSMutableDictionary alloc]init];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"MODEL"];
    [uploadFormatDic setObject:username forKey:@"username"];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dataDic = [collectionData toDictionaryWithStringValue];
    [dataArray addObject:dataDic];
    [uploadFormatDic setObject:dataArray forKey:@"data"];
    NSError *error;
    NSData *uploadFormatData = [NSJSONSerialization dataWithJSONObject:uploadFormatDic options:kNilOptions error:&error];
    if (error) {
        NSLog(@"uploadFormatData error");
        return nil;
    }
    NSString *uploadFormatDataStr = [[NSString alloc]initWithData:uploadFormatData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",uploadFormatDataStr);
    return uploadFormatDataStr;
    
}

@end
