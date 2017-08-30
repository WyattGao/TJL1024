//
//  WoEnterPhoneNumberViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/29.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoEnterPhoneNumberViewController.h"
#import "WoGetVerificationCodeViewController.h"

@interface WoEnterPhoneNumberViewController ()

@property (nonatomic,strong) WoEnterPhoneNumberView                  *enterPhoneNumberView;

@property (nonatomic,strong) WoGetVerificationCodeViewController *changePassWordVC; /**< 修改密码获取验证码 */

@property (nonatomic,strong) WoGetVerificationCodeViewController *changePhoneVC; /**< 修改手机号获取验证码 */

@property (nonatomic,strong) WoGetVerificationCodeViewController *getVerificationCodeNewPhoneVC;

@end

@implementation WoEnterPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setType:(EnterPhoneNuamberType)type
{
    _type = type;
    self.enterPhoneNumberView.phoneTF.text = @"";
}

- (void)createUI
{
    [self.view addSubview:self.enterPhoneNumberView];
    
    WS(ws);
    
    [self.enterPhoneNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    switch (self.type) {
        case EnterPhoneNuamberForChangePassWord:
            [self setNavTitle:@"密码找回"];
            break;
        case EnterPhoneNumaberForChangePhoneNumber:
            [self setNavTitle:@"更换手机号"];
            break;
        case EnterPhoneNuamberForNewPhoneNumber:
            [self setNavTitle:@"更换手机号"];
            break;
        default:
            break;
    }
}

- (WoEnterPhoneNumberView *)enterPhoneNumberView
{
    if (!_enterPhoneNumberView) {
        _enterPhoneNumberView      = [WoEnterPhoneNumberView new];
        _enterPhoneNumberView.type = self.type;
        WS(ws);
        _enterPhoneNumberView.nextBtn.glNextBtnClick = ^{
            BOOL isBinDingPhone = [ws.enterPhoneNumberView.phoneTF.text isEqualToString:[GL_USERDEFAULTS getStringValue:@"PHONE"]];
            switch (ws.type) {
                case EnterPhoneNuamberForChangePassWord:
                    if (isBinDingPhone) {
                        [ws pushWithController:ws.changePassWordVC];
                    } else {
                        GL_ALERTCONTR_1(@"您所输入的手机号不正确");
                    }
                    break;
                case EnterPhoneNumaberForChangePhoneNumber:
                    if (isBinDingPhone) {
                        [ws pushWithController:ws.changePhoneVC];
                    } else {
                        GL_ALERTCONTR_1(@"您所输入的手机号不正确");
                    }
                    break;
                case EnterPhoneNuamberForNewPhoneNumber:
                    if (isBinDingPhone) {
                        GL_ALERTCONTR_1(@"请输入新的手机号码，该号码已经是您的绑定号码");
                    } else {
                        
                        ws.getVerificationCodeNewPhoneVC.phoneNumberStr = ws.enterPhoneNumberView.phoneTF.text;
                        [ws pushWithController:ws.getVerificationCodeNewPhoneVC];
                    }
                    break;
                default:
                    break;
            }
        };
    }
    return _enterPhoneNumberView;
}

- (WoGetVerificationCodeViewController *)changePassWordVC
{
    if (!_changePassWordVC) {
        _changePassWordVC                = [WoGetVerificationCodeViewController new];
        _changePassWordVC.phoneNumberStr = [GL_USERDEFAULTS getStringValue:@"PHONE"];
        _changePhoneVC.viewType          = GetVerificationCodePassWord;
    }
    return _changePassWordVC;
}

- (WoGetVerificationCodeViewController *)changePhoneVC
{
    if (!_changePhoneVC) {
        _changePhoneVC                = [WoGetVerificationCodeViewController new];
        _changePhoneVC.phoneNumberStr = [GL_USERDEFAULTS getStringValue:@"PHONE"];
        _changePhoneVC.viewType       = GetVerificationCodeOldPhone;
    }
    return _changePhoneVC;
}

- (WoGetVerificationCodeViewController *)getVerificationCodeNewPhoneVC
{
    if (!_getVerificationCodeNewPhoneVC) {
        _getVerificationCodeNewPhoneVC = [WoGetVerificationCodeViewController new];
        _getVerificationCodeNewPhoneVC.viewType = GetVerificationCodeNewPhone;
    }
    return _getVerificationCodeNewPhoneVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
