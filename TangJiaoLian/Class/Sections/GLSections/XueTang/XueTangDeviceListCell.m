//
//  XueTangDeviceListCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangDeviceListCell.h"

@implementation XueTangDeviceListCell

//重试按钮点击事件
- (void)retryBtnClick:(GLButton *)sender
{
    
}

- (void)changeCellForConnectionStatus:(GLConnectionStatus)status
{
    GL_DISPATCH_MAIN_QUEUE(^{
        switch (status) {
            case GLConnectionUnfinished:
                [self.retryBtn setHidden:true];
                self.deviceNameLbl.textColor    = TCOL_MAIN;
                self.connectionStatusLbl.hidden = false;
                break;
            case GLConnectionFailed:
                [self.retryBtn setHidden:false];
                [self.retryBtn setBackgroundColor:TCOL_RETRYBTN forState:UIControlStateNormal];
                [self.retryBtn setTitle:@"重试" forState:UIControlStateNormal];
                self.connectionStatusLbl.hidden = true;
                self.deviceNameLbl.textColor    = TCOL_RETRYBTN;
                break;
            case GLConnectionSucceed:
                break;
            default:
                break;
        }
    });
}

- (void)createUI
{
//    self.contentView.backgroundColor = TCOL_DEVICECELLBG;
    self.selected                    = false;
    
    [self.contentView addSubview:self.deviceNameLbl];
    [self.contentView addSubview:self.connectionStatusLbl];
    [self.contentView addSubview:self.retryBtn];
    
    WS(ws);
    
    [self.deviceNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.contentView);
    }];
    
    [self.connectionStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.deviceNameLbl);
        make.left.equalTo(ws.deviceNameLbl.mas_right).offset(17);
    }];
    
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.deviceNameLbl);
        make.left.equalTo(ws.deviceNameLbl.mas_right).offset(17);
        make.size.mas_equalTo(CGSizeMake(50, 22));
    }];
}

- (UILabel *)deviceNameLbl
{
    if (!_deviceNameLbl) {
        _deviceNameLbl               = [UILabel new];
        _deviceNameLbl.font          = GL_FONT_B(20);
        _deviceNameLbl.textColor     = TCOL_DEVICELISTTEXT;
        _deviceNameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _deviceNameLbl;
}

- (GLButton *)retryBtn
{
    if (!_retryBtn) {
        _retryBtn = [GLButton new];
        [_retryBtn setHidden:true];
        [_retryBtn setTitle:@"连接" forState:UIControlStateNormal];
        [_retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_retryBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
        [_retryBtn setTitleColor:TCOL_HOMETEXTCOLOR forState:UIControlStateNormal];
        [_retryBtn setCornerRadius:8];
        [_retryBtn setFont:GL_FONT(12)];
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
        _connectionStatusLbl.hidden    = true;
    }
    return _connectionStatusLbl;
}

- (void)setCellSelected:(BOOL)cellSelected
{
    if (cellSelected) {
        if (self.cellSelected) {
            self.retryBtn.hidden            = false;
            [self.retryBtn setTitle:@"连接" forState:UIControlStateNormal];
            self.connectionStatusLbl.hidden = true;
            self.deviceNameLbl.textColor    = TCOL_MAIN;
        }
    } else {
        self.retryBtn.hidden = true;
    }
    _cellSelected = cellSelected;
}

- (void)setEntity:(id)entity
{
    [super setEntity:entity];
    LFPeripheral *deviceEntity = (LFPeripheral *)entity;
    _deviceNameLbl.text        = deviceEntity.sensorName;
}

@end
