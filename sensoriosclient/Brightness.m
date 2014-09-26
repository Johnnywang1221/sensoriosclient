//
//  Brightness.m
//  uidevice
//
//  Created by jack on 14-9-26.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "Brightness.h"

@implementation Brightness

+(CGFloat)getBrightnessFromScreen{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat brightnessOfTheScreen = mainScreen.brightness;
    return brightnessOfTheScreen;
}

@end
