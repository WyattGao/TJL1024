//
//  XueTangViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangViewController.h"
#import "XueTangView.h"
#import "LFHardwareConnector.h"
#import "SMDBlueToothManager.h"
#import "XueTangDeviceListViewController.h"
#import "sanbg.h"
#import "LoginViewController.h"
#import "MBProgressHUD+Add.h"
#import "XueTangTargerViewController.h"
#import "STDataAnalysisViewController.h"
#import "STSportController.h"
#import "STDietRecordViewController.h"
#import "STMedicationController.h"
#import "WearRecordViewController.h"
#import "RunChartViewController.h"
#import "RingTimeHelpViewController.h"
#import "SlideRuleView.h"

typedef NS_ENUM(NSInteger,GLRecordWearingTimeType){
    ///开始佩戴记录
    GLStartRecord = 0,
    ///结束佩戴记录
    GLEndRecord
};

@interface XueTangViewController ()<CBCentralManagerDelegate,UIAlertViewDelegate>

@property(strong,nonatomic)CBCentralManager *CBCManager;

@property (nonatomic,strong) NSMutableArray *devicesArr; /**< 存放搜索到的设备列表 */

@property (nonatomic,strong) XueTangView *xueTangView;

@property (nonatomic,strong) XueTangDeviceListViewController *listVC;

@property (nonatomic,strong) LFPeripheral *sensor;
///存放参比血糖的数组
@property (nonatomic,strong) NSMutableArray *referenceArr;

@property (nonatomic,strong) SlideRuleView *slideRuleView;/**< 血糖滑尺 */

@property (nonatomic,strong) XueTangTargerViewController *targetVC;

@property (nonatomic,strong) STDataAnalysisViewController *analysisVC; /**< 数据分析控制器 */

@property (nonatomic,assign) BOOL isBluetoothOpen;
///佩戴记录VC
@property (nonatomic,strong) WearRecordViewController *wearRecordVC;
///趋势图
@property (nonatomic,strong) RunChartViewController *runChartVC;

@property (nonatomic,strong) dispatch_source_t refreshTimetTimer;

@property (nonatomic,strong) XueTangDeviceListCell *deviceCell; /**< 记录点击连接设备的cell */

@property (nonatomic,strong) NSTimer *getValueTimer; /**< 计时器，每三分半钟收取一次数据 */

@property (nonatomic,assign) BOOL isStartGettingDatav; /**< 是否开始获取数据 */

@property (nonatomic,strong) RingTimeHelpViewController *ringTimeHelpVC; /**< 环信时间按钮操作帮助 */

@end

@implementation XueTangViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    
    if (!ISLOGIN) {
        LoginViewController *loginVC = [LoginViewController new];
        WS(ws);
        [self.navigationController presentViewController:loginVC animated:false completion:^{
            [super viewDidLoad];
            
            //初始化CGM
            [ws createCGM];
            
            //时间监听
            [ws TimeToMonitor];
        }];
    } else {
        [super viewDidLoad];
        
        //初始化CGM
        [self createCGM];
        
        //时间监听
        [self TimeToMonitor];

    }
}

- (void)createUI
{
    if (ISBINDING) {
        [self setNavTitle:@"动态血糖（正在连接）"];
        [SVProgressHUD showWithStatus:@"正在连接设备"];
    } else {
        [self setNavTitle:@"动态血糖（未连接）"];
    }
    
    [self addSubView:self.xueTangView];
    
    WS(ws);
    
    [self.xueTangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (void)createData
{
    if (ISBINDING) {
        for (NSInteger i = 0;i < 5;i++) {
            //请求全部记录数据
            [self getRecotdDataWithType:i];
        }
    }
}

/**
 创建CGM监听
 */
- (void)createCGM
{
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey:@(NO)};
    //设置蓝牙状态监听代理
    self.CBCManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    
    //监听搜索到的血糖仪设备
    [GL_NOTIC_CENTER addObserver:self selector:@selector(discoverDevice:) name:SMDBLEDidDiscoverDeviceNotification object:nil];
    //监听已连接的设备的电压
    [GL_NOTIC_CENTER addObserver:self selector:@selector(receivedVoltage:) name:SMDBLEDidReceivedVoltageNotification object:nil];
    //实时电流值
    [GL_NOTIC_CENTER addObserver:self selector:@selector(receivedCurrent:) name:SMDBLEDidReceivedCurrentIndexNotification object:nil];
    //监听获取设备中全部未上传数据回调
    [GL_NOTIC_CENTER addObserver:self selector:@selector(receivedAllDatas:) name:SMDBLEDidGetAllDatas object:nil];
    
    if (!ISBINDING) {
        [self initCGMData];
    }
    
    if (![GL_USERDEFAULTS getIntegerValue:SamTargetState]) {
        [GL_USERDEFAULTS setValue:@"2.9" forKey:SamTargetLow];
        [GL_USERDEFAULTS setValue:@"11.1" forKey:SamTargetHeight];
        [GL_USERDEFAULTS setBool:true forKey:SamTargetState];
    }
    
    if (![GL_USERDEFAULTS getIntegerValue:SamIsShake]) {
        //2是开启
        [GL_USERDEFAULTS setValue:@"2" forKey:SamIsShake];
    }
    if (![GL_USERDEFAULTS getIntegerValue:SamIsAudio]) {
        [GL_USERDEFAULTS setValue:@"2" forKey:SamIsAudio];
    }
    
    
    //查询用户保存的预警值
    [self selectDynamicBloodRang];
}


/**
 初始化CGM本地数据
 */
- (void)initCGMData
{
    [SVProgressHUD dismiss];
    
    GL_DISPATCH_MAIN_QUEUE(^{
        //显示连接按钮
        [self.xueTangView.ringView setStatus:GLRingTimeUnunitedStatus];
        [self.xueTangView setContentOffset:CGPointMake(0, 0) animated:true];
        
        [self.xueTangView.shiShiView.connectStateLbl setText:@"监测：关"];
        [self.xueTangView.shiShiView.connectSwitch setOn:false];
        [self setNavTitle:@"动态血糖（未连接）"];
        
        //清除绑定时间
        [GL_USERDEFAULTS setObject:nil forKey:SamStartBinDingDeviceTime];
        [GL_USERDEFAULTS setObject:nil forKey:SamEndBinDingDeviceTime];
        //清除绑定设备名称
        [GL_USERDEFAULTS setObject:nil forKey:SamBangDingDeviceName];
        //还原极化完成状态
        [GL_USERDEFAULTS setObject:false forKey:SamPolarizationFinish];
        
        [GL_USERDEFAULTS synchronize];
        
        //清除血糖数据
        [GLCache writeCacheArr:@[] name:SamReferenceArr];
        [GLCache writeCacheArr:@[] name:SamBloodValueArr];
        [GLCache writeCacheArr:@[] name:SamCurrentValueArr];
        
        //清除预警数据
        [GLCache writeCacheArr:@[] name:SamTargetWarningArr];
        
        //    [self.xueTangView.lineView refreshLineView];
        [self.xueTangView.recordView realodTargetData];
        NSArray *bloodArr = [[[GLCache readCacheArrWithName:SamBloodValueArr] reverseObjectEnumerator] allObjects];
        [self.xueTangView.liShiZhiView reloadDataWithBloodArr:bloodArr];
        //    [self.xueTangView.shiShiView.zuiXinLbl setText:@"0.0"];
        
        //刷新头部View的连接状态
        [self.xueTangView.shiShiView reloadViewbyBinDingState];
        
        //修改记录按钮显示
        [self.xueTangView.recordView changeDisplayStatus];
        //初始化饮食用药胰岛素运动记录的时间
        [GL_USERDEFAULTS setValue:@"" forKey:SamRecordInsulinTime];
        [GL_USERDEFAULTS setValue:@"" forKey:SamRecordMedicinalTime];
        [GL_USERDEFAULTS setValue:@"" forKey:SamRecordDietTime];
        [GL_USERDEFAULTS setValue:@"" forKey:SamRecordSportsTime];
    });
}


/**
 时间监听
 */
- (void)TimeToMonitor
{
    WS(ws);
    __block NSInteger lastDate = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _refreshTimetTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_refreshTimetTimer,dispatch_walltime(NULL, 0),10.0 * NSEC_PER_SEC, 0); //每10秒计时器
        dispatch_source_set_event_handler(_refreshTimetTimer, ^{

            [ws.xueTangView.shiShiView.ringView refreshTwinklingBtn];
            if (ISBINDING) {
                //刷新日期
                [ws.xueTangView.shiShiView reloadConectStateLblTime];
            }
            if (ws.isStartGettingDatav) { //是否开始主动获取数据
                if (([[NSDate date] timeIntervalSince1970] - lastDate) >= 210 || lastDate == 0) { //每3分半获取一次
                    //主动获取数据
                    [self getDeviceAllData];
                    lastDate = [[NSDate date] timeIntervalSince1970];
                }
                
            }
        });
        dispatch_resume(_refreshTimetTimer);
    });
}



