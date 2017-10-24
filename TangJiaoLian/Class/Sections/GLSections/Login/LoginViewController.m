//
//  LoginViewController.m
//  RTLibrary-ios
//
//  Created by 高临原 on 16-6-13.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassWordViewController.h"
#import "EMSDK.h"
#import <YZBaseSDK/YZBaseSDK.h>

@interface LoginViewController ()<UITextFieldDelegate,ForgetPassWordViewControllerDelegate>
{
    CGFloat tfRectY;
}
@property (nonatomic,strong) GLTextField *phoneTF;  /**< 手机号码编辑框 */
@property (nonatomic,strong) GLTextField *passTF;   /**< 密码编辑框 */
@property (nonatomic,strong) GLButton *loginBtn;    /**< 登陆按钮 */
@property (nonatomic,strong) GLButton *regBtn;      /**< 注册按钮 */
@property (nonatomic,strong) UIScrollView *mainSV;  /**<  */

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
    
    [self initUI];

    //使用第三方客户端登陆
    if (_userLoginInfo) {
        NSNotification *notification = [[NSNotification alloc]initWithName:@"unionLogin" object:_userLoginInfo userInfo:nil];
        [self unionLogin:notification];
    }
    //初始化LoginView，设置LoginViewDelegate处理登录视图的事件
    
    //在视图代理方法里通过调用LoginHandler处理登录业务逻辑，发起网络请求和结果处理均在LoginHandler中完成
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navHide = YES;
}

//使用CGM客户端的账号
- (void)useCGMAccountLogin
{
    if([[UIApplication sharedApplication] canOpenURL:GL_URL(@"newCGMApp://SuiTangLogin")]){
        [[UIApplication sharedApplication] openURL:GL_URL(@"newCGMApp://SuiTangLogin")];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:false completion:^{
            }];
        });
    }
}

- (void)initNav {
//    [self initTemporaryNavWithTitle:@"欢迎加入糖教练" LeftButtonIV:nil RightButtonTtile:nil];
}

