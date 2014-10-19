//
//  NSDate+interval.m
//  classTest
//
//  Created by jack on 14-9-30.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "NSDate+interval.h"

@implementation NSDate (interval)
-(NSString *)intervalSince1970AdjustedByDay:(int)day Hour:(int)hour Minute:(int)minute Second:(int)second{
    
    NSTimeInterval interval = self.timeIntervalSince1970;
    interval=interval + (day*3600*24+hour*3600+minute*60+second);
    long long llintValue = (long long)(interval*1000);
    return [NSString stringWithFormat:@"%lld",llintValue];
}

@end