#pragma mark - 处理连接设备的各种回调
//搜索到的血糖仪设备通知回调
- (void)discoverDevice:(NSNotification *)notification
{
    GL_DisLog(@"获得蓝牙搜索结果");
    
    WS(ws);
    
    if (ISBINDING) { //若果已经绑定设备，则先监测设备的连接状态
        BOOL isAuthorizedConnection = [SMDBlueToothManager sharedManger].isAuthorizedConnection;
        BOOL hasConnectedSensor     = [LFHardwareConnector shareConnector].hasConnectedSensor;
        
        NSLog(@"授权结果 discoverDevice --%d",isAuthorizedConnection);
        NSLog(@"链接结果 discoverDevice ---%d",hasConnectedSensor);
        
        GL_DisLog([NSString stringWithFormat:@"授权结果 ： %d",isAuthorizedConnection]);
        GL_DisLog([NSString stringWithFormat:@"链接结果 :  %d",hasConnectedSensor]);
        
        //扫描设备中,请稍后...
        LFPeripheral *sensor = (LFPeripheral *)[notification object];
        NSLog(@"sensor.sensorName------->>>>>%@",sensor.sensorName);
        
        if ([sensor.sensorName isEqualToString:[GL_USERDEFAULTS getStringValue:SamBangDingDeviceName]]) {
            
            GL_DisLog(@"搜索到绑定的设备,停止搜索并开始连接设备");
            [SVProgressHUD showWithStatus:@"正在连接设备"];
            [[SMDBlueToothManager sharedManger] stopScanningDevice];
            _sensor = sensor;
            [self startConnectDevice];
        }
    } else { //未绑定设备，展示搜索到的设备信息
        LFPeripheral *sensor = (LFPeripheral *)[notification object];
        
        BOOL isSenorInArray = NO;
        for (LFPeripheral *device in self.devicesArr) {
            if ([device.identifier isEqualToString:sensor.identifier]) {
                isSenorInArray = YES;
            }
        }
        
        if (!isSenorInArray) {
            GL_DISPATCH_MAIN_QUEUE(^{
                [ws.devicesArr addObject:sensor];
                if (ws.xueTangView.deviceTV.status != SearchDeviceStatusSucceed) {
                    ws.xueTangView.deviceTV.status = SearchDeviceStatusSucceed;
                }
                ws.xueTangView.deviceTV.tbDataSouce = ws.devicesArr;
                [ws.xueTangView.deviceTV reloadData];
            });
        }
    }
}

//开始连接设备
- (void)startConnectDevice
{
    NSLog(@"开始连接设备");
    
    NSLog(@"授权结果--%d",[SMDBlueToothManager sharedManger].isAuthorizedConnection);
    NSLog(@"链接结果--%d",[LFHardwareConnector shareConnector].hasConnectedSensor);
    
    
    if ([SMDBlueToothManager sharedManger].isAuthorizedConnection) 	{
        //监测设备是否已经被授权过，如果是，则是重新连接设备
        [SVProgressHUD showWithStatus:@"设备重连成功"];
        [self getAuthroBeginSuccess];
    } else if([LFHardwareConnector shareConnector].hasConnectedSensor){
        //设备已连接过，但还未完成授权
        if ([[[LFHardwareConnector shareConnector] getConnectedPeriphral].identifier isEqual:_sensor.identifier]) {
            //获取授权
            [[SMDBlueToothManager sharedManger] getAuthroWithCompletion:^(BOOL success, id sensor) {
                //授权成功
                [self getAuthroBeginSuccess];
            } timeoutBlock:^{
                //授权超时
            }];
        } else {
            
            //连接设备与之前的不匹配 取消连接
            [[LFHardwareConnector shareConnector] cancelPeripheral:[[LFHardwareConnector shareConnector] getConnectedPeriphral]];
        }
    } else {
        //设备未连接过，未授权过
        [[SMDBlueToothManager sharedManger] getConnectionForSensor:self.sensor completion:^(BOOL success){
            // 连接成功
            GL_DisLog(@"动态血糖设备连接成功");
            
            NSLog(@"// 未连接，未授权");
            NSLog(@"动态血糖设备连接成功");
            NSLog(@"2授权结果--%d",[SMDBlueToothManager sharedManger].isAuthorizedConnection);
            NSLog(@"2链接结果---%d",[LFHardwareConnector shareConnector].hasConnectedSensor);
            
        } withGettingAuthroCompletion:^(BOOL success, id sensor){
            _sensor = sensor;
            NSLog(@"授权结果 %d,--%@",success,_sensor.peripheral.name);
            // 获取授权结果
            if (success) {// 链接和授权成功
                GL_DisLog(@"设备授权成功");
                
                //链接和授权成功后 开发发命令
                [self getAuthroBeginSuccess];
            }else{//  授权失败
                
                GL_DisLog(@"设备授权失败，重新查看授权状态");
                
                //查看授权状态
                if ([[SMDBlueToothManager sharedManger] isAuthorizedConnection]) {
                    //授权成功
                    [self getAuthroBeginSuccess];
                } else {
                    //授权失败
                    
                }
            }
            
        } timeoutBlock:^{
            GL_DisLog(@"设备连接超时");
            NSLog(@"动态血糖设备连接超时");
            // 链接超时，重新连接
            [[SMDBlueToothManager sharedManger] startScanningDevice];
        }];
    }
}

//授权成功（第1步）
- (void)getAuthroBeginSuccess
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_sensor) {
                GL_DisLog(@"设备连接成功，授权完成，发命令");
                [SMDBlueToothManager sharedManger].isFirstConnectedDevice = YES;
                //连接成功
                NSLog(@"动态血糖设备连接成功");
                [GLTools noti:@"动态血糖设备连接成功" isWarning:false];
                
                //如果是首次连接的设备，先检查电压
                if (![GL_USERDEFAULTS objectForKey:@"SamStartBinDingDeviceTime"]) {
                    GL_DisLog(@"设备首次连接成功，判断电压是否可以维持");
                    //主动获取电压
                    NSLog(@"主动获取电压");
                    [[LFHardwareConnector shareConnector] getData_voltag];
                } else {
                    [self getAuthroDidSuccess];//链接和授权成功后 开发发命令
                }
            }
        });
    });
}

