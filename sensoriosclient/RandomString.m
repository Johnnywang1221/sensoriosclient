//
//  RandomString.m
//  uploadDemo
//
//  Created by jack on 14-9-10.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "RandomString.h"

@implementation RandomString
+ (NSString *)randomStringFromTime{
    NSMutableString *randomStringFromTime = [[NSMutableString alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMDDHHmmss"];
    NSDate *now = [NSDate date];
    [randomStringFromTime appendString:[dateFormatter stringFromDate:now]];
    NSInteger randomInteger = arc4random()%100;
    [randomStringFromTime appendString:[NSString stringWithFormat:@"%d",randomInteger]];
    return randomStringFromTime;
}

@end
