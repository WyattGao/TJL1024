//
//  CGMManager.m
//  Diabetes
//
//  Created by 徐其东 on 16/6/22.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "CGMManager.h"
#import <AudioToolbox/AudioToolbox.h>



@implementation CGMManager

+ (NSString*)CGMStartTime{
    NSString *startTime = [GL_USERDEFAULTS objectForKey:SamStartBinDingDeviceTime];
    if (startTime==nil)
        startTime = [NSDate nowDateString];
  
    return startTime;
}

+ (NSString*)CGMEndTime{
    NSString *end = [GL_USERDEFAULTS objectForKey:SamEndBinDingDeviceTime];//历史佩戴
    if (end!=nil) {
        return end;
    }
 
    return [NSDate nowDateString];
}
+ (NSString*)CGMEndingTime{
    NSString *end = [GL_USERDEFAULTS objectForKey:SamEndBinDingDeviceTime];//历史佩戴
    if (end!=nil) {
        return end;
    }
    
    NSString *endTime = [NSDate nowDateString];
    endTime = [GLTools getAfterTime:200 nowTime:endTime format:@"yyyy-MM-dd HH:mm:ss"];
    return endTime;
}


- (void)checkBluetoothOpen{
    self.manager=[[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

- (void)checkBluetoothOpen:(bluetoothSuccessBlock)bluetoothSuccess andFiled:(bluetoothFailedBlock)bluetoothFailed{
    
    
    if (_isOpen) {
        bluetoothSuccess();
    }else{
        bluetoothFailed();
    }
}



- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            
        {
            _isOpen = YES;
            DLog(@"蓝牙开启且可用");
            
        }
            
            break;
            
        default:
            _isOpen = NO;
            DLog(@"蓝牙不可用");
            
            break;
            
    }
    
}


@end