- (void)initUI
{
    _phoneTF                 = [GLTextField new];
    _passTF                  = [GLTextField new];
    _loginBtn                = [GLButton new];
    _regBtn                  = [GLButton new];
    UIImageView *logoIV      = [UIImageView new];/**< 糖教练Logo */
    UILabel *phoneLeftLbl     = [UILabel new];/**< 登陆框左侧文字 */
    UIView      *phoneLine   = [UIView new];/**< 手机号输入框下方横线 */
    UILabel *passLbl      = [UILabel new];/**< 密码框左侧图标 */
    UIView      *passLine    = [UIView new];/**< 密码输入框下方横线 */
    GLButton    *forgetBtn   = [GLButton new];/**< 忘记密码 */
    UIImageView *backGroudIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"背景图")];

    [self.view addSubview:backGroudIV];
    [self.view addSubview:_passTF];
    [self.view addSubview:_phoneTF];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:logoIV];
    [self.view addSubview:phoneLine];
    [self.view addSubview:passLine];
    [self.view addSubview:passLbl];
    [self.view addSubview:phoneLeftLbl];
    [self.view addSubview:forgetBtn];
    [self.view addSubview:_regBtn];
    
    self.view.backgroundColor   = RGB(255, 255, 255);
    
    [logoIV setImage:GL_IMAGE(@"登陆logo")];
    
    UILongPressGestureRecognizer *logoGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(logoIVClick:)];
    logoGest.minimumPressDuration = 2.0f;
    [logoIV addGestureRecognizer:logoGest];
    [logoIV setUserInteractionEnabled:true];
    
    _phoneTF.keyboardType        = UIKeyboardTypeNumberPad;
    _phoneTF.returnKeyType       = UIReturnKeyNext;
    _phoneTF.placeholder         = @"请输入手机号码";
    _phoneTF.delegate            = self;
    _phoneTF.placeholderColor    = RGB(255, 255, 255);
    _phoneTF.clearButtonMode     = UITextFieldViewModeWhileEditing;
    _phoneTF.text                = [GL_USERDEFAULTS getStringValue:@"PHONE"];
    _phoneTF.textLength          = 11;
    _phoneTF.textAlignment       = NSTextAlignmentLeft;
    _phoneTF.textColor           = RGB(255, 255, 255);

    _passTF.keyboardType         = UIKeyboardTypeASCIICapable;
    _passTF.secureTextEntry      = YES;
    _passTF.returnKeyType        = UIReturnKeyDone;
    _passTF.placeholder          = @"请输入密码";
    _passTF.delegate             = self;
    _passTF.placeholderColor     = RGB(255, 255, 255);
    _passTF.clearButtonMode      = UITextFieldViewModeWhileEditing;
    _passTF.textAlignment        = NSTextAlignmentLeft;
    _passTF.textColor            = RGB(255, 255, 255);

    phoneLine.backgroundColor    = RGB(255, 255, 255);
    passLine.backgroundColor     = RGB(255, 255, 255);

    phoneLeftLbl.text            = @"+86";
    phoneLeftLbl.font            = GL_FONT(16);
    phoneLeftLbl.textColor       = RGB(255, 255, 255);
    
    passLbl.text                 = @"密码";
    passLbl.font                 = GL_FONT(16);
    passLbl.textColor            = RGB(255, 255, 255);

    [_loginBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [_loginBtn setFont:GL_FONT(15)];
    [_loginBtn setGraphicLayoutState:TEXTCENTER];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setBackgroundColor:RGBA(255, 255, 255, 0.4f) forState:UIControlStateNormal];
    [_loginBtn setCornerRadius:5];
    
    [_regBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [_regBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [_regBtn setFont:GL_FONT(15)];
    [_regBtn addTarget:self action:@selector(regBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_regBtn setBackgroundColor:RGBA(255, 255, 255, 0.7f) forState:UIControlStateNormal];
    [_regBtn setCornerRadius:5];

    
    [forgetBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setFont:GL_FONT(12)];
    [forgetBtn setGraphicLayoutState:TEXTCENTER];
    
    WS(ws);
    
    [backGroudIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GL_IP6_H_RATIO(125));
        make.centerX.equalTo(ws.view);
    }];
    
    [phoneLeftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIV.mas_bottom).offset(GL_IP6_H_RATIO(98));
        make.left.equalTo(ws.view).offset(GL_IP6_W_RATIO(50));
        make.width.mas_equalTo(30);
    }];
    
    [passLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLeftLbl.mas_bottom).offset(GL_IP6_H_RATIO(28));
        make.left.equalTo(phoneLeftLbl);
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneLeftLbl);
        make.height.mas_equalTo(40);
        make.left.equalTo(phoneLeftLbl.mas_right).offset(GL_IP6_W_RATIO(28));
        make.right.equalTo(phoneLine.mas_right);
    }];
    
    [_passTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passLbl);
        make.left.equalTo(_phoneTF);
        make.right.equalTo(passLine);
        make.height.mas_equalTo(40);
    }];
    
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_phoneTF.mas_bottom);
        make.centerX.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH - GL_IP6_W_RATIO(100));
        make.height.mas_equalTo(0.5);
    }];
    
    [passLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_passTF.mas_bottom);
        make.centerX.equalTo(ws.view);
        make.width.equalTo(phoneLine);
        make.height.mas_equalTo(0.5);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.top.equalTo(forgetBtn.mas_bottom).offset(GL_IP6_H_RATIO(46));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    
    [_regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.top.equalTo(_loginBtn.mas_bottom).offset(GL_IP6_H_RATIO(30));
        make.size.equalTo(ws.loginBtn);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(forgetBtn.lbl).offset(20);
        make.height.equalTo(forgetBtn.lbl).offset(8.5 * 2);
        make.top.equalTo(passLine.mas_bottom);
        make.right.equalTo(ws.view.mas_right).offset(GL_IP6_W_RATIO(-37));
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}

