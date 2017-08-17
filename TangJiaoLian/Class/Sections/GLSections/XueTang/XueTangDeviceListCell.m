//
//  XueTangDeviceListCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangDeviceListCell.h"
#import "LFPeripheral.h"

@implementation XueTangDeviceListCell

//重试按钮点击事件
- (void)retryBtnClick:(GLButton *)sender
{
    
}

- (void)changeCellForConnectionStatus:(GLConnectionStatus)status
{
    switch (status) {
        case GLConnectionUnfinished:
            self.retryBtn.hidden            = true;
            self.connectionStatusLbl.hidden = false;
            self.deviceNameLbl.textColor    = TCOL_MAIN;
            break;
        case GLConnectionFailed:
            self.connectionStatusLbl.hidden = true;
            self.retryBtn.hidden            = false;
            self.deviceNameLbl.textColor    = TCOL_RETRYBTN;
            break;
        case GLConnectionSucceed:
            break;
        default:
            break;
    }
}

- (void)createUI
{
    self.contentView.backgroundColor = TCOL_DEVICECELLBG;
    
    [self.contentView addSubview:self.deviceNameLbl];
    [self.contentView addSubview:self.connectionStatusLbl];
    [self.contentView addSubview:self.retryBtn];
    
    WS(ws);
    
    [self.deviceNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView).offset(16);
        make.centerY.equalTo(ws.contentView);
    }];
    
    [self.connectionStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.deviceNameLbl);
        make.left.equalTo(ws.deviceNameLbl.mas_right).offset(17);
    }];
    
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.deviceNameLbl);
        make.left.equalTo(ws.deviceNameLbl.mas_right).offset(17);
    }];
}

- (UILabel *)deviceNameLbl
{
    if (!_deviceNameLbl) {
        _deviceNameLbl               = [UILabel new];
        _deviceNameLbl.font          = GL_FONT_B(15);
        _deviceNameLbl.textColor     = TCOL_NORMALETEXT;
        _deviceNameLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _deviceNameLbl;
}

- (GLButton *)retryBtn
{
    if (!_retryBtn) {
        _retryBtn = [GLButton new];
        [_retryBtn setHidden:true];
        [_retryBtn setTitle:@"重试" forState:UIControlStateNormal];
        [_retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_retryBtn setBackgroundColor:TCOL_RETRYBTN forState:UIControlStateNormal];
        [_retryBtn setTitleColor:TCOL_HOMETEXTCOLOR forState:UIControlStateNormal];
    }
    return _retryBtn;
}


- (UILabel *)connectionStatusLbl
{
    if (!_connectionStatusLbl) {
        _connectionStatusLbl           = [UILabel new];
        _connectionStatusLbl.font      = GL_FONT(14);
        _connectionStatusLbl.textColor = TCOL_MAIN;
        _connectionStatusLbl.text      = @"连接中...";
        _connectionStatusLbl.hidden    = false;
    }
    return _connectionStatusLbl;
}

- (void)setEntity:(id)entity
{
    LFPeripheral *deviceEntity = (LFPeripheral *)entity;
    
    _deviceNameLbl.text = deviceEntity.sensorName;
}

@end
