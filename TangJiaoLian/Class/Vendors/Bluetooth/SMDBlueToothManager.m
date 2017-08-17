//
//  SMDBLEManager.m
//  Sanmeditech
//
//  Created by Nathan on 14-5-26.
//  Copyright (c) 2014年 xpg. All rights reserved.
//

#import "SMDBlueToothManager.h"
#import "LFPeripheral.h"
#import "Unitl.h"
#import "AppDelegate.h"

#define ZDY_LOG(XX)    NSLog(XX);[[NSNotificationCenter defaultCenter] postNotificationName:@"其他后台自动命令日志" object:XX];


NSString *const SMDBLEDidDiscoverDeviceNotification = @"LSBLEDidDiscoverDeviceNotification";
NSString *const SMDBLEDidConnectedDeviceNotification = @"SMDBLEDidConnectedDeviceNotification";
NSString *const SMDBLEDidDisconnectedDeviceNotification = @"SMDBLEDidDisconnectedDeviceNotification";
NSString *const SMDBLEDidGetAuthroNotification = @"SMDBLEDidGetAuthroNotification";
NSString *const SMDBLEDidReceivedCurrentNotification = @"SMDBLEDidReceivedCurrentNotification";
NSString *const SMDBLEDidReceivedCurrentIndexNotification = @"SMDBLEDidReceivedCurrentIndexNotification";
NSString *const SMDBLEDidReceivedVoltageNotification = @"SMDBLEDidReceivedVoltageNotification";//电压
NSString *const SMDBLEDidGetDataCount = @"SMDBLEDidGetDataCount";//数据数量
NSString *const SMDBLEDidStartMonitor = @"SMDBLEDidStartMonitor";
NSString *const SMDBLEDidGetMonitorState = @"SMDBLEDidGetMonitorState";
NSString *const SMDBLEDidGetBackgroundPostNotification = @"SMDBLEDidGetBackgroundPostNotification";
// 获取所有的电流值数组
NSString *const SMDBLEDidGetAllDatas = @"SMDBLEDidGetAllDatas";
//设备连接成功
NSString *const SMDBLEDidConnectSuccess = @"SMDBLEDidConnectSuccess";



@interface SMDBlueToothManager ()

@property (nonatomic, strong) LFPeripheral *currentSensor;

@property (nonatomic, strong) NSTimer *backgroundScaningTimer;

@property (nonatomic, strong) NSTimer *timeoutTimer;

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// All Completion Blocks
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@property (nonatomic, strong) void(^connectionCompletionBlock)(BOOL success);
@property (nonatomic, strong) void(^gettingAuthroCompletionBlock)(BOOL success, id sensor);
@property (nonatomic, strong) void(^dataCountCompletionBlock)(NSInteger count);
@property (nonatomic, strong) void(^startMonitorCompletionBlock)(BOOL success);
@property (nonatomic, strong) void(^stopMonitorCompletionBlock)(BOOL success);
@property (nonatomic, strong) void(^getMonitorBlock)(MONITOR_STATE state);
@property (nonatomic, strong) void(^getCurrentBlock)(CGFloat current);
@property (nonatomic, strong) void(^getCurrentsBlock)(NSArray *currents);
@property (nonatomic, strong) void(^getFirmwareVersionBlock)(NSString *version);

// 单操作锁开关，如果开启，即当当前有一个操作未完成，就不允许开始新操作
// 主要是测试用
@property (nonatomic, assign) BOOL lockedForSingleProcessing;

// 判断系统是否在获取数据中，如果是，那就拒绝发送所有命令，以防止固件发送数据接收不完整
@property (nonatomic, assign) BOOL isGettingData;

@end

@implementation SMDBlueToothManager

+ (instancetype)sharedManger
{
    static SMDBlueToothManager *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[SMDBlueToothManager alloc] init];
        manger.isAuthorizedConnection = NO;
        manger.lockedForSingleProcessing = NO;
        manger.shouldAutoConnectDevice = YES;
        manger.postingNotification = YES;
        manger.timeoutInterval = 15.f;
        manger.isFirstConnectedDevice = NO;
        manger.isGettingData = NO;
        
        
        
    });
    return manger;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Property
