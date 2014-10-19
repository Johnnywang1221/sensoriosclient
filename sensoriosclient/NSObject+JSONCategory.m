//
//  NSObject+JSONCategory.m
//  classTest
//
//  Created by jack on 14-10-11.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "NSObject+JSONCategory.h"

@implementation NSObject (JSONCategory)
- (NSString *)toJSONString{
    NSString *JSONString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@",error);
        return nil;
    }
    else{
        JSONString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return JSONString;
}

@end
