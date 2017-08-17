//
//  BLEConnector.h
//
//  Created by apple on 12-11-30.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFPeripheral.h"

extern NSString *const RCBCurrentPeripheralIdentifier;
extern NSString *const RCBNotFoundCurrentDevice;

typedef enum {
    VOLTAGE_COMMAND = 0x01,
    RECORE_COMMAND = 0x02,
    NDFI_COMMAND = 0x04,
    ADFI_COMMAND = 0x05,
    AC_COMMAND = 0x06,
    AD_COMMAND = 0x07,
    MONITOR_COMMAND = 0x08,
    ADVINTV_COMMAND = 0x09,
    AUTHO_COMMAD = 0x0b,
    PW_COMMAND = 0x0c,
    CLEINTV_COMMAND = 0x0d,
    CLENUM_COMMAND = 0x0e,
    NAME_COMMAND = 0x0F,
    DISCONNECT_COMMAND = 0x12,
    
    SN_COMMAND = 0x13,
    VERSION_COMMAND = 0x14,
    CLET_ID = 0x15,
    
    DATE_COMAND = 0x16,//new
    
    DATA_COMAND = 0x63,
    
    DATA_GETVOLTAGE = 0x11,
    
}OBJECT_COMMAND_STATE;

typedef enum {
    MONITOR_START = 0x01,
    MONITOR_STOP = 0x03
}MONITOR_STATE;

typedef enum {
    SET_COMMAND = 0x61,
    GET_COMMAND = 0x62
}OPERATION_COMMAND_STATE;


@interface WriteCommandData : NSObject

@property(nonatomic,retain) id data;
@property(nonatomic, assign) OBJECT_COMMAND_STATE state;
@property (nonatomic, assign) OPERATION_COMMAND_STATE operationSate;

@end

@protocol BLEConnectorDelegate <NSObject>

@required
- (void)bleConnectorDiscoveredPeripheral:(LFPeripheral*)lfPeripheral;
- (void)bleConnectorStateDidUpdate:(BOOL)state;

// Sanmeditech
- (void)bleConnectorDidReceiveDataFromPeripheral:(LFPeripheral*)lfPeripheral objectState:(OBJECT_COMMAND_STATE)obCmd operationState:(OPERATION_COMMAND_STATE)opCmd withData:(id)data;

@optional
- (void)bleConnectorDidConnectToPeripheral:(LFPeripheral *)lfPeripheral;
- (void)bleConnectorDidDisconnectToPeripheral:(LFPeripheral *)lfPeripheral;
@end

@interface BLEConnector : NSObject
{
    LFPeripheral *connectedLFPeripheral;
    LFPeripheral *connectingLFPeripheral;
}
@property(nonatomic,assign)id<BLEConnectorDelegate> delegate;
@property(nonatomic,retain)LFPeripheral *connectedLFPeripheral;
@property(nonatomic,retain)LFPeripheral *connectingLFPeripheral;
@property(nonatomic, assign)BOOL permitPair;
@property (nonatomic, strong, readonly) CBCentralManager *manager;


@property (nonatomic, strong)NSMutableArray *peripheralArr;//找到的设备数据
@property (nonatomic, strong)NSTimer *connectPeripheralTimer;


- (BOOL)isSupportLEHardware;
- (void)startScan;
- (void)stopScan;
- (void)connectToPeripheral:(LFPeripheral *)lfPeripheral;
- (void)cancelPeriphral:(LFPeripheral *)lfPeripheral;
- (void)setServices:(NSArray*)services;
- (void)writeCommandInQueue:(CBPeripheral *)peripheral;

// Sanmeditech
- (void)writeDataToPeripheral:(CBPeripheral*)peripheral data:(id)data objectCommand:(OBJECT_COMMAND_STATE)cmd OPCode:(OPERATION_COMMAND_STATE)opCode;
@end
