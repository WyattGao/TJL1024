//
//  XueTangShiShiXueTangView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"
#import "XueTangZhiEntity.h"
#import "XueTangRingTimeView.h"

typedef void(^ConnectSwitchClick)(BOOL isOn);

@interface XueTangShiShiXueTangView : GLView

///连接状态提示
@property (nonatomic,strong) UILabel *connectStateLbl;
///连接设备开关
@property (nonatomic,strong) UISwitch *connectSwitch;
///趋势图按钮
@property (nonatomic,strong) UIButton *tendencyBtn;

@property (nonatomic,copy) ConnectSwitchClick connectSwitchClick;

@property (nonatomic,strong) XueTangRingTimeView *ringView;

- (void)reloadViewbyBinDingState;

@end