////////////////////////////////////////////////////////////////////////////////

- (LFPeripheral *)connectedDevice
{
    return [[LFHardwareConnector shareConnector] getConnectedPeriphral];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////

- (void)reconnectedToDevice
{
    if (self.isAuthorizedConnection) {
        
        UIAlertView *alterr = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Device is connected." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterr show];
        
        return;
    }
    [self startScanningDevice];
}

- (void)getNextCurrent
{
    //    NSInteger lastIndex = [SMDDefaults sharedDefaults].lastCurrentIndex;
    //    [[LFHardwareConnector shareConnector] getNumOfData:1 fromIndex:lastIndex];
    //    [self writeCommandInQueueForManager];
}

-(void)startScanningDevice {
    [[LFHardwareConnector shareConnector] cancelScanning];
    [[LFHardwareConnector shareConnector] startScanning];
}

- (void)stopScanningDevice {
    [[LFHardwareConnector shareConnector] cancelScanning];
}

- (BOOL)hasProgressingOperations {   // 这个方法是这个类的精髓！！：）
    
    if (self.isGettingData) {
        NSLog(@" Data is Updating! Deny all Operations!");
        return YES; // 正在获取数据，不允许所有操作！！
    }
    if (!self.lockedForSingleProcessing) return NO; // 单操作锁
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // 判断是否有动作在进行中
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    if (self.connectionCompletionBlock) {
        NSLog(@"------ Connection Completion Block --------");
        return YES;
    }
    
    if (self.gettingAuthroCompletionBlock) {
        NSLog(@"------ Getting Authro Completion Block --------");
        return YES;
    }
    
    if (self.dataCountCompletionBlock) {
        NSLog(@"------ Data Count Completion Block --------");
        return YES;
    }
    
    if (self.startMonitorCompletionBlock) {
        NSLog(@"------ Start Monitor Completion Block --------");
        return YES;
    }
    
    if (self.stopMonitorCompletionBlock) {
        NSLog(@"------ Stop Monitor Completion Block --------");
        return YES;
    }
    
    if (self.getCurrentBlock) {
        NSLog(@"------ Get Current Completion Block --------");
        return YES;
    }
    
    if (self.getCurrentsBlock) {
        NSLog(@"------ Get Currents_ Completion Block --------");
        return YES;
    }
    
    if (self.getMonitorBlock) {
        NSLog(@"------ Get Monitor Completion Block --------");
        return YES;
    }
    
    return NO;
}

- (void)autoSearchDeviceInBackground
{
    NSLog(@"autoSearchDeviceInBackground");
    NSTimeInterval timeInterval = 15.f;
    self.backgroundScaningTimer = nil;
    if (!self.backgroundScaningTimer) {
        NSLog(@"autoSearchDeviceInBackground1");
        self.backgroundScaningTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(performBackgroundScan) userInfo:nil repeats:YES];
        [self.backgroundScaningTimer fire];
    }
}
#pragma mark---------疑问--------核实已经连接设备以后 后台是否应该停止扫描
- (void)performBackgroundScan
{
    
    NSLog(@"performBackgroundScan");
    if (![LFHardwareConnector shareConnector].hasConnectedSensor) {
        NSLog(@"![LFHardwareConnector shareConnector].hasConnectedSensor");
        [[LFHardwareConnector shareConnector] cancelScanning];
        [[LFHardwareConnector shareConnector] startScanning];
    }
}

- (BOOL)didStartAutoScan
{
    return !(self.backgroundScaningTimer == nil);
}

//- (BOOL)isConnectingDeviceController
//{
//    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([navController isKindOfClass:[UINavigationController class]]) {
//        UIViewController *controller = navController.visibleViewController;
//        if ([controller isKindOfClass:[SMDConnectDeviceController class]]) return YES;
//    }
//    return NO;
//}