- (BOOL)checkUserNameAndPassWord
{
    if (!_phoneTF.text.length) {
        GL_ALERT_E(@"请输入手机号");
        return false;
    } else if (!_passTF.text.length) {
        GL_ALERT_E(@"请输入密码");
        return false;
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:true];

    if (textField == _passTF) {
        [self loginBtnClick:_loginBtn];
    } else if(textField == _phoneTF){
        [_passTF becomeFirstResponder];
    } else {
        
        if ([textField.text isEqualToString:@"2929"]) {
            BOOL isTestServer = [GL_USERDEFAULTS boolForKey:@"isTestServer"];
            [GL_USERDEFAULTS setBool:!isTestServer forKey:@"isTestServer"];
        }
    }
    
    return YES;
}

- (void)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:true];

    if([self checkUserNameAndPassWord]){
        [self loginReqsut];
    }
}

- (void)loginReqsut
{
    NSDictionary *postDic = @{
                              FUNCNAME : @"login",
                              INFIELD  : @{
                                      @"PHONE" : _phoneTF.text,
                                      @"PASSWORD" : [_passTF.text md5HexDigest],
                                      @"DEVICE"   : @"1",
                                      @"DEVICESTOKEN" : [GL_USERDEFAULTS getStringValue:@"devToken"]
                                      },
                              OUTFIELD : @[]
                              };
    
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            NSString *RETMSG = [[[response objectForKey:@"Result"] objectForKey:@"OutField"] objectForKey:@"RETMSG"];
            NSString *RETVAL = [[[response objectForKey:@"Result"] objectForKey:@"OutField"] objectForKey:@"RETVAL"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[response objectForKey:@"Result"]objectForKey:@"OutField"]];
            if ([RETVAL isEqualToString:@"S"]) {
                //保存用户数据
                //用户头像
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"RET_FACE"]       forKey:@"PIC"];
                //昵称 统一用UserName字段
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"USERNAME"]  forKey:@"NICKNAME"];
                //身高
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"HEIGHT"]    forKey:@"HEIGHT"];
                //体重
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"WEIGHT"]    forKey:@"WEIGHT"];
                //腰围
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"WAISTLINE"] forKey:@"WAISTLINE"];
                //已保存的BMI
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"BMI"]       forKey:@"BMI"];
                //出生年月
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"BIRTHDAY"]  forKey:@"AGE"];
                //用户名（昵称）
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"USERNAME"]  forKey:@"USERNAME"];
                //用户号
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"ACCOUNT"]   forKey:@"ACCOUNT"];
                //用户id
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"ID"]   forKey:@"USERID"];
                //性别
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"SEX"]       forKey:@"SEX"];
                //绑定的手机号
                [GL_USERDEFAULTS setObject:_phoneTF.text     forKey:@"PHONE"];
                //糖尿病类型
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"DIABETESTYPE"] forKey:@"DIABETESTYPE"];
                //心率
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"HEARTRATE"] forKey:@"HEARTRATE"];
                //高血压
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"HIGHESTHYPERTENSION"] forKey:@"HIGHESTHYPERTENSION"];
                //低血压
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"LOWESTHYPERTENSION"] forKey:@"LOWESTHYPERTENSION"];
                
                [GL_USERDEFAULTS setObject:[dic getStringValue:@"HUAN_USERNAME"] forKey:@"HUAN_USERNAME"];
                
                if (![[dic getStringValue:@"SEX"] length]) {
                    [dic setObject:@"" forKey:@"SEX"];
                }
                                
                [GL_USERDEFAULTS setValuesForKeysWithDictionary:dic];
                
                [GL_USERDEFAULTS setValue:_passTF.text forKey:@"PASSWORD"];
                
                [GL_USERDEFAULTS synchronize];
                
                //发送通知改头像
                [self sendChangeIcon];
                
                //环信登陆
                [self huanxinLogin:[dic getStringValue:@"HUAN_USERNAME"]];
                
                //有赞登陆
                [self yzLogin];
            } else {
                GL_ALERT_E(RETMSG);
            }
        } else {
            GL_ALERT_E([response getStringValue:@"Message"]);
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_AFFAil;
    }];
}