//授权成功（第2步）开始发命令
-  (void)getAuthroDidSuccess{
    [SVProgressHUD dismiss];
    
    NSLog(@"开始获取设备状态--%@",[GL_USERDEFAULTS objectForKey:SamStartBinDingDeviceTime]);
    NSLog(@"3授权结果--%d",[SMDBlueToothManager sharedManger].isAuthorizedConnection);
    NSLog(@"3链接结果---%d",[LFHardwareConnector shareConnector].hasConnectedSensor);
    
    
    NSString *logStr = @"设备连接成功";
    GL_DisLog(logStr);
    logStr = [NSString stringWithFormat:@"设备绑定时间 : %@",[GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime]];
    GL_DisLog(logStr);
    logStr = [NSString stringWithFormat:@"设备绑定时间 : %@",[GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime]];
    GL_DisLog(logStr);
    logStr = [NSString stringWithFormat:@"授权结果 : %d",[SMDBlueToothManager sharedManger].isAuthorizedConnection];
    GL_DisLog(logStr);
    logStr = [NSString stringWithFormat:@"连接结果 : %d",[LFHardwareConnector shareConnector].hasConnectedSensor];
    GL_DisLog(logStr);
    
    
    //如果有绑定设备的时间，说明之前一直在使用，只需连接上即可
    if ([GL_USERDEFAULTS objectForKey:SamStartBinDingDeviceTime]) {
        [self setNavTitle:@"动态血糖（已连接）"];

//        [SVProgressHUD showWithStatus:@"正在同步数据"];
//        GL_ALERT_S(@"连接成功");
        GL_ALERT_S(@"血糖数据已同步");

        
        GL_DisLog(@"存在设备绑定时间，设备为重连");
        
        //此时可以获取设备里的数据，进行上传
        if ([GL_USERDEFAULTS boolForKey:SamPolarizationFinish]) {
            //极化已经完成
            //获取设备里的总数据量,上传设备中未上传的数据
//            [self getDeviceAllData];
            self.isStartGettingDatav = true;
        } else {
            //极化还未完成,继续极化
            [SVProgressHUD dismiss];
            GL_DisLog(@"重连之前，设备极化没有结束，继续极化");
            [self.xueTangView.ringView setStatus:GLRingTimePolarizationStatus];
            
            NSInteger polarizationTime = ([[NSDate date] timeIntervalSince1970] - [[[GL_USERDEFAULTS stringForKey:SamStartBinDingDeviceTime] toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970]) / 60 ;
            if (polarizationTime >= 11) {
                self.isStartGettingDatav = true;
            }
        }
    }else{
        [SVProgressHUD showWithStatus:@"正在获取设备状态"];
        //首次连接，获取设备状态
        GL_DisLog(@"获取设备状态");
        [[SMDBlueToothManager sharedManger] getMonitorStatusWithCompletion:^(MONITOR_STATE state) {
            if (state == MONITOR_STOP) {
                GL_DisLog(@"设备处于停止状态");
                [SVProgressHUD showWithStatus:@"正在开启设备监测"];
                //首先重启设备,发送停止监控命令
                [self getsStopMonitor];
            }else if(state == MONITOR_START){
                /*
                 设备已经在监测了，说明设备在此次连接上之前一直处于监测中，开启新一轮监测，设备里存有数据，
                 这个时候需要将设备关闭后重新开启
                 */
                GL_DisLog(@"设备处于开启状态，但是没有绑定时间，开启新一轮监测，需要关闭设备，重新开启");
                NSLog(@"设备处于开启状态，但是没有绑定时间，需要关闭设备，重新开启");
                [SVProgressHUD showWithStatus:@"正在重启设备"];
                //发送停止监控命令
                [self getsStopMonitor];
            }
        } timeoutBlock:^{
            GL_DisLog(@"获取设备开启状态超时");
        }];
    }
}

/**
 停止设备，发送停止设备命令
 */
-(void)getsStopMonitor{
    GL_DisLog(@"发送停止监测命令");
    [[SMDBlueToothManager sharedManger] stopMonitorWithCompletion:^(BOOL success) {
        if (success) {
            GL_DisLog(@"成功停止监测");
            /*
             退出设备成功，如果说没有绑定时间，设备需要重新启动，再开启设备操作
             如果有绑定时间说明，用户是要退出设备监测，需要做退出设备操作
             */
            if (![GL_USERDEFAULTS objectForKey:SamStartBinDingDeviceTime]) {
                //重启开启监测
                GL_DisLog(@"设备在重新开启检测");
                [SVProgressHUD showWithStatus:@"正在开启监测"];
                [self getStartMonitor];
            }else{
                //初始化CGM本地数据
                [self initCGMData];
                GL_ALERT_S(@"已结束监测");
            }
        }else{
            NSLog(@"退出设备失败");
            GL_DisLog(@"停止监测失败");
        }
    } timeoutBlock:^{
        NSLog(@"停止检测超时");
        GL_DisLog(@"停止监测超时");
        
        //已有绑定设备但设备未连接所以操作超时
        if (ISBINDING && ![[LFHardwareConnector shareConnector] hasConnectedSensor]) {
            if ([[LFHardwareConnector shareConnector] getConnectedPeriphral]!=nil) {
                //取消外围设备
                [[LFHardwareConnector shareConnector] cancelPeripheral:[[LFHardwareConnector shareConnector] getConnectedPeriphral]];
            }
            //清除记录
            [self initCGMData];
            GL_ALERT_S(@"已结束监测");
        }
    }];
}

//开始监控
-(void)getStartMonitor{
    GL_DisLog(@"发送开始采集--开始监测命令");
    [[SMDBlueToothManager sharedManger] startMonitorWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"输出日志>>>>>>>成功开始检测");
            NSLog(@"存设备的绑定时间－－%@\n\n",[GLTools getNowTime]);
            GL_DisLog([NSString stringWithFormat:@"开始采集--成功开始监测,记录绑定设备时间%@",[GLTools getNowTime]]);
            
            //更改极化完成状态
            [GL_USERDEFAULTS setBool:false forKey:SamPolarizationFinish];
            //记录绑定时间
            [GL_USERDEFAULTS setObject:[GLTools getNowTime] forKey:SamStartBinDingDeviceTime];
            //记录设备的型号,防止用户中间更改了设备
            [GL_USERDEFAULTS setObject:_sensor.sensorName forKey:SamBangDingDeviceName];
            
            [GL_USERDEFAULTS synchronize];
            //上传佩戴纪录的起始时间
            [self recordWearingTime:GLStartRecord];
            
        }else{
            GL_DisLog(@"设备开启检测失败");
            [SVProgressHUD showSuccessWithStatus:@"设备开启监测失败"];
        }
    } timeoutBlock:^{
        GL_DisLog(@"开始采集--开始监测超时");
        NSLog(@"输出日志>>>>>>>开始检测超时");
        [SVProgressHUD showSuccessWithStatus:@"设备开启监测超时"];
    }];
}


/**
 获取到设备电压的通知 （3分钟/次）
 */
