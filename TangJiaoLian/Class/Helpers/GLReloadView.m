//
//  GLReloadView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/11.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLReloadView.h"

GLReloadView *reloadView;

@implementation GLReloadView

+ (instancetype)share
{
    @synchronized (self) {
        if (!reloadView) {
            reloadView = [GLReloadView new];
        }
    }
    
    return reloadView;
}


- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)reloadBtnClick
{
    if (_reload) {
        _reload();
    }
}

- (void)createUI
{
    self.backgroundColor  = TCOL_BGGRAY;
    
    [self addSubview:self.reloadBtn];
    
    WS(ws);
    
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(120, 35));
    }];
}

- (UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [UIButton new];
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_reloadBtn.titleLabel setFont:GL_FONT(18)];
        [_reloadBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_reloadBtn setCornerRadius:5];
       
        [_reloadBtn setBorderWidth:0.5];
        [_reloadBtn setBorderColor:TCOL_MAIN];
    }
    return _reloadBtn;
}

@end
