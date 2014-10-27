//
//  WebPhoto.h
//  sensoriosclient
//
//  Created by jack on 14-10-10.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebPhoto : NSObject

@property (nonatomic,copy)NSString *packURL;
@property (nonatomic,copy)NSString *srcURL;
@property (nonatomic,strong)UIImage *packImage;
@property (nonatomic,strong)UIImage *srcImage;
@end
