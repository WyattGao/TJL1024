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
#import "XueTangLineView.h"
#import "XueTangPolarizationView.h"
#import "XueTangRecordView.h"
#import "XueTangConnectingDeviceView.h"
#import "XueTangWearRecordBtnView.h"
#import "XueTangRingTimeView.h"
#import "XueTangDeviceListTableView.h"

@interface XueTangView : GLTableView

///数据分析与控糖目标
@property (nonatomic,strong) XueTangDataAnalysisAndMonitoringTargetView  *dataAndTargetView;
///实时血糖值
@property (nonatomic,strong) XueTangShiShiXueTangView *shiShiView;
///历史血糖值
@property (nonatomic,strong) XueTangLiShiZhiView *liShiZhiView;
///连接按钮
@property (nonatomic,strong) XueTangRecordView *recordView;
///折线图
@property (nonatomic,strong) XueTangLineView *lineView;
///佩戴记录按钮
@property (nonatomic,strong) XueTangWearRecordBtnView *wearRecordBtnView;
///设备列表View
@property (nonatomic,strong) XueTangDeviceListTableView *deviceTV;

@end
