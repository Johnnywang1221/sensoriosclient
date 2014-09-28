//
//  ALAssetsLibrary+CustomPhotoAlbum.h
//  sensor
//
//  Created by Vivian on 14-9-3.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)saveWriteImage:(UIImage*)image toAlbum:(NSString*)albumName withMetadata:(NSDictionary *)metadata withCompletionBlock:(SaveImageCompletion)completionBlock;

@end
