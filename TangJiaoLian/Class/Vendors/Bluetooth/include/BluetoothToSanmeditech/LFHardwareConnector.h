//
//  LFHardwareConnector.h
//
//  Created by apple on 12-11-29.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEConnector.h"
#import "LFSensorDefine.h"
#import <UIKit/UIKit.h>
@protocol LFHardwareConnectorDelegate <NSObject>

@required
/**
 *  @author bai, 16-03-10 19:03:26
 *
 *  @brief 硬件传感器连接器发现
 *
 *  @param sensor 蓝牙
 */
-(void)hardwareConnectorDiscoveredSensor:(LFPeripheral*)sensor;

@optional
/**
 *  @author bai, 16-03-10 19:03:08
 *
 *  @brief 连接器得到身份验证失败
 *
 *  @param lfPheripheral 蓝牙对象
 */
- (void)hardwareConnectorGetAuthFail:(LFPeripheral *)lfPheripheral;
/**
 *  @author bai, 16-03-10 19:03:12
 *
 *  @brief 硬件连接器并得到Authro成功
 *
 *  @param lfPheripheral 蓝牙对象
 */
- (void)hardwareConnectorDidGetAuthroSuccess:(LFPeripheral *)lfPheripheral;
/**
 *  @author bai, 16-03-10 19:03:15
 *
 *  @brief 硬件连接器并得到所有数据计数
 *
 *  @param count 获取数据计数
 */
- (void)hardwareConnectorDidGetAllDataCount:(NSInteger)count;
/**
 *  @author bai, 16-03-10 19:03:18
 *
 *  @brief 硬件连接器并成功设置监控状态
 *
 *  @param monitorState 目前监控状态
 */
- (void)hardwareConnectorDidSetMonitorStateSuccess:(MONITOR_STATE)monitorState;
/**
 *  @author bai, 16-03-10 19:03:20
 *
 *  @brief 硬件连接并接收电流
 *
 *  @param current 电流量
 */
- (void)hardwareConnectorDidReceiveCurrent:(CGFloat)current;
/**
 *  @author bai, 16-03-10 19:03:23
 *
 *  @brief 硬件连接器完成收到电流
 */
- (void)hardwareConnectorDidFinishReceiveCurrent;
/**
 *  @author bai, 16-03-10 19:03:26
 *
 *  @brief 硬件连接器并得到当前的数据
 *
 *  @param array 数据数组
 */
- (void)hardwareConnectorDidGetCurrentDatas:(NSArray *)array;
/**
 *  @author bai, 16-03-10 19:03:28
 *
 *  @brief 硬件连接器连接到外围
 *
 *  @param lfPeripheral 蓝牙信息
 */
- (void)hardwareConnectorDidConnectedToPeripheral:(LFPeripheral *)lfPeripheral;
/**
 *  @author bai, 16-03-10 19:03:31
 *
 *  @brief 硬件连接器断开连接的外围
 *
 *  @param lfPeripheral 蓝牙信息
 */
- (void)hardwareConnectorDidDisconnectedToPeripheral:(LFPeripheral *)lfPeripheral;
/**
 *  @author bai, 16-03connectToPeripheral-10 19:03:33
 *
 *  @brief 硬件连接并接收电压
 *
 *  @param voltage 电压量
 */
- (void)hardwareConnectorDidReceiveVoltage:(CGFloat)voltage;
/**
 *  @author bai, 16-03-10 19:03:38
 *
 *  @brief 硬件连接器并得到监控状态
 *
 *  @param monitorState 获取监控状态
 */
- (void)hardwareConnectorDidGetMonitorState:(MONITOR_STATE)monitorState;
/**
 *  @author bai, 16-03-10 19:03:41
 *
 *  @brief 硬件连接并接收电流
 *
 *  @param current
 *  @param index
 */
