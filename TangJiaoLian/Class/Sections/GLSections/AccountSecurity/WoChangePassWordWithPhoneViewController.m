//
//  WoChangePassWordWithPhoneViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoChangePassWordWithPhoneViewController.h"
#import "WoChangePassWordWIthPhoneView.h"
#import "WoChangePassWordViewController.h"

@interface WoChangePassWordWithPhoneViewController ()

@property (nonatomic,strong) WoChangePassWordWIthPhoneView *mainView;
@property (nonatomic,strong) WoChangePassWordViewController *changePassWordVC;

@end

@implementation WoChangePassWordWithPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    if (_viewType == ChangePassWord) {
        [self setNavTitle:@"修改密码"];
    } else {
        [self setNavTitle:@"更换手机号"];
    }
    
    [self setLeftBtnImgNamed:nil];
    
    self.view.backgroundColor = TCOL_BGGRAY;
    
    [self addSubView:self.mainView];
    
    WS(ws);
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (void)createData
{
//    [self sendCodeRequst];
}

- (void)sendCodeRequst
{
    WS(ws);
    NSDictionary *postDic = @{
                              FUNCNAME : @"send",
                              INFIELD  : @{
                                      @"PHONE":ws.phoneNumberStr
                                      }
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                [ws.mainView changeCodeBtnState];
            } else {
                GL_ALERT_E(GETRETMSG);
            }
        } else {
            GL_ALERT_E(GETMESSAGE);
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"获取验证码失败,请检查网络");
    }];
}

- (WoChangePassWordWIthPhoneView *)mainView
{
    WS(ws);
    if (!_mainView) {
        _mainView = [WoChangePassWordWIthPhoneView new];
        _mainView.bindingPhoneStr = ws.phoneNumberStr;
        _mainView.codeBtnClick = ^{
            [ws sendCodeRequst];
        };

        _mainView.nextBtnClick = ^{
            [ws pushWithController:ws.changePassWordVC];
            /*
            NSDictionary *postDic = @{
                                      FUNCNAME : @"checkVerifyCode",
                                      INFIELD  : @{
                                                @"PHONE" : ws.phoneNumberStr,
                                                @"VERIFYCODE" : ws.mainView.codeTF.text
                                              }
                                      };
            [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                if (GETTAG) {
                    if (GETRETVAL) {
                        [ws pushWithController:ws.changePassWordVC];
                    } else {
                        GL_ALERT_E(GETRETMSG);
                    }
                } else {
                    GL_ALERT_E(GETMESSAGE);
                }
            } failure:^(GLRequest *request, NSError *error) {
                
            }];
             */
        };
    }
    return _mainView;
}

- (WoChangePassWordViewController *)changePassWordVC
{
    if (!_changePassWordVC) {
        _changePassWordVC = [WoChangePassWordViewController new];
    }
    return _changePassWordVC;
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
