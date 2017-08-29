//
//  WoEnterPhoneNumberView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/29.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoEnterPhoneNumberView.h"


@implementation WoEnterPhoneNumberView

- (void)textfieldFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 11) {
        _nextBtn.selected               = true;
        _nextBtn.userInteractionEnabled = true;
    } else {
        _nextBtn.selected               = false;
        _nextBtn.userInteractionEnabled = false;
    }
}

- (void)createUI
{
    [self addSubview:self.hintLbl];
    [self addSubview:self.phoneTF];
    [self addSubview:self.nextBtn];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 53));
        make.top.equalTo(ws);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.centerX.equalTo(ws);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.phoneTF.mas_bottom).offset(100);
        make.centerX.equalTo(ws);
        
    }];
    
    switch (self.type) {
        case EnterPhoneNuamberForChangePassWord:
            self.hintLbl.text        = @"请输入您注册的手机号";
            self.phoneTF.placeholder = @"请输入手机号";
            break;
        case EnterPhoneNumaberForChangePhoneNumber:
        {
            NSString *phoneStr          = [[GL_USERDEFAULTS getStringValue:@"PHONE"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            NSString *highlightStr      = @"当前手机号码";
            self.hintLbl.attributedText = [NSMutableAttributedString setAllText:[NSString stringWithFormat:@"请输入完整的%@（%@）",highlightStr,phoneStr] andSpcifiStr:highlightStr withColor:TCOL_HIGHLIGHTSTR specifiStrFont:GL_FONT(14)];
            self.phoneTF.placeholder    = @"请输入当前手机号";
        }
            break;
        case EnterPhoneNuamberForNewPhoneNumber:
        {
            NSString *highlightStr      = @"新的";
            self.hintLbl.attributedText = [NSMutableAttributedString setAllText:[NSString stringWithFormat:@"请输入%@手机号码",highlightStr] andSpcifiStr:highlightStr withColor:TCOL_HIGHLIGHTSTR specifiStrFont:GL_FONT(14)];
            self.phoneTF.placeholder    = @"请输入新的手机号";
        }
            break;
        default:
            break;
    }
    
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textColor     = RGB(153, 153, 153);
        _hintLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLbl;
}

- (GLTextField *)phoneTF
{
    if (!_phoneTF) {
        _phoneTF = [GLTextField new];
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.glDelegate = self;
    }
    return _phoneTF;
}

- (GLNextBtn *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn                        = [[GLNextBtn alloc]initWithType:GLNextBtnNormalType];
        _nextBtn.userInteractionEnabled = false;
    }
    return _nextBtn;
}

@end
