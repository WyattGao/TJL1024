//
//  WearRecordDetailTableView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"
#import "XueTangDataAnalysisAndMonitoringTargetView.h"
#import "XueTangLiShiZhiView.h"
#import "XueTangLineView.h"

@interface WearRecordDetailTableView : GLTableView

@property (nonatomic,strong) XueTangDataAnalysisAndMonitoringTargetView *dataAnalysisView;
@property (nonatomic,strong) XueTangLiShiZhiView *lishiZhiView;
@property (nonatomic,strong) XueTangLineView *lineView;

@end
