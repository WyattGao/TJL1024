//
//  WoInfoFooterView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/26.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoInfoFooterView.h"

@implementation WoInfoFooterView

- (void)exitBtnClick:(GLButton *)sender
{
    if (self.exitBtnClick) {
        self.exitBtnClick();
    }
}

- (void)createUI
{
    [self addSubview:self.exitBtn];
    
    WS(ws);
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 40));
    }];
}

- (GLButton *)exitBtn
{
    if (!_exitBtn) {
        _exitBtn = [GLButton new];
        [_exitBtn setTitle:@"退出账号" forState:UIControlStateNormal];
        [_exitBtn setFont:GL_FONT(16)];
        [_exitBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_exitBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
        [_exitBtn setTextAlignment:NSTextAlignmentCenter];
        [_exitBtn setCornerRadius:5];
        [_exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

@end
