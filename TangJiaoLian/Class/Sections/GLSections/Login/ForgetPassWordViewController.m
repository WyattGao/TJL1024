//
//  ForgetPassWord.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/26.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "ForgetPassWordViewController.h"

@interface ForgetPassWordViewController ()<GLTextFieldDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTV;

@property (nonatomic,strong) GLButton *changePassWordBtn;

@property (nonatomic,strong) GLButton *chooseBtn;

@property (nonatomic,assign) NSInteger finishCount;       /**< 统计填写完成度 */

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
    
    [self initUI];
}

- (void)initNav
{
    if (_type == ForgetPassWord) {
        //忘记密码
        [self initTemporaryNavWithTitle:@"忘记密码" LeftButtonIV:@"返回" RightButtonTtile:nil];
    } else {
        //快速注册
        [self initTemporaryNavWithTitle:@"注册" LeftButtonIV:@"返回" RightButtonTtile:nil];
    }
    
}

- (void)initUI
{
    _mainTV                 = [UITableView new];
    
    [self.view addSubview:_mainTV];
    [self getFootView];
    
    _mainTV.delegate        = self;
    _mainTV.dataSource      = self;
    _mainTV.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    WS(ws);
    
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64));
    }];
}

- (UIView *)getFootView
{
    UIView *footView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 96.5 + 40)];
    _mainTV.tableFooterView = footView;
    _changePassWordBtn      = [GLButton new];
    [footView addSubview:_changePassWordBtn];
    
    _changePassWordBtn.graphicLayoutState = TEXTCENTER;
    [_changePassWordBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [_changePassWordBtn setSelBackGroundColor:TCOL_MAIN];
    [_changePassWordBtn setNomBackGroundColor:RGB(212, 212, 213)];
    [_changePassWordBtn setCornerRadius:5];
    [_changePassWordBtn addTarget:self action:@selector(checkVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [_changePassWordBtn setUserInteractionEnabled:false];
    
    WS(ws);
    
    [_changePassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 40));
        make.centerX.equalTo(ws.view);
        make.bottom.equalTo(footView);
    }];
    
    if (_type == ForgetPassWord) {
        [_changePassWordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    } else {
        [_changePassWordBtn setTitle:@"注册" forState:UIControlStateNormal];
        _chooseBtn             = [GLButton new];
        UILabel  *lbl          = [UILabel new];
        UIButton *agreementBtn = [UIButton new];/**< 阅读协议 */
        
        [footView addSubview:_chooseBtn];
        [footView addSubview:lbl];
        [footView addSubview:agreementBtn];
        
        [_chooseBtn setGraphicLayoutState:PICCENTER];
        [_chooseBtn setImage:GL_IMAGE(@"复选框-未选中") forState:UIControlStateNormal];
        [_chooseBtn setImage:GL_IMAGE(@"复选框-选中") forState:UIControlStateSelected];
        [_chooseBtn addTarget:self action:@selector(termsOfServiceClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [lbl setText:@"我已阅读并同意"];
        [lbl setFont:GL_FONT(12)];
        [lbl setTextColor:RGB(0, 0, 0)];
        
        [agreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
        [agreementBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [agreementBtn.titleLabel setFont:GL_FONT(12)];
        [agreementBtn addTarget:self action:@selector(readUserAgreement:) forControlEvents:UIControlEventTouchUpInside];
        
        [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbl);
            make.left.equalTo(lbl.mas_right);
        }];
        
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(31, 31));
            make.top.equalTo(footView).offset(9.5);
            make.left.equalTo(footView).offset(5);
        }];
        
        [_chooseBtn.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.center.equalTo(_chooseBtn);
        }];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_chooseBtn.mas_right).offset(-5);
            make.centerY.equalTo(_chooseBtn);
        }];
    }
    
    return footView;
}

#pragma mark - TableViewDelegate,TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == Register) {
        return 4;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [@(indexPath.row) stringValue];
    ForgetPassWordCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell) {
        cell = [[ForgetPassWordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        cell.type                      = _type;
        cell.textField.glDelegate      = self;
        cell.textField.tag             = 800 + indexPath.row;
        if (indexPath.row == 1) {
            [cell.getCodeBtn addTarget:self action:@selector(chaekPhone) forControlEvents:UIControlEventTouchUpInside];
            cell.getCodeBtn.tag = 900;
        }
    }
    
    return cell;
}

#pragma mark - GLTextFieldDeleagete
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.tag == 803) {
        //        [self checkVerifyCode];
    }
    
    return YES;
}

- (void)textfieldFieldDidChange:(UITextField *)textField
{
    self.finishCount = _chooseBtn.selected;
    if (textField.tag == 800) {
        UIButton *getCodeBtn = [self.view viewWithTag:900];
        if (textField.text.length) {
            getCodeBtn.selected = true;
            getCodeBtn.userInteractionEnabled = YES;
        } else {
            getCodeBtn.selected = false;
            getCodeBtn.userInteractionEnabled = NO;
        }
    }
    for (NSInteger i = 0;i < 4;i++) {
        GLTextField  *tf = [self.view viewWithTag:i + 800];
        if (tf.text.length) {
            self.finishCount ++;
        } else {
            self.finishCount --;
        }
    }
}


