//
//  PicSave.h
//  sensoriosclient
//
//  Created by user on 14-9-29.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicSave : NSObject

@property (nonatomic) int picID;
@property (nonatomic, retain) NSString *picTopic;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic) int tag;

@end
