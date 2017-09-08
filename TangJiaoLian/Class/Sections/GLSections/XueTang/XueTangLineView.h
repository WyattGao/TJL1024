//
//  XueTangLineView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"
#import "XQDLineChart.h"
#import "ChartsDateValueFormatter.h"
#import "XueTangLineViewEntity.h"


@interface XueTangLineView : GLView

@property (nonatomic,strong) XQDColor *lineColor;
@property (nonatomic,strong) UIView *cutlineView;
@property (nonatomic,strong) XQDLineChart *lineChat;
@property (nonatomic,strong) LineChartView *lineChartView;
@property (nonatomic,strong) XueTangLineViewEntity *entity;


/**
 刷新折线图
 */
- (void)refreshLineView;

/**
 佩戴记录刷新折现图
 */
- (void)wearRecordrefreshLineView;


@end