- (void)setFinishCount:(NSInteger)finishCount
{
    _finishCount = finishCount;
    
    //找回密码填写4项，注册填写5项
    NSInteger finishNum = _type == ForgetPassWord ? 4 : 5 ;
    if (_finishCount == finishNum) {
        _changePassWordBtn.selected = true;
        _changePassWordBtn.userInteractionEnabled = true;
    } else {
        _changePassWordBtn.selected = NO;
        _changePassWordBtn.userInteractionEnabled = false;
    }
}

#pragma mark - WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)checkVerifyCode
{
    UITextField *phoneTF        = [self.view viewWithTag:800];
    UITextField *codeTF         = [self.view viewWithTag:801];
    UITextField *passWord       = [self.view viewWithTag:802];
    UITextField *checkPassWord  = [self.view viewWithTag:803];
    
    if (_type == Register) {
        if (!_chooseBtn.selected) {
            GL_ALERT_E(@"须阅读并同意协议");
            return;
        }
    }
    
    if (!codeTF.text.length) {
        GL_ALERT_E(@"请填写验证码");
    } else if (![checkPassWord.text isEqualToString:passWord.text]) {
        GL_ALERT_E(@"两次输入密码不一致");
    } else if (checkPassWord.text.length < 6) {
        GL_ALERT_E(@"密码不得少于6位");
    } else {
        NSDictionary *postDic = @{
                                  FUNCNAME : @"checkVerifyCode",
                                  INFIELD  : @{
                                          @"PHONE"      : phoneTF.text,
                                          @"VERIFYCODE" : codeTF.text
                                          },
                                  OUTFIELD : @[]
                                  };
        
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if (GETTAG) {
                if (GETRETVAL) {
                    GL_ALERT_S(GETRETMSG);
                    [self changePassWord];
                } else {
                    GL_ALERT_E(GETRETMSG);
                }
            } else {
                GL_ALERT_E(GETMESSAGE);
            }

        } failure:^(GLRequest *request, NSError *error) {
            
        }];
    }
}

//提交修改密码/注册
- (void)changePassWord
{
    UITextField *phoneTF        = [self.view viewWithTag:800];
    UITextField *passWordTF     = [self.view viewWithTag:802];
    UITextField *codeTF         = [self.view viewWithTag:801];

    if (_type == ForgetPassWord) {
        //修改密码
        NSDictionary *postDic = @{
                                  FUNCNAME : @"editPwd",
                                  INFIELD  : @{
                                          @"ACCOUNT"     : @"",
                                          @"PHONE"       : phoneTF.text,
                                          @"PASSWORD"    : @"",	//旧密码 可以为空 传的话会校验旧密码是否正确
                                          @"NEWPASSWORD" : [passWordTF.text md5HexDigest],
                                          @"DEVICE"      : @"1"
                                          },
                                  OUTFIELD : @[]
                                  };
        
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if ([response getIntegerValue:@"Tag"]) {
                if (GETRETVAL) {
                    GL_ALERT_S(GETRETMSG);
                    if ([_delegate respondsToSelector:@selector(registerUserPhone:)]) {
                        [_delegate registerUserPhone:phoneTF.text];
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    GL_ALERT_E(GETRETMSG);
                }
            } else {
                GL_ALERT_E(GETRETMSG);
            }
        } failure:^(GLRequest *request, NSError *error) {
            GL_AFFAil;
        }];
    } else {
        //注册账号
        NSDictionary *userDic = @{
                                  @"PHONE":phoneTF.text,
                                  @"PASSWORD":[passWordTF.text md5HexDigest],
                                  @"TYPE":[NSNumber numberWithInt:1],
                                  @"INVITE_CODE": @"",	//邀请码
                                  @"INVITE_TYPE":@"",	//邀请类型：1医生邀请 2 好友邀请
                                  @"DEVICE":[NSNumber numberWithInt:1],
                                  @"CHECKCODE" : codeTF.text
                                  };
        NSDictionary *dict = @{
                               FUNCNAME:@"register",
                               OUTFIELD:@[
                                       @"RETVAL",
                                       @"RETMSG"
                                       ],
                               INTABLE:@{
                                       @"USER_BASE":@[userDic]
                                       },
                               OUTTABLE:@""
                               };
        [GL_Requst postWithParameters:dict SvpShow:true success:^(GLRequest *request, id response) {
            if ([response getIntegerValue:@"Tag"]) {
                if (GETRETVAL) {
                    GL_ALERT_S(GETRETMSG);
                    if ([_delegate respondsToSelector:@selector(registerUserPhone:)]) {
                        [_delegate registerUserPhone:phoneTF.text];
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    GL_ALERT_E(GETRETMSG);
                }
            } else {
                GL_ALERT_E([response getStringValue:@"Message"]);
            }
        } failure:^(GLRequest *request, NSError *error) {
            GL_ALERT_E(@"网络错误，请检查网络");
        }];
    }
}

