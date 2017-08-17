//
//  XueTangDataAnalysisAndMonitoringTargetView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/17.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^TagertBtnClick)();
typedef void(^DataAnalysisBtnClick)();

@interface XueTangDataAnalysisAndMonitoringTargetView : GLView

///数据分析按钮
@property (nonatomic,strong) GLButton *dataAnalysisBtn;
///监测目标按钮
@property (nonatomic,strong) GLButton *monitoringTargetBtn;
///垂直分割线
@property (nonatomic,strong) UIView *verticalLine;
///顶部水平分割线
@property (nonatomic,strong) UIView *topHorizontalLine;
///底部水平分割线
@property (nonatomic,strong) UIView *bomHorizontalLine;

@property (nonatomic,copy) TagertBtnClick tagertBtnClick;
@property (nonatomic,copy) DataAnalysisBtnClick dataBtnClick;

//刷新预警值的数值
- (void)realodTargetData;

@end
