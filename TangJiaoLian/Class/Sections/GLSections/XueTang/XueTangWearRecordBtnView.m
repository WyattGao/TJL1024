//
//  XueTangWearRecordBtnView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangWearRecordBtnView.h"

@implementation XueTangWearRecordBtnView

- (void)createUI
{
    [self addSubview:self.wearRecordBtn];
    [self addSubview:self.rightIV];
    
    WS(ws);
    
    [self.wearRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.rightIV.mas_left).offset(-4);
        make.centerY.equalTo(ws);
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).offset(-10.6);
        make.centerY.equalTo(ws);
    }];
}

- (GLButton *)wearRecordBtn
{
    if (!_wearRecordBtn) {
        _wearRecordBtn = [GLButton new];
        [_wearRecordBtn setImage:GL_IMAGE(@"血糖页-佩戴记录") forState:UIControlStateNormal];
        [_wearRecordBtn setTitle:@"佩戴记录" forState:UIControlStateNormal];
        [_wearRecordBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_wearRecordBtn setFont:GL_FONT(14)];
        [_wearRecordBtn setGraphicLayoutState:PICLEFT];
        [_wearRecordBtn setGraphicLayoutSpacing:5.6];
        [_wearRecordBtn setUserInteractionEnabled:false];
    }
    return _wearRecordBtn;
}

- (UIImageView *)rightIV
{
    if (!_rightIV) {
        _rightIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"右箭头-绿")];
    }
    return _rightIV;
}

@end