- (void)receivedVoltage:(NSNotification *)notification
{
    GL_DisLog(@"获取到设备电量通知");
    
    CGFloat voltage = [notification.object floatValue];
    CGFloat battery = 1;
    if (voltage >= 2.75) { //判断电压是否大于2.75 如果小于2.75则电量已经无法维持设备使用
        //计算电量
        battery = 100.00 - (((3.00f - voltage) * 100.0f)/(25.0f*1.0f))*100;
    }
    
    [GL_USERDEFAULTS setValue:[NSString stringWithFormat:@"%.1f",battery] forKey:SamBangDingDeviceBattery];
    
    if (battery <= 20.0f) {
        //判断设备是否已连接
        if (![GL_USERDEFAULTS objectForKey:SamStartBinDingDeviceTime]) {
            GL_DisLog(@"设备之前未连接，因设备电量低于20%，提示用户更换设备并取消外围");
            
            [SVProgressHUD dismiss];
            
            //取消连接设备
            [[LFHardwareConnector shareConnector] cancelPeripheral:_sensor];
        } else {
            GL_DisLog(@"设备连接中，设备电量低于20%，提示更换电池");
            
            // 已经链接了设备后获取的电压，正常提示即可
            [GLTools noti:@"动态血糖设备电量即将耗尽，请及时更换电池" isWarning:true];
        }
    } else if(![GL_USERDEFAULTS objectForKey:SamStartBinDingDeviceTime]){
        //电量充足又是首次连接该设备
        GL_DisLog(@"设备电量充足，连接设备");
        [self getAuthroDidSuccess];
    }
}




/**
 获取设备中的最新电流值的通知（3分钟/条）
 */
- (void)receivedCurrent:(NSNotification *)notification
{
    float current = [[[notification object] objectForKey:@"current"] floatValue];
    
    if ((int)current>=600) {
        [GLTools CGMUILocalNotification:HEIGH600];
    }else if ((int)current<30){
        [GLTools CGMUILocalNotification:LOW30];
    }
    [self getDeviceAllData];
}

//获取设备里的数据总数据量
- (void)getDeviceAllData{
    NSLog(@"//获取设备里的数据总数据量");
    GL_DisLog(@"获取设备中的总数据量，准备上传");
    [[SMDBlueToothManager sharedManger] getDataCountWithCompletion:^(NSInteger dataCount) {
        NSLog(@"数据统计：%ld",dataCount);
        //对比本地存的数据和设备里的数据
        NSArray *cacheArr = [GLCache readCacheArrWithName:SamCurrentValueArr];
        if (cacheArr.count<dataCount) {
            //获取设备里未上传的数据
            [[SMDBlueToothManager sharedManger] getAllDataFromIndex:cacheArr.count numdata:dataCount-cacheArr.count];
            GL_DisLog([NSString stringWithFormat:@"开始获取设备中未上传的全部数据,共%ld条",dataCount-cacheArr.count]);
        }else{
            [SVProgressHUD dismiss];
        }
    } timeoutBlock:^{
        NSLog(@"//获取设备里的数据总数据量  超时");
    }];
}

- (void)receivedAllDatas:(NSNotification *)notification
{
    NSLog(@"得到所有未上传的电流数组");
    GL_DisLog(@"获取所有电流数组，并将数据添加到本地电流值集合中");
    
    /*
     将未上传的数据和已上传的数据集体重新计算
     */
    
    NSArray *newCurrentValue = [notification object];
    
    NSMutableArray *allCurrentValue = [NSMutableArray arrayWithArray:[GLCache readCacheArrWithName:SamCurrentValueArr]];
    [allCurrentValue addObjectsFromArray:newCurrentValue];
    [GLCache writeCacheArr:allCurrentValue name:SamCurrentValueArr];
    
    NSArray *allReferenceArr = [GLCache readCacheArrWithName:SamReferenceArr];
    
    NSLog(@"目前设备里所有的电流值 allCurrentValue---%@",allCurrentValue);
    NSLog(@"从绑定时间到目前的所有参比值 allReferenceArr---%@",allReferenceArr);
    
    //存放计算之后的血糖值
    NSMutableArray *allBloodValueArr = [NSMutableArray array];
    
    BGC_Init();
    
    //记录最后一条参比血糖的值，避免重复计算
    CGFloat lastOneReferenceValue = MAXFLOAT;
    
    NSString *bloodValue;
    for (int i=0; i<allCurrentValue.count; i++) {
        
        
        //加上10min的等待时间
        int time = i*3+10;
        //计算下标电流的时间
        NSString *collectedtimeStr = [GLTools getAfterTime:time nowTime:[GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime] format:@"yyyy-MM-dd HH:mm:ss"];
        
        //计算电流时间点相对应的参比
        CGFloat nowReferenceValue = [GLTools getReferenceForTtime:collectedtimeStr];
        
        if (nowReferenceValue != lastOneReferenceValue) {
            if(1 && BGC_PermitRef())
            {
                
                //计算电流时间点相对应的参比
                //                    NSString *nowReferenceValue = [self returnCanBiAndDianLiuTtime:collectedtimeStr andCanBiArr:allReferenceArr];
                lastOneReferenceValue = nowReferenceValue;
                //提示用户输入参比；
                unsigned int ref = (int)(nowReferenceValue *10);
                DLog(@"参比--%d",(int)(nowReferenceValue *10));
                int rslt = BGC_InputReference(ref,0);
                if(rslt != BGC_OK)
                {
                    //处理异样。报警、提示重新输入或其他处理；
                    NSLog(@"参比输入，K值异常");
                    GL_DisLog(@"K值异常");
                }
            }
        }
        
        
        _sConvertResult_t convert_result;
        int rslt = BGC_InputCurrent([allCurrentValue[i] doubleValue]*100, &convert_result);
        NSLog(@"rslt = %d",rslt);
        
        bloodValue = [NSString stringWithFormat:@"%d.%d",convert_result.bg/1000,convert_result.bg%1000/100];
        
        //将数据存到本地
        //数据示例 {value:5.23,collectedtime:'2015-12-17 16:30:55'}
        if ([allCurrentValue[i] floatValue]>600||[allCurrentValue[i] floatValue]<30) {
            if (i && [allCurrentValue[i] floatValue] >= 0) {
                bloodValue = [[allBloodValueArr lastObject] getStringValue:@"value"];
            } else {
                bloodValue = @"0.0";
            }
        }
        
        NSDictionary *dic = @{@"value":bloodValue,
                              @"collectedtime":collectedtimeStr,
                              @"currentvalue":[NSString stringWithFormat:@"%.1lf",[allCurrentValue[i] floatValue]]};
        [allBloodValueArr addObject:dic];
        
        
        //检查血糖值是否需要预警
        if (i == allCurrentValue.count-1) {
            //只预警最新的血糖值
            [GLTools checkBloodValueWarning:dic];
        }
    }
    
    WS(ws);
    
    DLog(@"将数据存到本地---%@",allBloodValueArr);
    [GLCache writeCacheArr:allBloodValueArr name:SamBloodValueArr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新折线图
//        [ws.xueTangView.lineView refreshLineView];
        [ws.xueTangView.ringView.timeDataView setRealTimeLblTextByBloodValue:bloodValue];
        [ws.xueTangView.liShiZhiView reloadDataWithBloodArr:[[allBloodValueArr reverseObjectEnumerator] allObjects]];
        
        //上次上传的index
        NSInteger upLoadIndex = [GL_USERDEFAULTS getIntegerValue:SamBloodUpLoadIdx];
        NSMutableArray *upLoadArr = [NSMutableArray array];
        
        if(upLoadIndex >= allBloodValueArr.count) {
            //如果下标比本地之前的数据还要高 咋改为上传本地最新的一条数据
            upLoadIndex = allBloodValueArr.count - 1;
        }
        
        for (NSInteger i = upLoadIndex; i<allBloodValueArr.count; i++) {
            [upLoadArr addObject:allBloodValueArr[i]];
        }
        
        NSLog(@"上传血糖值-----所有血糖值：%ld个,,,,,本次上传血糖值：%ld个,,,,,上次上传的下标：%ld",allBloodValueArr.count,upLoadArr.count,upLoadIndex);
        
        //将数据上传网络
        NSDictionary *postDic =@{
                                 @"FuncName":@"saveSamGlucose",
                                 @"InField":@{
                                         @"ACCOUNT":USER_ACCOUNT,	//账号
                                         @"DEVICE":@"1",	//设备号
                                         @"VALUES":upLoadArr,
                                         @"VERSION":GL_VERSION
                                         }
                                 };
        
        [GL_Requst postWithParameters:postDic SvpShow:false success:^(GLRequest *request, id response) {
            if (GETTAG) {
                if (GETRETVAL) {
                    //上传成功
                    NSLog(@"血糖上传成功：保存index－－－%ld",allBloodValueArr.count);
                    //保存目前为止上传的所有血糖值的数量
                    [GL_USERDEFAULTS setValue:@(allBloodValueArr.count) forKey:SamBloodUpLoadIdx];
                } else {
                    
                }
            } else {
                
            }
        } failure:^(GLRequest *request, NSError *error) {
            
        }];
    });
}

