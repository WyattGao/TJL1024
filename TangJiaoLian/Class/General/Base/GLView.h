//
//  GLView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLEntity.h"

@interface GLView : UIView


/**
 根据模型初始化一个View

 @param entity 模型
 @return 返回View
 */
- (instancetype)initWithModel:(GLEntity *)entity;

- (void)createUI;

- (void)createData;

- (void)refresh;

@end
