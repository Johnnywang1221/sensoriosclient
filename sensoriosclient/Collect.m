//
//  Collect.m
//  sensoriosclient
//
//  Created by user on 14-9-24.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "Collect.h"

@implementation Collect

@synthesize locationManager;

@synthesize dataId;
@synthesize lightIntensity;
@synthesize soundIntensity;
@synthesize createdTime;
@synthesize chargeState;
@synthesize batteryState;
@synthesize netState;

@synthesize hostReachability;//Cellular data network
@synthesize wifiReachability;
@synthesize internetReachability;

-(CollectionData *)startCollect
{
    CollectionData *dataList = [[CollectionData alloc]init];
    
    dataList.dataId = 0;
    dataList.lightIntensity = Brightness.getBrightnessFromScreen;
    
    Record *record = [[Record alloc]init];
    dataList.soundIntensity = [record getDecibels];
    //dataList.createdTime = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"COLLECT\nlight==%f\nsound==%f", dataList.lightIntensity, dataList.soundIntensity);
    dataList.chargeState = [self getBatteryState];
    dataList.batteryState = self.batteryState;
    [self checkNetwork];
    dataList.netState = self.netState;
//    NSLog(@"COLLECT\ncharge==%d\nbattery==%d\nnetwork==%d", dataList.chargeState, dataList.batteryState, dataList.netState);

    return dataList;
}

//-(int)getBattery
//{
//    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
//    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
//    
//    CFDictionaryRef pSource = NULL;
//    const void *psValue;
//    
//    int numOfSources = (int)CFArrayGetCount(sources);
//    if (numOfSources == 0)
//    {
//        CFRelease(blob);
//        CFRelease(sources);
//        NSLog(@"Error in CFArrayGetCount");
//        return 0;
//    }
//    
//    for (int i = 0 ; i < numOfSources ; i++)
//    {
//        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
//        if (!pSource)
//        {
//            CFRelease(blob);
//            CFRelease(sources);
//            NSLog(@"Error in IOPSGetPowerSourceDescription");
//            return 0;
//        }
//        
//        psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
//        
//        int curCapacity = 0;
//        int maxCapacity = 0;
//        int percent;
//        
//        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
//        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
//        
//        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
//        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
//        
//        percent = (int)(((double)curCapacity/(double)maxCapacity * 100.0f)*100);
//        
////        NSNumber* no1 = [NSNumber numberWithInt:curCapacity];
////        NSNumber* no2= [NSNumber numberWithInt:maxCapacity];
//        
//        CFRelease(blob);
//        CFRelease(sources);
//        
//        //return [NSDictionary dictionaryWithObjectsAndKeys:no1, @"no1", no2, @"no2", nil];
//        
//        return percent;
//    }
//    
//    CFRelease(blob);
//    CFRelease(sources);
//    
//    return 0;
//}


-(int)getBatteryState
{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    //    accuracy is not very good
    float batLeft = [myDevice batteryLevel];
    self.batteryState=(batLeft*100);
    //NSLog(@"Battry Level is :%d and Battery Status is :%d",batinfo,i);
    
    int i=[myDevice batteryState];
    
    //in Android
    //UIDeviceBatteryStateUnplugged  4 = not charging
    //UIDeviceBatteryStateCharging   2
    //UIDeviceBatteryStateFull       5
    //UIDeviceBatteryStateUnknown    1
    //discharging 3  (doesn't exist in ios)
    
    switch (i)
    {
        case UIDeviceBatteryStateUnplugged:
        {
            return 4;
            break;
        }
        case UIDeviceBatteryStateCharging:
        {
            return 2;
            break;
        }
        case UIDeviceBatteryStateFull:
        {
            return 5;
            break;
        }
        default:
        {
            return 1;
            break;
        }
    }
    
}

- (void)checkNetwork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
	[self getNetWork:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self getNetWork:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
	[self getNetWork:self.wifiReachability];
    
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self getNetWork:curReach];
}

-(void) getNetWork:(Reachability *)curReach
{
    NetworkStatus netstatus = [curReach currentReachabilityStatus];
    
    //NSLog(@"Network status: %d", netstatus);
    
    //all values are following android!
    switch (netstatus)
    {
        case NotReachable:
            // 没有网络连接
            //reachableStatus = NSLocalizedString(@"No Network", "");
            self.netState = 0;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            //reachableStatus = @"GPRS/3G";
            self.netState = 2;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            //reachableStatus = @"WIFI";
            self.netState = 3;
            break;
    }
    
}

@end