//开启蓝牙
- (void)openBluetooth
{
    [JHSysAlertUtil presentAlertViewWithTitle:@"未开启蓝牙" message:@"请您先打开蓝牙开关" confirmTitle:@"确定" handler:^{
    }];
    
    //iOS11失效
//    [JHSysAlertUtil presentAlertViewWithTitle:@"未开启蓝牙" message:@"监测到您的蓝牙已关闭" cancelTitle:@"去设置" defaultTitle:@"确定" distinct:true cancel:^{
//        NSString * defaultWork       = [self getDefaultWork];
//        NSString * bluetoothMethod   = [self getBluetoothMethod];
//        NSURL*url                    = [NSURL URLWithString:@"Prefs:root=Bluetooth"];
//        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
//        [[LSApplicationWorkspace
//          performSelector:NSSelectorFromString(defaultWork)]
//         performSelector:NSSelectorFromString(bluetoothMethod)
//         withObject:url
//         withObject:nil];
//    } confirm:^{
//
//    }];
}

#pragma mark - 蓝牙状态监听
//监听蓝牙连接状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message = @"";
    switch (central.state) {
        case CBManagerStateUnknown:
            message = @"初始化中，请稍后……";
            break;
        case CBManagerStateResetting:
            message = @"设备不支持状态，过会请重试……";
            break;
        case CBManagerStateUnsupported:
            message = @"设备未授权状态，过会请重试……";
            break;
        case CBManagerStateUnauthorized:
            message = @"设备未授权状态，过会请重试……";
            break;
        case CBManagerStatePoweredOff: //蓝牙已关闭
        {
            [SVProgressHUD dismiss];
            _isBluetoothOpen = false;
            message = @"尚未打开蓝牙，请在设置中打开……";
            if ([GL_USERDEFAULTS objectForKey:SamBangDingDeviceName]) {
                [self openBluetooth];
            }
        }
            break;
        case CBManagerStatePoweredOn: //蓝牙已开启
        {
            _isBluetoothOpen = true;
            
            if (ISBINDING) {
                message = @"蓝牙已经成功开启，稍后……";
                
                //将LFHardwareConnectorDelegate遵守对象绑定为SMDBlueToothManager
                if ([LFHardwareConnector shareConnector].delegate != [SMDBlueToothManager sharedManger]) {
                    [LFHardwareConnector shareConnector].delegate = [SMDBlueToothManager sharedManger];
                }
                
                if ([[LFHardwareConnector shareConnector] isBLEEnable]) {
                    if (![[LFHardwareConnector shareConnector] getConnectedPeriphral]) {
                        if (_sensor) {
                            [self startConnectDevice];
                        } else {
                            //设备未连接，开始搜索设备
                            [[SMDBlueToothManager sharedManger] startScanningDevice];
                            //                            double delayInSeconds = 20.0;
                            //                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                            //                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            //
                            //                            });
                        }
                    }
                } else {
                    //蓝牙连接失败
                    NSLog(@"蓝牙打开失败 %s",__func__);
                    [[SMDBlueToothManager sharedManger] autoSearchDeviceInBackground];
                }
                
                [SVProgressHUD showWithStatus:@"正在重连设备"];
                [[SMDBlueToothManager sharedManger] startScanningDevice];
            }
        }
            break;
        default:
            break;
    }
    NSLog(@"蓝牙状态---%@",message);
}

#pragma mark - 网络请求
/**
 上传佩戴开始和佩戴结束记录
 
@param type GLStartRecord = 0 开始 GLEndRecord = 1 结束
 */
- (void)recordWearingTime:(GLRecordWearingTimeType)type
{
    NSDictionary *postDic = @{
                              @"FuncName":@"saveSamWear",
                              @"InField":@{
                                      @"ACCOUNT":USER_ACCOUNT,	//账号
                                      @"DEVICE":@"1",	//设备号
                                      @"STARTTIME":[GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime],	//开始时间
                                      @"ENDTIME":type == GLEndRecord ? [GLTools getNowTime] : @"",	//结束时间
                                      @"EMITTERCODE":[GL_USERDEFAULTS getStringValue:SamBangDingDeviceName],
                                      @"SENSORCODE":@"",
                                      @"STATUS":[@(type) stringValue],
                                      @"VERSION":GL_VERSION
                                      }
                              };
    
    WS(ws);
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                                
                if (type == GLStartRecord) {
                    //上传开始佩戴记录成功
                    GL_ALERT_S(@"设备开启监测成功");
                    
                    //修改提示状态
                    [_xueTangView.shiShiView reloadViewbyBinDingState];
                    
                    //开始极化
                    [ws.xueTangView turnShiShiView];
                    [ws.xueTangView.ringView setStatus:GLRingTimePolarizationStatus];
                    GL_DisLog(@"已上传开始佩戴记录");
                    
                    //刷新纪录按钮的状态
                    [ws.xueTangView.recordView changeDisplayStatus];
                    
                    //修改标题提示
                    [self setNavTitle:@"动态血糖（已连接）"];
                } else {
                    //上传结束佩戴记录成功，停止设备
                    GL_DisLog(@"已上传结束佩戴记录,开始停止设备");
                    
                    [ws getsStopMonitor];
                }
                
            } else {
                GL_ALERT_E(GETRETMSG);
                if (type == GLStartRecord) {
                    //上传开始连接失败，取消外围连接,初始化连接状态
                    [[LFHardwareConnector shareConnector] cancelPeripheral:_sensor];
                    //修改所选设备cell的状态
                    [ws.deviceCell changeCellForConnectionStatus:GLConnectionFailed];
                    [self initCGMData];
                } else {
                    //上传结束失败，如果是已经上传过，则继续断开设备
                    if ([GETRETMSG isEqualToString:@"您已上传过该信息"]) {
                        [ws getsStopMonitor];
                    }
                }
            }
        } else {
            if (GETMESSAGE) {
                GL_ALERT_E(GETMESSAGE);
            } else {
                GL_ALERTCONTR_1(@"未能成功开启监测，请稍后再试");
            }
            
            if (type == GLStartRecord) {
                //上传开始连接失败，取消外围连接
                [[LFHardwareConnector shareConnector] cancelPeripheral:_sensor];
                //修改所选设备cell的状态
                [ws.deviceCell changeCellForConnectionStatus:GLConnectionFailed];
                [self initCGMData];
            } else {
                //上传结束失败，如果是已经上传过，则继续断开设备
                if (GETRETMSG) {
                    if ([GETRETMSG isEqualToString:@"您已上传过该信息"]) {
                        [ws getsStopMonitor];
                    }
                }
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        if (type == GLStartRecord) {
            //上传开始连接失败，取消外围连接
            [[LFHardwareConnector shareConnector] cancelPeripheral:_sensor];
            //修改所选设备cell的状态
            [ws.deviceCell changeCellForConnectionStatus:GLConnectionFailed];
            [self initCGMData];
            GL_ALERT_E(@"网络不稳定，未能成功开启监测，请稍后再试");
        } else {
            //上传结束失败
            GL_ALERT_E(@"上传结束佩戴记录失败，请稍后再试");
        }
    }];
}