- (void)sendChangeIcon
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSNotification *notify = [NSNotification notificationWithName:@"changeUserInfo" object:nil];
    
    [center postNotification:notify];
}


/**
 登陆环信
 */
- (void)huanxinLogin:(NSString *)huanUserName
{
    EMError *error = [[EMClient sharedClient] loginWithUsername:huanUserName password:@"123456"];
    if (!error) {
        //设置环信自动登陆
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        NSLog(@"环信登录成功");
    }
}

/**
 登陆有赞
 */
- (void)yzLogin
{
    NSDictionary *postDic = @{
                              @"func" : @"yzLogin",
                              @"id" : [GL_USERDEFAULTS getStringValue:@"USERID"],
                              @"username" : [GL_USERDEFAULTS getStringValue:@"USERNAME"]
                              };
    [GL_Requst POST:API_YZ parameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"errCode"] == 0) {
            NSDictionary *dic = [[response getDictionaryValue:@"data"] getDictionaryValue:@"data"];
            //成功
            [YZSDK setToken:[dic getStringValue:@"access_token"] key:[dic getStringValue:@"cookie_key"] value:[dic getStringValue:@"cookie_value"]];
            [GLCache writeCacheDic:dic name:YZToken];
            [GL_USERDEFAULTS setBool:true forKey:@"YZLOGIN"];
            [GL_USERDEFAULTS setBool:false forKey:YZISSHOPINGHINT];
            //登陆成功回调
            [self dismissViewControllerAnimated:true completion:^{
                GL_ALERT_S(@" 登录成功  ");
                if (_loginFinishBlock) {
                    _loginFinishBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginFinish" object:nil];
            }];

        } else {
            //失败
            [GL_USERDEFAULTS setBool:false forKey:@"YZLOGIN"];
        }
    } failure:^(GLRequest *request, NSError *error) {
    }];
}

//注册
- (void)regBtnClick:(GLButton *)sender
{
    [self.view endEditing:true];
    
    ForgetPassWordViewController *forgetVC = [ForgetPassWordViewController new];
    forgetVC.delegate                      = self;
    forgetVC.type                          = Register;
    [self presentViewController:forgetVC animated:true completion:nil];
}

//忘记密码
- (void)forgetBtnClick:(GLButton *)sender
{
    [self.view endEditing:true];
    
    ForgetPassWordViewController *forgetVC = [ForgetPassWordViewController new];
    forgetVC.delegate                      = self;
    forgetVC.type                          = ForgetPassWord;
    [self presentViewController:forgetVC animated:true completion:nil];
}

- (void)registerUserPhone:(NSString *)phoneNum
{
    _phoneTF.text = phoneNum;
}

- (void)dismissClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)unionLogin:(NSNotification *)notification
{
    [SVProgressHUD showWithStatus:@"正在登陆"];
    _phoneTF.text = [notification.object getStringValue:@"phone"];
    _passTF.text  = [notification.object getStringValue:@"passWord"];
    [self loginReqsut];
}

- (void)cancelLogin:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:false completion:nil];
}


- (void)logoIVClick:(UIGestureRecognizer *)gesture
{
    UITextField *tf = [UITextField new];
    [gesture.view addSubview:tf];
    
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(gesture.view);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}

- (BOOL)isKeyboardListener
{
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rect = [textField convertRect:textField.bounds toView:GL_KEYWINDOW];
    tfRectY     = rect.origin.y + rect.size.height;
    return true;
}

- (void)keyboardWillShowHandler:(CGSize)keyBoardSize
{
    
    if (tfRectY  > SCREEN_HEIGHT - keyBoardSize.height) {
        WS(ws);
        CGFloat heightDiff = (SCREEN_HEIGHT  - keyBoardSize.height) - tfRectY;
        
        [UIView animateWithDuration:0.25f animations:^{
            ws.view.y = heightDiff;
        }];
    }
}

- (void)keyboardWillHideHandler:(CGSize)keyBoardSize
{
    WS(ws);
    [UIView animateWithDuration:0.25f animations:^{
        ws.view.y = 0;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unionLogin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelLogin" object:nil];
}

@end
