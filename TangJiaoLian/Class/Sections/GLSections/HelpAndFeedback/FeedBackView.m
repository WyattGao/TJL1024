//
//  FeedBackView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FeedBackView.h"

@implementation FeedBackView

- (void)createUI
{
    self.backgroundColor = TCOL_BGGRAY;
    
    [self addSubview:self.hintLbl];
    [self addSubview:self.feedBackTV];
    [self addSubview:self.mailOrPhoneTF];
    [self addSubview:self.nextBtn];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(16);
        make.centerX.equalTo(ws);
        make.width.mas_equalTo(SCREEN_WIDTH - 16 * 2);
    }];
    
    [self.feedBackTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(17);
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,  /*375 / SCREEN_WIDTH  * */ GL_IP6_H_RATIO(210)));
    }];
    
    [self.mailOrPhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.feedBackTV.mas_bottom).offset(20);
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mailOrPhoneTF.mas_bottom).offset(GL_IP6_H_RATIO(101));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
        make.centerX.equalTo(ws);
    }];
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.text          = @"请把您的宝贵意见告诉我们，我们的进步离不开您的支持。";
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textColor     = TCOL_SUBHEADTEXT;
        _hintLbl.numberOfLines = 0;
    }
    return _hintLbl;
}

- (GLTextView *)feedBackTV
{
    if (!_feedBackTV) {
        _feedBackTV                    = [GLTextView new];
        _feedBackTV.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _feedBackTV.backgroundColor    = [UIColor whiteColor];
        _feedBackTV.returnKeyType      = UIReturnKeyDone;
        _feedBackTV.font               = GL_FONT(14);
        _feedBackTV.placeholder        = @"在此输入反馈内容";
        _feedBackTV.lineSpacing        = 6;
    }
    return _feedBackTV;
}

- (GLTextField *)mailOrPhoneTF
{
    if (!_mailOrPhoneTF) {
        _mailOrPhoneTF                 = [GLTextField new];
        _mailOrPhoneTF.placeholder     = @"您的邮箱或手机号";
        _mailOrPhoneTF.font            = GL_FONT(16);
        _mailOrPhoneTF.textAlignment   = NSTextAlignmentCenter;
        _mailOrPhoneTF.backgroundColor = [UIColor whiteColor];
    }
    return _mailOrPhoneTF;
}

- (GLNextBtn *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn          = [[GLNextBtn alloc]initWithType:GLSubmitBtnNormalType];
        _nextBtn.selected = true;
    }
    return _nextBtn;
}

@end