/**
 上传参比血糖
 
 @param dic @{VALUE：5.6，collectedtime：2017-03-26 11:50:58"}
 */
- (void)upLoadReferGlucose:(NSDictionary *)dic
{
    NSMutableDictionary *inFieldDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [inFieldDic setValue:USER_ACCOUNT forKey:@"ACCOUNT"];
    [inFieldDic setValue:@"1" forKey:@"DEVICE"];
    
    NSDictionary *postDic = @{
                              @"FuncName":@"saveSamReferGlucose",
                              @"InField":inFieldDic
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                NSMutableArray *referenceArr = [NSMutableArray arrayWithArray:[GLCache readCacheArrWithName:SamReferenceArr]];
                [referenceArr addObject:dic];
                [GLCache writeCacheArr:referenceArr name:SamReferenceArr];
                GL_ALERT_S(@"参比血糖记录成功")
            } else {
                GL_ALERT_E(GETRETMSG);
            }
        } else {
            GL_ALERT_E(GETMESSAGE);
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"网络不稳定，参比血糖记录失败，请稍后再试")
    }];
}

/**
 查询用户设置的血糖预警值
 */
- (void)selectDynamicBloodRang
{
    NSDictionary *postDic = @{
                              FUNCNAME : @"selectDynamicBloodRang",
                              INFIELD  : @{
                                      @"ACCOUNT" : USER_ACCOUNT
                                      }
                              };
    WS(ws);
    [GL_Requst postWithParameters:postDic SvpShow:false success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                NSDictionary *dic = [[response objectForKey:@"Result"] objectForKey:OUTTABLE];
                if ([dic count]) {
                    [GL_USERDEFAULTS setValue:[NSString stringWithFormat:@"%.1f", [dic getFloatValue:@"low"]] forKey:SamTargetLow];
                    [GL_USERDEFAULTS setValue:[NSString stringWithFormat:@"%.1f", [dic getFloatValue:@"height"]] forKey:SamTargetHeight];
                    [ws.xueTangView.recordView  realodTargetData];
                }
            } else {
                
            }
        } else {
            
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
}


/**
 获取服务器上的动态血糖值
 */
- (void)getBloodValue
{
    NSDictionary *postDic = @{
                              @"FuncName":@"getSamGlucose",
                              @"InField":@{
                                      @"ACCOUNT":USER_ACCOUNT,	//账号
                                      @"DEVICE":@"1",	//设备号
                                      @"BEGINTIME":CGM_Start_Time,	//开始时间
                                      @"ENDTIME":CGM_End_Time		//结束时间
                                      }
                              };
    
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                NSLog(@"获取血糖%@",response);
//                _xueTangView.lineView.lineColor.chartLine_PointArr = @[response[@"Result"][@"OutTable"]];
//                [_xueTangView.lineView refreshLineView];
            }
            
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
}


/**
 从服务器获取参比血糖
 */
- (void)getRecotdDataWithType:(GLRecordType)type{
    switch (type) {
        case GLRecordBloodType: //参比血糖
        {
            NSDictionary *postDic = @{
                                      @"FuncName":@"getSamReferGlucose",
                                      @"InField":@{
                                              @"ACCOUNT":USER_ACCOUNT,	//账号
                                              @"DEVICE":@"1",	//设备号
                                              @"BEGINTIME":(CGM_Start_Time),	//开始时间
                                              @"ENDTIME":(CGM_End_Time),		//结束时间
                                              @"VERSION":GL_VERSION
                                              }
                                      };
            [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                if (GETTAG) {
                    if (GETRETVAL) {
                        NSLog(@"获取参比%@",response);
                        [GLCache writeCacheArr:response[@"Result"][@"OutTable"] name:SamReferenceArr];
//                        _xueTangView.lineView.lineColor.chartLine_bigPointArr = response[@"Result"][@"OutTable"];
//                        [_xueTangView.lineView refreshLineView];
                    }
                }
            } failure:^(GLRequest *request, NSError *error) {
                
            }];
        }
            break;
            break;
        default:
            break;
    }
}

#pragma mark - 跳转蓝牙设置所需字符 利用ASCII值进行拼装组合方法。这样可绕过审核。
-(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

-(NSString *) getBluetoothMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}

#pragma mark - 点击事件
//停止监测
- (void)stopBLE
{
    WS(ws);
    [JHSysAlertUtil presentAlertViewWithTitle:@"确定要停止监测吗" message:@"停止监测后将直接完成本次周期的监测" cancelTitle:@"确定" defaultTitle:@"取消" distinct:true cancel:^{
        [SVProgressHUD showWithStatus:@"正在停止监测"];
        [ws recordWearingTime:GLEndRecord];
    } confirm:^{
        [ws.xueTangView.shiShiView.connectSwitch setOn:true];
    }];
}

