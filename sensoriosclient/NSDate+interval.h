//
//  NSDate+interval.h
//  classTest
//
//  Created by jack on 14-9-30.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (interval)
-(NSString *)intervalSince1970AdjustedByDay:(int)day Hour:(int)hour Minute:(int)minute Second:(int)second;

@end
