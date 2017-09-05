//
//  RingRealTimeDataView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/5.
//  Copyright © 2017年 高临原♬. All rights reserved.
//
//  血糖时间环中实时血糖数据

#import "GLView.h"

@interface RingRealTimeDataView : GLView

@property (nonatomic,strong) UILabel *realTimeLbl; /**< 实时血糖数据Label */

@property (nonatomic,strong) GLButton *dataAnalysisBtn; /**< 数据分析按钮 */


/**
 根据最新血糖值设置标签

 @param bloodValue 最新血糖值
 */
- (void)setRealTimeLblTextByBloodValue:(NSString *)bloodValue;

@end
