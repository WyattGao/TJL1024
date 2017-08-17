//
//  LFPeripheral.h
//
//  Created by apple on 12-11-30.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFSensorDefine.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface LFPeripheral :LFHardwareSensor


@property(nonatomic,retain)CBPeripheral *peripheral;
@property(nonatomic,assign)NSUInteger randomNumber;
@property(nonatomic,assign)uint16_t peripheralFeature;
@property(nonatomic,retain)NSData *data;

@end
