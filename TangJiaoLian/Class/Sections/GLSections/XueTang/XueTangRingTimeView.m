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
    
    [self.connectionBtn       setHidden:true];
    [self.hintLbl             setHidden:true];
    [self.polarizationTimeLbl setHidden:true];
    [self.timeDataView        setHidden:true];
    
    GL_DISPATCH_MAIN_QUEUE(^{
        switch (status) {
            case GLRingTimeUnunitedStatus:     //未连接
                [self.connectionBtn setHidden:false];
                [self changeHintLblSatuts:GLRingTimeHintLabelPolarizationStatus WithHour:0 WithAbnormalCount:0];
                [self.timer setFireDate:[NSDate distantFuture]];
                
                for (NSInteger i = 1;i <= 24;i++) {
                    GLButton *timeBtn = [self viewWithTag:30 + i];
                    [timeBtn setImage:[UIImage imageWithColor:TCOL_RINGTIMENOR size:CGSizeMake(16, 16)] forState:UIControlStateNormal];
                    [timeBtn setUserInteractionEnabled:false];
                }
                break;
            case GLRingTimeCheckedStatus:   //时间按钮选中
                [self.hintLbl setHidden:false];
                break;
            case GLRingTimePolarizationStatus: //极化中
                [self changeHintLblSatuts:GLRingTimeHintLabelPolarizationStatus WithHour:0 WithAbnormalCount:0];
                [self.hintLbl setHidden:false];
                [self.polarizationTimeLbl setHidden:false];
                [self startTimeKeeping];
                
                break;
            case GLRingTimeConnectingStatus: //连接中
                [self.timeDataView setHidden:false];
                break;
            default:
                break;
        }
    });
}

- (void)changeHintLblSatuts:(GLRingTimeHintLabelStatus)status WithHour:(NSInteger)hour WithAbnormalCount:(NSInteger)abnormalCount
{
    NSInteger nextHour = hour == 23 ? 0 : (hour + 1);
    
    NSString *selectHourStr = [[@(hour) stringValue] isEqualToString:[[NSDate date] toString:@"H"]] ? @"现在" : [NSString stringWithFormat:@"%ld点之间",nextHour];
    WS(ws);
    switch (status) {
        case GLRingTimeHintLabelPolarizationStatus:
            self.hintLbl.textColor = TCOL_MAIN;
            self.hintLbl.font      = GL_FONT(14);
            self.hintLbl.text      = @"设备极化中\n大概需要20分钟";
            break;
        case GLRingTimeHintLabelNormal:
        {
            self.hintLbl.font      = GL_FONT(18);
            self.hintLbl.textColor = TCOL_MAIN;
            self.hintLbl.text      = [NSString stringWithFormat:@"%ld点到%@\n您的血糖共出现\n0次异常",hour,selectHourStr];
        }
            break;
        case GLRingTimeHintLabelAbNormal:
        {
            self.hintLbl.font      = GL_FONT(18);
            self.hintLbl.textColor = TCOL_GLUCOSEHEIGHT;
            self.hintLbl.text      = [NSString stringWithFormat:@"%ld点到%@\n您的血糖共出现\n%ld次异常",hour,selectHourStr,abnormalCount];

        }
            break;
        default:
            break;
    }
    
    if (status != GLRingTimeHintLabelPolarizationStatus) {
        //5秒后恢复展示实时血糖
        GLButton *timeBtn = [self viewWithTag:30 + (hour == 0 ? 24 : hour)];
        
        double delayInSeconds = 5.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [ws setStatus:GLRingTimeConnectingStatus];
            timeBtn.selected = false;
        });
    }
}

