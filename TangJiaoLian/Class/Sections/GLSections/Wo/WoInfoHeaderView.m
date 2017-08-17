//
//  WoInfoHeaderView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoInfoHeaderView.h"

static const NSInteger kPhotoWidth = 90;

@implementation WoInfoHeaderView

- (void)refresh
{
    if (ISLOGIN) {
        [_userPhotoIV sd_setImageWithURL:GL_URL([GL_USERDEFAULTS getStringValue:@"PIC"])
                        placeholderImage:GL_IMAGE(@"用户默认头像")];
        _userNameLbl.text      = [GL_USERDEFAULTS getStringValue:@"USERNAME"];
    } else {
        [_userPhotoIV setImage:GL_IMAGE(@"用户默认头像")];
        _userNameLbl.text      = @"未登录";
    }
}

//编辑个人信息按钮点击事件
- (void)editInfoBtnClick:(UIButton *)sender
{
    if (_editInfoClick) {
        _editInfoClick();
    }
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.backGroudIV];
    [self addSubview:self.userPhotoMaskIV];
    [self addSubview:self.userPhotoIV];
    [self addSubview:self.userNameLbl];
    [self addSubview:self.editInfoBtn];
    
    WS(ws);
    
    [self.backGroudIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, GL_IP6_H_RATIO(46), 0));
    }];
    
    [self.userPhotoMaskIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GL_IP6_H_RATIO(90), GL_IP6_H_RATIO(90)));
        make.top.equalTo(ws).offset(GL_IP6_H_RATIO(47));
        make.centerX.equalTo(ws);
    }];
    
    [self.userPhotoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.userPhotoMaskIV);
        make.size.mas_equalTo(CGSizeMake(GL_IP6_H_RATIO(kPhotoWidth) ,GL_IP6_H_RATIO(kPhotoWidth)));
    }];
    
    [self.userNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.userPhotoIV.mas_bottom).offset(GL_IP6_H_RATIO(15));
        make.centerX.equalTo(ws.userPhotoIV);
    }];
    
    [self.editInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws).offset(-15);
        make.top.equalTo(ws).offset(35);
    }];
}

- (UIImageView *)backGroudIV
{
    if (!_backGroudIV) {
        _backGroudIV                        = [[UIImageView alloc]initWithImage:GL_IMAGE(@"我的-bar")];
        _backGroudIV.userInteractionEnabled = true;
        UITapGestureRecognizer *gesture     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editInfoBtnClick:)];
        [_backGroudIV addGestureRecognizer:gesture];
    }
    return _backGroudIV;
}

- (UIImageView *)userPhotoIV
{
    if (!_userPhotoIV) {
        _userPhotoIV              = [UIImageView new];
        _userPhotoIV.borderWidth  = 3;
        _userPhotoIV.cornerRadius = GL_IP6_H_RATIO(kPhotoWidth)/2;
        _userPhotoIV.borderColor  = [UIColor whiteColor];
        _userPhotoIV.masksToBounds= true;

        if (ISLOGIN) {
            [_userPhotoIV sd_setImageWithURL:GL_URL([GL_USERDEFAULTS getStringValue:@"PIC"])
                            placeholderImage:GL_IMAGE(@"用户默认头像")];
        } else {
            _userPhotoIV.image = GL_IMAGE(@"用户默认头像");
        }
    }
    return _userPhotoIV;
}

- (UIImageView *)userPhotoMaskIV
{
    if (!_userPhotoMaskIV) {
        _userPhotoMaskIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"我的-头像遮罩")];
    }
    return _userPhotoMaskIV;
}

- (UILabel *)userNameLbl
{
    if (!_userNameLbl) {
        _userNameLbl           = [UILabel new];
        _userNameLbl.font      = GL_FONT_B(18);
        _userNameLbl.textColor = TCOL_WHITETEXT;
        _userNameLbl.text      = ISLOGIN ? [GL_USERDEFAULTS getStringValue:@"USERNAME"] : @"未登录";
    }
    return _userNameLbl;
}

- (GLButton *)editInfoBtn
{
    if (!_editInfoBtn) {
        _editInfoBtn = [GLButton new];
        [_editInfoBtn setImage:GL_IMAGE(@"我的-编辑") forState:UIControlStateNormal];
    }
    return _editInfoBtn;
}

@end
