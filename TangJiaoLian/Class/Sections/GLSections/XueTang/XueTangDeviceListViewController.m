//
//  XueTangDeviceListViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangDeviceListViewController.h"
#import "XueTangDeviceListTableView.h"

@interface XueTangDeviceListViewController ()

@property (nonatomic,strong) XueTangDeviceListTableView *mainTV;

@end

@implementation XueTangDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self setNavTitle:@"搜索列表"];
    [self setLeftBtnImgNamed:nil];
    
    [self addSubView:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.bottom.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void)createData
{
}

//搜索到设备之后的通知回调
- (void)discoverDevice:(NSNotification *)notification
{
    WS(ws);
    GL_DISPATCH_MAIN_QUEUE(^{
        LFPeripheral *sensor = (LFPeripheral *)[notification object];
        
        BOOL isSenorInArray = NO;
        for (LFPeripheral *device in self.mainTV.tbDataSouce) {
            if ([device.identifier isEqualToString:sensor.identifier]) {
                isSenorInArray = YES;
            }
        }
        
        if (!isSenorInArray) {
            [ws.mainTV.tbDataSouce addObject:sensor];
            [ws.mainTV reloadData];
        }
    });
}

- (XueTangDeviceListTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [XueTangDeviceListTableView new];
        
        WS(ws);
        
        _mainTV.tableViewDidSelect = ^(NSIndexPath *indexPath){
            if (ws.connectDevice) {
                    [ws popViewController];
                ws.connectDevice(ws.mainTV.tbDataSouce[indexPath.row]);
            }
        };
    }
    return _mainTV;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navHide = false;
    //开始搜索设备
    [[SMDBlueToothManager sharedManger] autoSearchDeviceInBackground];
    //添加搜索到设备的通知回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverDevice:) name:SMDBLEDidDiscoverDeviceNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navHide = true;
    
    //停止搜索设备
    [[SMDBlueToothManager sharedManger] stopAutoSearchDeviceInBackground];
    //清空设备列表数据
    [self.mainTV.tbDataSouce removeAllObjects];
    [self.mainTV reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
