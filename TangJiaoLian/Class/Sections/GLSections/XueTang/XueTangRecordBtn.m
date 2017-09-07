//
//  XueTangRecordBtn.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/14.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangRecordBtn.h"

@implementation XueTangRecordBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:TCOL_RECORDNORCOLOR forState:UIControlStateNormal];
        [self setBackgroundColor:TCOL_MAIN forState:UIControlStateSelected];
        [self setTitleColor:TCOL_HOMETEXTCOLOR forState:UIControlStateNormal];
        [self setFont:GL_FONT(14)];
        [self setGraphicLayoutState:PICTOP];
        [self setGraphicLayoutSpacing:7];
        
        [self addSubview:self.successHintView];
        
        WS(ws);
        
        [self.successHintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws);
            make.size.equalTo(ws);
        }];
    }
    return self;
}


- (void)setStatus:(GLRecordBtnStatus)status
{
    WS(ws);
    switch (status) {
        case GLRecordBtnSuccess:
        {
            self.successHintView.hidden = false;
            self.hintLbl.text = @"记录成功";
            
            WS(ws);
            
            [self.hintLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.hintIV.mas_bottom).offset(5);
                make.centerX.equalTo(ws.successHintView);
            }];
            
            //延时运行
            double delayInSeconds = 5.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                ws.successHintView.hidden = true;
            });
        }
            break;
       case GLRecordBtnTimings:
        {
            self.successHintView.hidden = false;
            self.hintLbl.text = @"10分钟内只需记录一次";
            
            [self.successHintView addSubview:self.hintLbl];
            
            WS(ws);
            
            [ws.hintLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(ws.successHintView);
                make.width.equalTo(ws).offset(-GL_IP6_W_RATIO(13));
            }];
            
            //延时运行
            double delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                ws.successHintView.hidden = true;
            });
        }
            break;
        case GLRecordBtnNormal:
        {
            self.successHintView.hidden = true;
        }
            break;
        default:
            break;
    }
}


- (UIView *)successHintView
{
    if (!_successHintView) {
        _successHintView                 = [UIView new];
        _successHintView.backgroundColor = TCOL_RECORDBTNHINT;
        _successHintView.hidden          = true;
        
        [_successHintView addSubview:self.hintLbl];
        [_successHintView addSubview:self.hintIV];
        
        [self.hintIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_successHintView).offset(GL_IP6_H_RATIO(12));
            make.centerX.equalTo(_successHintView);
        }];
//
//        [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(ws.hintIV.mas_bottom).offset(5);
//            make.centerX.equalTo(ws);
//        }];
        }
    return _successHintView;
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textColor     = TCOL_HOMETEXTCOLOR;
        _hintLbl.textAlignment = NSTextAlignmentCenter;
        _hintLbl.text          = @"记录成功";
    }
    return _hintLbl;
}

- (UIImageView *)hintIV
{
    if (!_hintIV) {
        _hintIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"成功")];
    }
    return _hintIV;
}

@end
