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
#import "NSObject+JSONCategory.h"
#import "PhotoWallList.h"


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

- (void)getPhotoWallListWithmaxNum:(int)maxNum beginTime:(NSString *)beginTimeString{
    //__block PhotoWallList *result;//返回值,__block使变量可以在block中被修改
    //获取json列表
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:beginTimeString forKey:@"begin_time"];
    [params setObject:@"photo_list" forKey:@"request_type"];
    [params setObject:[NSNumber numberWithInt:maxNum] forKey:@"request_maxnum"];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",[params toJSONString]);
    [postDic setObject:[params toJSONString] forKey:@"upload"];
    [self POST:GetPhotoWallListAppendURL parameters:postDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //解析返回json，构造PhotoWallList model
        //NSString *jsonResponse = [[NSString alloc]initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:&error];
        if(error){
            NSLog(@"%@",error);
            return ;
        }
        else{
            //NSLog(@"%@",responseDic);
            PhotoWallList *result;
            result = [[PhotoWallList alloc]init];
            result.photosNum = [[responseDic objectForKey:@"response_num"]integerValue];
            result.photosArray = [responseDic objectForKey:@"response_photos"];
            [self.photoWallListDelegate sucessWithPhotoWallList:result];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self.photoWallListDelegate failedWithError:error];
    }];
    
    
}
#pragma mark -- download Image


@end