- (void)postNotificationWithId:(NSString *)notificationId object:(id)object
{
    // 开始想用 Key - Function 的方式配置各个通知的开关，现在只是加个总开关～
    if (self.postingNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationId object:object];
    }
}

- (void)setTimeoutActionWithBlock:(void(^)())block shouldCleanUpBlock:(id)shouldCleanUpBlock
{
    NSLog(@"%s",__func__);
    CGFloat timeOutInterval = self.timeoutInterval;
    __block id cleanUpBlock = shouldCleanUpBlock;
    
    BOOL isGettingDataBlock = (void(^)(id object))shouldCleanUpBlock == self.getCurrentsBlock; // 判断是不是GettingCurrents block
    if (isGettingDataBlock)
    {
        NSLog(@"Is Getting Data Block!!");
        timeOutInterval = self.timeoutInterval*2.f; // 2倍时间 30秒的超时时间，哇咔咔
    }
    
    timeOutInterval = 10;//fix
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic = @{@"cleanUpBlock":cleanUpBlock,@"block":block};
        
        self.timeoutTimer =  [NSTimer scheduledTimerWithTimeInterval:timeOutInterval target:self selector:@selector(completionWithTimer:) userInfo:dic repeats:NO];
    });
}
- (void)completionWithTimer:(NSNotification *)not{
    
    NSDictionary *dic = [not userInfo];
    
    id cleanUpBlock = [dic objectForKey:@"cleanUpBlock"];
    void(^Block)();
    Block = [dic objectForKey:@"block"];
    
    if (cleanUpBlock && self.timeoutTimer) {
        cleanUpBlock = nil;
        //                if (isGettingDataBlock)FIX LL
        
        self.isGettingData = NO;
        
        self.timeoutTimer = nil;
        Block();
    }
}
- (void)stopTimeoutTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timeoutTimer) {
            [self.timeoutTimer setFireDate:[NSDate distantFuture]];
            self.timeoutTimer = nil;
        }
    });
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions
////////////////////////////////////////////////////////////////////////////////

- (void)getConnectionForSensor:(LFPeripheral *)sensor completion:(void (^)(BOOL))block withGettingAuthroCompletion:(void (^)(BOOL, id))authroBlock timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    [self getConnectionForSensor:sensor completion:^(BOOL success){
        [self stopTimeoutTimer];
        block(success);
        sleep(2);
        [self getAuthroWithCompletion:authroBlock timeoutBlock:^{
            timeoutblock();
        }];
    } timeoutBlock:^{
        timeoutblock();
    }];
}

- (void)getConnectionForSensor:(LFPeripheral *)sensor completion:(void (^)(BOOL))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    if (sensor) {
        self.connectionCompletionBlock = block;
        self.currentSensor = sensor;
        [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.connectionCompletionBlock];
        [[LFHardwareConnector shareConnector] connectToPeripheral:self.currentSensor];
    }else{
//        UIAlertView *alterr = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有发现设备!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alterr show];
    }
}

- (void)getAuthroWithCompletion:(void (^)(BOOL, id))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    if ([LFHardwareConnector shareConnector].hasConnectedSensor) {
        self.gettingAuthroCompletionBlock = block;
        [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.gettingAuthroCompletionBlock];
        [[LFHardwareConnector shareConnector] getAuthroWithPassword:nil autoReconnect:NO DeviceAddr:nil];
        [self writeCommandInQueueForManager];
    }else
    {
        NSLog(@"Device is not connected.");
//        [SVProgressHUD showErrorWithStatus:@"设备失去连接"];
    }
}

- (void)getDataCountWithCompletion:(void (^)(NSInteger))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    self.dataCountCompletionBlock = block;
    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.dataCountCompletionBlock];
    [[LFHardwareConnector shareConnector] getDataWithComman:AC_COMMAND];
    [self writeCommandInQueueForManager];
}

