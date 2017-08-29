//
//  ChartsDateValueFormatter.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/28.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartsDateValueFormatter : NSObject<IChartAxisValueFormatter>

@property (nonatomic,strong) NSArray *arr;

- (instancetype)initWithArr:(NSArray *)arr;

@end
