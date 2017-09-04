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

- (void)setStatus:(GLRingTimeStatus)status
{
    _status = status;
    
    GL_DISPATCH_MAIN_QUEUE(^{
        switch (status) {
            case GLRingTimeUnunitedStatus:     //未连接
                [self.connectionBtn setHidden:false];
                [self.hintLbl setHidden:true];
                [self.polarizationTimeLbl setHidden:true];
                [self changeHintLblSatuts:GLRingTimeHintLabelPolarizationStatus WithHour:0 WithAbnormalCount:0];
                [self.timer setFireDate:[NSDate distantFuture]];
                break;
            case GLRIngTimeConnectingStatus:   //已在连接中
                [self.connectionBtn setHidden:true];
                [self.hintLbl setHidden:false];
                [self.polarizationTimeLbl setHidden:true];
                break;
            case GLRingTimePolarizationStatus: //极化中
                [self.connectionBtn setHidden:true];
                [self.hintLbl setHidden:false];
                [self startTimeKeeping];
                break;
            default:
                break;
        }
    });
}

- (void)changeHintLblSatuts:(GLRingTimeHintLabelStatus)status WithHour:(NSInteger)hour WithAbnormalCount:(NSInteger)abnormalCount
{
    switch (status) {
        case GLRingTimeHintLabelPolarizationStatus:
            self.hintLbl.textColor = TCOL_MAIN;
            self.hintLbl.font      = GL_FONT(14);
            self.hintLbl.text      = @"设备极化中\n大概需要20分钟";
            break;
        case GLRingTimeHintLabelNormal:
            self.hintLbl.font      = GL_FONT(18);
            self.hintLbl.textColor = TCOL_MAIN;
            break;
        case GLRingTimeHintLabelAbNormal:
            self.hintLbl.font      = GL_FONT(18);
            self.hintLbl.textColor = TCOL_GLUCOSEHEIGHT;
            break;
        default:
            break;
    }
}

//极化计时
- (void)timeKeeping
{
    GL_DISPATCH_MAIN_QUEUE(^{
        NSInteger timeInter           = 20 * 60 - ([[NSDate date] timeIntervalSince1970] - [[[GL_USERDEFAULTS stringForKey:SamStartBinDingDeviceTime] toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970]);
        NSDate *date                  = [NSDate dateWithTimeIntervalInMilliSecondSince1970:timeInter];
        self.polarizationTimeLbl.text = [date toString:@"mm:ss"];
        
        if (timeInter <= 0) {
            //停止计时器
            GL_DISPATCH_MAIN_QUEUE(^{
                [self.timer setFireDate:[NSDate distantFuture]];
                self.hidden = true;
                [GL_USERDEFAULTS setBool:true forKey:SamPolarizationFinish];
                [GL_USERDEFAULTS synchronize];
                if (_polarizationFinish) {
                    _polarizationFinish(true);
                }
            });
        }
    });
}

//开始极化计时
- (void)startTimeKeeping
{
    GL_DISPATCH_MAIN_QUEUE(^{
        self.hidden = false;
        [self.timer setFireDate:[NSDate date]];
        [self.timer fire];
    });
}

//根据时间刷新闪烁按钮的状态
- (void)refreshTwinklingBtn
{
//    if (ISBINDING) {
    if (![self.nowHour isEqualToString:[[NSDate date] toString:@"H"]]) {
        self.nowHour = [[NSDate date] toString:@"H"];
        GLButton *hourBtn = [self.nowHour isEqualToString:@"0"] ? [self viewWithTag:54] : [self viewWithTag:(30 + [self.nowHour integerValue])];
        [self animateFirstRoundWithHourBtn:hourBtn];
    }
//    }
}

//为小时按钮生成呼吸效果
- (void)animateFirstRoundWithHourBtn:(GLButton *)hourBtn
{
    hourBtn.alpha = 0.4f;
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        hourBtn.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self animateSecondRoundWithHourBtn:hourBtn];
    }];
}

- (void)animateSecondRoundWithHourBtn:(GLButton *)hourBtn
{
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        hourBtn.alpha = 0.4f;
    } completion:^(BOOL finished) {
        [self animateFirstRoundWithHourBtn:hourBtn];
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

- (void)createUI
{
    self.backgroundColor = TCOL_BG;
    
    [self addSubview:self.connectionBtn];
    [self addSubview:self.hintLbl];
    [self addSubview:self.polarizationTimeLbl];
    
    WS(ws);
    
    [self.connectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.width.mas_equalTo(126);
    }];
    
    [self.polarizationTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(22);
        make.centerX.equalTo(ws);
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
    
    [self setStatus:GLRingTimeUnunitedStatus];
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
        _hintLbl.hidden        = true;
        _hintLbl.numberOfLines = 0;
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
        [_connectionBtn setHidden:true];
    }
    
    return _connectionBtn;
}

- (NSString *)nowHour
{
    if (!_nowHour) {
        _nowHour = [NSString new];
    }
    return _nowHour;
}

- (UILabel *)polarizationTimeLbl
{
    if (!_polarizationTimeLbl) {
        _polarizationTimeLbl               = [UILabel new];
        _polarizationTimeLbl.font          = GL_FONT_BY_NAME(@"Courier", 15);
        _polarizationTimeLbl.textColor     = RGB(153, 153, 153);
        _polarizationTimeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _polarizationTimeLbl;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =   [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeKeeping) userInfo:nil repeats:true];
    }
    return _timer;
}


@end
