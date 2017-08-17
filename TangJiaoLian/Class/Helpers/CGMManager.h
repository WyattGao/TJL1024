//
//  CGMManager.h
//  Diabetes
//
//  Created by 徐其东 on 16/6/22.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define CGM_Start_Time [CGMManager CGMStartTime]
#define CGM_End_Time [CGMManager CGMEndTime]
#define CGM_Ending_Time [CGMManager CGMEndingTime]

typedef void(^bluetoothSuccessBlock)(void);
typedef void(^bluetoothFailedBlock)(void);


typedef enum {
    LOW30 = 0,
    HEIGH600 = 1,
    NORMAL = 2,
} DEVICESTATE ;

@interface CGMManager : NSObject<CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *manager;
@property (nonatomic, assign) BOOL isOpen;/*<#注释#>*/





/**
 *  @author 徐其东（http://www.xuqidong.com）, 16-06-22 16:06:50
 *
 *  本地通知设备监测状态
 *
 *  @param state 设备监测状态
 */
+ (void)CGMUILocalNotification:(int)state;

/**
 *  @author 徐其东（http://www.xuqidong.com）, 16-06-22 16:06:05
 *
 *  设备电量
 *
 *  @param state 设备电量
 */
+ (void)CGMUILocalNotificationVoltage:(int)state;


+ (NSString*)CGMStartTime;
+ (NSString*)CGMEndTime;
+ (NSString*)CGMEndingTime;


- (void)checkBluetoothOpen;
- (void)checkBluetoothOpen:(bluetoothSuccessBlock)bluetoothSuccess andFiled:(bluetoothFailedBlock)bluetoothFailed;

@end
