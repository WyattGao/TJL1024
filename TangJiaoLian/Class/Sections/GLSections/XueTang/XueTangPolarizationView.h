//
//  XueTangPolarizationView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

/**
 极化完成回调
 */
//typedef void(^PolarizationFinish)(BOOL isFinish);

@interface XueTangPolarizationView : GLView

//@property (nonatomic,copy) PolarizationFinish polarizationFinish;

- (void)startTimeKeeping;

@end
