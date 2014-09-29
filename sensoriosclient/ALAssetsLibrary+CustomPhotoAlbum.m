//
//  ALAssetsLibrary+CustomPhotoAlbum.m
//  sensor
//
//  Created by Vivian on 14-9-3.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock

{
    
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
     
                       completionBlock:^(NSURL* assetURL, NSError* error) {
                           
                           if (error!=nil) {
                               
                               completionBlock(error);
                               
                               return;
                               
                           }
                           
                           [self addAssetURL: assetURL
                            
                                     toAlbum:albumName
                            
                         withCompletionBlock:completionBlock];
                           
                       }];
    
}

-(void)saveWriteImage:(UIImage*)image toAlbum:(NSString*)albumName withMetadata:(NSDictionary *)metadata withID:(int)picID withCompletionBlock:(SaveImageCompletion)completionBlock
{
  
    [self writeImageToSavedPhotosAlbum:[image CGImage]
                              metadata:metadata
                       completionBlock:^(NSURL* assetURL, NSError* error) {
                           
                           if (error!=nil) {
                               
                               completionBlock(error);
                               
                               return;
                               
                           }
                           
                           [self addAssetURL: assetURL
                                     toAlbum:albumName
                         withCompletionBlock:completionBlock];
                           
                           [self picSaveDB:[assetURL absoluteString] withID:picID];
                           
                       }];
    
}

-(void)picSaveDB:(NSString *)path withID:(int)id
{
    PicSave *save = [[PicSave alloc]init];
    save.picID = id;
    save.picTopic = @"Topic";
    save.filePath = path;
    save.tag = 0;//haven't upload
    
    Sqlite *sqlitedb = [[Sqlite alloc]init];
    [sqlitedb insertSaveList:save];
    
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock{
    
    __block BOOL albumWasFound = NO;
    
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
     
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                
                                albumWasFound = YES;
                                
                                [self assetForURL: assetURL
                                 
                                      resultBlock:^(ALAsset *asset) {
                                          
                                          [group addAsset: asset];
                                          
                                          completionBlock(nil);
                                          
                                      } failureBlock: completionBlock];
                                
                                return;
                                
                            }
                            
                            if (group==nil && albumWasFound==NO) {
                                
                                __weak ALAssetsLibrary* weakSelf = self;
                                
                                [self addAssetsGroupAlbumWithName:albumName
                                 
                                                      resultBlock:^(ALAssetsGroup *group) {
                                                          
                                                          [weakSelf assetForURL: assetURL
                                                           
                                                                    resultBlock:^(ALAsset *asset) {
                                                                        
                                                                        [group addAsset: asset];
                                                                        
                                                                        completionBlock(nil);
                                                                        
                                                                    } failureBlock: completionBlock];
                                                          
                                                      } failureBlock: completionBlock];
                                
                                return;
                                
                            }
                            
                        } failureBlock: completionBlock];
    
}

@end