#pragma mark - 点击事件
//获取验证码
- (void)getCodeClick:(GLButton *)sender
{
    UITextField *phoneTF = [self.view viewWithTag:800];
    if (!phoneTF.text.length) {
        GL_ALERT_E(@"请填写手机号");
    } else {
        UITextField *codeTF         = [self.view viewWithTag:801];
        [codeTF becomeFirstResponder];
        
        ForgetPassWordCell *cell = [_mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NSDictionary *postDic = @{
                                  FUNCNAME : @"send_sms",
                                  INFIELD  : @{
                                          @"PHONE" : cell.textField.text,
                                          },
                                  OUTFIELD : @[]
                                  };
        
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if ([response getIntegerValue:@"Tag"]) {
                if (GETRETVAL) {
                    GL_ALERT_S(GETRETMSG);
                    if (sender.userInteractionEnabled == YES) {
                        sender.titleLabel.font = [UIFont systemFontOfSize:14];
                        //倒计时时间
                        __block int timeout = 59;
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
                        dispatch_source_set_event_handler(_timer, ^{
                            //倒计时结束，关闭
                            if(timeout<=0){
                                dispatch_source_cancel(_timer);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    sender.userInteractionEnabled         = YES;
                                    cell.textField.userInteractionEnabled = YES;
                                    sender.titleLabel.font = [UIFont systemFontOfSize:15];
                                    [sender setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
                                });
                            }else{
                                int seconds = timeout % 60;
                                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [sender setTitle:[NSString stringWithFormat:@"%@秒后(重发)",strTime] forState:UIControlStateNormal];
                                    
                                    sender.userInteractionEnabled         = NO;
                                    cell.textField.userInteractionEnabled = NO;
                                });
                                timeout--;
                            }
                        });
                        dispatch_resume(_timer);
                    } else {
                        GL_ALERT_E(GETRETMSG);
                    }
                } else {
                    GL_ALERT_E(GETRETMSG);
                }
            } else {
                GL_ALERT_E([response getStringValue:@"Message"]);
            }
        } failure:^(GLRequest *request, NSError *error) {
            GL_ALERT_E(@"获取失败,请检查网络");
        }];
    }
}

- (void)chaekPhone
{
    UITextField *phoneTF = [self.view viewWithTag:800];
    if (!phoneTF.text.length) {
        GL_ALERT_E(@"请填写手机号");
    } else {
        if (_type == 0) {
            NSDictionary *postDic = @{
                                      FUNCNAME : @"checkPhone",
                                      INFIELD  : @{
                                              @"PHONE" : phoneTF.text,
                                              @"DEVICE" : @"1"
                                              }
                                      };
            
            [GL_Requst postWithParameters:postDic SvpShow:self.view success:^(GLRequest *request, id response) {
                if ([response getIntegerValue:@"Tag"]) {
                    if (GETRETVAL) {
                        [self getCodeClick:[self.view viewWithTag:900]];
                    } else {
                        GL_ALERT_E(GETRETMSG);
                    }
                } else {
                    GL_ALERT_E([response getStringValue:@"Message"]);
                }
            } failure:^(GLRequest *request, NSError *error) {
                
            }];
        } else {
            [self getCodeClick:[self.view viewWithTag:900]];
        }
    }
}

//同意协议选择框
- (void)termsOfServiceClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.finishCount --;
    } else {
        self.finishCount ++;
    }
}

//阅读协议
- (void)readUserAgreement:(UIButton *)sender
{
    GLViewController *vc = [GLViewController new];
    UIWebView *webView   = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSString *urlStr       = [HOST_URL stringByAppendingString:@"/xieyi"];
    
    [vc.view addSubview:webView];

    [vc initTemporaryNavWithTitle:@"用户协议" LeftButtonIV:@"返回" RightButtonTtile:nil];
    
    [webView loadRequest:[NSURLRequest requestWithURL:GL_URL(urlStr)]];
    
    [webView setDelegate:self];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - KeyBoardListener
- (BOOL)isKeyboardListener
{
    return YES;
}

- (void)keyboardWillShowHandler:(CGSize)keyBoardSize
{
    [UIView animateWithDuration:0.3f animations:^{
        if (_type == ForgetPassWord) {
            _changePassWordBtn.y = 5;
        } else {
            _changePassWordBtn.y = 37;
        }
    }];
}

- (void)keyboardWillHideHandler:(CGSize)keyBoardSize
{
    [UIView animateWithDuration:0.3f animations:^{
        _changePassWordBtn.y = 95.5;
    }];
}

@end