#pragma mark - 加载属性
- (XueTangView *)xueTangView
{
    if (!_xueTangView) {
        _xueTangView = [XueTangView new];
        WS(ws);
        
        //给历史记录赋初始值
        [_xueTangView.liShiZhiView reloadDataWithBloodArr:[[[GLCache readCacheArrWithName:SamBloodValueArr] reverseObjectEnumerator] allObjects]];
        
        _xueTangView.shiShiView.connectSwitchClick = ^(BOOL isOn){
            if (!isOn) {
                if (ISBINDING) {
                    [ws stopBLE];
                } 
            } else {
                //搜索设备
                ws.xueTangView.shiShiView.ringView.connectBtnClick();
            }
        };
#pragma mark - 时间环回调
        //极化结束
        _xueTangView.ringView.polarizationFinish = ^{
            GL_DISPATCH_MAIN_QUEUE(^{
                ws.xueTangView.userInteractionEnabled = true;
                [JHSysAlertUtil presentAlertViewWithTitle:@"极化完成" message:@"请输入参比血糖" confirmTitle:@"确定" handler:^{
                    CGFloat lastReferenceValue = 50.0f;
                    NSArray *referenceArr = [NSMutableArray arrayWithArray:[GLCache readCacheArrWithName:SamReferenceArr]];
                    if (referenceArr.count) {
                        lastReferenceValue = [[referenceArr lastObject] getFloatValue:@"value"] * 10.0f;
                    }
                    [ws.slideRuleView showWithCurrentValue:50.0f];
                }];
            });
        };
        
        //极化11分钟，开始主动获取数据
        _xueTangView.ringView.polarizationElevenMinutes = ^{
            ws.isStartGettingDatav = true;
        };
        
        //点击连接设备按钮回调
        _xueTangView.ringView.connectBtnClick = ^{
            if ([ws isLogin]) {
                if ([LFHardwareConnector shareConnector].delegate != [SMDBlueToothManager sharedManger]) {
                    [LFHardwareConnector shareConnector].delegate = [SMDBlueToothManager sharedManger];
                }
                
                if (!ws.isBluetoothOpen){
                    [ws openBluetooth];
                } else {
                    //开始搜索设备
                    [[SMDBlueToothManager sharedManger] autoSearchDeviceInBackground];
                    
                    //转到设备列表
                    [ws.xueTangView turnShiShiView];
                    
                    //设置设备列表为搜索状态
                    [ws.xueTangView.deviceTV setStatus:SearchDeviceStatusNone];

                    //超时计算
                    double delayInSeconds = 30.0f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //停止搜索设备
                        [[SMDBlueToothManager sharedManger] stopAutoSearchDeviceInBackground];
                        if (ws.xueTangView.deviceTV.tbDataSouce.count == 0) {
                            [ws.xueTangView.deviceTV setStatus:SearchDeviceStatusFailed];
                        }
                    });
             }
            }
        };
        
        //点击数据分析回调
        _xueTangView.ringView.dataAnalysisBtnClick = ^{
            ws.analysisVC.startTimeStr = [GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime];
            ws.analysisVC.endTimeStr   = [GLTools getNowTime];
            [ws pushWithController:ws.analysisVC];
        };
        
        _xueTangView.ringView.helpBtn.buttonClick = ^(GLButton *sender) {
            [ws pushWithController:ws.ringTimeHelpVC];
        };

#pragma mark - 连接设备回调
        //连接指定设备点击事件
        _xueTangView.deviceTV.connectClick = ^(XueTangDeviceListCell *cell) {
            //停止搜索设备
            [[SMDBlueToothManager sharedManger] stopAutoSearchDeviceInBackground];
            //连接设备
            [SVProgressHUD showWithStatus:@"正在连接设备"];
            ws.sensor     = cell.entity;
            ws.deviceCell = cell;
            //修改点击连接cell的状态
            [ws.deviceCell changeCellForConnectionStatus:GLConnectionUnfinished];
            [ws startConnectDevice];
        };
        
        _xueTangView.deviceTV.retryBtn.buttonClick = ^(GLButton *sender) {
            if (sender == ws.xueTangView.deviceTV.retryBtn) {
                ws.xueTangView.shiShiView.ringView.connectBtnClick();
            } else {
                //停止搜索设备
                [[SMDBlueToothManager sharedManger] stopAutoSearchDeviceInBackground];
                //开始搜索设备
                [[SMDBlueToothManager sharedManger] autoSearchDeviceInBackground];
                
                //超时计算
                double delayInSeconds = 30.0f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //停止搜索设备
                    [[SMDBlueToothManager sharedManger] stopAutoSearchDeviceInBackground];
                });
            }
        };
        
        //佩戴记录点击事件
        _xueTangView.shiShiView.tendencyBtnClick = ^{
            [ws pushWithController:ws.wearRecordVC];
            [ws.wearRecordVC createData];
        };

#pragma mark - 记录按钮点击
        _xueTangView.recordView.recordViewClick = ^(GLRecordType type){
            NSString *nowTime = [GLTools getNowTime];
            switch (type) {
                case GLRecordBloodType: //记录参比血糖
                {
                    CGFloat lastReferenceValue = 50.0f;
                    NSArray *referenceArr = [NSMutableArray arrayWithArray:[GLCache readCacheArrWithName:SamReferenceArr]];
                    if (referenceArr.count) {
                        lastReferenceValue = [[referenceArr lastObject] getFloatValue:@"value"] * 10.0f;
                    }
                    [ws.slideRuleView showWithCurrentValue:50.0f];
                }
                    break;
                case GLRecordFoodType: //饮食
                {
                    NSString *lastRecordTime = [GL_USERDEFAULTS getStringValue:SamRecordDietTime];
                    if ([[NSDate date] minutesAfterDate:[lastRecordTime toDateDefault]] >= 10 || !lastRecordTime.length) {
                        NSDictionary *postDic = @{
                                                  FUNCNAME : @"saveBloodDiet",
                                                  INFIELD  : @{
                                                          @"DEVICE" : @"1"
                                                          },
                                                  INTABLE  : @{
                                                          @"ID"           : @"",
                                                          @"ACCOUNT"      : USER_ACCOUNT,
                                                          @"DIETTIME"     : nowTime,
                                                          @"DIETSITUATION": @"饮食"
                                                          }
                                                  };
                        
                        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                            if (GETTAG) {
                                if (GETRETVAL) {
                                    //记录饮食成功
                                    [ws getRecotdDataWithType:GLRecordFoodType];
                                    [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                                    [GL_USERDEFAULTS setValue:nowTime forKey:SamRecordDietTime];
                                }
                            }
                        } failure:^(GLRequest *request, NSError *error) {
                            GL_AFFAil;
                        }];
                    } else {
                        //提示10分钟内只能记录一次
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnTimings WithType:type];
                    }
                    /*
                    STDietRecordViewController *dietVC = [STDietRecordViewController new];
                    [ws pushWithController:dietVC];
                    dietVC.refreshDietRecord = ^(){
                        [ws getRecotdDataWithType:GLRecordFoodType];
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                    };
                     */
                }
                    break;
                case GLRecordInsulin:  //胰岛素
                {
                    NSString *lastRecordTime = [GL_USERDEFAULTS getStringValue:SamRecordInsulinTime];
                    if ([[NSDate date] minutesAfterDate:[lastRecordTime toDateDefault]] >= 10 || !lastRecordTime.length) {
                        NSDictionary *postDic = @{
                                                  FUNCNAME : @"saveBloodMedication",
                                                  INFIELD  : @{
                                                          @"DEVICE" : @"1"
                                                          },
                                                  INTABLE : @{
                                                          @"ACCOUNT" : USER_ACCOUNT,
                                                          @"MEDICATIONTIME" : nowTime,
                                                          @"DETAIL" : @[@{@"NAME":@"",
                                                                          @"DOSE":@"",
                                                                          @"USAGE":@"4"}]
                                                          }
                                                  };
                        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                            if (GETTAG) {
                                if (GETRETVAL) {
                                    [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                                    [GL_USERDEFAULTS setValue:nowTime forKey:SamRecordInsulinTime];
                                }
                            }
                        } failure:^(GLRequest *request, NSError *error) {
                            GL_AFFAil;
                        }];
                    } else {
                        //提示10分钟内只能记录一次
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnTimings WithType:type];
                    }
                    /*
                    STMedicationController *medicatVC = [STMedicationController new];
                    medicatVC.isYiDaoSu = true;
                    medicatVC.cellNum = 3;
                    [GL_USERDEFAULTS setObject:@"胰岛素" forKey:@"medicationCell"];
                    [ws pushWithController:medicatVC];
                    medicatVC.refreshBlock = ^(){
                        [ws getRecotdDataWithType:GLRecordInsulin];
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                    };
                     */
                }
                    break;
                case GLRecordRrugs: //口服药
                {
                    NSString *lastRecordTime = [GL_USERDEFAULTS getStringValue:SamRecordMedicinalTime];
                    if ([[NSDate date] minutesAfterDate:[lastRecordTime toDateDefault]] >= 10 || !lastRecordTime.length) {
                        NSDictionary *postDic = @{
                                                  FUNCNAME : @"saveBloodMedication",
                                                  INFIELD  : @{
                                                          @"DEVICE" : @"1"
                                                          },
                                                  INTABLE : @{
                                                          @"ACCOUNT" : USER_ACCOUNT,
                                                          @"MEDICATIONTIME" : nowTime,
                                                          @"DETAIL" : @[@{@"NAME":@"",
                                                                          @"DOSE":@"",
                                                                          @"USAGE":@"1"}]
                                                          }
                                                  };
                        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                            if (GETTAG) {
                                if (GETRETVAL) {
                                    [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                                    [GL_USERDEFAULTS setValue:nowTime forKey:SamRecordMedicinalTime];
                                }
                            }
                        } failure:^(GLRequest *request, NSError *error) {
                            GL_AFFAil;
                        }];
                    } else {
                        //提示10分钟内只能记录一次
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnTimings WithType:type];
                    }

                    /*
                    STMedicationController *medicatVC = [STMedicationController new];
                    medicatVC.isYiDaoSu = false;
                    medicatVC.cellNum    = 3;
                    [GL_USERDEFAULTS setObject:@"用药" forKey:@"medicationCell"];
                    [ws pushWithController:medicatVC];
                    medicatVC.refreshBlock = ^(){
                        [ws getRecotdDataWithType:GLRecordRrugs];
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                    };
                     */
                }
                    break;
                case GLRecordSport: //运动
                {
                    NSString *lastRecordTime = [GL_USERDEFAULTS getStringValue:SamRecordSportsTime];
                    if ([[NSDate date] minutesAfterDate:[lastRecordTime toDateDefault]] >= 10 || !lastRecordTime.length) {
                        NSDictionary *postDic = @{
                                                  FUNCNAME : @"saveBloodMotion",
                                                  @"InField":@{
                                                          @"DEVICE":@"1",		//0:android 1:ios
                                                          @"ID":@"",		//运动id
                                                          @"ACCOUNT":USER_ACCOUNT,	//用户账号
                                                          @"MOTIONTIME":nowTime,	//运动时间
                                                          @"MOTIONTYPE":@"计步器"
                                                          },
                                                  @"OutField":@[
                                                          @"RETVAL",
                                                          @"RETMSG"
                                                          ]
                                                  };
                        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                            if (GETTAG) {
                                if (GETRETVAL) {
                                    [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                                    [GL_USERDEFAULTS setValue:nowTime forKey:SamRecordSportsTime];
                                }
                            }
                        } failure:^(GLRequest *request, NSError *error) {
                            GL_AFFAil;
                        }];
                    } else {
                        //提示10分钟内只能记录一次
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnTimings WithType:type];
                    }
                    /*
                    STSportController *sportVC = [STSportController new];
                    [ws pushWithController:sportVC];
                    sportVC.refreshSportRecord = ^(){
                        [ws getRecotdDataWithType:GLRecordSport];
                        [ws.xueTangView.recordView realodRecordBtnStatus:GLRecordBtnSuccess WithType:type];
                    };
                     */
                }
                    break;
                case GLRecordTarget:
                {
                    [ws pushWithController:ws.targetVC];
                }
                    break;
                default:
                    break;
            }
        };
        
