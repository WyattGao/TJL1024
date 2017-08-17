//
//  XueTangPolarizationView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangPolarizationView.h"

@interface XueTangPolarizationView ()

@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation XueTangPolarizationView

- (void)createUI
{
    self.backgroundColor = TCOL_MASKBG;
    self.hidden = true;
    
    [self addSubview:self.timeLbl];
    
    WS(ws);
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws).offset(-20);
        make.centerX.equalTo(ws);
    }];
}

- (UILabel *)timeLbl
{
    if (!_timeLbl) {
        _timeLbl               = [UILabel new];
        _timeLbl.font          = GL_FONT_B(30);
        _timeLbl.textColor     = RGB(255, 255, 255);
        _timeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLbl;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer =   [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeKeeping) userInfo:nil repeats:true];
    }
    return _timer;
}

- (void)timeKeeping
{
    GL_DISPATCH_MAIN_QUEUE(^{
        NSInteger timeInter = 20 * 60 - ([[NSDate date] timeIntervalSince1970] - [[[GL_USERDEFAULTS stringForKey:SamStartBinDingDeviceTime] toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970]);
        NSDate *date        = [NSDate dateWithTimeIntervalInMilliSecondSince1970:timeInter];
        self.timeLbl.text   = [NSString stringWithFormat:@"极化中 %@",[date toString:@"mm:ss"]];
        
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

- (void)startTimeKeeping
{
    GL_DISPATCH_MAIN_QUEUE(^{
        if (_polarizationFinish) {
            _polarizationFinish(false);
        }
        self.hidden = false;
        [self.timer setFireDate:[NSDate date]];
        [self.timer fire];
    });
}



@end
