//
//  PicSave.m
//  sensoriosclient
//
//  Created by user on 14-9-29.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "PicSave.h"

@implementation PicSave
@synthesize picID;
@synthesize picTopic;
@synthesize filePath;
@synthesize tag;

-(id) init
{
    picID = 0;
    picTopic = @"";
    filePath = @"";
    tag = 0;
    
    return self;
}


@end