- (void)getMonitorStatusWithCompletion:(void (^)(MONITOR_STATE))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    NSLog(@"%@",block);
    
    self.getMonitorBlock = block;
    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.getMonitorBlock];
    [[LFHardwareConnector shareConnector] getDataWithComman:MONITOR_COMMAND];
    [self writeCommandInQueueForManager];
}

- (void)startMonitorWithCompletion:(void (^)(BOOL))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    self.startMonitorCompletionBlock = block;
    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.startMonitorCompletionBlock];
    [[LFHardwareConnector shareConnector] setDataToPeripheral:@(MONITOR_START) command:MONITOR_COMMAND];
    [self writeCommandInQueueForManager];
}

- (void)stopMonitorWithCompletion:(void (^)(BOOL))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    self.stopMonitorCompletionBlock = block;
    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.stopMonitorCompletionBlock];
    [[LFHardwareConnector shareConnector] setDataToPeripheral:@(MONITOR_STOP) command:MONITOR_COMMAND];
    [self writeCommandInQueueForManager];
}

- (void)getNextCurrent:(void (^)(CGFloat))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    //    self.getCurrentBlock = block;
    //    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.getCurrentBlock];
    //    NSInteger lastIndex = [SMDDefaults sharedDefaults].lastCurrentIndex;
    //    [[LFHardwareConnector shareConnector] getNumOfData:1 fromIndex:lastIndex];
    //    [self writeCommandInQueueForManager];
}

- (void)getCurrentsFromIndex:(NSInteger)beginIndex toIndex:(NSInteger)endIndex witCompletion:(void (^)(NSArray *))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s",__func__);
    if ([self hasProgressingOperations]) return;
    
    self.getCurrentsBlock = block;
    self.isGettingData = YES;
    NSLog(@"==========BeginGetData=============");
    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.getCurrentsBlock];
    NSInteger dataNumber = (endIndex - beginIndex)+1;
    if (dataNumber > 500) {  // 分批获取
        dataNumber = 500;
    }
    [[LFHardwareConnector shareConnector] getNumOfData:dataNumber fromIndex:beginIndex];
    [self writeCommandInQueueForManager];
}

- (void)getFirmwareVersionWithCompletion:(void (^)(NSString *))block timeoutBlock:(void (^)())timeoutblock
{
    NSLog(@"%s", __func__);
    if ([self hasProgressingOperations]) return;
    
    self.getFirmwareVersionBlock = block;
    [self setTimeoutActionWithBlock:timeoutblock shouldCleanUpBlock:self.getFirmwareVersionBlock];
    [[LFHardwareConnector shareConnector] getDataWithComman:VERSION_COMMAND];
    [self writeCommandInQueueForManager];
}

- (void)getAllDataFromIndex:(NSInteger)index numdata:(NSInteger )numdata{
//    [[LFHardwareConnector    shareConnector] getDataFromIndex:index];
    [[LFHardwareConnector shareConnector] getNumOfData:numdata fromIndex:index];
     [self writeCommandInQueueForManager];
}

- (void)getDataWithComman:(uint8_t)cmd{
    [[LFHardwareConnector shareConnector] getDataWithComman:cmd];
     [self writeCommandInQueueForManager];
}

