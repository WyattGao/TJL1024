//
//  XueTangConnectingDeviceView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^ConnectBtnClick)();
typedef void(^CheckWearRecordBtnClick)();

@interface XueTangConnectingDeviceView : GLView

@property (nonatomic,copy) ConnectBtnClick connectBtnClick;
@property (nonatomic,copy) CheckWearRecordBtnClick checkWearRecordBtnClick;

@end
