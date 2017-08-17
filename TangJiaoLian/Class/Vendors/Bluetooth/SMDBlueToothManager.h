//
//  SMDBLEManager.h
//  Sanmeditech
//
//  Created by Nathan on 14-5-26.
//  Copyright (c) 2014年 xpg. All rights reserved.
//

#import "LFHardwareConnector.h"


//发现设备|连接设备|断开设备|得到Authro |接收电流|收到电压|获取数据|开始监控|获得监控状态|获得背景职位|


extern NSString *const SMDBLEDidDiscoverDeviceNotification;
extern NSString *const SMDBLEDidConnectedDeviceNotification;
extern NSString *const SMDBLEDidGetAuthroNotification;
extern NSString *const SMDBLEDidReceivedCurrentNotification;
extern NSString *const SMDBLEDidReceivedCurrentIndexNotification;
extern NSString *const SMDBLEDidReceivedVoltageNotification;
extern NSString *const SMDBLEDidGetDataCount;
extern NSString *const SMDBLEDidStartMonitor;
extern NSString *const SMDBLEDidGetMonitorState;
extern NSString *const SMDBLEDidDisconnectedDeviceNotification;
extern NSString *const SMDBLEDidGetBackgroundPostNotification;
extern NSString *const SMDBLEDidGetAllDatas;//获取所有的电流值数组
extern NSString *const SMDBLEDidConnectSuccess;//设备连接成功

@protocol SDBlueToothBackgroundPostsDelegate <NSObject>

- (void)blueToothBackgroundPost;

@end

@interface SMDBlueToothManager : NSObject <LFHardwareConnectorDelegate>

@property (nonatomic, assign) id<SDBlueToothBackgroundPostsDelegate>delegate;

@property (nonatomic, assign) BOOL isAuthorizedConnection; //是否已授权
@property (nonatomic, assign) CGFloat timeoutInterval; // 默认是10s
@property (nonatomic, assign) BOOL postingNotification;
@property (nonatomic, assign) BOOL isFirstConnectedDevice; // 用来判定是不是重新连接的设备

@property (nonatomic, strong) LFPeripheral *connectedDevice; // 已连接的设备

+ (instancetype)sharedManger;
- (void)startScanningDevice;
- (void)stopScanningDevice;

- (void)autoSearchDeviceInBackground;
- (void)stopAutoSearchDeviceInBackground;
- (BOOL)didStartAutoScan;

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// New Methods
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@property (nonatomic, assign) BOOL shouldAutoConnectDevice;  // 自动连接硬件开关

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// 授权连接方法
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// 获取连接，以及授权连接
- (void)getConnectionForSensor:(LFPeripheral *)sensor completion:(void(^)(BOOL success))block withGettingAuthroCompletion:(void(^)(BOOL success, id sensor))authroBlock timeoutBlock:(void(^)())timeoutblock;
- (void)getConnectionForSensor:(LFPeripheral *)sensor completion:(void(^)(BOOL success))block timeoutBlock:(void(^)())timeoutblock;  // 建立连接
- (void)getAuthroWithCompletion:(void(^)(BOOL success, id sensor))block timeoutBlock:(void(^)())timeoutblock;  // 获取授权

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// 采集状态方法
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

- (void)getMonitorStatusWithCompletion:(void(^)(MONITOR_STATE state))block timeoutBlock:(void(^)())timeoutblock; // 获取当前采集状态
- (void)startMonitorWithCompletion:(void(^)(BOOL success))block timeoutBlock:(void(^)())timeoutblock;  // 开始采集
- (void)stopMonitorWithCompletion:(void(^)(BOOL success))block timeoutBlock:(void(^)())timeoutblock;  // 停止采集

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// 获取数据方法
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

/** 疑问
 
 1. 获取全部数据的时候，应当让程工在数据段开始和结尾加上标识符，原因：app计算控制开始和结束接收数据难度大，容易出现问题。
 
 **/

- (void)getDataCountWithCompletion:(void(^)(NSInteger dataCount))block timeoutBlock:(void(^)())timeoutblock; // 获取采集数据量
// 获取电流
- (void)getNextCurrent:(void(^)(CGFloat current))block timeoutBlock:(void(^)())timeoutblock;
- (void)getCurrentsFromIndex:(NSInteger)beginIndex toIndex:(NSInteger)endIndex witCompletion:(void(^)(NSArray *currents))block timeoutBlock:(void(^)())timeoutblock;



- (void)getAllDataFromIndex:(NSInteger)index numdata:(NSInteger )numdata;

- (void)getDataWithComman:(uint8_t)cmd;

/**
 *  @brief 获取固件版本号
 */
- (void)getFirmwareVersionWithCompletion:(void(^)(NSString *version))block timeoutBlock:(void(^)())timeoutblock;




@end
