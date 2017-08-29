//
//  WoEnterPhoneNumberView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/29.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoEnterPhoneNumberView.h"

@implementation WoEnterPhoneNumberView

- (void)createUI
{
    [self addSubview:self.hintLbl];
    [self addSubview:self.phoneTF];
    [self addSubview:self.nextBtn];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl = [UILabel new];
        switch (<#expression#>) {
            case <#constant#>:
                <#statements#>
                break;
                
            default:
                break;
        }
    }
    return _hintLbl;
}

- (GLTextField *)phoneTF
{
    if (!_phoneTF) {
        _phoneTF = [GLTextField new];
        _phoneTF.placeholder = @"请输入手机号";
    }
    return _phoneTF;
}

- (GLNextBtn *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[GLNextBtn alloc]initWithType:GLNextBtnNormalType];
    }
    return _nextBtn;
}

@end