//极化计时
- (void)timeKeeping
{
    WS(ws);
    GL_DISPATCH_MAIN_QUEUE(^{
        NSInteger timeInter           = 20 * 60 - ([[NSDate date] timeIntervalSince1970] - [[[GL_USERDEFAULTS stringForKey:SamStartBinDingDeviceTime] toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970]);
        NSDate *date                  = [NSDate dateWithTimeIntervalInMilliSecondSince1970:timeInter];
        self.polarizationTimeLbl.text = [date toString:@"mm:ss"];
        
        if (timeInter <= 0) {
            //停止计时器
            GL_DISPATCH_MAIN_QUEUE(^{
                [ws.timer setFireDate:[NSDate distantFuture]];
                [ws setStatus:GLRingTimeConnectingStatus];
                [GL_USERDEFAULTS setBool:true forKey:SamPolarizationFinish];
                [GL_USERDEFAULTS synchronize];
                if (ws.polarizationFinish) {
                    ws.polarizationFinish();
                }
            });
        }
        
        if (timeInter == 11) {
            if (ws.polarizationElevenMinutes) {
                ws.polarizationElevenMinutes();
            }
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
    if (![self.nowHourBtn.text isEqualToString:[[NSDate date] toString:@"H"]] || !self.nowHourBtn.layer.animationKeys.count) { //判断时间是否变更和动画是否停止
        WS(ws);

        GL_DISPATCH_MAIN_QUEUE(^{
            //先移除之前按钮的动画
            [ws.nowHourBtn.layer removeAllAnimations];
            //找到当前时间对应的按钮
            ws.nowHourBtn = [[[NSDate date] toString:@"H"] isEqualToString:@"0"] ? [self viewWithTag:54] : [self viewWithTag:(30 + [[[NSDate date] toString:@"H"] integerValue])];
            
            [ws animateFirstRoundWithHourBtn];
            
            [self.tmpTimeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(ws.nowHourBtn);
                make.center.equalTo(ws.nowHourBtn);
            }];
            
            if (ISBINDING) {
                [ws.nowHourBtn setImage:[UIImage imageWithColor:TCOL_MAIN size:CGSizeMake(16, 16)] forState:UIControlStateNormal];
                [ws.nowHourBtn setUserInteractionEnabled:true];
                //刷新按钮状态
                [self refreshAllTimebuttonWarningState];
            }
        });
        
    }
    //    }
}

//为小时按钮生成呼吸效果
- (void)animateFirstRoundWithHourBtn
{
    WS(ws);
    GL_DISPATCH_MAIN_QUEUE(^{
        ws.nowHourBtn.alpha = 0.3f;
        [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
            ws.nowHourBtn.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    });
}

//- (void)animateSecondRoundWithHourBtn
//{
//    GLButton *hourBtn = [self.nowHour isEqualToString:@"0"] ? [self viewWithTag:54] : [self viewWithTag:(30 + [self.nowHour integerValue])];
//
//    WS(ws);
//    GL_DISPATCH_MAIN_QUEUE(^{
//        [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            hourBtn.alpha = 0.3f;
//        } completion:^(BOOL finished) {
//            [ws animateFirstRoundWithHourBtn];
//        }];
//    });
//}

/**
 连接设备按钮点击事件
 */
- (void)connectBtnClick:(UIButton *)sender
{
    if (_connectBtnClick) {
        _connectBtnClick();
    }
}

//闪烁按钮点击事件
- (void)tmpTimeBtnClick:(GLButton *)sender
{
    if (ISBINDING) { //绑定状态下可以触发点击事件
        [self timeBtnClick:self.nowHourBtn];
    }
}

//时间按钮点击事件
- (void)timeBtnClick:(GLButton *)sender
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
        [self setStatus:GLRingTimeCheckedStatus];
        
        NSInteger count = [self.warningDic getIntegerValue:sender.text];

        [self changeHintLblSatuts:count ?  GLRingTimeHintLabelAbNormal : GLRingTimeHintLabelNormal WithHour:[sender.text integerValue] WithAbnormalCount:count];

    } else {
        //取消显示预警信息
        [self setStatus:GLRingTimeConnectingStatus];
    }
}

- (void)refreshAllTimebuttonWarningState
{
    for (NSInteger i = 0; i <= 24; i++) {
        [self.warningDic setValue:@"0" forKey:[@(i) stringValue]];
    }

    NSArray *bloodValueArr = [GLCache readCacheArrWithName:SamBloodValueArr];
    for (NSDictionary *valueDic in bloodValueArr) {
        NSDate *date   = [[valueDic getStringValue:@"collectedtime"] toDateDefault];
        //取同一天的数据
        if ([[date toString:@"dd"] isEqualToString:[[NSDate date] toString:@"dd"]]) {
            NSString *hour = [date toString:@"H"];
            CGFloat value  = [valueDic getFloatValue:@"value"];
            //保存每一个小时的异常数据
            if (value > 0 && (value <= [GL_USERDEFAULTS getFloatValue:SamTargetLow] || value >= [GL_USERDEFAULTS getFloatValue:SamTargetHeight])) {
                GLButton *timeBtn = [self viewWithTag:30 + ([hour integerValue] == 0 ? 24 : [hour integerValue])];
                //如果警告按钮不是红色则改为红色
                if (!CGColorEqualToColor(timeBtn.nomBackGroundColor.CGColor, TCOL_RINGTIMEWAR.CGColor)) {
                    [timeBtn setImage:[UIImage imageWithColor:TCOL_RINGTIMEWAR size:CGSizeMake(16, 16)] forState:UIControlStateNormal];
                }
                NSInteger count = [[self.warningDic objectForKey:hour] integerValue];
                count += 1;
                [self.warningDic setValue:[@(count) stringValue] forKey:hour];
            }
        }
    }
}

#pragma mark - createUI
- (void)createUI
{
    self.backgroundColor = TCOL_BG;
    
    [self addSubview:self.connectionBtn];
    [self addSubview:self.hintLbl];
    [self addSubview:self.polarizationTimeLbl];
    [self addSubview:self.timeDataView];
    [self addSubview:self.helpBtn];
    
    WS(ws);
    
    [self.connectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.width.mas_equalTo(150);
    }];
    
    [self.polarizationTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(22);
        make.centerX.equalTo(ws);
    }];
    
    [self.timeDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(180, 180));
    }];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(ws).offset(9);
        make.right.equalTo(ws.mas_right).offset(-29);
    }];
    
    //绘制环形时间按钮
    NSDate *binDingTimeDate1 = [[GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime] toDate:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *binDingTimeDate2 = [[binDingTimeDate1 toString:@"yyyy-MM-dd HH:00:00"] toDate:@"yyyy-MM-dd HH:mm:ss"];
    
    float dist = SCREEN_HEIGHT >= GL_IPHONE_6_PLUS_SCREEN_HEIGHT ? GL_IP6_H_RATIO(104) : 104;//半径
    for (int i= 1; i<= 24;i++) {
        float angle = degreesToRadians((360 / 24) * i);
        float y = cos(angle) * dist;
        float x = sin(angle) * dist;
        
        GLButton *btn           = [GLButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        
        btn.width               = 28;
        btn.height              = 28;
        btn.tag                 = 30 + i;
        btn.cornerRadius        = btn.width/2;
        btn.layer.masksToBounds = true;
        btn.highlighted         = false;
        [btn.lbl setFont:GL_FONT(8)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (i == 24) {
            [btn setTitle:@"0" forState:UIControlStateNormal];
        } else {
            [btn setTitle:[@(i) stringValue] forState:UIControlStateNormal];
        }
        
//        [btn setBackgroundColor:TCOL_RINGTIMESEL forState:UIControlStateSelected];
        [btn setImage:[UIImage imageWithColor:TCOL_RINGTIMESEL size:CGSizeMake(16, 16)] forState:UIControlStateSelected];
        
        
        NSDate *btnHourTime = [[[NSDate date] toString:[NSString stringWithFormat:@"yyyy-MM-dd %@:00:00",btn.text]] toDate:@"yyyy-MM-dd HH:mm:ss"];
        
        //按钮显示时间与绑定时间的时差
        NSTimeInterval bingdinTimeBetween = [btnHourTime timeIntervalSinceDate:binDingTimeDate2];
        //按钮显示时间与当前时间的时差
        NSTimeInterval nowTimeBetween = [btnHourTime timeIntervalSinceDate:[NSDate date]];
        
        if (ISBINDING && bingdinTimeBetween >= 0 && nowTimeBetween <= 0) {
            [btn setImage:[UIImage imageWithColor:TCOL_MAIN size:CGSizeMake(16, 16)] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageWithColor:TCOL_RINGTIMENOR size:CGSizeMake(16, 16)] forState:UIControlStateNormal];
            btn.userInteractionEnabled = false;
        }
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint center = CGPointMake(SCREEN_WIDTH/2 + x,240/2 -  y);
        btn.center     = center;
        
        //设置btn的imageview
        btn.iv.cornerRadius  = 16/2;
        btn.iv.masksToBounds = true;
        [btn.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(btn);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    [self refreshAllTimebuttonWarningState];
    
    [self addSubview:self.tmpTimeBtn];
    
    if (ISBINDING) {
        [self setStatus:GLRingTimeConnectingStatus];
    } else {
        [self setStatus:GLRingTimeUnunitedStatus];
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

- (RingRealTimeDataView *)timeDataView
{
    if (!_timeDataView) {
        _timeDataView        = [RingRealTimeDataView new];
        _timeDataView.hidden = true;
        WS(ws);
        _timeDataView.dataAnalysisBtn.buttonClick = ^(GLButton *sender) {
            if (ws.dataAnalysisBtnClick) {
                ws.dataAnalysisBtnClick();
            }
        };
    }
    return _timeDataView;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =   [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeKeeping) userInfo:nil repeats:true];
    }
    return _timer;
}

- (GLButton *)tmpTimeBtn
{
    if (!_tmpTimeBtn) {
        _tmpTimeBtn = [GLButton new];
        [_tmpTimeBtn addTarget:self action:@selector(tmpTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tmpTimeBtn;
}

- (GLButton *)helpBtn
{
    if (!_helpBtn) {
        _helpBtn = [GLButton new];
        [_helpBtn setImage:GL_IMAGE(@"帮助-使用说明") forState:UIControlStateNormal];
    }
    return _helpBtn;
}

- (GLButton *)nowHourBtn
{
    if (!_nowHourBtn) {
        _nowHourBtn = [GLButton new];
    }
    return _nowHourBtn;
}

- (NSMutableDictionary *)warningDic
{
    if (!_warningDic) {
        _warningDic = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i <= 24; i++) {
            [_warningDic setValue:@"0" forKey:[@(i) stringValue]];
        }
    }
    return _warningDic;
}

@end