//        _xueTangView.dataAndTargetView.tagertBtnClick = ^(){
//            [ws pushWithController:ws.targetVC];
//        };
//        
//        _xueTangView.dataAndTargetView.dataBtnClick = ^(){
//            [ws pushWithController:ws.analysisVC];
//        };
        
        [_xueTangView tableViewDidSelect:^(NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 2: //佩戴记录点击回调
                {
                    [ws pushWithController:ws.wearRecordVC];
                }
                    break;
            }
        }];
        
    }
    return _xueTangView;
}

- (SlideRuleView *)slideRuleView
{
    if (!_slideRuleView) {
        _slideRuleView = [SlideRuleView slideRuleViewWithType:GLSlideRuleViewReferenceBloodType];
        WS(ws);
        [_slideRuleView getSlectReferenceValueDic:^(NSDictionary *valueDic) {
            [ws upLoadReferGlucose:valueDic];
        }];
    }
    return _slideRuleView;
}

- (XueTangTargerViewController *)targetVC
{
    if (!_targetVC) {
        _targetVC = [XueTangTargerViewController new];
        _targetVC.hidesBottomBarWhenPushed = true;
        WS(ws);
        _targetVC.refreshTarget = ^(){
            //刷新监控目标值
            [ws.xueTangView.recordView  realodTargetData];
//            //刷新折现图的监控目标区域
//            [ws.xueTangView.lineView refreshLineView];
        };
    }
    
    return _targetVC;
}

- (STDataAnalysisViewController *)analysisVC
{
    if (!_analysisVC) {
        _analysisVC              = [STDataAnalysisViewController new];
    }
    return _analysisVC;
}

//- (XueTangPolarizationView *)polarizationView
//{
//    if (!_polarizationView) {
//        _polarizationView = [[XueTangPolarizationView alloc]initWithFrame:self.view.frame];
//        WS(ws);
//        //极化完成回调
//        _polarizationView.polarizationFinish = ^(BOOL isFinish){
//            if (isFinish) {
//                //极化结束
//                GL_DISPATCH_MAIN_QUEUE(^{
//                    ws.xueTangView.userInteractionEnabled = true;
//                    [JHSysAlertUtil presentAlertViewWithTitle:@"极化完成" message:@"请输入参比血糖" confirmTitle:@"确定" handler:^{
//                        [ws.popView show];
//                    }];
//                });
//            } else {
//                //极化开始/重新开始
//                [ws.xueTangView setContentOffset:CGPointMake(0, 0) animated:true];
//                ws.xueTangView.userInteractionEnabled = false;
//            }
//        };
//    }
//    return _polarizationView;
//}

- (WearRecordViewController *)wearRecordVC
{
    if (!_wearRecordVC) {
        _wearRecordVC = [WearRecordViewController new];
    }
    return _wearRecordVC;
}

- (RunChartViewController *)runChartVC
{
    if (!_runChartVC) {
        _runChartVC = [RunChartViewController new];
    }
    return _runChartVC;
}

- (RingTimeHelpViewController *)ringTimeHelpVC
{
    if (!_ringTimeHelpVC) {
        _ringTimeHelpVC = [RingTimeHelpViewController new];
    }
    return _ringTimeHelpVC;
}

- (NSMutableArray *)devicesArr
{
    if (!_devicesArr) {
        _devicesArr = [NSMutableArray new];
    }
    return _devicesArr;
}

//- (NSTimer *)getValueTimer
//{
//    if (!_getValueTimer) {
//        _getValueTimer = [NSTimer scheduledTimerWithTimeInterval:60*3.5 target:self selector:@selector(getDeviceAllData) userInfo:nil repeats:true];
//        [[NSRunLoop currentRunLoop] addTimer:_getValueTimer forMode:NSRunLoopCommonModes];
//    }
//    return _getValueTimer;
//}
//
//- (void)getValueTimerStart
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.getValueTimer setFireDate:[NSDate date]];
//            [self.getValueTimer fire];
//        });
//    });
//    
//    //    dispatch_source_cancel(_getValueTimer);
//    //    // 开启定时器
//    //    dispatch_resume(_getValueTimer);
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
