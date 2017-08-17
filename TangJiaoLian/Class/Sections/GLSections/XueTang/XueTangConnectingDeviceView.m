//
//  XueTangConnectingDeviceView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangConnectingDeviceView.h"

@interface XueTangConnectingDeviceView ()

@property (nonatomic,strong) UIButton *connectBtn;
@property (nonatomic,strong) UIButton *checkWearRecordBtn;

@end

@implementation XueTangConnectingDeviceView

- (void)createUI
{
    self.backgroundColor        = TCOL_BG;
    self.userInteractionEnabled = true;
    
    [self addSubview:self.connectBtn];
    [self addSubview:self.checkWearRecordBtn];
    
    WS(ws);
    
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (SCREEN_HEIGHT == GL_IPHONE_4_SCREEN_HEIGHT) {
            make.size.mas_equalTo(CGSizeMake(120, 120));
            make.top.equalTo(ws).offset(95);
        } else {
            make.top.equalTo(ws).offset(GL_IP6_H_RATIO(121));
        }
        make.centerX.equalTo(ws);
    }];
    
    [self.checkWearRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.connectBtn.mas_bottom).offset(GL_IP6_H_RATIO(60));
        make.centerX.equalTo(ws);
        if (SCREEN_HEIGHT == GL_IPHONE_4_SCREEN_HEIGHT) {
            make.size.mas_equalTo(CGSizeMake(120, 120));
        }
    }];
}

/**
 连接设备按钮点击事件
 */
- (void)connectBtnClick:(UIButton *)sender
{
    if (_connectBtnClick) {
        _connectBtnClick();
    }
}

- (void)checkWearRecordBtnClick:(UIButton *)sender
{
    if (_checkWearRecordBtnClick) {
        _checkWearRecordBtnClick();
    }
}

- (UIButton *)connectBtn
{
    if (!_connectBtn) {
        _connectBtn = [UIButton new];
        [_connectBtn setImage:GL_IMAGE(@"连接设备") forState:UIControlStateNormal];
        [_connectBtn addTarget:self action:@selector(connectBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectBtn;
}

- (UIButton *)checkWearRecordBtn
{
    if (!_checkWearRecordBtn) {
        _checkWearRecordBtn = [UIButton new];
        [_checkWearRecordBtn setImage:GL_IMAGE(@"佩戴记录") forState:UIControlStateNormal];
        [_checkWearRecordBtn addTarget:self action:@selector(checkWearRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkWearRecordBtn;
}

@end
