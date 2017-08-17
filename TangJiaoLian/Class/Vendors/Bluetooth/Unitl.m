//
//  Unitl.m
//  BluetoothDemo
//
//  Created by bai on 16/2/25.
//  Copyright © 2016年 Sanmeditech. All rights reserved.
//

#import "Unitl.h"

@implementation Unitl

+ (NSTimer *)addTimeOutOperationWithInterval:(CGFloat)interval completionBlock:(void (^)())completentBlock
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(completionWithTimer:) userInfo:completentBlock repeats:NO];
    return timer;
}

+ (void)completionWithTimer:(NSTimer *)timer
{
    void (^completionBlock)();
    completionBlock = timer.userInfo;
    if (completionBlock) {
        completionBlock();
    }
}

@end