- (void)writeCommandInQueueForManager
{
    // 汇总操作 方便以后维护，哇哈哈
    [[LFHardwareConnector shareConnector] writeCommandInQueue];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - BLE Delegate
////////////////////////////////////////////////////////////////////////////////

- (void)hardwareConnectorDiscoveredSensor:(LFPeripheral *)sensor
{
    
    ZDY_LOG(@"====================find sensor===================");
    ZDY_LOG(sensor.sensorName);
    ZDY_LOG(@"====================find sensor===================");
    
    //    if (self.shouldAutoConnectDevice && ![self isConnectingDeviceController]) {
    //        if ([SMDDevice isDeviceExistedWithUUID:sensor.identifier]) {
    //            [self getConnectionForSensor:sensor completion:^(BOOL success){} withGettingAuthroCompletion:^(BOOL success, id sensor){
    //            } timeoutBlock:^{
    //                
    //            }];
    //            return;
    //        }else {
    //            
    //        }
    //    }
    
    [self postNotificationWithId:SMDBLEDidDiscoverDeviceNotification object:sensor];
}

- (void)hardwareConnectorDidConnectedToPeripheral:(LFPeripheral *)lfPeripheral
{
    ZDY_LOG(@"====================Connected sensor===================");
    //    [SDDefaults sharedDefaults].shouldAutoConnectBlueTeeth = YES;
    
    if ([self.currentSensor.identifier isEqualToString:lfPeripheral.identifier]) {
        
        
        if (self.connectionCompletionBlock) {
            [self stopTimeoutTimer];
            self.connectionCompletionBlock(YES);
        }
        self.connectionCompletionBlock = nil;
    }
    
    [self postNotificationWithId:SMDBLEDidConnectedDeviceNotification object:lfPeripheral];
    
    // 记录最后连接的设备的Mac地址
    //    [SDDefaults sharedDefaults].lastConnectDeviceUUID = lfPeripheral.identifier;
    
    
}

- (void)hardwareConnectorDidDisconnectedToPeripheral:(LFPeripheral *)lfPeripheral {
    //TODO: disconnnect ble
    
    self.isAuthorizedConnection = NO;
    
    //警告 : 设备失去连接 !!
    
    [self postNotificationWithId:SMDBLEDidDisconnectedDeviceNotification object:lfPeripheral];
}


- (void)hardwareConnectorDidGetAuthroSuccess:(LFPeripheral *)lfPheripheral
{
    ZDY_LOG(@"=================== Get Auth Success ! ===================");
    ZDY_LOG(@"=================== Get Auth Success ! ===================");
    if (self.gettingAuthroCompletionBlock) {
        [self stopTimeoutTimer];
        self.isFirstConnectedDevice = NO;
        self.gettingAuthroCompletionBlock(YES, lfPheripheral);
        self.gettingAuthroCompletionBlock = nil;
    }
    
//    [self getFirmwareVersionWithCompletion:^(NSString *version) {
//        
//        NSString *version1 = [NSString stringWithFormat:@"-----Minus----- firmware version: %@", version];
//        ZDY_LOG(version1);
//        [self postNotificationWithId:SMDBLEDidConnectSuccess object:nil];
//        
//    } timeoutBlock:^{
//        
//        ZDY_LOG(@"-----Minus----- 获取固件版本超时...");
//        GL_ALERT_AFTER_E(@"获取固件版本超时");
//    }];
    
    self.isAuthorizedConnection = YES;
    
    [self postNotificationWithId:SMDBLEDidGetAuthroNotification object:lfPheripheral];
}

- (void)hardwareConnectorDidSetMonitorStateSuccess:(MONITOR_STATE)monitorState
{
    ZDY_LOG(@"================== Set Monitor Success ! ==============");
    ZDY_LOG(@"================== Set Monitor Success ! ==============");
    [self stopTimeoutTimer];
    if (self.startMonitorCompletionBlock) {
        if (monitorState == MONITOR_START) {
            ZDY_LOG(@"MONITOR_START");
            self.startMonitorCompletionBlock(YES);
        }else {
            self.startMonitorCompletionBlock(NO);
        }
        self.startMonitorCompletionBlock = nil;
    }
    
    if (self.stopMonitorCompletionBlock) {
        if (monitorState == MONITOR_STOP) {
            ZDY_LOG(@"MONITOR_STOP")
            self.stopMonitorCompletionBlock(YES);
        }else {
            self.stopMonitorCompletionBlock(NO);
        }
        self.stopMonitorCompletionBlock = nil;
    }
    
    [self postNotificationWithId:SMDBLEDidStartMonitor object:@(monitorState)];
}

- (void)hardwareConnectorGetAuthFail:(LFPeripheral *)lfPheripheral {
    ZDY_LOG(@"===================Get Auth Fail===================");
    ZDY_LOG(@"===================Get Auth Fail===================");
    [[LFHardwareConnector shareConnector] cancelPeripheral:lfPheripheral];
}

- (void)hardwareConnectorDidGetAllDataCount:(NSInteger)count
{
    NSLog(@"DataCount : %ld",(long)count);
    if (self.dataCountCompletionBlock) {
        [self stopTimeoutTimer];
        self.dataCountCompletionBlock(count);
        self.dataCountCompletionBlock = nil;
    }
    [self postNotificationWithId:SMDBLEDidGetDataCount object:@(count)];
}

- (void)hardwareConnectorDidReceiveCurrent:(CGFloat)current
{
    NSLog(@"------ Received Current : %0.1f", current);
    if (self.getMonitorBlock) {
        [self stopTimeoutTimer];
        self.getMonitorBlock(current);
    }
    [self postNotificationWithId:SMDBLEDidReceivedCurrentNotification object:@(current)];
}

- (void)hardwareConnectorDidReceiveVoltage:(CGFloat)voltage
{
    NSLog(@"------ Received Battery Voltage : %0.3f", voltage);
    NSLog(@"Received Battery Voltage : %0.3f", voltage);
    [self postNotificationWithId:SMDBLEDidReceivedVoltageNotification object:@(voltage)];
}

- (void)hardwareConnectorDidGetMonitorState:(MONITOR_STATE)monitorState
{
    NSLog(@"------ Received Monitor State : %d", monitorState);
    NSLog(@"Monitor State : %d", monitorState);
    if (self.getMonitorBlock) {
        [self stopTimeoutTimer];
        self.getMonitorBlock(monitorState);
        self.getMonitorBlock = nil;
    }
    
    [self postNotificationWithId:SMDBLEDidGetMonitorState object:@(monitorState)];
}

- (void)hardwareConnectorDidGetCurrentDatas:(NSArray *)array
{
    ZDY_LOG(@"------ Received Currents --------");
    ZDY_LOG(@"---------------------------------");
    ZDY_LOG(@"==========DidGetData=============");
    ZDY_LOG(@"------- Datas --------");
    NSString *str = [NSString stringWithFormat:@"arr%@",array];
    ZDY_LOG(str);
    
    [self postNotificationWithId:SMDBLEDidGetAllDatas object:array];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"获取设备动态电流值数组结果" object:array];
    
    
    if (self.getCurrentBlock && (array.count == 1)) {
        [self stopTimeoutTimer];
        self.getCurrentBlock([array[0] floatValue]);
        self.getCurrentBlock = nil;
        //        self.isGettingData = NO;//fix ll
    }
    
    if (self.getCurrentsBlock) {
        [self stopTimeoutTimer];
        self.getCurrentsBlock(array);
        self.getCurrentsBlock = nil;
        self.isGettingData = NO;
    }
}

- (void)hardwareConnectorDidReceiveCurrent:(CGFloat)current atIndex:(NSInteger)index
{
    //    NSLog(@"------ Received Currents For Device --------\n");
    //    NSLog(@"Current : %.1f   at Index : %d",current,(int)index);
    //    NSLog(@"--------------------------------------------\n");
    
    ZDY_LOG(@"------ Analysis CurrentsData For Device ");
    ZDY_LOG(@"AnalysisCurrentsData");
    NSLog(@"------ CurrentData : %.1f   at Index : %d  ",current,(int)index);
    [self postNotificationWithId:SMDBLEDidReceivedCurrentIndexNotification object:@{@"current":@(current),@"index":@(index)}];
}

- (void)hardwareConnectorDidGetFirmwareVersion:(NSString *)version
{
    NSLog(@"------ Received Firmware Version : %@", version);
    NSLog(@"Firmware Version : %@", version);
    
    if (self.getFirmwareVersionBlock)
    {
        [self stopTimeoutTimer];
        self.getFirmwareVersionBlock(version);
        self.getFirmwareVersionBlock = nil;
    }
}

- (void)stopAutoSearchDeviceInBackground
{
    [self.backgroundScaningTimer setFireDate:[NSDate distantFuture]];
}

@end
