//
//  WoChangePassWordWIthPhoneView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoChangePassWordWIthPhoneView.h"
#import "NSMutableAttributedString+Category.h"

@implementation WoChangePassWordWIthPhoneView

- (void)setBindingPhoneStr:(NSString *)bindingPhoneStr
{
    _bindingPhoneStr        = bindingPhoneStr;
    _hintLbl.attributedText = [NSMutableAttributedString setAllText:[NSString stringWithFormat:@"我们已经给您的手机号码 %@ 发送了一条验证短信，请输入短信验证码。",self.bindingPhoneStr] andSpcifiStr:self.bindingPhoneStr withColor:RGB(252,79,8) specifiStrFont:GL_FONT(14)];
}

- (void)nextBtnClick:(GLButton *)sender
{
    if (self.nextBtnClick) {
        self.nextBtnClick();
    }
}

- (void)codeBtnClick:(GLButton *)sender
{
    if (sender.userInteractionEnabled == YES) {
        if (self.codeBtnClick) {
            self.codeBtnClick();
        }
    }
}

- (void)changeCodeBtnState
{
    WS(ws);
    //倒计时时间
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                ws.codeBtn.selected               = false;
                ws.codeBtn.userInteractionEnabled = YES;
                [ws.codeBtn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                ws.codeBtn.selected = true;
                int seconds         = timeout % 60;
                NSString *strTime   = [NSString stringWithFormat:@"%.2d", seconds];
                [ws.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%@)",strTime] forState:UIControlStateNormal];
                ws.codeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)createUI
{
    [self addSubview:self.hintLbl];
    [self addSubview:self.codeTF];
    [self addSubview:self.codeBtn];
    [self addSubview:self.nextBtn];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(16);
        make.centerX.equalTo(ws);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(17);
        make.left.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 120, 50));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(120, 50));
        make.centerY.equalTo(ws.codeTF);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.codeTF.mas_bottom).offset(101);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
        make.centerX.equalTo(ws);
    }];
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textColor     = RGB(153, 153, 153);
        _hintLbl.numberOfLines = 0;
    }
    return _hintLbl;
}

- (GLTextField *)codeTF
{
    if (!_codeTF) {
        _codeTF                 = [GLTextField new];
        _codeTF.textAlignment   = NSTextAlignmentCenter;
        _codeTF.placeholder     = @"请输入短信验证码";
        _codeTF.font            = GL_FONT(16);
        _codeTF.backgroundColor = RGB(255, 255, 255);
        _codeTF.keyboardType    = UIKeyboardTypeNumberPad;
    }
    return _codeTF;
}

- (GLButton *)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [GLButton new];
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_codeBtn setFont:GL_FONT(14)];
        [_codeBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_codeBtn setBackgroundColor:RGB(153, 153, 153) forState:UIControlStateSelected];
        [_codeBtn setBackgroundColor:RGB(0, 204, 153) forState:UIControlStateNormal];
    }
    return _codeBtn;
}

- (GLButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [GLButton new];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setFont:GL_FONT(16)];
        [_nextBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
        [_nextBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_nextBtn setTextAlignment:NSTextAlignmentCenter];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setCornerRadius:5];
    }
    return _nextBtn;
}


@end
