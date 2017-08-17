//
//  WearRecordEntity.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLEntity.h"

@interface WearRecordEntity : GLEntity

///用户id
@property (nonatomic,copy) NSString *userid;
///佩戴开始时间
@property (nonatomic,copy) NSString *starttime;
///佩戴结束时间
@property (nonatomic,copy) NSString *endtime;
///发射器编号
@property (nonatomic,copy) NSString *emittercode;

@end
