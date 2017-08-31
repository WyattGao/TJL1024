//
//  XueTangRingTimeView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/8.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangRingTimeView.h"

@implementation XueTangRingTimeView

#define degreesToRadians(degrees) ((degrees * (float)M_PI) / 180.0f)

- (void)refreshTwinklingBtn
{
    if (ISBINDING) {
        NSString *nowHour = [[NSDate date] toString:@"H"];
        GLButton *hourBtn = [nowHour isEqualToString:@"0"] ? [self viewWithTag:54] : [self viewWithTag:(30 + [nowHour integerValue] + 1)];
        hourBtn.alpha = 0.5f;
        [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionRepeat animations:^{
            hourBtn.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
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

- (void)createUI
{
    self.backgroundColor = TCOL_BG;
    
    [self addSubview:self.connectionBtn];
    
    WS(ws);
    
    [self.connectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
    
    
    float dist = 104;//半径
    for (int i= 1; i<= 24;i++) {
        float angle = degreesToRadians((360 / 24) * i);
        float y = cos(angle) * dist;
        float x = sin(angle) * dist;
        
        GLButton *btn           = [GLButton buttonWithType:UIButtonTypeCustom];
        btn.width               = 16;
        btn.height              = 16;
        btn.tag                 = 30 + i;
        btn.layer.cornerRadius  = 8;
        btn.layer.masksToBounds = true;
        btn.highlighted         = false;
        
        //默认灰色背景
        [btn setBackgroundColor:TCOL_RINGTIMENOR forState:UIControlStateNormal];
        //选中
        [btn setBackgroundColor:TCOL_RINGTIMESEL forState:UIControlStateSelected];
        //高亮异常红色
//        [btn setBackgroundColor:TCOL_RINGTIMEWAR forState:UIControlStateHighlighted];
        //高亮无异常绿色
        [btn setBackgroundColor:TCOL_RINGTIMEPASS forState:UIControlStateDisabled];
        
        if (i == 24) {
            [btn setTitle:@"0" forState:UIControlStateNormal];
        } else {
            [btn setTitle:[@(i) stringValue] forState:UIControlStateNormal];
        }
        
        [btn.lbl setFont:GL_FONT(8)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint center = CGPointMake(SCREEN_WIDTH/2 + x,240/2 -  y);
        btn.center = center;
        
        [self addSubview:btn];
    }
    
    [self refreshTwinklingBtn];
}

- (void)timeBtnClick:(UIButton *)sender
{
    //取消所有按钮的选中状态
    for (NSInteger i = 1;i <= 24;i++) {
        GLButton *btn = (GLButton *)[self viewWithTag:30 + i];
        if (btn.tag != sender.tag) {
            btn.selected = false;
        }
    }
    sender.selected  = !sender.selected;
    if (sender.selected) {
        //显示预警信息
    } else {
        //取消显示预警信息
    }
}


- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.font          = GL_FONT(18);
        _hintLbl.textAlignment = NSTextAlignmentCenter;
        _hintLbl.textColor     = TCOL_MAIN;
    }
    return _hintLbl;
}

- (GLButton *)connectionBtn
{
    if (!_connectionBtn) {
        _connectionBtn = [GLButton new];
        [_connectionBtn setTitle:@"连接设备" forState:UIControlStateNormal];
        [_connectionBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
        [_connectionBtn setTitleColor:TCOL_WHITETEXT forState:UIControlStateNormal];
        [_connectionBtn setCornerRadius:20];
        [_connectionBtn setFont:GL_FONT(20)];
        [_connectionBtn setTextAlignment:NSTextAlignmentCenter];
        [_connectionBtn addTarget:self action:@selector(connectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _connectionBtn;
}


@end
