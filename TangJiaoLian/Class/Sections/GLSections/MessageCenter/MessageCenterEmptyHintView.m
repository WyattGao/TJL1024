//
//  MessageCenterEmptyHintView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/6/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "MessageCenterEmptyHintView.h"

@implementation MessageCenterEmptyHintView

- (void)createUI
{
    [self addSubview:self.iconIV];
    [self addSubview:self.hintLbl];
    
    WS(ws);
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws).offset(100);
    }];
    
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.iconIV.mas_bottom).offset(20);
        make.centerX.equalTo(ws.iconIV);
    }];
}

- (UIImageView *)iconIV
{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"消息中心-暂无消息")];
    }
    return _iconIV;
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl           = [UILabel new];
        _hintLbl.text      = @"暂无消息";
        _hintLbl.font      = GL_FONT(18);
        _hintLbl.textColor = TCOL_SUBHEADTEXT;
    }
    return _hintLbl;
}

@end
