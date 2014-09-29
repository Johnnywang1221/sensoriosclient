//
//  Record.m
//  sensoriosclient
//
//  Created by user on 14-9-26.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "Record.h"

@implementation Record

@synthesize recorder;

-(void)startRecord
{
    //Here we also specifying a sample rate of 44.1kHz (which is capable of representing 22 kHz of sound frequencies according to the Nyquist theorem), and 1 channel (we do not need stereo to measure noise).
    NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    NSError* error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]]  settings:recorderSettings error:&error];
    
    if(recorder){
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
    }else{
        NSLog(@"error for recorder initialisation");
    }
    
}

-(int)getDecibels
{
    [self startRecord];
    [recorder updateMeters];
    
    //android:amplitude 0-32768
    //ios: peakPower -160db-0db
    float peak = [recorder peakPowerForChannel:0];
    float android_peak = 10 * log10(32768);
    int decibel = (int)(((peak-(-160))/160)*android_peak);
    //NSLog(@"Peak==%f, android_peak==%f, decibel ==%d",peak, android_peak, decibel);
    return  decibel;
    
}

@end
