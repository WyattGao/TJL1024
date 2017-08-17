
//
//  WoChangePassWordWihPhoneFinishViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/25.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoChangePassWordWihPhoneFinishViewController.h"

@interface WoChangePassWordWihPhoneFinishViewController ()

@end

@implementation WoChangePassWordWihPhoneFinishViewController

- (void)navLeftBtnClick:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self.view setBackgroundColor:TCOL_BGGRAY];
    
    switch (_type) {
        case GLFinishChangePassWord:
            [self setNavTitle:@"修改密码"];
            break;
        case GLFinishChangePhone:
            [self setNavTitle:@"修改手机号"];
            break;
        case GLFinishFeedBack:
            [self setNavTitle:@"意见反馈"];
            break;
        default:
            break;
    }
    
    self.navigationItem.hidesBackButton = true;
    
    [self addSubView:self.finishIV];
    [self addSubView:self.hintLbl];
    [self addSubView:self.finishBtn];
    
    WS(ws);
    
    [self.finishIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(50 + 64);
        make.centerX.equalTo(ws.view);
    }];
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.finishIV.mas_bottom).offset(46);
        make.centerX.equalTo(ws.finishIV);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(97);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
    }];
}

- (UIImageView *)finishIV
{
    if (!_finishIV) {
        _finishIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"账号安全-修改成功")];
    }
    return _finishIV;
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl = [UILabel new];
        
        switch (_type) {
            case GLFinishChangePassWord:
                _hintLbl.text = @"修改成功！下次请使用新设置的密码登录。";
                break;
            case GLFinishChangePhone:
                _hintLbl.text = @"修改成功！下次请使用新的手机号登录。";
                break;
            case GLFinishFeedBack:
                _hintLbl.text = @"提交成功！非常感谢您为我们提供的宝贵意见！";
                break;
            default:
                break;
        }
        
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textAlignment = NSTextAlignmentCenter;
        _hintLbl.textColor     = RGB(153, 153, 153);
    }
    return _hintLbl;
}

- (GLNextBtn *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[GLNextBtn alloc]initWithType:GLFinishBtnNomalType];
        WS(ws);
        _finishBtn.glNextBtnClick = ^{
            GL_DISPATCH_MAIN_QUEUE(^{
                [ws.navigationController popToRootViewControllerAnimated:true];
            });
        };
    }
    return _finishBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
