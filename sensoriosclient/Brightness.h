//
//  Brightness.h
//  uidevice
//
//  Created by jack on 14-9-26.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//
//使用方法：调用类方法[Brightness getBrightnessFromScreen];
//返回类型：CGFloat(UIKit中的float，基本类型，不用CGFloat *)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Brightness : NSObject
+ (CGFloat)getBrightnessFromScreen;

@end
