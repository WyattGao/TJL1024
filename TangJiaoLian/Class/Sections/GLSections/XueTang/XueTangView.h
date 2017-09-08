//
//  XueTangView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"
#import "XueTangShiShiXueTangView.h"
#import "XueTangLiShiZhiView.h"
#import "XueTangDataAnalysisAndMonitoringTargetView.h"
#import "XueTangConnectingDeviceView.h"
#import "XueTangPolarizationView.h"
#import "XueTangRecordView.h"
#import "XueTangConnectingDeviceView.h"
#import "XueTangRingTimeView.h"
#import "XueTangDeviceListTableView.h"

@interface XueTangView : GLTableView

///实时血糖值
@property (nonatomic,strong) XueTangShiShiXueTangView *shiShiView;
///历史血糖值
@property (nonatomic,strong) XueTangLiShiZhiView *liShiZhiView;
///记录按钮
@property (nonatomic,strong) XueTangRecordView *recordView;
///设备列表View
@property (nonatomic,strong) XueTangDeviceListTableView *deviceTV;

@property (nonatomic,strong) XueTangRingTimeView *ringView;


/**
 翻转实时数据View,切换连接设备和设备列表页面
 */
- (void)turnShiShiView;

@end
