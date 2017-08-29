//
//  ChartsDateValueFormatter.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/28.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "ChartsDateValueFormatter.h"

@implementation ChartsDateValueFormatter

- (instancetype)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self) {
        self.arr = arr;
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return _arr[(NSInteger)[@(value) integerValue]];
}

@end
