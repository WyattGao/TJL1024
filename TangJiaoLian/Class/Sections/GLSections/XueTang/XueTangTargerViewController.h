//
//  XueTangTargerViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"

typedef void(^RefreshTarget)();

@interface XueTangTargerViewController : GLViewController

///刷新主页面预警值
@property (nonatomic,copy) RefreshTarget refreshTarget;

@end