- (void)hardwareConnectorDidReceiveCurrent:(CGFloat)current atIndex:(NSInteger)index;
/**
 *  @author bai, 16-03-10 19:03:44
 *
 *  @brief 硬件连接器并得到设备开始时间
 *
 *  @param date 时间
 */
- (void)hardwareConnectorDidGetDeviceStartTime:(NSDate *)date;
/**
 *  @author bai, 16-03-10 19:03:47
 *
 *  @brief 硬件连接器并得到固件版本
 *
 *  @param version 版本信息
 */
- (void)hardwareConnectorDidGetFirmwareVersion:(NSString *)version;
@end

@interface LFHardwareConnector : NSObject

@property(nonatomic,readonly)BOOL isBLEEnable;
@property(nonatomic,readonly)BOOL hasConnectedSensor;//已连接的传感器
@property(nonatomic,assign)id<LFHardwareConnectorDelegate> delegate;
@property(nonatomic, assign)BOOL isScanning;//正在扫描
@property(nonatomic, assign)BOOL permitPair;//允许对

@property (nonatomic, assign) NSInteger getNum;//获取数据条数

/**
 *  @author bai, 16-03-10 19:03:25
 *
 *  @brief 开始扫描
 */
- (void)startScanning;
/**
 *  @author bai, 16-03-10 19:03:34
 *
 *  @brief 取消扫描
 */
- (void)cancelScanning;
/**
 *  @author bai, 16-03-10 19:03:44
 *
 *  @brief 获取连接器
 *
 *  @return
 */
+ (LFHardwareConnector*)shareConnector;
/**
 *  @author bai, 16-03-10 19:03:06
 *
 *  @brief 连接到外围
 *
 *  @param lfPeripheral
 */
- (void)connectToPeripheral:(LFPeripheral *)lfPeripheral;
/**
 *  @author bai, 16-03-10 19:03:25
 *
 *  @brief 取消外围
 *
 *  @param lfPeripheral
 */
- (void)cancelPeripheral:(LFPeripheral*)lfPeripheral;
/**
 *  @author bai, 16-03-10 19:03:42
 *
 *  @brief 写命令队列
 */
- (void)writeCommandInQueue;
/**
 *  @author bai, 16-03-10 19:03:57
 *
 *  @brief 获取外围设备
 *
 *  @return
 */
- (LFPeripheral*)getConnectedPeriphral;
/**
 *  @author bai, 16-03-10 19:03:25
 *
 *  @brief 中央管理器
 *
 *  @return
 */
- (CBCentralManager *)centralManager;

// Sanmeditech Actions
/**
 *  @author bai, 16-03-10 19:03:40
 *
 *  @brief 得到Authro密码
 *
 *  @param password
 *  @param isReconnecting
 *  @param deviceAddr
 */
- (void)getAuthroWithPassword:(NSString *)password autoReconnect:(BOOL)isReconnecting DeviceAddr:(NSString *)deviceAddr;
/**
 *  @author bai, 16-03-10 19:03:59
 *
 *  @brief 得到Num的数据
 *
 *  @param dataNum
 *  @param beginIndex
 */
- (void)getNumOfData:(NSUInteger)dataNum fromIndex:(NSUInteger)beginIndex;
/**
 *  @author bai, 16-03-10 19:03:13
 *
 *  @brief 从指数获得数据
 *
*  @param index
 */
- (void)getDataFromIndex:(NSUInteger)index;
/**
 *  @author bai, 16-03-10 19:03:35
 *
 *  @brief 得到的数据与Comman
 *
 *  @param cmd
 */
- (void)getDataWithComman:(uint8_t)cmd;
/**
 *  @author bai, 16-03-10 19:03:58
 *
 *  @brief 集数据外围
 *
 *  @param data
 *  @param cmd
 */
- (void)setDataToPeripheral:(id)data command:(uint8_t)cmd;

- (void)setDeviceTime;
- (void)getDeviceTime;


/*
 *
 * 获取电压当前电压
 */

- (void)getData_voltag;
@end
