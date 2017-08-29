//
//  RunChartView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/22.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"
#import "XueTangLineView.h"

@interface RunChartView : GLTableView

///折线图
@property (nonatomic,strong) XueTangLineView *lineView;

@end
