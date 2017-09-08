//
//  XueTangLineViewEntity.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/28.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangLineViewEntity.h"

@implementation XueTangLineViewEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bloodGlucoseArr = @[];
        self.referenceArr    = @[];
        self.dietArr         = @[];
        self.medicatedArr    = @[];
        self.insulinArr      = @[];
        self.sportsArr       = @[];
        self.xAxisTimeArr    = @[];
    }
    return self;
}

@end
