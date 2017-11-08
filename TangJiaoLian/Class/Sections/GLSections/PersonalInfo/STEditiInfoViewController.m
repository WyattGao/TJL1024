//
//  STEditiInfoViewController.m
//  Diabetes
//
//  Created by 高临原 on 16/3/4.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STEditiInfoViewController.h"

@interface STEditiInfoViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTV;

@property (nonatomic,copy) NSString *codeStr;

@end

@implementation STEditiInfoViewController

- (instancetype)initWithType:(EDITIVCSTYLE)style
{
    self = [super init];
    if (self) {
        _editiStyle = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNav];
}

- (void)initNav
{
    NSString *titleStr = @"";
    switch (_editiStyle) {
        case NikeName:     titleStr = @"昵称";     break;
        case BingDingPhone:titleStr = @"绑定手机号";break;
        default:break;
    }
    
    [self setNavTitle:titleStr];
    [self setLeftBtnImgNamed:nil];
}

- (void)createUI
{
    _mainTV = [[UITableView alloc]initWithFrame:self.view.frame];

    [self.view addSubview:_mainTV];
    
    _mainTV.delegate        = self;
    _mainTV.dataSource      = self;
    _mainTV.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _mainTV.backgroundColor = RGB(246, 246, 250);
    _mainTV.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    
    WS(ws);
    
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_editiStyle == BingDingPhone) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!indexPath.row) {
        UITextField *tf   = [UITextField new];
        UIView      *line = [UIView new];
        [cell.contentView addSubview:tf];
        [cell.contentView addSubview:line];
        
        tf.delegate     = self;
        tf.tag          = 10;
        
        line.backgroundColor = RGB(241, 241, 245);
        
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.size.equalTo(cell.contentView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
            make.centerX.equalTo(cell.contentView);
        }];
        
        switch (_editiStyle) {
            case NikeName:
                tf.placeholder  = @"请输入昵称";
                tf.text         = _tf1Str.length ? _tf1Str : @"";
                break;
            case BingDingPhone:
                tf.placeholder  = @"请输入您的手机号（限中国大陆地区）";
                tf.keyboardType = UIKeyboardTypePhonePad;
            {
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(15);
                    make.right.equalTo(cell.contentView.mas_right);
                    make.height.equalTo(@1);
                }];
            }
                break;
            default:
                break;
        }
        
        
        
    } else if(indexPath.row == 1 && _editiStyle == BingDingPhone){
        UIButton *getCodeBtn = [UIButton new];
        UITextField *codeTF  = [UITextField new];
        UIView      *lineView   = [UIView      new];
        
        [cell.contentView addSubview:getCodeBtn];
        [cell.contentView addSubview:codeTF];
        [cell.contentView addSubview:lineView];

        getCodeBtn.tag                = 100;
        getCodeBtn.backgroundColor    = TCOL_MAIN;
        getCodeBtn.titleLabel.font    = GL_FONT(16);
        getCodeBtn.layer.cornerRadius = 4;
        [getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [getCodeBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [getCodeBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        lineView.backgroundColor = RGB(241, 241, 245);
        
        codeTF.placeholder  = @"短信验证码";
        codeTF.font         = GL_FONT(15);
        codeTF.keyboardType = UIKeyboardTypePhonePad;
        codeTF.tag          = 11;
        
        [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-13);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(127, 32));
        }];
        
        [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(getCodeBtn.mas_left).offset(-5);
            make.height.equalTo(@(42));
            make.centerY.equalTo(cell.contentView);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView);
            make.height.equalTo(@1);
            make.bottom.equalTo(cell.contentView);
        }];

    } else if(indexPath.row == 2 && _editiStyle == BingDingPhone){
        UITextField *passWordTF = [UITextField new];
        [cell.contentView addSubview:passWordTF];
       
        
        passWordTF.keyboardType  = UIKeyboardTypeASCIICapable;
        passWordTF.placeholder   = @"请设置密码";
        passWordTF.font          = GL_FONT(15);
        passWordTF.tag           = 12;

       
        
        [passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView);
            make.centerY.equalTo(cell.contentView);
            make.height.equalTo(@42);
        }];

    }
    return cell;
}

