//
//  Record.h
//  sensoriosclient
//
//  Created by user on 14-9-26.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Record : NSObject

@property (nonatomic, strong)AVAudioRecorder *recorder;

-(int)getDecibels;

@end
