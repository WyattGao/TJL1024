//
//  XueTangDeviceListHeader.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangDeviceListHeader.h"

@interface XueTangDeviceListHeader ()


@end

@implementation XueTangDeviceListHeader

- (void)createUI
{
    self.backgroundColor = TCOL_BG;
    
    [self addSubview:self.titleLbl];
    [self addSubview:self.refreshBtn];
    
    WS(ws);
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(44);
        make.centerX.equalTo(ws);
    }];
        
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.titleLbl.mas_right).offset(19);
        make.centerY.equalTo(ws.titleLbl);
    }];
    
    for (NSInteger i = 0;i < 2;i++) {
        UIView *bLine = [UIView new];
        
        [self addSubview:bLine];
        
        bLine.backgroundColor = TCOL_BG;
        
        [bLine mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!i) {
                make.top.equalTo(ws.mas_top);
            } else {
                make.bottom.equalTo(ws.mas_bottom);
            }
            make.centerX.equalTo(ws);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 5));
        }];
    }
}

- (GLButton *)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [GLButton new];
        [_refreshBtn setImage:GL_IMAGE(@"刷新") forState:UIControlStateNormal];
        [_refreshBtn setGraphicLayoutState:PICCENTER];
    }
    return _refreshBtn;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl               = [UILabel new];
        _titleLbl.font          = GL_FONT_B(20);
        _titleLbl.textColor     = TCOL_MAIN;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text          = @"请选择设备";
    }
    return _titleLbl;
}

//- (UIActivityIndicatorView *)activityView
//{
//    if (!_activityView) {
//        _activityView       = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _activityView.color = TCOL_MAIN;
//        [_activityView startAnimating];
//        [_activityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
//    }
//    return _activityView;
//}

@end