- (void)getCodeClick:(UIButton *)sender
{
    if ([[(UITextField *)[self.view viewWithTag:10] text] length] != 11/*||!isTure*/){
        GL_ALERT_E(@"请输入正确的手机号码");
        return;
    }
    
    NSDictionary *postDic = @{
                              FUNCNAME : @"send_sms",
                              INFIELD  : @{
                                            @"PHONE" : [(UITextField *)[self.view viewWithTag:10] text],
                                           },
                              OUTFIELD : @[]
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            GL_ALERT_S(@"已将验证码发送到您的手机");
            
            UIButton *sender = (UIButton *)[self.view viewWithTag:100];
            UITextField *phoneTF = (UITextField *)[self.view viewWithTag:10];
            
            if (sender.userInteractionEnabled == YES) {
                sender.titleLabel.font = [UIFont systemFontOfSize:15];
                //倒计时时间
                __block int timeout=59;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
                dispatch_source_set_event_handler(_timer, ^{
                    //倒计时结束，关闭
                    if(timeout<=0){
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            sender.userInteractionEnabled = YES;
                            phoneTF.userInteractionEnabled = YES;
                            sender.titleLabel.font = [UIFont systemFontOfSize:15];
                            [sender setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
                        });
                    }else{
                        int seconds = timeout % 60;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [sender setTitle:[NSString stringWithFormat:@"%@秒后(重发)",strTime] forState:UIControlStateNormal];
                            
                            sender.userInteractionEnabled = NO;
                            phoneTF.userInteractionEnabled = NO;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"验证码发送失败");
    }];
}

- (void)navLeftBtnClick:(UIButton *)sender
{
    [super navLeftBtnClick:sender];
    if (_editiStyle == NikeName) {
//        [self rightBtnDown:nil];
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        if (_editiStyle == NikeName) {
        [self rightBtnDown:nil];
        }
    }
}

- (void)rightBtnDown:(UIButton *)btn
{
    if (_editiStyle == BingDingPhone) {
    UITextField *phoneTF = (UITextField *)[self.view viewWithTag:10];
    UITextField *codeTF  = (UITextField *)[self.view viewWithTag:11];
    UITextField *passTF  = (UITextField *)[self.view viewWithTag:12];
        if ([[(UITextField *)[self.view viewWithTag:10] text] length] != 11/*||!isTure*/){
            GL_ALERT_E(@"请输入正确的手机号码");
            return;
        }
    if (!phoneTF.text.length){
        GL_ALERT_E(@"请输入正确的手机号码");
        return;
    }
    if (!codeTF.text.length) {
        GL_ALERT_E(@"请输入验证码");
        return;
    }
    if (!passTF.text.length) {
        GL_ALERT_E(@"请输入密码");
        return;
    }
        if (passTF.text.length<6) {
            GL_ALERT_E(@"密码长度小于6位数");
            return;
        }
    NSDictionary *postDic = @{
                              FUNCNAME : @"checkVerifyCode",
                              INFIELD  : @{
                                            @"PHONE" : phoneTF.text,
                                            @"VERIFYCODE" : codeTF.text
                                        },
                              OUTFIELD : @[]
                              };
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if ([response[@"Tag"]isEqualToString:@"0"]) {
                GL_ALERT_E(response[@"Message"]);
                return;
            }
            if ([[[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETVAL"] isEqualToString:@"S"]) {
                [self binDingPhone];
            } else {
                GL_ALERT_E([[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETMSG"]);
            }

        } failure:^(GLRequest *request, NSError *error) {
            GL_AFFAil;
        }];
    } else {
        [self.delegate getEditiContent:[(UITextField *)[self.view viewWithTag:10] text]];
    }
}

- (void)binDingPhone
{
    NSDictionary *postDic = @{
                              FUNCNAME : @"oauthloginbindphone",
                              INFIELD  : @{
                                      @"ACCOUNT"  :USER_ACCOUNT,
                                      @"PHONE"    :[(UITextField *)[self.view viewWithTag:10] text],
                                      @"PASSWORD" :[(UITextField *)[self.view viewWithTag:12] text],
                                      @"DEVICE"   : @"1"
                                      },
                              OUTFIELD : @[]
                              };
    
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            [self.delegate getEditiContent:[(UITextField *)[self.view viewWithTag:10] text]];
            GL_ALERT_S(@"您已成功绑定手机号");
            [[NSUserDefaults standardUserDefaults] setObject:[(UITextField *)[self.view viewWithTag:10] text] forKey:@"USER_PHONE"];
            [GL_USERDEFAULTS setObject:[(UITextField *)[self.view viewWithTag:10] text] forKey:@"PHONE"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            GL_ALERT_E([[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETMSG"]);
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"手机绑定失败");
    }];
}

@end
