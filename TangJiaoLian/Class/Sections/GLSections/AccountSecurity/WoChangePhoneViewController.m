//
//  WoChangePhoneViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoChangePhoneViewController.h"
#import "WoChangePassWordWihPhoneFinishViewController.h"

@interface WoChangePhoneViewController ()

@property (nonatomic,strong) WoChangePassWordWihPhoneFinishViewController *finishVC;

@end

@implementation WoChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self addSubView:self.hintLbl];
    [self addSubView:self.phoneTF];
    [self addSubView:self.nextBtn];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64 + 16);
        make.centerX.equalTo(ws.view);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(17);
        make.centerX.equalTo(ws.hintLbl);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.phoneTF.mas_bottom).offset(100);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 40));
    }];
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl                = [UILabel new];
        _hintLbl.attributedText = [NSMutableAttributedString setAllText:@"请输入新的手机号码"
                                                           andSpcifiStr:@"新的"
                                                              withColor:RGB(252, 79, 8)
                                                         specifiStrFont:GL_FONT(15)];
        _hintLbl.font           = GL_FONT(14);
        _hintLbl.textColor      = TCOL_SUBHEADTEXT;
    }
    return _hintLbl;
}

- (GLTextField *)phoneTF
{
    if (!_phoneTF) {
        _phoneTF                  = [GLTextField new];
        _phoneTF.placeholder      = @"请输入新的手机号";
        _phoneTF.font             = GL_FONT(16);
        _phoneTF.placeholderColor = TCOL_SUBHEADTEXT;
        _phoneTF.textAlignment    = NSTextAlignmentCenter;
        _phoneTF.backgroundColor  = RGB(255, 255, 255);
    }
    return _phoneTF;
}

- (GLNextBtn *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[GLNextBtn alloc]initWithType:GLNextBtnNormalType];
        WS(ws);
        _nextBtn.glNextBtnClick = ^{
            [ws pushWithController:ws.finishVC];
        };
    }
    return _nextBtn;
}

- (WoChangePassWordWihPhoneFinishViewController *)finishVC
{
    if (!_finishVC) {
        _finishVC = [WoChangePassWordWihPhoneFinishViewController new];
        _finishVC.type = GLFinishChangePhone;
    }
    return _finishVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
