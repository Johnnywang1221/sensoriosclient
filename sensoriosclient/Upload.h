//
//  Upload.h
//  uploadDemo
//
//  Created by jack on 14-9-5.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Upload : NSObject<NSURLConnectionDataDelegate>

- (void)uploadImage:(UIImage *)image toURL:(NSString *)imageUploadURL;

@end
